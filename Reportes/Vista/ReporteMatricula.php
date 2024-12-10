<?php
require_once("../../General/fpdf/fpdf.php");
require_once("../Modelo/ReporteMatricula.php");

class PDF extends FPDF
{
    function Header()
    {
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(80);
        $this->Cell(30, 10, 'LISTADO DE ALUMNOS', 0, 1, 'C');
        $this->Ln(10);
    }

    function Footer()
    {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, 'Page ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
    }

    function ChapterTitle($lectivo, $nivel, $grado, $seccion)
    {
        $this->SetFont('Arial', 'B', 12);
        $this->SetFillColor(188, 188, 188);
        $totalWidth = $this->GetPageWidth() - 20;
        $cellWidth = $totalWidth / 4;

        $this->Cell($cellWidth, 9, utf8_decode($lectivo), 1, 0, 'C', true);
        $this->Cell($cellWidth, 9, utf8_decode($nivel), 1, 0, 'C', true);
        $this->Cell($cellWidth, 9, utf8_decode($grado), 1, 0, 'C', true);
        $this->Cell($cellWidth, 9, utf8_decode($seccion), 1, 1, 'C', true);
        $this->Ln(10);
    }

    function TableHeader()
    {
        $this->SetFont('Arial', 'B', 12);
        $this->Cell(10, 10, '#', 0);
        $this->Cell(140, 10, 'APELLIDO Y NOMBRE', 0);
        $this->Cell(40, 10, 'CATEGORIA', 0);
        $this->Ln();
    }

    function TableRow($row, $num)
    {
        $this->SetFont('Arial', '', 12);
        $this->Cell(10, 10, $num, 0);

        if ($row['alumno'] === 'SIN ALUMNOS') {
            $this->SetFont('Arial', 'I', 12); // Cursiva para resaltar
        }

        $this->Cell(140, 10, utf8_decode($row['alumno']), 0);
        $this->SetFont('Arial', '', 12);
        $this->Cell(40, 10, utf8_decode($row['categoria']), 0);
        $this->Ln();
    }
}

$reporte = new ReporteMatricula();
$datos = $reporte->listar();

$pdf = new PDF();
$pdf->AliasNbPages();

$currentGrado = '';
$currentNivel = '';
$currentLectivo = '';
$currentSeccion = '';
$counter = 1;

while ($row = $datos->fetch_assoc()) {
    if ($row['grado'] !== $currentGrado || $row['nivel'] !== $currentNivel || $row['lectivo'] !== $currentLectivo || $row['seccion'] !== $currentSeccion) {
        $pdf->AddPage();
        $currentGrado = $row['grado'];
        $currentNivel = $row['nivel'];
        $currentLectivo = $row['lectivo'];
        $currentSeccion = $row['seccion'];
        $pdf->ChapterTitle($row['lectivo'], $row['nivel'], $row['grado'], $row['seccion']);
        $pdf->TableHeader();
        $counter = 1;
    }
    $pdf->TableRow($row, $counter);
    $counter++;
}

$pdf->Output();
