<?php
require('../../General/fpdf/fpdf.php');
require_once("../Modelo/apoderados_matriculados.php");

class PDF extends FPDF
{
    // Cabecera del PDF
    function Header()
    {
        $this->SetFont('Arial', 'B', 14);
        $this->Cell(0, 10, utf8_decode('REPORTE DE APODERADOS'), 0, 1, 'C');
        $this->Ln(5);

        $this->SetFont('Arial', 'B', 10);
        $this->Cell(10, 10, utf8_decode('N°'), 1, 0, 'C');
        $this->Cell(150, 10, utf8_decode('NOMBRE DEL APODERADO'), 1, 0, 'C');
        $this->Cell(0, 10, utf8_decode('TELÉFONO'), 1, 1, 'C');
    }

    // Pie de página
    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, utf8_decode('PÁGINA ') . $this->PageNo(), 0, 0, 'C');
    }
}

// Instanciar PDF
$pdf = new PDF();
$pdf->AddPage();
$pdf->SetFont('Arial', '', 10);

$apoderado = new Apoderadosmatriculados();
$rspta = $apoderado->listar();

$contador = 1;
while ($reg = $rspta->fetch_object()) {
    $pdf->Cell(10, 8, utf8_decode($contador), 1, 0, 'C');
    $pdf->Cell(150, 8, utf8_decode($reg->nombre_apoderado), 1, 0, 'L');
    $pdf->Cell(0, 8, utf8_decode($reg->telefono), 1, 1, 'C');
    $contador++;
}

$pdf->Output("I", "reporte_apoderados_matriculados.pdf");
?>
