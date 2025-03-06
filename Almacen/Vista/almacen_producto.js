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
        $("select[name='categorias[]']").each(function () {
            $(this).html(r);
        });
    });
}

function limpiar() {
    $("#tabla_dinamica tbody").empty();
    agregarFila();
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
    let detalles = [];

    $("#tabla_dinamica tbody tr").each(function () {
        let id = $(this).find("input[name='ids[]']").val() || null;
        let nombre = $(this).find("input[name='nombres[]']").val() || "";
        let categoria_id = $(this).find("select[name='categorias[]']").val() || "";
        let precio_compra = $(this).find("input[name='precios_compra[]']").val() || "0";
        let precio_venta = $(this).find("input[name='precios_venta[]']").val() || "0";
        let stock = $(this).find("input[name='stocks[]']").val() || "0";
        let estado = $(this).find("select[name='estados[]']").val() || "1";

        if (nombre !== "" && categoria_id !== "") {
            detalles.push({
                id: id,
                nombre: nombre,
                categoria_id: categoria_id,
                precio_compra: precio_compra,
                precio_venta: precio_venta,
                stock: stock,
                estado: estado
            });
        }
    });

    if (detalles.length === 0) {
        alert("Debe agregar al menos un producto antes de guardar.");
        return;
    }

    $.ajax({
        url: link + "guardaryeditar",
        type: "POST",
        data: { detalles: JSON.stringify(detalles) },
        success: function (response) {
            alert(response);
            tabla.ajax.reload();
            MostrarListado();
            limpiar();
        },
        error: function () {
            alert("Error al guardar los registros.");
        }
    });
}

function agregarFila() {
    let fila = `<tr>
        <td><input type="hidden" name="ids[]"></td>
        <td><input type="text" name="nombres[]" class="form-control" required></td>
        <td><select name="categorias[]" class="form-control"></select></td>
        <td><input type="number" name="precios_compra[]" class="form-control" required></td>
        <td><input type="number" name="precios_venta[]" class="form-control" required></td>
        <td><button type="button" class="btn btn-danger btn-sm" onclick="eliminarFila(this)">Eliminar</button></td>
    </tr>`;
    $("#tabla_dinamica tbody").append(fila);
    cargarCategorias();
}

function eliminarFila(fila) {
    $(fila).closest("tr").remove();
}

function mostrar(id) {
    $.ajax({
        url: link + "mostrar",
        type: "POST",
        data: { id: id },
        dataType: "json",
        success: function (data) {
            if (data) {
                MostrarFormulario();
                $("#tabla_dinamica tbody").empty();
                $.post(link + "listar_categorias_activas", function (categorias) {
                    let selectCategorias = `<select name="categorias[]" class="form-control">` + categorias + `</select>`;
                    let fila = `<tr>
                        <td><input type="hidden" name="ids[]" value="${data.id}"></td>
                        <td><input type="text" name="nombres[]" class="form-control" value="${data.nombre}" required></td>
                        <td>${selectCategorias}</td>
                        <td><input type="number" name="precios_compra[]" class="form-control" value="${data.precio_compra}" required></td>
                        <td><input type="number" name="precios_venta[]" class="form-control" value="${data.precio_venta}" required></td>
                        <td><button type="button" class="btn btn-danger btn-sm" onclick="eliminarFila(this)">ELIMINAR</button></td>
                    </tr>`;
                    $("#tabla_dinamica tbody").append(fila);
                    $("#tabla_dinamica tbody select[name='categorias[]']").val(data.categoria_id);
                });
            } else {
                alert("No se encontraron datos del producto.");
            }
        },
        error: function () {
            alert("Error al obtener los datos del producto.");
        }
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