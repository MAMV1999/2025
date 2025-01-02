<?php
require_once("../../database.php");

class Recibosalida
{
    public function __construct()
    {
    }

    public function listar_almacen_salida($id)
    {
        $sql = "SELECT 
                    almacen_salida.id AS salida_id,
                    almacen_salida.usuario_apoderado_id AS apoderado_id,
                    usuario_apoderado.nombreyapellido AS apoderado_nombre,
                    almacen_salida.almacen_comprobante_id AS comprobante_id,
                    almacen_comprobante.nombre AS comprobante_nombre,
                    almacen_salida.numeracion AS salida_numeracion,
                    DATE_FORMAT(almacen_salida.fecha, '%d/%m/%Y') AS salida_fecha,
                    almacen_salida.almacen_metodo_pago_id AS metodo_pago_id,
                    almacen_metodo_pago.nombre AS metodo_pago_nombre,
                    almacen_salida.total AS salida_total,
                    almacen_salida.observaciones AS salida_observaciones,
                    almacen_salida.fechacreado AS salida_fechacreado,
                    almacen_salida.estado AS salida_estado
                FROM almacen_salida
                LEFT JOIN usuario_apoderado ON almacen_salida.usuario_apoderado_id = usuario_apoderado.id
                LEFT JOIN almacen_comprobante ON almacen_salida.almacen_comprobante_id = almacen_comprobante.id
                LEFT JOIN almacen_metodo_pago ON almacen_salida.almacen_metodo_pago_id = almacen_metodo_pago.id
                WHERE almacen_salida.id = '$id'";
        return ejecutarConsulta($sql);
    }    

    public function listar_almacen_salida_detalle($id)
    {
        $sql = "SELECT 
                    almacen_salida_detalle.id AS detalle_id,
                    almacen_salida_detalle.almacen_salida_id AS salida_id,
                    almacen_salida_detalle.almacen_producto_id AS producto_id,
                    almacen_producto.nombre AS producto_nombre,
                    almacen_salida_detalle.stock AS detalle_stock,
                    almacen_salida_detalle.precio_unitario AS detalle_precio_unitario,
                    almacen_salida_detalle.observaciones AS detalle_observaciones
                FROM almacen_salida_detalle
                LEFT JOIN almacen_producto ON almacen_salida_detalle.almacen_producto_id = almacen_producto.id
                WHERE almacen_salida_detalle.almacen_salida_id = '$id'";
        return ejecutarConsulta($sql);
    }
}
?>
