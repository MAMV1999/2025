var link = "../Controlador/Matricula.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargar_secciones();
    cargar_docentes();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
}

function cargar_secciones() {
    $.post(link + "listar_secciones_activas", function (r) {
        $("#id_institucion_seccion").html(r);
        $("#id_institucion_seccion").selectpicker("refresh");
    });
}

function cargar_docentes() {
    $.post(link + "listar_docentes_activos", function (r) {
        $("#id_usuario_docente").html(r);
        $("#id_usuario_docente").selectpicker("refresh");
    });
}

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
});

function limpiar() {
    cargar_secciones();
    cargar_docentes();
    $("#id").val("");
    $("#id_institucion_seccion").val("");
    $("#id_usuario_docente").val("");
    $("#preciomatricula").val("");
    $("#preciomensualidad").val("");
    $("#preciomantenimiento").val("");
    $("#aforo").val("");
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
        { id: id },
        function (data, status) {
            data = JSON.parse(data);
            MostrarFormulario();

            $("#id").val(data.id);
            $("#id_institucion_seccion").val(data.id_institucion_seccion);
            $("#id_usuario_docente").val(data.id_usuario_docente);
            $("#preciomatricula").val(data.preciomatricula);
            $("#preciomensualidad").val(data.preciomensualidad);
            $("#preciomantenimiento").val(data.preciomantenimiento);
            $("#aforo").val(data.aforo);
            $("#observaciones").val(data.observaciones);
            $("#id_institucion_seccion").selectpicker("refresh");
            $("#id_usuario_docente").selectpicker("refresh");
        }
    );
}

function activar(id) {
    let condicion = confirm("¿ACTIVAR?");
    if (condicion === true) {
        $.ajax({
            type: "POST",
            url: link + "activar",
            data: { id: id },
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
            data: { id: id },
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
