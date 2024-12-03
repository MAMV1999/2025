<?php
require_once("../../database.php");

class MatriculaDetalle
{
    public function __construct() {}

    public function guardar(
        $apoderado_dni,
        $apoderado_nombreyapellido,
        $apoderado_telefono,
        $apoderado_tipo,
        $apoderado_documento,
        $apoderado_sexo,
        $apoderado_estado_civil,
        $apoderado_observaciones,
        $alumno_dni,
        $alumno_nombreyapellido,
        $alumno_nacimiento,
        $alumno_sexo,
        $alumno_documento,
        $alumno_telefono,
        $alumno_observaciones,
        $detalle,
        $matricula_id,
        $matricula_categoria,
        $matricula_observaciones,
        $pago_numeracion,
        $pago_fecha,
        $pago_descripcion,
        $pago_monto,
        $pago_metodo_id,
        $pago_observaciones,

        $mensualidad_id, // Array con los mensualidad_id de las mensualidades
        $mensualidad_precio, // Array con los mensualidad_precio de las mensualidades
        $apoderado_id = null, // ID de apoderado (si ya existe)
        $alumno_id = null // ID de alumno (si ya existe)
    ) {
        // Validar si ya existe el ID del apoderado
        if (!$apoderado_id) {
            $sql_apoderado = "INSERT INTO usuario_apoderado (numerodocumento, nombreyapellido, telefono, id_apoderado_tipo, id_documento, id_sexo, id_estado_civil, usuario, clave, observaciones, estado) VALUES ('$apoderado_dni', '$apoderado_nombreyapellido', '$apoderado_telefono', '$apoderado_tipo', '$apoderado_documento', '$apoderado_sexo', '$apoderado_estado_civil', '$apoderado_dni', '$apoderado_dni', '$apoderado_observaciones', '1')";
            $apoderado_id = ejecutarConsulta_retornarID($sql_apoderado);

            if (!$apoderado_id) {
                return false; // Falló al guardar apoderado
            }
        }

        // Validar si ya existe el ID del alumno
        if (!$alumno_id) {
            $sql_alumno = "INSERT INTO usuario_alumno (id_apoderado, numerodocumento, nombreyapellido, nacimiento, id_documento, id_sexo, telefono, usuario, clave, observaciones, estado) VALUES ('$apoderado_id', '$alumno_dni', '$alumno_nombreyapellido', '$alumno_nacimiento', '$alumno_documento', '$alumno_sexo', '$alumno_telefono', '$alumno_dni', '$alumno_dni', '$alumno_observaciones', '1')";
            $alumno_id = ejecutarConsulta_retornarID($sql_alumno);

            if (!$alumno_id) {
                // Eliminar apoderado si falla la creación del alumno
                $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                ejecutarConsulta($sql_eliminar_apoderado);
                return false;
            }
        }

        // Guardar matricula_detalle
        $sql_matricula_detalle = "INSERT INTO matricula_detalle (id_usuario_apoderado, id_usuario_alumno, descripcion, id_matricula, id_matricula_categoria, observaciones, estado) VALUES ('$apoderado_id', '$alumno_id', '$detalle', '$matricula_id', '$matricula_categoria', '$matricula_observaciones', '1')";
        $matricula_detalle_id = ejecutarConsulta_retornarID($sql_matricula_detalle);

        if ($matricula_detalle_id) {
            // Guardar matricula_pago
            $sql_matricula_pago = "INSERT INTO matricula_pago (id_matricula_detalle, numeracion, fecha, descripcion, monto, id_matricula_metodo_pago, observaciones, estado) VALUES ('$matricula_detalle_id', '$pago_numeracion', '$pago_fecha', '$pago_descripcion', '$pago_monto', '$pago_metodo_id', '$pago_observaciones', '1')";
            $pago_id = ejecutarConsulta_retornarID($sql_matricula_pago);

            if ($pago_id) {
                // Guardar varias filas en mensualidad_detalle
                foreach ($mensualidad_id as $index => $mensualidad_mes_id) {
                    $precio = $mensualidad_precio[$index];
                    $sql_mensualidad_detalle = "INSERT INTO mensualidad_detalle (id_mensualidad_mes, id_matricula_detalle, monto, pagado, observaciones, estado) VALUES ('$mensualidad_mes_id', '$matricula_detalle_id', '$precio', '0', '', '1')";

                    if (!ejecutarConsulta($sql_mensualidad_detalle)) {
                        // Si falla, eliminar todos los registros creados
                        $sql_eliminar_pago = "DELETE FROM matricula_pago WHERE id = '$pago_id'";
                        ejecutarConsulta($sql_eliminar_pago);

                        $sql_eliminar_matricula_detalle = "DELETE FROM matricula_detalle WHERE id = '$matricula_detalle_id'";
                        ejecutarConsulta($sql_eliminar_matricula_detalle);

                        $sql_eliminar_alumno = "DELETE FROM usuario_alumno WHERE id = '$alumno_id'";
                        ejecutarConsulta($sql_eliminar_alumno);

                        $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                        ejecutarConsulta($sql_eliminar_apoderado);

                        return false;
                    }
                }

                return true; // Todo se guardó correctamente
            } else {
                // Eliminar matricula_detalle si falla matricula_pago
                $sql_eliminar_matricula_detalle = "DELETE FROM matricula_detalle WHERE id = '$matricula_detalle_id'";
                ejecutarConsulta($sql_eliminar_matricula_detalle);

                $sql_eliminar_alumno = "DELETE FROM usuario_alumno WHERE id = '$alumno_id'";
                ejecutarConsulta($sql_eliminar_alumno);

                $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
                ejecutarConsulta($sql_eliminar_apoderado);
            }
        } else {
            // Eliminar usuario_alumno si falla matricula_detalle
            $sql_eliminar_alumno = "DELETE FROM usuario_alumno WHERE id = '$alumno_id'";
            ejecutarConsulta($sql_eliminar_alumno);

            $sql_eliminar_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$apoderado_id'";
            ejecutarConsulta($sql_eliminar_apoderado);
        }

        return false; // Falló en algún punto
    }


    public function buscarApoderadoPorDNI($dni)
    {
        $sql = "SELECT * FROM usuario_apoderado WHERE numerodocumento = '$dni' AND estado = '1'";
        $result = ejecutarConsultaSimpleFila($sql);
        return $result ? $result : [];
    }

    public function buscarAlumnoPorDNI($dni)
    {
        $sql = "SELECT * FROM usuario_alumno WHERE numerodocumento = '$dni' AND estado = '1'";
        $result = ejecutarConsultaSimpleFila($sql);
        return $result ? $result : [];
    }

    public function listar()
    {
        $sql = "SELECT
            md.id AS matricula_detalle_id,
            i.nombre AS institucion_nombre,
            il.nombre AS lectivo_nombre,
            iniv.nombre AS nivel_nombre,
            ig.nombre AS grado_nombre,
            isec.nombre AS seccion_nombre,
            ua.nombreyapellido AS alumno_nombre,
            uap.nombreyapellido AS apoderado_nombre,
            mp.numeracion AS pago_numeracion,
            mp.fecha AS pago_fecha,
            mp.descripcion AS pago_descripcion,
            mp.monto AS pago_monto,
            mtp.nombre AS metodo_pago_nombre,
            mp.observaciones AS pago_observaciones,
            md.estado AS matricula_detalle_estado
            FROM matricula_detalle md
            INNER JOIN matricula m ON md.id_matricula = m.id
            INNER JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
            INNER JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
            INNER JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
            INNER JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
            INNER JOIN institucion i ON il.id_institucion = i.id
            INNER JOIN matricula_categoria mc ON md.id_matricula_categoria = mc.id
            INNER JOIN matricula_pago mp ON md.id = mp.id_matricula_detalle
            INNER JOIN matricula_metodo_pago mtp ON mp.id_matricula_metodo_pago = mtp.id
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
                    il.nombre AS lectivo,
                    iniv.nombre AS nivel,
                    ig.nombre AS grado,
                    isec.nombre AS seccion,
                    m.aforo,
                    (SELECT COUNT(*) FROM matricula_detalle WHERE id_matricula = m.id AND estado = 1) AS matriculados,
                    m.preciomatricula,
                    m.preciomensualidad,
                    m.preciomantenimiento,
                    m.observaciones
                FROM matricula m
                INNER JOIN institucion_seccion isec ON m.id_institucion_seccion = isec.id
                INNER JOIN institucion_grado ig ON isec.id_institucion_grado = ig.id
                INNER JOIN institucion_nivel iniv ON ig.id_institucion_nivel = iniv.id
                INNER JOIN institucion_lectivo il ON iniv.id_institucion_lectivo = il.id
                WHERE m.estado = '1'";
        return ejecutarConsulta($sql);
    }

    // Método para listar los apoderados activos referidos
    public function listarApoderadosReferidoActivo()
    {
        $sql = "SELECT id, nombreyapellido FROM usuario_apoderado WHERE estado = '1'";
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

    public function getNextPagoNumeracion()
    {
        $sql = "SELECT LPAD(IFNULL(MAX(CAST(numeracion AS UNSIGNED)) + 1, 1), 6, '0') AS numeracion FROM matricula_pago";
        $result = ejecutarConsultaSimpleFila($sql);
        return $result ? $result['numeracion'] : '000001';
    }

    public function listarMensualidadesActivas()
    {
        $sql = "SELECT 
                    mm.id AS id,
                    mm.nombre AS mensualidad_nombre,
                    DATE_FORMAT(mm.fechavencimiento, '%d/%m/%Y') AS fechavencimiento_format,
                    CASE 
                        WHEN mm.pago_mantenimiento = 1 THEN CONCAT(mm.descripcion, ' + MANTENIMIENTO')
                        ELSE mm.descripcion
                    END AS descripcion,
                    mm.pago_mantenimiento AS mantenimiento,
                    mm.observaciones AS observaciones,
                    mm.fechacreado AS fechacreado,
                    mm.estado AS estado,
                    il.nombre AS lectivo_nombre,
                    CONCAT(mm.nombre, ' ', il.nombre) AS nombre
                FROM 
                    mensualidad_mes mm
                JOIN 
                    institucion_lectivo il ON mm.id_institucion_lectivo = il.id;";
        return ejecutarConsulta($sql);
    }

    public function validarContraseña($contraseña)
    {
        $sql = "SELECT COUNT(*) AS total FROM institucion_validacion WHERE nombre = '$contraseña' AND estado = '1'";
        $resultado = ejecutarConsultaSimpleFila($sql);
        return $resultado['total'] > 0;
    }


    public function eliminar($id_matricula_detalle)
    {
        // Obtener los IDs de usuario_apoderado y usuario_alumno desde matricula_detalle
        $sql_obtener_ids = "SELECT id_usuario_apoderado, id_usuario_alumno FROM matricula_detalle WHERE id = '$id_matricula_detalle'";
        $resultado = ejecutarConsultaSimpleFila($sql_obtener_ids);
        $id_apoderado = $resultado['id_usuario_apoderado'];
        $id_alumno = $resultado['id_usuario_alumno'];

        // Eliminar registros relacionados en mensualidad_detalle
        $sql_mensualidad_detalle = "DELETE FROM mensualidad_detalle WHERE id_matricula_detalle = '$id_matricula_detalle'";
        ejecutarConsulta($sql_mensualidad_detalle);

        // Eliminar registros relacionados en matricula_pago
        $sql_matricula_pago = "DELETE FROM matricula_pago WHERE id_matricula_detalle = '$id_matricula_detalle'";
        ejecutarConsulta($sql_matricula_pago);

        // Eliminar registro en matricula_detalle
        $sql_matricula_detalle = "DELETE FROM matricula_detalle WHERE id = '$id_matricula_detalle'";
        ejecutarConsulta($sql_matricula_detalle);

        // Eliminar registros relacionados en usuario_alumno
        $sql_alumno = "DELETE FROM usuario_alumno WHERE id = '$id_alumno'";
        ejecutarConsulta($sql_alumno);

        // Eliminar registros relacionados en usuario_apoderado
        $sql_apoderado = "DELETE FROM usuario_apoderado WHERE id = '$id_apoderado'";
        ejecutarConsulta($sql_apoderado);

        return true;
    }
}
