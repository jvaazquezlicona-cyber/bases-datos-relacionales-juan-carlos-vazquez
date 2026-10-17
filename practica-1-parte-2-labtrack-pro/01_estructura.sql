-- UPEM | Bases de Datos Relacionales | Practica 1, Parte 2
-- LabTrack Pro - Creacion del esquema (DDL)
-- Alumno: Juan Carlos Vazquez Licona | Matricula: 241090003 | Grupo: 7 A
-- Ejecutar una sola vez antes del archivo 02.

CREATE DATABASE IF NOT EXISTS LabTrackDB
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE LabTrackDB;

-- Catalogo del inventario de laboratorio.
CREATE TABLE Equipos_Lab (
  id_equipo      INT AUTO_INCREMENT PRIMARY KEY,
  num_inventario VARCHAR(30) NOT NULL UNIQUE,
  tipo           ENUM('PC','Monitor','Proyector','Switch','Otro') NOT NULL,
  marca          VARCHAR(60) NOT NULL,
  modelo         VARCHAR(100) NOT NULL,
  ubicacion      VARCHAR(80) NOT NULL DEFAULT 'Lab A',
  estado         ENUM('Disponible','Prestado','En Mantenimiento','Baja')
                 NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB;

-- Alumnos autorizados para solicitar prestamos.
CREATE TABLE Alumnos (
  id_alumno INT AUTO_INCREMENT PRIMARY KEY,
  nombre    VARCHAR(100) NOT NULL,
  matricula VARCHAR(20) NOT NULL UNIQUE,
  carrera   VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Un equipo puede prestarse varias veces en fechas diferentes.
-- RESTRICT preserva el historial si se intenta borrar equipo o alumno.
CREATE TABLE Prestamos (
  id_prestamo      INT AUTO_INCREMENT PRIMARY KEY,
  fecha_prestamo   DATETIME NOT NULL,
  fecha_devolucion DATETIME NULL,
  id_equipo        INT NOT NULL,
  id_alumno        INT NOT NULL,
  CONSTRAINT fk_prestamo_equipo FOREIGN KEY (id_equipo)
    REFERENCES Equipos_Lab(id_equipo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_prestamo_alumno FOREIGN KEY (id_alumno)
    REFERENCES Alumnos(id_alumno)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_devolucion_fecha CHECK (
    fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo
  ),
  INDEX idx_prestamo_equipo_estado (id_equipo, fecha_devolucion)
) ENGINE=InnoDB;

-- Intervenciones tecnicas realizadas sobre el inventario.
CREATE TABLE Mantenimientos (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  fecha            DATE NOT NULL,
  descripcion      VARCHAR(255) NOT NULL,
  costo            DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tipo_mant        ENUM('Preventivo','Correctivo') NOT NULL,
  id_equipo        INT NOT NULL,
  CONSTRAINT fk_mantenimiento_equipo FOREIGN KEY (id_equipo)
    REFERENCES Equipos_Lab(id_equipo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_costo_no_negativo CHECK (costo >= 0)
) ENGINE=InnoDB;
