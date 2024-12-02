<?php
include_once("../Modelo/matricula_detalle.php");

$matriculaDetalle = new MatriculaDetalle();

// Variables recibidas desde el formulario
$apoderado_id = isset($_POST["apoderado_id"]) ? limpiarcadena($_POST["apoderado_id"]) : "";
$apoderado_dni = isset($_POST["apoderado_dni"]) ? limpiarcadena($_POST["apoderado_dni"]) : "";
$apoderado_nombreyapellido = isset($_POST["apoderado_nombreyapellido"]) ? limpiarcadena($_POST["apoderado_nombreyapellido"]) : "";
$apoderado_telefono = isset($_POST["apoderado_telefono"]) ? limpiarcadena($_POST["apoderado_telefono"]) : "";
$apoderado_tipo = isset($_POST["apoderado_tipo"]) ? limpiarcadena($_POST["apoderado_tipo"]) : "";
$apoderado_documento = isset($_POST["apoderado_documento"]) ? limpiarcadena($_POST["apoderado_documento"]) : "";
$apoderado_sexo = isset($_POST["apoderado_sexo"]) ? limpiarcadena($_POST["apoderado_sexo"]) : "";
$apoderado_estado_civil = isset($_POST["apoderado_estado_civil"]) ? limpiarcadena($_POST["apoderado_estado_civil"]) : "";
$apoderado_usuario = isset($_POST["apoderado_usuario"]) ? limpiarcadena($_POST["apoderado_usuario"]) : "";
$apoderado_clave = isset($_POST["apoderado_clave"]) ? limpiarcadena($_POST["apoderado_clave"]) : "";
$apoderado_observaciones = isset($_POST["apoderado_observaciones"]) ? limpiarcadena($_POST["apoderado_observaciones"]) : "";

$alumno_id = isset($_POST["alumno_id"]) ? limpiarcadena($_POST["alumno_id"]) : "";
$alumno_dni = isset($_POST["alumno_dni"]) ? limpiarcadena($_POST["alumno_dni"]) : "";
$alumno_nombreyapellido = isset($_POST["alumno_nombreyapellido"]) ? limpiarcadena($_POST["alumno_nombreyapellido"]) : "";
$alumno_nacimiento = isset($_POST["alumno_nacimiento"]) ? limpiarcadena($_POST["alumno_nacimiento"]) : "";
$alumno_sexo = isset($_POST["alumno_sexo"]) ? limpiarcadena($_POST["alumno_sexo"]) : "";
$alumno_documento = isset($_POST["alumno_documento"]) ? limpiarcadena($_POST["alumno_documento"]) : "";
$alumno_telefono = isset($_POST["alumno_telefono"]) ? limpiarcadena($_POST["alumno_telefono"]) : "";
$alumno_usuario = isset($_POST["alumno_usuario"]) ? limpiarcadena($_POST["alumno_usuario"]) : "";
$alumno_clave = isset($_POST["alumno_clave"]) ? limpiarcadena($_POST["alumno_clave"]) : "";
$alumno_observaciones = isset($_POST["alumno_observaciones"]) ? limpiarcadena($_POST["alumno_observaciones"]) : "";

$detalle = isset($_POST["detalle"]) ? limpiarcadena($_POST["detalle"]) : "";
$matricula_id = isset($_POST["matricula_id"]) ? limpiarcadena($_POST["matricula_id"]) : "";
$matricula_categoria = isset($_POST["matricula_categoria"]) ? limpiarcadena($_POST["matricula_categoria"]) : "";
$matricula_observaciones = isset($_POST["matricula_observaciones"]) ? limpiarcadena($_POST["matricula_observaciones"]) : "";

$pago_numeracion = isset($_POST["pago_numeracion"]) ? limpiarcadena($_POST["pago_numeracion"]) : "";
$pago_fecha = isset($_POST["pago_fecha"]) ? limpiarcadena($_POST["pago_fecha"]) : "";
$pago_descripcion = isset($_POST["pago_descripcion"]) ? limpiarcadena($_POST["pago_descripcion"]) : "";
$pago_monto = isset($_POST["pago_monto"]) ? limpiarcadena($_POST["pago_monto"]) : "";
$pago_metodo_id = isset($_POST["pago_metodo_id"]) ? limpiarcadena($_POST["pago_metodo_id"]) : "";
$pago_observaciones = isset($_POST["pago_observaciones"]) ? limpiarcadena($_POST["pago_observaciones"]) : "";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        $rspta = $matriculaDetalle->guardar(
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
            $_POST["mensualidad_id"],
            $_POST["mensualidad_precio"],
            $apoderado_id,
            $alumno_id
        );
        echo $rspta ? "Matrícula registrada correctamente" : "No se pudo registrar la matrícula";
        break;

    case 'eliminar_con_validacion':
        $id_matricula_detalle = isset($_POST["id_matricula_detalle"]) ? limpiarcadena($_POST["id_matricula_detalle"]) : "";
        $contraseña = isset($_POST["contraseña"]) ? limpiarcadena($_POST["contraseña"]) : "";

        // Validar la contraseña utilizando el modelo
        if ($matriculaDetalle->validarContraseña($contraseña)) {
            // Si la contraseña es válida, eliminar el registro
            $rspta = $matriculaDetalle->eliminar($id_matricula_detalle);
            echo $rspta ? "Registro eliminado correctamente" : "No se pudo eliminar el registro";
        } else {
            echo "Contraseña inválida. No se realizó ninguna acción.";
        }
        break;


    case 'listar_apoderado_tipos_activos':
        $rspta = $matriculaDetalle->listarApoderadoTiposActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

        // Listar los documentos activos
    case 'listar_documentos_activos':
        $rspta = $matriculaDetalle->listarDocumentosActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

        // Listar los sexos activos
    case 'listar_sexos_activos':
        $rspta = $matriculaDetalle->listarSexosActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

        // Listar los estados civiles activos
    case 'listar_estados_civiles_activos':
        $rspta = $matriculaDetalle->listarEstadosCivilesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

        // Listar las matrículas activas
    case 'listar_matriculas_activas':
        $rspta = $matriculaDetalle->listarMatriculasActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '"
                            data-id="' . $reg->id . '"
                            data-lectivo="' . $reg->lectivo . '"
                            data-nivel="' . $reg->nivel . '"
                            data-grado="' . $reg->grado . '"
                            data-seccion="' . $reg->seccion . '"
                            data-aforo="' . $reg->aforo . '"
                            data-matriculados="' . $reg->matriculados . '"
                            data-preciomatricula="' . $reg->preciomatricula . '"
                            data-preciomensualidad="' . $reg->preciomensualidad . '"
                            data-preciomantenimiento="' . $reg->preciomantenimiento . '"
                            data-observaciones="' . $reg->observaciones . '"
                >' . $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado . ' - ' . $reg->seccion . ' -->(Aforo: ' . $reg->aforo . ', Matriculados: ' . $reg->matriculados . ')</option>';
        }
        break;

        // Listar las categorías de matrícula activas
    case 'listar_categorias_activas':
        $rspta = $matriculaDetalle->listarCategoriasActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

        // Listar los métodos de pago activos
    case 'listar_metodos_pago_activos':
        $rspta = $matriculaDetalle->listarMetodosPagoActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

    case 'listar':
        $rspta = $matriculaDetalle->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->lectivo_nombre . ' - ' . $reg->nivel_nombre . ' - ' . $reg->grado_nombre,
                "1" => $reg->apoderado_nombre,
                "2" => $reg->alumno_nombre,
                "3" => $reg->pago_numeracion . ' - ' . $reg->metodo_pago_nombre,
                "4" => '<button type="button" onclick="eliminarConValidacion(' . $reg->matricula_detalle_id . ')" class="btn btn-danger btn-sm">ELIMINAR</button>'
            );
        }

        $results = array(
            "sEcho" => 1,
            "iTotalRecords" => count($data),
            "iTotalDisplayRecords" => count($data),
            "aaData" => $data
        );
        echo json_encode($results);
        break;

    case 'obtener_siguiente_numeracion_pago':
        $numeracion = $matriculaDetalle->getNextPagoNumeracion();
        echo $numeracion;
        break;

    case 'buscar_apoderado':
        $dni = isset($_POST['dni']) ? limpiarcadena($_POST['dni']) : '';
        $rspta = $matriculaDetalle->buscarApoderadoPorDNI($dni);
        echo json_encode($rspta);
        break;

    case 'buscar_alumno':
        $dni = isset($_POST['dni']) ? limpiarcadena($_POST['dni']) : '';
        $rspta = $matriculaDetalle->buscarAlumnoPorDNI($dni);
        echo json_encode($rspta);
        break;

    case 'listar_mensualidades_activas':
        $rspta = $matriculaDetalle->listarMensualidadesActivas();
        $rows = "";
        while ($reg = $rspta->fetch_object()) {
            $rows .= "
                    <tr>
                        <td style='width: 10%;'><input type='text' name='mensualidad_id[]' value='{$reg->id}' class='form-control-plaintext' readonly></td>
                        <td style='width: 20%;'><input type='text' name='mensualidad_nombre[]' value='{$reg->nombre}' class='form-control-plaintext' readonly></td>
                        <td style='width: 30%;'><input type='text' name='descripcion[]' value='{$reg->descripcion}' class='form-control-plaintext' readonly></td>
                        <td style='width: 15%;'><input type='text' name='mensualidad_precio[]' class='form-control-plaintext precio-mensualidad' data-mantenimiento='{$reg->mantenimiento}'></td>
                        <td style='width: 25%;'><input type='text' name='fechavencimiento_format[]' value='{$reg->fechavencimiento_format}' class='form-control-plaintext'></td>
                    </tr>";
        }
        echo $rows;
        break;
}
