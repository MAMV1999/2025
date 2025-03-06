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
$referido_id = isset($_POST["apoderado_referido"]) ? limpiarcadena($_POST["apoderado_referido"]) : "0";
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
            $referido_id,
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

    case 'listar_apoderados_referido_activo':
        $rspta = $matriculaDetalle->listarApoderadosReferidoActivo();
        echo '<option value="">NO TIENE REFERENCIA</option>';
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombreyapellido . '</option>';
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
                "0" => count($data) + 1,
                "1" => $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado,
                "2" => $reg->nombre_alumno,
                "3" => $reg->nombre_apoderado,
                "4" => $reg->categoria,
                "5" => '
                        <div class="btn-group">
                        <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#' . $reg->numeracion_pago . '">DATOS</button>
                        <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split btn-sm" data-bs-toggle="dropdown" aria-expanded="false">
                            <span class="visually-hidden">Toggle Dropdown</span>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="../../Reportes/Vista/ReciboMatricula.php?id=' . $reg->matricula_detalle_id . '" Target="_blank">RECIBO ' . $reg->numeracion_pago . ' - ' . $reg->fecha_pago . '</a></li>
                            <li><a class="dropdown-item" href="../../Reportes/Vista/ReciboMatricula_copy.php?id=' . $reg->matricula_detalle_id . '" Target="_blank">FIRMA CONTRATO</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="../../Reportes/Vista/Constancia_vacante.php?id=' . $reg->matricula_detalle_id . '" Target="_blank">CONST. DE VACANTE</a></li>
                            <li><a class="dropdown-item" href="../../Reportes/Vista/Constancia_Matricula.php?id=' . $reg->matricula_detalle_id . '" Target="_blank">CONST. DE MATRICULA</a></li>
                            <li><a class="dropdown-item" href="../../Reportes/Vista/Constancia_Estudios.php?id=' . $reg->matricula_detalle_id . '" Target="_blank">CONST. DE ESTUDIOS</a></li>
                            <li><hr class="dropdown-divider"></li>
                        </ul>
                        </div>
                        
                        <!-- Modal -->
                        <div class="modal fade" id="' . $reg->numeracion_pago . '" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-xl">
                            <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="exampleModalLabel">' . $reg->nombre_apoderado . ' - ' . $reg->nombre_alumno . '</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                            <!-- body -->
                                <nav>
                                    <div class="nav nav-tabs" id="nav-tab" role="tablist">
                                        <button class="nav-link active" id="0001-tab" data-bs-toggle="tab" data-bs-target="#0001" type="button" role="tab" aria-controls="0001" aria-selected="true">INFORMACION</button>
                                    </div>
                                </nav>
                                <div class="tab-content" id="nav-tabContent">
                                    <div class="tab-pane fade show active" id="0001" role="tabpanel" aria-labelledby="0001-tab">
                                        <div class="p-3">
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" colspan="2" class="table-secondary">MATRICULA</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>INSTITUCION</td><td>' . $reg->institucion . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>MATRICULA</td><td>' . $reg->lectivo . ' - ' . $reg->nivel . ' - ' . $reg->grado . ' - ' . $reg->seccion . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>TIPO DE MATRICULA</td><td>' . $reg->categoria . '</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <hr>
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" colspan="2" class="table-secondary">APODERADO(A)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>DOCUMENTO</td><td>' . $reg->documento_apoderado . ' - ' . $reg->numero_documento_apoderado . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>NOMBRE</td><td>' . $reg->tipo_apoderado . ' - ' . $reg->nombre_apoderado . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>TELEFONO</td><td>' . $reg->telefono_apoderado . '</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <hr>
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" colspan="2" class="table-secondary">ALUMNO(A)</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>DOCUMENTO</td><td>' . $reg->documento_alumno . ' - ' . $reg->numero_documento_alumno . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>NOMBRE</td><td>' . $reg->nombre_alumno . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>NACIMIENTO</td><td>' . $reg->fecha_nacimiento . ' - ' . $reg->edad_alumno . ' AÑOS</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <hr>
                                            <table class="table table-bordered">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" colspan="2" class="table-secondary">PAGO</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td>N° RECIBO</td><td>N° ' . $reg->numeracion_pago . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>FECHA</td><td>' . $reg->fecha_pago . '</td>
                                                    </tr>
                                                    <tr>
                                                        <td>MONTO</td><td>S/. ' . $reg->monto_pago . ' - ' . $reg->metodo_pago . '</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <hr>
                                            <center>
                                            <button type="button" onclick="eliminarConValidacion(' . $reg->matricula_detalle_id . ')" class="btn btn-danger  btn-sm">ELIMINAR</button>
                                            </center>
                                        </div>
                                    </div>
                                </div>
                            <!-- fin-body -->
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">SALIR</button>
                            </div>
                            </div>
                        </div>
                        </div>'
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
                        <td style='width: 15%;'><input type='text' name='mensualidad_precio[]' class='form-control-plaintext precio-mensualidad' required data-mantenimiento='{$reg->mantenimiento}'></td>
                        <td style='width: 25%;'><input type='text' name='fechavencimiento_format[]' value='{$reg->fechavencimiento_format}' class='form-control-plaintext'></td>
                    </tr>";
        }
        echo $rows;
        break;

    case 'listar_apoderados_referidos_activos':
        $rspta = $matriculaDetalle->listarApoderadosReferidosActivos();
        echo '<option value="">NO TIENE REFERENCIA</option>'; // Primera opción vacía
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombreyapellido . ' (' . $reg->repeticiones . ')</option>';
        }
        break;
}
