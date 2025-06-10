# 🧃 Proyecto Final SQL – Kiosko

Este proyecto consiste en el diseño e implementación de una base de datos relacional para la gestión de un kiosco. Permite controlar productos, empleados, ventas, compras, stock y alertas automáticas de forma eficiente y segura.

## 📁 Contenido

- [🎯 Objetivo](#-objetivo)
- [💡 Problemas que soluciona esta base de datos](#-problemas-que-soluciona-esta-base-de-datos)
- [📦 Modelo de negocio](#-modelo-de-negocio)
- [🛠️ Tecnologías utilizadas](#-tecnologías-utilizadas)
- [🗂️ Estructura de la base de datos](#-estructura-de-la-base-de-datos)
- [📊 Informes y consultas](#-informes-y-consultas)
- [🔧 Uso de funciones, procedimientos y vistas](#-uso-de-funciones-procedimientos-y-vistas)


---

## 🎯 Objetivo

Desarrollar una base de datos funcional que permita:
- Registrar ventas y compras
- Controlar el stock en tiempo real
- Generar alertas por bajo stock
- Llevar un historial de precios
- Analizar productos más vendidos, stock crítico, etc.

---

## 💡 Problemas que soluciona esta base de datos
Esta base de datos está diseñada para solucionar varios problemas comunes en la gestión diaria del kiosco, tales como:

Control efectivo del stock: Evita errores manuales y pérdidas de inventario mediante el control automático del stock en tiempo real, actualizando las cantidades con cada compra y venta.

Alertas automáticas: Genera alertas cuando el stock de algún producto es bajo, permitiendo tomar acciones antes de quedarse sin mercadería.

Historial de precios: Registra automáticamente los cambios de precio de los productos para evitar pérdidas por actualización incorrecta y facilitar análisis históricos y rendiciones.

Prevención de stock negativo: Gracias a triggers, se evita vender más unidades de las que hay disponibles, asegurando la integridad del inventario.

Gestión de ventas múltiples: Facilita la venta de uno o varios productos a la vez con procedimientos almacenados que manejan toda la lógica necesaria.

Organización del inventario por ubicación: Permite saber en qué depósito o estantería se encuentra cada producto para una gestión más ordenada y rápida.

Control de vencimientos: Incluye seguimiento de productos próximos a vencer, ayudando a reducir pérdidas por productos caducados.

Roles de empleados y seguridad: Diferencia las funciones de cada empleado (cajero, repositor, dueño) para un mejor control interno.

En resumen, esta base de datos ofrece una solución integral para optimizar la administración del kiosco, reducir errores humanos, mejorar la toma de decisiones y mantener un negocio más eficiente y rentable.

---

## 📦 Modelo de negocio

El kiosco vende golosinas, bebidas y snacks. Realiza compras a proveedores, las almacena, vende productos al público y trabaja con un equipo de empleados que cumplen distintos roles (cajeros, repositores, dueño).



---

## 🗂️ Estructura de la base de datos

- **Tablas principales**: `productos`, `empleados`, `compras`, `ventas`, `detalle_venta`, `distribuidores`, `obra_sociales`, `alertas_stock`
- **Relaciones** con claves foráneas correctamente definidas
- **Constraints**: validaciones de stock, precios positivos, etc.
- **ENUM y campos por defecto**: ejemplo, roles de empleados, nacionalidad, etc.

---

## 📊 Informes y consultas

Incluye vistas, funciones y procedimientos que permiten generar reportes automáticos y realizar acciones con lógica de negocio.

---

## 🔧 Uso de funciones, procedimientos y vistas

### 📌 Función `calcular_total_venta(idVenta)`
Calcula el total de una venta sumando cantidad × precio_unitario en `detalle_venta`.
**Ejemplo de uso:**
```sql
SELECT calcular_total_venta(1);

📌 Procedimiento hacer_venta_simple
Registra una nueva venta y actualiza automáticamente el stock.

Parámetros:

p_id_empleado INT

p_id_producto INT

p_cantidad INT

p_precio_unitario DECIMAL

Ejemplo:

CALL hacer_venta_simple(1, 7, 8, 150.00);

📌 Vista v_stock_actual
Muestra el stock real de productos calculado como:

total de unidades compradas - unidades vendidas

Consulta:
SELECT * FROM v_stock_actual;

📌 Trigger trg_alerta_stock_bajo
Se dispara automáticamente luego de actualizar productos con bajo stock (menor a 10 unidades)
 y agrega un mensaje en la tabla alertas_stock.

⬇️ Cómo importar la base de datos
Opción 1: desde MySQL Workbench
Abrí MySQL Workbench.

File > Open SQL Script > seleccioná kiosko.sql

Ejecutá el script completo (F5) con una base nueva.
mysql -u root -p < kiosko.sql


⬆️ Cómo exportar la base de datos
Desde la terminal:
mysqldump -u root -p kiosko > backup_kiosko.sql


Desde Workbench:

Database > Data Export > Seleccionar "kiosko" > Export to Self-Contained File

👤 Autor
Emanuel Rinaldi
Proyecto final – Curso de SQL Server – Coderhouse

¡Gracias por visitar el proyecto! 🚀

