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
        <h5 class="border-bottom pb-2 mb-0"><b>PAGOS DE MATRÍCULA - LISTADO</b></h5>
        <div class="p-3">
            <table class="table" id="myTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>NUMERACIÓN</th>
                        <th>FECHA</th>
                        <th>DESCRIPCIÓN</th>
                        <th>MONTO</th>
                        <th>MÉTODO DE PAGO</th>
                        <th>ESTADO</th>
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
        <h5 class="border-bottom pb-2 mb-0"><b>PAGOS DE MATRÍCULA - FORMULARIO</b></h5>
        <form id="frm_form" name="frm_form" method="post">
            <input type="hidden" id="id" name="id" placeholder="id" class="form-control">

            <div class="p-3">
                <label for="id_matricula_detalle" class="form-label"><b>DETALLE DE MATRÍCULA:</b></label>
                <div class="input-group">
                    <select id="id_matricula_detalle" name="id_matricula_detalle" class="form-control selectpicker" data-live-search="true"></select>
                </div>
            </div>

            <div class="p-3">
                <label for="numeracion" class="form-label"><b>NUMERACIÓN:</b></label>
                <div class="input-group">
                    <input type="text" id="numeracion" name="numeracion" placeholder="Numeración" class="form-control">
                </div>
            </div>

            <div class="p-3">
                <label for="fecha" class="form-label"><b>FECHA:</b></label>
                <div class="input-group">
                    <input type="date" id="fecha" name="fecha" class="form-control">
                </div>
            </div>

            <div class="p-3">
                <label for="descripcion" class="form-label"><b>DESCRIPCIÓN:</b></label>
                <div class="input-group">
                    <textarea id="descripcion" name="descripcion" placeholder="Descripción" class="form-control"></textarea>
                </div>
            </div>

            <div class="p-3">
                <label for="monto" class="form-label"><b>MONTO:</b></label>
                <div class="input-group">
                    <input type="number" step="0.01" id="monto" name="monto" placeholder="Monto" class="form-control">
                </div>
            </div>

            <div class="p-3">
                <label for="id_matricula_metodo_pago" class="form-label"><b>MÉTODO DE PAGO:</b></label>
                <div class="input-group">
                    <select id="id_matricula_metodo_pago" name="id_matricula_metodo_pago" class="form-control selectpicker" data-live-search="true"></select>
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
<script src="Matricula_pago.js"></script>
<?php
}
ob_end_flush();
?>
