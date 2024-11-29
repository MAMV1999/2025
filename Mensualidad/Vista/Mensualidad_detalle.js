var link = "../Controlador/Mensualidad_detalle.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargar_meses();
    cargar_matricula_detalles();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
}

function cargar_meses() {
    $.post(link + "listar_meses_activos", function (r) {
        $("#id_mensualidad_mes").html(r);
        $("#id_mensualidad_mes").selectpicker("refresh");
    });
}

function cargar_matricula_detalles() {
    $.post(link + "listar_matricula_detalles_activos", function (r) {
        $("#id_matricula_detalle").html(r);
        $("#id_matricula_detalle").selectpicker("refresh");
    });
}

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
});

function limpiar() {
    cargar_meses();
    cargar_matricula_detalles();
    $("#id").val("");
    $("#id_mensualidad_mes").val("");
    $("#id_matricula_detalle").val("");
    $("#monto").val("");
    $("#pagado").val("");
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
    limpiar();
}

function mostrar(id) {
    $.post(
        link + "mostrar",
        {
            id: id,
        },
        function (data, status) {
            data = JSON.parse(data);
            MostrarFormulario();

            $("#id").val(data.id);
            $("#id_mensualidad_mes").val(data.id_mensualidad_mes);
            $("#id_matricula_detalle").val(data.id_matricula_detalle);
            $("#monto").val(data.monto);
            $("#pagado").val(data.pagado);
            $("#observaciones").val(data.observaciones);

            $("#id_mensualidad_mes").selectpicker("refresh");
            $("#id_matricula_detalle").selectpicker("refresh");
        }
    );
}

function activar(id) {
    let condicion = confirm("¿ACTIVAR?");
    if (condicion === true) {
        $.ajax({
            type: "POST",
            url: link + "activar",
            data: {
                id: id,
            },
            success: function (datos) {
                alert(datos);
                tabla.ajax.reload();
            },
        });
    } else {
        alert("CANCELADO");
    }
}

function desactivar(id) {
    let condicion = confirm("¿DESACTIVAR?");
    if (condicion === true) {
        $.ajax({
            type: "POST",
            url: link + "desactivar",
            data: {
                id: id,
            },
            success: function (datos) {
                alert(datos);
                tabla.ajax.reload();
            },
        });
    } else {
        alert("CANCELADO");
    }
}

init();
