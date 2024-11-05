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
            <h5 class="border-bottom pb-2 mb-0"><b>CB EBENEZER</b></h5>
            <div class="d-flex text-body-secondary pt-3">
                <div class="card text-center w-100">
                    <div class="card-header">
                        <br>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title"><?php echo $_SESSION['nombre']; ?></h5>
                        <p class="card-text"><?php echo $_SESSION['cargo']; ?></p>
                    </div>
                    <div class="card-footer text-body-secondary">
                        <br>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <?php include "../../General/Include/2_footer.php"; ?>
    <script>
        function init() {
            actualizarFechaHora();
            setInterval(actualizarFechaHora, 1000);
        }

        init();
    </script>
<?php
}
ob_end_flush();
?>