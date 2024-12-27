<?php
include_once("../Modelo/almacen_producto.php");

$almacenProducto = new AlmacenProducto();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$nombre = isset($_POST["nombre"]) ? limpiarcadena($_POST["nombre"]) : "";
$descripcion = isset($_POST["descripcion"]) ? limpiarcadena($_POST["descripcion"]) : "";
$categoria_id = isset($_POST["categoria_id"]) ? limpiarcadena($_POST["categoria_id"]) : "";
$precio_compra = isset($_POST["precio_compra"]) ? limpiarcadena($_POST["precio_compra"]) : "";
$precio_venta = isset($_POST["precio_venta"]) ? limpiarcadena($_POST["precio_venta"]) : "";
$stock = isset($_POST["stock"]) ? limpiarcadena($_POST["stock"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $almacenProducto->guardar($nombre, $descripcion, $categoria_id, $precio_compra, $precio_venta, $stock, $estado);
            echo $rspta ? "Producto registrado correctamente" : "No se pudo registrar el producto";
        } else {
            $rspta = $almacenProducto->editar($id, $nombre, $descripcion, $categoria_id, $precio_compra, $precio_venta, $stock, $estado);
            echo $rspta ? "Producto actualizado correctamente" : "No se pudo actualizar el producto";
        }
        break;

    case 'desactivar':
        $rspta = $almacenProducto->desactivar($id);
        echo $rspta ? "Producto desactivado correctamente" : "No se pudo desactivar el producto";
        break;

    case 'activar':
        $rspta = $almacenProducto->activar($id);
        echo $rspta ? "Producto activado correctamente" : "No se pudo activar el producto";
        break;

    case 'mostrar':
        $rspta = $almacenProducto->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $almacenProducto->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->nombre,
                "1" => $reg->categoria,
                "2" => "S/. " . number_format($reg->precio_compra, 2),
                "3" => "S/. " . number_format($reg->precio_venta, 2),
                "4" => $reg->stock,
                "5" => ($reg->estado)
                    ? '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-danger btn-sm" onclick="desactivar(' . $reg->id . ')">DESACTIVAR</button>'
                    : '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-success btn-sm" onclick="activar(' . $reg->id . ')">ACTIVAR</button>'
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

    case 'listar_categorias_activas':
        $rspta = $almacenProducto->listarCategoriasActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;
}
?>
