var link = "../Controlador/almacen_ingreso.php?op=";
var tabla;
var tabla2;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
    fecha();
    listar_usuario_apoderado();
    listar_almacen_comprobante();
    listar_almacen_metodo_pago();
}

function numeracion() {
    $.post(link + "numeracion", function (data) {
        $("#numeracion").val(data); // Asignar el valor obtenido al campo
    });
}

function listar_usuario_apoderado() {
    $.post(link + "listar_usuario_apoderado", function (r) {
        $("#usuario_apoderado_id").html(r);
    });
}

function listar_almacen_comprobante() {
    $.post(link + "listar_almacen_comprobante", function (r) {
        $("#almacen_comprobante_id").html(r);
    });
}

function listar_almacen_metodo_pago() {
    $.post(link + "listar_almacen_metodo_pago", function (r) {
        $("#almacen_metodo_pago_id").html(r);
    });
}

function fecha() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear() + "-" + (month) + "-" + (day);
    $("#fecha").val(today);
}

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
    tabla2 = $("#myTable2").DataTable({
        ajax: link + "listar_almacen_producto",
    });
});

function limpiar() {

}

function MostrarListado() {
    limpiar();
    $("#listado").show();
    $("#formulario").hide();
}

function MostrarFormulario() {
    $("#listado").hide();
    $("#formulario").show();
    numeracion();
}

init();
