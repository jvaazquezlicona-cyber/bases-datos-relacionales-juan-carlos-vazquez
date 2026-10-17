-- LabTrack Pro - Datos de prueba y operaciones DML
-- Ejecutar una sola vez DESPUES de 01_estructura.sql.
USE LabTrackDB;

-- D1. Insertar 6 equipos (minimo solicitado: 4).
-- Equipo 2 empieza en mantenimiento; luego se libera con UPDATE.
INSERT INTO Equipos_Lab
(num_inventario, tipo, marca, modelo, ubicacion, estado) VALUES
('LAB-001','PC','HP','ProDesk 400','Lab A','Prestado'),
('LAB-002','Monitor','Dell','P2422H','Lab A','En Mantenimiento'),
('LAB-003','Proyector','Epson','PowerLite E20','Auditorio','Prestado'),
('LAB-004','Switch','TP-Link','TL-SG1024','Lab A','Disponible'),
('LAB-005','PC','Lenovo','ThinkCentre M70q','Lab B','En Mantenimiento'),
('LAB-006','Monitor','Samsung','T350','Lab A','Disponible');

-- D2. Insertar 4 alumnos.
INSERT INTO Alumnos (nombre, matricula, carrera) VALUES
('Mariana Rios','LAB-2026-001','Ingenieria en Sistemas'),
('Luis Hernandez','LAB-2026-002','Ingenieria Industrial'),
('Sofia Perez','LAB-2026-003','Ingenieria en Sistemas'),
('Daniel Gomez','LAB-2026-004','Ingenieria en Sistemas');

-- D3. Insertar 8 prestamos: NULL significa que aun esta prestado.
INSERT INTO Prestamos
(fecha_prestamo, fecha_devolucion, id_equipo, id_alumno) VALUES
('2026-10-01 09:00:00','2026-10-01 13:00:00',2,1),
('2026-10-05 10:00:00','2026-10-05 12:00:00',1,1),
('2026-10-14 08:30:00',NULL,1,1),
('2026-10-15 11:00:00',NULL,3,2),
('2026-09-29 13:00:00','2026-09-29 17:00:00',5,2),
('2026-09-25 09:15:00','2026-09-25 11:15:00',2,3),
('2026-10-10 10:00:00','2026-10-10 12:30:00',5,4),
('2026-09-15 08:00:00','2026-09-15 10:00:00',2,1);

-- D4. Insertar 6 mantenimientos (el ultimo es prueba temporal).
INSERT INTO Mantenimientos
(fecha, descripcion, costo, tipo_mant, id_equipo) VALUES
('2026-10-02','Limpieza y calibracion de monitor',150.00,'Preventivo',2),
('2026-10-12','Cambio de unidad de almacenamiento',980.00,'Correctivo',5),
('2026-09-20','Actualizacion de memoria RAM',300.00,'Correctivo',1),
('2026-10-10','Limpieza de filtro del proyector',200.00,'Preventivo',3),
('2026-10-15','Reparacion de puerto USB',400.00,'Correctivo',5),
('2026-10-16','REGISTRO TEMPORAL PARA ELIMINAR',0.00,'Preventivo',4);

-- D5. UPDATE de una sola fila: equipo 2 ya esta disponible.
UPDATE Equipos_Lab
SET estado = 'Disponible'
WHERE id_equipo = 2;

-- D6. UPDATE de varias filas: mejorar nombre de ubicacion.
UPDATE Equipos_Lab
SET ubicacion = 'Laboratorio de Computo A'
WHERE id_equipo IN (1,2,4,6) AND ubicacion = 'Lab A';

-- D7. DELETE seguro: quitar solo registro temporal de prueba.
-- No afecta equipos ni historiales reales (id_mantenimiento=6).
DELETE FROM Mantenimientos
WHERE id_mantenimiento = 6;

-- D8. SELECT simple con WHERE.
SELECT id_equipo, num_inventario, modelo, estado
FROM Equipos_Lab
WHERE estado = 'Disponible';

-- D9. SELECT simple con ORDER BY.
SELECT nombre, matricula, carrera
FROM Alumnos
ORDER BY nombre ASC;
