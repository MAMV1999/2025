<?php
include_once("../Modelo/matricula_meses.php");

$matriculaMeses = new MatriculaMeses();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$nombre = isset($_POST["nombre"]) ? limpiarcadena($_POST["nombre"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $matriculaMeses->guardar(strtoupper($nombre), strtoupper($observaciones), $estado);
            echo $rspta ? "Mes de matrícula registrado correctamente" : "No se pudo registrar el mes de matrícula";
        } else {
            $rspta = $matriculaMeses->editar($id, strtoupper($nombre), strtoupper($observaciones), $estado);
            echo $rspta ? "Mes de matrícula actualizado correctamente" : "No se pudo actualizar el mes de matrícula";
        }
        break;

    case 'desactivar':
        $rspta = $matriculaMeses->desactivar($id);
        echo $rspta ? "Mes de matrícula desactivado correctamente" : "No se pudo desactivar el mes de matrícula";
        break;

    case 'activar':
        $rspta = $matriculaMeses->activar($id);
        echo $rspta ? "Mes de matrícula activado correctamente" : "No se pudo activar el mes de matrícula";
        break;

    case 'mostrar':
        $rspta = $matriculaMeses->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $matriculaMeses->listar();
        $data = Array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->id,
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
