<?php
require_once("../../database.php");

class AlmacenIngreso
{
    public function __construct()
    {
    }

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
                    ua.id,
                    uat.nombre AS tipo_apoderado,
                    ud.nombre AS tipo_documento,
                    ua.numerodocumento,
                    ua.nombreyapellido,
                    ua.telefono,
                    us.nombre AS sexo,
                    uec.nombre AS estado_civil,
                    ua.usuario,
                    ua.clave,
                    ua.observaciones,
                    ua.fechacreado,
                    ua.estado
                FROM usuario_apoderado ua
                LEFT JOIN usuario_apoderado_tipo uat ON ua.id_apoderado_tipo = uat.id
                LEFT JOIN usuario_documento ud ON ua.id_documento = ud.id
                LEFT JOIN usuario_sexo us ON ua.id_sexo = us.id
                LEFT JOIN usuario_estado_civil uec ON ua.id_estado_civil = uec.id
                WHERE ua.estado = 1";
        return ejecutarConsulta($sql);
    }

    public function listar_almacen_comprobante()
    {
        $sql = "SELECT 
                    ac.id,
                    ac.nombre,
                    ac.observaciones,
                    ac.fechacreado,
                    ac.estado
                FROM almacen_comprobante ac
                WHERE ac.estado = 1";
        return ejecutarConsulta($sql);
    }

    public function listar_almacen_metodo_pago()
    {
        $sql = "SELECT 
                    amp.id,
                    amp.nombre,
                    amp.observaciones,
                    amp.fechacreado,
                    amp.estado
                FROM  almacen_metodo_pago amp
                WHERE amp.estado = 1";
        return ejecutarConsulta($sql);
    }

}
?>