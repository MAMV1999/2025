<?php
include_once("../Modelo/Matricula_pago.php");

$matriculaPago = new Matricula_pago();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$id_matricula_detalle = isset($_POST["id_matricula_detalle"]) ? limpiarcadena($_POST["id_matricula_detalle"]) : "";
$numeracion = isset($_POST["numeracion"]) ? limpiarcadena($_POST["numeracion"]) : "";
$fecha = isset($_POST["fecha"]) ? limpiarcadena($_POST["fecha"]) : "";
$descripcion = isset($_POST["descripcion"]) ? limpiarcadena($_POST["descripcion"]) : "";
$monto = isset($_POST["monto"]) ? limpiarcadena($_POST["monto"]) : "";
$id_matricula_metodo_pago = isset($_POST["id_matricula_metodo_pago"]) ? limpiarcadena($_POST["id_matricula_metodo_pago"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $matriculaPago->guardar($id_matricula_detalle, $numeracion, $fecha, $descripcion, $monto, $id_matricula_metodo_pago, $observaciones);
            echo $rspta ? "Pago registrado correctamente" : "No se pudo registrar el pago";
        } else {
            $rspta = $matriculaPago->editar($id, $id_matricula_detalle, $numeracion, $fecha, $descripcion, $monto, $id_matricula_metodo_pago, $observaciones);
            echo $rspta ? "Pago actualizado correctamente" : "No se pudo actualizar el pago";
        }
        break;

    case 'desactivar':
        $rspta = $matriculaPago->desactivar($id);
        echo $rspta ? "Pago desactivado correctamente" : "No se pudo desactivar el pago";
        break;

    case 'activar':
        $rspta = $matriculaPago->activar($id);
        echo $rspta ? "Pago activado correctamente" : "No se pudo activar el pago";
        break;

    case 'mostrar':
        $rspta = $matriculaPago->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $matriculaPago->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => 'N° ' . $reg->id,
                "1" => $reg->fecha,
                "2" => 'N° ' . $reg->numeracion,
                "3" => $reg->apoderado,
                "4" => 'S./ ' . $reg->monto,
                "5" => $reg->metodo_pago,
                "6" => ($reg->estado) ?
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

    case 'listar_metodos_pago_activos':
        $rspta = $matriculaPago->listarMetodosPagoActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id . '>' . $reg->nombre . '</option>';
        }
        break;

    case 'listar_matricula_detalles_activos':
        $rspta = $matriculaPago->listarMatriculaDetallesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id . '>' . $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado . ' - ' . $reg->seccion . ' - ' . $reg->apoderado . ' - ' . $reg->alumno . '</option>';
        }
        break;
}
