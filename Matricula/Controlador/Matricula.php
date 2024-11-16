<?php
include_once("../Modelo/Matricula.php");

$matricula = new Matricula();
$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$id_institucion_seccion = isset($_POST["id_institucion_seccion"]) ? limpiarcadena($_POST["id_institucion_seccion"]) : "";
$id_usuario_docente = isset($_POST["id_usuario_docente"]) ? limpiarcadena($_POST["id_usuario_docente"]) : "";
$preciomatricula = isset($_POST["preciomatricula"]) ? limpiarcadena($_POST["preciomatricula"]) : "";
$preciomensualidad = isset($_POST["preciomensualidad"]) ? limpiarcadena($_POST["preciomensualidad"]) : "";
$preciomantenimiento = isset($_POST["preciomantenimiento"]) ? limpiarcadena($_POST["preciomantenimiento"]) : "";
$aforo = isset($_POST["aforo"]) ? limpiarcadena($_POST["aforo"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $matricula->guardar($id_institucion_seccion, $id_usuario_docente, $preciomatricula, $preciomensualidad, $preciomantenimiento, $aforo, $observaciones);
            echo $rspta ? "Matrícula registrada correctamente" : "No se pudo registrar la matrícula";
        } else {
            $rspta = $matricula->editar($id, $id_institucion_seccion, $id_usuario_docente, $preciomatricula, $preciomensualidad, $preciomantenimiento, $aforo, $observaciones);
            echo $rspta ? "Matrícula actualizada correctamente" : "No se pudo actualizar la matrícula";
        }
        break;

    case 'desactivar':
        $rspta = $matricula->desactivar($id);
        echo $rspta ? "Matrícula desactivada correctamente" : "No se pudo desactivar la matrícula";
        break;

    case 'activar':
        $rspta = $matricula->activar($id);
        echo $rspta ? "Matrícula activada correctamente" : "No se pudo activar la matrícula";
        break;

    case 'mostrar':
        $rspta = $matricula->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $matricula->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->nombre_lectivo.' - '.$reg->nombre_nivel.' - '.$reg->nombre_grado.' - '.$reg->nombre_seccion,
                "1" => $reg->docente_nombre,
                "2" => 'S/. '.$reg->preciomatricula,
                "3" => 'S/. '.$reg->preciomensualidad,
                "4" => $reg->aforo.' ALUMNOS',
                "5" => ($reg->estado) ?
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-danger btn-sm" onclick="desactivar(' . $reg->id . ')">DESACTIVAR</button>' :
                    '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button> <button class="btn btn-primary btn-sm" onclick="activar(' . $reg->id . ')">ACTIVAR</button>'
            );
        }
        $results = array(
            "sEcho" => 1,
            "iTotalRecords" => count($data),
            "iTotalDisplayRecords" => count($data),
            "aaData" => $data
        );
        echo json_encode($results);
        break;

    case 'listar_secciones_activas':
        $rspta = $matricula->listarSeccionesActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id_seccion . '>' . $reg->nombre_lectivo . ' - ' . $reg->nombre_nivel . ' - ' . $reg->nombre_grado . ' - ' . $reg->nombre_seccion . '</option>';
        }
        break;

    case 'listar_docentes_activos':
        $rspta = $matricula->listarDocentesActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value=' . $reg->id_docente . '>' . $reg->nombre_docente . ' - ' . $reg->nombre_cargo . '</option>';
        }
        break;
}
?>
