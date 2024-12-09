<?php
include_once("../Modelo/matricula_editar.php");

$matriculaDetalle = new Matricula_detalle();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$descripcion = isset($_POST["descripcion"]) ? limpiarcadena($_POST["descripcion"]) : "";
$id_matricula = isset($_POST["id_matricula"]) ? limpiarcadena($_POST["id_matricula"]) : "";
$id_matricula_categoria = isset($_POST["id_matricula_categoria"]) ? limpiarcadena($_POST["id_matricula_categoria"]) : "";
$id_usuario_apoderado_referido = isset($_POST["id_usuario_apoderado_referido"]) ? limpiarcadena($_POST["id_usuario_apoderado_referido"]) : "NULL";
$id_usuario_apoderado = isset($_POST["id_usuario_apoderado"]) ? limpiarcadena($_POST["id_usuario_apoderado"]) : "";
$id_usuario_alumno = isset($_POST["id_usuario_alumno"]) ? limpiarcadena($_POST["id_usuario_alumno"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $matriculaDetalle->guardar($descripcion, $id_matricula, $id_matricula_categoria, $id_usuario_apoderado_referido, $id_usuario_apoderado, $id_usuario_alumno, $observaciones);
            echo $rspta ? "Detalle registrado correctamente" : "No se pudo registrar el detalle";
        } else {
            $rspta = $matriculaDetalle->editar($id, $descripcion, $id_matricula, $id_matricula_categoria, $id_usuario_apoderado_referido, $id_usuario_apoderado, $id_usuario_alumno, $observaciones);
            echo $rspta ? "Detalle actualizado correctamente" : "No se pudo actualizar el detalle";
        }
        break;

    case 'desactivar':
        $rspta = $matriculaDetalle->desactivar($id);
        echo $rspta ? "Detalle desactivado correctamente" : "No se pudo desactivar el detalle";
        break;

    case 'activar':
        $rspta = $matriculaDetalle->activar($id);
        echo $rspta ? "Detalle activado correctamente" : "No se pudo activar el detalle";
        break;

    case 'mostrar':
        $rspta = $matriculaDetalle->mostrar($id);
        echo json_encode($rspta);
        break;

    case 'listar':
        $rspta = $matriculaDetalle->listar();
        $data = array();

        while ($reg = $rspta->fetch_object()) {
            $data[] = array(
                "0" => $reg->lectivo.' - '.$reg->nivel.' - '.$reg->grado.' - '.$reg->seccion,
                "1" => $reg->alumno,
                "2" => $reg->apoderado,
                "3" => $reg->categoria,
                "4" => '<button class="btn btn-warning btn-sm" onclick="mostrar(' . $reg->id . ')">EDITAR</button>'
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
}
