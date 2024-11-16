<?php
require_once("../../database.php");

class Usuario_apoderado
{
    public function __construct()
    {
    }

    // Método para guardar un nuevo usuario apoderado
    public function guardar($id_apoderado_tipo, $id_documento, $numerodocumento, $nombreyapellido, $telefono, $id_sexo, $id_estado_civil, $usuario, $clave, $observaciones)
    {
        $sql = "INSERT INTO usuario_apoderado (id_apoderado_tipo, id_documento, numerodocumento, nombreyapellido, telefono, id_sexo, id_estado_civil, usuario, clave, observaciones) 
                VALUES ('$id_apoderado_tipo', '$id_documento', '$numerodocumento', '$nombreyapellido', '$telefono', '$id_sexo', '$id_estado_civil', '$numerodocumento', '$numerodocumento', '$observaciones')";
        return ejecutarConsulta($sql);
    }

    // Método para editar un usuario apoderado existente
    public function editar($id, $id_apoderado_tipo, $id_documento, $numerodocumento, $nombreyapellido, $telefono, $id_sexo, $id_estado_civil, $usuario, $clave, $observaciones)
    {
        $sql = "UPDATE usuario_apoderado 
                SET id_apoderado_tipo='$id_apoderado_tipo', id_documento='$id_documento', numerodocumento='$numerodocumento', nombreyapellido='$nombreyapellido', telefono='$telefono', id_sexo='$id_sexo', id_estado_civil='$id_estado_civil', usuario='$usuario', clave='$clave', observaciones='$observaciones' 
                WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de un usuario apoderado específico
    public function mostrar($id)
    {
        $sql = "SELECT * FROM usuario_apoderado WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todos los usuarios apoderados
    public function listar()
    {
        $sql = "SELECT ua.id, ua.numerodocumento, ua.nombreyapellido, ua.telefono, uat.nombre AS tipo_apoderado, ud.nombre AS tipo_documento, us.nombre AS sexo, uec.nombre AS estado_civil, ua.usuario, ua.estado, ua.fechacreado 
                FROM usuario_apoderado ua
                LEFT JOIN usuario_apoderado_tipo uat ON ua.id_apoderado_tipo = uat.id
                LEFT JOIN usuario_documento ud ON ua.id_documento = ud.id
                LEFT JOIN usuario_sexo us ON ua.id_sexo = us.id
                LEFT JOIN usuario_estado_civil uec ON ua.id_estado_civil = uec.id";
        return ejecutarConsulta($sql);
    }

    // Método para desactivar un usuario apoderado
    public function desactivar($id)
    {
        $sql = "UPDATE usuario_apoderado SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar un usuario apoderado
    public function activar($id)
    {
        $sql = "UPDATE usuario_apoderado SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los tipos de apoderados activos
    public function listarTiposApoderadosActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_apoderado_tipo WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los tipos de documentos activos
    public function listarTiposDocumentosActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_documento WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los sexos activos
    public function listarSexosActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_sexo WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los estados civiles activos
    public function listarEstadosCivilesActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_estado_civil WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }
}
?>
