<?php
include_once("../Modelo/usuario_menu.php");

$usuarioMenu = new UsuarioMenu();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$nombre = isset($_POST["nombre"]) ? limpiarcadena($_POST["nombre"]) : "";
$link = isset($_POST["link"]) ? limpiarcadena($_POST["link"]) : "";
$icono = isset($_POST["icono"]) ? limpiarcadena($_POST["icono"]) : "";
$descripcion = isset($_POST["descripcion"]) ? limpiarcadena($_POST["descripcion"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $usuarioMenu->guardar($nombre, $link, $icono, $descripcion, $estado);
            echo $rspta ? "Menú registrado correctamente" : "No se pudo registrar el menú";
        } else {
            $rspta = $usuarioMenu->editar($id, $nombre, $link, $icono, $descripcion, $estado);
            echo $rspta ? "Menú actualizado correctamente" : "No se pudo actualizar el menú";
        }
        break;

    case 'desactivar':
        $rspta = $usuarioMenu->desactivar($id);
        echo $rspta ? "Menú desactivado correctamente" : "No se pudo desactivar el menú";
        break;

    case 'activar':
        $rspta = $usuarioMenu->activar($id);
        echo $rspta ? "Menú activado correctamente" : "No se pudo activar el menú";
        break;

    case 'mostrar':
        $rspta = $usuarioMenu->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $usuarioMenu->listar();
        $data = Array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => count($data) + 1,
                "1" => $reg->nombre,
                "2" => ($reg->estado) ? '
                <button type="button" onclick="mostrar(' . $reg->id . ')" class="btn btn-warning btn-sm">EDITAR</button>
                <button type="button" onclick="desactivar(' . $reg->id . ')" class="btn btn-danger btn-sm">DESACTIVAR</button>
                ' : '
                <button type="button" onclick="mostrar(' . $reg->id . ')" class="btn btn-warning btn-sm">EDITAR</button>
                <button type="button" onclick="activar(' . $reg->id . ')" class="btn btn-success btn-sm">ACTIVAR</button>
                '
            );
        }
        $results = array(
            "sEcho" => 1,
            "iTotalRecords" => count($data),
            "iTotalDisplayRecords" => count($data),
            "aaData" => $data
        );
        echo json_encode($results);
        break;
}
?>
