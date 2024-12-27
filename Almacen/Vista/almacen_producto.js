var link = "../Controlador/almacen_producto.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargarCategorias();
}

function cargarCategorias() {
    $.post(link + "listar_categorias_activas", function (r) {
        $("#categoria_id").html(r);
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
    $("#nombre").val("");
    $("#descripcion").val("");
    $("#categoria_id").val("");
    $("#precio_compra").val("");
    $("#precio_venta").val("");
    $("#stock").val("");
    cargarCategorias();
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
        $("#nombre").val(data.nombre);
        $("#descripcion").val(data.descripcion);
        $("#categoria_id").val(data.categoria_id);
        $("#precio_compra").val(data.precio_compra);
        $("#precio_venta").val(data.precio_venta);
        $("#stock").val(data.stock);
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
