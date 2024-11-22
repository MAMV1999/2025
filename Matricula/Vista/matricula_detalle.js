var link = "../Controlador/matricula_detalle.php?op=";
var tabla;

function init() {
    // Configuración del formulario
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargarMatriculas();
    cargarCategorias();
    cargarAlumnos();
    cargarApoderados();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
}

// Funciones para cargar datos dinámicos en los selects
function cargarMatriculas() {
    $.post(link + "listar_matriculas_activas", function (r) {
        $("#id_matricula").html(r);
    });
}

function cargarCategorias() {
    $.post(link + "listar_categorias_activas", function (r) {
        $("#id_matricula_categoria").html(r);
    });
}

function cargarAlumnos() {
    $.post(link + "listar_alumnos_activos", function (r) {
        $("#id_usuario_alumno").html(r);
    });
}

function cargarApoderados() {
    $.post(link + "listar_apoderados_activos", function (r) {
        $("#id_usuario_apoderado").html(r);
    });
}

$(document).ready(function () {
    // Inicialización de DataTable
    tabla = $('#myTable').DataTable({
        "ajax": {
            "url": link + "listar",
            "dataSrc": function (json) {
                console.log(json); // Verifica la estructura de la respuesta aquí
                return json.aaData; // Asegúrate de que 'aaData' esté correctamente formado en el controlador
            }
        }
    });
});

// Función para limpiar el formulario
function limpiar() {
    cargarMatriculas();
    cargarCategorias();
    cargarAlumnos();
    cargarApoderados();

    $("#id").val("");
    $("#descripcion").val("");
    $("#id_matricula").val("");
    $("#id_matricula_categoria").val("");
    $("#id_usuario_apoderado").val("");
    $("#id_usuario_alumno").val("");
    $("#observaciones").val("");
}

// Función para mostrar el listado y ocultar el formulario
function MostrarListado() {
    limpiar();
    $("#listado").show();
    $("#formulario").hide();
}

// Función para mostrar el formulario y ocultar el listado
function MostrarFormulario() {
    $("#listado").hide();
    $("#formulario").show();
}

// Función para guardar o editar un detalle de matrícula
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

// Función para mostrar un detalle de matrícula específico
function mostrar(id) {
    $.post(link + "mostrar", { id: id }, function (data, status) {
        data = JSON.parse(data);
        MostrarFormulario();

        $("#id").val(data.id);
        $("#descripcion").val(data.descripcion);
        $("#id_matricula").val(data.id_matricula);
        $("#id_matricula_categoria").val(data.id_matricula_categoria);
        $("#id_usuario_apoderado").val(data.id_usuario_apoderado);
        $("#id_usuario_alumno").val(data.id_usuario_alumno);
        $("#observaciones").val(data.observaciones);

        // Refrescar selects para que se muestren los valores seleccionados
        $("#id_matricula").selectpicker("refresh");
        $("#id_matricula_categoria").selectpicker("refresh");
        $("#id_usuario_apoderado").selectpicker("refresh");
        $("#id_usuario_alumno").selectpicker("refresh");
    });
}

// Función para activar un detalle de matrícula
function activar(id) {
    let condicion = confirm("¿ACTIVAR?");
    if (condicion === true) {
        $.post(link + "activar", { id: id }, function (datos) {
            alert(datos);
            tabla.ajax.reload();
        });
    }
}

// Función para desactivar un detalle de matrícula
function desactivar(id) {
    let condicion = confirm("¿DESACTIVAR?");
    if (condicion === true) {
        $.post(link + "desactivar", { id: id }, function (datos) {
            alert(datos);
            tabla.ajax.reload();
        });
    }
}

init();
