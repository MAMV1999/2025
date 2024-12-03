<?php
require_once("../../database.php");

class Recibomatricula
{
    public function __construct()
    {
    }

    public function listarPorIdMatriculaDettalle($id)
    {
        $sql = "SELECT 
        -- Información de la matrícula detalle
        md.id AS matricula_detalle_id,
        md.descripcion AS matricula_detalle_descripcion,
        md.observaciones AS matricula_detalle_observaciones,
        md.fechacreado AS matricula_detalle_fechacreado,
        
        -- Información del alumno
        ua.nombreyapellido AS alumno_nombre_completo,
        ua.numerodocumento AS alumno_numero_documento,
        ud_a.nombre AS alumno_tipo_documento,
        ua.nacimiento AS alumno_fecha_nacimiento,
    
        -- Información del apoderado
        ap.nombreyapellido AS apoderado_nombre_completo,
        ap.numerodocumento AS apoderado_numero_documento,
        ud_ap.nombre AS apoderado_tipo_documento,
        ap.telefono AS apoderado_telefono,
    
        -- Información del ciclo lectivo, nivel, grado y sección
        il.nombre AS lectivo_nombre,
        inl.nombre AS nivel_nombre,
        ig.nombre AS grado_nombre,
        isec.nombre AS seccion_nombre,
    
        -- Información de la institución
        inst.nombre AS institucion_nombre,
        inst.direccion AS institucion_direccion,
        inst.telefono AS institucion_telefono,
        inst.correo AS institucion_correo,
        inst.razon_social AS institucion_razon_social,
        inst.ruc AS institucion_ruc,
    
        -- Información de los pagos
        mp.numeracion AS pago_numeracion,
        DATE_FORMAT(mp.fecha, '%d/%m/%Y') AS pago_fecha,
        mp.descripcion AS pago_descripcion,
        mp.monto AS pago_monto,
        mmp.nombre AS metodo_pago_nombre
    
    FROM 
        matricula_detalle md
        -- Relación con matrícula
        INNER JOIN matricula m ON md.id_matricula = m.id
        -- Relación con sección
        INNER JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
        -- Relación con grado
        INNER JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
        -- Relación con nivel
        INNER JOIN institucion_nivel inl ON ig.id_institucion_nivel = inl.id
        -- Relación con ciclo lectivo
        INNER JOIN institucion_lectivo il ON inl.id_institucion_lectivo = il.id
        -- Relación con institución
        INNER JOIN institucion inst ON il.id_institucion = inst.id
        -- Relación con el alumno
        INNER JOIN usuario_alumno ua ON md.id_usuario_alumno = ua.id
        -- Relación con el tipo de documento del alumno
        INNER JOIN usuario_documento ud_a ON ua.id_documento = ud_a.id
        -- Relación con el apoderado
        INNER JOIN usuario_apoderado ap ON md.id_usuario_apoderado = ap.id
        -- Relación con el tipo de documento del apoderado
        INNER JOIN usuario_documento ud_ap ON ap.id_documento = ud_ap.id
        -- Relación con pagos
        LEFT JOIN matricula_pago mp ON mp.id_matricula_detalle = md.id
        -- Relación con método de pago
        LEFT JOIN matricula_metodo_pago mmp ON mp.id_matricula_metodo_pago = mmp.id
        
        WHERE md.id = '$id'";
        return ejecutarConsulta($sql);
    }
}
?>
