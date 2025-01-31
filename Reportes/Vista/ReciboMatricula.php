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
        $this->SetY(-23);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 5, utf8_decode('Fecha y Hora de generación: ' . $this->fecha_hora_actual), 0, 1, 'C');
        $this->Cell(0, 10, 'Página ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
    }

    function Recibo($data)
    {
        $this->AddPage();

        $this->SetFont('Arial', 'B', 25);
        $this->Cell(0, 10, utf8_decode($data['institucion_nombre']), 0, 1, 'C');
        $this->SetFont('Arial', 'B', 10);
        $this->Cell(0, 5, utf8_decode($data['institucion_direccion']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode($data['institucion_ruc'].' '.$data['institucion_razon_social']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode('CORREO '.$data['institucion_correo']), 0, 1, 'C');
        $this->Cell(0, 5, utf8_decode('TELEFONO '.$data['institucion_telefono']), 0, 1, 'C');
        $this->Ln(5);

        
        $this->SetFont('Arial', 'B', 17);
        $this->Cell(0, 8, utf8_decode('RECIBO N° '.$data['pago_numeracion']), 0, 1, 'C');
        $this->Ln(5);

        $this->SectionTitle('INFORMACIÓN DE MATRICULA');
        $this->SectionData('INSTITUCION', $data['institucion_nombre']);
        $this->SectionData('MATRICULA', $data['lectivo_nombre'].' / '.$data['nivel_nombre'].' / '.$data['grado_nombre'].' / '.$data['seccion_nombre']);
        $this->Ln(5);

        $this->SectionTitle('DATOS DEL APODERADO');
        $this->SectionData('DOCUMENTO', $data['apoderado_tipo_documento'].' - '.$data['apoderado_numero_documento']);
        $this->SectionData('NOMBRE', $data['apoderado_nombre_completo']);
        $this->SectionData('TELEFONO', $data['apoderado_telefono']);
        $this->Ln(5);

        $this->SectionTitle('DATOS DEL ALUMNO');
        $this->SectionData('DOCUMENTO', $data['alumno_tipo_documento'].' - '.$data['alumno_numero_documento']);
        $this->SectionData('APELLIDOS Y NOMBRES', $data['alumno_nombre_completo']);
        $this->Ln(5);

        $this->SectionTitle('INFORMACIÓN DE PAGO');
        $this->SectionData('NÚMERO DE RECIBO', $data['pago_numeracion']);
        $this->SectionData('FECHA', $data['pago_fecha']);
        $this->SectionData('MONTO', $data['pago_monto']);
        $this->SectionData('METODO', $data['metodo_pago_nombre']);
        $this->Ln(5);

        // Manejo del texto largo para la descripción
        //$this->SetFont('Arial', '', 8);
        //$this->MultiCell(0, 4, utf8_decode($data['pago_descripcion']), 0);
        //$this->Ln(5);
    }

    function SectionTitle($label)
    {
        $this->SetFont('Arial', 'B', 11);
        $this->SetFillColor(188, 188, 188);
        $this->Cell(0, 10, utf8_decode($label), 1, 1, 'L', true);
        $this->Ln(0);
    }

    function SectionData($label, $data)
    {
        $this->SetFont('Arial', '', 10);
        $this->Cell(50, 8, utf8_decode($label), 1);
        $this->Cell(0, 8, utf8_decode($data), 1, 1);
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

$filename = utf8_decode($data['alumno_nombre_completo']) . '.pdf';

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename="' . $filename . '"');
header('Cache-Control: private, max-age=0, must-revalidate');
header('Pragma: public');

$pdf->Output('I', $filename);
