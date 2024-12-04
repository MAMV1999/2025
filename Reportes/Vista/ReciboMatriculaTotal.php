<?php

require('../../General/fpdf/fpdf.php');
require_once("../Modelo/ReciboMatriculaTotal.php");

class PDF extends FPDF
{
    protected $fecha_hora_actual;

    function __construct($orientation = 'L', $unit = 'mm', $size = 'A4', $fecha_hora_actual = null)
    {
        parent::__construct($orientation, $unit, $size);
        $this->fecha_hora_actual = $fecha_hora_actual;
        $this->SetMargins(5, 5, 5); // Márgenes estrictos de 5 mm
    }

    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, utf8_decode('Fecha y Hora de generación: ' . $this->fecha_hora_actual), 0, 0, 'C');
        $this->Cell(0, 10, 'Página ' . $this->PageNo() . '/{nb}', 0, 0, 'R');
    }

    function HeaderTable()
    {
        $this->SetFont('Arial', 'B', 7);
        $this->SetFillColor(220, 220, 220); // Color de fondo para encabezados
        $this->Cell(15, 10, utf8_decode('LECTIVO'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('NIVEL'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('GRADO'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('SECCIÓN'), 1, 0, 'C', true);
        $this->Cell(60, 10, utf8_decode('ALUMNO'), 1, 0, 'C', true);
        $this->Cell(60, 10, utf8_decode('APODERADO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('TELEFONO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('FECHA'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('NUMERACION'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('MONTO'), 1, 0, 'C', true);
        $this->Cell(30, 10, utf8_decode('MÉTODO'), 1, 1, 'C', true);
    }

    function FillTable($results)
    {
        $this->SetFont('Arial', '', 7);
        foreach ($results as $row) {
            $this->Cell(15, 8, utf8_decode($row['lectivo']), 1, 0, 'C');
            $this->Cell(15, 8, utf8_decode($row['nivel']), 1, 0, 'C');
            $this->Cell(15, 8, utf8_decode($row['grado']), 1, 0, 'C');
            $this->Cell(15, 8, utf8_decode($row['seccion']), 1, 0, 'C');
            $this->Cell(60, 8, utf8_decode($row['nombre_alumno']), 1, 0, 'C');
            $this->Cell(60, 8, utf8_decode($row['nombre_apoderado']), 1, 0, 'C');
            $this->Cell(20, 8, utf8_decode($row['telefono_apoderado']), 1, 0, 'C');
            $this->Cell(20, 8, utf8_decode($row['fecha']), 1, 0, 'C');
            $this->Cell(20, 8, utf8_decode('N° '.$row['numeracion']), 1, 0, 'C');
            $this->Cell(15, 8, 'S/.'.number_format($row['monto'], 2), 1, 0, 'C');
            $this->Cell(30, 8, utf8_decode($row['metodo_pago']), 1, 1, 'C');
        }
    }
}


$modelo = new ReciboMatriculaTotal();
$result = $modelo->listarReciboMatriculaTotal();
if (!$result) {
    die("Error al obtener los datos.");
}

// Transformar el resultado en un array
$rows = [];
while ($row = $result->fetch_assoc()) {
    $rows[] = $row;
}

// Generar el PDF
date_default_timezone_set('America/Lima');
$fecha_hora_actual = date('d/m/Y H:i:s');

$pdf = new PDF('L', 'mm', 'A4', $fecha_hora_actual);
$pdf->AliasNbPages();
$pdf->AddPage();

// Encabezados de la tabla
$pdf->HeaderTable();

// Llenar la tabla con datos
$pdf->FillTable($rows);

// Salida del archivo
$filename = 'Recibo_Matricula.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $filename);
