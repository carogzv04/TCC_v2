CREATE DATABASE  IF NOT EXISTS `tcc_db` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `tcc_db`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tcc_db
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `detalle_respuestas`
--

DROP TABLE IF EXISTS `detalle_respuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_respuestas` (
  `id_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `ru_id` int(11) NOT NULL,
  `preguntas_id` int(11) NOT NULL,
  `or_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  UNIQUE KEY `uq_dr_ru_preg` (`ru_id`,`preguntas_id`),
  KEY `fk_detalle_respuesta_pregunta` (`preguntas_id`),
  KEY `fk_detalle_respuesta_opcion` (`or_id`),
  CONSTRAINT `fk_detalle_respuesta_opcion` FOREIGN KEY (`or_id`) REFERENCES `opciones_respuesta` (`id_opciones`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_respuesta_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_respuesta_usuario` FOREIGN KEY (`ru_id`) REFERENCES `respuestas_usuario` (`id_rpu`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_respuestas`
--

LOCK TABLES `detalle_respuestas` WRITE;
/*!40000 ALTER TABLE `detalle_respuestas` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_respuestas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dimensiones_fs`
--

DROP TABLE IF EXISTS `dimensiones_fs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dimensiones_fs` (
  `id_dimension` int(11) NOT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo` char(2) DEFAULT NULL,
  PRIMARY KEY (`id_dimension`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dimensiones_fs`
--

LOCK TABLES `dimensiones_fs` WRITE;
/*!40000 ALTER TABLE `dimensiones_fs` DISABLE KEYS */;
INSERT INTO `dimensiones_fs` VALUES (1,'Activo–Reflexivo','Preferencia entre aprendizaje activo o reflexivo','AR'),(2,'Visual–Verbal','Preferencia entre imágenes o palabras','VV'),(3,'Secuencial–Global','Preferencia entre paso a paso o visión general','SG'),(4,'Sensorial-Intuitivo','Preferencia entre lo concreto y lo abstracto','SI');
/*!40000 ALTER TABLE `dimensiones_fs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estilos_aprendizaje`
--

DROP TABLE IF EXISTS `estilos_aprendizaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estilos_aprendizaje` (
  `id_ea` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ea`),
  KEY `fk_estilo_dim_idx` (`dimensiones_id`),
  CONSTRAINT `fk_estilo_dim` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estilos_aprendizaje`
--

LOCK TABLES `estilos_aprendizaje` WRITE;
/*!40000 ALTER TABLE `estilos_aprendizaje` DISABLE KEYS */;
INSERT INTO `estilos_aprendizaje` VALUES (1,'Activo–Reflexivo','Dimensión que evalúa si el estudiante prefiere la acción o la reflexión al aprender.',NULL),(2,'Sensorial–Intuitivo','Dimensión que evalúa si el estudiante prefiere datos concretos o conceptos abstractos.',NULL),(3,'Visual–Verbal','Dimensión que evalúa si el estudiante prefiere representaciones visuales o información verbal.',NULL),(4,'Secuencial–Global','Dimensión que evalúa si el estudiante aprende mejor paso a paso o viendo la visión general primero.',NULL),(5,'Activo–Reflexivo','Dimensión que evalúa si el estudiante prefiere la acción o la reflexión al aprender.',NULL),(6,'Sensorial–Intuitivo','Dimensión que evalúa si el estudiante prefiere datos concretos o conceptos abstractos.',NULL),(7,'Visual–Verbal','Dimensión que evalúa si el estudiante prefiere representaciones visuales o información verbal.',NULL),(8,'Secuencial–Global','Dimensión que evalúa si el estudiante aprende mejor paso a paso o viendo la visión general primero.',NULL);
/*!40000 ALTER TABLE `estilos_aprendizaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mapeo_pregunta_dimension`
--

DROP TABLE IF EXISTS `mapeo_pregunta_dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapeo_pregunta_dimension` (
  `id_mpd` int(11) NOT NULL AUTO_INCREMENT,
  `preguntas_id` int(11) DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL,
  `polo_a_label` varchar(45) DEFAULT NULL,
  `polo_b_label` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_mpd`),
  UNIQUE KEY `uq_mpd_pregunta` (`preguntas_id`),
  KEY `fk_mpd_dimension` (`dimensiones_id`),
  CONSTRAINT `fk_mpd_dimension` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`),
  CONSTRAINT `fk_mpd_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mapeo_pregunta_dimension`
--

LOCK TABLES `mapeo_pregunta_dimension` WRITE;
/*!40000 ALTER TABLE `mapeo_pregunta_dimension` DISABLE KEYS */;
INSERT INTO `mapeo_pregunta_dimension` VALUES (10,1,1,'Activo','Reflexivo'),(11,2,2,'Visual','Verbal'),(12,3,3,'Secuencial','Global'),(13,4,4,'Sensorial','Intuitivo'),(14,5,1,'Activo','Reflexivo'),(15,6,2,'Visual','Verbal'),(16,7,3,'Secuencial','Global'),(17,8,4,'Sensorial','Intuitivo'),(18,9,1,'Activo','Reflexivo'),(19,10,2,'Visual','Verbal'),(20,11,3,'Secuencial','Global'),(21,12,4,'Sensorial','Intuitivo'),(22,13,1,'Activo','Reflexivo'),(23,14,2,'Visual','Verbal'),(24,15,3,'Secuencial','Global'),(25,16,4,'Sensorial','Intuitivo'),(26,17,1,'Activo','Reflexivo'),(27,18,2,'Visual','Verbal'),(28,19,3,'Secuencial','Global'),(29,20,4,'Sensorial','Intuitivo'),(30,21,1,'Activo','Reflexivo'),(31,22,2,'Visual','Verbal'),(32,23,3,'Secuencial','Global'),(33,24,4,'Sensorial','Intuitivo'),(34,25,1,'Activo','Reflexivo'),(35,26,2,'Visual','Verbal'),(36,27,3,'Secuencial','Global'),(37,28,4,'Sensorial','Intuitivo'),(38,29,1,'Activo','Reflexivo'),(39,30,2,'Visual','Verbal'),(40,31,3,'Secuencial','Global'),(41,32,4,'Sensorial','Intuitivo'),(42,33,1,'Activo','Reflexivo'),(43,34,2,'Visual','Verbal'),(44,35,3,'Secuencial','Global'),(45,36,4,'Sensorial','Intuitivo'),(46,37,1,'Activo','Reflexivo'),(47,38,2,'Visual','Verbal'),(48,39,3,'Secuencial','Global'),(49,40,4,'Sensorial','Intuitivo'),(50,41,1,'Activo','Reflexivo'),(51,42,2,'Visual','Verbal'),(52,43,3,'Secuencial','Global'),(53,44,4,'Sensorial','Intuitivo'),(54,45,1,'Activo','Reflexivo'),(55,46,2,'Visual','Verbal'),(56,47,3,'Secuencial','Global'),(57,48,4,'Sensorial','Intuitivo'),(58,49,1,'Activo','Reflexivo'),(59,50,2,'Visual','Verbal'),(60,51,3,'Secuencial','Global'),(61,52,4,'Sensorial','Intuitivo'),(62,53,1,'Activo','Reflexivo'),(63,54,2,'Visual','Verbal'),(64,55,3,'Secuencial','Global'),(65,56,4,'Sensorial','Intuitivo'),(66,57,1,'Activo','Reflexivo'),(67,58,2,'Visual','Verbal'),(68,59,3,'Secuencial','Global'),(69,60,4,'Sensorial','Intuitivo');
/*!40000 ALTER TABLE `mapeo_pregunta_dimension` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opcion_estilo`
--

DROP TABLE IF EXISTS `opcion_estilo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opcion_estilo` (
  `id_oe` int(11) NOT NULL AUTO_INCREMENT,
  `opciones_id` int(11) NOT NULL,
  `ea_id` int(11) NOT NULL,
  `peso` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_oe`),
  KEY `fk_opcion_estilo_opcion` (`opciones_id`),
  KEY `fk_opcion_estilo_estilo` (`ea_id`),
  CONSTRAINT `fk_opcion_estilo_estilo` FOREIGN KEY (`ea_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_opcion_estilo_opcion` FOREIGN KEY (`opciones_id`) REFERENCES `opciones_respuesta` (`id_opciones`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opcion_estilo`
--

LOCK TABLES `opcion_estilo` WRITE;
/*!40000 ALTER TABLE `opcion_estilo` DISABLE KEYS */;
INSERT INTO `opcion_estilo` VALUES (1,1,1,1),(2,2,1,-1),(3,3,2,1),(4,4,2,-1),(5,5,3,1),(6,6,3,-1),(7,7,4,1),(8,8,4,-1),(9,9,1,1),(10,10,1,-1),(11,11,2,1),(12,12,2,-1),(13,13,3,1),(14,14,3,-1),(15,15,4,1),(16,16,4,-1),(17,17,1,1),(18,18,1,-1),(19,19,2,1),(20,20,2,-1),(21,21,3,1),(22,22,3,-1),(23,23,4,1),(24,24,4,-1),(25,25,1,1),(26,26,1,-1),(27,27,2,1),(28,28,2,-1),(29,29,3,1),(30,30,3,-1),(31,31,4,1),(32,32,4,-1),(33,33,1,1),(34,34,1,-1),(35,35,2,1),(36,36,2,-1),(37,37,3,1),(38,38,3,-1),(39,39,4,1),(40,40,4,-1),(41,41,1,1),(42,42,1,-1),(43,43,2,1),(44,44,2,-1),(45,45,3,1),(46,46,3,-1),(47,47,4,1),(48,48,4,-1),(49,49,1,1),(50,50,1,-1),(51,51,2,1),(52,52,2,-1),(53,53,3,1),(54,54,3,-1),(55,55,4,1),(56,56,4,-1),(57,57,1,1),(58,58,1,-1),(59,59,2,1),(60,60,2,-1),(61,61,3,1),(62,62,3,-1),(63,63,4,1),(64,64,4,-1),(65,65,1,1),(66,66,1,-1),(67,67,2,1),(68,68,2,-1),(69,69,3,1),(70,70,3,-1),(71,71,4,1),(72,72,4,-1),(73,73,1,1),(74,74,1,-1),(75,75,2,1),(76,76,2,-1),(77,77,3,1),(78,78,3,-1),(79,79,4,1),(80,80,4,-1),(81,81,1,1),(82,82,1,-1),(83,83,2,1),(84,84,2,-1),(85,85,3,1),(86,86,3,-1),(87,87,4,1),(88,88,4,-1),(89,89,1,1),(90,90,1,-1);
/*!40000 ALTER TABLE `opcion_estilo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opciones_respuesta`
--

DROP TABLE IF EXISTS `opciones_respuesta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opciones_respuesta` (
  `id_opciones` int(11) NOT NULL AUTO_INCREMENT,
  `preguntas_id` int(11) NOT NULL,
  `texto_op` text DEFAULT NULL,
  `peso` tinyint(4) DEFAULT NULL,
  `codigo_op` enum('A','B') NOT NULL,
  PRIMARY KEY (`id_opciones`),
  UNIQUE KEY `uq_opciones_pregunta_codigo` (`preguntas_id`,`codigo_op`),
  KEY `pregunta_id_idx` (`preguntas_id`),
  CONSTRAINT `fk_opciones_pregunta` FOREIGN KEY (`preguntas_id`) REFERENCES `preguntas` (`id_preguntas`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opciones_respuesta`
--

LOCK TABLES `opciones_respuesta` WRITE;
/*!40000 ALTER TABLE `opciones_respuesta` DISABLE KEYS */;
INSERT INTO `opciones_respuesta` VALUES (1,1,'Opción A genérica',1,'A'),(2,1,'Opción B genérica',1,'B'),(3,2,'Opción A genérica',1,'A'),(4,2,'Opción B genérica',1,'B'),(5,3,'Opción A genérica',1,'A'),(6,3,'Opción B genérica',1,'B'),(7,4,'Opción A genérica',1,'A'),(8,4,'Opción B genérica',1,'B'),(9,5,'Opción A genérica',1,'A'),(10,5,'Opción B genérica',1,'B'),(11,6,'Opción A genérica',1,'A'),(12,6,'Opción B genérica',1,'B'),(13,7,'Opción A genérica',1,'A'),(14,7,'Opción B genérica',1,'B'),(15,8,'Opción A genérica',1,'A'),(16,8,'Opción B genérica',1,'B'),(17,9,'Opción A genérica',1,'A'),(18,9,'Opción B genérica',1,'B'),(19,10,'Opción A genérica',1,'A'),(20,10,'Opción B genérica',1,'B'),(21,11,'Opción A genérica',1,'A'),(22,11,'Opción B genérica',1,'B'),(23,12,'Opción A genérica',1,'A'),(24,12,'Opción B genérica',1,'B'),(25,13,'Opción A genérica',1,'A'),(26,13,'Opción B genérica',1,'B'),(27,14,'Opción A genérica',1,'A'),(28,14,'Opción B genérica',1,'B'),(29,15,'Opción A genérica',1,'A'),(30,15,'Opción B genérica',1,'B'),(31,31,'Opción A genérica',1,'A'),(32,31,'Opción B genérica',1,'B'),(33,32,'Opción A genérica',1,'A'),(34,32,'Opción B genérica',1,'B'),(35,33,'Opción A genérica',1,'A'),(36,33,'Opción B genérica',1,'B'),(37,34,'Opción A genérica',1,'A'),(38,34,'Opción B genérica',1,'B'),(39,35,'Opción A genérica',1,'A'),(40,35,'Opción B genérica',1,'B'),(41,36,'Opción A genérica',1,'A'),(42,36,'Opción B genérica',1,'B'),(43,37,'Opción A genérica',1,'A'),(44,37,'Opción B genérica',1,'B'),(45,38,'Opción A genérica',1,'A'),(46,38,'Opción B genérica',1,'B'),(47,39,'Opción A genérica',1,'A'),(48,39,'Opción B genérica',1,'B'),(49,40,'Opción A genérica',1,'A'),(50,40,'Opción B genérica',1,'B'),(51,41,'Opción A genérica',1,'A'),(52,41,'Opción B genérica',1,'B'),(53,42,'Opción A genérica',1,'A'),(54,42,'Opción B genérica',1,'B'),(55,43,'Opción A genérica',1,'A'),(56,43,'Opción B genérica',1,'B'),(57,44,'Opción A genérica',1,'A'),(58,44,'Opción B genérica',1,'B'),(59,45,'Opción A genérica',1,'A'),(60,45,'Opción B genérica',1,'B'),(61,46,'Opción A genérica',1,'A'),(62,46,'Opción B genérica',1,'B'),(63,47,'Opción A genérica',1,'A'),(64,47,'Opción B genérica',1,'B'),(65,48,'Opción A genérica',1,'A'),(66,48,'Opción B genérica',1,'B'),(67,49,'Opción A genérica',1,'A'),(68,49,'Opción B genérica',1,'B'),(69,50,'Opción A genérica',1,'A'),(70,50,'Opción B genérica',1,'B'),(71,51,'Opción A genérica',1,'A'),(72,51,'Opción B genérica',1,'B'),(73,52,'Opción A genérica',1,'A'),(74,52,'Opción B genérica',1,'B'),(75,53,'Opción A genérica',1,'A'),(76,53,'Opción B genérica',1,'B'),(77,54,'Opción A genérica',1,'A'),(78,54,'Opción B genérica',1,'B'),(79,55,'Opción A genérica',1,'A'),(80,55,'Opción B genérica',1,'B'),(81,56,'Opción A genérica',1,'A'),(82,56,'Opción B genérica',1,'B'),(83,57,'Opción A genérica',1,'A'),(84,57,'Opción B genérica',1,'B'),(85,58,'Opción A genérica',1,'A'),(86,58,'Opción B genérica',1,'B'),(87,59,'Opción A genérica',1,'A'),(88,59,'Opción B genérica',1,'B'),(89,60,'Opción A genérica',1,'A'),(90,60,'Opción B genérica',1,'B'),(91,16,'Opción A genérica',1,'A'),(92,16,'Opción B genérica',1,'B'),(93,17,'Opción A genérica',1,'A'),(94,17,'Opción B genérica',1,'B'),(95,18,'Opción A genérica',1,'A'),(96,18,'Opción B genérica',1,'B'),(97,19,'Opción A genérica',1,'A'),(98,19,'Opción B genérica',1,'B'),(99,20,'Opción A genérica',1,'A'),(100,20,'Opción B genérica',1,'B'),(101,21,'Opción A genérica',1,'A'),(102,21,'Opción B genérica',1,'B'),(103,22,'Opción A genérica',1,'A'),(104,22,'Opción B genérica',1,'B'),(105,23,'Opción A genérica',1,'A'),(106,23,'Opción B genérica',1,'B'),(107,24,'Opción A genérica',1,'A'),(108,24,'Opción B genérica',1,'B'),(109,25,'Opción A genérica',1,'A'),(110,25,'Opción B genérica',1,'B'),(111,26,'Opción A genérica',1,'A'),(112,26,'Opción B genérica',1,'B'),(113,27,'Opción A genérica',1,'A'),(114,27,'Opción B genérica',1,'B'),(115,28,'Opción A genérica',1,'A'),(116,28,'Opción B genérica',1,'B'),(117,29,'Opción A genérica',1,'A'),(118,29,'Opción B genérica',1,'B'),(119,30,'Opción A genérica',1,'A'),(120,30,'Opción B genérica',1,'B');
/*!40000 ALTER TABLE `opciones_respuesta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntas` (
  `id_preguntas` int(11) NOT NULL AUTO_INCREMENT,
  `test_id` int(10) unsigned NOT NULL,
  `texto` text DEFAULT NULL,
  `orden` int(11) DEFAULT NULL,
  `tipo_pregunta` enum('opcion_multiple','escala','imagen','audio','texto_libre') NOT NULL DEFAULT 'opcion_multiple',
  `numero_pregunta` int(11) NOT NULL,
  `media_url` text DEFAULT NULL,
  `media_tipo` enum('ninguno','imagen','audio','video') NOT NULL DEFAULT 'ninguno',
  PRIMARY KEY (`id_preguntas`),
  UNIQUE KEY `uq_preguntas_test_numero` (`numero_pregunta`,`test_id`),
  KEY `idx_preguntas_test` (`test_id`),
  CONSTRAINT `fk_pregunta_test` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id_test`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntas`
--

LOCK TABLES `preguntas` WRITE;
/*!40000 ALTER TABLE `preguntas` DISABLE KEYS */;
INSERT INTO `preguntas` VALUES (1,1,'Cuando la maestra explica algo nuevo, prefiero:',1,'opcion_multiple',1,NULL,'ninguno'),(2,1,'Me gusta más aprender cuando:',2,'opcion_multiple',2,NULL,'ninguno'),(3,1,'Si tengo que resolver un problema, prefiero:',3,'opcion_multiple',3,NULL,'ninguno'),(4,1,'En clase, disfruto más cuando:',4,'opcion_multiple',4,NULL,'ninguno'),(5,1,'Me resulta más fácil aprender:',5,'opcion_multiple',5,NULL,'ninguno'),(6,1,'Recuerdo mejor las cosas cuando:',6,'opcion_multiple',6,NULL,'ninguno'),(7,1,'Cuando estudio algo nuevo:',7,'opcion_multiple',7,NULL,'ninguno'),(8,1,'Si hago un trabajo en grupo:',8,'opcion_multiple',8,NULL,'ninguno'),(9,1,'Para entender una historia:',9,'opcion_multiple',9,NULL,'ninguno'),(10,1,'Cuando me enseñan algo difícil:',10,'opcion_multiple',10,NULL,'ninguno'),(11,1,'Para aprender mejor:',11,'opcion_multiple',11,NULL,'ninguno'),(12,1,'En los juegos o actividades:',12,'opcion_multiple',12,NULL,'ninguno'),(13,1,'Cuando me cuentan algo nuevo:',13,'opcion_multiple',13,NULL,'ninguno'),(14,1,'Si tengo que armar un rompecabezas:',14,'opcion_multiple',14,NULL,'ninguno'),(15,1,'En la escuela, me siento más cómodo cuando:',15,'opcion_multiple',15,NULL,'ninguno'),(16,2,'Cuando el profe explica un tema, prefiero:',16,'opcion_multiple',1,NULL,'ninguno'),(17,2,'Si estudio para un examen, me ayuda más:',17,'opcion_multiple',2,NULL,'ninguno'),(18,2,'Para entender un problema difícil:',18,'opcion_multiple',3,NULL,'ninguno'),(19,2,'En un trabajo grupal:',19,'opcion_multiple',4,NULL,'ninguno'),(20,2,'Cuando aprendo algo nuevo:',20,'opcion_multiple',5,NULL,'ninguno'),(21,2,'En clase, recuerdo mejor:',21,'opcion_multiple',6,NULL,'ninguno'),(22,2,'Si me explican algo difícil:',22,'opcion_multiple',7,NULL,'ninguno'),(23,2,'Cuando estudio solo:',23,'opcion_multiple',8,NULL,'ninguno'),(24,2,'Para aprender un concepto:',24,'opcion_multiple',9,NULL,'ninguno'),(25,2,'Si tengo que resolver un problema:',25,'opcion_multiple',10,NULL,'ninguno'),(26,2,'Me resulta más fácil aprender:',26,'opcion_multiple',11,NULL,'ninguno'),(27,2,'En clase, disfruto más:',27,'opcion_multiple',12,NULL,'ninguno'),(28,2,'Recuerdo mejor:',28,'opcion_multiple',13,NULL,'ninguno'),(29,2,'Cuando me presentan un tema nuevo:',29,'opcion_multiple',14,NULL,'ninguno'),(30,2,'Si estoy con amigos:',30,'opcion_multiple',15,NULL,'ninguno'),(31,2,'Cuando aprendo algo complicado:',31,'opcion_multiple',16,NULL,'ninguno'),(32,2,'Para organizar mi estudio:',32,'opcion_multiple',17,NULL,'ninguno'),(33,2,'En actividades escolares:',33,'opcion_multiple',18,NULL,'ninguno'),(34,2,'Para recordar información:',34,'opcion_multiple',19,NULL,'ninguno'),(35,2,'Si tengo que aprender algo nuevo:',35,'opcion_multiple',20,NULL,'ninguno'),(36,3,'Cuando aprendo algo nuevo:',36,'opcion_multiple',1,NULL,'ninguno'),(37,3,'En una capacitación o curso:',37,'opcion_multiple',2,NULL,'ninguno'),(38,3,'Para entender un tema complejo:',38,'opcion_multiple',3,NULL,'ninguno'),(39,3,'Cuando participo en un grupo:',39,'opcion_multiple',4,NULL,'ninguno'),(40,3,'En el trabajo o estudio, aprendo mejor con:',40,'opcion_multiple',5,NULL,'ninguno'),(41,3,'Recuerdo más fácilmente:',41,'opcion_multiple',6,NULL,'ninguno'),(42,3,'Si tengo que resolver un problema nuevo:',42,'opcion_multiple',7,NULL,'ninguno'),(43,3,'Cuando escucho una presentación:',43,'opcion_multiple',8,NULL,'ninguno'),(44,3,'En el estudio de un tema:',44,'opcion_multiple',9,NULL,'ninguno'),(45,3,'Si aprendo algo técnico:',45,'opcion_multiple',10,NULL,'ninguno'),(46,3,'En reuniones o clases:',46,'opcion_multiple',11,NULL,'ninguno'),(47,3,'Cuando leo un libro o artículo:',47,'opcion_multiple',12,NULL,'ninguno'),(48,3,'Para recordar algo:',48,'opcion_multiple',13,NULL,'ninguno'),(49,3,'Cuando estudio solo:',49,'opcion_multiple',14,NULL,'ninguno'),(50,3,'Si aprendo un procedimiento nuevo:',50,'opcion_multiple',15,NULL,'ninguno'),(51,3,'En actividades grupales:',51,'opcion_multiple',16,NULL,'ninguno'),(52,3,'Me resulta más fácil aprender:',52,'opcion_multiple',17,NULL,'ninguno'),(53,3,'Para entender un proceso:',53,'opcion_multiple',18,NULL,'ninguno'),(54,3,'Cuando organizo un proyecto:',54,'opcion_multiple',19,NULL,'ninguno'),(55,3,'En un curso:',55,'opcion_multiple',20,NULL,'ninguno'),(56,3,'En una reunión:',56,'opcion_multiple',21,NULL,'ninguno'),(57,3,'Para aprender un tema nuevo:',57,'opcion_multiple',22,NULL,'ninguno'),(58,3,'En clases con apoyo visual:',58,'opcion_multiple',23,NULL,'ninguno'),(59,3,'Cuando afronto un desafío:',59,'opcion_multiple',24,NULL,'ninguno'),(60,3,'Para aprender mejor:',60,'opcion_multiple',25,NULL,'ninguno');
/*!40000 ALTER TABLE `preguntas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recomendaciones`
--

DROP TABLE IF EXISTS `recomendaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recomendaciones` (
  `id_recs` int(11) NOT NULL AUTO_INCREMENT,
  `estilo_id` int(11) DEFAULT NULL,
  `contenido` text DEFAULT NULL,
  `personalizada` tinyint(4) DEFAULT NULL,
  `dimension_code` int(11) DEFAULT NULL,
  `polo` varchar(45) DEFAULT NULL,
  `umbral_min` tinyint(4) DEFAULT NULL,
  `recurso_url` text DEFAULT NULL,
  PRIMARY KEY (`id_recs`),
  KEY `fk_recomendacion_estilo` (`estilo_id`),
  KEY `fk_rec_dim` (`dimension_code`),
  CONSTRAINT `fk_rec_dim` FOREIGN KEY (`dimension_code`) REFERENCES `dimensiones_fs` (`id_dimension`),
  CONSTRAINT `fk_recomendacion_estilo` FOREIGN KEY (`estilo_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recomendaciones`
--

LOCK TABLES `recomendaciones` WRITE;
/*!40000 ALTER TABLE `recomendaciones` DISABLE KEYS */;
INSERT INTO `recomendaciones` VALUES (6,1,'Participar en grupos de estudio, explicando en voz alta lo aprendido.',0,1,'Activo',0,NULL),(7,1,'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.',0,1,'Reflexivo',0,NULL),(8,2,'Enfocate en ejemplos prácticos y ejercicios concretos para fijar los conceptos.',0,4,'Sensorial',0,NULL),(9,2,'Buscar conexiones con teorías y patrones generales, más allá de los detalles.',0,4,'Intuitivo',0,NULL),(10,3,'Usar diagramas, mapas conceptuales y colores para organizar la información.',0,2,'Visual',0,NULL),(11,3,'Estudiar discutiendo con otros y escribiendo resúmenes detallados.',0,2,'Verbal',0,NULL),(12,4,'Avanzar paso a paso, siguiendo el orden lógico de los temas.',0,3,'Secuencial',0,NULL),(13,4,'Empezar con una visión general del tema antes de profundizar en los detalles.',0,3,'Global',0,NULL),(14,1,'Participar en grupos de estudio, explicando en voz alta lo aprendido.',0,1,'Activo',0,NULL),(15,1,'Realizá proyectos en equipo para poner en práctica lo que aprendés.',0,1,'Activo',3,NULL),(16,1,'Buscá oportunidades de aplicar lo aprendido en situaciones reales, incluso antes de dominar la teoría.',0,1,'Activo',6,NULL),(17,1,'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.',0,1,'Reflexivo',0,NULL),(18,1,'Mantené un diario de aprendizaje donde registres tus reflexiones.',0,1,'Reflexivo',3,NULL),(19,1,'Antes de actuar, analizá distintos enfoques posibles y sus consecuencias.',0,1,'Reflexivo',6,NULL),(20,1,'Participar en grupos de estudio, explicando en voz alta lo aprendido.',0,1,'Activo',0,NULL),(21,1,'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.',0,1,'Reflexivo',0,NULL),(22,2,'Enfocate en ejemplos prácticos y ejercicios concretos para fijar los conceptos.',0,4,'Sensorial',0,NULL),(23,2,'Buscar conexiones con teorías y patrones generales, más allá de los detalles.',0,4,'Intuitivo',0,NULL),(24,3,'Usar diagramas, mapas conceptuales y colores para organizar la información.',0,2,'Visual',0,NULL),(25,3,'Estudiar discutiendo con otros y escribiendo resúmenes detallados.',0,2,'Verbal',0,NULL),(26,4,'Avanzar paso a paso, siguiendo el orden lógico de los temas.',0,3,'Secuencial',0,NULL),(27,4,'Empezar con una visión general del tema antes de profundizar en los detalles.',0,3,'Global',0,NULL),(28,1,'Participar en grupos de estudio, explicando en voz alta lo aprendido.',0,1,'Activo',0,NULL),(29,1,'Realizá proyectos en equipo para poner en práctica lo que aprendés.',0,1,'Activo',3,NULL),(30,1,'Buscá oportunidades de aplicar lo aprendido en situaciones reales, incluso antes de dominar la teoría.',0,1,'Activo',6,NULL),(31,1,'Tomate tiempo para pensar y escribir resúmenes antes de aplicar lo aprendido.',0,1,'Reflexivo',0,NULL),(32,1,'Mantené un diario de aprendizaje donde registres tus reflexiones.',0,1,'Reflexivo',3,NULL),(33,1,'Antes de actuar, analizá distintos enfoques posibles y sus consecuencias.',0,1,'Reflexivo',6,NULL);
/*!40000 ALTER TABLE `recomendaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `respuestas_usuario`
--

DROP TABLE IF EXISTS `respuestas_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `respuestas_usuario` (
  `id_rpu` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `tests_id` int(10) unsigned NOT NULL,
  `fecha_realizacion` datetime DEFAULT NULL,
  `valido` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_rpu`),
  KEY `usuario_id_idx` (`usuario_id`),
  KEY `fk_rpu_test_idx` (`tests_id`),
  CONSTRAINT `fk_rpu_test` FOREIGN KEY (`tests_id`) REFERENCES `tests` (`id_test`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rpu_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `respuestas_usuario`
--

LOCK TABLES `respuestas_usuario` WRITE;
/*!40000 ALTER TABLE `respuestas_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `respuestas_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resultado_dimension`
--

DROP TABLE IF EXISTS `resultado_dimension`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resultado_dimension` (
  `id_rd` int(11) NOT NULL AUTO_INCREMENT,
  `ru_id` int(11) DEFAULT NULL,
  `dimensiones_id` int(11) DEFAULT NULL,
  `polo_a` varchar(45) DEFAULT NULL,
  `polo_b` varchar(45) DEFAULT NULL,
  `neto` smallint(6) DEFAULT NULL,
  `magnitud` tinyint(4) DEFAULT NULL,
  `ganador` varchar(45) DEFAULT NULL,
  `total_pregs` tinyint(4) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id_rd`),
  UNIQUE KEY `uq_rd_ru_dim` (`ru_id`,`dimensiones_id`),
  KEY `fk_rd_dim` (`dimensiones_id`),
  CONSTRAINT `fk_rd_dim` FOREIGN KEY (`dimensiones_id`) REFERENCES `dimensiones_fs` (`id_dimension`),
  CONSTRAINT `fk_rd_ru` FOREIGN KEY (`ru_id`) REFERENCES `respuestas_usuario` (`id_rpu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultado_dimension`
--

LOCK TABLES `resultado_dimension` WRITE;
/*!40000 ALTER TABLE `resultado_dimension` DISABLE KEYS */;
/*!40000 ALTER TABLE `resultado_dimension` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resultados_usuario`
--

DROP TABLE IF EXISTS `resultados_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resultados_usuario` (
  `id_resu` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `test_id` int(10) unsigned DEFAULT NULL,
  `estilo_id` int(11) DEFAULT NULL,
  `porcentaje` int(11) DEFAULT NULL,
  `fecha_resultado` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_resu`),
  KEY `fk_resultado_usuario_usuario` (`usuario_id`),
  KEY `fk_resultado_usuario_estilo` (`estilo_id`),
  KEY `fk_resultado_usuario_test` (`test_id`),
  CONSTRAINT `fk_resultado_usuario_estilo` FOREIGN KEY (`estilo_id`) REFERENCES `estilos_aprendizaje` (`id_ea`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_resultado_usuario_test` FOREIGN KEY (`test_id`) REFERENCES `tests` (`id_test`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_resultado_usuario_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resultados_usuario`
--

LOCK TABLES `resultados_usuario` WRITE;
/*!40000 ALTER TABLE `resultados_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `resultados_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tests`
--

DROP TABLE IF EXISTS `tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tests` (
  `id_test` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `test_nombre` varchar(100) NOT NULL,
  `test_descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp(),
  `test_key` varchar(45) NOT NULL,
  `rango_edad_min` tinyint(3) unsigned NOT NULL,
  `rango_edad_max` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id_test`),
  UNIQUE KEY `uq_tests_test_key` (`test_key`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tests`
--

LOCK TABLES `tests` WRITE;
/*!40000 ALTER TABLE `tests` DISABLE KEYS */;
INSERT INTO `tests` VALUES (1,'Test Niños','Evaluación de estilos de aprendizaje para niños.',1,'2025-10-10 03:09:54','TNI',5,11),(2,'Test Adolescentes','Evaluación de estilos de aprendizaje para adolescentes.',1,'2025-10-10 03:09:54','TAD',12,17),(3,'Test Adultos','Evaluación de estilos de aprendizaje para adultos.',1,'2025-10-10 03:09:54','TADU',18,99);
/*!40000 ALTER TABLE `tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuarios` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(150) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `sexo` enum('M','F','O') DEFAULT NULL,
  `foto_perfil` text DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL,
  `diagnostico_previo` text DEFAULT NULL,
  PRIMARY KEY (`id_usuarios`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Carmela De Arteaga Guidotti','2003-09-24','meme@example.com','F','https://ejemplo.com/avatar.jpg','2025-10-11 03:38:21','TEA');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-11 18:35:37
