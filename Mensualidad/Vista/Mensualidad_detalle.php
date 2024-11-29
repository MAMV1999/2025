<?php
ob_start();
session_start();

if (!isset($_SESSION['nombre'])) {
    header("Location: ../../Inicio/Controlador/Acceso.php?op=salir");
} else {
?>
    <?php include "../../General/Include/1_header.php"; ?>
    <main class="container">
        <!-- TITULO -->
        <?php include "../../General/Include/3_body.php"; ?>

        <!-- CUERPO_INICIO -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLE DE MENSUALIDADES - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>MATRICULA</th>
                            <th>APODERADO</th>
                            <th>ALUMNO</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>

            <small class="d-block text-end mt-3">
                <button type="button" onclick="MostrarFormulario();limpiar();" class="btn btn-success">Agregar</button>
            </small>
        </div>

        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLE DE MENSUALIDADES - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <input type="hidden" id="id" name="id" placeholder="id" class="form-control">

                <div class="p-3">
                    <label for="generalInfo" class="form-label"><b>DETALLES GENERALES:</b></label>
                    <div class="p-3">
                        <p><b>MATRICULA:</b></p>
                        <ul>
                            <li><span id="lectivo"></span> / <span id="nivel"></span> / <span id="grado"></span> ( <span id="seccion"></span> )</li>
                        </ul>
                        <p><b>APODERADO:</b></p>
                        <ul>
                            <li><b>DOCUMENTO:</b> <span id="apoderado_tipo_documento"></span> - <span id="apoderado_numerodocumento"></span></li>
                            <li><b>NOMBRE Y APELLIDO:</b> <span id="apoderado_nombreyapellido"></span></li>
                            <li><b>TELÉFONO:</b> <span id="apoderado_telefono"></span></li>
                        </ul>
                        <p><b>ALUMNO:</b></p>
                        <ul>
                            <li><b>DOCUMENTO:</b> <span id="alumno_tipo_documento"></span> - <span id="alumno_numerodocumento"></span></li>
                            <li><b>NOMBRE Y APELLIDO:</b> <span id="alumno_nombreyapellido"></span></li>
                        </ul>
                    </div>
                </div>

                <div class="p-3">
                    <label for="detallesRelacionados" class="form-label"><b>DETALLES RELACIONADOS:</b></label>
                    <div class="input-group">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>N°</th>
                                    <th>MES</th>
                                    <th>VENCIMIENTO</th>
                                    <th>MONTO</th>
                                    <th>PAGADO</th>
                                    <th>OBSERVACIONES</th>
                                </tr>
                            </thead>
                            <tbody id="detallesRelacionados"></tbody>
                        </table>
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
    <script src="Mensualidad_detalle.js"></script>
<?php
}
ob_end_flush();
?>