<?php
include_once("../Modelo/documento_estado.php");

$documentoEstado = new DocumentoEstado();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$nombre = isset($_POST["nombre"]) ? limpiarcadena($_POST["nombre"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $documentoEstado->guardar($nombre, $observaciones, $estado);
            echo $rspta ? "Estado del documento registrado correctamente" : "No se pudo registrar el estado del documento";
        } else {
            $rspta = $documentoEstado->editar($id, $nombre, $observaciones, $estado);
            echo $rspta ? "Estado del documento actualizado correctamente" : "No se pudo actualizar el estado del documento";
        }
        break;

    case 'desactivar':
        $rspta = $documentoEstado->desactivar($id);
        echo $rspta ? "Estado desactivado correctamente" : "No se pudo desactivar el estado";
        break;

    case 'activar':
        $rspta = $documentoEstado->activar($id);
        echo $rspta ? "Estado activado correctamente" : "No se pudo activar el estado";
        break;

    case 'mostrar':
        $rspta = $documentoEstado->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $documentoEstado->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => "N° ".$reg->id,
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
