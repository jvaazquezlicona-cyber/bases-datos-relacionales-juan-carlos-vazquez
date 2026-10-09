-- UPEM | Bases de Datos Relacionales | Ejercicios DDL y DML
-- Juan Carlos Vazquez Licona | Matricula: 241090003 | Grupo: 7 A
-- Codigo recuperado del reporte final con evidencias de MySQL Workbench.
-- IMPORTANTE: ejecutar solo sobre una base de pruebas vacia.
-- Las inserciones de auditoria y carrera no estaban transcritas en el reporte;
-- se agregan datos ilustrativos para que el script pueda ejecutarse completo.

-- PREPARACION
CREATE DATABASE IF NOT EXISTS practica_ddl_dml;
USE practica_ddl_dml;
SHOW DATABASES;

-- EJERCICIO 1: DDL
CREATE TABLE Profesor (
 id_profesor INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(80) NOT NULL,
 apellido VARCHAR(80) NOT NULL,
 correo VARCHAR(120) UNIQUE
);
CREATE TABLE Materia (
 id_materia INT AUTO_INCREMENT PRIMARY KEY,
 clave VARCHAR(10) UNIQUE NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 departamento VARCHAR(80) NOT NULL,
 carga_horaria INT NOT NULL,
 CONSTRAINT chk_carga CHECK (carga_horaria > 0)
);
CREATE TABLE Asignacion (
 id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
 id_profesor INT NOT NULL,
 id_materia INT NOT NULL,
 grupo VARCHAR(10) NOT NULL,
 CONSTRAINT fk_profesor FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor),
 CONSTRAINT fk_materia FOREIGN KEY (id_materia) REFERENCES Materia(id_materia),
 CONSTRAINT uq_asignacion UNIQUE (id_profesor, id_materia, grupo)
);
SHOW TABLES;

-- EJERCICIO 2: DML Y CONSULTAS
INSERT INTO Profesor(nombre,apellido,correo) VALUES
('Juan','Ramirez','juan@upem.mx'),('Ana','Lopez','ana@upem.mx'),
('Carlos','Hernandez','carlos@upem.mx'),('Maria','Garcia','maria@upem.mx'),
('Pedro','Martinez','pedro@upem.mx');
INSERT INTO Materia(clave,nombre,departamento,carga_horaria) VALUES
('BD101','Bases de Datos','Sistemas',6),('PR102','Programacion','Sistemas',8),
('RD103','Redes','Sistemas',6),('MT104','Matematicas','Ciencias Basicas',5),
('FI105','Fisica','Ciencias Basicas',5),('IS106','Ingenieria de Software','Sistemas',7);
INSERT INTO Asignacion(id_profesor,id_materia,grupo) VALUES
(1,1,'ISC701'),(1,2,'ISC702'),(2,3,'ISC701'),(2,6,'ISC702'),
(3,1,'ISC703'),(3,4,'ISC701'),(4,5,'ISC702'),(4,4,'ISC703'),
(5,2,'ISC701'),(5,6,'ISC703');
SELECT p.nombre,p.apellido,m.clave AS materia,a.grupo
FROM Asignacion a JOIN Profesor p ON a.id_profesor=p.id_profesor
JOIN Materia m ON a.id_materia=m.id_materia ORDER BY p.apellido;

-- EJERCICIO 3: AUDITORIA Y TRANSACCION
CREATE TABLE Auditoria_Carga (
 id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
 id_materia INT NOT NULL,
 carga_anterior INT NOT NULL,
 carga_nueva INT NOT NULL,
 fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY(id_materia) REFERENCES Materia(id_materia)
);

-- El reporte documenta cuatro cambios (6->8, 8->10, 6->8, 7->9).
-- Para reproducirlos de forma atomica, se inserta auditoria y actualiza en una transaccion.
START TRANSACTION;
INSERT INTO Auditoria_Carga (id_materia,carga_anterior,carga_nueva)
SELECT id_materia,carga_horaria,carga_horaria+2 FROM Materia
WHERE id_materia IN (1,2,3,6) AND departamento='Sistemas';
UPDATE Materia SET carga_horaria = carga_horaria + 2
WHERE id_materia IN (1,2,3,6) AND departamento='Sistemas';
COMMIT;
SELECT * FROM Auditoria_Carga;
SELECT id_materia,nombre,carga_horaria FROM Materia WHERE id_materia IN (1,2,3,6);


-- EJERCICIO 4: ESTADISTICAS POR CARRERA
CREATE TABLE Carrera(id_carrera INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE Estudiante(id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(80) NOT NULL, apellido VARCHAR(80) NOT NULL,
 id_carrera INT NOT NULL,
 FOREIGN KEY(id_carrera) REFERENCES Carrera(id_carrera));
CREATE TABLE Calificacion(id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
 id_estudiante INT NOT NULL, calificacion DECIMAL(4,2) NOT NULL,
 CHECK(calificacion BETWEEN 0 AND 10),
 FOREIGN KEY(id_estudiante) REFERENCES Estudiante(id_estudiante));

-- Datos de ejemplo reconstruidos (el reporte confirma 3 carreras, 9 estudiantes y 18 calificaciones).
INSERT INTO Carrera (nombre) VALUES
('Administracion de Empresas'),('Ingenieria en Sistemas Computacionales'),('Ingenieria Industrial');
INSERT INTO Estudiante (nombre,apellido,id_carrera) VALUES
('Ana','Santos',1),('Luis','Cruz',1),('Elena','Morales',1),
('Carlos','Vega',2),('Lucia','Rios',2),('Diego','Ruiz',2),
('Sofia','Lopez',3),('Miguel','Ortiz',3),('Paola','Reyes',3);
INSERT INTO Calificacion (id_estudiante,calificacion) VALUES
(1,9.50),(1,9.00),(2,8.50),(2,9.00),(3,8.50),(3,9.00),
(4,9.00),(4,8.50),(5,8.50),(5,9.00),(6,8.00),(6,8.50),
(7,9.00),(7,9.00),(8,8.00),(8,8.00),(9,7.50),(9,8.00);

SELECT c.nombre AS carrera,
 COUNT(e.id_estudiante) AS total_estudiantes,
 ROUND(AVG(e.promedio),2) AS promedio_general,
 ROUND(100.0*SUM(CASE WHEN e.promedio >= 8.5 THEN 1 ELSE 0 END)
 / NULLIF(COUNT(e.id_estudiante),0),2) AS porcentaje_destacados
FROM Carrera c
LEFT JOIN (
 SELECT es.id_estudiante,es.id_carrera,AVG(cal.calificacion) AS promedio
 FROM Estudiante es JOIN Calificacion cal
 ON es.id_estudiante=cal.id_estudiante
 GROUP BY es.id_estudiante,es.id_carrera
) e ON c.id_carrera=e.id_carrera
GROUP BY c.id_carrera,c.nombre ORDER BY promedio_general DESC;


-- EJERCICIO 5: ARQUITECTURA ANSI/SPARC (teorico)
-- Nivel externo: vistas para profesores y administracion.
-- Nivel conceptual: tablas, relaciones y restricciones.
-- Nivel interno: archivos InnoDB, indices y almacenamiento.
-- Independencia fisica: cambiar disco o indices sin cambiar consultas.
-- Independencia logica: agregar una columna opcional manteniendo las interfaces.
