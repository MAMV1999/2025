-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-12-2024 a las 17:27:44
-- Versión del servidor: 10.1.31-MariaDB
-- Versión de PHP: 7.2.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `2025`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento`
--

CREATE TABLE `documento` (
  `id` int(11) NOT NULL,
  `id_documento_responsable` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `obligatorio` tinyint(1) NOT NULL DEFAULT '0',
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `documento`
--

INSERT INTO `documento` (`id`, `id_documento_responsable`, `nombre`, `obligatorio`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, 'FICHA UNICA DE MATRICULA', 1, '', '2024-11-24 06:23:32', 1),
(2, 1, 'CONSTANCIA DE MATRICULA', 1, '', '2024-11-24 06:23:45', 1),
(3, 1, 'CERTIFICADO DE ESTUDIOS', 1, '', '2024-11-24 06:23:56', 1),
(4, 1, 'INFORME DE PROGRESO / LIBRETA DE NOTAS', 0, '', '2024-11-24 06:24:07', 1),
(5, 1, 'CONSTANCIA DE NO ADEUDO', 1, '', '2024-11-24 06:24:19', 1),
(6, 2, 'CARNE DE VACUNACIÓN (NIÑO SANO / COVID)', 0, '', '2024-11-24 06:26:29', 1),
(7, 2, 'PARTIDA / ACTA DE NACIMIENTO', 0, '', '2024-11-24 06:26:40', 1),
(8, 2, 'COPIA DNI ALUMNO', 1, '', '2024-11-24 06:26:51', 1),
(9, 2, 'COPIA DNI APODERADO', 1, '', '2024-11-24 06:27:02', 1),
(10, 2, '6 FOTOS (TAMAÑO CARNET)', 0, '', '2024-11-24 06:27:14', 1),
(11, 2, 'FOTO FAMILIAR (TAMAÑO JUMBO)', 0, '', '2024-11-24 06:27:28', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento_detalle`
--

CREATE TABLE `documento_detalle` (
  `id` int(11) NOT NULL,
  `id_matricula_detalle` int(11) NOT NULL,
  `id_documento` int(11) NOT NULL,
  `entregado` tinyint(1) NOT NULL DEFAULT '0',
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento_estado`
--

CREATE TABLE `documento_estado` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `documento_estado`
--

INSERT INTO `documento_estado` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'NO', '', '2024-12-01 15:22:40', 1),
(2, 'SI', '', '2024-12-01 15:22:46', 1),
(3, 'OMITIDO', '', '2024-12-01 15:22:53', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento_responsable`
--

CREATE TABLE `documento_responsable` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `documento_responsable`
--

INSERT INTO `documento_responsable` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'COLEGIO PROCEDENCIA', '', '2024-11-24 06:22:10', 1),
(2, 'APODERADO', '', '2024-11-24 06:22:16', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion`
--

CREATE TABLE `institucion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_usuario_docente` int(11) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `ruc` varchar(11) NOT NULL,
  `razon_social` varchar(100) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion`
--

INSERT INTO `institucion` (`id`, `nombre`, `id_usuario_docente`, `telefono`, `correo`, `ruc`, `razon_social`, `direccion`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'IEP. EBENEZER', 1, '958197047', 'CBEBENEZER0791@GMAIL.COM', '20602116892', 'GAYCE E.I.R.L.', 'CAL.LOS PENSAMIENTOS NRO. 261 P.J. EL ERMITAÑO LIMA - LIMA - INDEPENDENCIA', '', '2024-11-24 05:54:21', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion_grado`
--

CREATE TABLE `institucion_grado` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_institucion_nivel` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion_grado`
--

INSERT INTO `institucion_grado` (`id`, `nombre`, `id_institucion_nivel`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, '3 AÑOS', 1, '', '2024-11-24 05:55:53', 1),
(2, '4 AÑOS', 1, '', '2024-11-24 05:56:02', 1),
(3, '5 AÑOS', 1, '', '2024-11-24 05:56:10', 1),
(4, '1 GRADO', 2, '', '2024-11-24 05:56:19', 1),
(5, '2 GRADO', 2, '', '2024-11-24 05:56:27', 1),
(6, '3 GRADO', 2, '', '2024-11-24 05:57:49', 1),
(7, '4 GRADO', 2, '', '2024-11-24 05:57:57', 1),
(8, '5 GRADO', 2, '', '2024-11-24 06:02:28', 1),
(9, '6 GRADO', 2, '', '2024-11-24 06:02:39', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion_lectivo`
--

CREATE TABLE `institucion_lectivo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `nombre_lectivo` varchar(300) NOT NULL,
  `id_institucion` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion_lectivo`
--

INSERT INTO `institucion_lectivo` (`id`, `nombre`, `nombre_lectivo`, `id_institucion`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, '2025', 'AñO DEL BICENTENARIO DE JOSé FAUSTINO SáNCHEZ CARRIóN Y DEFENSA DE LA REPúBLICA PERUANA', 1, '', '2024-11-24 05:54:57', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion_nivel`
--

CREATE TABLE `institucion_nivel` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_institucion_lectivo` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion_nivel`
--

INSERT INTO `institucion_nivel` (`id`, `nombre`, `id_institucion_lectivo`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'INICIAL', 1, '', '2024-11-24 05:55:26', 1),
(2, 'PRIMARIA', 1, '', '2024-11-24 05:55:36', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion_seccion`
--

CREATE TABLE `institucion_seccion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_institucion_grado` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion_seccion`
--

INSERT INTO `institucion_seccion` (`id`, `nombre`, `id_institucion_grado`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'A', 1, '', '2024-11-24 06:03:28', 1),
(2, 'A', 2, '', '2024-11-24 06:03:34', 1),
(3, 'A', 3, '', '2024-11-24 06:03:40', 1),
(4, 'A', 4, '', '2024-11-24 06:03:46', 1),
(5, 'A', 5, '', '2024-11-24 06:03:50', 1),
(6, 'A', 6, '', '2024-11-24 06:03:57', 1),
(7, 'A', 7, '', '2024-11-24 06:04:02', 1),
(8, 'A', 8, '', '2024-11-24 06:04:08', 1),
(9, 'A', 9, '', '2024-11-24 06:04:14', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `institucion_validacion`
--

CREATE TABLE `institucion_validacion` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `institucion_validacion`
--

INSERT INTO `institucion_validacion` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, '73937543', '', '2024-11-30 14:59:55', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula`
--

CREATE TABLE `matricula` (
  `id` int(11) NOT NULL,
  `id_institucion_seccion` int(11) NOT NULL,
  `id_usuario_docente` int(11) NOT NULL,
  `preciomatricula` decimal(10,2) NOT NULL,
  `preciomensualidad` decimal(10,2) NOT NULL,
  `preciomantenimiento` decimal(10,2) NOT NULL,
  `aforo` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula`
--

INSERT INTO `matricula` (`id`, `id_institucion_seccion`, `id_usuario_docente`, `preciomatricula`, `preciomensualidad`, `preciomantenimiento`, `aforo`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, 1, '200.00', '270.00', '25.00', 20, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:09:41', 1),
(2, 2, 1, '200.00', '270.00', '25.00', 20, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:13:01', 1),
(3, 3, 1, '200.00', '280.00', '25.00', 20, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:13:27', 1),
(4, 4, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:13:45', 1),
(5, 5, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:14:19', 1),
(6, 6, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:14:49', 1),
(7, 7, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:15:11', 1),
(8, 8, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:15:29', 1),
(9, 9, 1, '200.00', '300.00', '25.00', 18, 'Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '2024-11-24 06:15:44', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula_categoria`
--

CREATE TABLE `matricula_categoria` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula_categoria`
--

INSERT INTO `matricula_categoria` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'RATIFICACION', '', '2024-11-24 06:06:30', 1),
(2, 'NUEVO', '', '2024-11-24 06:06:35', 1),
(3, 'TRASLADO', '', '2024-11-24 06:06:42', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula_detalle`
--

CREATE TABLE `matricula_detalle` (
  `id` int(11) NOT NULL,
  `descripcion` text NOT NULL,
  `id_matricula` int(11) NOT NULL,
  `id_matricula_categoria` int(11) NOT NULL,
  `id_usuario_apoderado_referido` int(11) DEFAULT NULL,
  `id_usuario_apoderado` int(11) NOT NULL,
  `id_usuario_alumno` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula_detalle`
--

INSERT INTO `matricula_detalle` (`id`, `descripcion`, `id_matricula`, `id_matricula_categoria`, `id_usuario_apoderado_referido`, `id_usuario_apoderado`, `id_usuario_alumno`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 3, 1, NULL, 1, 1, '', '2024-12-01 05:46:02', 1),
(2, 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 3, 1, NULL, 2, 2, '', '2024-12-01 05:47:30', 1),
(3, 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 3, 1, NULL, 3, 3, '', '2024-12-01 05:48:55', 1),
(7, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 7, 7, '', '2024-12-03 15:52:48', 1),
(8, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 6, 1, NULL, 7, 8, '', '2024-12-03 15:54:19', 1),
(9, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 7, 1, NULL, 8, 9, '', '2024-12-03 19:26:44', 1),
(10, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 5, 1, NULL, 8, 10, '', '2024-12-03 19:35:37', 1),
(11, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 5, 1, NULL, 9, 11, '', '2024-12-03 20:05:47', 1),
(13, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 5, 1, NULL, 11, 13, '', '2024-12-03 20:15:53', 1),
(14, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 6, 1, NULL, 12, 14, '', '2024-12-03 20:17:20', 1),
(15, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 8, 1, NULL, 13, 15, '', '2024-12-03 20:18:52', 1),
(16, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 14, 16, '', '2024-12-03 20:20:32', 1),
(17, 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 15, 17, '', '2024-12-03 20:25:54', 1),
(18, 'MATRICULA 2025 - 10/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 7, 1, NULL, 16, 18, '', '2024-12-10 19:51:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula_metodo_pago`
--

CREATE TABLE `matricula_metodo_pago` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula_metodo_pago`
--

INSERT INTO `matricula_metodo_pago` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'EFECTIVO', '', '2024-11-24 06:05:48', 1),
(2, 'YAPE', '', '2024-11-24 06:05:54', 1),
(3, 'TRANSFERENCIA', '', '2024-11-24 06:06:02', 1),
(4, 'INTERBANCARIO', '', '2024-11-24 06:06:11', 1),
(5, 'PAGO PENDIENTE', '', '2024-11-25 05:41:01', 1),
(6, 'MATRICULA GRATIS', '', '2024-12-01 06:17:48', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula_pago`
--

CREATE TABLE `matricula_pago` (
  `id` int(11) NOT NULL,
  `id_matricula_detalle` int(11) NOT NULL,
  `numeracion` varchar(50) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` text NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `id_matricula_metodo_pago` int(11) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `matricula_pago`
--

INSERT INTO `matricula_pago` (`id`, `id_matricula_detalle`, `numeracion`, `fecha`, `descripcion`, `monto`, `id_matricula_metodo_pago`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, '000001', '2024-12-01', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-01 05:46:02', 1),
(2, 2, '000002', '2024-12-01', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-01 05:47:30', 1),
(3, 3, '000003', '2024-12-01', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-01 05:48:55', 1),
(7, 7, '000004', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 15:52:48', 1),
(8, 8, '000005', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 15:54:19', 1),
(9, 9, '000006', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 19:26:44', 1),
(10, 10, '000007', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 19:35:37', 1),
(11, 11, '000008', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:05:47', 1),
(13, 13, '000009', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 20:15:53', 1),
(14, 14, '000010', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:17:20', 1),
(15, 15, '000011', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:18:52', 1),
(16, 16, '000012', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:20:32', 1),
(17, 17, '000013', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:25:54', 1),
(18, 18, '000014', '2024-12-10', 'MATRICULA 2025 - 10/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-10 19:51:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensualidad_detalle`
--

CREATE TABLE `mensualidad_detalle` (
  `id` int(11) NOT NULL,
  `id_mensualidad_mes` int(11) NOT NULL,
  `id_matricula_detalle` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `pagado` tinyint(1) NOT NULL DEFAULT '0',
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `mensualidad_detalle`
--

INSERT INTO `mensualidad_detalle` (`id`, `id_mensualidad_mes`, `id_matricula_detalle`, `monto`, `pagado`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(2, 2, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(3, 3, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(4, 4, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(5, 5, 1, '305.00', 0, '', '2024-12-01 05:46:02', 1),
(6, 6, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(7, 7, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(8, 8, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(9, 9, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(10, 10, 1, '305.00', 0, '', '2024-12-01 05:46:02', 1),
(11, 1, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(12, 2, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(13, 3, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(14, 4, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(15, 5, 2, '305.00', 0, '', '2024-12-01 05:47:30', 1),
(16, 6, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(17, 7, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(18, 8, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(19, 9, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(20, 10, 2, '305.00', 0, '', '2024-12-01 05:47:30', 1),
(21, 1, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(22, 2, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(23, 3, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(24, 4, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(25, 5, 3, '305.00', 0, '', '2024-12-01 05:48:55', 1),
(26, 6, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(27, 7, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(28, 8, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(29, 9, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(30, 10, 3, '305.00', 0, '', '2024-12-01 05:48:55', 1),
(34, 1, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(35, 2, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(36, 3, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(37, 4, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(38, 5, 7, '325.00', 0, '', '2024-12-03 15:52:48', 1),
(39, 6, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(40, 7, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(41, 8, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(42, 9, 7, '300.00', 0, '', '2024-12-03 15:52:48', 1),
(43, 10, 7, '325.00', 0, '', '2024-12-03 15:52:48', 1),
(44, 1, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(45, 2, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(46, 3, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(47, 4, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(48, 5, 8, '325.00', 0, '', '2024-12-03 15:54:19', 1),
(49, 6, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(50, 7, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(51, 8, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(52, 9, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(53, 10, 8, '325.00', 0, '', '2024-12-03 15:54:19', 1),
(54, 1, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(55, 2, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(56, 3, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(57, 4, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(58, 5, 9, '325.00', 0, '', '2024-12-03 19:26:44', 1),
(59, 6, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(60, 7, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(61, 8, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(62, 9, 9, '300.00', 0, '', '2024-12-03 19:26:44', 1),
(63, 10, 9, '325.00', 0, '', '2024-12-03 19:26:44', 1),
(64, 1, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(65, 2, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(66, 3, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(67, 4, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(68, 5, 10, '325.00', 0, '', '2024-12-03 19:35:37', 1),
(69, 6, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(70, 7, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(71, 8, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(72, 9, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(73, 10, 10, '325.00', 0, '', '2024-12-03 19:35:37', 1),
(74, 1, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(75, 2, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(76, 3, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(77, 4, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(78, 5, 11, '325.00', 0, '', '2024-12-03 20:05:47', 1),
(79, 6, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(80, 7, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(81, 8, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(82, 9, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(83, 10, 11, '325.00', 0, '', '2024-12-03 20:05:47', 1),
(94, 1, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(95, 2, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(96, 3, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(97, 4, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(98, 5, 13, '325.00', 0, '', '2024-12-03 20:15:53', 1),
(99, 6, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(100, 7, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(101, 8, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(102, 9, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(103, 10, 13, '325.00', 0, '', '2024-12-03 20:15:53', 1),
(104, 1, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(105, 2, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(106, 3, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(107, 4, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(108, 5, 14, '325.00', 0, '', '2024-12-03 20:17:20', 1),
(109, 6, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(110, 7, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(111, 8, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(112, 9, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(113, 10, 14, '325.00', 0, '', '2024-12-03 20:17:20', 1),
(114, 1, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(115, 2, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(116, 3, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(117, 4, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(118, 5, 15, '325.00', 0, '', '2024-12-03 20:18:52', 1),
(119, 6, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(120, 7, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(121, 8, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(122, 9, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(123, 10, 15, '325.00', 0, '', '2024-12-03 20:18:52', 1),
(124, 1, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(125, 2, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(126, 3, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(127, 4, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(128, 5, 16, '325.00', 0, '', '2024-12-03 20:20:32', 1),
(129, 6, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(130, 7, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(131, 8, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(132, 9, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(133, 10, 16, '325.00', 0, '', '2024-12-03 20:20:32', 1),
(134, 1, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(135, 2, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(136, 3, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(137, 4, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(138, 5, 17, '325.00', 0, '', '2024-12-03 20:25:54', 1),
(139, 6, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(140, 7, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(141, 8, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(142, 9, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(143, 10, 17, '325.00', 0, '', '2024-12-03 20:25:54', 1),
(144, 1, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(145, 2, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(146, 3, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(147, 4, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(148, 5, 18, '325.00', 0, '', '2024-12-10 19:51:02', 1),
(149, 6, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(150, 7, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(151, 8, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(152, 9, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(153, 10, 18, '325.00', 0, '', '2024-12-10 19:51:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensualidad_mes`
--

CREATE TABLE `mensualidad_mes` (
  `id` int(11) NOT NULL,
  `id_institucion_lectivo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `pago_mantenimiento` tinyint(1) NOT NULL DEFAULT '0',
  `fechavencimiento` date DEFAULT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `mensualidad_mes`
--

INSERT INTO `mensualidad_mes` (`id`, `id_institucion_lectivo`, `nombre`, `descripcion`, `pago_mantenimiento`, `fechavencimiento`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, 'MARZO', 'MENSUALIDAD MARZO', 0, '2025-04-01', '', '2024-11-24 06:31:02', 1),
(2, 1, 'ABRIL', 'MENSUALIDAD ABRIL', 0, '2025-05-01', '', '2024-11-24 06:31:59', 1),
(3, 1, 'MAYO', 'MENSUALIDAD MAYO', 0, '2025-06-01', '', '2024-11-24 06:33:03', 1),
(4, 1, 'JUNIO', 'MENSUALIDAD JUNIO', 0, '2025-07-01', '', '2024-11-24 06:33:16', 1),
(5, 1, 'JULIO', 'MENSUALIDAD JULIO', 1, '2025-08-01', '', '2024-11-24 06:33:31', 1),
(6, 1, 'AGOSTO', 'MENSUALIDAD AGOSTO', 0, '2025-09-01', '', '2024-11-24 06:33:44', 1),
(7, 1, 'SEPTIEMBRE', 'MENSUALIDAD SEPTIEMBRE', 0, '2025-10-01', '', '2024-11-24 06:34:06', 1),
(8, 1, 'OCTUBRE', 'MENSUALIDAD OCTUBRE', 0, '2025-11-01', '', '2024-11-24 06:34:23', 1),
(9, 1, 'NOVIEMBRE', 'MENSUALIDAD NOVIEMBRE', 0, '2025-12-01', '', '2024-11-24 06:34:40', 1),
(10, 1, 'DICIEMBRE', 'MENSUALIDAD DICIEMBRE', 1, '2025-12-31', '', '2024-11-24 06:34:52', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_alumno`
--

CREATE TABLE `usuario_alumno` (
  `id` int(11) NOT NULL,
  `id_apoderado` int(11) NOT NULL,
  `id_documento` int(11) NOT NULL,
  `numerodocumento` varchar(20) NOT NULL,
  `nombreyapellido` varchar(100) NOT NULL,
  `nacimiento` date DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_sexo` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_alumno`
--

INSERT INTO `usuario_alumno` (`id`, `id_apoderado`, `id_documento`, `numerodocumento`, `nombreyapellido`, `nacimiento`, `telefono`, `id_sexo`, `usuario`, `clave`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, 1, '91490868', 'BRAVO LAVI AINHOA LORENA', '2019-09-03', '', 1, '91490868', '91490868', '', '2024-12-01 05:46:02', 1),
(2, 2, 1, '91339973', 'PAREDES SAYO LUCIANA ALESSANDRA', '2019-05-20', '', 1, '91339973', '91339973', '', '2024-12-01 05:47:30', 1),
(3, 3, 1, '91418340', 'CASTILLO CHERO LIAM ALEXANDER', '2019-07-16', '', 2, '91418340', '91418340', '', '2024-12-01 05:48:55', 1),
(7, 7, 1, '78193503', 'ROJAS SANCHO ABRAHAM KEILEB', '2013-07-27', '', 2, '78193503', '78193503', '', '2024-12-03 15:52:48', 1),
(8, 7, 1, '79738641', 'ROJAS SANCHO PABLO JEREMIAS', '2016-06-30', '', 2, '79738641', '79738641', '', '2024-12-03 15:54:19', 1),
(9, 8, 1, '79469636', 'PALOMINO MENDEZ ALMENDRA JAZMIN', '2015-12-27', '', 1, '79469636', '79469636', '', '2024-12-03 19:26:44', 1),
(10, 8, 1, '90412868', 'PALOMINO MENDEZ AXEL JOSUÉ', '2017-07-09', '', 2, '90412868', '90412868', '', '2024-12-03 19:35:37', 1),
(11, 9, 1, '90391163', 'SIFUENTES CORREA SOFIA NICOLE', '2017-09-01', '', 1, '90391163', '90391163', '', '2024-12-03 20:05:47', 1),
(13, 11, 1, '90495561', 'QUINTANA VARGAS MARIANO ESTIVEN', '2017-11-03', '', 2, '90495561', '90495561', '', '2024-12-03 20:15:53', 1),
(14, 12, 1, '79878771', 'ESPINOZA GARCIA ANGELO CAMILO', '2016-10-01', '', 2, '79878771', '79878771', '', '2024-12-03 20:17:20', 1),
(15, 13, 1, '78915280', 'RIOS PEREIRA VICTORIA ARIANA', '2015-01-08', '', 1, '78915280', '78915280', '', '2024-12-03 20:18:52', 1),
(16, 14, 1, '78309084', 'DAMASO TITO DILAN MISAEL', '2013-10-10', '', 2, '78309084', '78309084', '', '2024-12-03 20:20:32', 1),
(17, 15, 1, '78226136', 'INFANZON CARDENAS MATHIAS AARON', '2013-08-28', '', 2, '78226136', '78226136', '', '2024-12-03 20:25:54', 1),
(18, 16, 1, '79176666', 'OBREGON RISCO MIQUEAS SANTIAGO', '2015-06-27', '', 2, '79176666', '79176666', '', '2024-12-10 19:51:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_apoderado`
--

CREATE TABLE `usuario_apoderado` (
  `id` int(11) NOT NULL,
  `id_apoderado_tipo` int(11) NOT NULL,
  `id_documento` int(11) NOT NULL,
  `numerodocumento` varchar(20) NOT NULL,
  `nombreyapellido` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `id_sexo` int(11) NOT NULL,
  `id_estado_civil` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_apoderado`
--

INSERT INTO `usuario_apoderado` (`id`, `id_apoderado_tipo`, `id_documento`, `numerodocumento`, `nombreyapellido`, `telefono`, `id_sexo`, `id_estado_civil`, `usuario`, `clave`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 2, 1, '44589835', 'GIAN CARLO ANTONIO BRAVO VELASQUEZ', '914778086', 2, 2, '44589835', '44589835', '', '2024-12-01 05:46:02', 1),
(2, 1, 1, '10161788', 'INES SAYO ANAYA', '996627688', 1, 2, '10161788', '10161788', '', '2024-12-01 05:47:30', 1),
(3, 1, 1, '75656377', 'MARCIA JANELLI CHERO MONTES', '994070866', 1, 1, '75656377', '75656377', '', '2024-12-01 05:48:55', 1),
(7, 1, 1, '47708402', 'LAURA ANGELICA SANCHO ALCANTARA', '978673981', 1, 1, '47708402', '47708402', '', '2024-12-03 15:52:48', 1),
(8, 1, 1, '47169725', 'SINTHIA KATERINE MENDEZ ZAVALETA', '943215408', 1, 2, '47169725', '47169725', '', '2024-12-03 19:26:44', 1),
(9, 1, 1, '47875566', 'ERICKA EDITH CORREA ROJAS', '935168567', 1, 1, '47875566', '47875566', '', '2024-12-03 20:05:47', 1),
(11, 2, 1, '09616813', 'JUVENAL QUINTANA ALVAREZ', '991179293', 2, 1, '09616813', '09616813', '', '2024-12-03 20:15:53', 1),
(12, 1, 1, '40148474', 'MELINDA GARCIA OLIVAS', '935928398', 1, 2, '40148474', '40148474', '', '2024-12-03 20:17:20', 1),
(13, 1, 1, '43289465', 'PEREIRA LOPEZ DAYSY BELGICA', '982525851', 1, 2, '43289465', '43289465', '', '2024-12-03 20:18:52', 1),
(14, 1, 1, '42817048', 'MARIA ELENA TITO QUISPE', '984034603', 1, 2, '42817048', '42817048', '', '2024-12-03 20:20:32', 1),
(15, 1, 1, '40908831', 'WUENDY KAREN CARDENAS MATOS', '993436180', 1, 2, '40908831', '40908831', '', '2024-12-03 20:25:54', 1),
(16, 3, 1, '10154401', 'MARGOT JULIANA GARCIA ALVARADO', '993983970', 1, 3, '10154401', '10154401', '', '2024-12-10 19:51:02', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_apoderado_tipo`
--

CREATE TABLE `usuario_apoderado_tipo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_apoderado_tipo`
--

INSERT INTO `usuario_apoderado_tipo` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'MADRE', '', '2024-11-24 05:47:11', 1),
(2, 'PADRE', '', '2024-11-24 05:47:19', 1),
(3, 'REPRESENTANTE LEGAL', '', '2024-11-24 05:47:30', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_cargo`
--

CREATE TABLE `usuario_cargo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_cargo`
--

INSERT INTO `usuario_cargo` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'DIRECTOR', '', '2024-11-24 05:50:33', 1),
(2, 'ADMINISTRATIVO', '', '2024-11-24 05:51:00', 1),
(3, 'DOCENTE', '', '2024-11-24 05:51:06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_docente`
--

CREATE TABLE `usuario_docente` (
  `id` int(11) NOT NULL,
  `id_documento` int(11) NOT NULL,
  `numerodocumento` varchar(20) NOT NULL,
  `nombreyapellido` varchar(100) NOT NULL,
  `nacimiento` date NOT NULL,
  `id_estado_civil` int(11) NOT NULL,
  `id_sexo` int(11) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `id_cargo` int(11) NOT NULL,
  `id_tipo_contrato` int(11) DEFAULT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date DEFAULT NULL,
  `sueldo` decimal(10,2) NOT NULL,
  `cuentabancaria` varchar(20) DEFAULT NULL,
  `cuentainterbancaria` varchar(20) DEFAULT NULL,
  `sunat_ruc` varchar(11) DEFAULT NULL,
  `sunat_usuario` varchar(50) NOT NULL,
  `sunat_contraseña` varchar(255) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `clave` varchar(255) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_docente`
--

INSERT INTO `usuario_docente` (`id`, `id_documento`, `numerodocumento`, `nombreyapellido`, `nacimiento`, `id_estado_civil`, `id_sexo`, `direccion`, `telefono`, `correo`, `id_cargo`, `id_tipo_contrato`, `fechainicio`, `fechafin`, `sueldo`, `cuentabancaria`, `cuentainterbancaria`, `sunat_ruc`, `sunat_usuario`, `sunat_contraseña`, `usuario`, `clave`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 1, '73937543', 'MARCO ANTONIO MANRIQUE VARILLAS', '1999-06-18', 1, 2, 'PROLONG. LAS GLADIOLAS MZ.X LT.12 EL ERMITAÑO', '994947452', 'MMANRIQUEVARILLAS99@GMAIL.COM', 2, 1, '0000-00-00', '0000-00-00', '0.00', '', '', '', '', '', '73937543', '73937543', '', '2024-11-24 05:52:35', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_documento`
--

CREATE TABLE `usuario_documento` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_documento`
--

INSERT INTO `usuario_documento` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'DNI', '', '2024-11-24 05:49:16', 1),
(2, 'PASAPORTE', '', '2024-11-24 05:49:35', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_estado_civil`
--

CREATE TABLE `usuario_estado_civil` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_estado_civil`
--

INSERT INTO `usuario_estado_civil` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'SOLTERO(A)', '', '2024-11-24 05:48:21', 1),
(2, 'CASADO(A)', '', '2024-11-24 05:48:30', 1),
(3, 'VIUDO(A)', '', '2024-11-24 05:48:46', 1),
(4, 'DIVORCIADO(A)', '', '2024-11-24 05:48:58', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_sexo`
--

CREATE TABLE `usuario_sexo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_sexo`
--

INSERT INTO `usuario_sexo` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'FEMENINO', '', '2024-11-24 05:47:45', 1),
(2, 'MASCULINO', '', '2024-11-24 05:47:53', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_tipo_contrato`
--

CREATE TABLE `usuario_tipo_contrato` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_tipo_contrato`
--

INSERT INTO `usuario_tipo_contrato` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'PLANILLA', '', '2024-11-24 05:51:20', 1),
(2, 'RECIBO POR HONORARIO', '', '2024-11-24 05:51:32', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `documento`
--
ALTER TABLE `documento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_documento_responsable` (`id_documento_responsable`);

--
-- Indices de la tabla `documento_detalle`
--
ALTER TABLE `documento_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_matricula_detalle` (`id_matricula_detalle`),
  ADD KEY `id_documento` (`id_documento`);

--
-- Indices de la tabla `documento_estado`
--
ALTER TABLE `documento_estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `documento_responsable`
--
ALTER TABLE `documento_responsable`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `institucion`
--
ALTER TABLE `institucion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario_docente` (`id_usuario_docente`);

--
-- Indices de la tabla `institucion_grado`
--
ALTER TABLE `institucion_grado`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion_nivel` (`id_institucion_nivel`);

--
-- Indices de la tabla `institucion_lectivo`
--
ALTER TABLE `institucion_lectivo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion` (`id_institucion`);

--
-- Indices de la tabla `institucion_nivel`
--
ALTER TABLE `institucion_nivel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion_lectivo` (`id_institucion_lectivo`);

--
-- Indices de la tabla `institucion_seccion`
--
ALTER TABLE `institucion_seccion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion_grado` (`id_institucion_grado`);

--
-- Indices de la tabla `institucion_validacion`
--
ALTER TABLE `institucion_validacion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion_seccion` (`id_institucion_seccion`),
  ADD KEY `id_usuario_docente` (`id_usuario_docente`);

--
-- Indices de la tabla `matricula_categoria`
--
ALTER TABLE `matricula_categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `matricula_detalle`
--
ALTER TABLE `matricula_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_matricula_detalle_matricula` (`id_matricula`),
  ADD KEY `fk_matricula_detalle_matricula_categoria` (`id_matricula_categoria`),
  ADD KEY `fk_matricula_detalle_usuario_apoderado` (`id_usuario_apoderado`),
  ADD KEY `fk_matricula_detalle_usuario_alumno` (`id_usuario_alumno`),
  ADD KEY `fk_matricula_detalle_usuario_apoderado_referido` (`id_usuario_apoderado_referido`);

--
-- Indices de la tabla `matricula_metodo_pago`
--
ALTER TABLE `matricula_metodo_pago`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `matricula_pago`
--
ALTER TABLE `matricula_pago`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_matricula_pago_matricula_detalle` (`id_matricula_detalle`),
  ADD KEY `fk_matricula_pago_metodo_pago` (`id_matricula_metodo_pago`);

--
-- Indices de la tabla `mensualidad_detalle`
--
ALTER TABLE `mensualidad_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mensualidad_mes` (`id_mensualidad_mes`),
  ADD KEY `id_matricula_detalle` (`id_matricula_detalle`);

--
-- Indices de la tabla `mensualidad_mes`
--
ALTER TABLE `mensualidad_mes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_institucion_lectivo` (`id_institucion_lectivo`);

--
-- Indices de la tabla `usuario_alumno`
--
ALTER TABLE `usuario_alumno`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_apoderado` (`id_apoderado`),
  ADD KEY `id_documento` (`id_documento`),
  ADD KEY `id_sexo` (`id_sexo`);

--
-- Indices de la tabla `usuario_apoderado`
--
ALTER TABLE `usuario_apoderado`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_apoderado_tipo` (`id_apoderado_tipo`),
  ADD KEY `id_documento` (`id_documento`),
  ADD KEY `id_sexo` (`id_sexo`),
  ADD KEY `id_estado_civil` (`id_estado_civil`);

--
-- Indices de la tabla `usuario_apoderado_tipo`
--
ALTER TABLE `usuario_apoderado_tipo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario_cargo`
--
ALTER TABLE `usuario_cargo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario_docente`
--
ALTER TABLE `usuario_docente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_documento` (`id_documento`),
  ADD KEY `id_estado_civil` (`id_estado_civil`),
  ADD KEY `id_cargo` (`id_cargo`),
  ADD KEY `id_tipo_contrato` (`id_tipo_contrato`),
  ADD KEY `id_sexo` (`id_sexo`);

--
-- Indices de la tabla `usuario_documento`
--
ALTER TABLE `usuario_documento`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario_estado_civil`
--
ALTER TABLE `usuario_estado_civil`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario_sexo`
--
ALTER TABLE `usuario_sexo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario_tipo_contrato`
--
ALTER TABLE `usuario_tipo_contrato`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `documento`
--
ALTER TABLE `documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `documento_detalle`
--
ALTER TABLE `documento_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `documento_estado`
--
ALTER TABLE `documento_estado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `documento_responsable`
--
ALTER TABLE `documento_responsable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `institucion`
--
ALTER TABLE `institucion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `institucion_grado`
--
ALTER TABLE `institucion_grado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `institucion_lectivo`
--
ALTER TABLE `institucion_lectivo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `institucion_nivel`
--
ALTER TABLE `institucion_nivel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `institucion_seccion`
--
ALTER TABLE `institucion_seccion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `institucion_validacion`
--
ALTER TABLE `institucion_validacion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `matricula`
--
ALTER TABLE `matricula`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `matricula_categoria`
--
ALTER TABLE `matricula_categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `matricula_detalle`
--
ALTER TABLE `matricula_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `matricula_metodo_pago`
--
ALTER TABLE `matricula_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `matricula_pago`
--
ALTER TABLE `matricula_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `mensualidad_detalle`
--
ALTER TABLE `mensualidad_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;

--
-- AUTO_INCREMENT de la tabla `mensualidad_mes`
--
ALTER TABLE `mensualidad_mes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuario_alumno`
--
ALTER TABLE `usuario_alumno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `usuario_apoderado`
--
ALTER TABLE `usuario_apoderado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `usuario_apoderado_tipo`
--
ALTER TABLE `usuario_apoderado_tipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario_cargo`
--
ALTER TABLE `usuario_cargo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario_docente`
--
ALTER TABLE `usuario_docente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuario_documento`
--
ALTER TABLE `usuario_documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuario_estado_civil`
--
ALTER TABLE `usuario_estado_civil`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuario_sexo`
--
ALTER TABLE `usuario_sexo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuario_tipo_contrato`
--
ALTER TABLE `usuario_tipo_contrato`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `documento`
--
ALTER TABLE `documento`
  ADD CONSTRAINT `documento_ibfk_1` FOREIGN KEY (`id_documento_responsable`) REFERENCES `documento_responsable` (`id`);

--
-- Filtros para la tabla `documento_detalle`
--
ALTER TABLE `documento_detalle`
  ADD CONSTRAINT `documento_detalle_ibfk_1` FOREIGN KEY (`id_matricula_detalle`) REFERENCES `matricula_detalle` (`id`),
  ADD CONSTRAINT `documento_detalle_ibfk_2` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id`);

--
-- Filtros para la tabla `institucion`
--
ALTER TABLE `institucion`
  ADD CONSTRAINT `institucion_ibfk_1` FOREIGN KEY (`id_usuario_docente`) REFERENCES `usuario_docente` (`id`);

--
-- Filtros para la tabla `institucion_grado`
--
ALTER TABLE `institucion_grado`
  ADD CONSTRAINT `institucion_grado_ibfk_1` FOREIGN KEY (`id_institucion_nivel`) REFERENCES `institucion_nivel` (`id`);

--
-- Filtros para la tabla `institucion_lectivo`
--
ALTER TABLE `institucion_lectivo`
  ADD CONSTRAINT `institucion_lectivo_ibfk_1` FOREIGN KEY (`id_institucion`) REFERENCES `institucion` (`id`);

--
-- Filtros para la tabla `institucion_nivel`
--
ALTER TABLE `institucion_nivel`
  ADD CONSTRAINT `institucion_nivel_ibfk_1` FOREIGN KEY (`id_institucion_lectivo`) REFERENCES `institucion_lectivo` (`id`);

--
-- Filtros para la tabla `institucion_seccion`
--
ALTER TABLE `institucion_seccion`
  ADD CONSTRAINT `institucion_seccion_ibfk_1` FOREIGN KEY (`id_institucion_grado`) REFERENCES `institucion_grado` (`id`);

--
-- Filtros para la tabla `matricula`
--
ALTER TABLE `matricula`
  ADD CONSTRAINT `matricula_ibfk_1` FOREIGN KEY (`id_institucion_seccion`) REFERENCES `institucion_seccion` (`id`),
  ADD CONSTRAINT `matricula_ibfk_2` FOREIGN KEY (`id_usuario_docente`) REFERENCES `usuario_docente` (`id`);

--
-- Filtros para la tabla `matricula_detalle`
--
ALTER TABLE `matricula_detalle`
  ADD CONSTRAINT `fk_matricula_detalle_matricula` FOREIGN KEY (`id_matricula`) REFERENCES `matricula` (`id`),
  ADD CONSTRAINT `fk_matricula_detalle_matricula_categoria` FOREIGN KEY (`id_matricula_categoria`) REFERENCES `matricula_categoria` (`id`),
  ADD CONSTRAINT `fk_matricula_detalle_usuario_alumno` FOREIGN KEY (`id_usuario_alumno`) REFERENCES `usuario_alumno` (`id`),
  ADD CONSTRAINT `fk_matricula_detalle_usuario_apoderado` FOREIGN KEY (`id_usuario_apoderado`) REFERENCES `usuario_apoderado` (`id`),
  ADD CONSTRAINT `fk_matricula_detalle_usuario_apoderado_referido` FOREIGN KEY (`id_usuario_apoderado_referido`) REFERENCES `usuario_apoderado` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `matricula_pago`
--
ALTER TABLE `matricula_pago`
  ADD CONSTRAINT `fk_matricula_pago_matricula_detalle` FOREIGN KEY (`id_matricula_detalle`) REFERENCES `matricula_detalle` (`id`),
  ADD CONSTRAINT `fk_matricula_pago_metodo_pago` FOREIGN KEY (`id_matricula_metodo_pago`) REFERENCES `matricula_metodo_pago` (`id`);

--
-- Filtros para la tabla `mensualidad_detalle`
--
ALTER TABLE `mensualidad_detalle`
  ADD CONSTRAINT `mensualidad_detalle_ibfk_1` FOREIGN KEY (`id_mensualidad_mes`) REFERENCES `mensualidad_mes` (`id`),
  ADD CONSTRAINT `mensualidad_detalle_ibfk_2` FOREIGN KEY (`id_matricula_detalle`) REFERENCES `matricula_detalle` (`id`);

--
-- Filtros para la tabla `mensualidad_mes`
--
ALTER TABLE `mensualidad_mes`
  ADD CONSTRAINT `mensualidad_mes_ibfk_1` FOREIGN KEY (`id_institucion_lectivo`) REFERENCES `institucion_lectivo` (`id`);

--
-- Filtros para la tabla `usuario_alumno`
--
ALTER TABLE `usuario_alumno`
  ADD CONSTRAINT `usuario_alumno_ibfk_1` FOREIGN KEY (`id_apoderado`) REFERENCES `usuario_apoderado` (`id`),
  ADD CONSTRAINT `usuario_alumno_ibfk_2` FOREIGN KEY (`id_documento`) REFERENCES `usuario_documento` (`id`),
  ADD CONSTRAINT `usuario_alumno_ibfk_3` FOREIGN KEY (`id_sexo`) REFERENCES `usuario_sexo` (`id`);

--
-- Filtros para la tabla `usuario_apoderado`
--
ALTER TABLE `usuario_apoderado`
  ADD CONSTRAINT `usuario_apoderado_ibfk_1` FOREIGN KEY (`id_apoderado_tipo`) REFERENCES `usuario_apoderado_tipo` (`id`),
  ADD CONSTRAINT `usuario_apoderado_ibfk_2` FOREIGN KEY (`id_documento`) REFERENCES `usuario_documento` (`id`),
  ADD CONSTRAINT `usuario_apoderado_ibfk_3` FOREIGN KEY (`id_sexo`) REFERENCES `usuario_sexo` (`id`),
  ADD CONSTRAINT `usuario_apoderado_ibfk_4` FOREIGN KEY (`id_estado_civil`) REFERENCES `usuario_estado_civil` (`id`);

--
-- Filtros para la tabla `usuario_docente`
--
ALTER TABLE `usuario_docente`
  ADD CONSTRAINT `usuario_docente_ibfk_1` FOREIGN KEY (`id_documento`) REFERENCES `usuario_documento` (`id`),
  ADD CONSTRAINT `usuario_docente_ibfk_2` FOREIGN KEY (`id_estado_civil`) REFERENCES `usuario_estado_civil` (`id`),
  ADD CONSTRAINT `usuario_docente_ibfk_3` FOREIGN KEY (`id_cargo`) REFERENCES `usuario_cargo` (`id`),
  ADD CONSTRAINT `usuario_docente_ibfk_4` FOREIGN KEY (`id_tipo_contrato`) REFERENCES `usuario_tipo_contrato` (`id`),
  ADD CONSTRAINT `usuario_docente_ibfk_5` FOREIGN KEY (`id_sexo`) REFERENCES `usuario_sexo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
