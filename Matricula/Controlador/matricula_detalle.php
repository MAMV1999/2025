<?php
include_once("../Modelo/matricula_detalle.php");

$matriculaDetalle = new MatriculaDetalle();

$id = isset($_POST["id"]) ? limpiarcadena($_POST["id"]) : "";
$descripcion = isset($_POST["descripcion"]) ? limpiarcadena($_POST["descripcion"]) : "";
$id_matricula = isset($_POST["id_matricula"]) ? limpiarcadena($_POST["id_matricula"]) : "";
$id_matricula_categoria = isset($_POST["id_matricula_categoria"]) ? limpiarcadena($_POST["id_matricula_categoria"]) : "";
$id_usuario_apoderado = isset($_POST["id_usuario_apoderado"]) ? limpiarcadena($_POST["id_usuario_apoderado"]) : "";
$id_usuario_alumno = isset($_POST["id_usuario_alumno"]) ? limpiarcadena($_POST["id_usuario_alumno"]) : "";
$observaciones = isset($_POST["observaciones"]) ? limpiarcadena($_POST["observaciones"]) : "";
$estado = isset($_POST["estado"]) ? limpiarcadena($_POST["estado"]) : "1";

switch ($_GET["op"]) {
    case 'guardaryeditar':
        if (empty($id)) {
            $rspta = $matriculaDetalle->guardar(
                $descripcion, $id_matricula, $id_matricula_categoria, 
                $id_usuario_apoderado, $id_usuario_alumno, $observaciones, $estado
            );
            echo $rspta ? "Detalle de matrícula registrado correctamente" : "No se pudo registrar el detalle de matrícula";
        } else {
            $rspta = $matriculaDetalle->editar(
                $id, $descripcion, $id_matricula, $id_matricula_categoria, 
                $id_usuario_apoderado, $id_usuario_alumno, $observaciones, $estado
            );
            echo $rspta ? "Detalle de matrícula actualizado correctamente" : "No se pudo actualizar el detalle de matrícula";
        }
        break;

    case 'desactivar':
        $rspta = $matriculaDetalle->desactivar($id);
        echo $rspta ? "Detalle de matrícula desactivado correctamente" : "No se pudo desactivar el detalle de matrícula";
        break;

    case 'activar':
        $rspta = $matriculaDetalle->activar($id);
        echo $rspta ? "Detalle de matrícula activado correctamente" : "No se pudo activar el detalle de matrícula";
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
                "0" => $reg->descripcion,
                "1" => $reg->categoria,
                "2" => $reg->alumno,
                "3" => $reg->apoderado,
                "4" => ($reg->estado) ?
                    '<button type="button" onclick="mostrar(' . $reg->id . ')" class="btn btn-warning btn-sm">EDITAR</button> <button type="button" onclick="desactivar(' . $reg->id . ')" class="btn btn-danger btn-sm">DESACTIVAR</button>' :
                    '<button type="button" onclick="mostrar(' . $reg->id . ')" class="btn btn-warning btn-sm">EDITAR</button> <button type="button" onclick="activar(' . $reg->id . ')" class="btn btn-success btn-sm">ACTIVAR</button>'
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

    // Listar datos dinámicos para los campos de selección en el formulario
    case 'listar_matriculas_activas':
        $rspta = $matriculaDetalle->listarMatriculasActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

    case 'listar_categorias_activas':
        $rspta = $matriculaDetalle->listarCategoriasActivas();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombre . '</option>';
        }
        break;

    case 'listar_alumnos_activos':
        $rspta = $matriculaDetalle->listarAlumnosActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombreyapellido . '</option>';
        }
        break;

    case 'listar_apoderados_activos':
        $rspta = $matriculaDetalle->listarApoderadosActivos();
        while ($reg = $rspta->fetch_object()) {
            echo '<option value="' . $reg->id . '">' . $reg->nombreyapellido . '</option>';
        }
        break;
}
?>
