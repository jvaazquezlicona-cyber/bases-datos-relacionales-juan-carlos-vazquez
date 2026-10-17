# Respuestas a las 12 preguntas guiadas — TechTrack Pro

**Alumno:** Juan Carlos Vazquez Licona  
**Matrícula:** 241090003  
**Grupo:** 7 A  
**Asignatura:** Bases de Datos Relacionales

Estas respuestas corresponden a las preguntas de la **Parte 1** del PDF del profesor. Puedes revisarlas y expresarlas con tus propias palabras.

## 1. ¿Por qué separar los roles de Administrador y Técnico?
Porque cada trabajador debe disponer solo de los permisos necesarios. El administrador controla usuarios, permisos e inventario, mientras que el técnico registra mantenimientos y asignaciones. Así se evitan eliminaciones accidentales, cambios no autorizados y riesgos de seguridad.

## 2. Dos procesos adicionales para el sistema
**Control de licencias de software:** registrar licencias, vencimientos y los equipos donde están instaladas. **Control de ubicación física:** almacenar edificio, oficina o laboratorio donde se encuentra cada equipo y registrar sus traslados.

## 3. ¿Por qué el Empleado solo tiene acceso a UC04?
Porque su función es consultar los equipos que tiene asignados, no modificar el inventario. Si pudiera registrar mantenimientos, podría introducir datos incorrectos o falsos y afectar la confiabilidad del historial técnico.

## 4. Cardinalidad (0..N) entre Equipo y Mantenimiento
Significa que un equipo puede tener **cero, uno o muchos mantenimientos**. Sí, un equipo recién registrado puede existir aunque todavía no tenga ningún mantenimiento.

## 5. ¿Por qué ON DELETE SET NULL en Equipos?
Si se elimina un usuario, los equipos deben conservarse en el inventario. `ON DELETE SET NULL` elimina solo la asociación: el campo `id_usuario` del equipo queda en `NULL`, sin borrar el equipo. En una implementación real también convendría revisar/actualizar su estado para que refleje que ya no está asignado.

## 6. ¿Qué ocurre con ON DELETE CASCADE en Mantenimientos?
Cuando se elimina un equipo, MySQL elimina automáticamente todos los mantenimientos que dependen de él. Esto mantiene la integridad referencial, pero **puede provocar pérdida del historial**. En un sistema real sería más conveniente usar una baja lógica del equipo o conservar el historial por auditoría, en lugar de borrarlo físicamente.

## 7. ¿Qué pasa si insertamos un número de serie repetido?
MySQL rechazará la inserción con un error de clave duplicada, porque `num_serie` tiene la restricción `UNIQUE`. Así se evita registrar dos equipos con el mismo número de serie.

## 8. Importancia de WHERE en UPDATE
`WHERE` define qué filas se modificarán. Si se omite en esa consulta, se intentaría cambiar el departamento de **todos** los usuarios, no solo el del usuario con `id_usuario = 2` (aunque la configuración de «safe updates» de Workbench podría bloquearlo).

## 9. ¿Qué deja fuera INNER JOIN? ¿Cómo incluir equipos sin usuario?
`INNER JOIN` excluye los equipos cuyo `id_usuario` es `NULL` o que no encuentran un usuario correspondiente. Para incluir los equipos sin usuario, reemplazamos `INNER JOIN` por `LEFT JOIN`:

```sql
SELECT e.num_serie, e.modelo, e.tipo, u.nombre AS asignado_a
FROM Equipos e
LEFT JOIN Usuarios u ON e.id_usuario = u.id_usuario;
```

## 10. Diferencia entre LEFT JOIN e INNER JOIN para departamentos
`LEFT JOIN` permite mostrar también usuarios sin equipos, y en la agrupación por departamento puede reflejar departamentos sin equipos con conteo cero. `INNER JOIN` excluye las filas de usuarios sin coincidencias, por lo que un departamento sin equipos no aparecería.

## 11. Consulta SUM y GROUP BY para costo total por equipo

```sql
SELECT e.id_equipo, e.modelo,
       COALESCE(SUM(m.costo), 0) AS costo_total
FROM Equipos e
LEFT JOIN Mantenimientos m ON e.id_equipo = m.id_equipo
GROUP BY e.id_equipo, e.modelo;
```

## 12. Cláusula para mostrar solamente totales mayores a 100
La cláusula es **`HAVING`**, porque filtra resultados agrupados después de aplicar `SUM`:

```sql
SELECT e.id_equipo, e.modelo,
       SUM(m.costo) AS costo_total
FROM Equipos e
JOIN Mantenimientos m ON e.id_equipo = m.id_equipo
GROUP BY e.id_equipo, e.modelo
HAVING SUM(m.costo) > 100;
```
