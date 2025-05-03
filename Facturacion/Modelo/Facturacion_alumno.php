<?php
require_once("../../database.php");

class Facturacion_alumno
{
    public function __construct() {}

    // Método para listar
    public function listar()
    {
        $sql = "SELECT
                    md.id AS mensualidad_detalle_id,
                    mm.id AS mensualidad_mes_id,
                    mm.nombre AS mes,
                    ua.numerodocumento AS apoderado_dni,
                    ua.nombreyapellido AS apoderado_nombre,
                    ua.telefono AS apoderado_telefono,
                    ual.numerodocumento AS alumno_dni,
                    ual.nombreyapellido AS alumno_nombre,
                    il2.nombre AS lectivo,
                    iniv.nombre AS nivel,
                    igr.nombre AS grado,
                    isec.nombre AS seccion,
                    CONCAT('MENSUALIDAD ', mm.nombre, ' ', il2.nombre, ' - ', iniv.nombre, ' - ', igr.nombre, ' - ', ual.nombreyapellido) AS descripcion_mensualidad,
                    md.monto,
                    md.pagado,
                    md.recibo,
                    md.estado
                FROM mensualidad_detalle md
                JOIN mensualidad_mes mm ON md.id_mensualidad_mes = mm.id AND mm.estado = 1
                JOIN institucion_lectivo il ON mm.id_institucion_lectivo = il.id AND il.estado = 1
                JOIN matricula_detalle mdet ON md.id_matricula_detalle = mdet.id AND mdet.estado = 1
                JOIN usuario_apoderado ua ON mdet.id_usuario_apoderado = ua.id AND ua.estado = 1
                JOIN usuario_alumno ual ON mdet.id_usuario_alumno = ual.id AND ual.estado = 1
                JOIN matricula m ON mdet.id_matricula = m.id AND m.estado = 1
                JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id AND isec.estado = 1
                JOIN institucion_grado igr ON isec.id_institucion_grado = igr.id AND igr.estado = 1
                JOIN institucion_nivel iniv ON igr.id_institucion_nivel = iniv.id AND iniv.estado = 1
                JOIN institucion_lectivo il2 ON iniv.id_institucion_lectivo = il2.id AND il2.estado = 1
                WHERE
                    md.pagado = 1
                    AND md.estado = 1
                    AND md.monto > 0
                ORDER BY
                    il2.nombre ASC,
                    iniv.nombre ASC,
                    igr.nombre ASC,
                    isec.nombre ASC,
                    ual.nombreyapellido ASC,
                    mm.id ASC";
        return ejecutarConsulta($sql);
    }
}
