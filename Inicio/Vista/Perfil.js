$(document).ready(function() {
    mostrarDatosPerfil();
});

$("#frmPerfil").on('submit', function(e) {
    e.preventDefault();
    var datos = $(this).serialize();

    $.post("../Controlador/Perfil.php?op=editar", datos, function(response) {
        var data = JSON.parse(response);
        if (data.status == "success") {
            alert("Actualización exitosa: " + data.message);
            $(location).attr("href", "Escritorio.php");
        } else {
            alert("Error: " + data.message);
        }
    });
});

function mostrarDatosPerfil() {
    $.post("../Controlador/Perfil.php?op=mostrar", function(response) {
        var data = JSON.parse(response);
        if (data) {
            // Aquí rellenas los campos del formulario con los datos del perfil
            $("#usuario").val(data.usuario);
            $("#contraseña").val(data.contraseña);
            $("#dni").val(data.dni);
            $("#nombre_apellido").val(data.nombre_apellido);
            $("#nacimiento").val(data.nacimiento);
            $("#sexo").val(data.sexo);
            $("#estado_civil").val(data.estado_civil);
            $("#cargo").val(data.cargo);
            $("#direccion").val(data.direccion);
            $("#telefono").val(data.telefono);
            $("#correo").val(data.correo);
            $("#sueldo").val(data.sueldo);
            $("#cuenta_bcp").val(data.cuenta_bcp);
            $("#interbancario_bcp").val(data.interbancario_bcp);
            $("#sunat_ruc").val(data.sunat_ruc);
            $("#sunat_usuario").val(data.sunat_usuario);
            $("#sunat_contraseña").val(data.sunat_contraseña);
            $("#observaciones").val(data.observaciones);
        } else {
            alert("Error al obtener los datos del perfil.");
        }
    });
}
