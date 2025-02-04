<?php
require_once("../../database.php");

class Matricula_detalle
{
    public function __construct() {}

    // Método para guardar un nuevo detalle de matrícula
    public function guardar($descripcion, $id_matricula, $id_matricula_categoria, $id_usuario_apoderado_referido, $id_usuario_apoderado, $id_usuario_alumno, $observaciones)
    {
        $sql = "INSERT INTO matricula_detalle (descripcion, id_matricula, id_matricula_categoria, id_usuario_apoderado_referido, id_usuario_apoderado, id_usuario_alumno, observaciones)
        VALUES ('$descripcion', '$id_matricula', '$id_matricula_categoria', '$id_usuario_apoderado_referido', '$id_usuario_apoderado', '$id_usuario_alumno', '$observaciones')";
        return ejecutarConsulta($sql);
    }

    // Método para editar un detalle de matrícula existente
    public function editar($id, $descripcion, $id_matricula, $id_matricula_categoria, $id_usuario_apoderado_referido, $id_usuario_apoderado, $id_usuario_alumno, $observaciones)
    {
        $sql = "UPDATE matricula_detalle SET 
                    descripcion='$descripcion', 
                    id_matricula='$id_matricula', 
                    id_matricula_categoria='$id_matricula_categoria', 
                    id_usuario_apoderado_referido='$id_usuario_apoderado_referido', 
                    id_usuario_apoderado='$id_usuario_apoderado', 
                    id_usuario_alumno='$id_usuario_alumno', 
                    observaciones='$observaciones' 
                WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de un registro específico
    public function mostrar($id)
    {
        $sql = "SELECT * FROM matricula_detalle WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todos los detalles de matrícula con los campos requeridos y estado = 1
    public function listar()
    {
        $sql = "SELECT 
                md.id,
                il.nombre AS lectivo, 
                iniv.nombre AS nivel, 
                ig.nombre AS grado, 
                isec.nombre AS seccion, 
                mc.nombre AS categoria, 
                uap.nombreyapellido AS apoderado, 
                ual.nombreyapellido AS alumno
            FROM matricula_detalle md
            LEFT JOIN usuario_alumno ual ON md.id_usuario_alumno = ual.id
            LEFT JOIN usuario_apoderado uap ON md.id_usuario_apoderado = uap.id
            LEFT JOIN matricula_categoria mc ON md.id_matricula_categoria = mc.id
            LEFT JOIN institucion_seccion isec ON md.id_matricula = isec.id
            LEFT JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
            LEFT JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
            LEFT JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
            WHERE md.estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para desactivar un detalle de matrícula
    public function desactivar($id)
    {
        $sql = "UPDATE matricula_detalle SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar un detalle de matrícula
    public function activar($id)
    {
        $sql = "UPDATE matricula_detalle SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }
}
