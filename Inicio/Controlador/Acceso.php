<?php
session_start();
require_once("../Modelo/Acceso.php");

$acceso = new Acceso();

$usuario = isset($_POST["usuario"]) ? limpiarcadena($_POST["usuario"]) : "";
$contraseña = isset($_POST["contraseña"]) ? limpiarcadena($_POST["contraseña"]) : "";

switch ($_GET["op"]) {
    case 'verificar':
        $rspta = $acceso->verificar($usuario, $contraseña);
        if ($rspta->num_rows > 0) {
            $fetch = $rspta->fetch_object();
            
            $_SESSION['tipo_usuario'] = 'Trabajador';
            $_SESSION['id'] = $fetch->id;
            $_SESSION['nombre'] = $fetch->nombre_apellido;
            $_SESSION['dni'] = $fetch->dni;
            $_SESSION['usuario'] = $fetch->usuario;
            $_SESSION['sexo'] = $fetch->sexo;
            $_SESSION['cargo'] = $fetch->cargo;
            $_SESSION['estado_civil'] = $fetch->estado_civil;
            // Añadir otras variables de sesión según sea necesario

            echo json_encode(array("status" => "success", "datos" => $fetch));
        } else {
            echo json_encode(array("status" => "error", "message" => "Usuario o contraseña incorrectos o el usuario está desactivado."));
        }
        break;

    case 'salir':
        session_unset();
        session_destroy();
        header("Location: ../../index.php");
        break;
}
?>
