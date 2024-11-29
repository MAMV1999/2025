<?php
include_once("../Modelo/Mensualidad_detalle.php");

$mensualidadDetalle = new Mensualidad_detalle();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$id_mensualidad_mes = isset($_POST["id_mensualidad_mes"]) ? limpiarcadena($_POST["id_mensualidad_mes"]) : "";
$id_matricula_detalle = isset($_POST["id_matricula_detalle"]) ? limpiarcadena($_POST["id_matricula_detalle"]) : "";
$monto = isset($_POST["monto"]) ? limpiarcadena($_POST["monto"]) : "";
$pagado = isset($_POST["pagado"]) ? limpiarcadena($_POST["pagado"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $mensualidadDetalle->guardar($id_mensualidad_mes, $id_matricula_detalle, $monto, $pagado, $observaciones);
            echo $rspta ? "Mensualidad registrada correctamente" : "No se pudo registrar la mensualidad";
        } else {
            $rspta = $mensualidadDetalle->editar($id, $id_mensualidad_mes, $id_matricula_detalle, $monto, $pagado, $observaciones);
            echo $rspta ? "Mensualidad actualizada correctamente" : "No se pudo actualizar la mensualidad";
        }
        break;

    case 'desactivar':
        $rspta = $mensualidadDetalle->desactivar($id);
        echo $rspta ? "Mensualidad desactivada correctamente" : "No se pudo desactivar la mensualidad";
        break;

    case 'activar':
        $rspta = $mensualidadDetalle->activar($id);
        echo $rspta ? "Mensualidad activada correctamente" : "No se pudo activar la mensualidad";
        break;

    case 'mostrar':
        $rspta = $mensualidadDetalle->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $mensualidadDetalle->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => 'N° ' . $reg->id,
                "1" => $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado . ' - ' . $reg->seccion,
                "2" => $reg->apoderado,
                "3" => $reg->alumno,
                "4" => ($reg->estado) ?
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-danger btn-sm" onclick="desactivar(' . $reg->id . ')">DESACTIVAR</button>' :
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-primary btn-sm" onclick="activar(' . $reg->id . ')">ACTIVAR</button>'
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

    case 'listar_meses_activos':
        $rspta = $mensualidadDetalle->listarMesesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id . '>' . $reg->nombre . '</option>';
        }
        break;

    case 'listar_matricula_detalles_activos':
        $rspta = $mensualidadDetalle->listarMatriculaDetallesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id . '>' . $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado . ' - ' . $reg->seccion . ' - ' . $reg->apoderado . ' - ' . $reg->alumno . '</option>';
        }
        break;
}
?>
