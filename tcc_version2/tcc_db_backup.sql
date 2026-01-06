-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-01-2026 a las 01:26:07
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tcc_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_respuestas`
--

CREATE TABLE `detalle_respuestas` (
  `id_detalle` int(11) NOT NULL,
  `ru_id` int(11) NOT NULL,
  `preguntas_id` int(11) NOT NULL,
  `or_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dimensiones_fs`
--

CREATE TABLE `dimensiones_fs` (
  `id_dimension` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `dimensiones_fs`
--

INSERT INTO `dimensiones_fs` (`id_dimension`, `nombre`, `descripcion`, `codigo`) VALUES
(1, 'Activo–Reflexivo', 'Preferencia entre aprendizaje activo o reflexivo', 'AR'),
(2, 'Visual–Verbal', 'Preferencia entre imágenes o palabras', 'VV'),
(3, 'Secuencial–Global', 'Preferencia entre paso a paso o visión general', 'SG'),
(4, 'Sensorial-Intuitivo', 'Preferencia entre lo concreto y lo abstracto', 'SI');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estilos_aprendizaje`
--

CREATE TABLE `estilos_aprendizaje` (
  `id_ea` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `estilos_aprendizaje`
--

INSERT INTO `estilos_aprendizaje` (`id_ea`, `nombre`, `descripcion`, `dimensiones_id`) VALUES
(1, 'Activo–Reflexivo', 'Dimensión que evalúa si el estudiante prefiere la acción o la reflexión al aprender.', NULL),
(2, 'Sensorial–Intuitivo', 'Dimensión que evalúa si el estudiante prefiere datos concretos o conceptos abstractos.', NULL),
(3, 'Visual–Verbal', 'Dimensión que evalúa si el estudiante prefiere representaciones visuales o información verbal.', NULL),
(4, 'Secuencial–Global', 'Dimensión que evalúa si el estudiante aprende mejor paso a paso o viendo la visión general primero.', NULL),
(5, 'Activo–Reflexivo', 'Dimensión que evalúa si el estudiante prefiere la acción o la reflexión al aprender.', NULL),
(6, 'Sensorial–Intuitivo', 'Dimensión que evalúa si el estudiante prefiere datos concretos o conceptos abstractos.', NULL),
(7, 'Visual–Verbal', 'Dimensión que evalúa si el estudiante prefiere representaciones visuales o información verbal.', NULL),
(8, 'Secuencial–Global', 'Dimensión que evalúa si el estudiante aprende mejor paso a paso o viendo la visión general primero.', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mapeo_pregunta_dimension`
--

CREATE TABLE `mapeo_pregunta_dimension` (
  `id_mpd` int(11) NOT NULL,
  `preguntas_id` int(11) DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL,
  `polo_a_label` varchar(45) DEFAULT NULL,
  `polo_b_label` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `mapeo_pregunta_dimension`
--

INSERT INTO `mapeo_pregunta_dimension` (`id_mpd`, `preguntas_id`, `dimensiones_id`, `polo_a_label`, `polo_b_label`) VALUES
(10, 1, 1, 'Activo', 'Reflexivo'),
(11, 2, 2, 'Visual', 'Verbal'),
(12, 3, 3, 'Secuencial', 'Global'),
(13, 4, 4, 'Sensorial', 'Intuitivo'),
(14, 5, 1, 'Activo', 'Reflexivo'),
(15, 6, 2, 'Visual', 'Verbal'),
(16, 7, 3, 'Secuencial', 'Global'),
(17, 8, 4, 'Sensorial', 'Intuitivo'),
(18, 9, 1, 'Activo', 'Reflexivo'),
(19, 10, 2, 'Visual', 'Verbal'),
(20, 11, 3, 'Secuencial', 'Global'),
(21, 12, 4, 'Sensorial', 'Intuitivo'),
(22, 13, 1, 'Activo', 'Reflexivo'),
(23, 14, 2, 'Visual', 'Verbal'),
(24, 15, 3, 'Secuencial', 'Global'),
(25, 16, 4, 'Sensorial', 'Intuitivo'),
(26, 17, 1, 'Activo', 'Reflexivo'),
(27, 18, 2, 'Visual', 'Verbal'),
(28, 19, 3, 'Secuencial', 'Global'),
(29, 20, 4, 'Sensorial', 'Intuitivo'),
(30, 21, 1, 'Activo', 'Reflexivo'),
(31, 22, 2, 'Visual', 'Verbal'),
(32, 23, 3, 'Secuencial', 'Global'),
(33, 24, 4, 'Sensorial', 'Intuitivo'),
(34, 25, 1, 'Activo', 'Reflexivo'),
(35, 26, 2, 'Visual', 'Verbal'),
(36, 27, 3, 'Secuencial', 'Global'),
(37, 28, 4, 'Sensorial', 'Intuitivo'),
(38, 29, 1, 'Activo', 'Reflexivo'),
(39, 30, 2, 'Visual', 'Verbal'),
(40, 31, 3, 'Secuencial', 'Global'),
(41, 32, 4, 'Sensorial', 'Intuitivo'),
(42, 33, 1, 'Activo', 'Reflexivo'),
(43, 34, 2, 'Visual', 'Verbal'),
(44, 35, 3, 'Secuencial', 'Global'),
(45, 36, 4, 'Sensorial', 'Intuitivo'),
(46, 37, 1, 'Activo', 'Reflexivo'),
(47, 38, 2, 'Visual', 'Verbal'),
(48, 39, 3, 'Secuencial', 'Global'),
(49, 40, 4, 'Sensorial', 'Intuitivo'),
(50, 41, 1, 'Activo', 'Reflexivo'),
(51, 42, 2, 'Visual', 'Verbal'),
(52, 43, 3, 'Secuencial', 'Global'),
(53, 44, 4, 'Sensorial', 'Intuitivo'),
(54, 45, 1, 'Activo', 'Reflexivo'),
(55, 46, 2, 'Visual', 'Verbal'),
(56, 47, 3, 'Secuencial', 'Global'),
(57, 48, 4, 'Sensorial', 'Intuitivo'),
(58, 49, 1, 'Activo', 'Reflexivo'),
(59, 50, 2, 'Visual', 'Verbal'),
(60, 51, 3, 'Secuencial', 'Global'),
(61, 52, 4, 'Sensorial', 'Intuitivo'),
(62, 53, 1, 'Activo', 'Reflexivo'),
(63, 54, 2, 'Visual', 'Verbal'),
(64, 55, 3, 'Secuencial', 'Global'),
(65, 56, 4, 'Sensorial', 'Intuitivo'),
(66, 57, 1, 'Activo', 'Reflexivo'),
(67, 58, 2, 'Visual', 'Verbal'),
(68, 59, 3, 'Secuencial', 'Global'),
(69, 60, 4, 'Sensorial', 'Intuitivo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opciones_respuesta`
--

CREATE TABLE `opciones_respuesta` (
  `id_opciones` int(11) NOT NULL,
  `preguntas_id` int(11) NOT NULL,
  `texto_op` text DEFAULT NULL,
  `peso` tinyint(4) DEFAULT NULL,
  `codigo_op` enum('A','B') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `opciones_respuesta`
--

INSERT INTO `opciones_respuesta` (`id_opciones`, `preguntas_id`, `texto_op`, `peso`, `codigo_op`) VALUES
(1, 1, 'Participar y hacer actividades.', 1, 'A'),
(2, 1, 'Escuchar tranquilo y pensar en silencio.', 1, 'B'),
(3, 2, 'Veo imágenes o dibujos.', 1, 'A'),
(4, 2, 'Escucho lo que me dicen o leo un texto.', 1, 'B'),
(5, 3, 'Probar paso a paso hasta encontrar la respuesta.', 1, 'A'),
(6, 3, 'Pensar en el problema completo y luego resolverlo.', 1, 'B'),
(7, 4, 'Hacemos juegos o actividades en grupo.', 1, 'A'),
(8, 4, 'Trabajo solo y pienso mis ideas.', 1, 'B'),
(9, 5, 'Con ejemplos de la vida real.', 1, 'A'),
(10, 5, 'Con explicaciones de teorías o ideas.', 1, 'B'),
(11, 6, 'Veo imágenes o dibujos.', 1, 'A'),
(12, 6, 'Leo o escucho las palabras.', 1, 'B'),
(13, 7, 'Prefiero que me den ejemplos concretos.', 1, 'A'),
(14, 7, 'Prefiero descubrir las ideas principales.', 1, 'B'),
(15, 8, 'Participo hablando y probando cosas.', 1, 'A'),
(16, 8, 'Prefiero escuchar y pensar antes de hablar.', 1, 'B'),
(17, 9, 'Prefiero verla en dibujos o películas.', 1, 'A'),
(18, 9, 'Prefiero escucharla o leerla.', 1, 'B'),
(19, 10, 'Me ayuda si me lo muestran con un ejemplo.', 1, 'A'),
(20, 10, 'Me gusta pensar en la idea general primero.', 1, 'B'),
(21, 11, 'Necesito practicar y hacer cosas.', 1, 'A'),
(22, 11, 'Prefiero leer o escuchar la explicación primero.', 1, 'B'),
(23, 12, 'Me gusta participar y moverme.', 1, 'A'),
(24, 12, 'Me gusta mirar y pensar qué haría.', 1, 'B'),
(25, 13, 'Me ayuda verlo en imágenes.', 1, 'A'),
(26, 13, 'Me ayuda escucharlo o leerlo.', 1, 'B'),
(27, 14, 'Voy poniendo pieza por pieza.', 1, 'A'),
(28, 14, 'Prefiero mirar la imagen entera y luego armarlo.', 1, 'B'),
(29, 15, 'Hacemos cosas prácticas.', 1, 'A'),
(30, 15, 'Pensamos en las ideas de la clase.', 1, 'B'),
(31, 16, 'Intervenir, preguntar y discutir.', 1, 'A'),
(32, 16, 'Escuchar primero y pensar en silencio.', 1, 'B'),
(33, 17, 'Hacer resúmenes con esquemas o dibujos.', 1, 'A'),
(34, 17, 'Leer apuntes o escuchar explicaciones.', 1, 'B'),
(35, 18, 'Lo resuelvo paso a paso.', 1, 'A'),
(36, 18, 'Prefiero mirar el problema en general y luego resolverlo.', 1, 'B'),
(37, 19, 'Me gusta hablar y proponer ideas.', 1, 'A'),
(38, 19, 'Prefiero escuchar y organizar mis pensamientos antes.', 1, 'B'),
(39, 20, 'Me sirven ejemplos prácticos.', 1, 'A'),
(40, 20, 'Me interesan las ideas y teorías detrás.', 1, 'B'),
(41, 21, 'Lo que veo en gráficos o presentaciones.', 1, 'A'),
(42, 21, 'Lo que leo en un texto o escucho del profe.', 1, 'B'),
(43, 22, 'Necesito que me den ejemplos concretos.', 1, 'A'),
(44, 22, 'Prefiero entender la idea general y después aplicarla.', 1, 'B'),
(45, 23, 'Hablo en voz alta, hago ejercicios.', 1, 'A'),
(46, 23, 'Leo y reflexiono en silencio.', 1, 'B'),
(47, 24, 'Me sirven esquemas y mapas conceptuales.', 1, 'A'),
(48, 24, 'Prefiero explicaciones escritas u orales.', 1, 'B'),
(49, 25, 'Sigo los pasos lógicos uno por uno.', 1, 'A'),
(50, 25, 'Lo pienso en su conjunto y luego lo resuelvo.', 1, 'B'),
(51, 26, 'Haciendo prácticas, experimentos, ejercicios.', 1, 'A'),
(52, 26, 'Analizando teorías o deduciendo ideas.', 1, 'B'),
(53, 27, 'Cuando hacemos actividades en grupo.', 1, 'A'),
(54, 27, 'Cuando reflexiono sobre lo que escucho.', 1, 'B'),
(55, 28, 'Diagramas, imágenes o gráficos.', 1, 'A'),
(56, 28, 'Lo que leo o escucho.', 1, 'B'),
(57, 29, 'Me ayuda si lo acompañan con ejemplos reales.', 1, 'A'),
(58, 29, 'Prefiero empezar con la explicación general.', 1, 'B'),
(59, 30, 'Me gusta conversar y hacer cosas juntos.', 1, 'A'),
(60, 30, 'Prefiero escuchar y pensar antes de hablar.', 1, 'B'),
(61, 31, 'Lo voy entendiendo por partes.', 1, 'A'),
(62, 31, 'Lo comprendo de golpe cuando lo relaciono con todo.', 1, 'B'),
(63, 32, 'Hago listas, esquemas y pasos.', 1, 'A'),
(64, 32, 'Pienso en la visión general del tema.', 1, 'B'),
(65, 33, 'Prefiero moverme, participar, interactuar.', 1, 'A'),
(66, 33, 'Prefiero observar y reflexionar.', 1, 'B'),
(67, 34, 'Me sirven cuadros y mapas.', 1, 'A'),
(68, 34, 'Prefiero leer mis notas o escuchar explicaciones.', 1, 'B'),
(69, 35, 'Lo practico y lo aplico enseguida.', 1, 'A'),
(70, 35, 'Lo pienso y reflexiono antes de usarlo.', 1, 'B'),
(71, 36, 'Prefiero discutirlo, probarlo o aplicarlo enseguida.', 1, 'A'),
(72, 36, 'Prefiero pensarlo antes de aplicarlo.', 1, 'B'),
(73, 37, 'Me resulta más útil hacer ejercicios prácticos.', 1, 'A'),
(74, 37, 'Me resulta más útil escuchar o leer teoría.', 1, 'B'),
(75, 38, 'Lo voy desarmando en pasos concretos.', 1, 'A'),
(76, 38, 'Prefiero ver primero el panorama completo.', 1, 'B'),
(77, 39, 'Me gusta proponer ideas y actividades.', 1, 'A'),
(78, 39, 'Prefiero escuchar y reflexionar antes de hablar.', 1, 'B'),
(79, 40, 'Ejemplos de la vida real.', 1, 'A'),
(80, 40, 'Explicaciones de conceptos y principios.', 1, 'B'),
(81, 41, 'Gráficos, esquemas, imágenes.', 1, 'A'),
(82, 41, 'Palabras, explicaciones, textos.', 1, 'B'),
(83, 42, 'Me sirve probar distintos métodos paso a paso.', 1, 'A'),
(84, 42, 'Prefiero pensar en la idea general y después buscar la solución.', 1, 'B'),
(85, 43, 'Me gusta que usen imágenes o diagramas.', 1, 'A'),
(86, 43, 'Me sirve más que lo expliquen con palabras.', 1, 'B'),
(87, 44, 'Avanzo de manera ordenada, un paso tras otro.', 1, 'A'),
(88, 44, 'Voy de un punto a otro, relacionando ideas generales.', 1, 'B'),
(89, 45, 'Lo entiendo mejor practicando.', 1, 'A'),
(90, 45, 'Lo entiendo mejor analizando la teoría primero.', 1, 'B'),
(91, 46, 'Me gusta participar activamente.', 1, 'A'),
(92, 46, 'Prefiero observar y reflexionar antes de hablar.', 1, 'B'),
(93, 47, 'Me concentro en ejemplos y casos concretos.', 1, 'A'),
(94, 47, 'Me atraen las ideas abstractas y las teorías.', 1, 'B'),
(95, 48, 'Me ayuda dibujarlo o imaginarlo en imágenes.', 1, 'A'),
(96, 48, 'Me ayuda explicarlo en palabras.', 1, 'B'),
(97, 49, 'Hago resúmenes con esquemas y dibujos.', 1, 'A'),
(98, 49, 'Subrayo o escribo explicaciones con palabras.', 1, 'B'),
(99, 50, 'Lo practico paso a paso hasta dominarlo.', 1, 'A'),
(100, 50, 'Primero intento entender cómo encaja en el todo.', 1, 'B'),
(101, 51, 'Me involucro, participo y actúo.', 1, 'A'),
(102, 51, 'Prefiero escuchar, pensar y luego decidir.', 1, 'B'),
(103, 52, 'Con experiencias prácticas y ejemplos reales.', 1, 'A'),
(104, 52, 'Con ideas generales y teorías.', 1, 'B'),
(105, 53, 'Necesito verlo explicado con imágenes o esquemas.', 1, 'A'),
(106, 53, 'Prefiero una explicación oral o escrita detallada.', 1, 'B'),
(107, 54, 'Hago una lista de tareas paso a paso.', 1, 'A'),
(108, 54, 'Pienso en el objetivo general y luego voy ajustando.', 1, 'B'),
(109, 55, 'Disfruto haciendo ejercicios y trabajos prácticos.', 1, 'A'),
(110, 55, 'Disfruto analizando conceptos y modelos.', 1, 'B'),
(111, 56, 'Hablo y participo activamente.', 1, 'A'),
(112, 56, 'Escucho y reflexiono antes de intervenir.', 1, 'B'),
(113, 57, 'Busco ejemplos y aplicaciones.', 1, 'A'),
(114, 57, 'Me concentro en las ideas abstractas.', 1, 'B'),
(115, 58, 'Recuerdo mejor si muestran diagramas o gráficos.', 1, 'A'),
(116, 58, 'Recuerdo mejor lo que se dice o escribe.', 1, 'B'),
(117, 59, 'Lo divido en partes pequeñas y avanzó por pasos.', 1, 'A'),
(118, 59, 'Lo pienso como un todo y lo resuelvo de forma global.', 1, 'B'),
(119, 60, 'Necesito experimentar, aplicar y probar.', 1, 'A'),
(120, 60, 'Prefiero pensar, reflexionar y analizar antes de actuar.', 1, 'B');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opcion_estilo`
--

CREATE TABLE `opcion_estilo` (
  `id_oe` int(11) NOT NULL,
  `opciones_id` int(11) NOT NULL,
  `ea_id` int(11) NOT NULL,
  `peso` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `opcion_estilo`
--

INSERT INTO `opcion_estilo` (`id_oe`, `opciones_id`, `ea_id`, `peso`) VALUES
(1, 1, 1, 1),
(2, 2, 1, -1),
(3, 3, 2, 1),
(4, 4, 2, -1),
(5, 5, 3, 1),
(6, 6, 3, -1),
(7, 7, 4, 1),
(8, 8, 4, -1),
(9, 9, 1, 1),
(10, 10, 1, -1),
(11, 11, 2, 1),
(12, 12, 2, -1),
(13, 13, 3, 1),
(14, 14, 3, -1),
(15, 15, 4, 1),
(16, 16, 4, -1),
(17, 17, 1, 1),
(18, 18, 1, -1),
(19, 19, 2, 1),
(20, 20, 2, -1),
(21, 21, 3, 1),
(22, 22, 3, -1),
(23, 23, 4, 1),
(24, 24, 4, -1),
(25, 25, 1, 1),
(26, 26, 1, -1),
(27, 27, 2, 1),
(28, 28, 2, -1),
(29, 29, 3, 1),
(30, 30, 3, -1),
(31, 31, 4, 1),
(32, 32, 4, -1),
(33, 33, 1, 1),
(34, 34, 1, -1),
(35, 35, 2, 1),
(36, 36, 2, -1),
(37, 37, 3, 1),
(38, 38, 3, -1),
(39, 39, 4, 1),
(40, 40, 4, -1),
(41, 41, 1, 1),
(42, 42, 1, -1),
(43, 43, 2, 1),
(44, 44, 2, -1),
(45, 45, 3, 1),
(46, 46, 3, -1),
(47, 47, 4, 1),
(48, 48, 4, -1),
(49, 49, 1, 1),
(50, 50, 1, -1),
(51, 51, 2, 1),
(52, 52, 2, -1),
(53, 53, 3, 1),
(54, 54, 3, -1),
(55, 55, 4, 1),
(56, 56, 4, -1),
(57, 57, 1, 1),
(58, 58, 1, -1),
(59, 59, 2, 1),
(60, 60, 2, -1),
(61, 61, 3, 1),
(62, 62, 3, -1),
(63, 63, 4, 1),
(64, 64, 4, -1),
(65, 65, 1, 1),
(66, 66, 1, -1),
(67, 67, 2, 1),
(68, 68, 2, -1),
(69, 69, 3, 1),
(70, 70, 3, -1),
(71, 71, 4, 1),
(72, 72, 4, -1),
(73, 73, 1, 1),
(74, 74, 1, -1),
(75, 75, 2, 1),
(76, 76, 2, -1),
(77, 77, 3, 1),
(78, 78, 3, -1),
(79, 79, 4, 1),
(80, 80, 4, -1),
(81, 81, 1, 1),
(82, 82, 1, -1),
(83, 83, 2, 1),
(84, 84, 2, -1),
(85, 85, 3, 1),
(86, 86, 3, -1),
(87, 87, 4, 1),
(88, 88, 4, -1),
(89, 89, 1, 1),
(90, 90, 1, -1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas`
--

CREATE TABLE `preguntas` (
  `id_preguntas` int(11) NOT NULL,
  `test_id` int(10) UNSIGNED NOT NULL,
  `dimension_id` int(11) DEFAULT NULL,
  `texto` text DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `tipo_pregunta` enum('opcion_multiple','escala','imagen','audio','texto_libre') NOT NULL DEFAULT 'opcion_multiple',
  `numero_pregunta` int(11) NOT NULL,
  `media_url` text DEFAULT NULL,
  `media_tipo` enum('ninguno','imagen','audio','video') NOT NULL DEFAULT 'ninguno'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `preguntas`
--

INSERT INTO `preguntas` (`id_preguntas`, `test_id`, `dimension_id`, `texto`, `orden`, `tipo_pregunta`, `numero_pregunta`, `media_url`, `media_tipo`) VALUES
(1, 1, 1, 'Cuando la maestra explica algo nuevo, prefiero:', 1, 'opcion_multiple', 1, NULL, 'ninguno'),
(2, 1, 2, 'Me gusta más aprender cuando:', 2, 'opcion_multiple', 2, NULL, 'ninguno'),
(3, 1, 4, 'Si tengo que resolver un problema, prefiero:', 3, 'opcion_multiple', 3, NULL, 'ninguno'),
(4, 1, 1, 'En clase, disfruto más cuando:', 4, 'opcion_multiple', 4, NULL, 'ninguno'),
(5, 1, 3, 'Me resulta más fácil aprender:', 5, 'opcion_multiple', 5, NULL, 'ninguno'),
(6, 1, 2, 'Recuerdo mejor las cosas cuando:', 6, 'opcion_multiple', 6, NULL, 'ninguno'),
(7, 1, 3, 'Cuando estudio algo nuevo:', 7, 'opcion_multiple', 7, NULL, 'ninguno'),
(8, 1, 1, 'Si hago un trabajo en grupo:', 8, 'opcion_multiple', 8, NULL, 'ninguno'),
(9, 1, 2, 'Para entender una historia:', 9, 'opcion_multiple', 9, NULL, 'ninguno'),
(10, 1, 4, 'Cuando me enseñan algo difícil:', 10, 'opcion_multiple', 10, NULL, 'ninguno'),
(11, 1, 1, 'Para aprender mejor:', 11, 'opcion_multiple', 11, NULL, 'ninguno'),
(12, 1, 1, 'En los juegos o actividades:', 12, 'opcion_multiple', 12, NULL, 'ninguno'),
(13, 1, 2, 'Cuando me cuentan algo nuevo:', 13, 'opcion_multiple', 13, NULL, 'ninguno'),
(14, 1, 4, 'Si tengo que armar un rompecabezas:', 14, 'opcion_multiple', 14, NULL, 'ninguno'),
(15, 1, 3, 'En la escuela, me siento más cómodo cuando:', 15, 'opcion_multiple', 15, NULL, 'ninguno'),
(16, 2, 1, 'Cuando el profe explica un tema, prefiero:', 16, 'opcion_multiple', 1, NULL, 'ninguno'),
(17, 2, 2, 'Si estudio para un examen, me ayuda más:', 17, 'opcion_multiple', 2, NULL, 'ninguno'),
(18, 2, 4, 'Para entender un problema difícil:', 18, 'opcion_multiple', 3, NULL, 'ninguno'),
(19, 2, 1, 'En un trabajo grupal:', 19, 'opcion_multiple', 4, NULL, 'ninguno'),
(20, 2, 3, 'Cuando aprendo algo nuevo:', 20, 'opcion_multiple', 5, NULL, 'ninguno'),
(21, 2, 2, 'En clase, recuerdo mejor:', 21, 'opcion_multiple', 6, NULL, 'ninguno'),
(22, 2, 3, 'Si me explican algo difícil:', 22, 'opcion_multiple', 7, NULL, 'ninguno'),
(23, 2, 1, 'Cuando estudio solo:', 23, 'opcion_multiple', 8, NULL, 'ninguno'),
(24, 2, 2, 'Para aprender un concepto:', 24, 'opcion_multiple', 9, NULL, 'ninguno'),
(25, 2, 4, 'Si tengo que resolver un problema:', 25, 'opcion_multiple', 10, NULL, 'ninguno'),
(26, 2, 3, 'Me resulta más fácil aprender:', 26, 'opcion_multiple', 11, NULL, 'ninguno'),
(27, 2, 1, 'En clase, disfruto más:', 27, 'opcion_multiple', 12, NULL, 'ninguno'),
(28, 2, 2, 'Recuerdo mejor:', 28, 'opcion_multiple', 13, NULL, 'ninguno'),
(29, 2, 3, 'Cuando me presentan un tema nuevo:', 29, 'opcion_multiple', 14, NULL, 'ninguno'),
(30, 2, 1, 'Si estoy con amigos:', 30, 'opcion_multiple', 15, NULL, 'ninguno'),
(31, 2, 4, 'Cuando aprendo algo complicado:', 31, 'opcion_multiple', 16, NULL, 'ninguno'),
(32, 2, 4, 'Para organizar mi estudio:', 32, 'opcion_multiple', 17, NULL, 'ninguno'),
(33, 2, 1, 'En actividades escolares:', 33, 'opcion_multiple', 18, NULL, 'ninguno'),
(34, 2, 2, 'Para recordar información:', 34, 'opcion_multiple', 19, NULL, 'ninguno'),
(35, 2, 3, 'Si tengo que aprender algo nuevo:', 35, 'opcion_multiple', 20, NULL, 'ninguno'),
(36, 3, 1, 'Cuando aprendo algo nuevo:', 36, 'opcion_multiple', 1, NULL, 'ninguno'),
(37, 3, 3, 'En una capacitación o curso:', 37, 'opcion_multiple', 2, NULL, 'ninguno'),
(38, 3, 4, 'Para entender un tema complejo:', 38, 'opcion_multiple', 3, NULL, 'ninguno'),
(39, 3, 1, 'Cuando participo en un grupo:', 39, 'opcion_multiple', 4, NULL, 'ninguno'),
(40, 3, 3, 'En el trabajo o estudio, aprendo mejor con:', 40, 'opcion_multiple', 5, NULL, 'ninguno'),
(41, 3, 2, 'Recuerdo más fácilmente:', 41, 'opcion_multiple', 6, NULL, 'ninguno'),
(42, 3, 4, 'Si tengo que resolver un problema nuevo:', 42, 'opcion_multiple', 7, NULL, 'ninguno'),
(43, 3, 2, 'Cuando escucho una presentación:', 43, 'opcion_multiple', 8, NULL, 'ninguno'),
(44, 3, 4, 'En el estudio de un tema:', 44, 'opcion_multiple', 9, NULL, 'ninguno'),
(45, 3, 3, 'Si aprendo algo técnico:', 45, 'opcion_multiple', 10, NULL, 'ninguno'),
(46, 3, 1, 'En reuniones o clases:', 46, 'opcion_multiple', 11, NULL, 'ninguno'),
(47, 3, 3, 'Cuando leo un libro o artículo:', 47, 'opcion_multiple', 12, NULL, 'ninguno'),
(48, 3, 2, 'Para recordar algo:', 48, 'opcion_multiple', 13, NULL, 'ninguno'),
(49, 3, 2, 'Cuando estudio solo:', 49, 'opcion_multiple', 14, NULL, 'ninguno'),
(50, 3, 4, 'Si aprendo un procedimiento nuevo:', 50, 'opcion_multiple', 15, NULL, 'ninguno'),
(51, 3, 1, 'En actividades grupales:', 51, 'opcion_multiple', 16, NULL, 'ninguno'),
(52, 3, 3, 'Me resulta más fácil aprender:', 52, 'opcion_multiple', 17, NULL, 'ninguno'),
(53, 3, 2, 'Para entender un proceso:', 53, 'opcion_multiple', 18, NULL, 'ninguno'),
(54, 3, 4, 'Cuando organizo un proyecto:', 54, 'opcion_multiple', 19, NULL, 'ninguno'),
(55, 3, 3, 'En un curso:', 55, 'opcion_multiple', 20, NULL, 'ninguno'),
(56, 3, 1, 'En una reunión:', 56, 'opcion_multiple', 21, NULL, 'ninguno'),
(57, 3, 3, 'Para aprender un tema nuevo:', 57, 'opcion_multiple', 22, NULL, 'ninguno'),
(58, 3, 2, 'En clases con apoyo visual:', 58, 'opcion_multiple', 23, NULL, 'ninguno'),
(59, 3, 4, 'Cuando afronto un desafío:', 59, 'opcion_multiple', 24, NULL, 'ninguno'),
(60, 3, 1, 'Para aprender mejor:', 60, 'opcion_multiple', 25, NULL, 'ninguno');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recomendaciones`
--

CREATE TABLE `recomendaciones` (
  `id_recs` int(11) NOT NULL,
  `estilo_id` int(11) DEFAULT NULL,
  `contenido` text DEFAULT NULL,
  `personalizada` tinyint(4) DEFAULT NULL,
  `dimension_code` int(11) DEFAULT NULL,
  `polo` varchar(45) DEFAULT NULL,
  `umbral_min` tinyint(4) DEFAULT NULL,
  `recurso_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `recomendaciones`
--

INSERT INTO `recomendaciones` (`id_recs`, `estilo_id`, `contenido`, `personalizada`, `dimension_code`, `polo`, `umbral_min`, `recurso_url`) VALUES
(6, 1, 'Participar en grupos de estudio, explicando en voz alta lo aprendido.', 0, 1, 'Activo', 0, NULL),
(7, 1, 'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.', 0, 1, 'Reflexivo', 0, NULL),
(8, 2, 'Enfocate en ejemplos prácticos y ejercicios concretos para fijar los conceptos.', 0, 4, 'Sensorial', 0, NULL),
(9, 2, 'Buscar conexiones con teorías y patrones generales, más allá de los detalles.', 0, 4, 'Intuitivo', 0, NULL),
(10, 3, 'Usar diagramas, mapas conceptuales y colores para organizar la información.', 0, 2, 'Visual', 0, NULL),
(11, 3, 'Estudiar discutiendo con otros y escribiendo resúmenes detallados.', 0, 2, 'Verbal', 0, NULL),
(12, 4, 'Avanzar paso a paso, siguiendo el orden lógico de los temas.', 0, 3, 'Secuencial', 0, NULL),
(13, 4, 'Empezar con una visión general del tema antes de profundizar en los detalles.', 0, 3, 'Global', 0, NULL),
(14, 1, 'Participar en grupos de estudio, explicando en voz alta lo aprendido.', 0, 1, 'Activo', 0, NULL),
(15, 1, 'Realizá proyectos en equipo para poner en práctica lo que aprendés.', 0, 1, 'Activo', 3, NULL),
(16, 1, 'Buscá oportunidades de aplicar lo aprendido en situaciones reales, incluso antes de dominar la teoría.', 0, 1, 'Activo', 6, NULL),
(17, 1, 'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.', 0, 1, 'Reflexivo', 0, NULL),
(18, 1, 'Mantené un diario de aprendizaje donde registres tus reflexiones.', 0, 1, 'Reflexivo', 3, NULL),
(19, 1, 'Antes de actuar, analizá distintos enfoques posibles y sus consecuencias.', 0, 1, 'Reflexivo', 6, NULL),
(20, 1, 'Participar en grupos de estudio, explicando en voz alta lo aprendido.', 0, 1, 'Activo', 0, NULL),
(21, 1, 'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.', 0, 1, 'Reflexivo', 0, NULL),
(22, 2, 'Enfocate en ejemplos prácticos y ejercicios concretos para fijar los conceptos.', 0, 4, 'Sensorial', 0, NULL),
(23, 2, 'Buscar conexiones con teorías y patrones generales, más allá de los detalles.', 0, 4, 'Intuitivo', 0, NULL),
(24, 3, 'Usar diagramas, mapas conceptuales y colores para organizar la información.', 0, 2, 'Visual', 0, NULL),
(25, 3, 'Estudiar discutiendo con otros y escribiendo resúmenes detallados.', 0, 2, 'Verbal', 0, NULL),
(26, 4, 'Avanzar paso a paso, siguiendo el orden lógico de los temas.', 0, 3, 'Secuencial', 0, NULL),
(27, 4, 'Empezar con una visión general del tema antes de profundizar en los detalles.', 0, 3, 'Global', 0, NULL),
(28, 1, 'Participar en grupos de estudio, explicando en voz alta lo aprendido.', 0, 1, 'Activo', 0, NULL),
(29, 1, 'Realizá proyectos en equipo para poner en práctica lo que aprendés.', 0, 1, 'Activo', 3, NULL),
(30, 1, 'Buscá oportunidades de aplicar lo aprendido en situaciones reales, incluso antes de dominar la teoría.', 0, 1, 'Activo', 6, NULL),
(31, 1, 'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.', 0, 1, 'Reflexivo', 0, NULL),
(32, 1, 'Mantené un diario de aprendizaje donde registres tus reflexiones.', 0, 1, 'Reflexivo', 3, NULL),
(33, 1, 'Antes de actuar, analizá distintos enfoques posibles y sus consecuencias.', 0, 1, 'Reflexivo', 6, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestas_usuario`
--

CREATE TABLE `respuestas_usuario` (
  `id_rpu` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `tests_id` int(10) UNSIGNED NOT NULL,
  `fecha_realizacion` datetime DEFAULT NULL,
  `valido` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultados_usuario`
--

CREATE TABLE `resultados_usuario` (
  `id_resu` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `test_id` int(10) UNSIGNED DEFAULT NULL,
  `estilo_id` int(11) DEFAULT NULL,
  `porcentaje` decimal(5,2) NOT NULL,
  `fecha_resultado` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultado_dimension`
--

CREATE TABLE `resultado_dimension` (
  `id_rd` int(11) NOT NULL,
  `ru_id` int(11) DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL,
  `polo_a` varchar(45) DEFAULT NULL,
  `polo_b` varchar(45) DEFAULT NULL,
  `neto` smallint(6) DEFAULT NULL,
  `magnitud` tinyint(4) DEFAULT NULL,
  `ganador` varchar(45) DEFAULT NULL,
  `total_pregs` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tests`
--

CREATE TABLE `tests` (
  `id_test` int(10) UNSIGNED NOT NULL,
  `test_nombre` varchar(100) NOT NULL,
  `test_descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `test_key` varchar(45) NOT NULL,
  `rango_edad_min` tinyint(3) UNSIGNED NOT NULL,
  `rango_edad_max` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tests`
--

INSERT INTO `tests` (`id_test`, `test_nombre`, `test_descripcion`, `activo`, `fecha_creacion`, `test_key`, `rango_edad_min`, `rango_edad_max`) VALUES
(1, 'Test Niños', 'Evaluación de estilos de aprendizaje para niños.', 1, '2025-10-10 03:09:54', 'TNI', 5, 11),
(2, 'Test Adolescentes', 'Evaluación de estilos de aprendizaje para adolescentes.', 1, '2025-10-10 03:09:54', 'TAD', 12, 17),
(3, 'Test Adultos', 'Evaluación de estilos de aprendizaje para adultos.', 1, '2025-10-10 03:09:54', 'TADU', 18, 99);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuarios` int(11) NOT NULL,
  `nombre_completo` varchar(150) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `foto_perfil` text DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuarios`, `nombre_completo`, `fecha_nacimiento`, `email`, `password_hash`, `foto_perfil`, `fecha_registro`) VALUES
(1, 'Gerónimo Barrera Domínguez', '1992-08-15', 'ycalleja@example.org', '$2y$10$wyazg4Mi6/5rMUoj.aqaluHUSmqU0qW3v7vupPVW8XLKAM/ruyTaW', NULL, '2026-01-05 18:46:37'),
(2, 'Samuel Baños', '1979-08-28', 'ramon62@example.net', '$2y$10$c8M4zt21idHto7.5zEzt1.nzp72LFJxTIHut7SXM1CRP.dZovjOIy', NULL, '2026-01-05 18:46:37'),
(3, 'Silvestre Melero-Buendía', '2002-10-31', 'wjaume@example.net', '$2y$10$6PImaAFh0gKJ3VeQAAXcMeUhwVmkEtl609nwVbAEqLPcsopU4ZcbO', NULL, '2026-01-05 18:46:38'),
(4, 'Pepita Borrell Salazar', '2000-08-13', 'patriciapalacio@example.com', '$2y$10$3eHZGjWGcivCsHBYy4ty0O7qjWfDPGNGKE6S.D7qvThTBMOucCUU6', NULL, '2026-01-05 18:46:38'),
(5, 'Adelardo Roselló Cueto', '1984-01-21', 'gordillomayte@example.org', '$2y$10$4QVxdMqm0YVLQ3Nv4uaGAexYmTY0ZhTwkRubX.QSVKgWXmKsdldDe', NULL, '2026-01-05 18:46:38'),
(6, 'Serafina del Oliveras', '1981-03-04', 'tapiareina@example.org', '$2y$10$XkwXTJOGENMtBGr92oq7K.J949EktklvaNhJlDbgMLmF14TdS108u', NULL, '2026-01-05 18:46:38'),
(7, 'Mariano Costa Pedrosa', '1990-07-16', 'ipulido@example.com', '$2y$10$UiQ8MHzhafa1rI50ww3Gyu.futX/LFgwPj.w35ilgg607cVxtjqOW', NULL, '2026-01-05 18:46:38'),
(8, 'Mireia Aguirre Benito', '2001-11-03', 'jose-carlos05@example.org', '$2y$10$fxoM1EHoAVXLAYhq9ZQlwuOJt3iRfT4.M5mBaiF78XNpZpJoyd.AG', NULL, '2026-01-05 18:46:38'),
(9, 'Raimundo Narváez Giner', '1983-11-24', 'perlazurita@example.net', '$2y$10$NqthBmbm.nbMJVP5C0luBuJm8clF8eGUYdBLPFRq3kt1I8/prtxzC', NULL, '2026-01-05 18:46:38'),
(10, 'Gala Asenjo Carnero', '1999-09-03', 'norbertosabater@example.com', '$2y$10$DeX6eXPKb0b5n3MChVn5UuOrcaX3nmynr9ziCDs9UR4qeKZ.E1tOi', NULL, '2026-01-05 18:46:38'),
(11, 'Prueba Registro', '2006-01-01', 'pruebaregister@example.com', '$2y$10$eUPrYDRM5R2GOyqGlgX88eG1MFLZq4tE8fmNwt./12649XSwwb3F6', 'https://ejemplo.com/avatar.png', '2026-01-05 19:34:01');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_extra`
--

CREATE TABLE `usuario_extra` (
  `usuario_id` int(11) NOT NULL,
  `sexo` enum('M','F','O') DEFAULT NULL,
  `diagnostico_previo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuario_extra`
--

INSERT INTO `usuario_extra` (`usuario_id`, `sexo`, `diagnostico_previo`) VALUES
(1, 'F', NULL),
(2, 'M', NULL),
(3, 'F', NULL),
(4, 'M', 'TEA'),
(5, 'F', 'TDAH'),
(6, 'M', NULL),
(7, 'O', 'Dislexia'),
(8, 'F', NULL),
(9, 'F', 'TEA'),
(10, 'O', 'TDAH'),
(11, 'O', NULL);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_sensibles_anonimos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_sensibles_anonimos` (
`sujeto_id` varchar(64)
,`edad` bigint(21)
,`sexo` enum('M','F','O')
,`diagnostico_previo` text
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_sensibles_anonimos`
--
DROP TABLE IF EXISTS `vw_sensibles_anonimos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_sensibles_anonimos`  AS SELECT sha2(concat('SALT_PRIVADA',`u`.`id_usuarios`),256) AS `sujeto_id`, timestampdiff(YEAR,`u`.`fecha_nacimiento`,curdate()) AS `edad`, `x`.`sexo` AS `sexo`, `x`.`diagnostico_previo` AS `diagnostico_previo` FROM (`usuario_extra` `x` join `usuarios` `u` on(`u`.`id_usuarios` = `x`.`usuario_id`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detalle_respuestas`
--
ALTER TABLE `detalle_respuestas`
  ADD PRIMARY KEY (`id_detalle`),
  ADD UNIQUE KEY `uq_dr_ru_preg` (`ru_id`,`preguntas_id`),
  ADD KEY `fk_detalle_respuesta_pregunta` (`preguntas_id`),
  ADD KEY `fk_detalle_respuesta_opcion` (`or_id`);

--
-- Indices de la tabla `dimensiones_fs`
--
ALTER TABLE `dimensiones_fs`
  ADD PRIMARY KEY (`id_dimension`);

--
-- Indices de la tabla `estilos_aprendizaje`
--
ALTER TABLE `estilos_aprendizaje`
  ADD PRIMARY KEY (`id_ea`),
  ADD KEY `fk_estilo_dim_idx` (`dimensiones_id`);

--
-- Indices de la tabla `mapeo_pregunta_dimension`
--
ALTER TABLE `mapeo_pregunta_dimension`
  ADD PRIMARY KEY (`id_mpd`),
  ADD UNIQUE KEY `uq_mpd_pregunta` (`preguntas_id`),
  ADD KEY `fk_mpd_dimension` (`dimensiones_id`);

--
-- Indices de la tabla `opciones_respuesta`
--
ALTER TABLE `opciones_respuesta`
  ADD PRIMARY KEY (`id_opciones`),
  ADD UNIQUE KEY `uq_opciones_pregunta_codigo` (`preguntas_id`,`codigo_op`),
  ADD KEY `pregunta_id_idx` (`preguntas_id`);

--
-- Indices de la tabla `opcion_estilo`
--
ALTER TABLE `opcion_estilo`
  ADD PRIMARY KEY (`id_oe`),
  ADD KEY `fk_opcion_estilo_opcion` (`opciones_id`),
  ADD KEY `fk_opcion_estilo_estilo` (`ea_id`);

--
-- Indices de la tabla `preguntas`
--
ALTER TABLE `preguntas`
  ADD PRIMARY KEY (`id_preguntas`),
  ADD UNIQUE KEY `uq_preguntas_test_numero` (`numero_pregunta`,`test_id`),
  ADD KEY `idx_preguntas_test` (`test_id`),
  ADD KEY `fk_preguntas_dimensiones_fs` (`dimension_id`);

--
-- Indices de la tabla `recomendaciones`
--
ALTER TABLE `recomendaciones`
  ADD PRIMARY KEY (`id_recs`),
  ADD KEY `fk_recomendacion_estilo` (`estilo_id`),
  ADD KEY `fk_rec_dim` (`dimension_code`);

--
-- Indices de la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  ADD PRIMARY KEY (`id_rpu`),
  ADD KEY `usuario_id_idx` (`usuario_id`),
  ADD KEY `fk_rpu_test_idx` (`tests_id`);

--
-- Indices de la tabla `resultados_usuario`
--
ALTER TABLE `resultados_usuario`
  ADD PRIMARY KEY (`id_resu`),
  ADD KEY `fk_resultado_usuario_usuario` (`usuario_id`),
  ADD KEY `fk_resultado_usuario_estilo` (`estilo_id`),
  ADD KEY `fk_resultado_usuario_test` (`test_id`);

--
-- Indices de la tabla `resultado_dimension`
--
ALTER TABLE `resultado_dimension`
  ADD PRIMARY KEY (`id_rd`),
  ADD UNIQUE KEY `uq_rd_ru_dim` (`ru_id`,`dimensiones_id`),
  ADD KEY `fk_rd_dim` (`dimensiones_id`);

--
-- Indices de la tabla `tests`
--
ALTER TABLE `tests`
  ADD PRIMARY KEY (`id_test`),
  ADD UNIQUE KEY `uq_tests_test_key` (`test_key`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuarios`),
  ADD UNIQUE KEY `email_UNIQUE` (`email`);

--
-- Indices de la tabla `usuario_extra`
--
ALTER TABLE `usuario_extra`
  ADD PRIMARY KEY (`usuario_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `detalle_respuestas`
--
ALTER TABLE `detalle_respuestas`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estilos_aprendizaje`
--
ALTER TABLE `estilos_aprendizaje`
  MODIFY `id_ea` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `mapeo_pregunta_dimension`
--
ALTER TABLE `mapeo_pregunta_dimension`
  MODIFY `id_mpd` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT de la tabla `opciones_respuesta`
--
ALTER TABLE `opciones_respuesta`
  MODIFY `id_opciones` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT de la tabla `opcion_estilo`
--
ALTER TABLE `opcion_estilo`
  MODIFY `id_oe` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT de la tabla `preguntas`
--
ALTER TABLE `preguntas`
  MODIFY `id_preguntas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `recomendaciones`
--
ALTER TABLE `recomendaciones`
  MODIFY `id_recs` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  MODIFY `id_rpu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resultados_usuario`
--
ALTER TABLE `resultados_usuario`
  MODIFY `id_resu` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resultado_dimension`
--
ALTER TABLE `resultado_dimension`
  MODIFY `id_rd` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tests`
--
ALTER TABLE `tests`
  MODIFY `id_test` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuarios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_respuestas`
--
ALTER TABLE `detalle_respuestas`
  ADD CONSTRAINT `fk_detalle_respuesta_opcion` FOREIGN KEY (`or_id`) REFERENCES `opciones_respuesta` (`id_opciones`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_respuesta_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_respuesta_usuario` FOREIGN KEY (`ru_id`) REFERENCES `respuestas_usuario` (`id_rpu`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estilos_aprendizaje`
--
ALTER TABLE `estilos_aprendizaje`
  ADD CONSTRAINT `fk_estilo_dim` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`);

--
-- Filtros para la tabla `mapeo_pregunta_dimension`
--
ALTER TABLE `mapeo_pregunta_dimension`
  ADD CONSTRAINT `fk_mpd_dimension` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`),
  ADD CONSTRAINT `fk_mpd_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`);

--
-- Filtros para la tabla `opciones_respuesta`
--
ALTER TABLE `opciones_respuesta`
  ADD CONSTRAINT `fk_opciones_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `opcion_estilo`
--
ALTER TABLE `opcion_estilo`
  ADD CONSTRAINT `fk_opcion_estilo_estilo` FOREIGN KEY (`ea_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_opcion_estilo_opcion` FOREIGN KEY (`opciones_id`) REFERENCES `opciones_respuesta` (`id_opciones`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `preguntas`
--
ALTER TABLE `preguntas`
  ADD CONSTRAINT `fk_pregunta_test` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id_test`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_preguntas_dimensiones_fs` FOREIGN KEY (`dimension_id`) REFERENCES `dimensiones_fs` (`id_dimension`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `recomendaciones`
--
ALTER TABLE `recomendaciones`
  ADD CONSTRAINT `fk_rec_dim` FOREIGN KEY (`dimension_code`) REFERENCES `dimensiones_fs` (`id_dimension`),
  ADD CONSTRAINT `fk_recomendacion_estilo` FOREIGN KEY (`estilo_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  ADD CONSTRAINT `fk_rpu_test` FOREIGN KEY (`tests_id`) REFERENCES `tests` (`id_test`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rpu_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resultados_usuario`
--
ALTER TABLE `resultados_usuario`
  ADD CONSTRAINT `fk_resultado_usuario_estilo` FOREIGN KEY (`estilo_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resultado_usuario_test` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id_test`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_resultado_usuario_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resultado_dimension`
--
ALTER TABLE `resultado_dimension`
  ADD CONSTRAINT `fk_rd_dim` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`),
  ADD CONSTRAINT `fk_rd_ru` FOREIGN KEY (`ru_id`) REFERENCES `respuestas_usuario` (`id_rpu`);

--
-- Filtros para la tabla `usuario_extra`
--
ALTER TABLE `usuario_extra`
  ADD CONSTRAINT `fk_uds_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
