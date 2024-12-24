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
                <table class="table table-hover text-center" id="myTable">
                    <thead>
                        <tr>
                            <th style="text-align: center;">ID</th>
                            <th style="text-align: center;">MES</th>
                            <th style="text-align: center;">DEUDORES</th>
                            <th style="text-align: center;">CANCELADO</th>
                            <th style="text-align: center;">ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>DETALLE DE MENSUALIDADES - FORMULARIO</b></h5>
            <form id="frm_form" name="frm_form" method="post">
                <br>
                <div class="table-responsive">
                    <table class="table table-hover" id="formulario-detalles">
                        <thead>
                            <tr>
                                <th>MATRICULA</th>
                                <th>APODERADO</th>
                                <th>TELEFONO</th>
                                <th>ALUMNO</th>
                                <th>CODIGO</th>
                                <th>MONTO</th>
                                <th>ESTADO</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Aquí se insertarán dinámicamente las filas -->
                        </tbody>
                    </table>
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
    <script src="mensualidad_x_mes.js"></script>
<?php
}
ob_end_flush();
?>