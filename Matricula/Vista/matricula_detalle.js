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
        actualizarPreciosMensualidad();
    });
}

function InformacionDetalle() {
    var selectedOption = $("#matricula_id option:selected");
    var lectivo = selectedOption.data('lectivo');
    var nivel = selectedOption.data('nivel');
    var grado = selectedOption.data('grado');
    var seccion = selectedOption.data('seccion');
    var preciomatricula = selectedOption.data('preciomatricula');
    var preciomensualidad = selectedOption.data('preciomensualidad');
    var preciomantenimiento = selectedOption.data('preciomantenimiento');
    var observaciones = selectedOption.data('observaciones');

    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = (day) + "/" + (month) + "/" + now.getFullYear();

    var info_matricula = 'MATRICULA ' + lectivo +' - '+ today+'\n' +
        'NIVEL: ' + nivel + ' - GRADO: ' + grado + ' - SECCION: ' + seccion + '\n\n' +
        'Precio Matricula: S./' + preciomatricula + '\n' +
        'Precio Mensualidad: S./' + preciomensualidad + '\n' +
        'Precio Mantenimiento: S./' + preciomantenimiento + '\n\n' +
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

// TABLA MENCUlIDADES - INICIO
function cargarMensualidades() {
    $.ajax({
        url: link + "listar_mensualidades_activas",
        type: "GET",
        success: function (response) {
            // Asegúrate de que la respuesta sea texto con las filas <tr>
            const tablaMensualidad = document.querySelector("#mensualidadTable tbody");
            tablaMensualidad.innerHTML = response; // Carga directamente el HTML enviado por el controlador

            // Actualiza los valores de precio mensualidad
            actualizarPreciosMensualidad();
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar las mensualidades: ", error);
        }
    });
}

function actualizarPreciosMensualidad() {
    const precioMensualidad = parseFloat($("#matricula_id").find(":selected").data("preciomensualidad")) || 0;
    const precioMantenimiento = parseFloat($("#matricula_id").find(":selected").data("preciomantenimiento")) || 0;

    document.querySelectorAll(".precio-mensualidad").forEach((input) => {
        const mantenimiento = parseInt(input.dataset.mantenimiento, 10); // Obtiene 1 o 0 del atributo data-mantenimiento
        if (mantenimiento === 1) {
            input.value = (precioMensualidad + precioMantenimiento).toFixed(2); // Suma mensualidad y mantenimiento
        } else {
            input.value = precioMensualidad.toFixed(2); // Campo vacío para mantenimiento = 0
        }
    });

    document.querySelectorAll(".mantenimiento").forEach((input) => {
        input.value = precioMantenimiento.toFixed(2); // Actualiza el precio de mantenimiento
    });
}
// TABLA MENCUlIDADES - FIN

function eliminarConValidacion(id) {
    let contraseña = prompt("Ingrese la contraseña para validar la eliminación:");
    if (contraseña !== null && contraseña !== "") {
        $.ajax({
            type: "POST",
            url: link + "eliminar_con_validacion",
            data: { id_matricula_detalle: id, contraseña: contraseña },
            success: function (datos) {
                alert(datos);
                tabla.ajax.reload();
            },
            error: function () {
                alert("Ocurrió un error al intentar eliminar.");
            }
        });
    } else {
        alert("Operación cancelada. No se ingresó contraseña.");
    }
}

function buscarApoderado() {
    var dni = $("#apoderado_dni").val();
    if (!dni) {
        alert("Por favor, ingrese el número de documento.");
        return;
    }

    $.ajax({
        type: "POST",
        url: link + "buscar_apoderado",
        data: { dni: dni },
        success: function (response) {
            var data = JSON.parse(response);
            if (data && data.id) {
                // Rellenar los campos con la información del apoderado
                $("#apoderado_id").val(data.id);
                $("#apoderado_nombreyapellido").val(data.nombreyapellido);
                $("#apoderado_telefono").val(data.telefono);
                $("#apoderado_tipo").val(data.id_apoderado_tipo).change();
                $("#apoderado_documento").val(data.id_documento).change();
                $("#apoderado_sexo").val(data.id_sexo).change();
                $("#apoderado_estado_civil").val(data.id_estado_civil).change();
                $("#apoderado_observaciones").val(data.observaciones);
            } else {
                alert("No se encontró un apoderado con ese número de documento.");
                $("#apoderado_dni").val("");
            }
        },
        error: function () {
            alert("Ocurrió un error al buscar al apoderado.");
        }
    });
}

function buscarAlumno() {
    var dni = $("#alumno_dni").val();
    if (!dni) {
        alert("Por favor, ingrese el número de documento del alumno.");
        return;
    }

    $.ajax({
        type: "POST",
        url: link + "buscar_alumno",
        data: { dni: dni },
        success: function (response) {
            var data = JSON.parse(response);
            if (data && data.id) {
                // Rellenar los campos con la información del alumno
                $("#alumno_id").val(data.id);
                $("#alumno_nombreyapellido").val(data.nombreyapellido);
                $("#alumno_nacimiento").val(data.nacimiento);
                $("#alumno_documento").val(data.id_documento).change();
                $("#alumno_sexo").val(data.id_sexo).change();
                $("#alumno_telefono").val(data.telefono);
                $("#alumno_observaciones").val(data.observaciones);
            } else {
                alert("No se encontró un alumno con ese número de documento.");
            }
        },
        error: function () {
            alert("Ocurrió un error al buscar al alumno.");
        }
    });
}



init();
