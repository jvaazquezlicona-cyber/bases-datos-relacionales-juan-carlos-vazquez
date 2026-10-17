[README.md](https://github.com/user-attachments/files/33588819/README.md)
# Práctica 1 (Parte 2) - LabTrack Pro

**Materia:** Bases de Datos Relacionales | **Docente:** Ing. Roberto Carlos Hurtado Torres  
**Alumno:** Juan Carlos Vázquez Licona | **Matrícula:** 241090003 | **Grupo:** 7° A  
**Universidad:** Universidad Privada del Estado de México (UPEM)

## Propósito
Sistema de gestión del laboratorio universitario con inventario, alumnos, préstamos y mantenimientos. Corresponde exclusivamente a la **Parte 2** del documento del segundo parcial.

## Archivos

| Archivo | Contenido |
|---|---|
| `01_estructura.sql` | Creación de `LabTrackDB` y cuatro tablas, PK, FK, UNIQUE, DEFAULT, CHECK e InnoDB. |
| `02_datos_y_operaciones.sql` | INSERT, dos UPDATE, DELETE justificado, WHERE y ORDER BY. |
| `03_retos_consultas.sql` | Seis retos SQL con JOIN, LEFT JOIN, GROUP BY, SUM y HAVING. |
| `04_modelo_ER.puml` | Modelo Crow's Foot en PlantUML. |
| `05_casos_de_uso.puml` | Diagrama UML de casos de uso en PlantUML. |
| `ER.png` y `Casos_de_Uso.png` | Diagramas para visualizar o adjuntar. |
| `Informe_LabTrack_Pro_Parte2.pdf` | Reporte técnico con secciones A-E, modelo, scripts y resultados esperados. |
| `Anexo_respuestas_parte1.md` | Respuestas a las 12 preguntas guiadas del documento, correspondientes a la Parte 1. |

## Cómo ejecutar en MySQL Workbench

1. Abrir la conexión local de MySQL.
2. **File > Open SQL Script** y seleccionar `01_estructura.sql`; ejecutar el archivo completo **una sola vez**.
3. Seleccionar `02_datos_y_operaciones.sql`; ejecutar **una sola vez**, preferentemente por bloques para documentar cada resultado.
4. Seleccionar `03_retos_consultas.sql`; ejecutar cada reto por separado para capturar la cuadrícula de resultados (`Result Grid`).
5. Actualizar **SCHEMAS** y revisar `LabTrackDB`.

**Atención:** no vuelvas a ejecutar los INSERT de `02_datos_y_operaciones.sql` sobre los mismos datos: hay restricciones `UNIQUE` y podría haber duplicados. No ejecutar el script de TechTrack Pro en esta práctica. No confundir `TechTrackDB` (Parte 1) con `LabTrackDB` (Parte 2).

## Resultados esperados con los datos incluidos

- 6 equipos, 4 alumnos, 8 préstamos y 5 mantenimientos después de eliminar un registro de prueba.
- Reto 1: 2 equipos actualmente prestados (LAB-001 y LAB-003).
- Reto 2: 2 equipos que nunca han sido prestados (LAB-004 y LAB-006).
- Reto 3: conteos de préstamos por alumno 4, 2, 1 y 1.
- Reto 4: total por tipo: PC = 1680.00; Monitor = 150.00; Proyector = 200.00.
- Reto 5: Mariana Ríos, 4 préstamos.
- Reto 6: LAB-005 (Lenovo ThinkCentre M70q), mantenimiento de 980.00.

> Son resultados **esperados a partir de los datos del script**. Las capturas de ejecución en MySQL Workbench deben realizarse en la computadora del alumno; no se incluyen capturas inventadas.

## Entrega

Subir esta carpeta a `bases-datos-relacionales-juan-carlos-vazquez/practica-1-parte-2-labtrack-pro/` sin sobrescribir los archivos de la Parte 1. Adjuntar el enlace de esta carpeta o el PDF y capturas a la tarea **Práctica 1 (Parte 2)** en Classroom.
