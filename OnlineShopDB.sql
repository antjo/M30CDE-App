-- MySQL dump 10.13  Distrib 5.5.46, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: OnlineShopDB
-- ------------------------------------------------------
-- Server version	5.5.46-0ubuntu0.14.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `email` varchar(30) NOT NULL,
  `password` varchar(20) NOT NULL,
  `fullname` varchar(60) NOT NULL,
  `adress` varchar(100) NOT NULL,
  `phoneNumber` varchar(11) DEFAULT NULL,
  `admin` bit(1) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES ('admin@gmail.com','password','Site Admin','address one','01234567899',''),('user1@gmail.com','password','test user1','address two','01234567899','\0'),('user2@gmail.com','password','test user2','address three','01234567899','\0'),('user3@gmail.com','password','test user3','address four','01234567899','\0'),('user4@gmail.com','password','test user4','address five','01234567899','\0'),('user5@gmail.com','password','test user5','address six','01234567899','\0');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `items` (
  `itemID` int(11) NOT NULL,
  `itemName` varchar(40) NOT NULL,
  `itemQuantity` int(11) NOT NULL,
  `price` int(11) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,'Iphone 3gs',92,30,' The first smartphone released by Apple.'),(2,'Iphone 4',93,40,' The second smartphone released by Apple.'),(3,'Iphone 4s',91,50,'The third smartphone released by Apple. '),(4,'Iphone 5',96,60,'The fourth smartphone released by Apple. '),(5,'Iphone 5s',96,70,'The fifth smartphone released by Apple. '),(6,'Iphone 6',97,80,'The sixth smartphone released by Apple. '),(7,'Iphone 6s',95,90,'The seventh smartphone released by Apple. This is also the latest smartphone available from Apple. '),(8,'Samsung Galaxy S',95,50,'Smartphone released by Samsung. '),(9,'Samsung Galaxy S2',92,60,'Another smartphone released by Samsung.'),(10,'Samsung Galaxy Note',95,80,'A big smartphone released by Samsung. Beware of the size of the phone. ');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordered_items`
--

DROP TABLE IF EXISTS `ordered_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ordered_items` (
  `orderID` int(11) NOT NULL,
  `itemID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  KEY `orderID` (`orderID`),
  CONSTRAINT `ordered_items_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `orders` (`orderID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordered_items`
--

LOCK TABLES `ordered_items` WRITE;
/*!40000 ALTER TABLE `ordered_items` DISABLE KEYS */;
INSERT INTO `ordered_items` VALUES (1,1,1),(1,5,1),(1,9,1),(1,10,1),(1,4,1),(2,4,2),(2,8,3),(2,9,1),(3,1,4),(3,3,1),(3,8,1),(3,9,1),(4,9,3),(4,5,2),(4,7,1),(5,2,4),(5,6,2),(5,10,1),(6,10,2),(6,7,3),(6,3,5),(6,1,1);
/*!40000 ALTER TABLE `ordered_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `orderPrice` int(7) DEFAULT NULL,
  `confirmed` bit(1) NOT NULL,
  UNIQUE KEY `orderID` (`orderID`),
  KEY `email` (`email`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`email`) REFERENCES `customers` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'user1@gmail.com',300,'\0'),(2,'user2@gmail.com',330,''),(3,'user2@gmail.com',280,'\0'),(4,'user3@gmail.com',410,'\0'),(5,'user4@gmail.com',400,''),(6,'user5@gmail.com',710,'\0');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-12-05 18:30:18
