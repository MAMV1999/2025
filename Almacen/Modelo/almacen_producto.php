<?php
require_once("../../database.php");

class AlmacenProducto
{
    public function __construct()
    {
    }

    // Método para guardar un nuevo producto
    public function guardar($nombre, $descripcion, $categoria_id, $precio_compra, $precio_venta, $stock = 0, $estado = 1)
    {
        $sql = "INSERT INTO almacen_producto (nombre, descripcion, categoria_id, precio_compra, precio_venta, stock, estado) VALUES ('$nombre', '$descripcion', '$categoria_id', '$precio_compra', '$precio_venta', '$stock', '$estado')";
        return ejecutarConsulta($sql);
    }
    

    // Método para editar un producto existente
    public function editar($id, $nombre, $descripcion, $categoria_id, $precio_compra, $precio_venta, $stock, $estado)
    {
        $sql = "UPDATE almacen_producto SET nombre='$nombre', descripcion='$descripcion', categoria_id='$categoria_id', precio_compra='$precio_compra', precio_venta='$precio_venta', stock='$stock', estado='$estado' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de un producto específico
    public function mostrar($id)
    {
        $sql = "SELECT * FROM almacen_producto WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todos los productos
    public function listar()
    {
        $sql = "SELECT p.id, p.nombre, p.descripcion, c.nombre AS categoria, p.precio_compra, p.precio_venta, p.stock, p.estado FROM almacen_producto p INNER JOIN almacen_categoria c ON p.categoria_id = c.id";
        return ejecutarConsulta($sql);
    }

    // Método para desactivar un producto
    public function desactivar($id)
    {
        $sql = "UPDATE almacen_producto SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar un producto
    public function activar($id)
    {
        $sql = "UPDATE almacen_producto SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para listar las categorías activas
    public function listarCategoriasActivas()
    {
        $sql = "SELECT id, nombre FROM almacen_categoria WHERE estado='1'";
        return ejecutarConsulta($sql);
    }
}
?>
