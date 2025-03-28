<?php

require('../../General/fpdf/fpdf.php');
require_once("../Modelo/mensualidad_detalle_general.php");

class PDF extends FPDF
{
    protected $fecha_hora_actual;

    function __construct($orientation = 'P', $unit = 'mm', $size = 'A4', $fecha_hora_actual = null)
    {
        parent::__construct($orientation, $unit, $size);
        $this->fecha_hora_actual = $fecha_hora_actual;
        $this->SetMargins(5, 5, 5);
    }

    function Header()
    {
        $this->SetFont('Arial', 'B', 12);
        $this->Cell(0, 8, 'DETALLE DE MENSUALIDADES X MES', 0, 1, 'C');
    }

    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, utf8_decode('FECHA Y HORA DE GENERACIÓN: ' . $this->fecha_hora_actual), 0, 0, 'C');
        $this->Cell(0, 10, utf8_decode('PÁGINA ') . $this->PageNo() . '/{nb}', 0, 0, 'R');
    }

    function HeaderTable($mes)
    {
        $this->SetFont('Arial', 'B', 12);
        $this->Cell(0, 8, utf8_decode(strtoupper($mes)), 0, 1, 'C');
        $this->Ln(3);

        $orientacion = 'C';

        $this->SetFont('Arial', 'B', 7);
        $this->SetFillColor(188, 188, 188);
        $this->Cell(15, 10, utf8_decode('NIVEL'), 1, 0, $orientacion, true);
        $this->Cell(15, 10, utf8_decode('GRADO'), 1, 0, $orientacion, true);
        $this->Cell(60, 10, utf8_decode('ALUMNO'), 1, 0, $orientacion, true);
        $this->Cell(60, 10, utf8_decode('APODERADO'), 1, 0, $orientacion, true);
        $this->Cell(18, 10, utf8_decode('TELEFONO'), 1, 0, $orientacion, true);
        $this->Cell(15, 10, utf8_decode('MONTO'), 1, 0, $orientacion, true);
        $this->Cell(17, 10, utf8_decode('ESTADO'), 1, 1, $orientacion, true);
    }

    function FillTable($results)
    {
        $this->SetFont('Arial', '', 7);
        $orientacion = 'C';
    
        foreach ($results as $row) {
            $this->Cell(15, 6, utf8_decode($row['nivel_nombre']), 1, 0, $orientacion);
            $this->Cell(15, 6, utf8_decode($row['grado_nombre']), 1, 0, $orientacion);
            $this->Cell(60, 6, utf8_decode($row['alumno_nombre']), 1, 0, $orientacion);
            $this->Cell(60, 6, utf8_decode($row['apoderado_nombre']), 1, 0, $orientacion);
            $this->Cell(18, 6, utf8_decode($row['apoderado_telefono']), 1, 0, $orientacion);
            $this->Cell(15, 6, 'S/.' . number_format($row['detalle_monto'], 2), 1, 0, $orientacion);
    
            // Evaluar estado de pago y aplicar color
            if (strtoupper($row['detalle_estado_pago']) === 'PENDIENTE') {
                $this->SetFillColor(220, 220, 220); // gris claro/plomo medio
                $this->Cell(17, 6, utf8_decode($row['detalle_estado_pago']), 1, 1, $orientacion, true);
            } else {
                $this->Cell(17, 6, utf8_decode($row['detalle_estado_pago']), 1, 1, $orientacion);
            }
        }
    }
    
}

// Obtener los datos
$modelo = new Mensualidad_detalle();
$resultDetalle = $modelo->listar_mensualidad_detalle_general();

if (!$resultDetalle) {
    die("Error al obtener los datos del detalle.");
}

$rowsDetalle = [];
while ($row = $resultDetalle->fetch_assoc()) {
    $rowsDetalle[] = $row;
}

// Agrupar por mes
$meses = [];
foreach ($rowsDetalle as $row) {
    $mes = $row['mensualidad_mes_nombre'];
    if (!isset($meses[$mes])) {
        $meses[$mes] = [];
    }
    $meses[$mes][] = $row;
}

// Generar el PDF
date_default_timezone_set('America/Lima');
$fecha_hora_actual = date('d/m/Y H:i:s');

$pdf = new PDF('P', 'mm', 'A4', $fecha_hora_actual);
$pdf->AliasNbPages();

foreach ($meses as $mes => $registros) {
    $pdf->AddPage();
    $pdf->HeaderTable($mes);
    $pdf->FillTable($registros);
}

// Salida del archivo
$filename = 'MENSUALIDADES_'.$fecha_hora_actual.'.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $filename);
