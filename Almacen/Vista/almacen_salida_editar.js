var link = "../Controlador/almacen_salida_editar.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargarApoderados();
    cargarComprobantes();
    cargarMetodosPago();
}

function cargarApoderados() {
    $.post(link + "listar_apoderados_activos", function (r) {
        $("#usuario_apoderado_id").html(r);
    });
}

function cargarComprobantes() {
    $.post(link + "listar_comprobantes_activos", function (r) {
        $("#almacen_comprobante_id").html(r);
    });
}

function cargarMetodosPago() {
    $.post(link + "listar_metodos_pago_activos", function (r) {
        $("#almacen_metodo_pago_id").html(r);
    });
}

$(document).ready(function () {
    tabla = $('#myTable').DataTable({
        "ajax": {
            "url": link + "listar",
            "dataSrc": function (json) {
                return json.aaData;
            }
        }
    });
});

function limpiar() {
    $("#id").val("");
    $("#numeracion").val("");
    $("#fecha").val("");
    $("#total").val("");
    $("#observaciones").val("");
}

function MostrarListado() {
    limpiar();
    $("#listado").show();
    $("#formulario").hide();
}

function MostrarFormulario() {
    $("#listado").hide();
    $("#formulario").show();
}

function guardaryeditar(e) {
    e.preventDefault();
    $.ajax({
        url: link + "guardaryeditar",
        type: "POST",
        data: $("#frm_form").serialize(),
        success: function (datos) {
            alert(datos);
            MostrarListado();
            tabla.ajax.reload();
        },
    });
}

function mostrar(id) {
    $.post(link + "mostrar", { id: id }, function (data, status) {
        data = JSON.parse(data);
        MostrarFormulario();

        $("#id").val(data.id);
        $("#usuario_apoderado_id").val(data.usuario_apoderado_id);
        $("#almacen_comprobante_id").val(data.almacen_comprobante_id);
        $("#numeracion").val(data.numeracion);
        $("#fecha").val(data.fecha);
        $("#almacen_metodo_pago_id").val(data.almacen_metodo_pago_id);
        $("#total").val(data.total);
        $("#observaciones").val(data.observaciones);
    });
}

function activar(id) {
    if (confirm("¿ACTIVAR?")) {
        $.post(link + "activar", { id: id }, function (datos) {
            alert(datos);
            tabla.ajax.reload();
        });
    }
}

function desactivar(id) {
    if (confirm("¿DESACTIVAR?")) {
        $.post(link + "desactivar", { id: id }, function (datos) {
            alert(datos);
            tabla.ajax.reload();
        });
    }
}

init();
