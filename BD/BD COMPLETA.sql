-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-03-2025 a las 04:54:00
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerDetallesMatricula` (`p_id` INT)  BEGIN
    -- Declaraciones para manejar el cursor y los datos
    DECLARE done INT DEFAULT FALSE;
    DECLARE documentoNombre VARCHAR(255);
    DECLARE documentosCursor CURSOR FOR SELECT nombre FROM documento;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Construcción inicial del SQL dinámico
    SET @sql = 'SELECT 
            md.id AS matricula_detalle_id,
            ins.nombre AS institucion_nombre,
            ins.telefono AS institucion_telefono,
            ins.correo AS institucion_correo,
            ins.ruc AS institucion_ruc,
            ins.razon_social AS institucion_razon_social,
            ins.direccion AS institucion_direccion,
            il.nombre AS institucion_lectivo,
            niv.nombre AS institucion_nivel, 
            ig.nombre AS institucion_grado,
            isec.nombre AS institucion_seccion,
            a.id AS apoderado_id,
            at.nombre AS apoderado_tipo,
            ad.nombre AS apoderado_documento_tipo,
            a.numerodocumento AS apoderado_numerodocumento,
            a.nombreyapellido AS apoderado_nombre,
            a.telefono AS apoderado_telefono,
            al.id AS alumno_id,
            ald.nombre AS alumno_documento_tipo,
            al.numerodocumento AS alumno_numerodocumento,
            al.nombreyapellido AS alumno_nombre';

    -- Abrir el cursor para recorrer los nombres de los documentos
    OPEN documentosCursor;

    -- Bucle para agregar las columnas dinámicas al SQL
    read_loop: LOOP
        FETCH documentosCursor INTO documentoNombre;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Añadir columnas dinámicas para los documentos
        SET @sql = CONCAT(@sql, 
            ', MAX(CASE WHEN d.nombre = ''', documentoNombre, ''' THEN 
                CASE 
                    WHEN IFNULL(dd.entregado, 0) = 1 THEN ''SI'' 
                    ELSE ''NO'' 
                END 
            ELSE ''NO'' END) AS `', documentoNombre, '`',
            ', MAX(CASE WHEN d.nombre = ''', documentoNombre, ''' THEN dd.observaciones ELSE \'\' END) AS `', documentoNombre, '_observaciones`'
        );
    END LOOP;

    -- Cerrar el cursor
    CLOSE documentosCursor;

    -- Completar el SQL dinámico con las cláusulas FROM, WHERE, GROUP BY y ORDER BY
    SET @sql = CONCAT(@sql, '
        FROM 
            matricula_detalle md
        JOIN 
            matricula m ON md.id_matricula = m.id
        JOIN 
            institucion_seccion isec ON m.id_institucion_seccion = isec.id
        JOIN 
            institucion_grado ig ON isec.id_institucion_grado = ig.id
        JOIN 
            institucion_nivel niv ON ig.id_institucion_nivel = niv.id
        JOIN 
            institucion_lectivo il ON niv.id_institucion_lectivo = il.id
        JOIN 
            institucion ins ON il.id_institucion = ins.id
        JOIN 
            usuario_apoderado a ON md.id_usuario_apoderado = a.id
        JOIN 
            usuario_apoderado_tipo at ON a.id_apoderado_tipo = at.id
        JOIN 
            usuario_documento ad ON a.id_documento = ad.id
        JOIN 
            usuario_alumno al ON md.id_usuario_alumno = al.id
        JOIN 
            usuario_documento ald ON al.id_documento = ald.id
        LEFT JOIN 
            documento_detalle dd ON md.id = dd.id_matricula_detalle
        LEFT JOIN 
            documento d ON dd.id_documento = d.id
        WHERE
            md.id = ', p_id, '
        GROUP BY 
            md.id, ins.nombre, ins.telefono, ins.correo, ins.ruc, ins.razon_social, ins.direccion, il.nombre, niv.nombre, ig.nombre, isec.nombre, 
            a.id, at.nombre, ad.nombre, a.numerodocumento, a.nombreyapellido, a.telefono, 
            al.id, ald.nombre, al.numerodocumento, al.nombreyapellido
        ORDER BY 
            ins.nombre ASC, niv.nombre ASC, ig.nombre ASC, isec.nombre ASC, al.nombreyapellido ASC
    ');

    -- Preparar y ejecutar la consulta dinámica
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_categoria`
--

CREATE TABLE `almacen_categoria` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `observaciones` text,
  `fechacreado` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_categoria`
--

INSERT INTO `almacen_categoria` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'DOCUMENTOS', '', '2024-12-27 02:26:34', 1),
(2, 'PRENDAS DE VESTIR', '', '2025-01-02 17:51:12', 1),
(3, 'CITA PSICOLÓGICA', '', '2025-01-15 15:21:25', 1),
(4, 'LIBROS ESCOLARES 2025', '', '2025-01-20 13:34:46', 1),
(5, 'PACKS ESCOLARES', '', '2025-01-20 13:50:49', 1),
(6, 'OTROS PAGOS', '', '2025-02-17 10:27:21', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_comprobante`
--

CREATE TABLE `almacen_comprobante` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `impuesto` decimal(10,2) NOT NULL DEFAULT '0.00',
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_comprobante`
--

INSERT INTO `almacen_comprobante` (`id`, `nombre`, `impuesto`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'BOLETA', '0.00', '', '2024-12-27 09:15:33', 1),
(2, 'RECIBO', '0.00', '', '2024-12-27 09:15:58', 0),
(3, 'FACTURA', '0.00', '', '2024-12-27 09:16:07', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_ingreso`
--

CREATE TABLE `almacen_ingreso` (
  `id` int(11) NOT NULL,
  `usuario_apoderado_id` int(11) NOT NULL,
  `almacen_comprobante_id` int(11) NOT NULL,
  `numeracion` varchar(50) NOT NULL,
  `fecha` date NOT NULL,
  `almacen_metodo_pago_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `observaciones` text,
  `fechacreado` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_ingreso`
--

INSERT INTO `almacen_ingreso` (`id`, `usuario_apoderado_id`, `almacen_comprobante_id`, `numeracion`, `fecha`, `almacen_metodo_pago_id`, `total`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 26, 1, '000001', '2025-01-02', 7, '0.00', '', '2025-01-02 10:55:32', 1),
(2, 26, 1, '000002', '2025-01-15', 7, '0.00', '', '2025-01-15 15:23:33', 1),
(3, 26, 1, '000003', '2025-01-20', 7, '0.00', 'POLO BLANCO Y PLOMO INICIAL TALLA 4 AL S', '2025-01-20 11:25:58', 1),
(4, 26, 1, '000004', '2025-01-20', 7, '0.00', '', '2025-01-20 13:32:24', 1),
(5, 26, 1, '000005', '2025-01-20', 7, '0.00', '', '2025-01-20 13:34:16', 1),
(6, 26, 1, '000006', '2025-01-20', 7, '0.00', '', '2025-01-20 13:54:08', 1),
(7, 26, 1, '000007', '2025-01-20', 7, '0.00', '', '2025-01-20 13:57:16', 1),
(8, 26, 1, '000008', '2025-01-27', 7, '0.00', '', '2025-01-27 15:41:11', 1),
(9, 26, 1, '000009', '2025-01-30', 7, '0.00', '', '2025-01-30 10:13:05', 1),
(10, 26, 1, '000010', '2025-01-30', 7, '0.00', '', '2025-01-30 10:14:13', 1),
(11, 26, 1, '000011', '2025-02-06', 7, '0.00', '', '2025-02-06 12:34:02', 1),
(12, 26, 1, '000012', '2025-02-13', 7, '0.00', '', '2025-02-13 11:53:40', 1),
(13, 26, 1, '000013', '2025-02-13', 7, '0.00', '', '2025-02-13 12:22:15', 1),
(14, 26, 1, '000014', '2025-02-13', 7, '0.00', '', '2025-02-13 13:08:07', 1),
(15, 26, 1, '000015', '2025-02-14', 7, '0.00', '', '2025-02-14 09:50:57', 1),
(16, 26, 1, '000016', '2025-02-17', 7, '0.00', '', '2025-02-17 09:52:39', 1),
(17, 26, 1, '000017', '2025-02-17', 7, '0.00', '', '2025-02-17 10:28:55', 1),
(18, 26, 1, '000018', '2025-02-17', 7, '0.00', '', '2025-02-17 14:44:14', 1),
(19, 26, 1, '000019', '2025-02-25', 7, '0.00', '', '2025-02-25 12:28:59', 1),
(20, 26, 1, '000020', '2025-03-06', 7, '0.00', '', '2025-03-06 01:11:31', 1),
(21, 26, 1, '000021', '2025-03-06', 7, '0.00', '', '2025-03-06 10:53:31', 1);

--
-- Disparadores `almacen_ingreso`
--
DELIMITER $$
CREATE TRIGGER `manejar_stock_cambio_estado` AFTER UPDATE ON `almacen_ingreso` FOR EACH ROW BEGIN
    -- Si el estado cambia de 1 a 0, restar stock
    IF OLD.estado = 1 AND NEW.estado = 0 THEN
        UPDATE almacen_producto p
        JOIN almacen_ingreso_detalle d ON p.id = d.almacen_producto_id
        SET p.stock = p.stock - d.stock
        WHERE d.almacen_ingreso_id = NEW.id;
    END IF;

    -- Si el estado cambia de 0 a 1, restaurar stock
    IF OLD.estado = 0 AND NEW.estado = 1 THEN
        UPDATE almacen_producto p
        JOIN almacen_ingreso_detalle d ON p.id = d.almacen_producto_id
        SET p.stock = p.stock + d.stock
        WHERE d.almacen_ingreso_id = NEW.id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_ingreso_detalle`
--

CREATE TABLE `almacen_ingreso_detalle` (
  `id` int(11) NOT NULL,
  `almacen_ingreso_id` int(11) NOT NULL,
  `almacen_producto_id` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `observaciones` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_ingreso_detalle`
--

INSERT INTO `almacen_ingreso_detalle` (`id`, `almacen_ingreso_id`, `almacen_producto_id`, `stock`, `precio_unitario`, `observaciones`) VALUES
(1, 1, 4, 10, '0.00', ''),
(2, 1, 3, 10, '0.00', ''),
(3, 1, 2, 10, '0.00', ''),
(4, 2, 95, 10, '0.00', ''),
(5, 2, 96, 10, '0.00', ''),
(6, 3, 36, 10, '0.00', ''),
(7, 3, 37, 10, '0.00', ''),
(8, 3, 38, 10, '0.00', ''),
(9, 3, 39, 10, '0.00', ''),
(10, 3, 40, 10, '0.00', ''),
(11, 3, 41, 10, '0.00', ''),
(12, 3, 42, 10, '0.00', ''),
(13, 3, 43, 10, '0.00', ''),
(14, 3, 26, 10, '0.00', ''),
(15, 3, 27, 10, '0.00', ''),
(16, 3, 28, 10, '0.00', ''),
(17, 3, 29, 10, '0.00', ''),
(18, 3, 30, 10, '0.00', ''),
(19, 3, 31, 10, '0.00', ''),
(20, 3, 32, 10, '0.00', ''),
(21, 3, 33, 10, '0.00', ''),
(22, 4, 86, 10, '0.00', ''),
(23, 4, 87, 10, '0.00', ''),
(24, 4, 88, 10, '0.00', ''),
(25, 4, 89, 10, '0.00', ''),
(26, 4, 90, 10, '0.00', ''),
(27, 4, 91, 10, '0.00', ''),
(28, 4, 92, 10, '0.00', ''),
(29, 4, 93, 10, '0.00', ''),
(30, 4, 94, 10, '0.00', ''),
(31, 4, 76, 10, '0.00', ''),
(32, 4, 77, 10, '0.00', ''),
(33, 4, 78, 10, '0.00', ''),
(34, 4, 79, 10, '0.00', ''),
(35, 4, 80, 10, '0.00', ''),
(36, 4, 81, 10, '0.00', ''),
(37, 4, 82, 10, '0.00', ''),
(38, 4, 83, 10, '0.00', ''),
(39, 4, 84, 10, '0.00', ''),
(40, 5, 6, 10, '0.00', ''),
(41, 5, 7, 10, '0.00', ''),
(42, 5, 8, 10, '0.00', ''),
(43, 5, 9, 10, '0.00', ''),
(44, 5, 10, 10, '0.00', ''),
(45, 5, 11, 10, '0.00', ''),
(46, 5, 12, 10, '0.00', ''),
(47, 5, 13, 10, '0.00', ''),
(48, 6, 97, 10, '0.00', ''),
(49, 6, 98, 10, '0.00', ''),
(50, 6, 99, 10, '0.00', ''),
(51, 6, 100, 10, '0.00', ''),
(52, 6, 101, 10, '0.00', ''),
(53, 6, 102, 10, '0.00', ''),
(54, 6, 103, 10, '0.00', ''),
(55, 6, 104, 10, '0.00', ''),
(56, 6, 105, 10, '0.00', ''),
(57, 7, 106, 10, '0.00', ''),
(58, 8, 4, 10, '0.00', ''),
(59, 8, 3, 10, '0.00', ''),
(60, 8, 2, 8, '0.00', ''),
(61, 9, 56, 10, '0.00', ''),
(62, 9, 57, 10, '0.00', ''),
(63, 9, 58, 10, '0.00', ''),
(64, 9, 59, 10, '0.00', ''),
(65, 9, 60, 10, '0.00', ''),
(66, 9, 61, 10, '0.00', ''),
(67, 9, 62, 10, '0.00', ''),
(68, 9, 63, 10, '0.00', ''),
(69, 10, 66, 10, '0.00', ''),
(70, 10, 67, 10, '0.00', ''),
(71, 10, 68, 10, '0.00', ''),
(72, 10, 69, 10, '0.00', ''),
(73, 10, 70, 10, '0.00', ''),
(74, 10, 71, 10, '0.00', ''),
(75, 10, 72, 10, '0.00', ''),
(76, 10, 73, 10, '0.00', ''),
(77, 11, 108, 10, '0.00', ''),
(78, 11, 109, 10, '0.00', ''),
(79, 11, 110, 10, '0.00', ''),
(80, 11, 111, 10, '0.00', ''),
(81, 11, 112, 10, '0.00', ''),
(82, 11, 113, 10, '0.00', ''),
(83, 11, 114, 10, '0.00', ''),
(84, 12, 117, 60, '0.00', ''),
(85, 13, 64, 5, '0.00', ''),
(86, 13, 74, 5, '0.00', ''),
(87, 14, 118, 50, '0.00', ''),
(88, 15, 119, 10, '0.00', ''),
(89, 15, 120, 10, '0.00', ''),
(90, 15, 121, 10, '0.00', ''),
(91, 15, 122, 10, '0.00', ''),
(92, 15, 123, 10, '0.00', ''),
(93, 15, 124, 10, '0.00', ''),
(94, 15, 125, 10, '0.00', ''),
(95, 15, 126, 10, '0.00', ''),
(96, 15, 127, 10, '0.00', ''),
(97, 15, 128, 10, '0.00', ''),
(98, 15, 129, 10, '0.00', ''),
(99, 15, 130, 10, '0.00', ''),
(100, 15, 131, 10, '0.00', ''),
(101, 15, 132, 10, '0.00', ''),
(102, 15, 133, 10, '0.00', ''),
(103, 15, 134, 10, '0.00', ''),
(104, 16, 135, 50, '0.00', ''),
(105, 17, 136, 50, '0.00', ''),
(106, 18, 137, 10, '0.00', ''),
(107, 19, 106, 50, '0.00', ''),
(108, 20, 145, 10, '0.00', ''),
(109, 20, 144, 10, '0.00', ''),
(110, 21, 147, 50, '0.00', '');

--
-- Disparadores `almacen_ingreso_detalle`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_ingreso` AFTER INSERT ON `almacen_ingreso_detalle` FOR EACH ROW BEGIN
    -- Incrementar el stock del producto correspondiente
    UPDATE almacen_producto
    SET stock = stock + NEW.stock
    WHERE id = NEW.almacen_producto_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_metodo_pago`
--

CREATE TABLE `almacen_metodo_pago` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `observaciones` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_metodo_pago`
--

INSERT INTO `almacen_metodo_pago` (`id`, `nombre`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 'EFECTIVO', '', '2024-12-27 09:21:08', 1),
(2, 'YAPE', '', '2024-12-27 09:21:17', 1),
(3, 'TRANSFERENCIA', '', '2024-12-27 09:21:24', 1),
(4, 'INTERBANCARIO', '', '2024-12-27 09:21:42', 1),
(5, 'PENDIENTE', '', '2024-12-27 09:21:50', 1),
(6, 'REGALO', '', '2024-12-27 09:22:35', 1),
(7, 'EMISION DIRECTA', '', '2025-01-02 15:55:04', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_producto`
--

CREATE TABLE `almacen_producto` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text,
  `categoria_id` int(11) NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT '0',
  `fechacreado` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_producto`
--

INSERT INTO `almacen_producto` (`id`, `nombre`, `descripcion`, `categoria_id`, `precio_compra`, `precio_venta`, `stock`, `fechacreado`, `estado`) VALUES
(1, 'DOCUMENTOS DE SALIDA (TODOS)', 'CONSTANCIA DE NO ADEUDO - CONSTANCIA DE MATRICULA - CERTIFICADO DE ESTUDIO', 1, '0.00', '100.00', 0, '2024-12-27 03:38:03', 0),
(2, 'CONSTANCIA DE NO ADEUDO', '', 1, '0.00', '10.00', 6, '2024-12-27 03:42:56', 1),
(3, 'CONSTANCIA DE MATRICULA', '', 1, '0.00', '10.00', 2, '2024-12-27 03:48:08', 1),
(4, 'CERTIFICADO DE ESTUDIOS', '', 1, '0.00', '80.00', 3, '2024-12-27 03:48:33', 1),
(5, 'BUZO TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(6, 'BUZO TALLA 4', '', 2, '0.00', '76.00', 10, '2025-01-02 18:00:28', 1),
(7, 'BUZO TALLA 6', '', 2, '0.00', '76.00', 9, '2025-01-02 18:00:28', 1),
(8, 'BUZO TALLA 8', '', 2, '0.00', '76.00', 10, '2025-01-02 18:00:28', 1),
(9, 'BUZO TALLA 10', '', 2, '0.00', '78.00', 10, '2025-01-02 18:00:28', 1),
(10, 'BUZO TALLA 12', '', 2, '0.00', '80.00', 10, '2025-01-02 18:00:28', 1),
(11, 'BUZO TALLA 14', '', 2, '0.00', '82.00', 9, '2025-01-02 18:00:28', 1),
(12, 'BUZO TALLA 16', '', 2, '0.00', '83.00', 10, '2025-01-02 18:00:28', 1),
(13, 'BUZO TALLA S', '', 2, '0.00', '83.00', 10, '2025-01-02 18:00:28', 1),
(14, 'BUZO TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(15, 'BUZO ANTIGUO TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(16, 'BUZO ANTIGUO TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(17, 'BUZO ANTIGUO TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(18, 'BUZO ANTIGUO TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(19, 'BUZO ANTIGUO TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(20, 'BUZO ANTIGUO TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(21, 'BUZO ANTIGUO TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(22, 'BUZO ANTIGUO TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(23, 'BUZO ANTIGUO TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(24, 'BUZO ANTIGUO TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(25, 'POLO BLANCO INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(26, 'POLO BLANCO INICIAL TALLA 4', '', 2, '0.00', '34.00', 8, '2025-01-02 18:00:28', 1),
(27, 'POLO BLANCO INICIAL TALLA 6', '', 2, '0.00', '34.00', 6, '2025-01-02 18:00:28', 1),
(28, 'POLO BLANCO INICIAL TALLA 8', '', 2, '0.00', '34.00', 6, '2025-01-02 18:00:28', 1),
(29, 'POLO BLANCO INICIAL TALLA 10', '', 2, '0.00', '36.00', 9, '2025-01-02 18:00:28', 1),
(30, 'POLO BLANCO INICIAL TALLA 12', '', 2, '0.00', '39.00', 10, '2025-01-02 18:00:28', 1),
(31, 'POLO BLANCO INICIAL TALLA 14', '', 2, '0.00', '41.00', 10, '2025-01-02 18:00:28', 1),
(32, 'POLO BLANCO INICIAL TALLA 16', '', 2, '0.00', '43.00', 10, '2025-01-02 18:00:28', 1),
(33, 'POLO BLANCO INICIAL TALLA S', '', 2, '0.00', '47.00', 10, '2025-01-02 18:00:28', 1),
(34, 'POLO BLANCO INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(35, 'POLO PLOMO INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(36, 'POLO PLOMO INICIAL TALLA 4', '', 2, '0.00', '34.00', 7, '2025-01-02 18:00:28', 1),
(37, 'POLO PLOMO INICIAL TALLA 6', '', 2, '0.00', '34.00', 6, '2025-01-02 18:00:28', 1),
(38, 'POLO PLOMO INICIAL TALLA 8', '', 2, '0.00', '34.00', 8, '2025-01-02 18:00:28', 1),
(39, 'POLO PLOMO INICIAL TALLA 10', '', 2, '0.00', '36.00', 9, '2025-01-02 18:00:28', 1),
(40, 'POLO PLOMO INICIAL TALLA 12', '', 2, '0.00', '39.00', 10, '2025-01-02 18:00:28', 1),
(41, 'POLO PLOMO INICIAL TALLA 14', '', 2, '0.00', '41.00', 10, '2025-01-02 18:00:28', 1),
(42, 'POLO PLOMO INICIAL TALLA 16', '', 2, '0.00', '43.00', 10, '2025-01-02 18:00:28', 1),
(43, 'POLO PLOMO INICIAL TALLA S', '', 2, '0.00', '47.00', 10, '2025-01-02 18:00:28', 1),
(44, 'POLO PLOMO INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(45, 'POLO PLOMO MANGA LARGA INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(46, 'POLO PLOMO MANGA LARGA INICIAL TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(47, 'POLO PLOMO MANGA LARGA INICIAL TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(48, 'POLO PLOMO MANGA LARGA INICIAL TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(49, 'POLO PLOMO MANGA LARGA INICIAL TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(50, 'POLO PLOMO MANGA LARGA INICIAL TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(51, 'POLO PLOMO MANGA LARGA INICIAL TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(52, 'POLO PLOMO MANGA LARGA INICIAL TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(53, 'POLO PLOMO MANGA LARGA INICIAL TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(54, 'POLO PLOMO MANGA LARGA INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(55, 'POLO BLANCO PRIMARIA TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(56, 'POLO BLANCO PRIMARIA TALLA 4', '', 2, '0.00', '34.00', 10, '2025-01-02 18:00:28', 1),
(57, 'POLO BLANCO PRIMARIA TALLA 6', '', 2, '0.00', '34.00', 10, '2025-01-02 18:00:28', 1),
(58, 'POLO BLANCO PRIMARIA TALLA 8', '', 2, '0.00', '34.00', 9, '2025-01-02 18:00:28', 1),
(59, 'POLO BLANCO PRIMARIA TALLA 10', '', 2, '0.00', '36.00', 9, '2025-01-02 18:00:28', 1),
(60, 'POLO BLANCO PRIMARIA TALLA 12', '', 2, '0.00', '39.00', 8, '2025-01-02 18:00:28', 1),
(61, 'POLO BLANCO PRIMARIA TALLA 14', '', 2, '0.00', '41.00', 7, '2025-01-02 18:00:28', 1),
(62, 'POLO BLANCO PRIMARIA TALLA 16', '', 2, '0.00', '43.00', 9, '2025-01-02 18:00:28', 1),
(63, 'POLO BLANCO PRIMARIA TALLA S', '', 2, '0.00', '47.00', 9, '2025-01-02 18:00:28', 1),
(64, 'POLO BLANCO PRIMARIA TALLA M', '', 2, '0.00', '47.00', 3, '2025-01-02 18:00:28', 1),
(65, 'POLO PLOMO PRIMARIA TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(66, 'POLO PLOMO PRIMARIA TALLA 4', '', 2, '0.00', '34.00', 10, '2025-01-02 18:00:28', 1),
(67, 'POLO PLOMO PRIMARIA TALLA 6', '', 2, '0.00', '34.00', 10, '2025-01-02 18:00:28', 1),
(68, 'POLO PLOMO PRIMARIA TALLA 8', '', 2, '0.00', '34.00', 9, '2025-01-02 18:00:28', 1),
(69, 'POLO PLOMO PRIMARIA TALLA 10', '', 2, '0.00', '36.00', 10, '2025-01-02 18:00:28', 1),
(70, 'POLO PLOMO PRIMARIA TALLA 12', '', 2, '0.00', '39.00', 8, '2025-01-02 18:00:28', 1),
(71, 'POLO PLOMO PRIMARIA TALLA 14', '', 2, '0.00', '41.00', 7, '2025-01-02 18:00:28', 1),
(72, 'POLO PLOMO PRIMARIA TALLA 16', '', 2, '0.00', '43.00', 10, '2025-01-02 18:00:28', 1),
(73, 'POLO PLOMO PRIMARIA TALLA S', '', 2, '0.00', '47.00', 9, '2025-01-02 18:00:28', 1),
(74, 'POLO PLOMO PRIMARIA TALLA M', '', 2, '0.00', '47.00', 2, '2025-01-02 18:00:28', 1),
(75, 'SHORT TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(76, 'SHORT TALLA 4', '', 2, '0.00', '31.00', 9, '2025-01-02 18:00:28', 1),
(77, 'SHORT TALLA 6', '', 2, '0.00', '31.00', 9, '2025-01-02 18:00:28', 1),
(78, 'SHORT TALLA 8', '', 2, '0.00', '31.00', 10, '2025-01-02 18:00:28', 1),
(79, 'SHORT TALLA 10', '', 2, '0.00', '36.00', 10, '2025-01-02 18:00:28', 1),
(80, 'SHORT TALLA 12', '', 2, '0.00', '36.00', 10, '2025-01-02 18:00:28', 1),
(81, 'SHORT TALLA 14', '', 2, '0.00', '39.00', 9, '2025-01-02 18:00:28', 1),
(82, 'SHORT TALLA 16', '', 2, '0.00', '39.00', 10, '2025-01-02 18:00:28', 1),
(83, 'SHORT TALLA S', '', 2, '0.00', '41.00', 9, '2025-01-02 18:00:28', 1),
(84, 'SHORT  TALLA M', '', 2, '0.00', '41.00', 10, '2025-01-02 18:00:28', 1),
(85, 'FALDA SHORT TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 0),
(86, 'FALDA SHORT TALLA 4', '', 2, '0.00', '33.00', 9, '2025-01-02 18:00:28', 1),
(87, 'FALDA SHORT TALLA 6', '', 2, '0.00', '33.00', 7, '2025-01-02 18:00:28', 1),
(88, 'FALDA SHORT TALLA 8', '', 2, '0.00', '33.00', 8, '2025-01-02 18:00:28', 1),
(89, 'FALDA SHORT TALLA 10', '', 2, '0.00', '38.00', 8, '2025-01-02 18:00:28', 1),
(90, 'FALDA SHORT TALLA 12', '', 2, '0.00', '38.00', 8, '2025-01-02 18:00:28', 1),
(91, 'FALDA SHORT TALLA 14', '', 2, '0.00', '41.00', 9, '2025-01-02 18:00:28', 1),
(92, 'FALDA SHORT TALLA 16', '', 2, '0.00', '41.00', 10, '2025-01-02 18:00:28', 1),
(93, 'FALDA SHORT TALLA S', '', 2, '0.00', '43.00', 10, '2025-01-02 18:00:28', 1),
(94, 'FALDA SHORT TALLA M', '', 2, '0.00', '43.00', 10, '2025-01-02 18:00:28', 1),
(95, 'CITA PSICOLÓGICA - INMEDIATA', '', 3, '0.00', '50.00', 7, '2025-01-15 15:21:52', 1),
(96, 'CITA PSICOLÓGICA - PROGRAMADO', '', 3, '0.00', '30.00', 10, '2025-01-15 15:22:54', 1),
(97, 'LIBRO INICIAL 3 AÑOS 2025', '', 4, '0.00', '220.00', 6, '2025-01-20 13:48:15', 1),
(98, 'LIBRO INICIAL 4 AÑOS 2025', '', 4, '0.00', '220.00', 6, '2025-01-20 13:48:42', 1),
(99, 'LIBRO INICIAL 5 AÑOS 2025', '', 4, '0.00', '220.00', 4, '2025-01-20 13:48:59', 1),
(100, 'LIBRO PRIMARIA 1 GRADO 2025', '', 4, '0.00', '240.00', 7, '2025-01-20 13:49:23', 1),
(101, 'LIBRO PRIMARIA 2 GRADO 2025', '', 4, '0.00', '240.00', 2, '2025-01-20 13:49:37', 1),
(102, 'LIBRO PRIMARIA 3 GRADO 2025', '', 4, '0.00', '240.00', 2, '2025-01-20 13:49:51', 1),
(103, 'LIBRO PRIMARIA 4 GRADO 2025', '', 4, '0.00', '250.00', 4, '2025-01-20 13:50:03', 1),
(104, 'LIBRO PRIMARIA 5 GRADO 2025', '', 4, '0.00', '255.00', 3, '2025-01-20 13:50:16', 1),
(105, 'LIBRO PRIMARIA 6 GRADO 2025', '', 4, '0.00', '255.00', 3, '2025-01-20 13:50:28', 1),
(106, 'PACK EBENEZER', '', 5, '0.00', '15.00', 37, '2025-01-20 13:51:16', 1),
(107, 'CHALECO TALLA 2', '', 2, '0.00', '0.00', 0, '2025-02-06 12:29:29', 0),
(108, 'CHALECO TALLA 4', '', 2, '0.00', '35.00', 10, '2025-02-06 12:29:46', 1),
(109, 'CHALECO TALLA 6', '', 2, '0.00', '35.00', 9, '2025-02-06 12:30:11', 1),
(110, 'CHALECO TALLA 8', '', 2, '0.00', '40.00', 9, '2025-02-06 12:30:27', 1),
(111, 'CHALECO TALLA 10', '', 2, '0.00', '40.00', 8, '2025-02-06 12:30:44', 1),
(112, 'CHALECO TALLA 12', '', 2, '0.00', '42.00', 10, '2025-02-06 12:31:08', 1),
(113, 'CHALECO TALLA 14', '', 2, '0.00', '42.00', 9, '2025-02-06 12:31:22', 1),
(114, 'CHALECO TALLA 16', '', 2, '0.00', '45.00', 10, '2025-02-06 12:32:17', 1),
(115, 'CHALECO TALLA S', '', 2, '0.00', '0.00', 0, '2025-02-06 12:32:30', 0),
(116, 'CHALECO TALLA M', '', 2, '0.00', '0.00', 0, '2025-02-06 12:32:43', 0),
(117, 'RAZ-KIDS', '', 4, '0.00', '100.00', 36, '2025-02-13 11:53:14', 1),
(118, 'GORRO', '', 2, '0.00', '12.00', 47, '2025-02-13 13:07:43', 1),
(119, 'MANDIL ARTE INICIAL TALLA 2', '', 2, '0.00', '0.00', 10, '2025-02-14 09:45:46', 1),
(120, 'MANDIL ARTE INICIAL TALLA 4', '', 2, '0.00', '40.00', 9, '2025-02-14 09:46:06', 1),
(121, 'MANDIL ARTE INICIAL TALLA 6', '', 2, '0.00', '40.00', 8, '2025-02-14 09:46:32', 1),
(122, 'MANDIL ARTE INICIAL TALLA 8', '', 2, '0.00', '0.00', 9, '2025-02-14 09:46:46', 1),
(123, 'MANDIL ARTE INICIAL TALLA 10', '', 2, '0.00', '0.00', 10, '2025-02-14 09:47:00', 1),
(124, 'MANDIL ARTE INICIAL TALLA 12', '', 2, '0.00', '0.00', 10, '2025-02-14 09:47:11', 1),
(125, 'MANDIL ARTE INICIAL TALLA 14', '', 2, '0.00', '0.00', 10, '2025-02-14 09:47:25', 1),
(126, 'MANDIL ARTE INICIAL TALLA 16', '', 2, '0.00', '0.00', 10, '2025-02-14 09:47:42', 1),
(127, 'MANDIL MINICHEF INICIAL TALLA 2', '', 2, '0.00', '0.00', 10, '2025-02-14 09:48:04', 1),
(128, 'MANDIL MINICHEF INICIAL TALLA 4', '', 2, '0.00', '40.00', 9, '2025-02-14 09:48:23', 1),
(129, 'MANDIL MINICHEF INICIAL TALLA 6', '', 2, '0.00', '40.00', 9, '2025-02-14 09:48:37', 1),
(130, 'MANDIL MINICHEF INICIAL TALLA 8', '', 2, '0.00', '0.00', 9, '2025-02-14 09:48:50', 1),
(131, 'MANDIL MINICHEF INICIAL TALLA 10', '', 2, '0.00', '0.00', 10, '2025-02-14 09:49:03', 1),
(132, 'MANDIL MINICHEF INICIAL TALLA 12', '', 2, '0.00', '0.00', 10, '2025-02-14 09:49:15', 1),
(133, 'MANDIL MINICHEF INICIAL TALLA 14', '', 2, '0.00', '0.00', 10, '2025-02-14 09:49:26', 1),
(134, 'MANDIL MINICHEF INICIAL TALLA 16', '', 2, '0.00', '0.00', 10, '2025-02-14 09:49:37', 1),
(135, 'LIBRO COMPUTACION PRIMARIA 2025', '', 4, '0.00', '100.00', 43, '2025-02-14 12:57:42', 1),
(136, 'MANTENIMIENTO DE AULAS - PAGO ANUAL', '', 6, '0.00', '50.00', 48, '2025-02-17 10:28:11', 1),
(137, 'FALDA SHORT TALLA L', '', 2, '0.00', '43.00', 9, '2025-02-17 14:43:49', 1),
(144, 'TOMATODO PEQUEÑO', '', 5, '0.00', '15.00', 10, '2025-03-06 01:08:14', 1),
(145, 'TOMATODO GRANDE', '', 5, '0.00', '12.00', 10, '2025-03-06 01:08:14', 1),
(146, 'CUADERNO DE CONTROL', '', 5, '0.00', '12.00', 0, '2025-03-06 01:09:37', 1),
(147, 'PAGO DE LISTADO DE UTILES', '', 6, '0.00', '200.00', 49, '2025-03-06 10:53:11', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_salida`
--

CREATE TABLE `almacen_salida` (
  `id` int(11) NOT NULL,
  `usuario_apoderado_id` int(11) NOT NULL,
  `almacen_comprobante_id` int(11) NOT NULL,
  `numeracion` varchar(50) NOT NULL,
  `fecha` date NOT NULL,
  `almacen_metodo_pago_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `observaciones` text,
  `fechacreado` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_salida`
--

INSERT INTO `almacen_salida` (`id`, `usuario_apoderado_id`, `almacen_comprobante_id`, `numeracion`, `fecha`, `almacen_metodo_pago_id`, `total`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 23, 1, '000001', '2025-01-02', 2, '10.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-02 15:35:29', 1),
(2, 27, 1, '000002', '2025-01-02', 1, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-02 16:03:10', 1),
(3, 29, 1, '000003', '2025-01-06', 2, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-06 10:59:43', 1),
(4, 28, 1, '000004', '2025-01-07', 3, '100.00', 'SE ENTREGO LOS DOCUMENTOS VIA WSP POR SOLICITUD DE LA MAMA, PERO LOS DOCUMENTOS ESTAN EN LA INSTITUCION', '2025-01-07 10:59:24', 1),
(5, 32, 1, '000005', '2025-01-07', 1, '100.00', 'SE ENTREGO LOS DOCUMENTOS - EL PAGO SE ENTREGO DIRECTAMENTE A LA DIRECTORA', '2025-01-07 11:27:44', 1),
(6, 30, 1, '000006', '2025-01-07', 2, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-07 12:18:10', 1),
(7, 23, 1, '000007', '2025-01-14', 2, '80.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-14 11:04:45', 1),
(8, 49, 1, '000008', '2025-01-15', 2, '50.00', 'VIERNES 17 DE ENERO DEL 2025 - 10:00 AM\r\nLA CITA FUE ATENDIDA', '2025-01-15 16:28:46', 1),
(9, 39, 1, '000009', '2025-01-15', 2, '50.00', 'FECHA: VIERNES 17 DE ENERO DEL 2025 - 11:30 AM\r\nLA CITA FUE ATENDIDA', '2025-01-16 09:21:36', 1),
(10, 37, 1, '000010', '2025-01-20', 2, '378.00', 'COMPROBANTE ANULADO', '2025-01-20 13:59:53', 0),
(11, 37, 1, '000011', '2025-01-20', 2, '408.00', 'PRODUCTO ENTREGADO', '2025-01-20 14:05:20', 1),
(12, 41, 1, '000012', '2025-01-22', 2, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-22 11:34:59', 1),
(13, 42, 1, '000013', '2025-01-22', 2, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-22 23:51:34', 1),
(14, 43, 1, '000014', '2025-01-23', 2, '100.00', 'SE ENTREGO LOS DOCUMENTOS', '2025-01-23 10:31:45', 1),
(15, 44, 1, '000015', '2025-01-27', 3, '90.00', 'DOCUMENTOS ENTREGADOS', '2025-01-27 13:29:36', 1),
(16, 45, 1, '000016', '2025-01-27', 3, '180.00', 'DOCUMENTOS ENTREGADOS', '2025-01-27 15:46:16', 1),
(17, 35, 1, '000017', '2025-01-28', 2, '255.00', '20 SOLES EFECTIVO\r\n235 SOLES YAPE', '2025-01-28 10:05:02', 1),
(18, 33, 1, '000018', '2025-01-30', 2, '255.00', '235 YAPE\r\n20 EFECTIVO', '2025-01-30 10:02:24', 1),
(19, 33, 1, '000019', '2025-01-30', 2, '76.00', 'DSCTO. POLO X2\r\nPRODUCTO ENTREGADO', '2025-01-30 10:19:31', 1),
(20, 19, 1, '000020', '2025-01-31', 2, '100.00', 'PRODUCTO ENTREGADO', '2025-01-31 16:32:43', 1),
(21, 53, 1, '000021', '2025-02-07', 6, '0.00', 'PRODUCTO ENTREGADO', '2025-02-07 10:21:15', 1),
(22, 54, 1, '000022', '2025-02-07', 1, '90.00', 'PRODUCTO ENTREGADO', '2025-02-07 10:33:00', 1),
(23, 31, 1, '000023', '2025-02-10', 2, '15.00', 'PRODUCTO ENTREGADO', '2025-02-10 10:31:03', 1),
(24, 56, 1, '000024', '2025-02-13', 2, '335.00', '1ER PAGO LIBRO PRIMARIA 5 GRADO 2025 - 70 SOLES EFECTIVO\r\n2DO PAGO LIBRO PRIMARIA 5 GRADO 2025 - 165 SOLES YAPE\r\n100 RAZ-KIDS', '2025-02-13 11:57:53', 1),
(25, 35, 1, '000025', '2025-02-13', 2, '126.00', 'LA APODERADA COMPRO\r\n1 POLO BLANCO PRIMARIA TALLA M\r\n2 POLO PLOMO PRIMARIA TALLA M\r\nSE ENTREGO 06/03 - 1 POLO PLOMO TALLA M', '2025-02-13 12:27:29', 1),
(26, 35, 1, '000026', '2025-02-13', 1, '15.00', 'PRODUCTO ENTREGADO', '2025-02-13 12:29:28', 1),
(27, 58, 1, '000027', '2025-02-13', 1, '391.00', '', '2025-02-13 13:18:06', 1),
(28, 58, 1, '000028', '2025-02-13', 1, '517.00', 'PENDIENTE ENTREGA DE POLO PLOMO PRIMARIA TALLA 12', '2025-02-13 13:18:09', 1),
(29, 59, 1, '000029', '2025-02-13', 1, '50.00', '', '2025-02-13 13:59:10', 1),
(30, 34, 1, '000030', '2025-02-13', 2, '240.00', 'PAGO 1 LIBRO PRIMARIA 3 GRADO 2025	20 SOLES EFECTIVO\r\nPAGO 2 LIBRO PRIMARIA 3 GRADO 2025	220 SOLES YAPE', '2025-02-13 15:58:59', 1),
(31, 13, 1, '000031', '2025-02-13', 1, '235.00', 'PAGO 1 LIBRO PRIMARIA 5 GRADO 2025	20 EFECTIVO\r\nPAGO 2 LIBRO PRIMARIA 5 GRADO 2025	200 EFECTIVO\r\nPAGO 3 LIBRO PRIMARIA 5 GRADO 2025	15 EFECTIVO', '2025-02-13 17:12:32', 1),
(32, 37, 1, '000032', '2025-02-14', 1, '80.00', 'PENDIENTE ENTREGA MANDIL MINICHEF INICIAL TALLA 6\r\nCANCELO 200 DE LA LISTA DE UTILES', '2025-02-14 09:52:15', 1),
(33, 9, 1, '000033', '2025-02-17', 1, '435.00', 'PAGO 1 LIBRO PRIMARIA 2 GRADO 2025	30 - EFECTIVO\r\nPAGO 2 LIBRO PRIMARIA 2 GRADO 2025	190 - EFECTIVO', '2025-02-17 09:55:24', 1),
(34, 47, 1, '000034', '2025-02-17', 1, '220.00', '', '2025-02-17 09:58:51', 1),
(35, 20, 1, '000035', '2025-02-17', 1, '655.00', 'PAGO 1 - 50 SOLES EFECTIVO\r\nPAGO 2 - LIBRO PRIMARIA 2 GRADO 2025	200\r\nPAGO 2 - LIBRO PRIMARIA 5 GRADO 2025	200\r\nPENDIENTE PAGO DE 5 SOLES DE LIBROS', '2025-02-17 10:22:26', 0),
(36, 20, 1, '000036', '2025-02-17', 1, '700.00', 'LIBRO PRIMARIA 2 GRADO 2025	220 SOLES\r\nLIBRO PRIMARIA 5 GRADO 2025	230 SOLES\r\n\r\nDEBE 5 SOLES DE - LIBRO PRIMARIA 5 GRADO 2025', '2025-02-17 10:40:09', 1),
(37, 60, 1, '000037', '2025-02-17', 1, '100.00', 'PENDIENTE DE ENTREGA\r\n\r\nSE SOLICITA CONSTANCIA DE CONDUCTA - COSTO: 20 SOLES - PENDIENTE', '2025-02-17 12:17:29', 1),
(38, 8, 1, '000038', '2025-02-17', 2, '450.00', 'PAGO 1 - LIBRO PRIMARIA 2 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 2 GRADO 2025	200 SOLES\r\n\r\nPAGO 1 - LIBRO PRIMARIA 4 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 4 GRADO 2025	210 SOLES', '2025-02-17 14:13:10', 1),
(39, 8, 1, '000039', '2025-02-17', 2, '473.00', 'PENDIENTE - POLO PLOMO PRIMARIA TALLA M	\r\nPENDIENTE - FALDA SHORT TALLA L	\r\nPENDIENTE - SHORT TALLA S', '2025-02-17 14:50:09', 1),
(40, 12, 1, '000040', '2025-02-17', 1, '220.00', 'PAGO 1 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 3 GRADO 2025	200 SOLES', '2025-02-17 15:31:46', 1),
(41, 40, 1, '000041', '2025-02-17', 2, '220.00', 'PAGO 1 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 3 GRADO 2025	50 SOLES\r\nPAGO 3 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 4 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 5 - LIBRO PRIMARIA 3 GRADO 2025	30 SOLES\r\nPAGO 6 - LIBRO PRIMARIA 3 GRADO 2025	40 SOLES\r\nPAGO 7 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 8 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES', '2025-02-17 16:15:18', 1),
(42, 61, 1, '000042', '2025-02-18', 1, '100.00', '', '2025-02-18 10:49:56', 1),
(43, 61, 1, '000043', '2025-02-18', 1, '100.00', 'EFECTIVO 80 SOLES\r\nYAPE 20 SOLES', '2025-02-18 10:53:08', 1),
(44, 13, 1, '000044', '2025-02-19', 1, '100.00', '', '2025-02-19 10:17:52', 1),
(45, 49, 1, '000045', '2025-02-19', 2, '240.00', 'PAGO 1 - LIBRO PRIMARIA 3 GRADO 2025	20\r\nPAGO 2 - LIBRO PRIMARIA 3 GRADO 2025	220', '2025-02-19 12:31:16', 1),
(46, 53, 1, '000046', '2025-02-20', 6, '0.00', '', '2025-02-20 12:43:06', 1),
(47, 31, 1, '000047', '2025-02-20', 2, '330.00', 'PAGO 1 - LIBRO PRIMARIA 4 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 4 GRADO 2025	228 SOLES', '2025-02-20 14:42:37', 1),
(48, 17, 1, '000048', '2025-02-20', 1, '460.00', 'PAGO 1 - LIBRO PRIMARIA 3 GRADO 2025	15 SOLES\r\nPAGO 1 - LIBRO PRIMARIA 6 GRADO 2025	15 SOLES\r\n\r\nPAGO 2 - LIBRO PRIMARIA 3 GRADO 2025	205 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025	225 SOLES', '2025-02-20 14:47:14', 1),
(49, 46, 1, '000049', '2025-02-20', 2, '430.00', 'PAGO 1 - LIBRO PRIMARIA 4 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 4 GRADO 2025	210 SOLES', '2025-02-20 14:50:52', 1),
(50, 36, 1, '000050', '2025-02-20', 1, '355.00', 'PAGO 1 - LIBRO PRIMARIA 5 GRADO 2025	100 EFECTIVO\r\nPAGO 2 - LIBRO PRIMARIA 5 GRADO 2025	155 YAPE', '2025-02-20 14:53:53', 1),
(51, 11, 1, '000051', '2025-02-20', 1, '220.00', 'PAGO 1 - LIBRO PRIMARIA 2 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 2 GRADO 2025	200 SOLES', '2025-02-20 14:59:22', 1),
(52, 23, 1, '000052', '2025-02-20', 1, '200.00', '', '2025-02-21 08:58:54', 1),
(53, 22, 1, '000053', '2025-02-21', 1, '200.00', 'PAGO 1 - LIBRO INICIAL 5 AÑOS 2025	20 SOLES\r\nPAGO 2 - LIBRO INICIAL 5 AÑOS 2025	180 SOLES', '2025-02-21 10:14:23', 1),
(54, 62, 1, '000054', '2025-02-21', 2, '10.00', '', '2025-02-21 11:05:07', 1),
(55, 51, 1, '000055', '2025-02-24', 4, '587.00', 'PENDIENTE DE ENTREGA FALDA SHORT TALLA 14 - DEJA PAGADO', '2025-02-24 11:10:58', 1),
(56, 64, 1, '000056', '2025-02-24', 2, '332.00', 'PAGO 1 - LIBRO INICIAL 5 AÑOS 2025 - 20 SOLES\r\nPAGO 2 - LIBRO INICIAL 5 AÑOS 2025 - 200 SOLES', '2025-02-24 13:07:23', 1),
(57, 21, 1, '000057', '2025-02-25', 1, '320.00', 'PAGO 1 - LIBRO PRIMARIA 2 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 2 GRADO 2025	200 SOLES', '2025-02-25 10:22:28', 1),
(58, 33, 1, '000058', '2025-02-25', 1, '38.00', '', '2025-02-25 10:37:13', 1),
(59, 50, 1, '000059', '2025-02-25', 1, '355.00', '', '2025-02-25 10:39:42', 1),
(60, 65, 1, '000060', '2025-02-25', 2, '43.00', '', '2025-02-25 11:38:14', 1),
(61, 15, 1, '000061', '2025-02-25', 1, '100.00', '', '2025-02-25 11:38:56', 1),
(62, 19, 1, '000062', '2025-02-25', 1, '320.00', 'PAGO 1 - LIBRO PRIMARIA 1 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 1 GRADO 2025	200 SOLES', '2025-02-25 11:45:58', 1),
(63, 66, 1, '000063', '2025-02-25', 2, '412.00', 'PENDIENTE DE ENTREGA:\r\nFALDA SHORT TALLA 4\r\nMANDIL MINICHEF INICIAL TALLA 4', '2025-02-25 12:26:12', 1),
(64, 67, 1, '000064', '2025-02-25', 2, '412.00', 'PENDIENTE DE ENTREGA:\r\nFALDA SHORT TALLA 4\r\nPOLO BLANCO INICIAL TALLA 4\r\nPOLO PLOMO INICIAL TALLA 4\r\nPACK EBENEZER\r\nMANDIL ARTE INICIAL TALLA 4\r\nMANDIL MINICHEF INICIAL TALLA 4', '2025-02-25 12:31:44', 0),
(65, 12, 1, '000065', '2025-02-25', 1, '100.00', '', '2025-02-25 12:48:19', 1),
(66, 68, 1, '000066', '2025-02-26', 2, '392.00', '', '2025-02-26 11:14:09', 1),
(67, 68, 1, '000067', '2025-02-26', 2, '100.00', '', '2025-02-26 11:17:31', 1),
(68, 15, 1, '000068', '2025-02-27', 1, '240.00', 'PAGO 1 - LIBRO PRIMARIA 6 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025	100 SOLES\r\nPAGO 3 - LIBRO PRIMARIA 6 GRADO 2025	120 SOLES', '2025-02-27 08:49:23', 1),
(69, 18, 1, '000069', '2025-02-27', 2, '440.00', 'PAGO 1 - LIBRO INICIAL 5 AÑOS 2025	20 SOLES\r\nPAGO 1 - LIBRO PRIMARIA 6 GRADO 2025	20 SOLES\r\n\r\nPAGO 2 - LIBRO INICIAL 5 AÑOS 2025	180 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025	220 SOLES', '2025-02-27 08:57:47', 1),
(70, 14, 1, '000070', '2025-02-27', 1, '340.00', 'PAGO 1 - LIBRO PRIMARIA 6 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025	220 SOLES', '2025-02-27 09:02:30', 1),
(71, 3, 1, '000071', '2025-02-27', 1, '200.00', 'PAGO 1 - LIBRO INICIAL 5 AÑOS 2025	20 SOLES\r\nPAGO 2 - LIBRO INICIAL 5 AÑOS 2025	180 SOLES', '2025-02-27 09:19:54', 1),
(72, 2, 1, '000072', '2025-02-27', 1, '200.00', 'PAGO 1 - LIBRO INICIAL 5 AÑOS 2025	30 SOLES\r\nPAGO 2 - LIBRO INICIAL 5 AÑOS 2025	150 SOLES\r\nPAGO 3 - LIBRO INICIAL 5 AÑOS 2025	20 SOLES', '2025-02-27 09:23:23', 1),
(73, 16, 1, '000073', '2025-02-27', 1, '230.00', '', '2025-02-27 09:29:08', 1),
(74, 30, 1, '000074', '2025-02-28', 1, '220.00', 'PAGO 1 - LIBRO INICIAL 3 AÑOS 2025	20 SOLES\r\nPAGO 2 - LIBRO INICIAL 3 AÑOS 2025	200 SOLES', '2025-02-28 08:19:12', 1),
(75, 30, 1, '000075', '2025-02-28', 1, '110.00', '', '2025-02-28 08:21:41', 1),
(76, 63, 1, '000076', '2025-02-28', 2, '220.00', 'PAGO 1 - LIBRO INICIAL 4 AÑOS 2025	20 SOLES\r\nPAGO 2 - LIBRO INICIAL 4 AÑOS 2025	200 SOLES', '2025-02-28 11:29:51', 1),
(77, 72, 1, '000077', '2025-02-28', 2, '100.00', '', '2025-02-28 15:53:22', 1),
(78, 74, 1, '000078', '2025-03-03', 2, '265.00', 'PAGO 1 - LIBRO PRIMARIA 4 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 4 GRADO 2025	210 SOLES', '2025-03-03 09:16:39', 1),
(79, 75, 1, '000079', '2025-03-03', 1, '100.00', '', '2025-03-03 10:08:46', 1),
(80, 7, 1, '000080', '2025-03-03', 1, '220.00', 'PAGO 1 - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 3 GRADO 2025	200 SOLES', '2025-03-03 10:23:37', 1),
(81, 1, 1, '000081', '2025-03-03', 1, '240.00', '', '2025-03-03 14:29:42', 1),
(82, 61, 1, '000082', '2025-03-04', 1, '255.00', 'PAGO 1 - LIBRO PRIMARIA 6 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025	220 SOLES', '2025-03-04 15:35:20', 1),
(83, 23, 1, '000083', '2025-03-04', 1, '200.00', '', '2025-03-04 15:47:27', 1),
(84, 67, 1, '000084', '2025-02-25', 2, '412.00', 'PENDIENTE ENTREGA:\r\nMANDIL MINICHEF INICIAL TALLA 8', '2025-03-05 10:08:21', 1),
(85, 67, 1, '000085', '2025-03-05', 2, '97.00', 'SE ENTREGO TODO', '2025-03-05 10:09:56', 1),
(86, 66, 1, '000086', '2025-03-05', 2, '34.00', '', '2025-03-05 10:12:47', 1),
(87, 76, 1, '000087', '2025-03-05', 1, '150.00', 'PAGO 1 - LIBRO PRIMARIA 2 GRADO 2025	20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 2 GRADO 2025	150 SOLES\r\nPAGO 3 PENDIENTE - LIBRO PRIMARIA 2 GRADO 2025     50SOLES', '2025-03-05 11:31:04', 1),
(88, 77, 1, '000088', '2025-03-05', 2, '330.00', '', '2025-03-05 12:05:00', 0),
(89, 77, 1, '000089', '2025-03-05', 2, '330.00', '', '2025-03-05 12:09:23', 1),
(90, 77, 1, '000090', '2025-03-05', 1, '15.00', '', '2025-03-05 12:10:18', 1),
(91, 78, 1, '000091', '2025-03-05', 1, '100.00', 'PAGO 1 - LIBRO PRIMARIA 4 GRADO 2025	100 SOLES', '2025-03-05 14:33:36', 1),
(92, 79, 1, '000092', '2025-03-05', 1, '255.00', '', '2025-03-05 14:36:51', 1),
(93, 11, 1, '000093', '2025-03-05', 1, '151.00', '', '2025-03-05 14:38:12', 1),
(94, 35, 1, '000094', '2025-03-06', 1, '100.00', '', '2025-03-06 10:44:24', 1),
(95, 55, 1, '000095', '2025-03-06', 2, '319.00', '', '2025-03-06 10:56:50', 1),
(96, 7, 1, '000096', '2025-03-06', 1, '240.00', 'PAGO 1 - LIBRO PRIMARIA 6 GRADO 2025 20 SOLES\r\nPAGO 2 - LIBRO PRIMARIA 6 GRADO 2025 220 SOLES', '2025-03-06 11:01:44', 1),
(97, 71, 1, '000097', '2025-03-06', 2, '504.00', 'PAGO ANTERIORMENTE - LIBRO PRIMARIA 3 GRADO 2025	20 SOLES YAPE\r\nPENDIENTE ENTREGA: SHORT TALLA 14', '2025-03-06 11:10:09', 1),
(98, 7, 1, '000098', '2025-03-06', 1, '30.00', 'PENDIENTE DE ENTREGA', '2025-03-06 11:15:15', 1),
(99, 80, 1, '000099', '2025-03-06', 2, '196.00', '', '2025-03-06 12:00:08', 1),
(100, 63, 1, '000100', '2025-03-06', 1, '64.00', '', '2025-03-06 12:58:38', 1);

--
-- Disparadores `almacen_salida`
--
DELIMITER $$
CREATE TRIGGER `manejar_stock_cambio_estado_salida` AFTER UPDATE ON `almacen_salida` FOR EACH ROW BEGIN
    -- Si el estado cambia de 1 a 0, restaurar stock
    IF OLD.estado = 1 AND NEW.estado = 0 THEN
        UPDATE almacen_producto p
        JOIN almacen_salida_detalle d ON p.id = d.almacen_producto_id
        SET p.stock = p.stock + d.stock
        WHERE d.almacen_salida_id = NEW.id;
    END IF;

    -- Si el estado cambia de 0 a 1, reducir stock
    IF OLD.estado = 0 AND NEW.estado = 1 THEN
        UPDATE almacen_producto p
        JOIN almacen_salida_detalle d ON p.id = d.almacen_producto_id
        SET p.stock = p.stock - d.stock
        WHERE d.almacen_salida_id = NEW.id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen_salida_detalle`
--

CREATE TABLE `almacen_salida_detalle` (
  `id` int(11) NOT NULL,
  `almacen_salida_id` int(11) NOT NULL,
  `almacen_producto_id` int(11) NOT NULL,
  `stock` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `observaciones` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen_salida_detalle`
--

INSERT INTO `almacen_salida_detalle` (`id`, `almacen_salida_id`, `almacen_producto_id`, `stock`, `precio_unitario`, `observaciones`) VALUES
(1, 1, 3, 1, '10.00', ''),
(2, 2, 4, 1, '80.00', ''),
(3, 2, 3, 1, '10.00', ''),
(4, 2, 2, 1, '10.00', ''),
(5, 3, 4, 1, '80.00', ''),
(6, 3, 3, 1, '10.00', ''),
(7, 3, 2, 1, '10.00', ''),
(8, 4, 4, 1, '80.00', ''),
(9, 4, 3, 1, '10.00', ''),
(10, 4, 2, 1, '10.00', ''),
(11, 5, 4, 1, '80.00', ''),
(12, 5, 3, 1, '10.00', ''),
(13, 5, 2, 1, '10.00', ''),
(14, 6, 4, 1, '80.00', ''),
(15, 6, 3, 1, '10.00', ''),
(16, 6, 2, 1, '10.00', ''),
(17, 7, 4, 1, '80.00', ''),
(18, 8, 95, 1, '50.00', ''),
(19, 9, 95, 1, '50.00', ''),
(20, 10, 106, 1, '15.00', ''),
(21, 10, 7, 1, '76.00', ''),
(22, 10, 27, 1, '34.00', ''),
(23, 10, 37, 1, '30.00', ''),
(24, 10, 87, 1, '33.00', ''),
(25, 10, 97, 1, '190.00', ''),
(26, 11, 106, 1, '15.00', ''),
(27, 11, 7, 1, '76.00', ''),
(28, 11, 37, 1, '34.00', ''),
(29, 11, 27, 1, '30.00', 'DESCUENTO X2'),
(30, 11, 87, 1, '33.00', ''),
(31, 11, 97, 1, '220.00', ''),
(32, 12, 4, 1, '80.00', ''),
(33, 12, 3, 1, '10.00', ''),
(34, 12, 2, 1, '10.00', ''),
(35, 13, 4, 1, '80.00', ''),
(36, 13, 3, 1, '10.00', ''),
(37, 13, 2, 1, '10.00', ''),
(38, 14, 4, 1, '80.00', ''),
(39, 14, 3, 1, '10.00', ''),
(40, 14, 2, 1, '10.00', ''),
(41, 15, 3, 1, '10.00', ''),
(42, 15, 4, 1, '80.00', ''),
(43, 16, 3, 2, '10.00', ''),
(44, 16, 4, 2, '80.00', ''),
(45, 17, 104, 1, '255.00', ''),
(46, 18, 104, 1, '255.00', ''),
(47, 19, 61, 1, '41.00', ''),
(48, 19, 71, 1, '35.00', ''),
(49, 20, 4, 1, '80.00', ''),
(50, 20, 3, 1, '10.00', ''),
(51, 20, 2, 1, '10.00', ''),
(52, 21, 11, 1, '0.00', ''),
(53, 22, 3, 1, '10.00', ''),
(54, 22, 4, 1, '80.00', ''),
(55, 23, 106, 1, '15.00', ''),
(56, 24, 117, 1, '100.00', ''),
(57, 24, 104, 1, '235.00', ''),
(58, 25, 64, 1, '47.00', ''),
(59, 25, 74, 2, '39.50', ''),
(60, 26, 106, 1, '15.00', ''),
(61, 27, 106, 1, '15.00', ''),
(62, 27, 118, 1, '12.00', ''),
(63, 27, 111, 1, '40.00', ''),
(64, 27, 89, 1, '38.00', ''),
(65, 27, 29, 1, '36.00', ''),
(66, 27, 39, 1, '30.00', ''),
(67, 27, 98, 1, '220.00', ''),
(68, 28, 106, 1, '15.00', ''),
(69, 28, 118, 1, '12.00', ''),
(70, 28, 111, 1, '40.00', ''),
(71, 28, 90, 1, '38.00', ''),
(72, 28, 60, 1, '39.00', ''),
(73, 28, 70, 1, '33.00', ''),
(74, 28, 100, 1, '240.00', ''),
(75, 28, 117, 1, '100.00', ''),
(76, 29, 95, 1, '50.00', ''),
(77, 30, 102, 1, '240.00', ''),
(78, 31, 104, 1, '235.00', ''),
(79, 32, 121, 1, '40.00', ''),
(80, 32, 129, 1, '40.00', ''),
(81, 33, 101, 1, '220.00', ''),
(82, 33, 117, 1, '100.00', ''),
(83, 33, 135, 1, '100.00', ''),
(84, 33, 106, 1, '15.00', ''),
(85, 34, 98, 1, '220.00', ''),
(86, 35, 117, 2, '100.00', ''),
(87, 35, 101, 1, '220.00', ''),
(88, 35, 104, 1, '235.00', ''),
(89, 36, 136, 2, '50.00', ''),
(90, 36, 117, 2, '100.00', ''),
(91, 36, 101, 1, '220.00', ''),
(92, 36, 104, 1, '180.00', 'DSCTO. 50'),
(93, 37, 2, 1, '10.00', ''),
(94, 37, 3, 1, '10.00', ''),
(95, 37, 4, 1, '80.00', ''),
(96, 38, 101, 1, '220.00', ''),
(97, 38, 103, 1, '230.00', ''),
(98, 39, 117, 2, '100.00', ''),
(99, 39, 106, 1, '15.00', ''),
(100, 39, 63, 1, '47.00', ''),
(101, 39, 73, 1, '39.00', 'DSCTO. 8 SOLES'),
(102, 39, 64, 1, '48.00', ''),
(103, 39, 74, 1, '40.00', 'DSCTO. 8 SOLES'),
(104, 39, 137, 1, '43.00', ''),
(105, 39, 83, 1, '41.00', ''),
(106, 40, 102, 1, '220.00', ''),
(107, 41, 102, 1, '220.00', ''),
(108, 42, 117, 1, '100.00', ''),
(109, 43, 135, 1, '100.00', ''),
(110, 44, 117, 1, '100.00', ''),
(111, 45, 102, 1, '240.00', ''),
(112, 46, 101, 1, '0.00', ''),
(113, 47, 135, 1, '100.00', ''),
(114, 47, 103, 1, '230.00', ''),
(115, 48, 102, 1, '220.00', ''),
(116, 48, 105, 1, '240.00', ''),
(117, 49, 103, 1, '230.00', ''),
(118, 49, 135, 1, '100.00', ''),
(119, 49, 117, 1, '100.00', ''),
(120, 50, 117, 1, '100.00', ''),
(121, 50, 104, 1, '255.00', ''),
(122, 51, 101, 1, '220.00', ''),
(123, 52, 135, 2, '100.00', ''),
(124, 53, 99, 1, '200.00', ''),
(125, 54, 3, 1, '10.00', ''),
(126, 55, 61, 1, '41.00', ''),
(127, 55, 71, 1, '35.00', ''),
(128, 55, 104, 1, '255.00', ''),
(129, 55, 117, 1, '100.00', ''),
(130, 55, 135, 1, '100.00', ''),
(131, 55, 106, 1, '15.00', ''),
(132, 55, 91, 1, '41.00', ''),
(133, 56, 28, 1, '34.00', ''),
(134, 56, 38, 1, '30.00', ''),
(135, 56, 106, 1, '15.00', ''),
(136, 56, 87, 1, '33.00', ''),
(137, 56, 99, 1, '220.00', ''),
(138, 57, 101, 1, '220.00', ''),
(139, 57, 117, 1, '100.00', ''),
(140, 58, 90, 1, '38.00', ''),
(141, 59, 117, 1, '100.00', ''),
(142, 59, 105, 1, '255.00', ''),
(143, 60, 62, 1, '43.00', ''),
(144, 61, 117, 1, '100.00', ''),
(145, 62, 100, 1, '220.00', ''),
(146, 62, 117, 1, '100.00', ''),
(147, 63, 26, 1, '34.00', ''),
(148, 63, 36, 1, '30.00', ''),
(149, 63, 106, 1, '15.00', ''),
(150, 63, 120, 1, '40.00', ''),
(151, 63, 128, 1, '40.00', ''),
(152, 63, 86, 1, '33.00', ''),
(153, 63, 97, 1, '220.00', ''),
(154, 64, 97, 1, '220.00', ''),
(155, 64, 86, 1, '33.00', ''),
(156, 64, 26, 1, '34.00', ''),
(157, 64, 36, 1, '30.00', ''),
(158, 64, 106, 1, '15.00', ''),
(159, 64, 120, 1, '40.00', ''),
(160, 64, 128, 1, '40.00', ''),
(161, 65, 117, 1, '100.00', ''),
(162, 66, 58, 1, '34.00', ''),
(163, 66, 68, 1, '30.00', ''),
(164, 66, 87, 1, '33.00', ''),
(165, 66, 100, 1, '240.00', ''),
(166, 66, 110, 1, '40.00', ''),
(167, 66, 106, 1, '15.00', ''),
(168, 67, 117, 1, '100.00', ''),
(169, 68, 105, 1, '240.00', ''),
(170, 69, 99, 1, '200.00', ''),
(171, 69, 105, 1, '240.00', ''),
(172, 70, 117, 1, '100.00', ''),
(173, 70, 105, 1, '240.00', ''),
(174, 71, 99, 1, '200.00', ''),
(175, 72, 99, 1, '200.00', ''),
(176, 73, 103, 1, '230.00', ''),
(177, 74, 97, 1, '220.00', ''),
(178, 75, 106, 1, '15.00', ''),
(179, 75, 26, 1, '34.00', ''),
(180, 75, 36, 1, '30.00', ''),
(181, 75, 76, 1, '31.00', ''),
(182, 76, 98, 1, '220.00', ''),
(183, 77, 4, 1, '80.00', ''),
(184, 77, 3, 1, '10.00', ''),
(185, 77, 2, 1, '10.00', ''),
(186, 78, 106, 1, '15.00', ''),
(187, 78, 103, 1, '250.00', ''),
(188, 79, 4, 1, '80.00', ''),
(189, 79, 3, 1, '10.00', ''),
(190, 79, 2, 1, '10.00', ''),
(191, 80, 102, 1, '220.00', ''),
(192, 81, 101, 1, '240.00', ''),
(193, 82, 105, 1, '240.00', ''),
(194, 82, 106, 1, '15.00', ''),
(195, 83, 117, 2, '100.00', ''),
(196, 84, 97, 1, '220.00', ''),
(197, 84, 28, 1, '34.00', ''),
(198, 84, 38, 1, '30.00', ''),
(199, 84, 88, 1, '33.00', ''),
(200, 84, 106, 1, '15.00', ''),
(201, 84, 122, 1, '40.00', ''),
(202, 84, 130, 1, '40.00', ''),
(203, 85, 28, 2, '32.00', ''),
(204, 85, 88, 1, '33.00', ''),
(205, 86, 36, 1, '34.00', ''),
(206, 87, 101, 1, '150.00', ''),
(207, 88, 60, 1, '39.00', ''),
(208, 88, 70, 1, '33.00', ''),
(209, 88, 90, 1, '38.00', ''),
(210, 88, 99, 1, '220.00', ''),
(211, 89, 60, 1, '39.00', ''),
(212, 89, 70, 1, '33.00', ''),
(213, 89, 89, 1, '38.00', ''),
(214, 89, 99, 1, '220.00', ''),
(215, 90, 106, 1, '15.00', ''),
(216, 91, 103, 1, '100.00', ''),
(217, 92, 102, 1, '240.00', ''),
(218, 92, 106, 1, '15.00', ''),
(219, 93, 117, 1, '100.00', ''),
(220, 93, 59, 1, '36.00', ''),
(221, 93, 106, 1, '15.00', ''),
(222, 94, 117, 1, '100.00', ''),
(223, 95, 121, 1, '40.00', ''),
(224, 95, 27, 1, '34.00', ''),
(225, 95, 37, 1, '30.00', ''),
(226, 95, 147, 1, '200.00', ''),
(227, 95, 106, 1, '15.00', ''),
(228, 96, 105, 1, '240.00', ''),
(229, 97, 61, 1, '41.00', ''),
(230, 97, 71, 1, '35.00', ''),
(231, 97, 106, 1, '15.00', ''),
(232, 97, 102, 1, '220.00', ''),
(233, 97, 117, 1, '100.00', ''),
(234, 97, 81, 1, '39.00', ''),
(235, 97, 113, 1, '42.00', ''),
(236, 97, 118, 1, '12.00', ''),
(237, 98, 106, 2, '15.00', ''),
(238, 99, 77, 1, '31.00', ''),
(239, 99, 106, 1, '15.00', ''),
(240, 99, 109, 1, '36.00', ''),
(241, 99, 98, 1, '50.00', 'PENDIENTE'),
(242, 99, 27, 1, '34.00', ''),
(243, 99, 37, 1, '30.00', ''),
(244, 100, 27, 1, '34.00', ''),
(245, 100, 37, 1, '30.00', '');

--
-- Disparadores `almacen_salida_detalle`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_salida` AFTER INSERT ON `almacen_salida_detalle` FOR EACH ROW BEGIN
    -- Reducir el stock del producto correspondiente
    UPDATE almacen_producto
    SET stock = stock - NEW.stock
    WHERE id = NEW.almacen_producto_id;
END
$$
DELIMITER ;

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
(11, 2, 'FOTO FAMILIAR (TAMAÑO JUMBO)', 0, '', '2024-11-24 06:27:28', 1),
(12, 2, 'OTROS DOCUMENTOS', 0, '', '2025-01-27 05:38:22', 1);

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

--
-- Volcado de datos para la tabla `documento_detalle`
--

INSERT INTO `documento_detalle` (`id`, `id_matricula_detalle`, `id_documento`, `entregado`, `observaciones`, `fechacreado`, `estado`) VALUES
(1, 32, 1, 0, 'DOC. OMITIDO', '2025-01-06 16:59:27', 1),
(2, 32, 2, 0, 'DOC. OMITIDO', '2025-01-06 16:59:27', 1),
(3, 32, 3, 0, 'DOC. OMITIDO', '2025-01-06 16:59:27', 1),
(4, 32, 4, 0, 'DOC. OMITIDO', '2025-01-06 16:59:27', 1),
(5, 32, 5, 0, 'DOC. OMITIDO', '2025-01-06 16:59:27', 1),
(6, 32, 6, 1, '', '2025-01-06 16:59:27', 1),
(7, 32, 7, 1, '', '2025-01-06 16:59:27', 1),
(8, 32, 8, 1, '', '2025-01-06 16:59:27', 1),
(9, 32, 9, 1, '', '2025-01-06 16:59:27', 1),
(10, 32, 10, 1, '6 FOTOS', '2025-01-06 16:59:27', 1),
(11, 32, 11, 1, '', '2025-01-06 16:59:27', 1),
(12, 34, 1, 1, '', '2025-01-17 20:53:24', 1),
(13, 34, 2, 1, '', '2025-01-17 20:53:24', 1),
(14, 34, 3, 1, '', '2025-01-17 20:53:24', 1),
(15, 34, 4, 1, '', '2025-01-17 20:53:24', 1),
(16, 34, 5, 1, '', '2025-01-17 20:53:24', 1),
(17, 34, 6, 1, '', '2025-01-17 20:53:24', 1),
(18, 34, 7, 1, '', '2025-01-17 20:53:24', 1),
(19, 34, 8, 1, '', '2025-01-17 20:53:24', 1),
(20, 34, 9, 1, '', '2025-01-17 20:53:24', 1),
(21, 34, 10, 0, '', '2025-01-17 20:53:24', 1),
(22, 34, 11, 0, '', '2025-01-17 20:53:24', 1),
(23, 33, 1, 1, '', '2025-01-17 20:59:09', 1),
(24, 33, 2, 1, '', '2025-01-17 20:59:09', 1),
(25, 33, 3, 1, '', '2025-01-17 20:59:09', 1),
(26, 33, 4, 1, '', '2025-01-17 20:59:09', 1),
(27, 33, 5, 1, '', '2025-01-17 20:59:09', 1),
(28, 33, 6, 0, '', '2025-01-17 20:59:09', 1),
(29, 33, 7, 0, '', '2025-01-17 20:59:09', 1),
(30, 33, 8, 1, '', '2025-01-17 20:59:09', 1),
(31, 33, 9, 1, '', '2025-01-17 20:59:09', 1),
(32, 33, 10, 0, '', '2025-01-17 20:59:09', 1),
(33, 33, 11, 0, '', '2025-01-17 20:59:09', 1),
(34, 36, 1, 1, '', '2025-01-17 21:05:18', 1),
(35, 36, 2, 1, '', '2025-01-17 21:05:18', 1),
(36, 36, 3, 1, '', '2025-01-17 21:05:18', 1),
(37, 36, 4, 0, '', '2025-01-17 21:05:18', 1),
(38, 36, 5, 1, '', '2025-01-17 21:05:18', 1),
(39, 36, 6, 0, '', '2025-01-17 21:05:18', 1),
(40, 36, 7, 0, '', '2025-01-17 21:05:18', 1),
(41, 36, 8, 1, 'SOLO CARA DELANTERA', '2025-01-17 21:05:18', 1),
(42, 36, 9, 1, 'SOLO CARA DELANTERA', '2025-01-17 21:05:18', 1),
(43, 36, 10, 0, '', '2025-01-17 21:05:18', 1),
(44, 36, 11, 0, '', '2025-01-17 21:05:18', 1),
(45, 35, 1, 1, '', '2025-01-28 14:22:33', 1),
(46, 35, 2, 1, '', '2025-01-28 14:22:33', 1),
(47, 35, 3, 1, '', '2025-01-28 14:22:33', 1),
(48, 35, 4, 0, '', '2025-01-28 14:22:33', 1),
(49, 35, 5, 1, '', '2025-01-28 14:22:33', 1),
(50, 35, 6, 1, '', '2025-01-28 14:22:33', 1),
(51, 35, 7, 1, '', '2025-01-28 14:22:33', 1),
(52, 35, 8, 1, '', '2025-01-28 14:22:33', 1),
(53, 35, 9, 1, '', '2025-01-28 14:22:33', 1),
(54, 35, 10, 1, '6 FOTOS', '2025-01-28 14:22:33', 1),
(55, 35, 11, 0, '', '2025-01-28 14:22:33', 1),
(56, 35, 12, 0, '', '2025-01-28 14:22:33', 1),
(57, 45, 1, 1, '', '2025-02-06 17:48:32', 1),
(58, 45, 2, 0, '', '2025-02-06 17:48:32', 1),
(59, 45, 3, 0, '', '2025-02-06 17:48:32', 1),
(60, 45, 4, 1, '', '2025-02-06 17:48:32', 1),
(61, 45, 5, 0, '', '2025-02-06 17:48:32', 1),
(62, 45, 6, 1, '', '2025-02-06 17:48:32', 1),
(63, 45, 7, 1, '', '2025-02-06 17:48:32', 1),
(64, 45, 8, 1, '', '2025-02-06 17:48:32', 1),
(65, 45, 9, 1, '', '2025-02-06 17:48:32', 1),
(66, 45, 10, 0, '', '2025-02-06 17:48:32', 1),
(67, 45, 11, 0, '', '2025-02-06 17:48:32', 1),
(68, 45, 12, 1, 'RECIBO DE AGUA', '2025-02-06 17:48:32', 1),
(69, 34, 12, 1, 'INFORME PSICOLOGICO', '2025-02-25 16:08:37', 1),
(70, 33, 12, 1, 'INFORME PSICOLOGICO', '2025-02-25 16:13:45', 1),
(71, 59, 1, 1, '', '2025-02-26 16:21:45', 1),
(72, 59, 2, 0, '', '2025-02-26 16:21:45', 1),
(73, 59, 3, 1, '', '2025-02-26 16:21:45', 1),
(74, 59, 4, 1, '', '2025-02-26 16:21:45', 1),
(75, 59, 5, 0, 'DOC. OMITIDO', '2025-02-26 16:21:45', 1),
(76, 59, 6, 1, '', '2025-02-26 16:21:45', 1),
(77, 59, 7, 1, '', '2025-02-26 16:21:45', 1),
(78, 59, 8, 0, '', '2025-02-26 16:21:45', 1),
(79, 59, 9, 1, 'CARNET DE EXTRANGERIA', '2025-02-26 16:21:45', 1),
(80, 59, 10, 1, '4 FOTOS', '2025-02-26 16:21:45', 1),
(81, 59, 11, 0, '', '2025-02-26 16:21:45', 1),
(82, 59, 12, 1, 'FICHA DE MATRICULA', '2025-02-26 16:21:45', 1),
(83, 60, 1, 0, 'DOC. OMITIDO', '2025-02-26 16:39:21', 1),
(84, 60, 2, 0, 'DOC. OMITIDO', '2025-02-26 16:39:22', 1),
(85, 60, 3, 0, 'DOC. OMITIDO', '2025-02-26 16:39:22', 1),
(86, 60, 4, 0, 'DOC. OMITIDO', '2025-02-26 16:39:22', 1),
(87, 60, 5, 0, 'DOC. OMITIDO', '2025-02-26 16:39:22', 1),
(88, 60, 6, 0, '', '2025-02-26 16:39:22', 1),
(89, 60, 7, 1, '', '2025-02-26 16:39:22', 1),
(90, 60, 8, 1, '', '2025-02-26 16:39:22', 1),
(91, 60, 9, 1, '', '2025-02-26 16:39:22', 1),
(92, 60, 10, 0, '', '2025-02-26 16:39:22', 1),
(93, 60, 11, 0, '', '2025-02-26 16:39:22', 1),
(94, 60, 12, 1, 'RECIBO DE LUZ', '2025-02-26 16:39:22', 1);

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
(1, 'IEP. EBENEZER', 2, '958197047', 'CBEBENEZER0791@GMAIL.COM', '20602116892', 'GAYCE E.I.R.L.', 'CAL.LOS PENSAMIENTOS NRO. 261 P.J. EL ERMITAÑO LIMA - LIMA - INDEPENDENCIA', '', '2024-11-24 05:54:21', 1);

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
(1, '2025', 'AÑO DE LA RECUPERACION Y CONSOLIDACION DE LA ECONOMIA PERUANA', 1, '', '2024-11-24 05:54:57', 1);

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
(1, 1, 1, '260.00', '280.00', '25.00', 20, '', '2024-11-24 06:09:41', 1),
(2, 2, 1, '260.00', '280.00', '25.00', 20, '', '2024-11-24 06:13:01', 1),
(3, 3, 1, '260.00', '290.00', '25.00', 20, '', '2024-11-24 06:13:27', 1),
(4, 4, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:13:45', 1),
(5, 5, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:14:19', 1),
(6, 6, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:14:49', 1),
(7, 7, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:11', 1),
(8, 8, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:29', 1),
(9, 9, 1, '260.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:44', 1);

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
(18, 'MATRICULA 2025 - 10/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 7, 1, NULL, 16, 18, '', '2024-12-10 19:51:02', 1),
(19, 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 6, 1, NULL, 17, 19, '', '2024-12-12 15:14:12', 1),
(20, 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 17, 20, '', '2024-12-12 15:16:37', 1),
(21, 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 3, 1, NULL, 18, 21, '', '2024-12-12 18:36:09', 1),
(22, 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 18, 22, '', '2024-12-12 18:38:35', 1),
(23, 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 4, 1, NULL, 19, 23, '', '2024-12-13 17:07:40', 1),
(24, 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 5, 1, NULL, 20, 24, '', '2024-12-13 18:49:22', 1),
(25, 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 8, 1, NULL, 20, 25, '', '2024-12-13 18:52:10', 1),
(26, 'MATRICULA 2025 - 14/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 5, 1, NULL, 21, 26, '', '2024-12-14 17:47:38', 1),
(27, 'MATRICULA 2025 - 15/12/2024\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 3, 1, NULL, 22, 27, '', '2024-12-15 20:41:28', 1),
(28, 'MATRICULA 2025 - 16/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 6, 1, NULL, 23, 28, '', '2024-12-16 14:02:35', 1),
(29, 'MATRICULA 2025 - 16/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 9, 1, NULL, 23, 29, '', '2024-12-16 14:03:16', 1),
(30, 'MATRICULA 2025 - 19/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 8, 1, NULL, 24, 30, '', '2024-12-19 19:02:36', 1),
(31, 'MATRICULA 2025 - 20/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 6, 1, NULL, 25, 31, '', '2024-12-20 16:34:44', 1),
(32, 'MATRICULA 2025 - 06/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./270.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', 1, 2, NULL, 30, 32, '', '2025-01-06 16:57:21', 1),
(33, 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 2, NULL, 33, 33, '', '2025-01-08 21:13:07', 1),
(34, 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 6, 2, NULL, 34, 34, '', '2025-01-08 21:18:04', 1),
(35, 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 2, NULL, 35, 35, '', '2025-01-08 21:21:40', 1),
(36, 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 2, NULL, 36, 36, '', '2025-01-08 21:25:19', 1),
(37, 'MATRICULA 2025 - 09/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 1, 2, NULL, 37, 37, '', '2025-01-09 20:08:25', 1),
(38, 'MATRICULA 2025 - 21/01/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 6, 1, NULL, 40, 38, '', '2025-01-21 17:51:37', 1),
(39, 'MATRICULA 2025 - 28/01/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 7, 1, NULL, 46, 39, '', '2025-01-28 19:49:11', 1),
(40, 'MATRICULA 2025 - 30/01/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 2, 2, NULL, 47, 40, '', '2025-01-30 16:15:23', 1),
(42, 'MATRICULA 2025 - 04/02/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 6, 2, NULL, 49, 42, '', '2025-02-04 15:24:05', 1),
(43, 'MATRICULA 2025 - 04/02/2025\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 9, 1, NULL, 50, 43, '', '2025-02-04 19:44:52', 1),
(44, 'MATRICULA 2025 - 06/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 2, NULL, 51, 44, '', '2025-02-06 14:43:33', 1),
(45, 'MATRICULA 2025 - 06/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00', 4, 2, NULL, 52, 45, '', '2025-02-06 17:43:00', 1),
(46, '', 2, 1, NULL, 53, 46, '', '2025-02-07 15:01:28', 1),
(47, 'MATRICULA 2025 - 07/02/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 5, 1, NULL, 53, 47, '', '2025-02-07 15:05:18', 1),
(48, 'MATRICULA 2025 - 10/02/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 7, 1, NULL, 31, 48, '', '2025-02-10 15:29:48', 1),
(49, 'MATRICULA 2025 - 10/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00', 2, 2, NULL, 55, 49, '', '2025-02-10 19:34:59', 1),
(50, 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 1, NULL, 56, 50, '', '2025-02-13 16:48:42', 1),
(51, 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00', 2, 2, NULL, 58, 51, '', '2025-02-13 17:47:24', 1),
(52, 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 4, 2, NULL, 58, 52, '', '2025-02-13 17:50:52', 1),
(53, 'MATRICULA 2025 - 18/02/2025\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 9, 1, NULL, 61, 53, '', '2025-02-18 15:43:45', 1),
(54, 'MATRICULA 2025 - 21/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00', 2, 2, NULL, 63, 54, '', '2025-02-21 19:41:49', 1),
(55, 'MATRICULA 2025 - 24/02/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 3, 2, NULL, 64, 55, '', '2025-02-24 17:39:23', 1),
(56, 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 8, 1, NULL, 65, 56, '', '2025-02-25 16:28:17', 1),
(57, 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 1, 2, NULL, 66, 57, '', '2025-02-25 17:07:08', 1),
(58, 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 1, 2, NULL, 67, 58, '', '2025-02-25 17:12:05', 1),
(59, 'MATRICULA 2025 - 26/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 4, 2, NULL, 68, 59, '', '2025-02-26 16:05:38', 1),
(60, 'MATRICULA 2025 - 26/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: ALUMNO LIBRE', 1, 2, NULL, 52, 60, '', '2025-02-26 16:36:56', 1),
(61, 'MATRICULA 2025 - 28/02/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 6, 2, NULL, 71, 61, '', '2025-02-28 19:34:16', 1),
(62, 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 3, 1, NULL, 73, 62, '', '2025-03-03 13:43:41', 1),
(63, 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 7, 1, NULL, 74, 63, '', '2025-03-03 13:59:57', 1),
(64, 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 5, 1, NULL, 1, 64, '', '2025-03-03 19:27:52', 1),
(65, 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 5, 1, NULL, 76, 65, '', '2025-03-05 16:27:26', 1),
(66, 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 3, 2, NULL, 77, 66, '', '2025-03-05 17:02:25', 1),
(67, 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 7, 2, NULL, 78, 67, '', '2025-03-05 17:19:54', 1),
(68, 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 6, 1, NULL, 79, 68, '', '2025-03-05 19:35:12', 1),
(69, 'MATRICULA 2025 - 06/03/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 2, 2, NULL, 80, 69, '', '2025-03-06 16:47:58', 1);

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
(5, 'PENDIENTE', '', '2024-11-25 05:41:01', 1),
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
(1, 1, '000001', '2024-12-14', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-01 05:46:02', 1),
(2, 2, '000002', '2024-12-14', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-01 05:47:30', 1),
(3, 3, '000003', '2024-12-15', 'MATRICULA 2025 - IEP. EBENEZER\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-01 05:48:55', 1),
(7, 7, '000004', '2025-02-27', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 15:52:48', 1),
(8, 8, '000005', '2025-02-27', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 15:54:19', 1),
(9, 9, '000006', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-03 19:26:44', 1),
(10, 10, '000007', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-03 19:35:37', 1),
(11, 11, '000008', '2024-12-02', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:05:47', 1),
(13, 13, '000009', '2024-12-14', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-03 20:15:53', 1),
(14, 14, '000010', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:17:20', 1),
(15, 15, '000011', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:18:52', 1),
(16, 16, '000012', '2024-11-29', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:20:32', 1),
(17, 17, '000013', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-03 20:25:54', 1),
(18, 18, '000014', '2024-12-10', 'MATRICULA 2025 - 10/12/2024\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-10 19:51:02', 1),
(19, 19, '000015', '2024-12-31', 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, 'LA DIRECTORA AUTORIZO PAGO HASTA FIN DE MES (DICIEMBRE)', '2024-12-12 15:14:12', 1),
(20, 20, '000016', '2024-12-31', 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, 'LA DIRECTORA AUTORIZO PAGO HASTA FIN DE MES (DICIEMBRE)', '2024-12-12 15:16:37', 1),
(21, 21, '000017', '2024-12-12', 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-12 18:36:09', 1),
(22, 22, '000018', '2024-12-12', 'MATRICULA 2025 - 12/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-12 18:38:35', 1),
(23, 23, '000019', '2024-12-13', 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 3, '', '2024-12-13 17:07:40', 1),
(24, 24, '000020', '2024-12-13', 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-13 18:49:22', 1),
(25, 25, '000021', '2024-12-13', 'MATRICULA 2025 - 13/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-13 18:52:10', 1),
(26, 26, '000022', '2024-12-13', 'MATRICULA 2025 - 14/12/2024\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-14 17:47:38', 1),
(27, 27, '000023', '2024-12-14', 'MATRICULA 2025 - 15/12/2024\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 3, '', '2024-12-15 20:41:28', 1),
(28, 28, '000024', '2024-12-16', 'MATRICULA 2025 - 16/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-16 14:02:35', 1),
(29, 29, '000025', '2024-12-16', 'MATRICULA 2025 - 16/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-16 14:03:16', 1),
(30, 30, '000026', '2024-12-19', 'MATRICULA 2025 - 19/12/2024\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 2, '', '2024-12-19 19:02:36', 1),
(31, 31, '000027', '2024-12-19', 'MATRICULA 2025 - 20/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 1, '', '2024-12-20 16:34:44', 1),
(32, 32, '000028', '2025-01-06', 'MATRICULA 2025 - 06/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./270.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '200.00', 3, '', '2025-01-06 16:57:21', 1),
(33, 33, '000029', '2025-01-08', 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-08 21:13:07', 1),
(34, 34, '000030', '2025-01-08', 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-08 21:18:04', 1),
(35, 35, '000031', '2025-01-08', 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-08 21:21:40', 1),
(36, 36, '000032', '2025-01-08', 'MATRICULA 2025 - 08/01/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-08 21:25:19', 1),
(37, 37, '000033', '2025-01-09', 'MATRICULA 2025 - 09/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-09 20:08:25', 1),
(38, 38, '000034', '2025-01-20', 'MATRICULA 2025 - 21/01/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '240.00', 3, '', '2025-01-21 17:51:37', 1),
(39, 39, '000035', '2025-01-28', 'MATRICULA 2025 - 28/01/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00', '220.00', 1, '', '2025-01-28 19:49:11', 1),
(40, 40, '000036', '2025-01-30', 'MATRICULA 2025 - 30/01/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-30 16:15:23', 1),
(42, 42, '000038', '2025-02-04', 'MATRICULA 2025 - 04/02/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 3, '', '2025-02-04 15:24:05', 1),
(43, 43, '000039', '2025-02-04', 'MATRICULA 2025 - 04/02/2025\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 1, '', '2025-02-04 19:44:52', 1),
(44, 44, '000040', '2025-02-06', 'MATRICULA 2025 - 06/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '200.00', 2, '', '2025-02-06 14:43:33', 1),
(45, 45, '000041', '2025-02-06', 'MATRICULA 2025 - 06/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '240.00', 2, '', '2025-02-06 17:43:00', 1),
(46, 46, '000042', '2025-02-07', 'MATRICULA 2025 - 07/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 2, '', '2025-02-07 15:01:28', 1),
(47, 47, '000043', '2025-02-07', 'MATRICULA 2025 - 07/02/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '0.00', 6, '', '2025-02-07 15:05:18', 1),
(48, 48, '000044', '2025-02-10', 'MATRICULA 2025 - 10/02/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A', '200.00', 2, '', '2025-02-10 15:29:48', 1),
(49, 49, '000045', '2025-02-10', 'MATRICULA 2025 - 10/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 1, '', '2025-02-10 19:34:59', 1),
(50, 50, '000046', '2025-02-13', 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00', '260.00', 2, '', '2025-02-13 16:48:42', 1),
(51, 51, '000047', '2025-02-13', 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 1, '', '2025-02-13 17:47:24', 1),
(52, 52, '000048', '2025-02-13', 'MATRICULA 2025 - 13/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00', '260.00', 1, '', '2025-02-13 17:50:52', 1),
(53, 53, '000049', '2025-02-18', 'MATRICULA 2025 - 18/02/2025\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00', '220.00', 1, '', '2025-02-18 15:43:45', 1),
(54, 54, '000050', '2025-02-21', 'MATRICULA 2025 - 21/02/2025\r\nNIVEL: INICIAL - GRADO: 4 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 2, '', '2025-02-21 19:41:49', 1),
(55, 55, '000051', '2025-02-24', 'MATRICULA 2025 - 24/02/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00', '260.00', 2, '', '2025-02-24 17:39:23', 1),
(56, 56, '000052', '2025-02-25', 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: PRIMARIA - GRADO: 5 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '0.00', 6, '', '2025-02-25 16:28:17', 1),
(57, 57, '000053', '2025-02-25', 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 2, '', '2025-02-25 17:07:08', 1),
(58, 58, '000054', '2025-02-25', 'MATRICULA 2025 - 25/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 2, '', '2025-02-25 17:12:05', 1),
(59, 59, '000055', '2025-02-26', 'MATRICULA 2025 - 26/02/2025\r\nNIVEL: PRIMARIA - GRADO: 1 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 2, '', '2025-02-26 16:05:39', 1),
(60, 60, '000056', '2025-02-26', 'MATRICULA 2025 - 26/02/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '200.00', 1, '', '2025-02-26 16:36:56', 1),
(61, 61, '000057', '2025-02-28', 'MATRICULA 2025 - 28/02/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 4, '', '2025-02-28 19:34:16', 1),
(62, 62, '000058', '2025-03-01', 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 3, '', '2025-03-03 13:43:41', 1),
(63, 63, '000059', '2025-03-03', 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '240.00', 2, '', '2025-03-03 13:59:57', 1),
(64, 64, '000060', '2025-03-03', 'MATRICULA 2025 - 03/03/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 1, '', '2025-03-03 19:27:52', 1),
(65, 65, '000061', '2025-03-05', 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 2 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-03-05 16:27:26', 1),
(66, 66, '000062', '2025-03-05', 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: INICIAL - GRADO: 5 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./290.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 2, '', '2025-03-05 17:02:25', 1),
(67, 67, '000063', '2025-03-05', 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 4 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 1, '', '2025-03-05 17:19:54', 1),
(68, 68, '000064', '2025-03-05', 'MATRICULA 2025 - 05/03/2025\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./310.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '240.00', 1, '', '2025-03-05 19:35:12', 1),
(69, 69, '000065', '2025-03-06', 'MATRICULA 2025 - 06/03/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./260.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '260.00', 2, '', '2025-03-06 16:47:58', 1);

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
(1, 1, 1, '280.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-01 05:46:02', 1),
(2, 2, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(3, 3, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(4, 4, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(5, 5, 1, '305.00', 0, '', '2024-12-01 05:46:02', 1),
(6, 6, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(7, 7, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(8, 8, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(9, 9, 1, '280.00', 0, '', '2024-12-01 05:46:02', 1),
(10, 10, 1, '305.00', 0, '', '2024-12-01 05:46:02', 1),
(11, 1, 2, '280.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-01 05:47:30', 1),
(12, 2, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(13, 3, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(14, 4, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(15, 5, 2, '305.00', 0, '', '2024-12-01 05:47:30', 1),
(16, 6, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(17, 7, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(18, 8, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(19, 9, 2, '280.00', 0, '', '2024-12-01 05:47:30', 1),
(20, 10, 2, '305.00', 0, '', '2024-12-01 05:47:30', 1),
(21, 1, 3, '280.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-01 05:48:55', 1),
(22, 2, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(23, 3, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(24, 4, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(25, 5, 3, '305.00', 0, '', '2024-12-01 05:48:55', 1),
(26, 6, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(27, 7, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(28, 8, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(29, 9, 3, '280.00', 0, '', '2024-12-01 05:48:55', 1),
(30, 10, 3, '305.00', 0, '', '2024-12-01 05:48:55', 1),
(34, 1, 7, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 15:52:48', 1),
(35, 2, 7, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-03 15:52:48', 1),
(36, 3, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(37, 4, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(38, 5, 7, '315.00', 0, '', '2024-12-03 15:52:48', 1),
(39, 6, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(40, 7, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(41, 8, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(42, 9, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(43, 10, 7, '315.00', 0, '', '2024-12-03 15:52:48', 1),
(44, 1, 8, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 15:54:19', 1),
(45, 2, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(46, 3, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(47, 4, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(48, 5, 8, '325.00', 0, '', '2024-12-03 15:54:19', 1),
(49, 6, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(50, 7, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(51, 8, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(52, 9, 8, '300.00', 0, '', '2024-12-03 15:54:19', 1),
(53, 10, 8, '325.00', 0, '', '2024-12-03 15:54:19', 1),
(54, 1, 9, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 19:26:44', 1),
(55, 2, 9, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-03 19:26:44', 1),
(56, 3, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(57, 4, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(58, 5, 9, '315.00', 0, '', '2024-12-03 19:26:44', 1),
(59, 6, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(60, 7, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(61, 8, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(62, 9, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(63, 10, 9, '315.00', 0, '', '2024-12-03 19:26:44', 1),
(64, 1, 10, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 19:35:37', 1),
(65, 2, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(66, 3, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(67, 4, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(68, 5, 10, '325.00', 0, '', '2024-12-03 19:35:37', 1),
(69, 6, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(70, 7, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(71, 8, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(72, 9, 10, '300.00', 0, '', '2024-12-03 19:35:37', 1),
(73, 10, 10, '325.00', 0, '', '2024-12-03 19:35:37', 1),
(74, 1, 11, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:05:47', 1),
(75, 2, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(76, 3, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(77, 4, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(78, 5, 11, '325.00', 0, '', '2024-12-03 20:05:47', 1),
(79, 6, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(80, 7, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(81, 8, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(82, 9, 11, '300.00', 0, '', '2024-12-03 20:05:47', 1),
(83, 10, 11, '325.00', 0, '', '2024-12-03 20:05:47', 1),
(94, 1, 13, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:15:53', 1),
(95, 2, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(96, 3, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(97, 4, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(98, 5, 13, '325.00', 0, '', '2024-12-03 20:15:53', 1),
(99, 6, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(100, 7, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(101, 8, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(102, 9, 13, '300.00', 0, '', '2024-12-03 20:15:53', 1),
(103, 10, 13, '325.00', 0, '', '2024-12-03 20:15:53', 1),
(104, 1, 14, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:17:20', 1),
(105, 2, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(106, 3, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(107, 4, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(108, 5, 14, '325.00', 0, '', '2024-12-03 20:17:20', 1),
(109, 6, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(110, 7, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(111, 8, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(112, 9, 14, '300.00', 0, '', '2024-12-03 20:17:20', 1),
(113, 10, 14, '325.00', 0, '', '2024-12-03 20:17:20', 1),
(114, 1, 15, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:18:52', 1),
(115, 2, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(116, 3, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(117, 4, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(118, 5, 15, '325.00', 0, '', '2024-12-03 20:18:52', 1),
(119, 6, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(120, 7, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(121, 8, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(122, 9, 15, '300.00', 0, '', '2024-12-03 20:18:52', 1),
(123, 10, 15, '325.00', 0, '', '2024-12-03 20:18:52', 1),
(124, 1, 16, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:20:32', 1),
(125, 2, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(126, 3, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(127, 4, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(128, 5, 16, '325.00', 0, '', '2024-12-03 20:20:32', 1),
(129, 6, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(130, 7, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(131, 8, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(132, 9, 16, '300.00', 0, '', '2024-12-03 20:20:32', 1),
(133, 10, 16, '325.00', 0, '', '2024-12-03 20:20:32', 1),
(134, 1, 17, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-03 20:25:54', 1),
(135, 2, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(136, 3, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(137, 4, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(138, 5, 17, '325.00', 0, '', '2024-12-03 20:25:54', 1),
(139, 6, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(140, 7, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(141, 8, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(142, 9, 17, '300.00', 0, '', '2024-12-03 20:25:54', 1),
(143, 10, 17, '325.00', 0, '', '2024-12-03 20:25:54', 1),
(144, 1, 18, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-10 19:51:02', 1),
(145, 2, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(146, 3, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(147, 4, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(148, 5, 18, '325.00', 0, '', '2024-12-10 19:51:02', 1),
(149, 6, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(150, 7, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(151, 8, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(152, 9, 18, '300.00', 0, '', '2024-12-10 19:51:02', 1),
(153, 10, 18, '325.00', 0, '', '2024-12-10 19:51:02', 1),
(154, 1, 19, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-12 15:14:12', 1),
(155, 2, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(156, 3, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(157, 4, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(158, 5, 19, '325.00', 0, '', '2024-12-12 15:14:12', 1),
(159, 6, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(160, 7, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(161, 8, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(162, 9, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(163, 10, 19, '325.00', 0, '', '2024-12-12 15:14:12', 1),
(164, 1, 20, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-12 15:16:37', 1),
(165, 2, 20, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-12 15:16:37', 1),
(166, 3, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(167, 4, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(168, 5, 20, '315.00', 0, '', '2024-12-12 15:16:37', 1),
(169, 6, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(170, 7, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(171, 8, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(172, 9, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
(173, 10, 20, '315.00', 0, '', '2024-12-12 15:16:37', 1),
(174, 1, 21, '280.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-12 18:36:09', 1),
(175, 2, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(176, 3, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(177, 4, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(178, 5, 21, '305.00', 0, '', '2024-12-12 18:36:09', 1),
(179, 6, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(180, 7, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(181, 8, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(182, 9, 21, '280.00', 0, '', '2024-12-12 18:36:09', 1),
(183, 10, 21, '305.00', 0, '', '2024-12-12 18:36:09', 1),
(184, 1, 22, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-12 18:38:35', 1),
(185, 2, 22, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-12 18:38:35', 1),
(186, 3, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(187, 4, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(188, 5, 22, '315.00', 0, '', '2024-12-12 18:38:35', 1),
(189, 6, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(190, 7, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(191, 8, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(192, 9, 22, '290.00', 0, '', '2024-12-12 18:38:35', 1),
(193, 10, 22, '315.00', 0, '', '2024-12-12 18:38:35', 1),
(194, 1, 23, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-13 17:07:40', 1),
(195, 2, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(196, 3, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(197, 4, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(198, 5, 23, '325.00', 0, '', '2024-12-13 17:07:40', 1),
(199, 6, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(200, 7, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(201, 8, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(202, 9, 23, '300.00', 0, '', '2024-12-13 17:07:40', 1),
(203, 10, 23, '325.00', 0, '', '2024-12-13 17:07:40', 1),
(204, 1, 24, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-13 18:49:22', 1),
(205, 2, 24, '300.00', 0, 'SE CANCELO 50 MANT. EN EFECTIVO 17/02', '2024-12-13 18:49:22', 1),
(206, 3, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(207, 4, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(208, 5, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(209, 6, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(210, 7, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(211, 8, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(212, 9, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(213, 10, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(214, 1, 25, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-13 18:52:10', 1),
(215, 2, 25, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-13 18:52:10', 1),
(216, 3, 25, '290.00', 0, 'SE CANCELO 50 MANT. EN EFECTIVO 17/02', '2024-12-13 18:52:10', 1),
(217, 4, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(218, 5, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(219, 6, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(220, 7, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(221, 8, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(222, 9, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(223, 10, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(224, 1, 26, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-14 17:47:38', 1),
(225, 2, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(226, 3, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(227, 4, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(228, 5, 26, '325.00', 0, '', '2024-12-14 17:47:38', 1),
(229, 6, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(230, 7, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(231, 8, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(232, 9, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
(233, 10, 26, '325.00', 0, '', '2024-12-14 17:47:38', 1),
(234, 1, 27, '280.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-15 20:41:28', 1),
(235, 2, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(236, 3, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(237, 4, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(238, 5, 27, '305.00', 0, '', '2024-12-15 20:41:28', 1),
(239, 6, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(240, 7, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(241, 8, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(242, 9, 27, '280.00', 0, '', '2024-12-15 20:41:28', 1),
(243, 10, 27, '305.00', 0, '', '2024-12-15 20:41:28', 1),
(244, 1, 28, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-16 14:02:35', 1),
(245, 2, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(246, 3, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(247, 4, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(248, 5, 28, '325.00', 0, '', '2024-12-16 14:02:35', 1),
(249, 6, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(250, 7, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(251, 8, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(252, 9, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(253, 10, 28, '325.00', 0, '', '2024-12-16 14:02:35', 1),
(254, 1, 29, '290.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-16 14:03:16', 1),
(255, 2, 29, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-16 14:03:16', 1),
(256, 3, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(257, 4, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(258, 5, 29, '315.00', 0, '', '2024-12-16 14:03:16', 1),
(259, 6, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(260, 7, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(261, 8, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(262, 9, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(263, 10, 29, '315.00', 0, '', '2024-12-16 14:03:16', 1),
(264, 1, 30, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-19 19:02:36', 1),
(265, 2, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(266, 3, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(267, 4, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(268, 5, 30, '325.00', 0, '', '2024-12-19 19:02:36', 1),
(269, 6, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(270, 7, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(271, 8, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(272, 9, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(273, 10, 30, '325.00', 0, '', '2024-12-19 19:02:36', 1),
(274, 1, 31, '300.00', 0, 'DSCTO. MATRICULA 15 DIC -10', '2024-12-20 16:34:44', 1),
(275, 2, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(276, 3, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(277, 4, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(278, 5, 31, '325.00', 0, '', '2024-12-20 16:34:44', 1),
(279, 6, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(280, 7, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(281, 8, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(282, 9, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
(283, 10, 31, '325.00', 0, '', '2024-12-20 16:34:44', 1),
(284, 1, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(285, 2, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(286, 3, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(287, 4, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(288, 5, 32, '305.00', 0, '', '2025-01-06 16:57:21', 1),
(289, 6, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(290, 7, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(291, 8, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(292, 9, 32, '280.00', 0, '', '2025-01-06 16:57:21', 1),
(293, 10, 32, '305.00', 0, '', '2025-01-06 16:57:21', 1),
(294, 1, 33, '300.00', 0, 'DSCTO. REFERIDOS X1 -10 SOLES', '2025-01-08 21:13:07', 1),
(295, 2, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(296, 3, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(297, 4, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(298, 5, 33, '325.00', 0, '', '2025-01-08 21:13:07', 1),
(299, 6, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(300, 7, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(301, 8, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(302, 9, 33, '300.00', 0, '', '2025-01-08 21:13:07', 1),
(303, 10, 33, '325.00', 0, '', '2025-01-08 21:13:07', 1),
(304, 1, 34, '260.00', 0, 'DSCTO. REFERIDOS X2 -50 SOLES', '2025-01-08 21:18:04', 1),
(305, 2, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(306, 3, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(307, 4, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(308, 5, 34, '285.00', 0, '', '2025-01-08 21:18:04', 1),
(309, 6, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(310, 7, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(311, 8, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(312, 9, 34, '260.00', 0, '', '2025-01-08 21:18:04', 1),
(313, 10, 34, '285.00', 0, '', '2025-01-08 21:18:04', 1),
(314, 1, 35, '300.00', 0, 'DSCTO. OTROS -10', '2025-01-08 21:21:40', 1),
(315, 2, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(316, 3, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(317, 4, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(318, 5, 35, '325.00', 0, '', '2025-01-08 21:21:40', 1),
(319, 6, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(320, 7, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(321, 8, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(322, 9, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(323, 10, 35, '325.00', 0, '', '2025-01-08 21:21:40', 1),
(324, 1, 36, '300.00', 0, 'DSCTO. OTROS -10', '2025-01-08 21:25:19', 1),
(325, 2, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(326, 3, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(327, 4, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(328, 5, 36, '325.00', 0, '', '2025-01-08 21:25:19', 1),
(329, 6, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(330, 7, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(331, 8, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(332, 9, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
(333, 10, 36, '325.00', 0, '', '2025-01-08 21:25:19', 1),
(334, 1, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(335, 2, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(336, 3, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(337, 4, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(338, 5, 37, '305.00', 0, '', '2025-01-09 20:08:25', 1),
(339, 6, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(340, 7, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(341, 8, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(342, 9, 37, '280.00', 0, '', '2025-01-09 20:08:25', 1),
(343, 10, 37, '305.00', 0, '', '2025-01-09 20:08:25', 1),
(344, 1, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(345, 2, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(346, 3, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(347, 4, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(348, 5, 38, '335.00', 0, '', '2025-01-21 17:51:37', 1),
(349, 6, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(350, 7, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(351, 8, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(352, 9, 38, '310.00', 0, '', '2025-01-21 17:51:37', 1),
(353, 10, 38, '335.00', 0, '', '2025-01-21 17:51:37', 1),
(354, 1, 39, '300.00', 0, 'DSCTO. OTROS -10', '2025-01-28 19:49:11', 1),
(355, 2, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(356, 3, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(357, 4, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(358, 5, 39, '325.00', 0, '', '2025-01-28 19:49:11', 1),
(359, 6, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(360, 7, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(361, 8, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(362, 9, 39, '300.00', 0, '', '2025-01-28 19:49:11', 1),
(363, 10, 39, '325.00', 0, '', '2025-01-28 19:49:11', 1),
(364, 1, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(365, 2, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(366, 3, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(367, 4, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(368, 5, 40, '305.00', 0, '', '2025-01-30 16:15:23', 1),
(369, 6, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(370, 7, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(371, 8, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(372, 9, 40, '280.00', 0, '', '2025-01-30 16:15:23', 1),
(373, 10, 40, '305.00', 0, '', '2025-01-30 16:15:23', 1),
(384, 1, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(385, 2, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(386, 3, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(387, 4, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(388, 5, 42, '335.00', 0, '', '2025-02-04 15:24:05', 1),
(389, 6, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(390, 7, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(391, 8, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(392, 9, 42, '310.00', 0, '', '2025-02-04 15:24:05', 1),
(393, 10, 42, '335.00', 0, '', '2025-02-04 15:24:05', 1),
(394, 1, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(395, 2, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(396, 3, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(397, 4, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(398, 5, 43, '335.00', 0, '', '2025-02-04 19:44:52', 1),
(399, 6, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(400, 7, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(401, 8, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(402, 9, 43, '310.00', 0, '', '2025-02-04 19:44:52', 1),
(403, 10, 43, '335.00', 0, '', '2025-02-04 19:44:52', 1),
(404, 1, 44, '290.00', 0, 'DSCTO. OTROS -20', '2025-02-06 14:43:33', 1),
(405, 2, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(406, 3, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(407, 4, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(408, 5, 44, '315.00', 0, '', '2025-02-06 14:43:33', 1),
(409, 6, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(410, 7, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(411, 8, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(412, 9, 44, '290.00', 0, '', '2025-02-06 14:43:33', 1),
(413, 10, 44, '315.00', 0, '', '2025-02-06 14:43:33', 1),
(414, 1, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(415, 2, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(416, 3, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(417, 4, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(418, 5, 45, '335.00', 0, '', '2025-02-06 17:43:00', 1),
(419, 6, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(420, 7, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(421, 8, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(422, 9, 45, '310.00', 0, '', '2025-02-06 17:43:00', 1),
(423, 10, 45, '335.00', 0, '', '2025-02-06 17:43:00', 1),
(424, 1, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(425, 2, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(426, 3, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(427, 4, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(428, 5, 46, '305.00', 0, '', '2025-02-07 15:01:28', 1),
(429, 6, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(430, 7, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(431, 8, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(432, 9, 46, '280.00', 0, '', '2025-02-07 15:01:28', 1),
(433, 10, 46, '305.00', 0, '', '2025-02-07 15:01:28', 1),
(434, 1, 47, '300.00', 0, 'DSCTO. HERMANOS -10 SOLES', '2025-02-07 15:05:18', 1),
(435, 2, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(436, 3, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(437, 4, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(438, 5, 47, '325.00', 0, '', '2025-02-07 15:05:18', 1),
(439, 6, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(440, 7, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(441, 8, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(442, 9, 47, '300.00', 0, '', '2025-02-07 15:05:18', 1),
(443, 10, 47, '325.00', 0, '', '2025-02-07 15:05:18', 1),
(444, 1, 48, '250.00', 0, 'DSCTO. OTROS -60', '2025-02-10 15:29:48', 1),
(445, 2, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(446, 3, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(447, 4, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(448, 5, 48, '275.00', 0, '', '2025-02-10 15:29:48', 1),
(449, 6, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(450, 7, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(451, 8, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(452, 9, 48, '250.00', 0, '', '2025-02-10 15:29:48', 1),
(453, 10, 48, '275.00', 0, '', '2025-02-10 15:29:48', 1),
(454, 1, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(455, 2, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(456, 3, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(457, 4, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(458, 5, 49, '305.00', 0, '', '2025-02-10 19:34:59', 1),
(459, 6, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(460, 7, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(461, 8, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(462, 9, 49, '280.00', 0, '', '2025-02-10 19:34:59', 1),
(463, 10, 49, '305.00', 0, '', '2025-02-10 19:34:59', 1),
(464, 1, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(465, 2, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(466, 3, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(467, 4, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(468, 5, 50, '335.00', 0, '', '2025-02-13 16:48:42', 1),
(469, 6, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(470, 7, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(471, 8, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(472, 9, 50, '310.00', 0, '', '2025-02-13 16:48:42', 1),
(473, 10, 50, '335.00', 0, '', '2025-02-13 16:48:42', 1),
(474, 1, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(475, 2, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(476, 3, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(477, 4, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(478, 5, 51, '305.00', 0, '', '2025-02-13 17:47:24', 1),
(479, 6, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(480, 7, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(481, 8, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(482, 9, 51, '280.00', 0, '', '2025-02-13 17:47:24', 1),
(483, 10, 51, '305.00', 0, '', '2025-02-13 17:47:24', 1),
(484, 1, 52, '300.00', 0, 'DSCTO. HERMANOS -10 SOLES', '2025-02-13 17:50:52', 1),
(485, 2, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(486, 3, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(487, 4, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(488, 5, 52, '325.00', 0, '', '2025-02-13 17:50:52', 1),
(489, 6, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(490, 7, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(491, 8, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(492, 9, 52, '300.00', 0, '', '2025-02-13 17:50:52', 1),
(493, 10, 52, '325.00', 0, '', '2025-02-13 17:50:52', 1),
(494, 1, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(495, 2, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(496, 3, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(497, 4, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(498, 5, 53, '335.00', 0, '', '2025-02-18 15:43:45', 1),
(499, 6, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(500, 7, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(501, 8, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(502, 9, 53, '310.00', 0, '', '2025-02-18 15:43:45', 1),
(503, 10, 53, '335.00', 0, '', '2025-02-18 15:43:45', 1),
(504, 1, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(505, 2, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(506, 3, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(507, 4, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(508, 5, 54, '305.00', 0, '', '2025-02-21 19:41:49', 1),
(509, 6, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(510, 7, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(511, 8, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(512, 9, 54, '280.00', 0, '', '2025-02-21 19:41:49', 1),
(513, 10, 54, '305.00', 0, '', '2025-02-21 19:41:49', 1),
(514, 1, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(515, 2, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(516, 3, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(517, 4, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(518, 5, 55, '315.00', 0, '', '2025-02-24 17:39:23', 1),
(519, 6, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(520, 7, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(521, 8, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(522, 9, 55, '290.00', 0, '', '2025-02-24 17:39:23', 1),
(523, 10, 55, '315.00', 0, '', '2025-02-24 17:39:23', 1),
(524, 1, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(525, 2, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(526, 3, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(527, 4, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(528, 5, 56, '335.00', 0, '', '2025-02-25 16:28:17', 1),
(529, 6, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(530, 7, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(531, 8, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(532, 9, 56, '310.00', 0, '', '2025-02-25 16:28:17', 1),
(533, 10, 56, '335.00', 0, '', '2025-02-25 16:28:17', 1),
(534, 1, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(535, 2, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(536, 3, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(537, 4, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(538, 5, 57, '305.00', 0, '', '2025-02-25 17:07:08', 1),
(539, 6, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(540, 7, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(541, 8, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(542, 9, 57, '280.00', 0, '', '2025-02-25 17:07:08', 1),
(543, 10, 57, '305.00', 0, '', '2025-02-25 17:07:08', 1),
(544, 1, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(545, 2, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(546, 3, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(547, 4, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(548, 5, 58, '305.00', 0, '', '2025-02-25 17:12:05', 1),
(549, 6, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(550, 7, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(551, 8, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(552, 9, 58, '280.00', 0, '', '2025-02-25 17:12:05', 1),
(553, 10, 58, '305.00', 0, '', '2025-02-25 17:12:05', 1),
(554, 1, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(555, 2, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(556, 3, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(557, 4, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(558, 5, 59, '335.00', 0, '', '2025-02-26 16:05:39', 1),
(559, 6, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(560, 7, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(561, 8, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(562, 9, 59, '310.00', 0, '', '2025-02-26 16:05:39', 1),
(563, 10, 59, '335.00', 0, '', '2025-02-26 16:05:39', 1),
(564, 1, 60, '250.00', 0, 'ALUMNO LIBRE', '2025-02-26 16:36:56', 1),
(565, 2, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(566, 3, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(567, 4, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(568, 5, 60, '275.00', 0, '', '2025-02-26 16:36:56', 1),
(569, 6, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(570, 7, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(571, 8, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(572, 9, 60, '250.00', 0, '', '2025-02-26 16:36:56', 1),
(573, 10, 60, '275.00', 0, '', '2025-02-26 16:36:56', 1),
(574, 1, 61, '250.00', 0, 'DSCTO. RECOM. LUCHO ESTRADA', '2025-02-28 19:34:16', 1),
(575, 2, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(576, 3, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(577, 4, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(578, 5, 61, '275.00', 0, '', '2025-02-28 19:34:16', 1),
(579, 6, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(580, 7, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(581, 8, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(582, 9, 61, '250.00', 0, '', '2025-02-28 19:34:16', 1),
(583, 10, 61, '275.00', 0, '', '2025-02-28 19:34:16', 1),
(584, 1, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(585, 2, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(586, 3, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(587, 4, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(588, 5, 62, '315.00', 0, '', '2025-03-03 13:43:41', 1),
(589, 6, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(590, 7, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(591, 8, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(592, 9, 62, '290.00', 0, '', '2025-03-03 13:43:41', 1),
(593, 10, 62, '315.00', 0, '', '2025-03-03 13:43:41', 1),
(594, 1, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(595, 2, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(596, 3, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(597, 4, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(598, 5, 63, '335.00', 0, '', '2025-03-03 13:59:57', 1),
(599, 6, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(600, 7, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(601, 8, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(602, 9, 63, '310.00', 0, '', '2025-03-03 13:59:57', 1),
(603, 10, 63, '335.00', 0, '', '2025-03-03 13:59:57', 1),
(604, 1, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(605, 2, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(606, 3, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(607, 4, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(608, 5, 64, '335.00', 0, '', '2025-03-03 19:27:52', 1),
(609, 6, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(610, 7, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(611, 8, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(612, 9, 64, '310.00', 0, '', '2025-03-03 19:27:52', 1),
(613, 10, 64, '335.00', 0, '', '2025-03-03 19:27:52', 1),
(614, 1, 65, '250.00', 0, 'DSCTO. OTROS -60', '2025-03-05 16:27:26', 1),
(615, 2, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(616, 3, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(617, 4, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(618, 5, 65, '275.00', 0, '', '2025-03-05 16:27:26', 1),
(619, 6, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(620, 7, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(621, 8, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(622, 9, 65, '250.00', 0, '', '2025-03-05 16:27:26', 1),
(623, 10, 65, '275.00', 0, '', '2025-03-05 16:27:26', 1),
(624, 1, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(625, 2, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(626, 3, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(627, 4, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(628, 5, 66, '315.00', 0, '', '2025-03-05 17:02:25', 1),
(629, 6, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(630, 7, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(631, 8, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(632, 9, 66, '290.00', 0, '', '2025-03-05 17:02:25', 1),
(633, 10, 66, '315.00', 0, '', '2025-03-05 17:02:25', 1),
(634, 1, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(635, 2, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(636, 3, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(637, 4, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(638, 5, 67, '335.00', 0, '', '2025-03-05 17:19:54', 1),
(639, 6, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(640, 7, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(641, 8, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(642, 9, 67, '310.00', 0, '', '2025-03-05 17:19:54', 1),
(643, 10, 67, '335.00', 0, '', '2025-03-05 17:19:54', 1),
(644, 1, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(645, 2, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(646, 3, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(647, 4, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(648, 5, 68, '335.00', 0, '', '2025-03-05 19:35:12', 1),
(649, 6, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(650, 7, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(651, 8, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(652, 9, 68, '310.00', 0, '', '2025-03-05 19:35:12', 1),
(653, 10, 68, '335.00', 0, '', '2025-03-05 19:35:12', 1),
(654, 1, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(655, 2, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(656, 3, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(657, 4, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(658, 5, 69, '305.00', 0, '', '2025-03-06 16:47:58', 1),
(659, 6, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(660, 7, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(661, 8, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(662, 9, 69, '280.00', 0, '', '2025-03-06 16:47:58', 1),
(663, 10, 69, '305.00', 0, '', '2025-03-06 16:47:58', 1);

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
(1, 1, 1, '91340784', 'TORRES FERRER DAHELA RENATTA', '2019-09-03', '', 1, '91340784', '91340784', '', '2024-12-01 05:46:02', 1),
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
(18, 16, 1, '79176666', 'OBREGON RISCO MIQUEAS SANTIAGO', '2015-06-27', '', 2, '79176666', '79176666', '', '2024-12-10 19:51:02', 1),
(19, 17, 1, '79928099', 'REGALADO TITO ANGELA NADESKA', '2016-11-04', '', 1, '79928099', '79928099', '', '2024-12-12 15:14:12', 1),
(20, 17, 1, '78485166', 'REGALADO TITO HECTOR ADRIANO AQUILES', '2014-02-25', '', 2, '78485166', '78485166', '', '2024-12-12 15:16:37', 1),
(21, 18, 1, '91601455', 'SOVERO PEREA NICOLAS FABRIZIO', '2019-11-20', '', 2, '91601455', '91601455', '', '2024-12-12 18:36:09', 1),
(22, 18, 1, '78169353', 'SOVERO PEREA CARLOS MOISES', '2013-07-03', '', 2, '78169353', '78169353', '', '2024-12-12 18:38:35', 1),
(23, 19, 1, '90994341', 'QUISPE RIVAS SAMANTHA NATALIA', '2018-10-05', '', 1, '90994341', '90994341', '', '2024-12-13 17:07:40', 1),
(24, 20, 1, '90178071', 'SALVADOR LOARTE ANGELY CAMILA', '2017-04-14', '', 1, '90178071', '90178071', '', '2024-12-13 18:49:22', 1),
(25, 20, 1, '78637674', 'SALVADOR LOARTE JONATHAN BAHYRÓN', '2014-06-20', '', 2, '78637674', '78637674', '', '2024-12-13 18:52:10', 1),
(26, 21, 1, '90259735', 'MEDINA FUENTES BRISTAN MILER', '2017-06-09', '', 2, '90259735', '90259735', '', '2024-12-14 17:47:38', 1),
(27, 22, 1, '91647311', 'LLEMPEN MESTANZA THAIS ALEJANDRA', '2019-12-22', '', 1, '91647311', '91647311', '', '2024-12-15 20:41:28', 1),
(28, 23, 1, '79992036', 'ORE CARHUAS KALET EMANUEL', '2016-12-09', '', 2, '79992036', '79992036', '', '2024-12-16 14:02:35', 1),
(29, 23, 1, '78412418', 'ORE CARHUAS JESUS DAVID', '2013-12-08', '', 2, '78412418', '78412418', '', '2024-12-16 14:03:16', 1),
(30, 24, 1, '79011209', 'CONDORI PALACIOS THIAGO GABRIEL', '2015-03-05', '', 2, '79011209', '79011209', '', '2024-12-19 19:02:36', 1),
(31, 25, 1, '79818384', 'CECILIO CRUZ LIRIA NAIARA', '2016-08-22', '', 1, '79818384', '79818384', '', '2024-12-20 16:34:44', 1),
(32, 30, 1, '92756809', 'ZURITA GONZALES DYLAN VALENTINO', '2022-02-14', '', 2, '92756809', '92756809', '', '2025-01-06 16:57:21', 1),
(33, 33, 1, '78911962', 'COTRINA TORIBIO ZOE LUCIANA', '2014-12-28', '', 1, '78911962', '78911962', '', '2025-01-08 21:13:07', 1),
(34, 34, 1, '90064704', 'TUPIÑO TORIBIO ANGELY CATALEYA', '2017-02-04', '', 1, '90064704', '90064704', '', '2025-01-08 21:18:04', 1),
(35, 35, 1, '78905918', 'OSORIO VALDIVIA ARHIAN ALEJANDRO', '2014-12-18', '', 2, '78905918', '78905918', '', '2025-01-08 21:21:40', 1),
(36, 36, 1, '79038891', 'TELLO TORIBIO ORLANDO SAMIR', '2015-03-26', '', 2, '79038891', '79038891', '', '2025-01-08 21:25:19', 1),
(37, 37, 1, '92821407', 'FLORES SHUPINGAHUA LUCIA SOFIA AURELIA', '2022-03-28', '', 1, '92821407', '92821407', '', '2025-01-09 20:08:25', 1),
(38, 40, 1, '79999511', 'MENDO JUAPE MATTHEW BENJAMIN', '2016-11-19', '', 2, '79999511', '79999511', '', '2025-01-21 17:51:37', 1),
(39, 46, 1, '79174904', 'DAVILA RODRIGUEZ ARIANA MABEL', '2015-06-18', '', 1, '79174904', '79174904', '', '2025-01-28 19:49:11', 1),
(40, 47, 1, '91968865', 'VELASCO MEZA JUAN IGNACIO', '2020-08-12', '', 2, '91968865', '91968865', '', '2025-01-30 16:15:23', 1),
(42, 49, 1, '79913760', 'VELIS TORRES JOSE GAEL', '2016-09-30', '', 2, '79913760', '79913760', '', '2025-02-04 15:24:05', 1),
(43, 50, 1, '78496580', 'PUJAY HUAMANI ANTHONELLA JASMIN', '2014-02-21', '', 1, '78496580', '78496580', '', '2025-02-04 19:44:52', 1),
(44, 51, 1, '78578865', 'BLAS HUERTA SHARON ANTUANET', '2014-04-30', '', 1, '78578865', '78578865', '', '2025-02-06 14:43:33', 1),
(45, 52, 1, '91255628', 'GOMEZ HUAMAN NAYTARA KIABETH', '2019-03-10', '', 1, '91255628', '91255628', '', '2025-02-06 17:43:00', 1),
(46, 53, 1, '91998486', 'RAYMUNDO SOSA ISABELLA KRISHA', '2020-09-02', '', 1, '91998486', '91998486', '', '2025-02-07 15:01:28', 1),
(47, 53, 1, '90586662', 'RAYMUNDO SOSA LUNA KRISNA', '2018-01-17', '', 1, '90586662', '90586662', '', '2025-02-07 15:05:18', 1),
(48, 31, 1, '79077669', 'COTRINA HUAIRA YAREDMY AITANA', '2015-04-18', '', 1, '79077669', '79077669', '', '2025-02-10 15:29:48', 1),
(49, 55, 1, '91907638', 'CHAHUA CASO DANNA ROSMADILEY', '2020-06-27', '', 1, '91907638', '91907638', '', '2025-02-10 19:34:59', 1),
(50, 56, 1, '79057501', 'ROCA GAVILAN MARK ALEXANDER', '2015-03-16', '', 1, '79057501', '79057501', '', '2025-02-13 16:48:42', 1),
(51, 58, 1, '92001766', 'BENDEZU INCHICAQUI AITANA ALISON', '2020-09-04', '', 1, '92001766', '92001766', '', '2025-02-13 17:47:24', 1),
(52, 58, 1, '91003190', 'MATOS INCHICAQUI FLAVIA ZOE', '2018-10-02', '', 1, '91003190', '91003190', '', '2025-02-13 17:50:52', 1),
(53, 61, 1, '78264132', 'CALLIRGOS PERAMAS ALEXIS GERAD', '2013-09-12', '', 2, '78264132', '78264132', '', '2025-02-18 15:43:45', 1),
(54, 63, 1, '92184755', 'PAREDES MONTES ZOE VIOLETA', '2021-01-07', '', 1, '92184755', '92184755', '', '2025-02-21 19:41:49', 1),
(55, 64, 1, '91614882', 'YACTAYO GARCIA ZITLIALI ISABEL', '2019-11-30', '', 1, '91614882', '91614882', '', '2025-02-24 17:39:23', 1),
(56, 65, 1, '78702979', 'ESPIRITU MINA JOHAN YONEL', '2014-07-14', '', 2, '78702979', '78702979', '', '2025-02-25 16:28:17', 1),
(57, 66, 1, '92920241', 'LEZCANO BOBADILLA CAYETANA THAIS', '2022-06-02', '', 1, '92920241', '92920241', '', '2025-02-25 17:07:08', 1),
(58, 67, 1, '92314701', 'ARISTA BOBADILLA MARIA CATALINA', '2021-04-14', '', 1, '92314701', '92314701', '', '2025-02-25 17:12:05', 1),
(59, 68, 1, '90831399', 'CAMPOS ECHARRY DOMINIC ABDIEL', '2018-06-19', '', 1, '90831399', '90831399', '', '2025-02-26 16:05:38', 1),
(60, 69, 1, '93100329', 'PACHAS HUAMAN LIAM EMMANUEL', '2022-10-15', '', 1, '93100329', '93100329', '', '2025-02-26 16:36:56', 1),
(61, 71, 1, '79890349', 'GIL LOPEZ SEBASTIÁN DAVID', '2016-09-24', '', 2, '79890349', '79890349', '', '2025-02-28 19:34:16', 1),
(62, 73, 1, '91521536', 'PACHECO TRUJILLO LIED MATHEO', '2019-09-17', '', 2, '91521536', '91521536', '', '2025-03-03 13:43:41', 1),
(63, 74, 1, '79543546', 'GARCIA HUAMANI ARIHANA MIKAELA', '2016-02-16', '', 1, '79543546', '79543546', '', '2025-03-03 13:59:57', 1),
(64, 1, 1, '90702846', 'TORRES FERRER MILAN IGNACIO', '2018-03-25', '', 2, '90702846', '90702846', '', '2025-03-03 19:27:52', 1),
(65, 76, 1, '90169771', 'VARGAS VARGAS IVANNA CLARISA', '2017-04-07', '', 1, '90169771', '90169771', '', '2025-03-05 16:27:26', 1),
(66, 77, 1, '91028036', 'ESTRADA DIAZ GEORDANA ZULEYKA', '2018-10-11', '', 1, '91028036', '91028036', '', '2025-03-05 17:02:25', 1),
(67, 78, 1, '79238735', 'MALDONADO SANCHEZ ZOE ISABELLA', '2015-07-17', '', 1, '79238735', '79238735', '', '2025-03-05 17:19:54', 1),
(68, 79, 1, '79205323', 'MAYTA ZAPATA JOAQUIN YAIR', '2015-07-17', '', 2, '79205323', '79205323', '', '2025-03-05 19:35:12', 1),
(69, 80, 1, '92246554', 'CONDOR ATANACIO THIAGO RAUL', '2021-02-25', '', 2, '92246554', '92246554', '', '2025-03-06 16:47:58', 1);

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
(1, 1, 1, '44520410', 'EVELIN MARITZA FERRER TAFUR', '987499267', 1, 4, '44520410', '44520410', '', '2024-12-01 05:46:02', 1),
(2, 1, 1, '10161788', 'INES SAYO ANAYA', '996627688', 1, 2, '10161788', '10161788', '', '2024-12-01 05:47:30', 1),
(3, 1, 1, '75656377', 'MARCIA JANELLI CHERO MONTES', '994070866', 1, 1, '75656377', '75656377', '', '2024-12-01 05:48:55', 1),
(7, 1, 1, '47708402', 'LAURA ANGELICA SANCHO ALCANTARA', '978673981', 1, 1, '47708402', '47708402', '', '2024-12-03 15:52:48', 1),
(8, 1, 1, '47169725', 'SINTHIA KATERINE MENDEZ ZAVALETA', '943215408', 1, 2, '47169725', '47169725', '', '2024-12-03 19:26:44', 1),
(9, 1, 1, '47875566', 'ERICKA EDITH CORREA ROJAS', '935168567', 1, 1, '47875566', '47875566', '', '2024-12-03 20:05:47', 1),
(11, 2, 1, '09616813', 'JUVENAL QUINTANA ALVAREZ', '991179293', 2, 1, '09616813', '09616813', '', '2024-12-03 20:15:53', 1),
(12, 1, 1, '40148474', 'MELINDA GARCIA OLIVAS', '935928398', 1, 2, '40148474', '40148474', '', '2024-12-03 20:17:20', 1),
(13, 1, 1, '43289465', 'DAYSY BELGICA PEREIRA LOPEZ', '982525851', 1, 2, '43289465', '43289465', '', '2024-12-03 20:18:52', 1),
(14, 1, 1, '42817048', 'MARIA ELENA TITO QUISPE', '984034603', 1, 2, '42817048', '42817048', '', '2024-12-03 20:20:32', 1),
(15, 1, 1, '40908831', 'WUENDY KAREN CARDENAS MATOS', '993436180', 1, 2, '40908831', '40908831', '', '2024-12-03 20:25:54', 1),
(16, 3, 1, '10154401', 'MARGOT JULIANA GARCIA ALVARADO', '993983970', 1, 3, '10154401', '10154401', '', '2024-12-10 19:51:02', 1),
(17, 1, 1, '44372303', 'ELENA YSABEL TITO LUQUE', '991060291', 1, 2, '44372303', '44372303', '', '2024-12-12 15:14:12', 1),
(18, 1, 1, '46340294', 'CARMEN PEREA ALVAREZ', '997179976', 1, 2, '46340294', '46340294', '', '2024-12-12 18:36:09', 1),
(19, 1, 1, '44345419', 'SUSANA VICTORIA RIVAS CORTEZ', '997838185', 1, 2, '44345419', '44345419', '', '2024-12-13 17:07:40', 1),
(20, 2, 1, '40865109', 'RUBEN SALVADOR MARENGO', '981959676', 2, 1, '40865109', '40865109', '', '2024-12-13 18:49:22', 1),
(21, 1, 1, '75539860', 'KATIA NORCELIA FUENTES CHAVEZ', '901931165', 1, 2, '75539860', '75539860', '', '2024-12-14 17:47:38', 1),
(22, 1, 1, '41102080', 'MARIA ADELINDA MESTANZA SUAREZ', '990477169', 1, 2, '41102080', '41102080', '', '2024-12-15 20:41:28', 1),
(23, 1, 1, '41281051', 'MARIA DE LOS ANGELES CARHUAS YJUMA', '932262539', 1, 1, '41281051', '41281051', '', '2024-12-16 14:02:35', 1),
(24, 1, 1, '46936573', 'LISETH KATHERINE PALACIOS BERMUDEZ', '977164577', 1, 2, '46936573', '46936573', '', '2024-12-19 19:02:35', 1),
(25, 1, 1, '43733426', 'BEATRIZ VERONICA CRUZ MESTANZA', '982868532', 1, 2, '43733426', '43733426', '', '2024-12-20 16:34:44', 1),
(26, 3, 1, '10509059', 'CECILIA ROSARIO MANRIQUE LOPEZ', '976300448', 1, 2, '10509059', '10509059', '', '2025-01-02 15:44:41', 1),
(27, 1, 1, '19039037', 'AMERICA ISABEL ROLDAN MORENO', '995798625', 1, 2, '19039037', '19039037', '', '2025-01-02 21:01:50', 1),
(28, 1, 1, '72237242', 'YULISA URBINA TITO', '988583183', 1, 1, '72237242', '72237242', '', '2025-01-06 14:22:09', 1),
(29, 1, 1, '45631340', 'SUSY VARGAS OBREGON', '906475503', 1, 1, '45631340', '45631340', '', '2025-01-06 15:59:19', 1),
(30, 1, 1, '43184714', 'YURITSA ANTONIA GONZALES ALMIDON', '955188598', 1, 2, '43184714', '43184714', '', '2025-01-06 16:57:21', 1),
(31, 1, 1, '75679145', 'KIMBERLY NAYELLI HUAIRA PADILLA', '936065049', 1, 1, '75679145', '75679145', '', '2025-01-07 14:49:42', 1),
(32, 1, 1, '40477767', 'AGAPITA BASILIA TORRES FELIPE', '971636093', 1, 1, '40477767', '40477767', '', '2025-01-07 16:26:58', 1),
(33, 1, 1, '41478915', 'DORIS TORIBIO DOMINGUEZ', '924609727', 1, 2, '41478915', '41478915', '', '2025-01-08 21:13:07', 1),
(34, 1, 1, '43303791', 'MARITZA TORIBIO DOMINGUEZ', '916391565', 1, 2, '43303791', '43303791', '', '2025-01-08 21:18:04', 1),
(35, 1, 1, '45977821', 'ERLINDA MARIBEL VALDIVIA LOPEZ', '945535265', 1, 1, '45977821', '45977821', '', '2025-01-08 21:21:40', 1),
(36, 1, 1, '10508169', 'GENOVEVA TORIBIO DOMINGUEZ', '930502729', 1, 1, '10508169', '10508169', '', '2025-01-08 21:25:19', 1),
(37, 2, 1, '07150535', 'TEOFANES ONOFRE FLORES DIAZ', '931300936', 2, 2, '07150535', '07150535', 'RECOMENDADA DE LA MAMA DE PARI\r\nDATOS DE LA MAMA:\r\nDNI: 45351376 - FIORELLA SHUPINGAHUA RIOS\r\nTELF: 916507178', '2025-01-09 20:08:25', 1),
(38, 1, 1, '44235581', 'SUSY GABRIELA TORRES CAMPOS', '947309583', 1, 1, '44235581', '44235581', '', '2025-01-15 21:26:39', 0),
(39, 1, 1, '46232427', 'NERY MENDOZA RAFAEL', '983617310', 1, 1, '46232427', '46232427', '', '2025-01-16 14:20:11', 1),
(40, 1, 1, '48085420', 'LIGUIA ELENA MENDO JUAPE', '904554626', 1, 2, '48085420', '48085420', '', '2025-01-21 17:51:37', 1),
(41, 1, 1, '70564641', 'EVELYN SELENE ALVA MORI', '943366891', 1, 1, '70564641', '70564641', '', '2025-01-22 16:34:17', 1),
(42, 1, 1, '10509263', 'NORMA ISABEL VARGAS AGUILAR', '985299748', 1, 2, '10509263', '10509263', '', '2025-01-23 04:50:44', 1),
(43, 1, 1, '10164574', 'BENERALDA MENDO CARRILLO DE CARRILLO', '951786144', 1, 2, '10164574', '10164574', '', '2025-01-23 15:31:10', 1),
(44, 1, 1, '42907308', 'MIRYAM PICON PERLA', '927902695', 1, 2, '42907308', '42907308', '', '2025-01-27 18:28:25', 1),
(45, 1, 1, '09908665', 'JUDITH LIDIA SOSA RAMIREZ', '933696493', 1, 1, '09908665', '09908665', '', '2025-01-27 20:44:28', 1),
(46, 1, 1, '62602786', 'RUDDY MADELEY RODRIGUEZ MALPARTIDA', '968478290', 1, 1, '62602786', '62602786', '', '2025-01-28 19:49:11', 1),
(47, 1, 1, '41812264', 'MARILYN PAOLA MEZA VELAZCO', '967535724', 1, 1, '41812264', '41812264', '', '2025-01-30 16:15:23', 1),
(49, 1, 1, '44235581', 'SUSY GABRIELA TORRES CAMPOS', '947309583', 1, 1, '44235581', '44235581', '', '2025-02-04 15:24:05', 1),
(50, 1, 1, '09911363', 'VERONICA VICTORIA HUAMANI RAMOS', '902742180', 1, 1, '09911363', '09911363', '', '2025-02-04 19:44:52', 1),
(51, 1, 1, '16023830', 'ROSARIO ELIZABETH HUERTA PALACIOS DE BLAS', '934293947', 1, 2, '16023830', '16023830', '942017596 agregar tambien este numero', '2025-02-06 14:43:33', 1),
(52, 1, 1, '48624260', 'YAHAIRA NINOSHKA HUAMAN ROJAS', '955372719', 1, 1, '48624260', '48624260', '', '2025-02-06 17:43:00', 1),
(53, 1, 1, '46673942', 'KRSNA SOSA HUAMANÑAHUI', '936307966', 1, 2, '46673942', '46673942', '', '2025-02-07 15:01:28', 1),
(54, 1, 1, '32737459', 'EDITH MARGARITA PULIDO TORRES', '997623072', 1, 2, '32737459', '32737459', '', '2025-02-07 15:30:52', 1),
(55, 1, 1, '44173933', 'LADY YANET CASO HIDALGO', '934645705', 1, 1, '44173933', '44173933', '', '2025-02-10 19:34:59', 1),
(56, 1, 1, '42252862', 'YANET GAVILAN CCATAMAYO', '967464662', 1, 1, '42252862', '42252862', '', '2025-02-13 16:47:41', 1),
(57, 1, 1, '', '', '', 1, 1, '', '', '', '2025-02-13 16:48:42', 0),
(58, 1, 1, '70430072', 'MURIEL CINDY INCHICAQUI SOLIS', '903460994', 1, 1, '70430072', '70430072', '', '2025-02-13 17:47:24', 1),
(59, 1, 1, '10863475', 'SUSANA LORENA DIAZ ÑIQUE', '930709815', 1, 1, '10863475', '10863475', '', '2025-02-13 18:58:30', 1),
(60, 1, 1, '48173344', 'KATHERINE BRISETH RIVEROS ACOSTA', '922407452', 1, 1, '48173344', '48173344', '', '2025-02-17 17:15:58', 1),
(61, 1, 1, '71386363', 'ALEXANDRA PERAMAS PUELLES', '943446491', 1, 2, '71386363', '71386363', '', '2025-02-18 15:43:45', 1),
(62, 1, 1, '74693070', 'ANGIE YANIL GARCIA RODRIGUEZ', '997506639', 1, 1, '74693070', '74693070', '', '2025-02-21 16:04:38', 1),
(63, 1, 1, '90484754', 'IRMA YANETH MONTES RAMIREZ', '930599508', 1, 1, '90484754', '90484754', '', '2025-02-21 19:41:49', 1),
(64, 1, 1, '74834333', 'ANGIE FIORELLA GARCIA RAMOS', '927335199', 1, 1, '74834333', '74834333', '', '2025-02-24 17:39:23', 1),
(65, 1, 1, '44636399', 'ROSA JOHANA MINA REYES', '924810456', 1, 1, '44636399', '44636399', '', '2025-02-25 16:28:17', 1),
(66, 1, 1, '48207815', 'LIZ LORILEIT BOBADILLA MALQUI', '922655675', 1, 1, '48207815', '48207815', '', '2025-02-25 17:07:08', 1),
(67, 1, 1, '42073463', 'IRIS BOBADILLA MALQUI', '946046046', 1, 1, '42073463', '42073463', '', '2025-02-25 17:12:05', 1),
(68, 1, 3, '004543556', 'HAYDELYS FELICIDAD ECHARRY SANCHEZ', '941021071', 1, 1, '004543556', '004543556', '', '2025-02-26 16:05:38', 1),
(69, 1, 1, '48624260', 'YAHAIRA NINOSHKA HUAMAN ROJAS', '955372719', 1, 1, '48624260', '48624260', '', '2025-02-26 16:36:56', 0),
(70, 1, 1, '43046327', 'MIRIAM MARIBEL PALOMINO COSTILLA', '934413015', 1, 1, '43046327', '43046327', '', '2025-02-28 17:27:56', 1),
(71, 1, 1, '42695489', 'MARUJA FLOR LOPEZ RAQUI', '997880608', 1, 1, '42695489', '42695489', '', '2025-02-28 19:34:16', 1),
(72, 1, 1, '44617909', 'JESSICA RAQUEL SAYAVERDE YLLATUPA', '992973469', 1, 1, '44617909', '44617909', '', '2025-02-28 20:52:52', 1),
(73, 1, 1, '72979729', 'JACKELIN LISSET TRUJILLO HURTADO', '914012987', 1, 1, '72979729', '72979729', '', '2025-03-03 13:43:41', 1),
(74, 1, 1, '46304825', 'MARIBEL ROSARIO HUAMANI DE LOS SANTOS', '958233860', 1, 1, '46304825', '46304825', '', '2025-03-03 13:59:57', 1),
(75, 1, 1, '77477915', 'HILARI MIRIAM REYES PEREA', '997830311', 1, 1, '77477915', '77477915', '', '2025-03-03 15:08:28', 1),
(76, 1, 1, '43942807', 'NOEMI SANDRA VARGAS LOAYZA', '954780664', 1, 1, '43942807', '43942807', '', '2025-03-05 16:27:26', 1),
(77, 1, 1, '10863475', 'SUSANA LORENA DIAZ ÑIQUE', '930709815', 1, 1, '10863475', '10863475', '', '2025-03-05 17:02:25', 1),
(78, 1, 1, '42102415', 'DANISSE GIANCARLA SANCHEZ CORNEJO', '982750957', 1, 1, '42102415', '42102415', '', '2025-03-05 17:19:54', 1),
(79, 2, 1, '40368880', 'JAIME ROLANDO MAYTA CAJA', '980557979', 2, 1, '40368880', '40368880', '', '2025-03-05 19:35:12', 1),
(80, 1, 1, '71328454', 'PATRICIA MILENE ATANACIO ZAMBRANO', '957087824', 1, 1, '71328454', '71328454', '', '2025-03-06 16:47:58', 1);

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
(1, 1, '73937543', 'MARCO ANTONIO MANRIQUE VARILLAS', '1999-06-18', 1, 2, 'PROLONG. LAS GLADIOLAS MZ.X LT.12 EL ERMITAÑO', '994947452', 'MMANRIQUEVARILLAS99@GMAIL.COM', 2, 2, '2025-01-01', '2025-12-31', '0.00', '19101118530027', '00219110111853002750', '', '', '', '73937543', '73937543', '', '2024-11-24 05:52:35', 1),
(2, 1, '10509059', 'CECILIA ROSARIO MANRIQUE LOPEZ', '1977-01-16', 2, 1, 'PROLONG. LAS GLADIOLAS MZ.X LT.12 EL ERMITAÑO', '976300448', '', 1, 1, '2025-01-01', '2025-12-31', '0.00', '', '', '', '', '', '10509059', '10509059', '', '2025-01-06 20:37:42', 1),
(3, 1, '71850167', 'EMELY LIZBETH INNA GALVEZ VALDEZ', '2001-03-03', 1, 1, 'JR. LOS NARANJOS 121 PISO 3 URB. VALDIVIEZO', '940734838', 'EMELYGV331@GMAIL.COM', 3, 2, '2025-03-01', '2025-12-31', '0.00', '', '', '', '', '', '71850167', '71850167', '', '2025-01-25 19:33:12', 1),
(4, 1, '71326581', 'TIFFANY YAMILE PASTOR MANZUR', '1999-12-31', 1, 1, '', '', '', 3, 1, '2025-03-01', '2025-12-31', '0.00', '19101457878002', '', '', '', '', '71326581', '71326581', '', '2025-02-28 21:20:40', 1);

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
(2, 'PASAPORTE', '', '2024-11-24 05:49:35', 1),
(3, 'CE', '', '2025-02-26 15:55:56', 1);

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
-- Estructura de tabla para la tabla `usuario_menu`
--

CREATE TABLE `usuario_menu` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `link` varchar(255) NOT NULL,
  `icono` varchar(100) NOT NULL,
  `descripcion` text,
  `fechacreado` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` tinyint(1) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario_menu`
--

INSERT INTO `usuario_menu` (`id`, `nombre`, `link`, `icono`, `descripcion`, `fechacreado`, `estado`) VALUES
(1, 'INICIO', '../../Inicio/Vista/Escritorio.php', '', '', '2025-01-30 01:32:55', 1),
(2, 'USUARIO', '../../Usuario/Vista/Escritorio.php', '', '', '2025-01-30 01:34:31', 1),
(3, 'INSTITUCION', '../../Institucion/Vista/Escritorio.php', '', '', '2025-01-30 01:34:49', 1),
(4, 'MATRICULA', '../../Matricula/Vista/Escritorio.php', '', '', '2025-01-30 01:35:06', 1),
(5, 'MENSUALIDAD', '../../Mensualidad/Vista/Escritorio.php', '', '', '2025-01-30 01:35:29', 1),
(6, 'DOCUMENTO', '../../Documento/Vista/Escritorio.php', '', '', '2025-01-30 01:35:46', 1),
(7, 'ALMACEN', '../../Almacen/Vista/Escritorio.php', '', '', '2025-01-30 01:36:59', 1),
(8, 'BIBLIOTECA', '../../Biblioteca/Vista/Escritorio.php', '', '', '2025-01-30 01:37:17', 1),
(9, 'REGISTRO', '../../Registro/Vista/Escritorio.php', '', '', '2025-03-06 06:19:14', 1);

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
(2, 'RECIBO X HON.', '', '2024-11-24 05:51:32', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacen_categoria`
--
ALTER TABLE `almacen_categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `almacen_comprobante`
--
ALTER TABLE `almacen_comprobante`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `almacen_ingreso`
--
ALTER TABLE `almacen_ingreso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_apoderado_id` (`usuario_apoderado_id`),
  ADD KEY `almacen_comprobante_id` (`almacen_comprobante_id`),
  ADD KEY `almacen_metodo_pago_id` (`almacen_metodo_pago_id`);

--
-- Indices de la tabla `almacen_ingreso_detalle`
--
ALTER TABLE `almacen_ingreso_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `almacen_ingreso_id` (`almacen_ingreso_id`),
  ADD KEY `almacen_producto_id` (`almacen_producto_id`);

--
-- Indices de la tabla `almacen_metodo_pago`
--
ALTER TABLE `almacen_metodo_pago`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `almacen_producto`
--
ALTER TABLE `almacen_producto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `almacen_salida`
--
ALTER TABLE `almacen_salida`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_apoderado_id` (`usuario_apoderado_id`),
  ADD KEY `almacen_comprobante_id` (`almacen_comprobante_id`),
  ADD KEY `almacen_metodo_pago_id` (`almacen_metodo_pago_id`);

--
-- Indices de la tabla `almacen_salida_detalle`
--
ALTER TABLE `almacen_salida_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `almacen_salida_id` (`almacen_salida_id`),
  ADD KEY `almacen_producto_id` (`almacen_producto_id`);

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
-- Indices de la tabla `usuario_menu`
--
ALTER TABLE `usuario_menu`
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
-- AUTO_INCREMENT de la tabla `almacen_categoria`
--
ALTER TABLE `almacen_categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `almacen_comprobante`
--
ALTER TABLE `almacen_comprobante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `almacen_ingreso`
--
ALTER TABLE `almacen_ingreso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `almacen_ingreso_detalle`
--
ALTER TABLE `almacen_ingreso_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT de la tabla `almacen_metodo_pago`
--
ALTER TABLE `almacen_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `almacen_producto`
--
ALTER TABLE `almacen_producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT de la tabla `almacen_salida`
--
ALTER TABLE `almacen_salida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT de la tabla `almacen_salida_detalle`
--
ALTER TABLE `almacen_salida_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT de la tabla `documento`
--
ALTER TABLE `documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `documento_detalle`
--
ALTER TABLE `documento_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `matricula_metodo_pago`
--
ALTER TABLE `matricula_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `matricula_pago`
--
ALTER TABLE `matricula_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `mensualidad_detalle`
--
ALTER TABLE `mensualidad_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=664;

--
-- AUTO_INCREMENT de la tabla `mensualidad_mes`
--
ALTER TABLE `mensualidad_mes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuario_alumno`
--
ALTER TABLE `usuario_alumno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `usuario_apoderado`
--
ALTER TABLE `usuario_apoderado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuario_documento`
--
ALTER TABLE `usuario_documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario_estado_civil`
--
ALTER TABLE `usuario_estado_civil`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuario_menu`
--
ALTER TABLE `usuario_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

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
-- Filtros para la tabla `almacen_ingreso`
--
ALTER TABLE `almacen_ingreso`
  ADD CONSTRAINT `almacen_ingreso_ibfk_1` FOREIGN KEY (`usuario_apoderado_id`) REFERENCES `usuario_apoderado` (`id`),
  ADD CONSTRAINT `almacen_ingreso_ibfk_2` FOREIGN KEY (`almacen_comprobante_id`) REFERENCES `almacen_comprobante` (`id`),
  ADD CONSTRAINT `almacen_ingreso_ibfk_3` FOREIGN KEY (`almacen_metodo_pago_id`) REFERENCES `almacen_metodo_pago` (`id`);

--
-- Filtros para la tabla `almacen_ingreso_detalle`
--
ALTER TABLE `almacen_ingreso_detalle`
  ADD CONSTRAINT `almacen_ingreso_detalle_ibfk_1` FOREIGN KEY (`almacen_ingreso_id`) REFERENCES `almacen_ingreso` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `almacen_ingreso_detalle_ibfk_2` FOREIGN KEY (`almacen_producto_id`) REFERENCES `almacen_producto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `almacen_producto`
--
ALTER TABLE `almacen_producto`
  ADD CONSTRAINT `almacen_producto_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `almacen_categoria` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `almacen_salida`
--
ALTER TABLE `almacen_salida`
  ADD CONSTRAINT `almacen_salida_ibfk_1` FOREIGN KEY (`usuario_apoderado_id`) REFERENCES `usuario_apoderado` (`id`),
  ADD CONSTRAINT `almacen_salida_ibfk_2` FOREIGN KEY (`almacen_comprobante_id`) REFERENCES `almacen_comprobante` (`id`),
  ADD CONSTRAINT `almacen_salida_ibfk_3` FOREIGN KEY (`almacen_metodo_pago_id`) REFERENCES `almacen_metodo_pago` (`id`);

--
-- Filtros para la tabla `almacen_salida_detalle`
--
ALTER TABLE `almacen_salida_detalle`
  ADD CONSTRAINT `almacen_salida_detalle_ibfk_1` FOREIGN KEY (`almacen_salida_id`) REFERENCES `almacen_salida` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `almacen_salida_detalle_ibfk_2` FOREIGN KEY (`almacen_producto_id`) REFERENCES `almacen_producto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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
