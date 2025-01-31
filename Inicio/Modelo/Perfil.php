<?php
require_once("../../database.php");

class Perfil
{
    private $id;

    public function __construct()
    {
        session_start();
        if (isset($_SESSION['id'])) {
            $this->id = $_SESSION['id'];
        } else {
            throw new Exception("ID de sesión no encontrada.");
        }
    }

    public function mostrar()
    {
        $sql = "SELECT * FROM trabajador WHERE id='$this->id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    public function editar($usuario, $contraseña, $dni, $nombre_apellido, $nacimiento, $sexo, $estado_civil, $cargo, $direccion, $telefono, $correo, $sueldo, $cuenta_bcp, $interbancario_bcp, $sunat_ruc, $sunat_usuario, $sunat_contraseña, $observaciones)
    {
        $sql = "UPDATE trabajador SET 
                    usuario='$usuario', 
                    contraseña='$contraseña', 
                    dni='$dni', 
                    nombre_apellido='$nombre_apellido', 
                    nacimiento='$nacimiento', 
                    sexo='$sexo', 
                    estado_civil='$estado_civil', 
                    cargo='$cargo', 
                    direccion='$direccion', 
                    telefono='$telefono', 
                    correo='$correo', 
                    sueldo='$sueldo', 
                    cuenta_bcp='$cuenta_bcp', 
                    interbancario_bcp='$interbancario_bcp', 
                    sunat_ruc='$sunat_ruc', 
                    sunat_usuario='$sunat_usuario', 
                    sunat_contraseña='$sunat_contraseña', 
                    observaciones='$observaciones' 
                WHERE id='$this->id'";
        return ejecutarConsulta($sql);
    }
}
?>
