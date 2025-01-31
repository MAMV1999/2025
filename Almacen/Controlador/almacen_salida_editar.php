<?php
include_once("../Modelo/almacen_salida_editar.php");

$almacenSalida = new AlmacenSalida();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$usuario_apoderado_id = isset($_POST["usuario_apoderado_id"]) ? limpiarcadena($_POST["usuario_apoderado_id"]) : "";
$almacen_comprobante_id = isset($_POST["almacen_comprobante_id"]) ? limpiarcadena($_POST["almacen_comprobante_id"]) : "";
$numeracion = isset($_POST["numeracion"]) ? limpiarcadena($_POST["numeracion"]) : "";
$fecha = isset($_POST["fecha"]) ? limpiarcadena($_POST["fecha"]) : "";
$almacen_metodo_pago_id = isset($_POST["almacen_metodo_pago_id"]) ? limpiarcadena($_POST["almacen_metodo_pago_id"]) : "";
$total = isset($_POST["total"]) ? limpiarcadena($_POST["total"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $almacenSalida->guardar($usuario_apoderado_id, $almacen_comprobante_id, $numeracion, $fecha, $almacen_metodo_pago_id, $total, $observaciones);
            echo $rspta ? "Salida registrada correctamente" : "No se pudo registrar la salida";
        } else {
            $rspta = $almacenSalida->editar($id, $usuario_apoderado_id, $almacen_comprobante_id, $numeracion, $fecha, $almacen_metodo_pago_id, $total, $observaciones);
            echo $rspta ? "Salida actualizada correctamente" : "No se pudo actualizar la salida";
        }
        break;

    case 'desactivar':
        $rspta = $almacenSalida->desactivar($id);
        echo $rspta ? "Salida desactivada correctamente" : "No se pudo desactivar la salida";
        break;

    case 'activar':
        $rspta = $almacenSalida->activar($id);
        echo $rspta ? "Salida activada correctamente" : "No se pudo activar la salida";
        break;

    case 'mostrar':
        $rspta = $almacenSalida->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $almacenSalida->listar();
        $data = array();
        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => count($data) + 1,
                "1" => $reg->nombre_apoderado,
                "2" => $reg->nombre_comprobante . ' - ' . $reg->numeracion,
                "3" => $reg->fecha,
                "4" => $reg->metodo_pago,
                "5" => $reg->estado_descripcion,
                "6" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
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

    case 'listar_apoderados_activos':
        $rspta = $almacenSalida->listarApoderadosActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombreyapellido . '</option>';
        }
        break;

    case 'listar_comprobantes_activos':
        $rspta = $almacenSalida->listarComprobantesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

    case 'listar_metodos_pago_activos':
        $rspta = $almacenSalida->listarMetodosPagoActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;
}
