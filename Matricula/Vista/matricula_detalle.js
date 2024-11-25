var link = "../Controlador/matricula_detalle.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    cargarSelectores(); // Cargar selectores dinámicos al inicializar
    fecha();
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

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
});

function fecha() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear() + "-" + (month) + "-" + (day);
    $("#pago_fecha").val(today);
}

function limpiar() {
    $("#apoderado_tipo").val("");
    $("#apoderado_documento").val("");
    $("#apoderado_sexo").val("");
    $("#apoderado_estado_civil").val("");
    $("#apoderado_dni").val("");
    $("#apoderado_nombreyapellido").val("");
    $("#apoderado_telefono").val("");
    $("#apoderado_observaciones").val("");

    $("#alumno_documento").val("");
    $("#alumno_sexo").val("");
    $("#alumno_dni").val("");
    $("#alumno_nombreyapellido").val("");
    $("#alumno_nacimiento").val("");
    $("#alumno_telefono").val("");
    $("#alumno_observaciones").val("");

    $("#matricula_id").val("");
    $("#matricula_categoria").val("");
    $("#matricula_observaciones").val("");

    $("#pago_numeracion").val("");
    $("#pago_fecha").val("");
    $("#pago_descripcion").val("");
    $("#pago_monto").val("");
    $("#pago_observaciones").val("");
}

function MostrarListado() {
    limpiar();
    $("#listado").show();
    $("#formulario").hide();
}

// Llamar a esta función al mostrar el formulario
function MostrarFormulario() {
    $("#listado").hide();
    $("#formulario").show();
    cargarSelectores();
    fecha();

    // Cargar la numeración del pago
    cargarSiguienteNumeracionPago();

    setTimeout(function () {
        InformacionDetalle();
    }, 200);
}

// Cargar datos en los selectores dinámicos
function cargarSelectores() {
    cargarApoderadoTipos();
    cargarDocumentos();
    cargarSexos();
    cargarEstadosCiviles();
    cargarMatriculas();
    cargarCategorias();
    cargarMetodosPago();
}

// Apoderado - Tipos
function cargarApoderadoTipos() {
    $.post(link + "listar_apoderado_tipos_activos", function (r) {
        $("#apoderado_tipo").html(r);
    });
}

// Documentos
function cargarDocumentos() {
    $.post(link + "listar_documentos_activos", function (r) {
        $("#apoderado_documento, #alumno_documento").html(r);
    });
}

// Sexos
function cargarSexos() {
    $.post(link + "listar_sexos_activos", function (r) {
        $("#apoderado_sexo, #alumno_sexo").html(r);
    });
}

// Estados Civiles
function cargarEstadosCiviles() {
    $.post(link + "listar_estados_civiles_activos", function (r) {
        $("#apoderado_estado_civil").html(r);
    });
}

// Matrículas
function cargarMatriculas() {
    $.post(link + "listar_matriculas_activas", function (r) {
        $("#matricula_id").html(r);
    });

    $("#matricula_id").change(function () {
        InformacionDetalle();
    });
}

function InformacionDetalle(){
    var selectedOption = $("#matricula_id option:selected");
    var lectivo = selectedOption.data('lectivo');
    var nivel = selectedOption.data('nivel');
    var grado = selectedOption.data('grado');
    var seccion = selectedOption.data('seccion');
    var preciomatricula = selectedOption.data('preciomatricula');
    var preciomensualidad = selectedOption.data('preciomensualidad');
    var preciomantenimiento = selectedOption.data('preciomantenimiento');
    var observaciones = selectedOption.data('observaciones');

    var info_matricula = 'MATRICULA: ' + lectivo + ' - ' + nivel + ' - ' + grado + ' - ' + seccion + '\n' +
        'Precio Matricula: S./' + preciomatricula + '\n'+
        'Precio Mensualidad: S./' + preciomensualidad + '\n'+
        'Precio Mantenimiento: S./' + preciomantenimiento + '\n\n'+
        'Observaciones: ' + observaciones + '\n';

    $("#pago_monto").val(preciomatricula);
    $("#detalle").val(info_matricula);
    $("#pago_descripcion").val(info_matricula);
}

// Categorías
function cargarCategorias() {
    $.post(link + "listar_categorias_activas", function (r) {
        $("#matricula_categoria").html(r);
    });
}

// Métodos de Pago
function cargarMetodosPago() {
    $.post(link + "listar_metodos_pago_activos", function (r) {
        $("#pago_metodo_id").html(r);
    });
}

function cargarSiguienteNumeracionPago() {
    $.post(link + "obtener_siguiente_numeracion_pago", function (data) {
        $("#pago_numeracion").val(data); // Asignar el valor obtenido al campo
    });
}

init();
