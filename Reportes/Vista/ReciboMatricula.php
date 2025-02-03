<?php

require('../../General/fpdf/fpdf.php');
require_once("../Modelo/ReciboMatricula.php");

class PDF extends FPDF
{
    protected $fecha_hora_actual;

    function __construct($orientation = 'P', $unit = 'mm', $size = 'A4', $fecha_hora_actual = null)
    {
        parent::__construct($orientation, $unit, $size);
        $this->fecha_hora_actual = $fecha_hora_actual;
    }

    function Footer()
    {
        $this->SetY(-20);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 5, utf8_decode('Fecha y Hora de generación: ' . $this->fecha_hora_actual), 0, 1, 'C');
        $this->Cell(0, 10, utf8_decode('Página ' . $this->PageNo() . '/{nb}'), 0, 0, 'C');
    }

    function Recibo($data)
    {
        $this->AddPage();

        // Encabezado con los datos de la institución
        $this->SetFont('Arial', 'B', 25);
        $this->Cell(0, 10, utf8_decode($data['institucion_nombre']), 0, 1, 'C');
        $this->SetFont('Arial', '', 9);
        $this->Cell(0, 5, utf8_decode('R.U.C.: ' . $data['institucion_ruc'] . ' - ' . $data['institucion_razon_social']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode($data['institucion_direccion']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode('TELÉFONO: ' . $data['institucion_telefono']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode('CORREO: ' . $data['institucion_correo']), 0, 1, 'C');
        $this->Ln(5);

        // Número de recibo y fecha
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(0, 8, utf8_decode('RECIBO N° ' . $data['pago_numeracion']), 0, 1, 'C');
        $this->Ln(5);

        // Información del Apoderado
        $this->SetFont('Arial', '', 10);
        $this->Cell(35, 7, utf8_decode('Apoderado(a):'), 0);
        $this->Cell(0, 7, utf8_decode($data['apoderado_tipo_nombre'] . ' - ' . $data['apoderado_nombre_completo']), 'B', 1);
        $this->Cell(35, 7, utf8_decode('Documento:'), 0);
        $this->Cell(50, 7, utf8_decode($data['apoderado_tipo_documento'] . ' ' . $data['apoderado_numero_documento']), 'B', 1);
        $this->Cell(35, 7, utf8_decode('Teléfono:'), 0);
        $this->Cell(50, 7, utf8_decode($data['apoderado_telefono']), 'B', 1);
        $this->Ln(5);

        // Información del Alumno
        $this->SetFont('Arial', '', 10);
        $this->Cell(35, 7, utf8_decode('Alumno(a):'), 0);
        $this->Cell(0, 7, utf8_decode($data['alumno_nombre_completo']), 'B', 1);
        $this->Cell(35, 7, utf8_decode('Documento:'), 0);
        $this->Cell(50, 7, utf8_decode($data['alumno_tipo_documento'] . ' ' . $data['alumno_numero_documento']), 'B', 1);
        $this->Ln(5);

        // Información del Alumno
        $this->SetFont('Arial', '', 10);
        $this->Cell(35, 7, utf8_decode('Fecha:'), 0);
        $this->Cell(50, 7, utf8_decode($data['pago_fecha']), 'B', 1);
        $this->Cell(35, 7, utf8_decode('Metodo:'), 0);
        $this->Cell(50, 7, utf8_decode($data['metodo_pago_nombre']), 'B', 1);
        $this->Ln(5);

        // Tabla de conceptos de pago
        $this->SetFont('Arial', 'B', 10);
        $this->Cell(20, 8, utf8_decode('CANT.'), 1, 0, 'C');
        $this->Cell(110, 8, utf8_decode('DESCRIPCIÓN'), 1, 0, 'C');
        $this->Cell(30, 8, utf8_decode('P. UNIT.'), 1, 0, 'C');
        $this->Cell(30, 8, utf8_decode('IMPORTE'), 1, 1, 'C');

        // Datos de la tabla
        $this->SetFont('Arial', '', 10);
        $this->Cell(20, 8, '1', 1, 0, 'C');
        $this->Cell(110, 8, utf8_decode('MATRICULA ' . $data['lectivo_nombre'] . ': ' . $data['nivel_nombre'] . ' / ' . $data['grado_nombre'] . ' / ' . $data['seccion_nombre']), 1, 0, 'C');
        $this->Cell(30, 8, 'S/ ' . number_format($data['pago_monto'], 2), 1, 0, 'C');
        $this->Cell(30, 8, 'S/ ' . number_format($data['pago_monto'], 2), 1, 1, 'C');
        $this->Ln(5);

        // Total a pagar
        $this->SetFont('Arial', 'B', 12);
        $this->Cell(160, 8, 'TOTAL S/  ', 1, 0, 'R');
        $this->Cell(30, 8, 'S/ ' . number_format($data['pago_monto'], 2), 1, 1, 'C');
        $this->Ln(5);
    }
}

// Obtener el ID de la matrícula
$id = $_GET['id'];

// Crear instancia del modelo y obtener datos
$modelo = new ReciboMatricula();
$result = $modelo->listarPorIdMatriculaDettalle($id);
$data = $result->fetch_assoc();

date_default_timezone_set('America/Lima');
$fecha_hora_actual = date('d/m/Y H:i:s');

$pdf = new PDF('P', 'mm', 'A4', $fecha_hora_actual);
$pdf->AliasNbPages();
$pdf->Recibo($data);

$filename = utf8_decode('MATRICULA '.$data['lectivo_nombre'].' '.$data['alumno_nombre_completo']) . '.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $filename);
