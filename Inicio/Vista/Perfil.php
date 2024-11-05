<?php
ob_start();
session_start();

if (!isset($_SESSION['id']) || !isset($_SESSION['nombre'])) {
    header("Location: ../../Inicio/Controlador/Acceso.php?op=salir");
    exit();
}
?>
<?php include "../../General/Include/1_header.php"; ?>
<main class="container">
    <!-- TITULO -->
    <?php include "../../General/Include/3_body.php"; ?>

    <!-- CUERPO_INICIO -->
    <div class="my-3 p-3 bg-body rounded shadow-sm">
        <h5 class="border-bottom pb-2 mb-0"><b><?php echo $_SESSION['nombre']; ?> (PERFIL)</b></h5>
        <form id="frmPerfil" name="frmPerfil" method="post">
            <input type="hidden" id="id" name="id" value="<?php echo $_SESSION['id']; ?>" class="form-control">
            <br>
            <div class="p-3">
                <nav>
                    <div class="nav nav-tabs" id="nav-tab" role="tablist">
                        <button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">ACCESOS</button>
                        <button class="nav-link" id="nav-profile-tab" data-bs-toggle="tab" data-bs-target="#nav-profile" type="button" role="tab" aria-controls="nav-profile" aria-selected="false">DATOS PERSONALES</button>
                        <button class="nav-link" id="nav-infobancaria-tab" data-bs-toggle="tab" data-bs-target="#nav-infobancaria" type="button" role="tab" aria-controls="nav-infobancaria" aria-selected="false">INFO. BANCARIA</button>
                        <button class="nav-link" id="nav-contact-tab" data-bs-toggle="tab" data-bs-target="#nav-contact" type="button" role="tab" aria-controls="nav-contact" aria-selected="false">CONTACTO</button>
                    </div>
                </nav>
                <div class="tab-content" id="nav-tabContent">
                    <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab" tabindex="0">
                        <div class="p-3">
                            <label for="usuario" class="form-label"><b>USUARIO:</b></label>
                            <div class="input-group">
                                <input type="text" id="usuario" name="usuario" placeholder="Usuario" class="form-control">
                            </div>
                        </div>
                        <div class="p-3">
                            <label for="usuario" class="form-label"><b>CONTRASEÑA:</b></label>
                            <div class="input-group">
                                <input type="password" id="contraseña" name="contraseña" placeholder="Contraseña" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab" tabindex="0">
                        <div class="p-3">
                            <label for="dni" class="form-label"><b>DATOS PERSONALES:</b></label>
                            <div class="input-group">
                                <input type="text" id="dni" name="dni" placeholder="DNI" class="form-control" readonly>
                                <input type="text" id="nombre_apellido" name="nombre_apellido" placeholder="Nombre y Apellido" class="form-control" style="width: 50%;" readonly>
                            </div>
                        </div>
                        <div class="p-3">
                            <label for="nacimiento" class="form-label"><b>FECHA DE NACIMIENTO:</b></label>
                            <div class="input-group">
                                <input type="date" id="nacimiento" name="nacimiento" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="nav-infobancaria" role="tabpanel" aria-labelledby="nav-infobancaria-tab" tabindex="0">
                        <div class="p-3">
                            <label for="cuenta_bcp" class="form-label"><b>BCP:</b></label>
                            <div class="input-group">
                                <input type="text" id="cuenta_bcp" name="cuenta_bcp" placeholder="Cuenta BCP" class="form-control">
                                <input type="text" id="interbancario_bcp" name="interbancario_bcp" placeholder="Interbancario BCP" class="form-control">
                            </div>
                        </div>
                        <div class="p-3">
                            <label for="sunat_ruc" class="form-label"><b>SUNAT:</b></label>
                            <div class="input-group">
                                <input type="text" id="sunat_ruc" name="sunat_ruc" placeholder="SUNAT RUC" class="form-control">
                                <input type="text" id="sunat_usuario" name="sunat_usuario" placeholder="SUNAT Usuario" class="form-control">
                                <input type="text" id="sunat_contraseña" name="sunat_contraseña" placeholder="SUNAT Contraseña" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="nav-contact" role="tabpanel" aria-labelledby="nav-contact-tab" tabindex="0">
                        <div class="p-3">
                            <label for="direccion" class="form-label"><b>DIRECCIÓN:</b></label>
                            <div class="input-group">
                                <input type="text" id="direccion" name="direccion" placeholder="Dirección" class="form-control">
                            </div>
                        </div>
                        <div class="p-3">
                            <label for="telefono" class="form-label"><b>TELÉFONO Y CORREO:</b></label>
                            <div class="input-group">
                                <input type="text" id="telefono" name="telefono" placeholder="Teléfono" class="form-control">
                                <input type="email" id="correo" name="correo" placeholder="Correo" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="p-3">
                <button type="submit" class="btn btn-primary">Guardar</button>
                <button type="button" onclick="$(location).attr('href', 'Escritorio.php');" class="btn btn-secondary">Cancelar</button>
            </div>
        </form>
    </div>
    <!-- CUERPO_FIN -->
</main>
<?php include "../../General/Include/2_footer.php"; ?>
<script src="perfil.js"></script>
<?php
ob_end_flush();
?>