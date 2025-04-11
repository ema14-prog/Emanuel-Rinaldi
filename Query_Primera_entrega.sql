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
    
   





