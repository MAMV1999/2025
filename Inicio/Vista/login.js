$("#frmAcceso").on('submit', function(e) {
    e.preventDefault();
    var usuario = $("#usuario").val();
    var contraseña = $("#contraseña").val();

    $.post("../Controlador/Acceso.php?op=verificar", {"usuario": usuario, "contraseña": contraseña}, function(response) {
        var data = JSON.parse(response);
        if (data.status == "success") {
            $("#usuario").val("");
            $("#contraseña").val("");
            $(location).attr("href", "Escritorio.php");
        } else {
            $("#usuario").val("");
            $("#contraseña").val("");
            alert("Algo anda mal: " + data.message);
        }
    });
});
