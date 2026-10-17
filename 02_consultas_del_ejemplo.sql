-- =====================================================
-- TechTrack Pro - Las 10 consultas de la seccion 2.5
-- UPEM / Practica 1 (Parte 1)
-- Ejecutar DESPUES del archivo 01_creacion_y_datos.sql
-- IMPORTANTE: Consultas 1 a 3 MODIFICAN los datos.
-- Ejecuta una consulta a la vez, seleccionandola y usando
-- el boton del rayo en MySQL Workbench, para tomar evidencias.
-- =====================================================
USE TechTrackDB;

-- CONSULTAS BASICAS

-- 1. INSERT: insertar un nuevo equipo.
INSERT INTO Equipos (num_serie, modelo, tipo, estado, id_usuario)
VALUES ('SN-554433', 'Apple MacBook Pro 14', 'Laptop', 'Asignado', 3);

-- 2. UPDATE: actualizar departamento del usuario 2.
UPDATE Usuarios
SET departamento = 'Sistemas'
WHERE id_usuario = 2;

-- 3. DELETE: eliminar un mantenimiento antiguo (id=1).
DELETE FROM Mantenimientos
WHERE id_mantenimiento = 1;

-- 4. SELECT: listado general de equipos.
SELECT * FROM Equipos;

-- CONSULTAS AVANZADAS

-- 5. Filtrar equipos de tipo Laptop.
SELECT num_serie, modelo, estado
FROM Equipos
WHERE tipo = 'Laptop';

-- 6. Ordenar usuarios por departamento y nombre.
SELECT nombre, departamento, email
FROM Usuarios
ORDER BY departamento ASC, nombre ASC;

-- 7. INNER JOIN: equipos con usuario asignado.
SELECT e.num_serie, e.modelo, e.tipo, u.nombre AS asignado_a
FROM Equipos e
INNER JOIN Usuarios u ON e.id_usuario = u.id_usuario;

-- 8. Mantenimientos con costo mayor a 100.
SELECT m.fecha, e.modelo, m.descripcion, m.costo, m.tipo_mant
FROM Mantenimientos m
JOIN Equipos e ON m.id_equipo = e.id_equipo
WHERE m.costo > 100;

-- 9. Contar equipos por departamento.
SELECT u.departamento, COUNT(e.id_equipo) AS total_equipos
FROM Usuarios u
LEFT JOIN Equipos e ON u.id_usuario = e.id_usuario
GROUP BY u.departamento;

-- 10. Equipos sin mantenimiento.
SELECT e.num_serie, e.modelo, e.tipo
FROM Equipos e
LEFT JOIN Mantenimientos m ON e.id_equipo = m.id_equipo
WHERE m.id_mantenimiento IS NULL;
