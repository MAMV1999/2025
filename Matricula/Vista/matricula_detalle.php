<?php
ob_start();
session_start();

if (!isset($_SESSION['nombre'])) {
    header("Location: ../../Inicio/Controlador/Acceso.php?op=salir");
} else {
?>
    <?php include "../../General/Include/1_header.php"; ?>
    <main class="container">
        <!-- TÍTULO -->
        <?php include "../../General/Include/3_body.php"; ?>

        <!-- CUERPO_INICIO -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>MATRÍCULA DETALLE - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>GRADO</th>
                            <th>APODERADO</th>
                            <th>ALUMNO</th>
                            <th>RECIBO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
            <small class="d-block text-end mt-3">
                <button type="button" onclick="MostrarFormulario();" class="btn btn-success">Agregar</button>
            </small>
        </div>

        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>MATRÍCULA DETALLE - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <div class="p-3">
                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="matricula-tab" data-bs-toggle="tab" data-bs-target="#matricula-tab-pane" type="button" role="tab" aria-controls="matricula-tab-pane" aria-selected="false">MATRÍCULA</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="alumno-tab" data-bs-toggle="tab" data-bs-target="#alumno-tab-pane" type="button" role="tab" aria-controls="alumno-tab-pane" aria-selected="false">ALUMNO</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="apoderado-tab" data-bs-toggle="tab" data-bs-target="#apoderado-tab-pane" type="button" role="tab" aria-controls="apoderado-tab-pane" aria-selected="false">APODERADO</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pago-tab" data-bs-toggle="tab" data-bs-target="#pago-tab-pane" type="button" role="tab" aria-controls="pago-tab-pane" aria-selected="false">PAGO</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">



                        <!-- MATRÍCULA -->
                        <div class="tab-pane fade show active" id="matricula-tab-pane" role="tabpanel" aria-labelledby="matricula-tab">
                            <div class="p-3">
                                <label for="matricula_id" class="form-label"><b>MATRÍCULA:</b></label>
                                <select id="matricula_id" name="matricula_id" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="matricula_categoria" class="form-label"><b>CATEGORÍA:</b></label>
                                <select id="matricula_categoria" name="matricula_categoria" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="detalle" class="form-label"><b>DETALLE:</b></label>
                                <textarea name="detalle" id="detalle" class="form-control" placeholder="Observaciones - (Opcional)"></textarea>
                            </div>
                            <div class="p-3">
                                <label for="matricula_observaciones" class="form-label"><b>OBSERVACIONES:</b></label>
                                <textarea name="matricula_observaciones" id="matricula_observaciones" class="form-control" placeholder="Observaciones - (Opcional)"></textarea>
                            </div>
                        </div>

                        <!-- ALUMNO -->
                        <div class="tab-pane fade" id="alumno-tab-pane" role="tabpanel" aria-labelledby="alumno-tab">
                            <div class="p-3">
                                <label for="alumno_documento" class="form-label"><b>Tipo de Documento:</b></label>
                                <select id="alumno_documento" name="alumno_documento" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="alumno_dni" class="form-label"><b>DNI:</b></label>
                                <input type="text" id="alumno_dni" name="alumno_dni" class="form-control" placeholder="DNI">
                            </div>
                            <div class="p-3">
                                <label for="alumno_nombreyapellido" class="form-label"><b>Nombre y Apellido:</b></label>
                                <input type="text" id="alumno_nombreyapellido" name="alumno_nombreyapellido" class="form-control" placeholder="Nombre y Apellido">
                            </div>
                            <div class="p-3">
                                <label for="alumno_sexo" class="form-label"><b>Sexo:</b></label>
                                <select id="alumno_sexo" name="alumno_sexo" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="alumno_nacimiento" class="form-label"><b>Fecha de Nacimiento:</b></label>
                                <input type="date" id="alumno_nacimiento" name="alumno_nacimiento" class="form-control">
                            </div>
                            <div class="p-3">
                                <label for="alumno_observaciones" class="form-label"><b>Observaciones:</b></label>
                                <textarea id="alumno_observaciones" name="alumno_observaciones" class="form-control" placeholder="Observaciones - (Opcional)"></textarea>
                            </div>
                        </div>


                        <!-- APODERADO -->
                        <div class="tab-pane fade" id="apoderado-tab-pane" role="tabpanel" aria-labelledby="apoderado-tab">
                            <div class="p-3">
                                <label for="apoderado_tipo" class="form-label"><b>Tipo de Apoderado:</b></label>
                                <select id="apoderado_tipo" name="apoderado_tipo" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="apoderado_documento" class="form-label"><b>Tipo de Documento:</b></label>
                                <select id="apoderado_documento" name="apoderado_documento" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="apoderado_dni" class="form-label"><b>Número de Documento:</b></label>
                                <input type="text" id="apoderado_dni" name="apoderado_dni" class="form-control" placeholder="Número de Documento">
                            </div>
                            <div class="p-3">
                                <label for="apoderado_nombreyapellido" class="form-label"><b>Nombre y Apellido:</b></label>
                                <input type="text" id="apoderado_nombreyapellido" name="apoderado_nombreyapellido" class="form-control" placeholder="Nombre y Apellido">
                            </div>
                            <div class="p-3">
                                <label for="apoderado_telefono" class="form-label"><b>Teléfono:</b></label>
                                <input type="text" id="apoderado_telefono" name="apoderado_telefono" class="form-control" placeholder="Teléfono">
                            </div>
                            <div class="p-3">
                                <label for="apoderado_sexo" class="form-label"><b>Sexo:</b></label>
                                <select id="apoderado_sexo" name="apoderado_sexo" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="apoderado_estado_civil" class="form-label"><b>Estado Civil:</b></label>
                                <select id="apoderado_estado_civil" name="apoderado_estado_civil" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="apoderado_observaciones" class="form-label"><b>Observaciones:</b></label>
                                <textarea id="apoderado_observaciones" name="apoderado_observaciones" class="form-control" placeholder="Observaciones - (Opcional)"></textarea>
                            </div>
                        </div>



                        <!-- PAGO -->
                        <div class="tab-pane fade" id="pago-tab-pane" role="tabpanel" aria-labelledby="pago-tab">
                            <div class="p-3">
                                <label for="pago_numeracion" class="form-label"><b>Numeración:</b></label>
                                <input type="text" id="pago_numeracion" name="pago_numeracion" class="form-control" placeholder="Numeración">
                            </div>
                            <div class="p-3">
                                <label for="pago_fecha" class="form-label"><b>Fecha:</b></label>
                                <input type="date" id="pago_fecha" name="pago_fecha" class="form-control">
                            </div>
                            <div class="p-3">
                                <label for="pago_descripcion" class="form-label"><b>Descripción:</b></label>
                                <textarea id="pago_descripcion" name="pago_descripcion" class="form-control" placeholder="Descripción - (Opcional)"></textarea>
                            </div>
                            <div class="p-3">
                                <label for="pago_metodo_id" class="form-label"><b>Método de Pago:</b></label>
                                <select id="pago_metodo_id" name="pago_metodo_id" class="form-control" data-live-search="true"></select>
                            </div>
                            <div class="p-3">
                                <label for="pago_monto" class="form-label"><b>Monto:</b></label>
                                <input type="text" id="pago_monto" name="pago_monto" class="form-control" placeholder="Monto">
                            </div>
                            <div class="p-3">
                                <label for="pago_observaciones" class="form-label"><b>Observaciones:</b></label>
                                <textarea id="pago_observaciones" name="pago_observaciones" class="form-control" placeholder="Observaciones - (Opcional)"></textarea>
                            </div>
                        </div>




                    </div>
                </div>

                <div class="p-3">
                    <button type="submit" class="btn btn-primary">Guardar</button>
                    <button type="button" onclick="MostrarListado();" class="btn btn-secondary">Cancelar</button>
                </div>
            </form>
        </div>
        <!-- CUERPO_FIN -->
    </main>
    <?php include "../../General/Include/2_footer.php"; ?>
    <script src="matricula_detalle.js"></script>
<?php
}
ob_end_flush();
?>