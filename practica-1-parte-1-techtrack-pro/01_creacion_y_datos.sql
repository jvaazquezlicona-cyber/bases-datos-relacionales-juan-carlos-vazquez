-- =====================================================
-- TechTrack Pro - Script de Base de Datos
-- Base de Datos Relacionales - UPEM
-- Profesor: Ing. Roberto Carlos Hurtado Torres
-- Alumno: Juan Carlos Vazquez Licona
-- Matricula: 241090003 | Grupo: 7 A
-- Practica 1 (Parte 1): Ejemplo del documento
-- =====================================================
-- EJECUTAR SOLO UNA VEZ EN UNA BASE DE DATOS NUEVA.
-- Si ya creaste las tablas antes, no vuelvas a correr este archivo
-- sin revisar los datos: puede generar errores de duplicados.

CREATE DATABASE IF NOT EXISTS TechTrackDB
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE TechTrackDB;

-- -----------------------------------------------------
-- Tabla: Usuarios
-- Almacena los empleados / usuarios del sistema
-- -----------------------------------------------------
CREATE TABLE Usuarios (
  id_usuario   INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(100) NOT NULL,
  departamento VARCHAR(50),
  email        VARCHAR(100) UNIQUE,
  fecha_alta   DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: Equipos
-- Inventario de activos tecnologicos
-- ON DELETE SET NULL: al eliminar un usuario, el equipo
-- queda sin asignacion (id_usuario = NULL).
-- -----------------------------------------------------
CREATE TABLE Equipos (
  id_equipo    INT AUTO_INCREMENT PRIMARY KEY,
  num_serie    VARCHAR(50) NOT NULL UNIQUE,
  modelo       VARCHAR(80) NOT NULL,
  tipo         ENUM('Laptop','Desktop','Servidor','Periferico','Otro')
               NOT NULL DEFAULT 'Laptop',
  estado       ENUM('Disponible','Asignado','En Mantenimiento','Baja')
               DEFAULT 'Disponible',
  id_usuario   INT NULL,
  CONSTRAINT fk_usuario_equipo
    FOREIGN KEY (id_usuario)
    REFERENCES Usuarios(id_usuario)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Tabla: Mantenimientos
-- Historial de intervenciones tecnicas
-- ON DELETE CASCADE: si se elimina el equipo,
-- sus mantenimientos se eliminan en cascada.
-- -----------------------------------------------------
CREATE TABLE Mantenimientos (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  fecha            DATE NOT NULL,
  descripcion      TEXT,
  costo            DECIMAL(10,2) DEFAULT 0.00,
  tipo_mant        ENUM('Preventivo','Correctivo') DEFAULT 'Correctivo',
  id_equipo        INT NOT NULL,
  CONSTRAINT fk_equipo_manto
    FOREIGN KEY (id_equipo)
    REFERENCES Equipos(id_equipo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Datos de prueba: iguales a los del ejemplo del profesor
-- -----------------------------------------------------
INSERT INTO Usuarios (nombre, departamento, email) VALUES
('Ana López', 'Sistemas', 'ana.lopez@empresa.com'),
('Carlos Ruiz', 'Contabilidad', 'carlos.ruiz@empresa.com'),
('María Torres', 'Recursos Humanos', 'maria.torres@empresa.com');

INSERT INTO Equipos (num_serie, modelo, tipo, estado, id_usuario) VALUES
('SN-998877', 'Dell Latitude 5420', 'Laptop', 'Asignado', 1),
('SN-112233', 'HP ProDesk 400', 'Desktop', 'Asignado', 2),
('SN-445566', 'Dell PowerEdge R740', 'Servidor', 'Disponible', NULL),
('SN-778899', 'Lenovo ThinkPad X1', 'Laptop', 'Asignado', 1);

INSERT INTO Mantenimientos (fecha, descripcion, costo, tipo_mant, id_equipo) VALUES
('2025-03-15', 'Cambio de disco SSD', 85.00, 'Correctivo', 1),
('2025-06-01', 'Limpieza preventiva y actualización BIOS', 0.00, 'Preventivo', 1),
('2025-08-20', 'Reemplazo de fuente de poder', 120.50, 'Correctivo', 3);

-- Comprobacion de carga (no modifica datos).
SELECT * FROM Usuarios;
SELECT * FROM Equipos;
SELECT * FROM Mantenimientos;
