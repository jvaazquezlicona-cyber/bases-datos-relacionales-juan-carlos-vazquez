-- LabTrack Pro - Seccion E: 6 retos DML
-- Ejecutar DESPUES de 01_estructura.sql y 02_datos_y_operaciones.sql.
USE LabTrackDB;

-- RETO 1: Equipos actualmente prestados, con alumno y matricula.
-- Se esperan 2 filas (LAB-001 y LAB-003).
SELECT e.num_inventario, e.modelo, a.nombre, a.matricula,
       p.fecha_prestamo
FROM Prestamos p
INNER JOIN Equipos_Lab e ON p.id_equipo = e.id_equipo
INNER JOIN Alumnos a ON p.id_alumno = a.id_alumno
WHERE p.fecha_devolucion IS NULL
ORDER BY e.num_inventario;

-- RETO 2: Equipos que nunca han sido prestados.
-- Se esperan LAB-004 y LAB-006.
SELECT e.num_inventario, e.tipo, e.marca, e.modelo
FROM Equipos_Lab e
LEFT JOIN Prestamos p ON e.id_equipo = p.id_equipo
WHERE p.id_prestamo IS NULL
ORDER BY e.num_inventario;

-- RETO 3: Cantidad de prestamos de cada alumno (incluso cero).
-- Se esperan conteos 4, 2, 1, 1 en el orden de matricula.
SELECT a.matricula, a.nombre, COUNT(p.id_prestamo) AS total_prestamos
FROM Alumnos a
LEFT JOIN Prestamos p ON a.id_alumno = p.id_alumno
GROUP BY a.id_alumno, a.matricula, a.nombre
ORDER BY a.matricula;

-- RETO 4: Costo total de mantenimientos por tipo de equipo.
-- PC=1680.00, Monitor=150.00, Proyector=200.00.
SELECT e.tipo, SUM(m.costo) AS costo_total
FROM Equipos_Lab e
INNER JOIN Mantenimientos m ON e.id_equipo = m.id_equipo
GROUP BY e.tipo
ORDER BY e.tipo;

-- RETO 5: Alumnos que han realizado mas de dos prestamos.
-- Se espera Mariana Rios, con 4 prestamos.
SELECT a.matricula, a.nombre, COUNT(p.id_prestamo) AS total_prestamos
FROM Alumnos a
INNER JOIN Prestamos p ON a.id_alumno = p.id_alumno
GROUP BY a.id_alumno, a.matricula, a.nombre
HAVING COUNT(p.id_prestamo) > 2;

-- RETO 6: Equipo con el mantenimiento individual mas costoso.
-- Se espera LAB-005, costo=980.00.
SELECT e.num_inventario, e.modelo, m.descripcion, m.fecha, m.costo
FROM Mantenimientos m
INNER JOIN Equipos_Lab e ON m.id_equipo = e.id_equipo
ORDER BY m.costo DESC, m.id_mantenimiento ASC
LIMIT 1;
