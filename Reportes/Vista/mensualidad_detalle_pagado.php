<?php

require('../../General/fpdf/fpdf.php');
require_once("../Modelo/mensualidad_detalle_pagado.php");

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
        $this->Cell(0, 8, 'MENSUALIDADES PAGADAS POR MES', 0, 1, 'C');
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

        $this->SetFont('Arial', 'B', 7);
        $this->SetFillColor(188, 188, 188);
        $this->Cell(15, 10, utf8_decode('NIVEL'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('GRADO'), 1, 0, 'C', true);
        $this->Cell(60, 10, utf8_decode('ALUMNO'), 1, 0, 'C', true);
        $this->Cell(60, 10, utf8_decode('APODERADO'), 1, 0, 'C', true);
        $this->Cell(18, 10, utf8_decode('TELÉFONO'), 1, 0, 'C', true);
        $this->Cell(15, 10, utf8_decode('MONTO'), 1, 0, 'C', true);
        $this->Cell(17, 10, utf8_decode('ESTADO'), 1, 1, 'C', true);
    }

    function FillTable($results)
    {
        $this->SetFont('Arial', '', 7);
        foreach ($results as $row) {
            $this->Cell(15, 6, utf8_decode($row['nivel_nombre']), 1, 0, 'C');
            $this->Cell(15, 6, utf8_decode($row['grado_nombre']), 1, 0, 'C');
            $this->Cell(60, 6, utf8_decode($row['alumno_nombre']), 1, 0, 'C');
            $this->Cell(60, 6, utf8_decode($row['apoderado_nombre']), 1, 0, 'C');
            $this->Cell(18, 6, utf8_decode($row['apoderado_telefono']), 1, 0, 'C');
            $this->Cell(15, 6, 'S/.' . number_format($row['detalle_monto'], 2), 1, 0, 'C');
            $this->Cell(17, 6, utf8_decode($row['detalle_estado_pago']), 1, 1, 'C');
        }
    }
}

// Obtener datos desde el modelo
$modelo = new Mensualidad_detalle_pagado();
$resultado = $modelo->listar_mensualidad_detalle_pagado();

if (!$resultado) {
    die("Error al obtener los datos de mensualidades pagadas.");
}

$filas = [];
while ($row = $resultado->fetch_assoc()) {
    $mes = $row['mensualidad_mes_nombre'];
    if (!isset($filas[$mes])) {
        $filas[$mes] = [];
    }
    $filas[$mes][] = $row;
}

// Configurar zona horaria y obtener hora actual
date_default_timezone_set('America/Lima');
$fecha_hora_actual = date('d/m/Y H:i:s');

// Crear PDF
$pdf = new PDF('P', 'mm', 'A4', $fecha_hora_actual);
$pdf->AliasNbPages();

foreach ($filas as $mes => $datos_mes) {
    $pdf->AddPage();
    $pdf->HeaderTable($mes);
    $pdf->FillTable($datos_mes);
}

// Salida del PDF
$nombre_archivo = 'MENSUALIDADES_PAGADAS_' . date('Ymd_His') . '.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $nombre_archivo . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $nombre_archivo);
