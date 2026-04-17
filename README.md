# 📊 Lemonu - Dashboard Estratégico de Rentabilidad

Este proyecto presenta una solución de **Business Intelligence** de extremo a extremo para el emprendimiento **Lemonu** (Cosmética y Perfumería). El objetivo es transformar datos transaccionales en información accionable para la toma de decisiones financieras.

## 🚀 Vista General del Proyecto
Se desarrolló un flujo de trabajo que integra una base de datos relacional con un panel de visualización interactivo, permitiendo monitorear las ganancias netas en tiempo real y el rendimiento por categoría de producto.

<img width="1137" height="615" alt="image" src="https://github.com/user-attachments/assets/7b7233e3-6d16-476a-a310-b2a9143ec7c1" />

## 🛠️ Stack Tecnológico
* **Base de Datos:** MySQL (Modelado relacional y creación de vistas analíticas).
* **Visualización:** Power BI Desktop (Conexión vía MySQL Connector).

## 🏗️ Arquitectura de Datos: Esquema Copo de Nieve (Snowflake Schema)
Para este proyecto, se implementó una arquitectura de base de datos robusta siguiendo las mejores prácticas de Data Warehousing:

* **Tabla de Hechos (Fact Table):** `fact_ventas`, que contiene las métricas transaccionales clave.
* **Tablas de Dimensiones:** `dim_productos`, `dim_clientes` y `dim_categorias`.
* **Relaciones:** Se aplicó una normalización que define este modelo como un **Esquema Copo de Nieve**, optimizando el almacenamiento y la integridad de los datos de categorías y productos.

## 📈 Funcionalidades Clave
* **Control de Rentabilidad:** Seguimiento exacto de la ganancia neta en USD.
* **Análisis por Rubro:** Comparativa visual entre Perfumería, Fragancias y Cuidado de la piel.
* **Segmentación Geográfica:** Filtros dinámicos para analizar ventas por ciudad (Buenos Aires, Córdoba, etc.).
* **Ranking de Productos:** Identificación de los artículos con mayor margen de beneficio.

## 📂 Contenido del Repositorio
* `script_db_lemonu.sql`: Contiene la creación de tablas, inserción de datos y la lógica de la vista analítica.
* `Lemonu_Analytics_Dashboard.pbix`: Archivo fuente de Power BI para explorar el reporte.

---
**Desarrollado por un apasionado por la Ciencia de Datos y la Tecnología.**
