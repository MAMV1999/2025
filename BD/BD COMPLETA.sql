-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-01-2025 a las 23:47:38
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
(2, 'PRENDAS DE VESTIR', '', '2025-01-02 17:51:12', 1);

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
(1, 26, 1, '000001', '2025-01-02', 7, '0.00', '', '2025-01-02 10:55:32', 1);

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
(3, 1, 2, 10, '0.00', '');

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
(2, 'CONSTANCIA DE NO ADEUDO', '', 1, '0.00', '10.00', 5, '2024-12-27 03:42:56', 1),
(3, 'CONSTANCIA DE MATRICULA', '', 1, '0.00', '10.00', 4, '2024-12-27 03:48:08', 1),
(4, 'CERTIFICADO DE ESTUDIOS', '', 1, '0.00', '80.00', 5, '2024-12-27 03:48:33', 1),
(5, 'BUZO NUEVO TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(6, 'BUZO NUEVO TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(7, 'BUZO NUEVO TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(8, 'BUZO NUEVO TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(9, 'BUZO NUEVO TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(10, 'BUZO NUEVO TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(11, 'BUZO NUEVO TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(12, 'BUZO NUEVO TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(13, 'BUZO NUEVO TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(14, 'BUZO NUEVO TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(15, 'BUZO ANTIGUO TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(16, 'BUZO ANTIGUO TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(17, 'BUZO ANTIGUO TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(18, 'BUZO ANTIGUO TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(19, 'BUZO ANTIGUO TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(20, 'BUZO ANTIGUO TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(21, 'BUZO ANTIGUO TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(22, 'BUZO ANTIGUO TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(23, 'BUZO ANTIGUO TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(24, 'BUZO ANTIGUO TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(25, 'POLO BLANCO INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(26, 'POLO BLANCO INICIAL TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(27, 'POLO BLANCO INICIAL TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(28, 'POLO BLANCO INICIAL TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(29, 'POLO BLANCO INICIAL TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(30, 'POLO BLANCO INICIAL TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(31, 'POLO BLANCO INICIAL TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(32, 'POLO BLANCO INICIAL TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(33, 'POLO BLANCO INICIAL TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(34, 'POLO BLANCO INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(35, 'POLO PLOMO INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(36, 'POLO PLOMO INICIAL TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(37, 'POLO PLOMO INICIAL TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(38, 'POLO PLOMO INICIAL TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(39, 'POLO PLOMO INICIAL TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(40, 'POLO PLOMO INICIAL TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(41, 'POLO PLOMO INICIAL TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(42, 'POLO PLOMO INICIAL TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(43, 'POLO PLOMO INICIAL TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(44, 'POLO PLOMO INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(45, 'POLO PLOMO MANGA LARGA INICIAL TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(46, 'POLO PLOMO MANGA LARGA INICIAL TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(47, 'POLO PLOMO MANGA LARGA INICIAL TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(48, 'POLO PLOMO MANGA LARGA INICIAL TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(49, 'POLO PLOMO MANGA LARGA INICIAL TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(50, 'POLO PLOMO MANGA LARGA INICIAL TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(51, 'POLO PLOMO MANGA LARGA INICIAL TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(52, 'POLO PLOMO MANGA LARGA INICIAL TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(53, 'POLO PLOMO MANGA LARGA INICIAL TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(54, 'POLO PLOMO MANGA LARGA INICIAL TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(55, 'POLO BLANCO PRIMARIA TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(56, 'POLO BLANCO PRIMARIA TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(57, 'POLO BLANCO PRIMARIA TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(58, 'POLO BLANCO PRIMARIA TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(59, 'POLO BLANCO PRIMARIA TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(60, 'POLO BLANCO PRIMARIA TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(61, 'POLO BLANCO PRIMARIA TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(62, 'POLO BLANCO PRIMARIA TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(63, 'POLO BLANCO PRIMARIA TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(64, 'POLO BLANCO PRIMARIA TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(65, 'POLO PLOMO PRIMARIA TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(66, 'POLO PLOMO PRIMARIA TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(67, 'POLO PLOMO PRIMARIA TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(68, 'POLO PLOMO PRIMARIA TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(69, 'POLO PLOMO PRIMARIA TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(70, 'POLO PLOMO PRIMARIA TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(71, 'POLO PLOMO PRIMARIA TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(72, 'POLO PLOMO PRIMARIA TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(73, 'POLO PLOMO PRIMARIA TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(74, 'POLO PLOMO PRIMARIA TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(75, 'SHORT TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(76, 'SHORT TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(77, 'SHORT TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(78, 'SHORT TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(79, 'SHORT TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(80, 'SHORT TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(81, 'SHORT TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(82, 'SHORT TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(83, 'SHORT TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(84, 'SHORT TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(85, 'FALDA SHORT TALLA 2', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(86, 'FALDA SHORT TALLA 4', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(87, 'FALDA SHORT TALLA 6', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(88, 'FALDA SHORT TALLA 8', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(89, 'FALDA SHORT TALLA 10', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(90, 'FALDA SHORT TALLA 12', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(91, 'FALDA SHORT TALLA 14', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(92, 'FALDA SHORT TALLA 16', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(93, 'FALDA SHORT TALLA S', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1),
(94, 'FALDA SHORT TALLA M', '', 2, '0.00', '0.00', 0, '2025-01-02 18:00:28', 1);

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
(1, 23, 1, '000001', '2025-01-02', 2, '10.00', '', '2025-01-02 15:35:29', 1),
(2, 27, 1, '000002', '2025-01-02', 1, '100.00', 'SOLO FALTA CERTIFICADO DE ESTUDIOS', '2025-01-02 16:03:10', 1),
(3, 29, 1, '000003', '2025-01-06', 2, '100.00', 'PENDIENTE ENTREGA DE TODOS LOS DOCUMENTOS', '2025-01-06 10:59:43', 1),
(4, 28, 1, '000004', '2025-01-07', 3, '100.00', 'PENDIENTE ENTREGA DE TODOS LOS DOCUMENTOS', '2025-01-07 10:59:24', 1),
(5, 32, 1, '000005', '2025-01-07', 1, '100.00', 'PENDIENTE ENTREGA DE TODOS LOS DOCUMENTOS', '2025-01-07 11:27:44', 1),
(6, 30, 1, '000006', '2025-01-07', 2, '100.00', 'PENDIENTE ENTREGA DE TODOS LOS DOCUMENTOS', '2025-01-07 12:18:10', 1);

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
(16, 6, 2, 1, '10.00', '');

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
(11, 32, 11, 1, '', '2025-01-06 16:59:27', 1);

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
(1, 1, 1, '220.00', '280.00', '25.00', 20, '', '2024-11-24 06:09:41', 1),
(2, 2, 1, '220.00', '280.00', '25.00', 20, '', '2024-11-24 06:13:01', 1),
(3, 3, 1, '220.00', '290.00', '25.00', 20, '', '2024-11-24 06:13:27', 1),
(4, 4, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:13:45', 1),
(5, 5, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:14:19', 1),
(6, 6, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:14:49', 1),
(7, 7, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:11', 1),
(8, 8, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:29', 1),
(9, 9, 1, '220.00', '310.00', '25.00', 18, '', '2024-11-24 06:15:44', 1);

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
(37, 'MATRICULA 2025 - 09/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', 1, 2, NULL, 37, 37, '', '2025-01-09 20:08:25', 1);

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
(7, 7, '000004', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 6 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 15:52:48', 1),
(8, 8, '000005', '2024-12-03', 'MATRICULA 2025 - 03/12/2024\r\nNIVEL: PRIMARIA - GRADO: 3 GRADO - SECCION: A\r\n\r\nPrecio Matricula: S./200.00\r\nPrecio Mensualidad: S./300.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones: Los alumnos que ratifiquen su matrícula, HACIENDO EL PAGO COMPLETO HASTA EL 15 DE DICIEMBRE. Pagaran 200 SOLES en la matricula y descuento de 10 SOLES en la mensualidad.', '0.00', 5, '', '2024-12-03 15:54:19', 1),
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
(37, 37, '000033', '2025-01-09', 'MATRICULA 2025 - 09/01/2025\r\nNIVEL: INICIAL - GRADO: 3 AÑOS - SECCION: A\r\n\r\nPrecio Matricula: S./220.00\r\nPrecio Mensualidad: S./280.00\r\nPrecio Mantenimiento: S./25.00\r\n\r\nObservaciones:', '220.00', 1, '', '2025-01-09 20:08:25', 1);

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
(34, 1, 7, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-03 15:52:48', 1),
(35, 2, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(36, 3, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(37, 4, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(38, 5, 7, '315.00', 0, '', '2024-12-03 15:52:48', 1),
(39, 6, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(40, 7, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(41, 8, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(42, 9, 7, '290.00', 0, '', '2024-12-03 15:52:48', 1),
(43, 10, 7, '315.00', 0, '', '2024-12-03 15:52:48', 1),
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
(54, 1, 9, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-03 19:26:44', 1),
(55, 2, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(56, 3, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(57, 4, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(58, 5, 9, '315.00', 0, '', '2024-12-03 19:26:44', 1),
(59, 6, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(60, 7, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(61, 8, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(62, 9, 9, '290.00', 0, '', '2024-12-03 19:26:44', 1),
(63, 10, 9, '315.00', 0, '', '2024-12-03 19:26:44', 1),
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
(153, 10, 18, '325.00', 0, '', '2024-12-10 19:51:02', 1),
(154, 1, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(155, 2, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(156, 3, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(157, 4, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(158, 5, 19, '325.00', 0, '', '2024-12-12 15:14:12', 1),
(159, 6, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(160, 7, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(161, 8, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(162, 9, 19, '300.00', 0, '', '2024-12-12 15:14:12', 1),
(163, 10, 19, '325.00', 0, '', '2024-12-12 15:14:12', 1),
(164, 1, 20, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-12 15:16:37', 1),
(165, 2, 20, '290.00', 0, '', '2024-12-12 15:16:37', 1),
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
(204, 1, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(205, 2, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(206, 3, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(207, 4, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(208, 5, 24, '325.00', 0, '', '2024-12-13 18:49:22', 1),
(209, 6, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(210, 7, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(211, 8, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(212, 9, 24, '300.00', 0, '', '2024-12-13 18:49:22', 1),
(213, 10, 24, '325.00', 0, '', '2024-12-13 18:49:22', 1),
(214, 1, 25, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-13 18:52:10', 1),
(215, 2, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(216, 3, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(217, 4, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(218, 5, 25, '315.00', 0, '', '2024-12-13 18:52:10', 1),
(219, 6, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(220, 7, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(221, 8, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(222, 9, 25, '290.00', 0, '', '2024-12-13 18:52:10', 1),
(223, 10, 25, '315.00', 0, '', '2024-12-13 18:52:10', 1),
(224, 1, 26, '300.00', 0, '', '2024-12-14 17:47:38', 1),
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
(244, 1, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(245, 2, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(246, 3, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(247, 4, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(248, 5, 28, '325.00', 0, '', '2024-12-16 14:02:35', 1),
(249, 6, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(250, 7, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(251, 8, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(252, 9, 28, '300.00', 0, '', '2024-12-16 14:02:35', 1),
(253, 10, 28, '325.00', 0, '', '2024-12-16 14:02:35', 1),
(254, 1, 29, '290.00', 0, 'DSCTO. HERMANO -10 SOLES', '2024-12-16 14:03:16', 1),
(255, 2, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(256, 3, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(257, 4, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(258, 5, 29, '315.00', 0, '', '2024-12-16 14:03:16', 1),
(259, 6, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(260, 7, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(261, 8, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(262, 9, 29, '290.00', 0, '', '2024-12-16 14:03:16', 1),
(263, 10, 29, '315.00', 0, '', '2024-12-16 14:03:16', 1),
(264, 1, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(265, 2, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(266, 3, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(267, 4, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(268, 5, 30, '325.00', 0, '', '2024-12-19 19:02:36', 1),
(269, 6, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(270, 7, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(271, 8, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(272, 9, 30, '300.00', 0, '', '2024-12-19 19:02:36', 1),
(273, 10, 30, '325.00', 0, '', '2024-12-19 19:02:36', 1),
(274, 1, 31, '300.00', 0, '', '2024-12-20 16:34:44', 1),
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
(314, 1, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(315, 2, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(316, 3, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(317, 4, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(318, 5, 35, '325.00', 0, '', '2025-01-08 21:21:40', 1),
(319, 6, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(320, 7, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(321, 8, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(322, 9, 35, '300.00', 0, '', '2025-01-08 21:21:40', 1),
(323, 10, 35, '325.00', 0, '', '2025-01-08 21:21:40', 1),
(324, 1, 36, '300.00', 0, '', '2025-01-08 21:25:19', 1),
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
(343, 10, 37, '305.00', 0, '', '2025-01-09 20:08:25', 1);

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
(37, 37, 1, '92821407', 'FLORES SHUPINGAHUA LUCIA SOFIA AURELIA', '2022-09-28', '', 1, '92821407', '92821407', '', '2025-01-09 20:08:25', 1);

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
(37, 2, 1, '07150535', 'TEOFANES ONOFRE FLORES DIAZ', '931300936', 2, 2, '07150535', '07150535', '', '2025-01-09 20:08:25', 1);

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
(1, 1, '73937543', 'MARCO ANTONIO MANRIQUE VARILLAS', '1999-06-18', 1, 2, 'PROLONG. LAS GLADIOLAS MZ.X LT.12 EL ERMITAÑO', '994947452', 'MMANRIQUEVARILLAS99@GMAIL.COM', 2, 1, '0000-00-00', '0000-00-00', '0.00', '', '', '', '', '', '73937543', '73937543', '', '2024-11-24 05:52:35', 1),
(2, 1, '10509059', 'CECILIA ROSARIO MANRIQUE LOPEZ', '0000-00-00', 1, 1, '', '976300448', '', 1, 1, '0000-00-00', '0000-00-00', '0.00', '', '', '', '', '', '10509059', '10509059', '', '2025-01-06 20:37:42', 1);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `almacen_comprobante`
--
ALTER TABLE `almacen_comprobante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `almacen_ingreso`
--
ALTER TABLE `almacen_ingreso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `almacen_ingreso_detalle`
--
ALTER TABLE `almacen_ingreso_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `almacen_metodo_pago`
--
ALTER TABLE `almacen_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `almacen_producto`
--
ALTER TABLE `almacen_producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT de la tabla `almacen_salida`
--
ALTER TABLE `almacen_salida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `almacen_salida_detalle`
--
ALTER TABLE `almacen_salida_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `documento`
--
ALTER TABLE `documento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `documento_detalle`
--
ALTER TABLE `documento_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `matricula_metodo_pago`
--
ALTER TABLE `matricula_metodo_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `matricula_pago`
--
ALTER TABLE `matricula_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `mensualidad_detalle`
--
ALTER TABLE `mensualidad_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=344;

--
-- AUTO_INCREMENT de la tabla `mensualidad_mes`
--
ALTER TABLE `mensualidad_mes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuario_alumno`
--
ALTER TABLE `usuario_alumno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `usuario_apoderado`
--
ALTER TABLE `usuario_apoderado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
