<?php
require_once("../../database.php");

class UsuarioMenu
{
    public function __construct()
    {
    }

    public function guardar($nombre, $link, $icono, $descripcion, $estado)
    {
        $sql = "INSERT INTO usuario_menu (nombre, link, icono, descripcion, estado) VALUES ('$nombre', '$link', '$icono', '$descripcion', '$estado')";
        return ejecutarConsulta($sql);
    }

    public function editar($id, $nombre, $link, $icono, $descripcion, $estado)
    {
        $sql = "UPDATE usuario_menu SET nombre='$nombre', link='$link', icono='$icono', descripcion='$descripcion', estado='$estado' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    public function mostrar($id)
    {
        $sql = "SELECT * FROM usuario_menu WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    public function listar()
    {
        $sql = "SELECT * FROM usuario_menu";
        return ejecutarConsulta($sql);
    }

    public function desactivar($id)
    {
        $sql = "UPDATE usuario_menu SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    public function activar($id)
    {
        $sql = "UPDATE usuario_menu SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }
}
?>
