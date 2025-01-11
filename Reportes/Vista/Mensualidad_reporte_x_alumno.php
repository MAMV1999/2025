<?php
require_once("../../General/fpdf/fpdf.php");
require_once("../Modelo/Mensualidad_reporte_x_alumno.php");

class PDFMensualidadAlumno extends FPDF
{
    // Cabecera del documento
    function Header()
    {
        $this->SetFont('Arial', 'B', 20);
        $this->Cell(0, 10, 'REPORTE DE MENSUALIDAD', 0, 1, 'C');
    }

    // Pie de página
    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, 'Pagina ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
    }

    // Agregar título
    function addTitulo($institucion)
    {
        $this->SetFont('Arial', 'B', 18);
        $this->Cell(0, 10, utf8_decode($institucion['nombre_institucion']), 0, 1, 'C');
        $this->SetFont('Arial', '', 10);
        $this->Cell(0, 6, utf8_decode("{$institucion['direccion_institucion']}"), 0, 1, 'C');
        $this->Cell(0, 6, utf8_decode("{$institucion['razon_social_institucion']} - {$institucion['ruc_institucion']}"), 0, 1, 'C');
        $this->Cell(0, 6, utf8_decode("TELÉFONO: {$institucion['telefono_institucion']}"), 0, 1, 'C');
        $this->Cell(0, 6, utf8_decode("CORREO: {$institucion['correo_institucion']}"), 0, 1, 'C');
        $this->Ln(10);
    }

    // Agregar información general
    function addInformacionGeneral($datos)
    {
        $this->SetFont('Arial', 'B', 10);
        $this->Cell(0, 8, 'INFORMACION GENERAL', 1, 1, 'L');
        $this->SetFont('Arial', '', 10);
        $borde = '1';
        $this->Cell(50, 8, utf8_decode("MATRICULA"), $borde, 0);
        $this->Cell(0, 8, utf8_decode("{$datos['nombre_lectivo']} - {$datos['nombre_nivel']} - {$datos['nombre_grado']}"), $borde, 1);

        $this->Cell(50, 8, utf8_decode("APODERADO"), $borde, 0);
        $this->Cell(0, 8, utf8_decode("{$datos['tipo_apoderado']} - {$datos['nombre_apoderado']}"), $borde, 1);

        $this->Cell(50, 8, utf8_decode("ALUMNO(A)"), $borde, 0);
        $this->Cell(0, 8, utf8_decode("{$datos['nombre_alumno']}"), $borde, 1);

        $this->Cell(50, 8, utf8_decode("CODIGO"), $borde, 0);
        $this->Cell(0, 8, utf8_decode("{$datos['numero_documento_alumno']}"), $borde, 1);
        $this->Ln(5);
    }

    // Agregar tabla de mensualidades
    function addTablaMensualidades($mensualidades)
    {
        $this->SetFont('Arial', 'B', 10);
        $this->Cell(30, 8, 'MES', 1, 0, 'C');
        $this->Cell(30, 8, 'MONTO', 1, 0, 'C');
        $this->Cell(30, 8, 'ESTADO', 1, 0, 'C');
        $this->Cell(100, 8, 'OBSERVACIONES', 1, 0, 'C');
        $this->Ln();

        $this->SetFont('Arial', '', 10);

        foreach ($mensualidades as $mensualidad) {
            $this->Cell(30, 8, utf8_decode($mensualidad['mes']), 1, 0, 'C');
            $this->Cell(30, 8, 'S/ '.number_format($mensualidad['monto'], 2), 1, 0, 'C');
            $this->Cell(30, 8, utf8_decode($mensualidad['estado']), 1, 0, 'C');
            $this->Cell(100, 8, utf8_decode($mensualidad['observacion']), 1, 0, 'C');
            $this->Ln();
        }
    }
}

// Obtener datos
$modelo = new Reportemensualidadxalumno();
$id_matricula_detalle = $_GET['id'];
//$id_matricula_detalle = '1';

// Obtener los datos del modelo y convertirlos en un array
$resultado = $modelo->listar($id_matricula_detalle);
$datos = [];
if ($resultado) {
    while ($fila = $resultado->fetch_assoc()) {
        $datos[] = $fila;
    }
}

if (!empty($datos)) {
    $institucion = [
        'nombre_institucion' => $datos[0]['nombre_institucion'],
        'telefono_institucion' => $datos[0]['telefono_institucion'],
        'correo_institucion' => $datos[0]['correo_institucion'],
        'ruc_institucion' => $datos[0]['ruc_institucion'],
        'razon_social_institucion' => $datos[0]['razon_social_institucion'],
        'direccion_institucion' => $datos[0]['direccion_institucion'],
    ];

    $informacion_general = [
        'nombre_lectivo' => $datos[0]['nombre_lectivo'],
        'nombre_nivel' => $datos[0]['nombre_nivel'],
        'nombre_grado' => $datos[0]['nombre_grado'],
        'nombre_seccion' => $datos[0]['nombre_seccion'],
        'nombre_alumno' => $datos[0]['nombre_alumno'],
        'tipo_documento_alumno' => $datos[0]['tipo_documento_alumno'],
        'numero_documento_alumno' => $datos[0]['numero_documento_alumno'],
        'tipo_apoderado' => $datos[0]['tipo_apoderado'],
        'nombre_apoderado' => $datos[0]['nombre_apoderado'],
        'tipo_documento_apoderado' => $datos[0]['tipo_documento_apoderado'],
        'numero_documento_apoderado' => $datos[0]['numero_documento_apoderado'],
        'telefono_apoderado' => $datos[0]['telefono_apoderado'],
    ];

    $mensualidades = [];
    $meses = explode(', ', $datos[0]['meses']);
    $montos = explode(', ', $datos[0]['montos']);
    $estados = explode(', ', $datos[0]['estados_pago_legibles']);
    $observaciones = explode(', ', $datos[0]['observaciones']);

    for ($i = 0; $i < count($meses); $i++) {
        $mensualidades[] = [
            'mes' => $meses[$i],
            'monto' => $montos[$i],
            'estado' => $estados[$i],
            'observacion' => $observaciones[$i],
        ];
    }

    // Crear PDF
    $pdf = new PDFMensualidadAlumno();
    $pdf->AliasNbPages();
    $pdf->AddPage();
    $pdf->addTitulo($institucion);
    $pdf->addInformacionGeneral($informacion_general);
    $pdf->addTablaMensualidades($mensualidades);
    $pdf->Output();
} else {
    echo "No se encontraron datos para el ID especificado.";
}
?>
