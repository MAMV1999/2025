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
        $detalles = isset($_POST['detalles']) ? json_decode($_POST['detalles'], true) : [];
        $rspta = $mensualidadDetalle->guardarEditarMasivo($detalles);
    
        echo $rspta ? "Registros actualizados correctamente" : "No se pudieron actualizar todos los registros";
        break;

    case 'mostrar':
        $rspta = $mensualidadDetalle->mostrar($id);
        $response = array();

        if ($rspta) {
            $ids = explode(',', $rspta['ids']);
            $ids_mensualidad_mes = explode(',', $rspta['ids_mensualidad_mes']);
            $meses = explode(',', $rspta['meses']);
            $fechas_vencimiento = explode(',', $rspta['fechas_vencimiento']);
            $montos = explode(',', $rspta['montos']);
            $estados_pagado = explode(',', $rspta['estados_pagado']);
            $estados_generales = explode(',', $rspta['estados_generales']);
            $observaciones = explode(',', $rspta['observaciones']);

            foreach ($montos as $index => $monto) {
                $response['detalles'][] = array(
                    "id" => $ids[$index],
                    "id_mensualidad_mes" => $ids_mensualidad_mes[$index],
                    "mes" => $meses[$index],
                    "fechavencimiento" => $fechas_vencimiento[$index],
                    "monto" => $monto,
                    "pagado" => $estados_pagado[$index],
                    "estado" => $estados_generales[$index],
                    "observaciones" => $observaciones[$index],
                );
            }

            $response['general'] = array(
                "id_matricula_detalle" => $rspta['id_matricula_detalle'],
                "lectivo" => $rspta['lectivo'],
                "nivel" => $rspta['nivel'],
                "grado" => $rspta['grado'],
                "seccion" => $rspta['seccion'],
                "apoderado" => array(
                    "tipo_documento" => $rspta['apoderado_tipo_documento'],
                    "numerodocumento" => $rspta['apoderado_numerodocumento'],
                    "nombreyapellido" => $rspta['apoderado_nombreyapellido'],
                    "telefono" => $rspta['apoderado_telefono'],
                ),
                "alumno" => array(
                    "tipo_documento" => $rspta['alumno_tipo_documento'],
                    "numerodocumento" => $rspta['alumno_numerodocumento'],
                    "nombreyapellido" => $rspta['alumno_nombreyapellido'],
                ),
            );
        }

        echo json_encode($response);
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
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
                    :
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
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
