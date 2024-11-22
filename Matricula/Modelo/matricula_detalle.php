<?php
require_once("../../database.php");

class MatriculaDetalle
{
    public function __construct()
    {
    }

    // Método para guardar un nuevo detalle de matrícula
    public function guardar(
        $descripcion, $id_matricula, $id_matricula_categoria, 
        $id_usuario_apoderado, $id_usuario_alumno, $observaciones, $estado = 1
    ) {
        $sql = "INSERT INTO matricula_detalle (
                    descripcion, id_matricula, id_matricula_categoria, 
                    id_usuario_apoderado, id_usuario_alumno, observaciones, estado
                ) VALUES (
                    '$descripcion', '$id_matricula', '$id_matricula_categoria', 
                    '$id_usuario_apoderado', '$id_usuario_alumno', '$observaciones', '$estado'
                )";
        return ejecutarConsulta($sql);
    }

    // Método para editar un detalle de matrícula existente
    public function editar(
        $id, $descripcion, $id_matricula, $id_matricula_categoria, 
        $id_usuario_apoderado, $id_usuario_alumno, $observaciones, $estado
    ) {
        $sql = "UPDATE matricula_detalle SET 
                    descripcion='$descripcion', id_matricula='$id_matricula', 
                    id_matricula_categoria='$id_matricula_categoria', 
                    id_usuario_apoderado='$id_usuario_apoderado', 
                    id_usuario_alumno='$id_usuario_alumno', 
                    observaciones='$observaciones', estado='$estado'
                WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de una matrícula específica
    public function mostrar($id)
    {
        $sql = "SELECT * FROM matricula_detalle WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todos los detalles de matrícula
    public function listar()
    {
        $sql = "SELECT 
                    md.id, 
                    md.descripcion, 
                    mc.nombre AS categoria, 
                    ua.nombreyapellido AS alumno, 
                    uap.nombreyapellido AS apoderado, 
                    md.estado 
                FROM matricula_detalle md
                INNER JOIN matricula m ON md.id_matricula = m.id
                INNER JOIN matricula_categoria mc ON md.id_matricula_categoria = mc.id
                INNER JOIN usuario_alumno ua ON md.id_usuario_alumno = ua.id
                INNER JOIN usuario_apoderado uap ON md.id_usuario_apoderado = uap.id";
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

    // Métodos para listar datos activos para los campos de selección en el formulario
    public function listarMatriculasActivas()
    {
        $sql = "SELECT id, nombre FROM matricula WHERE estado='1'";
        return ejecutarConsulta($sql);
    }

    public function listarCategoriasActivas()
    {
        $sql = "SELECT id, nombre FROM matricula_categoria WHERE estado='1'";
        return ejecutarConsulta($sql);
    }

    public function listarAlumnosActivos()
    {
        $sql = "SELECT id, nombreyapellido FROM usuario_alumno WHERE estado='1'";
        return ejecutarConsulta($sql);
    }

    public function listarApoderadosActivos()
    {
        $sql = "SELECT id, nombreyapellido FROM usuario_apoderado WHERE estado='1'";
        return ejecutarConsulta($sql);
    }
}
?>
