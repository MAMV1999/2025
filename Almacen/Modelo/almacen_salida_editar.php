<?php
require_once("../../database.php");

class AlmacenSalida
{
    public function __construct() {}

    // Método para registrar una nueva salida de almacén
    public function guardar($usuario_apoderado_id, $almacen_comprobante_id, $numeracion, $fecha, $almacen_metodo_pago_id, $total, $observaciones)
    {
        $sql = "INSERT INTO almacen_salida (usuario_apoderado_id, almacen_comprobante_id, numeracion, fecha, almacen_metodo_pago_id, total, observaciones)
        VALUES ('$usuario_apoderado_id', '$almacen_comprobante_id', '$numeracion', '$fecha', '$almacen_metodo_pago_id', '$total', '$observaciones')";
        return ejecutarConsulta($sql);
    }

    // Método para editar una salida existente
    public function editar($id, $usuario_apoderado_id, $almacen_comprobante_id, $numeracion, $fecha, $almacen_metodo_pago_id, $total, $observaciones)
    {
        $sql = "UPDATE almacen_salida SET usuario_apoderado_id='$usuario_apoderado_id', almacen_comprobante_id='$almacen_comprobante_id', numeracion='$numeracion',
        fecha='$fecha', almacen_metodo_pago_id='$almacen_metodo_pago_id', total='$total', observaciones='$observaciones' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de una salida específica
    public function mostrar($id)
    {
        $sql = "SELECT * FROM almacen_salida WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todas las salidas
    public function listar()
    {
        $sql = "SELECT 
                    asd.id,
                    ua.nombreyapellido AS nombre_apoderado,
                    ac.nombre AS nombre_comprobante,
                    asd.numeracion,
                    DATE_FORMAT(asd.fecha, '%d/%m/%Y') AS fecha,
                    amp.nombre AS metodo_pago,
                    asd.total,
                    asd.observaciones,
                    asd.fechacreado,
                    asd.estado,
                    CASE 
                        WHEN asd.estado = 1 THEN 'ACTIVO'
                        WHEN asd.estado = 0 THEN 'ANULADO'
                        ELSE 'DESCONOCIDO'
                    END AS estado_descripcion
                FROM almacen_salida asd
                LEFT JOIN usuario_apoderado ua ON asd.usuario_apoderado_id = ua.id
                LEFT JOIN almacen_comprobante ac ON asd.almacen_comprobante_id = ac.id
                LEFT JOIN almacen_metodo_pago amp ON asd.almacen_metodo_pago_id = amp.id
                ORDER BY asd.fecha DESC, asd.numeracion DESC";
        return ejecutarConsulta($sql);
    }

    // Método para desactivar una salida
    public function desactivar($id)
    {
        $sql = "UPDATE almacen_salida SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar una salida
    public function activar($id)
    {
        $sql = "UPDATE almacen_salida SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    public function listarApoderadosActivos()
    {
        $sql = "SELECT id, nombreyapellido FROM usuario_apoderado WHERE estado='1'";
        return ejecutarConsulta($sql);
    }

    public function listarComprobantesActivos()
    {
        $sql = "SELECT id, nombre FROM almacen_comprobante WHERE estado='1'";
        return ejecutarConsulta($sql);
    }

    public function listarMetodosPagoActivos()
    {
        $sql = "SELECT id, nombre FROM almacen_metodo_pago WHERE estado='1'";
        return ejecutarConsulta($sql);
    }
}
