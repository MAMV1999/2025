<?php
require_once("../../database.php");

class Mensualidad_detalle
{
    public function __construct() {}

    // Método para guardar un nuevo registro de mensualidad
    public function guardar($id_mensualidad_mes, $id_matricula_detalle, $monto, $pagado, $observaciones)
    {
        $sql = "INSERT INTO mensualidad_detalle (id_mensualidad_mes, id_matricula_detalle, monto, pagado, observaciones) 
                VALUES ('$id_mensualidad_mes', '$id_matricula_detalle', '$monto', '$pagado', '$observaciones')";
        return ejecutarConsulta($sql);
    }

    // Método para editar un registro de mensualidad existente
    public function editar($id, $id_mensualidad_mes, $id_matricula_detalle, $monto, $pagado, $observaciones)
    {
        $sql = "UPDATE mensualidad_detalle 
                SET id_mensualidad_mes='$id_mensualidad_mes', id_matricula_detalle='$id_matricula_detalle', 
                    monto='$monto', pagado='$pagado', observaciones='$observaciones' 
                WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de una mensualidad específica
    public function mostrar($id)
    {
        $sql = "SELECT 
                    md.id_matricula_detalle,
                    il.nombre AS lectivo,
                    iniv.nombre AS nivel,
                    ig.nombre AS grado,
                    isec.nombre AS seccion,
                    ud_ap.nombre AS apoderado_tipo_documento,
                    uap.numerodocumento AS apoderado_numerodocumento,
                    uap.nombreyapellido AS apoderado_nombreyapellido,
                    uap.telefono AS apoderado_telefono,
                    ud_al.nombre AS alumno_tipo_documento,
                    ual.numerodocumento AS alumno_numerodocumento,
                    ual.nombreyapellido AS alumno_nombreyapellido,
                    GROUP_CONCAT(md.id) AS ids,
                    GROUP_CONCAT(md.id_mensualidad_mes) AS ids_mensualidad_mes,
                    GROUP_CONCAT(CONCAT(mm.nombre, ' (', il.nombre, ')')) AS meses,
                    GROUP_CONCAT(DATE_FORMAT(mm.fechavencimiento, '%d/%m/%Y')) AS fechas_vencimiento,
                    GROUP_CONCAT(md.monto) AS montos,
                    GROUP_CONCAT(md.pagado) AS estados_pagado,
                    GROUP_CONCAT(md.estado) AS estados_generales,
                    GROUP_CONCAT(md.observaciones) AS observaciones
                FROM mensualidad_detalle md
                LEFT JOIN mensualidad_mes mm ON md.id_mensualidad_mes = mm.id
                LEFT JOIN matricula_detalle mdet ON md.id_matricula_detalle = mdet.id
                LEFT JOIN usuario_apoderado uap ON mdet.id_usuario_apoderado = uap.id
                LEFT JOIN usuario_documento ud_ap ON uap.id_documento = ud_ap.id
                LEFT JOIN usuario_alumno ual ON mdet.id_usuario_alumno = ual.id
                LEFT JOIN usuario_documento ud_al ON ual.id_documento = ud_al.id
                LEFT JOIN institucion_seccion isec ON mdet.id_matricula = isec.id
                LEFT JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
                LEFT JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                LEFT JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                WHERE md.id_matricula_detalle = '$id'
                GROUP BY md.id_matricula_detalle";
        return ejecutarConsultaSimpleFila($sql);
    }
    
    // Método para listar todas las mensualidades
    public function listar()
    {
        $sql = "SELECT 
                    md.id_matricula_detalle AS id, 
                    il.nombre AS lectivo, 
                    iniv.nombre AS nivel, 
                    ig.nombre AS grado, 
                    isec.nombre AS seccion, 
                    uap.nombreyapellido AS apoderado, 
                    ual.nombreyapellido AS alumno,
                    SUM(md.monto) AS total_monto, 
                    COUNT(md.id) AS num_mensualidades,
                    md.estado AS estado
                FROM mensualidad_detalle md
                LEFT JOIN mensualidad_mes mm ON md.id_mensualidad_mes = mm.id
                LEFT JOIN matricula_detalle mdet ON md.id_matricula_detalle = mdet.id
                LEFT JOIN usuario_apoderado uap ON mdet.id_usuario_apoderado = uap.id
                LEFT JOIN usuario_alumno ual ON mdet.id_usuario_alumno = ual.id
                LEFT JOIN institucion_seccion isec ON mdet.id_matricula = isec.id
                LEFT JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
                LEFT JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                LEFT JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                WHERE md.estado = '1'
                GROUP BY mdet.id, il.nombre, iniv.nombre, ig.nombre, isec.nombre, uap.nombreyapellido, ual.nombreyapellido";
        return ejecutarConsulta($sql);
    }


    // Método para desactivar un registro de mensualidad
    public function desactivar($id)
    {
        $sql = "UPDATE mensualidad_detalle SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar un registro de mensualidad
    public function activar($id)
    {
        $sql = "UPDATE mensualidad_detalle SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los meses activos
    public function listarMesesActivos()
    {
        $sql = "SELECT id, nombre FROM mensualidad_mes WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los detalles de matrícula activos
    public function listarMatriculaDetallesActivos()
    {
        $sql = "SELECT 
                    mdet.id, 
                    il.nombre AS lectivo, 
                    iniv.nombre AS nivel, 
                    ig.nombre AS grado, 
                    isec.nombre AS seccion, 
                    uap.nombreyapellido AS apoderado, 
                    ual.nombreyapellido AS alumno
                FROM matricula_detalle mdet
                LEFT JOIN usuario_apoderado uap ON mdet.id_usuario_apoderado = uap.id
                LEFT JOIN usuario_alumno ual ON mdet.id_usuario_alumno = ual.id
                LEFT JOIN institucion_seccion isec ON mdet.id_matricula = isec.id
                LEFT JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
                LEFT JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                LEFT JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                WHERE mdet.estado = '1'";
        return ejecutarConsulta($sql);
    }
}
