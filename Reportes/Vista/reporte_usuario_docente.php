<?php

require('../../General/fpdf/fpdf.php');
require_once("../Modelo/reporte_usuario_docente.php");

class PDF extends FPDF
{
    protected $fecha_hora_actual;

    function __construct($orientation = 'L', $unit = 'mm', $size = 'A4', $fecha_hora_actual = null)
    {
        parent::__construct($orientation, $unit, $size);
        $this->fecha_hora_actual = $fecha_hora_actual;
        $this->SetMargins(5, 5, 5); // Márgenes estrictos de 5 mm
    }

    function Header()
    {
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(0, 10, 'LISTADO DETALLE MATRICULADOS', 0, 1, 'C');
        $this->Ln(3);
    }

    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, utf8_decode('FECHA Y HORA DE GENERACIÓN: ' . $this->fecha_hora_actual), 0, 0, 'C');
        $this->Cell(0, 10, utf8_decode('PÁGINA ') . $this->PageNo() . '/{nb}', 0, 0, 'R');
    }

    function HeaderTable()
    {
        $this->SetFont('Arial', 'B', 7);
        $this->SetFillColor(188, 188, 188);
        $this->Cell(8, 10, utf8_decode('N°'), 1, 0, 'C', true);
        $this->Cell(23, 10, utf8_decode('DOCUMENTO'), 1, 0, 'C', true);
        $this->Cell(70, 10, utf8_decode('NOMBRES Y APELLIDOS'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('TELEFONO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('NACIMIENTO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('ESTADO CIVIL'), 1, 0, 'C', true);
        $this->Cell(28, 10, utf8_decode('CARGO'), 1, 0, 'C', true);
        $this->Cell(25, 10, utf8_decode('CONTRATO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('INICIO'), 1, 0, 'C', true);
        $this->Cell(20, 10, utf8_decode('TERMINO'), 1, 0, 'C', true);
        $this->Cell(0, 10, utf8_decode('CUENTA BCP'), 1, 1, 'C', true);
    }

    function FillTable($results)
    {
        $this->SetFont('Arial', '', 7);
        $contador = 1;
        foreach ($results as $row) {
            $this->Cell(8, 6, $contador, 1, 0, 'C');
            $this->Cell(23, 6, utf8_decode($row['documento_tipo'].' '.$row['numerodocumento']), 1, 0, 'C');
            $this->Cell(70, 6, utf8_decode($row['docente_nombre']), 1, 0, 'C');
            $this->Cell(20, 6, utf8_decode($row['telefono']), 1, 0, 'C');
            $this->Cell(20, 6, utf8_decode($row['fecha_nacimiento']), 1, 0, 'C');
            $this->Cell(20, 6, utf8_decode($row['estado_civil']), 1, 0, 'C');
            $this->Cell(28, 6, utf8_decode($row['cargo']), 1, 0, 'C');
            $this->Cell(25, 6, utf8_decode($row['tipo_contrato']), 1, 0, 'C');
            $this->Cell(20, 6, utf8_decode($row['fecha_inicio']), 1, 0, 'C');
            $this->Cell(20, 6, utf8_decode($row['fecha_fin']), 1, 0, 'C');
            $this->Cell(0, 6, utf8_decode($row['cuentabancaria']), 1, 1, 'C');

            $contador++;
        }
    }
}

// Obtener los datos
$modelo = new Reportedocente();
$resultDetalle = $modelo->listar();

if (!$resultDetalle) {
    die("Error al obtener los datos del detalle.");
}

$rowsDetalle = [];
while ($row = $resultDetalle->fetch_assoc()) {
    $rowsDetalle[] = $row;
}

// Generar el PDF
date_default_timezone_set('America/Lima');
$fecha_hora_actual = date('d/m/Y H:i:s');

$pdf = new PDF('L', 'mm', 'A4', $fecha_hora_actual);
$pdf->AliasNbPages();
$pdf->AddPage();

$pdf->HeaderTable();
$pdf->FillTable($rowsDetalle);

$filename = 'Recibo_Matricula.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $filename);
