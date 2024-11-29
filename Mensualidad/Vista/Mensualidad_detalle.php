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
                <label for="id_mensualidad_mes" class="form-label"><b>MES:</b></label>
                <div class="input-group">
                    <select id="id_mensualidad_mes" name="id_mensualidad_mes" class="form-control selectpicker" data-live-search="true"></select>
                </div>
            </div>

            <div class="p-3">
                <label for="id_matricula_detalle" class="form-label"><b>DETALLE DE MATRÍCULA:</b></label>
                <div class="input-group">
                    <select id="id_matricula_detalle" name="id_matricula_detalle" class="form-control selectpicker" data-live-search="true"></select>
                </div>
            </div>

            <div class="p-3">
                <label for="monto" class="form-label"><b>MONTO:</b></label>
                <div class="input-group">
                    <input type="number" step="0.01" id="monto" name="monto" placeholder="Monto" class="form-control">
                </div>
            </div>

            <div class="p-3">
                <label for="pagado" class="form-label"><b>ESTADO:</b></label>
                <div class="input-group">
                    <select id="pagado" name="pagado" class="form-control">
                        <option value="1">Pagado</option>
                        <option value="0">Pendiente</option>
                    </select>
                </div>
            </div>

            <div class="p-3">
                <label for="observaciones" class="form-label"><b>OBSERVACIONES:</b></label>
                <div class="input-group">
                    <textarea id="observaciones" name="observaciones" placeholder="Observaciones" class="form-control"></textarea>
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
