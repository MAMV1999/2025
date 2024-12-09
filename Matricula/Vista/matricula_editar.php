<?php
ob_start();
session_start();

if (!isset($_SESSION['nombre'])) {
    header("Location: ../../Inicio/Controlador/Acceso.php?op=salir");
} else {
?>
    <?php include "../../General/Include/1_header.php"; ?>
    <main class="container">
        <?php include "../../General/Include/3_body.php"; ?>

        <!-- Listado -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLES DE MATRÍCULA - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>MATRICULA</th>
                            <th>ALUMNO</th>
                            <th>APODERADO</th>
                            <th>CATEGORÍA</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <!-- Formulario -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLES DE MATRÍCULA - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <input type="hidden" id="id" name="id" placeholder="id" class="form-control">

                <div class="p-3">
                    <label for="descripcion" class="form-label"><b>DESCRIPCIÓN:</b></label>
                    <textarea id="descripcion" name="descripcion" class="form-control" placeholder="Descripción"></textarea>
                </div>

                <div class="p-3">
                    <label for="id_matricula" class="form-label"><b>MATRÍCULA:</b></label>
                    <input type="text" id="id_matricula" name="id_matricula" class="form-control">
                </div>

                <div class="p-3">
                    <label for="id_matricula_categoria" class="form-label"><b>CATEGORÍA:</b></label>
                    <select id="id_matricula_categoria" name="id_matricula_categoria" class="form-control selectpicker" data-live-search="true"></select>
                </div>

                <div class="p-3">
                    <label for="id_usuario_apoderado" class="form-label"><b>APODERADO:</b></label>
                    <select id="id_usuario_apoderado" name="id_usuario_apoderado" class="form-control selectpicker" data-live-search="true"></select>
                </div>

                <div class="p-3">
                    <label for="id_usuario_alumno" class="form-label"><b>ALUMNO:</b></label>
                    <select id="id_usuario_alumno" name="id_usuario_alumno" class="form-control selectpicker" data-live-search="true"></select>
                </div>

                <div class="p-3">
                    <label for="observaciones" class="form-label"><b>OBSERVACIONES:</b></label>
                    <textarea id="observaciones" name="observaciones" class="form-control" placeholder="Observaciones"></textarea>
                </div>

                <div class="p-3">
                    <button type="submit" class="btn btn-primary">Guardar</button>
                    <button type="button" onclick="MostrarListado();" class="btn btn-secondary">Cancelar</button>
                </div>
            </form>
        </div>
    </main>
    <?php include "../../General/Include/2_footer.php"; ?>
    <script src="matricula_editar.js"></script>
<?php
}
ob_end_flush();
?>
