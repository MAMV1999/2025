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

        <!-- LISTADO DE DETALLES DE MATRÍCULA -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLES DE MATRÍCULA - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>DESCRIPCIÓN</th>
                            <th>CATEGORÍA</th>
                            <th>ALUMNO</th>
                            <th>APODERADO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>

            <small class="d-block text-end mt-3">
                <button type="button" onclick="MostrarFormulario();" class="btn btn-success">AGREGAR</button>
            </small>
        </div>

        <!-- FORMULARIO DE DETALLE DE MATRÍCULA -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLE DE MATRÍCULA - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <input type="hidden" id="id" name="id" class="form-control">

                <!-- Pestañas para organización de campos -->
                <div class="p-3">
                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="general-tab" data-bs-toggle="tab" data-bs-target="#general-tab-pane" type="button" role="tab" aria-controls="general-tab-pane" aria-selected="true">DATOS GENERALES</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="observaciones-tab" data-bs-toggle="tab" data-bs-target="#observaciones-tab-pane" type="button" role="tab" aria-controls="observaciones-tab-pane" aria-selected="false">OBSERVACIONES</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <!-- TAB: DATOS GENERALES -->
                        <div class="tab-pane fade show active" id="general-tab-pane" role="tabpanel" aria-labelledby="general-tab">
                            <div class="p-3">
                                <label for="descripcion" class="form-label"><b>DESCRIPCIÓN:</b></label>
                                <input type="text" id="descripcion" name="descripcion" class="form-control" placeholder="Descripción">
                            </div>

                            <div class="p-3">
                                <label for="id_matricula" class="form-label"><b>MATRÍCULA:</b></label>
                                <select id="id_matricula" name="id_matricula" class="form-control" data-live-search="true"></select>
                            </div>

                            <div class="p-3">
                                <label for="id_matricula_categoria" class="form-label"><b>CATEGORÍA:</b></label>
                                <select id="id_matricula_categoria" name="id_matricula_categoria" class="form-control" data-live-search="true"></select>
                            </div>

                            <div class="p-3">
                                <label for="id_usuario_alumno" class="form-label"><b>ALUMNO:</b></label>
                                <select id="id_usuario_alumno" name="id_usuario_alumno" class="form-control" data-live-search="true"></select>
                            </div>

                            <div class="p-3">
                                <label for="id_usuario_apoderado" class="form-label"><b>APODERADO:</b></label>
                                <select id="id_usuario_apoderado" name="id_usuario_apoderado" class="form-control" data-live-search="true"></select>
                            </div>
                        </div>

                        <!-- TAB: OBSERVACIONES -->
                        <div class="tab-pane fade" id="observaciones-tab-pane" role="tabpanel" aria-labelledby="observaciones-tab">
                            <div class="p-3">
                                <label for="observaciones" class="form-label"><b>OBSERVACIONES:</b></label>
                                <textarea id="observaciones" name="observaciones" class="form-control" rows="5" placeholder="Observaciones"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BOTONES DE ACCIÓN -->
                <div class="p-3">
                    <button type="submit" class="btn btn-primary">GUARDAR</button>
                    <button type="button" onclick="MostrarListado();" class="btn btn-secondary">CANCELAR</button>
                </div>
            </form>
        </div>
    </main>
    <?php include "../../General/Include/2_footer.php"; ?>
    <script src="matricula_detalle.js"></script>
<?php
}
ob_end_flush();
?>
