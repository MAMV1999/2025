<?php
require_once("../../database.php");

class Apoderadosmatriculados
{
    public function __construct()
    {
    }

    public function listar()
    {
        $sql = "SELECT DISTINCT 
                    ua.nombreyapellido AS nombre_apoderado,
                    ua.telefono
                FROM 
                    matricula_detalle md
                INNER JOIN 
                    usuario_apoderado ua ON md.id_usuario_apoderado = ua.id
                WHERE 
                    md.estado = 1
                    AND ua.estado = 1
                ORDER BY 
                    ua.nombreyapellido ASC";
        return ejecutarConsulta($sql);
    }
}
?>
