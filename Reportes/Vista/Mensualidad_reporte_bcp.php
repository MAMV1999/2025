<?php
require('../../General/fpdf/fpdf.php');
require_once("../Modelo/Mensualidad_reporte_bcp.php");

class PDF extends FPDF
{
    function Header()
    {
        $this->SetFont('Arial', 'B', 12);
        $this->Cell(0, 8, utf8_decode('REPORTE DE MENSUALIDAD FORMATO BCP'), 0, 1, 'C');
        $this->Ln(2);

        $this->SetFont('Arial', 'B', 8);
        $this->Cell(20, 8, utf8_decode('CÓDIGO'), 1, 0, 'C');
        $this->Cell(55, 8, utf8_decode('DEPOSITANTE'), 1, 0, 'C');
        $this->Cell(55, 8, utf8_decode('RETORNO'), 1, 0, 'C');
        $this->Cell(25, 8, utf8_decode('F. EMISIÓN'), 1, 0, 'C');
        $this->Cell(25, 8, utf8_decode('F. VENCIMIENTO'), 1, 0, 'C');
        $this->Cell(20, 8, utf8_decode('MONTO'), 1, 0, 'C');
        $this->Cell(15, 8, utf8_decode('MORA'), 1, 0, 'C');
        $this->Cell(25, 8, utf8_decode('M. MÍNIMO'), 1, 0, 'C');
        $this->Cell(20, 8, utf8_decode('REGISTRO'), 1, 0, 'C');
        $this->Cell(25, 8, utf8_decode('DOCUMENTO'), 1, 1, 'C');
    }

    function Footer()
    {
        $this->SetY(-12);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 8, utf8_decode('Página ') . $this->PageNo(), 0, 0, 'C');
    }
}

// Crear el PDF en horizontal y márgenes ajustados
$pdf = new PDF('L', 'mm', 'A4');
$pdf->SetMargins(10, 10, 10);
$pdf->AddPage();
$pdf->SetFont('Arial', '', 8);

$modelo = new Mensualidadbcp();
$rspta = $modelo->listar();

while ($reg = $rspta->fetch_object()) {
    $pdf->Cell(20, 7, utf8_decode($reg->CODIGO), 1, 0, 'C');
    $pdf->Cell(55, 7, utf8_decode($reg->DEPOSITANTE), 1, 0, 'L');
    $pdf->Cell(55, 7, utf8_decode($reg->RETORNO), 1, 0, 'L');
    $pdf->Cell(25, 7, utf8_decode($reg->FECHA_EMISION), 1, 0, 'C');
    $pdf->Cell(25, 7, utf8_decode($reg->FECHA_VENCIMIENTO), 1, 0, 'C');
    $pdf->Cell(20, 7, number_format($reg->MONTO, 2), 1, 0, 'R');
    $pdf->Cell(15, 7, number_format($reg->MORA, 2), 1, 0, 'R');
    $pdf->Cell(25, 7, number_format($reg->MONTO_MINIMO, 2), 1, 0, 'R');
    $pdf->Cell(20, 7, utf8_decode($reg->REGISTRO), 1, 0, 'C');
    $pdf->Cell(25, 7, utf8_decode($reg->DOCUMENTO), 1, 1, 'L');
}

$pdf->Output("I", "reporte_mensualidad_bcp.pdf");
?>
