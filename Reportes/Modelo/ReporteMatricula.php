<?php
require_once("../../database.php");

class ReporteMatricula
{
    public function __construct() {}

    public function listar()
    {
        $sql = "SELECT 
                    il.nombre AS lectivo,
                    iniv.nombre AS nivel,
                    ig.nombre AS grado,
                    IFNULL(us.nombreyapellido, 'SIN ALUMNOS') AS alumno
                FROM 
                    institucion_grado ig
                JOIN 
                    institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                JOIN 
                    institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                LEFT JOIN 
                    institucion_seccion isec ON ig.id = isec.id_institucion_grado
                LEFT JOIN 
                    matricula m ON isec.id = m.id_institucion_seccion
                LEFT JOIN 
                    matricula_detalle md ON m.id = md.id_matricula AND md.estado = '1'
                LEFT JOIN 
                    usuario_alumno us ON md.id_usuario_alumno = us.id
                ORDER BY 
                    il.nombre ASC, 
                    iniv.nombre ASC, 
                    ig.nombre ASC, 
                    alumno ASC";
        return ejecutarConsulta($sql);
    }
}
