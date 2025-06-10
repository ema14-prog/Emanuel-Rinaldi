CREATE DATABASE kiosko;
USE kiosko;

CREATE TABLE productos (
	id_producto INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    marca VARCHAR(30) NOT NULL,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE empleados (
	id_empleado INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(40) NOT NULL,
    email VARCHAR (100) UNIQUE DEFAULT NULL,
    dni INT UNIQUE NOT NULL,
    telefono VARCHAR (20) UNIQUE DEFAULT NULL,
    nacionalidad VARCHAR (30) DEFAULT "Argentina"
);

INSERT INTO empleados(nombre, apellido, email, dni, telefono)
VALUES 
("Emanuel", "Rinaldi" , "emamatias1412@gmail.com" , 35347716, "1122545566"),
("brenda", "falcon", "falcon@mail.com", 113333666, "1166667777"),
("lionel", "Messi", "messi@mail.com", 33555888, "1187556611");

SELECT * FROM empleados;

CREATE TABLE distribuidores (
	id_distribuidor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE compras(
	id_producto INT,
    id_distribuidor INT,
    compra_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_producto, id_distribuidor),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_distribuidor) REFERENCES distribuidores(id_distribuidor)
);

INSERT INTO distribuidores (nombre) VALUES 
	("Mogul"),
    ("Jorgito"),
	("Buballo"),
	("Billiken");
    
    -- --------------------------------------------------------------
    /* SEGUNDA ENTREGA DESDE ACA */
    

ALTER TABLE empleados ADD COLUMN fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP;    
ALTER TABLE distribuidores ADD COLUMN fecha_inscripcion DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE compras ADD COLUMN unidades INT;

INSERT INTO empleados(nombre, apellido, email, dni, telefono)
VALUES 
("Marcelo", "Rinaldi" , "marcelo@gmail.com" , 355888987, "454578787878");

INSERT INTO productos (marca,nombre)
VALUES
	("Jorgito", "alfajor"),
    ("Buballo" , "chicles"),
    ("Billiken", "Chupetines"),
    ("Mogul", "Banditas elasticas");
    
INSERT INTO compras(id_producto,id_distribuidor,unidades)
VALUES
	(2,3,50),
    (3,4,200),
    (4,1,400);
    
    
CREATE TABLE obra_sociales (
	id_obra_social INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(30) NOT NULL
);

ALTER TABLE empleados ADD COLUMN id_obra_social INT;
ALTER TABLE empleados ADD FOREIGN KEY (id_obra_social)  REFERENCES obra_sociales(id_obra_social);

INSERT INTO obra_sociales(nombre)
VALUES
	("SWISS MEDICAL"),
	("GALENO"),
    ("OSECAC"),
    ("VITTAS");

ALTER TABLE productos
  ADD COLUMN precio_actual DECIMAL(10,2) NOT NULL DEFAULT 0,
  ADD COLUMN stock        INT UNSIGNED NOT NULL DEFAULT 0,
  ADD CONSTRAINT chk_precio_pos CHECK (precio_actual >= 0),
  ADD CONSTRAINT chk_stock_pos  CHECK (stock >= 0);
ALTER TABLE productos ADD COLUMN descripcion VARCHAR(200) DEFAULT NULL;


ALTER TABLE compras
  ADD COLUMN precio_unitario DECIMAL(10,2) NOT NULL DEFAULT 0,
  ADD CONSTRAINT chk_precio_compra CHECK (precio_unitario >= 0);

ALTER TABLE empleados
  ADD COLUMN rol ENUM('cajero','repositor','dueño','otro') DEFAULT 'cajero';

CREATE TABLE ventas (
  id_venta INT PRIMARY KEY AUTO_INCREMENT,
  id_empleado INT NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE detalle_venta (
  id_venta INT,
  id_producto INT,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_venta, id_producto),
  FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);


INSERT INTO productos (marca, nombre, precio_actual, stock, descripcion)
VALUES 
  ('Jorgito', 'Alfajor', 150.00, 100, 'Alfajor de chocolate relleno de dulce de leche'),
  ('Billiken', 'Chupetín', 80.00, 200, 'Chupetines frutales variados'),
  ('Coca-Cola', 'Coca 500ml', 500.00, 50, 'Botella de medio litro'),
  ('Pepsi', 'Pepsi 1.5L', 700.00, 30, 'Gaseosa sabor cola'),
  ('Lays', 'Papas Clásicas', 600.00, 40, 'Papas fritas saladas');

INSERT INTO compras (id_producto, id_distribuidor, unidades, precio_unitario)
VALUES 
  (1, 1, 50, 120.00), 
  (2, 4, 100, 60.00);  
  
INSERT INTO ventas (id_empleado, total)
	VALUES 
	(1, 5),
    (2,7),
    (3,1),
    (4,15);

INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
VALUES
  (1, 7, 3, 150.00),
  (4, 9, 1, 500.00);

-- Creo funcion para calcular el total de una venta
DELIMITER //
CREATE FUNCTION calcular_total_venta(idVenta INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2);

  SELECT IFNULL(SUM(cantidad * precio_unitario), 0)
  INTO total
  FROM detalle_venta
  WHERE id_venta = idVenta;

  RETURN total;
END;
//

DELIMITER ;


SELECT calcular_total_venta(1); 


CREATE TABLE alertas_stock (
  id_alerta INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  mensaje VARCHAR(255),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
 
-- Creo trigger que me mande un mensaje de alerta cada vez que este bajo de stock un producto. 

DELIMITER //

CREATE TRIGGER trg_alerta_stock_bajo
AFTER UPDATE ON productos
FOR EACH ROW
BEGIN
  IF NEW.stock < 10 AND NEW.stock <> OLD.stock THEN
    INSERT INTO alertas_stock (id_producto, mensaje)
    VALUES (
      NEW.id_producto,
      CONCAT('¡Alerta! El producto "', NEW.nombre, '" tiene bajo stock: ', NEW.stock, ' unidades.')
    );
  END IF;
END;
//

DELIMITER ;


-- Una vista que muestra el stock que queda al realizar compras y ventas

CREATE VIEW v_stock_actual AS
SELECT p.id_producto,
       p.marca,
       p.nombre,
       IFNULL(ent.total_ent,0) - IFNULL(sal.total_sal,0) AS stock_actual
FROM productos p
LEFT JOIN (
  SELECT id_producto, SUM(unidades) AS total_ent
  FROM compras
  GROUP BY id_producto
) ent ON ent.id_producto = p.id_producto
LEFT JOIN (
  SELECT id_producto, SUM(cantidad) AS total_sal
  FROM detalle_venta
  GROUP BY id_producto
) sal ON sal.id_producto = p.id_producto;


DELIMITER //




-- Stored Procedure para realizar venta de 1 producto

CREATE PROCEDURE hacer_venta_simple (
  IN p_id_empleado INT,
  IN p_id_producto INT,
  IN p_cantidad INT,
  IN p_precio_unitario DECIMAL(10,2)
)
BEGIN
  DECLARE v_id_venta INT;

  -- Insertar venta
  INSERT INTO ventas (id_empleado, total)
  VALUES (p_id_empleado, 0);

  SET v_id_venta = LAST_INSERT_ID();

  -- Insertar detalle
  INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
  VALUES (v_id_venta, p_id_producto, p_cantidad, p_precio_unitario);

  -- Actualizar total
  UPDATE ventas
  SET total = calcular_total_venta(v_id_venta)
  WHERE id_venta = v_id_venta;

  -- Actualizar stock
  UPDATE productos
  SET stock = stock - p_cantidad
  WHERE id_producto = p_id_producto;
END;
//

DELIMITER ;


CALL hacer_venta_simple(1, 7, 8, 150.00);


-- -----------------------------------------------------

-- TERCERA ENTREGA

-- Control de stock negativo con trigger preventivo,evita que se venda más de lo disponible:

DELIMITER //
CREATE TRIGGER trg_prevenir_stock_negativo
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
  IF NEW.stock < 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede tener stock negativo';
  END IF;
END;
//
DELIMITER ;


-- Vista de ranking de productos más vendidos

CREATE VIEW v_productos_mas_vendidos AS
SELECT 
  p.id_producto,
  p.nombre,
  SUM(dv.cantidad) AS total_vendido
FROM detalle_venta dv
JOIN productos p ON p.id_producto = dv.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_vendido DESC;

SELECT * FROM v_productos_mas_vendidos;


-- Stored Procedure para venta compuesta (más de un producto)

-- tabla temporal para simular una venta con múltiples productos
CREATE TABLE temp_items_venta (
  id_producto INT,
  cantidad INT,
  precio_unitario DECIMAL(10,2)
);

DELIMITER //
CREATE PROCEDURE hacer_venta_compuesta(IN p_id_empleado INT)
BEGIN
  DECLARE v_id_venta INT;

  -- Crear la venta vacía
  INSERT INTO ventas (id_empleado, total)
  VALUES (p_id_empleado, 0);

  SET v_id_venta = LAST_INSERT_ID();

  -- Insertar todos los productos de la tabla temporal
  INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario)
  SELECT v_id_venta, id_producto, cantidad, precio_unitario
  FROM temp_items_venta;

  -- Actualizar el total
  UPDATE ventas
  SET total = calcular_total_venta(v_id_venta)
  WHERE id_venta = v_id_venta;

  -- Actualizar el stock de cada producto
  UPDATE productos p
  JOIN temp_items_venta t ON p.id_producto = t.id_producto
  SET p.stock = p.stock - t.cantidad;

  -- Limpiar la tabla temporal
  DELETE FROM temp_items_venta;
END;
//
DELIMITER ;

-- Historial de precios.Problema que soluciona: No se pierde el precio anterior de los productos cuando se actualiza. 
-- Sirve para análisis y para rendiciones.
-- Una tabla historial_precios que guarde cada vez que cambia el precio.

CREATE TABLE historial_precios (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  precio_anterior DECIMAL(10,2),
  precio_nuevo DECIMAL(10,2),
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

DELIMITER //
CREATE TRIGGER trg_registrar_cambio_precio
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
  IF NEW.precio_actual <> OLD.precio_actual THEN
    INSERT INTO historial_precios (id_producto, precio_anterior, precio_nuevo)
    VALUES (OLD.id_producto, OLD.precio_actual, NEW.precio_actual);
  END IF;
END;
//
DELIMITER ;

-- Gestión de stock por depósito o estantería

-- Problema que soluciona: Saber dónde está el producto (útil si se guarda mercadería atrás o en distintas heladeras/góndolas).

CREATE TABLE ubicaciones (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50)
);

CREATE TABLE stock_ubicacion (
  id_producto INT,
  id_ubicacion INT,
  cantidad INT,
  PRIMARY KEY (id_producto, id_ubicacion),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion)
);


-- Control de vencimiento de productos
-- Problema que soluciona: El kiosco pierde plata si se le vencen cosas (lácteos, jugos, alfajores, etc.).

-- Agrego: Una columna fecha_vencimiento y una vista de productos próximos a vencer:

ALTER TABLE productos ADD COLUMN fecha_vencimiento DATE DEFAULT NULL;

-- Vista de próximos a vencer en 15 días
CREATE VIEW v_productos_proximos_a_vencer AS
SELECT *
FROM productos
WHERE fecha_vencimiento IS NOT NULL
  AND fecha_vencimiento <= DATE_ADD(CURDATE(), INTERVAL 15 DAY);


