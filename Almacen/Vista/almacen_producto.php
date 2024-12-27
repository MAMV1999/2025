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

        <!-- LISTADO DE PRODUCTOS -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="listado">
            <h5 class="border-bottom pb-2 mb-0"><b>PRODUCTOS - LISTADO</b></h5>
            <div class="p-3">
                <table class="table" id="myTable">
                    <thead>
                        <tr>
                            <th>NOMBRE</th>
                            <th>CATEGORÍA</th>
                            <th>PRECIO COMPRA</th>
                            <th>PRECIO VENTA</th>
                            <th>STOCK</th>
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

        <!-- FORMULARIO DE PRODUCTO -->
        <div class="my-3 p-3 bg-body rounded shadow-sm" id="formulario">
            <h5 class="border-bottom pb-2 mb-0"><b>PRODUCTO - FORMULARIO</b></h5>
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
                                <label for="nombre" class="form-label"><b>NOMBRE:</b></label>
                                <input type="text" id="nombre" name="nombre" class="form-control" placeholder="Nombre del producto" required>
                            </div>

                            <div class="p-3">
                                <label for="descripcion" class="form-label"><b>DESCRIPCIÓN:</b></label>
                                <textarea id="descripcion" name="descripcion" class="form-control" placeholder="Descripción del producto"></textarea>
                            </div>

                            <div class="p-3">
                                <label for="categoria_id" class="form-label"><b>CATEGORÍA:</b></label>
                                <select id="categoria_id" name="categoria_id" class="form-control" data-live-search="true" required></select>
                            </div>

                            <div class="p-3">
                                <label for="precio_compra" class="form-label"><b>PRECIO COMPRA:</b></label>
                                <input type="number" step="0.01" id="precio_compra" name="precio_compra" class="form-control" placeholder="Precio de compra" required>
                            </div>

                            <div class="p-3">
                                <label for="precio_venta" class="form-label"><b>PRECIO VENTA:</b></label>
                                <input type="number" step="0.01" id="precio_venta" name="precio_venta" class="form-control" placeholder="Precio de venta" required>
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
    <script src="almacen_producto.js"></script>
<?php
}
ob_end_flush();
?>
