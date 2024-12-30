<?php
include_once("../Modelo/almacen_ingreso.php");

$almaceningreso = new AlmacenIngreso();

switch ($_GET["op"]) {

    case 'listar':
        $rspta = $almaceningreso->listar();
        $data = [];

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => count($data) + 1,
                "1" => $reg->nombre_apoderado,
                "2" => $reg->nombre_comprobante . ' - ' . $reg->numeracion,
                "3" => $reg->fecha,
                "4" => $reg->total,
                "5" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
            );
        }

        echo json_encode(array(
            "sEcho" => 1,
            "iTotalRecords" => count($data),
            "iTotalDisplayRecords" => count($data),
            "aaData" => $data
        ));
        break;

    case 'listar_almacen_producto':
        $rspta = $almaceningreso->listar_almacen_producto();
        $data = [];

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->producto,
                "1" => $reg->categoria,
                "2" => 'S./ ' . $reg->precio_compra,
                "3" => '" '.$reg->stock.' "',
                "4" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id_producto . ')">AGREGAR</button>'
            );
        }

        echo json_encode(array(
            "sEcho" => 1,
            "iTotalRecords" => count($data),
            "iTotalDisplayRecords" => count($data),
            "aaData" => $data
        ));
        break;

    case 'listar_usuario_apoderado':
        $rspta = $almaceningreso->listar_usuario_apoderado();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id_apoderado . '">' . $reg->nombreyapellido . '</option>';
        }
        break;

    case 'listar_almacen_comprobante':
        $rspta = $almaceningreso->listar_almacen_comprobante();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id_comprobante . '">' . $reg->nombre_comprobante . '</option>';
        }
        break;

    case 'listar_almacen_metodo_pago':
        $rspta = $almaceningreso->listar_almacen_metodo_pago();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id_metodo_pago . '">' . $reg->metodo_pago . '</option>';
        }
        break;

    case 'numeracion':
        $rspta = $almaceningreso->numeracion();
        echo $rspta;
        break;
}
