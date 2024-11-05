<?php
include_once("../Modelo/Perfil.php");

try {
    $perfil = new Perfil();
} catch (Exception $e) {
    echo json_encode(array("status" => "error", "message" => $e->getMessage()));
    exit();
}

$usuario = isset($_POST["usuario"]) ? limpiarcadena($_POST["usuario"]) : "";
$contraseña = isset($_POST["contraseña"]) ? limpiarcadena($_POST["contraseña"]) : "";
$dni = isset($_POST["dni"]) ? limpiarcadena($_POST["dni"]) : "";
$nombre_apellido = isset($_POST["nombre_apellido"]) ? limpiarcadena($_POST["nombre_apellido"]) : "";
$nacimiento = isset($_POST["nacimiento"]) ? limpiarcadena($_POST["nacimiento"]) : "";
$sexo = isset($_POST["sexo"]) ? limpiarcadena($_POST["sexo"]) : "";
$estado_civil = isset($_POST["estado_civil"]) ? limpiarcadena($_POST["estado_civil"]) : "";
$cargo = isset($_POST["cargo"]) ? limpiarcadena($_POST["cargo"]) : "";
$direccion = isset($_POST["direccion"]) ? limpiarcadena($_POST["direccion"]) : "";
$telefono = isset($_POST["telefono"]) ? limpiarcadena($_POST["telefono"]) : "";
$correo = isset($_POST["correo"]) ? limpiarcadena($_POST["correo"]) : "";
$sueldo = isset($_POST["sueldo"]) ? limpiarcadena($_POST["sueldo"]) : "";
$cuenta_bcp = isset($_POST["cuenta_bcp"]) ? limpiarcadena($_POST["cuenta_bcp"]) : "";
$interbancario_bcp = isset($_POST["interbancario_bcp"]) ? limpiarcadena($_POST["interbancario_bcp"]) : "";
$sunat_ruc = isset($_POST["sunat_ruc"]) ? limpiarcadena($_POST["sunat_ruc"]) : "";
$sunat_usuario = isset($_POST["sunat_usuario"]) ? limpiarcadena($_POST["sunat_usuario"]) : "";
$sunat_contraseña = isset($_POST["sunat_contraseña"]) ? limpiarcadena($_POST["sunat_contraseña"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";

switch ($_GET["op"]) {
    case 'mostrar':
        $rspta = $perfil->mostrar();
        echo json_encode($rspta);
        break;

    case 'editar':
        $rspta = $perfil->editar($usuario, $contraseña, $dni, $nombre_apellido, $nacimiento, $sexo, $estado_civil, $cargo, $direccion, $telefono, $correo, $sueldo, $cuenta_bcp, $interbancario_bcp, $sunat_ruc, $sunat_usuario, $sunat_contraseña, $observaciones);
        echo $rspta ? json_encode(array("status" => "success", "message" => "Perfil actualizado correctamente")) : json_encode(array("status" => "error", "message" => "No se pudo actualizar el perfil"));
        break;

    // Otras operaciones necesarias
}
?>
