var link = "../Controlador/Facturacion_x_mes.php?op=";
var tabla;

function init() {
    $("#frm_form").on("submit", function (e) {
        guardaryeditar(e);
    });
    MostrarListado();
    actualizarFechaHora();
    setInterval(actualizarFechaHora, 1000);
}

$(document).ready(function () {
    tabla = $("#myTable").DataTable({
        ajax: link + "listar",
    });
});

function limpiar() {
    $("#formulario-detalles tbody").empty();
}

function guardaryeditar(e) {
    e.preventDefault();
    let detalles = [];

    // Recorre cada fila de la tabla para recopilar los datos
    $("#formulario-detalles tbody tr").each(function () {
        let id = $(this).find("input[name^='id']").val();
        let recibo = $(this).find("input[name^='recibo']").is(":checked") ? 1 : 0; // Valor del checkbox

        detalles.push({
            id: id,
            recibo: recibo
        });
    });

    // Envío de datos al servidor
    $.ajax({
        url: link + "guardaryeditar",
        type: "POST",
        data: { detalles: JSON.stringify(detalles) },
        success: function (response) {
            alert(response);
            MostrarListado();
            limpiar(); // Limpia el formulario y otros elementos.
            tabla.ajax.reload();
        },
        error: function () {
            alert("Error al guardar los registros.");
        }
    });
}

function mostrar(id_mensualidad_mes) {
    $.post(link + "mostrar", { id_mensualidad_mes: id_mensualidad_mes }, function (data) {
        let detalles = JSON.parse(data); // Convierte los datos JSON en un arreglo de objetos.
        limpiar(); // Limpia el formulario y otros elementos.

        let tbody = $("#formulario-detalles tbody");
        tbody.empty(); // Limpia los datos previos.

        // Itera sobre los datos y genera filas en el formulario.
        detalles.forEach((detalle, index) => {
            let fila = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${detalle.mensualidad_nombre} ${detalle.institucion_lectivo_nombre} - ${detalle.grado_nombre}</td>
                        <td>${detalle.apoderado_numero_documento}</td>
                        <td>${detalle.apoderado_nombre}</td>
                        <td>${detalle.monto}</td>
                        <td><button type="button" onclick="copiarAlPortapapeles('${detalle.descripcion_mensualidad}')" class="btn btn-outline-secondary btn-sm">DESC.</button></td>
                        <td>
                            <input type="hidden" name="id${index}" value="${detalle.mensualidad_detalle_id}">
                            <input type="checkbox" name="recibo${index}" ${detalle.recibo == 1 ? "checked" : ""} style="width: 30px; height: 30px;">
                        </td>
                    </tr>
            `;
            tbody.append(fila);
        });

        MostrarFormulario(); // Muestra el formulario con los datos cargados.
    });
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

init();
