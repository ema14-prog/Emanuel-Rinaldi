# 🧃 Proyecto Final SQL – Kiosko

Este proyecto consiste en el diseño e implementación de una base de datos relacional para la gestión de un kiosco. Permite controlar productos, empleados, ventas, compras, stock y alertas automáticas de forma eficiente y segura.

## 📁 Contenido

- [🎯 Objetivo](#-objetivo)
- [📦 Modelo de negocio](#-modelo-de-negocio)
- [🛠️ Tecnologías utilizadas](#-tecnologías-utilizadas)
- [🗂️ Estructura de la base de datos](#-estructura-de-la-base-de-datos)
- [📊 Informes y consultas](#-informes-y-consultas)
- [🔧 Uso de funciones, procedimientos y vistas](#-uso-de-funciones-procedimientos-y-vistas)
- [⬇️ Cómo importar la base de datos](#️-cómo-importar-la-base-de-datos)
- [⬆️ Cómo exportar la base de datos](#️-cómo-exportar-la-base-de-datos)
- [👤 Autor](#-autor)

---

## 🎯 Objetivo

Desarrollar una base de datos funcional que permita:
- Registrar ventas y compras
- Controlar el stock en tiempo real
- Generar alertas por bajo stock
- Llevar un historial de precios
- Analizar productos más vendidos, stock crítico, etc.

---

## 📦 Modelo de negocio

El kiosco vende golosinas, bebidas y snacks. Realiza compras a proveedores, las almacena, vende productos al público y trabaja con un equipo de empleados que cumplen distintos roles (cajeros, repositores, dueño).

---

## 🛠️ Tecnologías utilizadas

- **MySQL 9.0.1** Community Server  
- **MySQL Workbench**  
- **GitHub** (repositorio del proyecto)  
- **Google Docs / PDF** para la documentación teórica  
- (Opcional) **dbdiagram.io** para el diagrama E-R

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

