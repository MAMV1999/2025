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
        <h5 class="border-bottom pb-2 mb-0"><b>MATRÍCULAS - LISTADO</b></h5>
        <div class="p-3">
            <table class="table" id="myTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>PERIODO</th>
                        <th>NIVEL / GRADO / SECCION</th>
                        <th>DOCENTE</th>
                        <th>AFORO</th>
                        <th>ESTADO</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>

        <small class="d-block text-end mt-3">
            <button type="button" onclick="MostrarFormulario();cargar_secciones();cargar_docentes();" class="btn btn-success">Agregar</button>
        </small>
    </div>

    <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
        <h5 class="border-bottom pb-2 mb-0"><b>MATRÍCULAS - FORMULARIO</b></h5>
        <form id="frm_form" name="frm_form" method="post">
            <input type="hidden" id="id" name="id" placeholder="id" class="form-control">

            <div class="p-3">
                <label for="id_institucion_seccion" class="form-label"><b>SECCIÓN:</b></label>
                <div class="input-group">
                    <select id="id_institucion_seccion" name="id_institucion_seccion" class="form-control selectpicker" data-live-search="true"></select>
                </div>
            </div>

            <div class="p-3">
                <label for="id_usuario_docente" class="form-label"><b>DOCENTE:</b></label>
                <div class="input-group">
                    <select id="id_usuario_docente" name="id_usuario_docente" class="form-control selectpicker" data-live-search="true"></select>
                </div>
            </div>

            <div class="p-3">
                <label for="preciomatricula" class="form-label"><b>PRECIO MATRÍCULA:</b></label>
                <div class="input-group">
                    <input type="number" id="preciomatricula" name="preciomatricula" placeholder="Precio Matrícula" class="form-control" step="0.01">
                </div>
            </div>

            <div class="p-3">
                <label for="preciomensualidad" class="form-label"><b>PRECIO MENSUALIDAD:</b></label>
                <div class="input-group">
                    <input type="number" id="preciomensualidad" name="preciomensualidad" placeholder="Precio Mensualidad" class="form-control" step="0.01">
                </div>
            </div>

            <div class="p-3">
                <label for="preciomantenimiento" class="form-label"><b>PRECIO MANTENIMIENTO:</b></label>
                <div class="input-group">
                    <input type="number" id="preciomantenimiento" name="preciomantenimiento" placeholder="Precio Mantenimiento" class="form-control" step="0.01">
                </div>
            </div>

            <div class="p-3">
                <label for="aforo" class="form-label"><b>AFORO:</b></label>
                <div class="input-group">
                    <input type="number" id="aforo" name="aforo" placeholder="Aforo Máximo" class="form-control">
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
<script src="Matricula.js"></script>
<?php
}
ob_end_flush();
?>
