var link = "../Controlador/matricula_editar.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargarApoderados();
    cargarAlumnos();
    cargarCategorias();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
}

function cargarApoderados() {
    $.post(link + "listar_apoderados_activos", function (r) {
        $("#id_usuario_apoderado").html(r);
        $("#id_usuario_apoderado").selectpicker("refresh");
    });
}

function cargarAlumnos() {
    $.post(link + "listar_alumnos_activos", function (r) {
        $("#id_usuario_alumno").html(r);
        $("#id_usuario_alumno").selectpicker("refresh");
    });
}

function cargarCategorias() {
    $.post(link + "listar_categorias_activas", function (r) {
        $("#id_matricula_categoria").html(r);
        $("#id_matricula_categoria").selectpicker("refresh");
    });
}

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
});

function limpiar() {
    cargarApoderados();
    cargarAlumnos();
    cargarCategorias();
    $("#id").val("");
    $("#descripcion").val("");
    $("#id_matricula").val("");
    $("#id_matricula_categoria").val("");
    $("#id_usuario_apoderado_referido").val("");
    $("#id_usuario_apoderado").val("");
    $("#id_usuario_alumno").val("");
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
            $("#descripcion").val(data.descripcion);
            $("#id_matricula").val(data.id_matricula);
            $("#id_matricula_categoria").val(data.id_matricula_categoria);
            $("#id_usuario_apoderado_referido").val(data.id_usuario_apoderado_referido);
            $("#id_usuario_apoderado").val(data.id_usuario_apoderado);
            $("#id_usuario_alumno").val(data.id_usuario_alumno);
            $("#observaciones").val(data.observaciones);

            $("#id_usuario_apoderado").selectpicker("refresh");
            $("#id_usuario_alumno").selectpicker("refresh");
            $("#id_matricula_categoria").selectpicker("refresh");
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
