<?php
require_once("../../database.php");

class AlmacenIngreso
{
    public function __construct() {}

    public function listar()
    {
        $sql = "SELECT 
                    ai.id,
                    ua.nombreyapellido AS nombre_apoderado,
                    ac.nombre AS nombre_comprobante,
                    ai.numeracion,
                    ai.fecha,
                    ai.impuesto,
                    amp.nombre AS metodo_pago,
                    ai.total,
                    ai.observaciones,
                    ai.fechacreado,
                    ai.estado
                FROM almacen_ingreso ai
                LEFT JOIN usuario_apoderado ua ON ai.usuario_apoderado_id = ua.id
                LEFT JOIN almacen_comprobante ac ON ai.almacen_comprobante_id = ac.id
                LEFT JOIN almacen_metodo_pago amp ON ai.almacen_metodo_pago_id = amp.id";
        return ejecutarConsulta($sql);
    }

    public function listar_usuario_apoderado()
    {
        $sql = "SELECT 
                    ua.id AS id_apoderado,
                    ua.id_apoderado_tipo,
                    uat.nombre AS tipo_apoderado,
                    ua.id_documento,
                    ud.nombre AS documento,
                    ua.numerodocumento,
                    ua.nombreyapellido,
                    ua.telefono,
                    ua.id_sexo,
                    us.nombre AS sexo,
                    ua.id_estado_civil,
                    uec.nombre AS estado_civil,
                    ua.usuario,
                    ua.clave,
                    ua.observaciones,
                    ua.fechacreado,
                    ua.estado
                FROM usuario_apoderado ua
                INNER JOIN usuario_documento ud ON ua.id_documento = ud.id AND ud.estado = 1
                INNER JOIN usuario_sexo us ON ua.id_sexo = us.id AND us.estado = 1
                INNER JOIN usuario_estado_civil uec ON ua.id_estado_civil = uec.id AND uec.estado = 1
                INNER JOIN usuario_apoderado_tipo uat ON ua.id_apoderado_tipo = uat.id AND uat.estado = 1
                WHERE ua.estado = 1
                ORDER BY ua.nombreyapellido ASC";
        return ejecutarConsulta($sql);
    }

    public function listar_almacen_comprobante()
    {
        $sql = "SELECT 
                    ac.id AS id_comprobante,
                    ac.nombre AS nombre_comprobante,
                    ac.observaciones,
                    ac.fechacreado,
                    ac.estado
                FROM almacen_comprobante ac
                WHERE ac.estado = 1
                ORDER BY ac.nombre ASC";
        return ejecutarConsulta($sql);
    }

    public function listar_almacen_metodo_pago()
    {
        $sql = "SELECT 
                    amp.id AS id_metodo_pago,
                    amp.nombre AS metodo_pago,
                    amp.observaciones,
                    amp.fechacreado,
                    amp.estado
                FROM almacen_metodo_pago amp
                WHERE amp.estado = 1
                ORDER BY amp.nombre ASC";
        return ejecutarConsulta($sql);
    }

    public function listar_almacen_producto()
    {
        $sql = "SELECT 
                ap.id AS id_producto,
                ap.nombre AS producto,
                ap.descripcion,
                ap.categoria_id,
                ac.nombre AS categoria,
                ap.precio_compra,
                ap.precio_venta,
                ap.stock,
                ap.fechacreado,
                ap.estado
                FROM almacen_producto ap
                INNER JOIN almacen_categoria ac ON ap.categoria_id = ac.id AND ac.estado = 1
                WHERE ap.estado = 1
                ORDER BY ap.nombre ASC";
        return ejecutarConsulta($sql);
    }

    public function numeracion()
    {
        $sql = "SELECT LPAD(IFNULL(MAX(CAST(numeracion AS UNSIGNED)) + 1, 1), 6, '0') AS numeracion FROM almacen_ingreso";
        $result = ejecutarConsultaSimpleFila($sql);
        return $result ? $result['numeracion'] : '000001';
    }
}
