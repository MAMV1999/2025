<?php
include_once("../Modelo/mensualidad_x_mes.php");

$mensualidadxmes = new Mensualidadxmes();

switch ($_GET["op"]) {

    case 'listar':
        $rspta = $mensualidadxmes->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => 'N° ' . $reg->id_mensualidad_mes,
                "1" => $reg->nombre_mes,
                "2" => $reg->deudor . ' APODERADOS',
                "3" => 'S/.' . $reg->suma_deuda,
                "4" => $reg->cancelado . ' APODERADOS',
                "5" => 'S/.' . $reg->suma_cancelado,
                "6" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id_mensualidad_mes . ')">EDITAR</button>'

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
