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

        <!-- LISTADO DE SALIDAS DE ALMACÉN -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>SALIDAS DE ALMACÉN - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>N°</th>
                            <th>APODERADO</th>
                            <th>COMPROBANTE</th>
                            <th>FECHA</th>
                            <th>METODO</th>
                            <th>ESTADO</th>
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

        <!-- FORMULARIO DE SALIDA -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>SALIDA DE ALMACÉN - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <input type="hidden" id="id" name="id" class="form-control">

                <!-- Pestañas para organización de campos -->
                <div class="p-3">
                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="general-tab" data-bs-toggle="tab" data-bs-target="#general-tab-pane" type="button" role="tab" aria-controls="general-tab-pane" aria-selected="true">DATOS GENERALES</button>
                        </li>
                    </ul>

                    <div class="tab-content" id="myTabContent">
                        <!-- TAB: DATOS GENERALES -->
                        <div class="tab-pane fade show active" id="general-tab-pane" role="tabpanel" aria-labelledby="general-tab">
                            <div class="p-3">
                                <label for="id_documento" class="form-label"><b>INFORMACION DEL COMPROBANTE:</b></label>
                                <div class="input-group">
                                    <select id="almacen_comprobante_id" name="almacen_comprobante_id" class="form-control" data-live-search="true" required></select>
                                    <input type="text" id="numeracion" name="numeracion" class="form-control" placeholder="Número de comprobante" required>
                                    <input type="date" id="fecha" name="fecha" class="form-control" required>
                                </div>
                            </div>

                            <div class="p-3">
                                <label for="usuario_apoderado_id" class="form-label"><b>APODERADO:</b></label>
                                <select id="usuario_apoderado_id" name="usuario_apoderado_id" class="form-control" data-live-search="true" required></select>
                            </div>

                            <div class="p-3">
                                <label for="id_documento" class="form-label"><b>INFORMACION DE PAGO:</b></label>
                                <div class="input-group">
                                <select id="almacen_metodo_pago_id" name="almacen_metodo_pago_id" class="form-control" data-live-search="true" required></select>
                                <input type="number" step="0.01" id="total" name="total" class="form-control" placeholder="Total" required>
                                </div>
                            </div>

                            <div class="p-3">
                                <label for="observaciones" class="form-label"><b>OBSERVACIONES:</b></label>
                                <textarea id="observaciones" name="observaciones" class="form-control" placeholder="Observaciones"></textarea>
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
    <script src="almacen_salida_editar.js"></script>
<?php
}
ob_end_flush();
?>