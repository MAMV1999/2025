<?php
include_once("../Modelo/Facturacion_alumno.php");

$facturacion_alumno = new Facturacion_alumno();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";

switch ($_GET["op"]) {

    case 'listar':
        $rspta = $facturacion_alumno->listar();
        $data = array();
        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => count($data) + 1,
                "1" => $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado,
                "2" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
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
