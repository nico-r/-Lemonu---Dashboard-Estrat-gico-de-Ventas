USE proyecto_analytics;

-- Aseguramos que estamos en la base correcta
USE proyecto_analytics;

-- 1. CARGA DE CATEGORÍAS (La punta del copo)
INSERT INTO dim_categorias (nombre_categoria) VALUES 
('Perfumería Árabe'), 
('Cuidado de la Piel'), 
('Fragancias de Diseñador'),
('Accesorios');

-- 2. CARGA DE PRODUCTOS (Relacionados a las categorías de arriba)
INSERT INTO dim_productos (producto_id, nombre_producto, costo_unitario, precio_venta, categoria_id) VALUES 
(1, 'Lattafa Asad EDP 100ml', 25.00, 48.50, 1),
(2, 'Effaclar Duo La Roche-Posay', 12.00, 22.00, 2),
(3, 'Club de Nuit Intense Man', 28.00, 55.00, 1),
(4, 'Versace Eros EDT 100ml', 55.00, 98.00, 3),
(5, 'Vichy Mineral 89 Booster', 18.00, 32.00, 2);

-- 3. CARGA DE CLIENTES
INSERT INTO dim_clientes (cliente_id, ciudad, tipo_cliente) VALUES 
(10, 'Buenos Aires', 'Minorista'),
(11, 'Córdoba', 'Mayorista'),
(12, 'Rosario', 'Minorista');

-- 4. CARGA DE VENTAS (Hechos)
INSERT INTO fact_ventas (fecha, producto_id, cliente_id, cantidad, monto_total_venta) VALUES 
('2026-04-01', 1, 10, 1, 48.50),
('2026-04-02', 2, 11, 5, 110.00),
('2026-04-02', 4, 10, 1, 98.00),
('2026-04-03', 3, 12, 2, 110.00),
('2026-04-04', 5, 11, 3, 96.00);

-- 1. Borramos las tablas viejas para resetear el modelo
DROP TABLE IF EXISTS fact_ventas;
DROP TABLE IF EXISTS dim_productos;
DROP TABLE IF EXISTS dim_categorias;
DROP TABLE IF EXISTS dim_clientes;

-- 2. Creamos la nueva jerarquía (Copo de Nieve)
CREATE TABLE dim_categorias (
    categoria_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50)
);

CREATE TABLE dim_productos (
    producto_id INT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    costo_unitario DECIMAL(10, 2),
    precio_venta DECIMAL(10, 2),
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES dim_categorias(categoria_id)
);

CREATE TABLE dim_clientes (
    cliente_id INT PRIMARY KEY,
    ciudad VARCHAR(50),
    tipo_cliente VARCHAR(20)
);

CREATE TABLE fact_ventas (
    venta_id INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    producto_id INT,
    cliente_id INT,
    cantidad INT,
    monto_total_venta DECIMAL(10, 2),
    FOREIGN KEY (producto_id) REFERENCES dim_productos(producto_id),
    FOREIGN KEY (cliente_id) REFERENCES dim_clientes(cliente_id)
);

-- 1. Insertar Categorías
INSERT INTO dim_categorias (nombre_categoria) VALUES 
('Perfumería Árabe'), 
('Cuidado de la Piel'), 
('Fragancias de Diseñador');

-- 2. Insertar Clientes
INSERT INTO dim_clientes (cliente_id, ciudad, tipo_cliente) VALUES 
(1, 'Buenos Aires', 'Minorista'),
(2, 'Córdoba', 'Mayorista');

-- 3. Insertar Productos
INSERT INTO dim_productos (producto_id, nombre_producto, costo_unitario, precio_venta, categoria_id) VALUES 
(10, 'Lattafa Asad 100ml', 25.00, 48.00, 1),
(11, 'Effaclar Duo LRP', 12.00, 25.00, 2),
(12, 'Versace Eros EDT', 55.00, 95.00, 3);

-- 4. Insertar Ventas
INSERT INTO fact_ventas (fecha, producto_id, cliente_id, cantidad, monto_total_venta) VALUES 
('2026-04-10', 10, 1, 1, 48.00),
('2026-04-11', 11, 2, 5, 125.00),
('2026-04-12', 12, 1, 1, 95.00);
-- REPORTE DE VENTAS CON MARGEN DE GANANCIA
SELECT 
    v.fecha,
    c.nombre_categoria,
    p.nombre_producto,
    v.cantidad,
    v.monto_total_venta AS ingreso,
    (v.monto_total_venta - (p.costo_unitario * v.cantidad)) AS ganancia_neta
FROM fact_ventas v
JOIN dim_productos p ON v.producto_id = p.producto_id
JOIN dim_categorias c ON p.categoria_id = c.categoria_id;

-- Creamos la vista para no repetir código
CREATE OR REPLACE VIEW vista_analisis_ventas AS
SELECT 
    v.fecha,
    c.nombre_categoria,
    p.nombre_producto,
    v.cantidad,
    v.monto_total_venta AS ingreso_total,
    (v.monto_total_venta - (p.costo_unitario * v.cantidad)) AS ganancia_neta,
    cl.ciudad AS ciudad_cliente
FROM fact_ventas v
JOIN dim_productos p ON v.producto_id = p.producto_id
JOIN dim_categorias c ON p.categoria_id = c.categoria_id
JOIN dim_clientes cl ON v.cliente_id = cl.cliente_id;

SELECT * FROM vista_analisis_ventas;


-- ¿En qué ciudad estamos siendo más rentables?
SELECT 
    ciudad_cliente, 
    SUM(monto_total_venta) AS total_vendido,
    SUM(monto_total_venta - (p.costo_unitario * v.cantidad)) AS ganancia_total
FROM fact_ventas v
JOIN dim_clientes cl ON v.cliente_id = cl.cliente_id
JOIN dim_productos p ON v.producto_id = p.producto_id
GROUP BY ciudad_cliente;

-- 1. CREAMOS LA VISTA (Reporte Automático)
CREATE OR REPLACE VIEW vista_reporte_negocios AS
SELECT 
    v.fecha,
    c.nombre_categoria AS rubro,
    p.nombre_producto AS articulo,
    v.cantidad,
    v.monto_total_venta AS ingreso,
    (v.monto_total_venta - (p.costo_unitario * v.cantidad)) AS ganancia_neta,
    cl.ciudad,
    cl.tipo_cliente
FROM fact_ventas v
JOIN dim_productos p ON v.producto_id = p.producto_id
JOIN dim_categorias c ON p.categoria_id = c.categoria_id
JOIN dim_clientes cl ON v.cliente_id = cl.cliente_id;

-- 2. CONSULTA DE RESULTADOS
SELECT * FROM vista_reporte_negocios;


-- 1. CREAMOS LA VISTA (Reporte Automático)
CREATE OR REPLACE VIEW vista_reporte_negocios AS
SELECT 
    v.fecha,
    c.nombre_categoria AS rubro,
    p.nombre_producto AS articulo,
    v.cantidad,
    v.monto_total_venta AS ingreso,
    (v.monto_total_venta - (p.costo_unitario * v.cantidad)) AS ganancia_neta,
    cl.ciudad,
    cl.tipo_cliente
FROM fact_ventas v
JOIN dim_productos p ON v.producto_id = p.producto_id
JOIN dim_categorias c ON p.categoria_id = c.categoria_id
JOIN dim_clientes cl ON v.cliente_id = cl.cliente_id;

-- 2. CONSULTA DE RESULTADOS
SELECT * FROM vista_reporte_negocios;


-- RANKING DE PRODUCTOS MÁS RENTABLES
SELECT 
    articulo, 
    SUM(cantidad) AS total_vendido, 
    SUM(ganancia_neta) AS ganancia_acumulada
FROM vista_reporte_negocios
GROUP BY articulo
ORDER BY ganancia_acumulada DESC;

-- RESUMEN EJECUTIVO DE NEGOCIO
SELECT 
    rubro,
    COUNT(articulo) AS variedad_productos,
    SUM(cantidad) AS unidades_totales,
    SUM(ingreso) AS facturacion_total,
    SUM(ganancia_neta) AS utilidad_limpia,
    ROUND((SUM(ganancia_neta) / SUM(ingreso)) * 100, 2) AS porcentaje_margen
FROM vista_reporte_negocios
GROUP BY rubro;