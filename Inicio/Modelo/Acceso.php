<?php
require_once("../../database.php");

class Acceso
{
    public function __construct()
    {
    }

    // Función para verificar usuario y contraseña
    public function verificar($usuario, $contraseña)
    {
        $sql = "SELECT * FROM trabajador WHERE usuario='$usuario' AND contraseña='$contraseña' AND estado='1'";
        return ejecutarConsulta($sql);
    }
}
?>
