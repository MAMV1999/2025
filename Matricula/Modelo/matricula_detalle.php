<?php
require_once("../../database.php");

class MatriculaDetalle
{
    public function __construct() {}

    public function guardar(
        $apoderado_dni, $apoderado_nombreyapellido, $apoderado_telefono, $apoderado_tipo, $apoderado_documento, $apoderado_sexo, $apoderado_estado_civil, $apoderado_observaciones,
        $alumno_dni, $alumno_nombreyapellido, $alumno_nacimiento, $alumno_sexo, $alumno_documento, $alumno_telefono, $alumno_observaciones,
        $detalle, $matricula_id, $matricula_categoria, $matricula_observaciones,
        $pago_numeracion, $pago_fecha, $pago_descripcion, $pago_monto, $pago_metodo_id, $pago_observaciones
    ) {
        // Guardar usuario_apoderado
        $sql_apoderado = "INSERT INTO usuario_apoderado (numerodocumento, nombreyapellido, telefono, id_apoderado_tipo, id_documento, id_sexo, id_estado_civil, usuario, clave, observaciones, estado) VALUES ('$apoderado_dni', '$apoderado_nombreyapellido', '$apoderado_telefono', '$apoderado_tipo', '$apoderado_documento', '$apoderado_sexo', '$apoderado_estado_civil', '$apoderado_dni', '$apoderado_dni', '$apoderado_observaciones', '1')";
        $apoderado_id = ejecutarConsulta_retornarID($sql_apoderado);
    
        if ($apoderado_id) {
            // Guardar usuario_alumno
            $sql_alumno = "INSERT INTO usuario_alumno (id_apoderado, numerodocumento, nombreyapellido, nacimiento, id_documento, id_sexo, telefono, usuario, clave, observaciones, estado) VALUES ('$apoderado_id', '$alumno_dni', '$alumno_nombreyapellido', '$alumno_nacimiento', '$alumno_documento', '$alumno_sexo', '$alumno_telefono', '$alumno_dni', '$alumno_dni', '$alumno_observaciones', '1')";
            $alumno_id = ejecutarConsulta_retornarID($sql_alumno);
    
            if ($alumno_id) {
                // Guardar matricula_detalle
                $sql_matricula_detalle = "INSERT INTO matricula_detalle (id_usuario_apoderado, id_usuario_alumno, descripcion, id_matricula, id_matricula_categoria, observaciones, estado) VALUES ('$apoderado_id', '$alumno_id', '$detalle', '$matricula_id', '$matricula_categoria', '$matricula_observaciones', '1')";
                $matricula_detalle_id = ejecutarConsulta_retornarID($sql_matricula_detalle);
    
                if ($matricula_detalle_id) {
                    // Guardar matricula_pago
                    $sql_matricula_pago = "INSERT INTO matricula_pago (id_matricula_detalle, numeracion, fecha, descripcion, monto, id_matricula_metodo_pago, observaciones, estado) VALUES ('$matricula_detalle_id', '$pago_numeracion', '$pago_fecha', '$pago_descripcion', '$pago_monto', '$pago_metodo_id', '$pago_observaciones', '1')";
                    $pago_id = ejecutarConsulta_retornarID($sql_matricula_pago);
    
                    if ($pago_id) {
                        return true; // Todo se guardó correctamente
                    } else {
                        // Eliminar matricula_detalle si falla matricula_pago
                        $sql_eliminar_matricula_detalle = "DELETE FROM matricula_detalle WHERE id = '$matricula_detalle_id'";
                        ejecutarConsulta($sql_eliminar_matricula_detalle);
    
                        // Eliminar usuario_alumno
                        $sql_eliminar_alumno = "DELETE FROM usuario_alumno WHERE id = '$alumno_id'";
                        ejecutarConsulta($sql_eliminar_alumno);
    
                        // Eliminar usuario_apoderado
                        $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                        ejecutarConsulta($sql_eliminar_apoderado);
                    }
                } else {
                    // Eliminar usuario_alumno si falla matricula_detalle
                    $sql_eliminar_alumno = "DELETE FROM usuario_alumno WHERE id = '$alumno_id'";
                    ejecutarConsulta($sql_eliminar_alumno);
    
                    // Eliminar usuario_apoderado
                    $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                    ejecutarConsulta($sql_eliminar_apoderado);
                }
            } else {
                // Eliminar usuario_apoderado si falla usuario_alumno
                $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                ejecutarConsulta($sql_eliminar_apoderado);
            }
        }
    
        return false; // Falló en algún punto
    }
    

    public function listar()
    {
        $sql = "SELECT 
                    md.id AS matricula_detalle_id,
                    md.estado AS matricula_detalle_estado,
                    i.nombre AS institucion_nombre,
                    il.nombre AS institucion_lectivo_nombre,
                    iniv.nombre AS institucion_nivel_nombre,
                    ig.nombre AS institucion_grado_nombre,
                    isec.nombre AS institucion_seccion_nombre,
                    mc.nombre AS matricula_categoria_nombre,
                    mp.numeracion AS matricula_pago_numeracion,
                    mp.fecha AS matricula_pago_fecha,
                    mp.descripcion AS matricula_pago_descripcion,
                    mp.monto AS matricula_pago_monto,
                    ua.nombreyapellido AS alumno_nombre,
                    uap.nombreyapellido AS apoderado_nombre
                FROM matricula_detalle md
                INNER JOIN matricula m ON md.id_matricula = m.id
                INNER JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
                INNER JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
                INNER JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                INNER JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                INNER JOIN institucion i ON il.id_institucion = i.id
                INNER JOIN matricula_categoria mc ON md.id_matricula_categoria = mc.id
                INNER JOIN matricula_pago mp ON md.id = mp.id_matricula_detalle
                INNER JOIN usuario_alumno ua ON md.id_usuario_alumno = ua.id
                INNER JOIN usuario_apoderado uap ON md.id_usuario_apoderado = uap.id
                WHERE md.estado = '1'
                  AND m.estado = '1'
                  AND isec.estado = '1'
                  AND ig.estado = '1'
                  AND iniv.estado = '1'
                  AND il.estado = '1'
                  AND i.estado = '1'
                  AND mc.estado = '1'
                  AND mp.estado = '1'
                  AND ua.estado = '1'
                  AND uap.estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar los tipos de apoderado activos
    public function listarApoderadoTiposActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_apoderado_tipo WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar los documentos activos
    public function listarDocumentosActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_documento WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar los sexos activos
    public function listarSexosActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_sexo WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar los estados civiles activos
    public function listarEstadosCivilesActivos()
    {
        $sql = "SELECT id, nombre FROM usuario_estado_civil WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar las matrículas activas
    public function listarMatriculasActivas()
    {
        $sql = "SELECT 
                m.id,
                CONCAT(il.nombre, ' - ', iniv.nombre, ' - ', ig.nombre, ' - ', isec.nombre) AS nombre
            FROM matricula m
            INNER JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
            INNER JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
            INNER JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
            INNER JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
            WHERE m.estado = '1'";
        return ejecutarConsulta($sql);
    }


    // Función para listar las categorías de matrícula activas
    public function listarCategoriasActivas()
    {
        $sql = "SELECT id, nombre FROM matricula_categoria WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Función para listar los métodos de pago activos
    public function listarMetodosPagoActivos()
    {
        $sql = "SELECT id, nombre FROM matricula_metodo_pago WHERE estado = '1'";
        return ejecutarConsulta($sql);
    }
}
