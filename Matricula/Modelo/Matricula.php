<?php
require_once("../../database.php");

class Matricula
{
    public function __construct() {}

    // Método para guardar una nueva matrícula
    public function guardar($id_institucion_seccion, $id_usuario_docente, $preciomatricula, $preciomensualidad, $preciomantenimiento, $aforo, $observaciones)
    {
        $sql = "INSERT INTO matricula (id_institucion_seccion, id_usuario_docente, preciomatricula, preciomensualidad, preciomantenimiento, aforo, observaciones) 
                VALUES ('$id_institucion_seccion', '$id_usuario_docente', '$preciomatricula', '$preciomensualidad', '$preciomantenimiento', '$aforo', '$observaciones')";
        return ejecutarConsulta($sql);
    }

    // Método para editar una matrícula existente
    public function editar($id, $id_institucion_seccion, $id_usuario_docente, $preciomatricula, $preciomensualidad, $preciomantenimiento, $aforo, $observaciones)
    {
        $sql = "UPDATE matricula 
                SET id_institucion_seccion='$id_institucion_seccion', 
                    id_usuario_docente='$id_usuario_docente', 
                    preciomatricula='$preciomatricula', 
                    preciomensualidad='$preciomensualidad', 
                    preciomantenimiento='$preciomantenimiento', 
                    aforo='$aforo', 
                    observaciones='$observaciones' 
                WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para mostrar los detalles de una matrícula específica
    public function mostrar($id)
    {
        $sql = "SELECT * FROM matricula WHERE id='$id'";
        return ejecutarConsultaSimpleFila($sql);
    }

    // Método para listar todas las matrículas
    public function listar()
    {
        $sql = "SELECT 
                m.id, 
                l.nombre AS nombre_lectivo,
                n.nombre AS nombre_nivel,
                g.nombre AS nombre_grado,
                isec.nombre AS nombre_seccion,
                u.nombreyapellido AS docente_nombre,
                m.preciomatricula, 
                m.preciomensualidad, 
                m.preciomantenimiento, 
                m.aforo, 
                m.observaciones, 
                m.estado, 
                m.fechacreado
            FROM matricula m
            LEFT JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
            LEFT JOIN institucion_grado g ON isec.id_institucion_grado = g.id
            LEFT JOIN institucion_nivel n ON g.id_institucion_nivel = n.id
            LEFT JOIN institucion_lectivo l ON n.id_institucion_lectivo = l.id
            LEFT JOIN usuario_docente u ON m.id_usuario_docente = u.id";
        return ejecutarConsulta($sql);
    }


    // Método para desactivar una matrícula
    public function desactivar($id)
    {
        $sql = "UPDATE matricula SET estado='0' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    // Método para activar una matrícula
    public function activar($id)
    {
        $sql = "UPDATE matricula SET estado='1' WHERE id='$id'";
        return ejecutarConsulta($sql);
    }

    public function listarSeccionesActivas()
    {
        $sql = "SELECT 
                    s.id AS id_seccion,
                    s.nombre AS nombre_seccion,
                    g.nombre AS nombre_grado,
                    n.nombre AS nombre_nivel,
                    l.nombre AS nombre_lectivo
                FROM institucion_seccion s
                INNER JOIN institucion_grado g ON s.id_institucion_grado = g.id
                INNER JOIN institucion_nivel n ON g.id_institucion_nivel = n.id
                INNER JOIN institucion_lectivo l ON n.id_institucion_lectivo = l.id
                WHERE s.estado = '1' 
                  AND g.estado = '1' 
                  AND n.estado = '1' 
                  AND l.estado = '1'
                  AND s.id NOT IN (
                      SELECT id_institucion_seccion 
                      FROM matricula 
                      WHERE estado = '1'
                  )";
        return ejecutarConsulta($sql);
    }


    // Método para listar docentes activos con su cargo
    public function listarDocentesActivos()
    {
        $sql = "SELECT 
                    u.id AS id_docente, 
                    u.nombreyapellido AS nombre_docente, 
                    c.nombre AS nombre_cargo
                FROM usuario_docente u
                LEFT JOIN usuario_cargo c ON u.id_cargo = c.id
                WHERE u.estado = '1'";
        return ejecutarConsulta($sql);
    }
}
