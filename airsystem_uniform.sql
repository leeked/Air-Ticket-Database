-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 06, 2021 at 05:20 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `airsystem`
--

-- --------------------------------------------------------

--
-- Table structure for table `airline`
--

CREATE TABLE `airline` (
  `airline_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `airline`
--

INSERT INTO `airline` (`airline_name`) VALUES
('American Airlines'),
('China Eastern');

-- --------------------------------------------------------

--
-- Table structure for table `airline_staff`
--

CREATE TABLE `airline_staff` (
  `username` varchar(30) NOT NULL,
  `staff_password` varchar(300) NOT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `airline_staff`
--

INSERT INTO `airline_staff` (`username`, `staff_password`, `first_name`, `last_name`, `date_of_birth`) VALUES
('jj2798', 'be1c21f0aef9b5d9e69dd0c7bd5cf439', 'Jeremy', 'J', '2000-12-25'),
('joe', '9f9d51bc70ef21ca5c14f307980a29d8', 'joe', 'bob', '2001-11-11'),
('steve_block', 'b9d0e6556e40c9be01351c245f3673ea', 'Steve', 'Block', '2009-05-16');

-- --------------------------------------------------------

--
-- Table structure for table `airplane`
--

CREATE TABLE `airplane` (
  `airline_name` varchar(20) NOT NULL,
  `airplane_id` int(11) NOT NULL,
  `num_seats` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `airplane`
--

INSERT INTO `airplane` (`airline_name`, `airplane_id`, `num_seats`) VALUES
('American Airlines', 100, 100),
('American Airlines', 101, 100),
('American Airlines', 102, 100),
('American Airlines', 103, 100),
('American Airlines', 104, 100),
('American Airlines', 105, 100),
('China Eastern', 200, 100),
('China Eastern', 201, 100),
('China Eastern', 202, 100),
('China Eastern', 203, 100),
('China Eastern', 204, 100),
('China Eastern', 205, 100);

-- --------------------------------------------------------

--
-- Table structure for table `airport`
--

CREATE TABLE `airport` (
  `code` int(11) NOT NULL,
  `airport_name` varchar(30) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `airport`
--

INSERT INTO `airport` (`code`, `airport_name`, `city`) VALUES
(111, 'JFK', 'New York City'),
(222, 'PVG', 'Shanghai'),
(333, 'SJC', 'San Jose'),
(444, 'PAR', 'Paris'),
(555, 'TOK', 'Tokyo'),
(666, 'CHC', 'Chicago'),
(777, 'MOS', 'Moscow'),
(888, 'SYD', 'Sydney'),
(999, 'DUB', 'Dubai');

-- --------------------------------------------------------

--
-- Stand-in structure for view `available_tickets`
-- (See below for the actual view)
--
CREATE TABLE `available_tickets` (
`ticket_id` int(11)
,`airline_name` varchar(20)
,`flight_number` int(11)
,`depart_ts` datetime
,`price` float(6,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `email` varchar(60) NOT NULL,
  `customer_name` varchar(30) NOT NULL,
  `customer_password` varchar(300) NOT NULL,
  `addr_building_number` int(11) DEFAULT NULL,
  `addr_street` varchar(30) DEFAULT NULL,
  `addr_city` varchar(30) DEFAULT NULL,
  `addr_state` varchar(30) DEFAULT NULL,
  `phone_number` varchar(12) NOT NULL,
  `passport_number` varchar(20) NOT NULL,
  `passport_expiration` date NOT NULL,
  `passport_country` varchar(60) NOT NULL,
  `date_of_birth` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`email`, `customer_name`, `customer_password`, `addr_building_number`, `addr_street`, `addr_city`, `addr_state`, `phone_number`, `passport_number`, `passport_expiration`, `passport_country`, `date_of_birth`) VALUES
('andyhamilton@nyu.edu', 'Andy Hamilton', '9726255eec083aa56dc0449a21b33190', 116, 'wallstreet', 'New York', 'New York', '621-141-5161', 'P-718', '2023-06-01', 'USA', '1952-11-03'),
('dummy@nyu.edu', 'Dummy Thicc', '275876e34cf609db118f3d84b799a790', 412, '7th Street', 'New York', 'New York', '123-456-7890', 'P-472', '2021-11-16', 'Venezuela', '2021-11-21'),
('jj2798@nyu.edu', 'Jeremy Jang', '6119442a08276dbb22e918c3d85c1c6e', 111, 'Somestreet', 'New York', 'New York', '408-123-4567', 'P-111', '2023-06-01', 'USA', '2000-12-25'),
('thisanemail@gmail.com', 'Johnny Boy', '3a853aa4e7e5b87c330dc29b7464bea8', 122, 'Anotherstreet', 'San Jose', 'California', '408-891-0111', 'P-213', '2026-02-01', 'USA', '2007-10-02');

-- --------------------------------------------------------

--
-- Table structure for table `flights`
--

CREATE TABLE `flights` (
  `airline_name` varchar(20) NOT NULL,
  `flight_number` int(11) NOT NULL,
  `depart_ts` datetime NOT NULL,
  `airplane_id` int(11) NOT NULL,
  `arrival_ts` datetime NOT NULL,
  `depart_airport_code` int(11) NOT NULL,
  `arrival_airport_code` int(11) NOT NULL,
  `flight_status` varchar(30) DEFAULT NULL,
  `base_price` float(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `flights`
--

INSERT INTO `flights` (`airline_name`, `flight_number`, `depart_ts`, `airplane_id`, `arrival_ts`, `depart_airport_code`, `arrival_airport_code`, `flight_status`, `base_price`) VALUES
('American Airlines', 1, '2022-02-24 06:03:54', 105, '2022-02-24 11:03:54', 999, 888, 'Delayed', 4317.00),
('American Airlines', 2, '2022-02-10 22:41:16', 102, '2022-02-11 01:41:16', 555, 666, 'On-time', 5909.00),
('American Airlines', 3, '2021-12-22 05:13:42', 103, '2021-12-22 07:13:42', 111, 555, 'Delayed', 9812.00),
('American Airlines', 4, '2022-03-10 04:31:20', 103, '2022-03-10 16:31:20', 999, 222, 'Delayed', 6586.00),
('American Airlines', 5, '2022-01-04 19:54:36', 104, '2022-01-05 08:54:36', 555, 999, 'Delayed', 6357.00),
('American Airlines', 6, '2022-05-17 18:31:20', 101, '2022-05-18 04:31:20', 333, 888, 'On-time', 3223.00),
('American Airlines', 7, '2022-03-07 09:30:54', 102, '2022-03-07 20:30:54', 555, 888, 'Delayed', 8245.00),
('American Airlines', 8, '2022-03-29 07:05:07', 102, '2022-03-29 15:05:07', 111, 777, 'Delayed', 4739.00),
('American Airlines', 9, '2022-04-30 17:30:37', 102, '2022-05-01 00:30:37', 111, 666, 'Delayed', 3829.00),
('American Airlines', 10, '2021-12-19 00:09:03', 102, '2021-12-19 14:09:03', 888, 444, 'Delayed', 7639.00),
('American Airlines', 11, '2022-02-15 09:14:35', 103, '2022-02-15 20:14:35', 666, 111, 'On-time', 8912.00),
('American Airlines', 12, '2022-05-07 06:47:42', 104, '2022-05-07 08:47:42', 444, 555, 'On-time', 9603.00),
('American Airlines', 13, '2021-12-25 12:55:17', 100, '2021-12-25 13:55:17', 333, 555, 'Delayed', 3944.00),
('American Airlines', 14, '2022-05-19 13:02:12', 100, '2022-05-19 18:02:12', 111, 999, 'On-time', 1160.00),
('American Airlines', 15, '2022-03-18 14:35:48', 103, '2022-03-19 01:35:48', 111, 444, 'On-time', 3112.00),
('American Airlines', 16, '2022-05-07 04:17:12', 105, '2022-05-07 09:17:12', 333, 444, 'On-time', 5912.00),
('American Airlines', 17, '2022-05-12 14:01:45', 102, '2022-05-13 03:01:45', 999, 333, 'Delayed', 3551.00),
('American Airlines', 18, '2022-04-13 02:27:59', 102, '2022-04-13 03:27:59', 999, 222, 'On-time', 9212.00),
('American Airlines', 19, '2022-03-24 21:59:25', 101, '2022-03-24 23:59:25', 999, 666, 'On-time', 3450.00),
('American Airlines', 20, '2022-03-01 08:32:56', 104, '2022-03-01 18:32:56', 888, 777, 'On-time', 1498.00),
('American Airlines', 21, '2021-11-22 12:00:00', 102, '2021-11-22 18:00:00', 111, 444, 'On-Time', 1200.00),
('China Eastern', 21, '2022-02-07 18:45:11', 201, '2022-02-07 22:45:11', 111, 555, 'On-time', 4926.00),
('China Eastern', 22, '2021-12-11 02:18:22', 200, '2021-12-11 14:18:22', 555, 111, 'Delayed', 7330.00),
('China Eastern', 23, '2021-12-16 19:24:58', 205, '2021-12-17 05:24:58', 999, 777, 'Delayed', 5175.00),
('China Eastern', 24, '2022-03-02 15:50:48', 202, '2022-03-02 16:50:48', 444, 111, 'Delayed', 5088.00),
('China Eastern', 25, '2022-03-11 20:25:07', 204, '2022-03-12 01:25:07', 111, 999, 'On-time', 2533.00),
('China Eastern', 26, '2022-01-20 04:58:25', 201, '2022-01-20 07:58:25', 222, 888, 'On-time', 4005.00),
('China Eastern', 27, '2021-12-02 09:31:29', 203, '2021-12-02 10:31:29', 777, 333, 'On-time', 2736.00),
('China Eastern', 28, '2022-05-05 19:17:04', 201, '2022-05-06 06:17:04', 444, 888, 'On-time', 4784.00),
('China Eastern', 29, '2022-02-19 13:05:25', 201, '2022-02-19 22:05:25', 888, 444, 'Delayed', 9650.00),
('China Eastern', 30, '2022-02-15 14:16:15', 204, '2022-02-16 01:16:15', 666, 888, 'On-time', 7089.00),
('China Eastern', 31, '2022-03-29 22:19:12', 203, '2022-03-30 06:19:12', 111, 333, 'On-time', 8975.00),
('China Eastern', 32, '2022-01-02 21:08:32', 204, '2022-01-03 09:08:32', 444, 666, 'On-time', 6211.00),
('China Eastern', 33, '2022-05-08 02:40:54', 200, '2022-05-08 06:40:54', 999, 222, 'Delayed', 9514.00),
('China Eastern', 34, '2021-12-01 21:28:18', 204, '2021-12-02 00:28:18', 888, 444, 'Delayed', 5439.00),
('China Eastern', 35, '2022-02-06 07:57:06', 202, '2022-02-06 19:57:06', 444, 777, 'Delayed', 2587.00),
('China Eastern', 36, '2022-02-13 05:02:34', 202, '2022-02-13 09:02:34', 222, 666, 'Delayed', 2584.00),
('China Eastern', 37, '2022-04-11 04:29:06', 201, '2022-04-11 10:29:06', 333, 999, 'On-time', 2172.00),
('China Eastern', 38, '2022-03-02 16:28:34', 205, '2022-03-02 23:28:34', 333, 444, 'Delayed', 1514.00),
('China Eastern', 39, '2022-02-03 13:12:14', 204, '2022-02-03 22:12:14', 666, 999, 'Delayed', 270.00),
('China Eastern', 40, '2022-05-17 15:39:14', 200, '2022-05-17 17:39:14', 666, 333, 'Delayed', 8385.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `max_num_tickets`
-- (See below for the actual view)
--
CREATE TABLE `max_num_tickets` (
`flight_number` int(11)
,`max_num_tickets` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `purchased_num_ticket_by_flightnum`
-- (See below for the actual view)
--
CREATE TABLE `purchased_num_ticket_by_flightnum` (
`flight_number` int(11)
,`num_purchased` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `ticket_id` int(11) NOT NULL,
  `email` varchar(30) NOT NULL,
  `card_type` varchar(20) NOT NULL,
  `card_number` varchar(19) NOT NULL,
  `name_on_card` varchar(30) NOT NULL,
  `expiration_date` date NOT NULL,
  `purchase_ts` datetime NOT NULL,
  `sell_price` float(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`ticket_id`, `email`, `card_type`, `card_number`, `name_on_card`, `expiration_date`, `purchase_ts`, `sell_price`) VALUES
(1000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-04 06:03:54', 5223.00),
(1002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-04 06:03:54', 5940.00),
(1004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-04 06:03:54', 4634.00),
(1006, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-04 06:03:54', 5256.00),
(1009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-04 06:03:54', 5128.00),
(2001, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-21 22:41:16', 5045.00),
(2003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-21 22:41:16', 5015.00),
(2006, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-21 22:41:16', 5339.00),
(3000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-02 05:13:42', 5825.00),
(3001, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-02 05:13:42', 5253.00),
(3002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-02 05:13:42', 4629.00),
(3003, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-02 05:13:42', 5559.00),
(3004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-02 05:13:42', 5277.00),
(3005, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-02 05:13:42', 5829.00),
(3007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-02 05:13:42', 4494.00),
(3008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-02 05:13:42', 6065.00),
(3009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-02 05:13:42', 6305.00),
(4000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-18 04:31:20', 6091.00),
(4002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-18 04:31:20', 4518.00),
(4003, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-18 04:31:20', 4545.00),
(4005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-18 04:31:20', 4995.00),
(4006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-18 04:31:20', 6202.00),
(4007, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-18 04:31:20', 5259.00),
(5002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-15 19:54:36', 6101.00),
(5003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-12-15 19:54:36', 4924.00),
(5006, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-15 19:54:36', 5629.00),
(5009, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-12-15 19:54:36', 4752.00),
(6000, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-27 18:31:20', 4835.00),
(6001, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-27 18:31:20', 4622.00),
(6007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-27 18:31:20', 5244.00),
(6009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-27 18:31:20', 5593.00),
(7002, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-15 09:30:54', 5126.00),
(7005, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-15 09:30:54', 5280.00),
(7007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-15 09:30:54', 4991.00),
(7008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-15 09:30:54', 5861.00),
(8005, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 07:05:07', 4943.00),
(9001, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-10 17:30:37', 5531.00),
(9002, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-10 17:30:37', 5109.00),
(9007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-10 17:30:37', 5859.00),
(9008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-10 17:30:37', 5403.00),
(10000, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-29 00:09:03', 4484.00),
(10002, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-29 00:09:03', 5549.00),
(11000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-26 09:14:35', 6015.00),
(11001, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-26 09:14:35', 6688.00),
(11004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-26 09:14:35', 7480.00),
(11005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-26 09:14:35', 7878.00),
(11006, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-26 09:14:35', 7066.00),
(11007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-26 09:14:35', 7226.00),
(11008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-26 09:14:35', 7381.00),
(12004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-17 06:47:42', 6228.00),
(12008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-17 06:47:42', 6602.00),
(13000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-12-05 12:55:17', 7703.00),
(13001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-05 12:55:17', 6600.00),
(13002, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-05 12:55:17', 7681.00),
(13004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-05 12:55:17', 6021.00),
(13005, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-05 12:55:17', 6688.00),
(13006, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-05 12:55:17', 7291.00),
(13007, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-05 12:55:17', 6798.00),
(13008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-05 12:55:17', 6707.00),
(13009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-05 12:55:17', 7540.00),
(14000, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-29 13:02:12', 6797.00),
(14007, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-29 13:02:12', 6619.00),
(15000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-26 14:35:48', 7735.00),
(15003, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-26 14:35:48', 7225.00),
(15004, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-26 14:35:48', 6251.00),
(15006, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-26 14:35:48', 7520.00),
(15008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-26 14:35:48', 6185.00),
(15009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-26 14:35:48', 7359.00),
(16001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-17 04:17:12', 6413.00),
(16004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-17 04:17:12', 6031.00),
(16007, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-17 04:17:12', 6191.00),
(16009, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-17 04:17:12', 6226.00),
(17000, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-22 14:01:45', 7735.00),
(17001, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-22 14:01:45', 7206.00),
(17003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-22 14:01:45', 6037.00),
(17005, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-22 14:01:45', 6096.00),
(17007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-22 14:01:45', 7598.00),
(17009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-22 14:01:45', 6467.00),
(18003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-03-24 02:27:59', 7370.00),
(18004, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-24 02:27:59', 6098.00),
(18005, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-24 02:27:59', 6511.00),
(18006, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-03-24 02:27:59', 6440.00),
(19000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-03-04 21:59:25', 6799.00),
(19001, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-04 21:59:25', 7399.00),
(19002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-04 21:59:25', 6367.00),
(19003, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-04 21:59:25', 7076.00),
(19004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-04 21:59:25', 7207.00),
(19006, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-03-04 21:59:25', 7591.00),
(19007, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-04 21:59:25', 6309.00),
(19008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-04 21:59:25', 7059.00),
(20000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-09 08:32:56', 6788.00),
(20001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-09 08:32:56', 7041.00),
(20002, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-09 08:32:56', 6976.00),
(20004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-09 08:32:56', 7344.00),
(20007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-09 08:32:56', 6166.00),
(20008, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-09 08:32:56', 6273.00),
(21008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-18 18:45:11', 6525.00),
(22001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-21 02:18:22', 6332.00),
(22002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-11-21 02:18:22', 5839.00),
(22003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-21 02:18:22', 5946.00),
(22004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-21 02:18:22', 6413.00),
(22007, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-21 02:18:22', 5424.00),
(22008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-21 02:18:22', 7060.00),
(22009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-11-21 02:18:22', 6997.00),
(23002, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-26 19:24:58', 5991.00),
(23007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-26 19:24:58', 6814.00),
(23008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-11-26 19:24:58', 6105.00),
(24001, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 15:50:48', 6742.00),
(24002, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-10 15:50:48', 5564.00),
(24003, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 15:50:48', 6115.00),
(24004, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 15:50:48', 7000.00),
(24005, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 15:50:48', 5317.00),
(24006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-10 15:50:48', 5796.00),
(24007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 15:50:48', 5817.00),
(24008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 15:50:48', 5579.00),
(24009, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-10 15:50:48', 7114.00),
(25004, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-19 20:25:07', 6133.00),
(25005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-02-19 20:25:07', 5360.00),
(26001, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-31 04:58:25', 6756.00),
(26004, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-31 04:58:25', 5719.00),
(26005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-12-31 04:58:25', 5295.00),
(26007, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-12-31 04:58:25', 6413.00),
(26009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-12-31 04:58:25', 5311.00),
(27000, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-12 09:31:29', 6986.00),
(27004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-12 09:31:29', 6884.00),
(27005, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2021-11-12 09:31:29', 7061.00),
(27006, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-12 09:31:29', 6382.00),
(27007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-12 09:31:29', 6572.00),
(27008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-12 09:31:29', 5312.00),
(28001, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-15 19:17:04', 5343.00),
(29000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-30 13:05:25', 6183.00),
(29003, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-30 13:05:25', 6175.00),
(29004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-30 13:05:25', 5601.00),
(29006, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-30 13:05:25', 5622.00),
(29008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-30 13:05:25', 6070.00),
(30002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-26 14:16:15', 5365.00),
(30006, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-26 14:16:15', 6051.00),
(30008, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-26 14:16:15', 5669.00),
(30009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-26 14:16:15', 5896.00),
(31000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 22:19:12', 6558.00),
(31001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-09 22:19:12', 7055.00),
(31002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 22:19:12', 6891.00),
(31003, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 22:19:12', 5520.00),
(31004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-03-09 22:19:12', 5570.00),
(31005, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-03-09 22:19:12', 5605.00),
(31007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 22:19:12', 6638.00),
(31008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-09 22:19:12', 6128.00),
(31009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-09 22:19:12', 6508.00),
(32003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-12-13 21:08:32', 6008.00),
(32004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-12-13 21:08:32', 6252.00),
(33001, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-18 02:40:54', 6400.00),
(33003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-04-18 02:40:54', 6405.00),
(33004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-18 02:40:54', 5364.00),
(33008, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-18 02:40:54', 6729.00),
(33009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-04-18 02:40:54', 7003.00),
(34000, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-11 21:28:18', 5721.00),
(34001, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2021-11-11 21:28:18', 6264.00),
(34003, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-11 21:28:18', 6985.00),
(34004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-11 21:28:18', 5996.00),
(34005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-11 21:28:18', 5523.00),
(34006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2021-11-11 21:28:18', 6882.00),
(34008, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-11 21:28:18', 5539.00),
(34009, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2021-11-11 21:28:18', 5227.00),
(35002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-17 07:57:06', 5218.00),
(35003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-17 07:57:06', 5480.00),
(35006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-17 07:57:06', 5534.00),
(35009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-17 07:57:06', 5194.00),
(36001, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-24 05:02:34', 6874.00),
(36002, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-24 05:02:34', 6727.00),
(36003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-24 05:02:34', 6378.00),
(36004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-24 05:02:34', 7082.00),
(36006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-24 05:02:34', 5745.00),
(36009, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-24 05:02:34', 6869.00),
(37000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-22 04:29:06', 6041.00),
(37002, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-22 04:29:06', 6384.00),
(37003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-03-22 04:29:06', 5896.00),
(37004, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-22 04:29:06', 6725.00),
(37005, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-03-22 04:29:06', 5833.00),
(37007, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-03-22 04:29:06', 6873.00),
(37008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-03-22 04:29:06', 6978.00),
(38000, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-10 16:28:34', 6201.00),
(38001, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-02-10 16:28:34', 5446.00),
(38002, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 16:28:34', 5445.00),
(38003, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 16:28:34', 6782.00),
(38004, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 16:28:34', 6683.00),
(38007, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 16:28:34', 5662.00),
(38008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-02-10 16:28:34', 5209.00),
(38009, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-02-10 16:28:34', 6471.00),
(39004, 'andyhamilton@nyu.edu', '7128-4932-5578-1924', 'American Express', 'Andy', '2026-04-01', '2022-01-14 13:12:14', 5382.00),
(39005, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-01-14 13:12:14', 5603.00),
(39007, 'dummy@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Dummy', '2021-12-22', '2022-01-14 13:12:14', 6285.00),
(39008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-01-14 13:12:14', 6300.00),
(40000, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-27 15:39:14', 6200.00),
(40005, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-27 15:39:14', 5631.00),
(40006, 'jj2798@nyu.edu', '1111-1111-1111-1111', 'VISA', 'Jeremy', '2023-09-01', '2022-04-27 15:39:14', 5425.00),
(40007, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-27 15:39:14', 5642.00),
(40008, 'thisanemail@gmail.com', '0112-3581-3213-4558', 'MasterCard', 'Johnny', '2029-06-09', '2022-04-27 15:39:14', 5443.00);

--
-- Triggers `purchases`
--
DELIMITER $$
CREATE TRIGGER `update_price` AFTER INSERT ON `purchases` FOR EACH ROW BEGIN
		IF (SELECT COUNT(ticket_id) FROM purchases INNER JOIN ticket as T USING (ticket_id) WHERE T.flight_number = (SELECT flight_number FROM ticket WHERE ticket.ticket_id = NEW.ticket_id) GROUP BY T.flight_number) / (SELECT max_num_tickets FROM max_num_tickets as M WHERE M.flight_number = (SELECT flight_number FROM ticket WHERE ticket.ticket_id = NEW.ticket_id)) > 0.75 
		AND
		(SELECT DISTINCT price FROM ticket WHERE (SELECT flight_number FROM ticket WHERE ticket.ticket_id = NEW.ticket_id) = ticket.flight_number) = (SELECT base_price FROM flights WHERE (SELECT flight_number FROM ticket WHERE ticket.ticket_id = NEW.ticket_id) = flights.flight_number)
		THEN
    		UPDATE ticket
			SET price = 1.25 * price
			WHERE ticket.flight_number = (SELECT flight_number FROM ticket WHERE ticket.ticket_id = NEW.ticket_id);
		END IF;
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `email` varchar(30) NOT NULL,
  `airline_name` varchar(20) NOT NULL,
  `flight_number` int(11) NOT NULL,
  `depart_ts` datetime NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `comments` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`email`, `airline_name`, `flight_number`, `depart_ts`, `rating`, `comments`) VALUES
('andyhamilton@nyu.edu', 'American Airlines', 1, '2022-02-24 06:03:54', 2, 'I wanna go home. bing bong'),
('andyhamilton@nyu.edu', 'American Airlines', 3, '2021-12-22 05:13:42', 5, 'down bad'),
('andyhamilton@nyu.edu', 'American Airlines', 6, '2022-05-17 18:31:20', 9, 'good flight'),
('andyhamilton@nyu.edu', 'American Airlines', 7, '2022-03-07 09:30:54', 6, 'mad bumpy'),
('andyhamilton@nyu.edu', 'American Airlines', 13, '2021-12-25 12:55:17', 2, 'oh my god i cannot tell you more this was the best flight ever'),
('andyhamilton@nyu.edu', 'American Airlines', 18, '2022-04-13 02:27:59', 10, 'oh my god i cannot tell you more this was the best flight ever'),
('andyhamilton@nyu.edu', 'American Airlines', 20, '2022-03-01 08:32:56', 7, 'I wanna go home. bing bong'),
('andyhamilton@nyu.edu', 'China Eastern', 23, '2021-12-16 19:24:58', 3, 'I wanna go home. bing bong'),
('andyhamilton@nyu.edu', 'China Eastern', 24, '2022-03-02 15:50:48', 7, 'horrendous'),
('andyhamilton@nyu.edu', 'China Eastern', 30, '2022-02-15 14:16:15', 6, 'good flight'),
('andyhamilton@nyu.edu', 'China Eastern', 32, '2022-01-02 21:08:32', 5, 'horrendous'),
('andyhamilton@nyu.edu', 'China Eastern', 33, '2022-05-08 02:40:54', 4, 'chill'),
('andyhamilton@nyu.edu', 'China Eastern', 36, '2022-02-13 05:02:34', 2, 'horrendous'),
('andyhamilton@nyu.edu', 'China Eastern', 38, '2022-03-02 16:28:34', 8, 'Im never flying ever again'),
('andyhamilton@nyu.edu', 'China Eastern', 39, '2022-02-03 13:12:14', 9, 'I wanna go home. bing bong'),
('dummy@nyu.edu', 'American Airlines', 2, '2022-02-10 22:41:16', 7, 'Im never flying ever again'),
('dummy@nyu.edu', 'American Airlines', 4, '2022-03-10 04:31:20', 8, 'chill'),
('dummy@nyu.edu', 'American Airlines', 5, '2022-01-04 19:54:36', 10, 'horrendous'),
('dummy@nyu.edu', 'American Airlines', 11, '2022-02-15 09:14:35', 3, 'down bad'),
('dummy@nyu.edu', 'American Airlines', 13, '2021-12-25 12:55:17', 6, 'oh my god i cannot tell you more this was the best flight ever'),
('dummy@nyu.edu', 'American Airlines', 17, '2022-05-12 14:01:45', 7, 'mad bumpy'),
('dummy@nyu.edu', 'American Airlines', 18, '2022-04-13 02:27:59', 7, 'horrendous'),
('dummy@nyu.edu', 'American Airlines', 20, '2022-03-01 08:32:56', 8, 'down bad'),
('dummy@nyu.edu', 'China Eastern', 26, '2022-01-20 04:58:25', 2, 'horrendous'),
('dummy@nyu.edu', 'China Eastern', 30, '2022-02-15 14:16:15', 6, 'oh my god i cannot tell you more this was the best flight ever'),
('dummy@nyu.edu', 'China Eastern', 32, '2022-01-02 21:08:32', 1, 'horrendous'),
('dummy@nyu.edu', 'China Eastern', 34, '2021-12-01 21:28:18', 2, 'chill'),
('dummy@nyu.edu', 'China Eastern', 37, '2022-04-11 04:29:06', 10, 'mad bumpy'),
('dummy@nyu.edu', 'China Eastern', 38, '2022-03-02 16:28:34', 3, 'mad bumpy'),
('jj2798@nyu.edu', 'American Airlines', 3, '2021-12-22 05:13:42', 2, 'mad bumpy'),
('jj2798@nyu.edu', 'American Airlines', 4, '2022-03-10 04:31:20', 1, 'mad bumpy'),
('jj2798@nyu.edu', 'American Airlines', 6, '2022-05-17 18:31:20', 6, 'good flight'),
('jj2798@nyu.edu', 'American Airlines', 7, '2022-03-07 09:30:54', 1, 'good flight'),
('jj2798@nyu.edu', 'American Airlines', 11, '2022-02-15 09:14:35', 7, 'down bad'),
('jj2798@nyu.edu', 'American Airlines', 12, '2022-05-07 06:47:42', 3, 'horrendous'),
('jj2798@nyu.edu', 'American Airlines', 13, '2021-12-25 12:55:17', 9, 'down bad'),
('jj2798@nyu.edu', 'American Airlines', 14, '2022-05-19 13:02:12', 6, 'horrendous'),
('jj2798@nyu.edu', 'American Airlines', 19, '2022-03-24 21:59:25', 10, 'I wanna go home. bing bong'),
('jj2798@nyu.edu', 'American Airlines', 20, '2022-03-01 08:32:56', 10, 'good flight'),
('jj2798@nyu.edu', 'China Eastern', 21, '2022-02-07 18:45:11', 5, 'good flight'),
('jj2798@nyu.edu', 'China Eastern', 22, '2021-12-11 02:18:22', 8, 'good flight'),
('jj2798@nyu.edu', 'China Eastern', 24, '2022-03-02 15:50:48', 8, 'mad bumpy'),
('jj2798@nyu.edu', 'China Eastern', 27, '2021-12-02 09:31:29', 4, 'I wanna go home. bing bong'),
('jj2798@nyu.edu', 'China Eastern', 29, '2022-02-19 13:05:25', 8, 'Im never flying ever again'),
('jj2798@nyu.edu', 'China Eastern', 35, '2022-02-06 07:57:06', 8, 'down bad'),
('jj2798@nyu.edu', 'China Eastern', 36, '2022-02-13 05:02:34', 10, 'oh my god i cannot tell you more this was the best flight ever'),
('jj2798@nyu.edu', 'China Eastern', 37, '2022-04-11 04:29:06', 4, 'chill'),
('jj2798@nyu.edu', 'China Eastern', 40, '2022-05-17 15:39:14', 10, 'mad bumpy'),
('thisanemail@gmail.com', 'American Airlines', 3, '2021-12-22 05:13:42', 4, 'Im never flying ever again'),
('thisanemail@gmail.com', 'American Airlines', 5, '2022-01-04 19:54:36', 5, 'I wanna go home. bing bong'),
('thisanemail@gmail.com', 'American Airlines', 9, '2022-04-30 17:30:37', 3, 'chill'),
('thisanemail@gmail.com', 'American Airlines', 13, '2021-12-25 12:55:17', 6, 'mad bumpy'),
('thisanemail@gmail.com', 'American Airlines', 18, '2022-04-13 02:27:59', 8, 'oh my god i cannot tell you more this was the best flight ever'),
('thisanemail@gmail.com', 'American Airlines', 20, '2022-03-01 08:32:56', 9, 'I wanna go home. bing bong'),
('thisanemail@gmail.com', 'China Eastern', 22, '2021-12-11 02:18:22', 9, 'I wanna go home. bing bong'),
('thisanemail@gmail.com', 'China Eastern', 23, '2021-12-16 19:24:58', 6, 'chill'),
('thisanemail@gmail.com', 'China Eastern', 24, '2022-03-02 15:50:48', 2, 'mad bumpy'),
('thisanemail@gmail.com', 'China Eastern', 29, '2022-02-19 13:05:25', 10, 'chill'),
('thisanemail@gmail.com', 'China Eastern', 36, '2022-02-13 05:02:34', 8, 'mad bumpy'),
('thisanemail@gmail.com', 'China Eastern', 37, '2022-04-11 04:29:06', 3, 'down bad'),
('thisanemail@gmail.com', 'China Eastern', 38, '2022-03-02 16:28:34', 8, 'horrendous'),
('thisanemail@gmail.com', 'China Eastern', 39, '2022-02-03 13:12:14', 1, 'I wanna go home. bing bong');

-- --------------------------------------------------------

--
-- Table structure for table `staff_phone`
--

CREATE TABLE `staff_phone` (
  `username` varchar(30) NOT NULL,
  `phone_number` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `staff_phone`
--

INSERT INTO `staff_phone` (`username`, `phone_number`) VALUES
('steve_block', '202-555-0155'),
('steve_block', '202-555-0176');

-- --------------------------------------------------------

--
-- Table structure for table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `airline_name` varchar(20) NOT NULL,
  `flight_number` int(11) NOT NULL,
  `depart_ts` datetime NOT NULL,
  `price` float(6,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `airline_name`, `flight_number`, `depart_ts`, `price`) VALUES
(1000, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1001, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1002, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1003, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1004, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1005, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1006, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1007, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1008, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(1009, 'American Airlines', 1, '2022-02-24 06:03:54', 4317.00),
(2000, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2001, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2002, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2003, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2004, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2005, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2006, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2007, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2008, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(2009, 'American Airlines', 2, '2022-02-10 22:41:16', 5909.00),
(3000, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3001, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3002, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3003, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3004, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3005, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3006, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3007, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3008, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(3009, 'American Airlines', 3, '2021-12-22 05:13:42', 9999.99),
(4000, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4001, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4002, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4003, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4004, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4005, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4006, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4007, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4008, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(4009, 'American Airlines', 4, '2022-03-10 04:31:20', 6586.00),
(5000, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5001, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5002, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5003, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5004, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5005, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5006, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5007, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5008, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(5009, 'American Airlines', 5, '2022-01-04 19:54:36', 6357.00),
(6000, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6001, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6002, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6003, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6004, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6005, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6006, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6007, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6008, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(6009, 'American Airlines', 6, '2022-05-17 18:31:20', 3223.00),
(7000, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7001, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7002, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7003, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7004, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7005, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7006, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7007, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7008, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(7009, 'American Airlines', 7, '2022-03-07 09:30:54', 8245.00),
(8000, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8001, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8002, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8003, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8004, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8005, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8006, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8007, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8008, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(8009, 'American Airlines', 8, '2022-03-29 07:05:07', 4739.00),
(9000, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9001, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9002, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9003, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9004, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9005, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9006, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9007, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9008, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(9009, 'American Airlines', 9, '2022-04-30 17:30:37', 3829.00),
(10000, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10001, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10002, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10003, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10004, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10005, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10006, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10007, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10008, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(10009, 'American Airlines', 10, '2021-12-19 00:09:03', 7639.00),
(11000, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11001, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11002, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11003, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11004, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11005, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11006, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11007, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11008, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(11009, 'American Airlines', 11, '2022-02-15 09:14:35', 8912.00),
(12000, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12001, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12002, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12003, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12004, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12005, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12006, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12007, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12008, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(12009, 'American Airlines', 12, '2022-05-07 06:47:42', 9603.00),
(13000, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13001, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13002, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13003, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13004, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13005, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13006, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13007, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13008, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(13009, 'American Airlines', 13, '2021-12-25 12:55:17', 4930.00),
(14000, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14001, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14002, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14003, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14004, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14005, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14006, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14007, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14008, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(14009, 'American Airlines', 14, '2022-05-19 13:02:12', 1160.00),
(15000, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15001, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15002, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15003, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15004, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15005, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15006, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15007, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15008, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(15009, 'American Airlines', 15, '2022-03-18 14:35:48', 3112.00),
(16000, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16001, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16002, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16003, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16004, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16005, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16006, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16007, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16008, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(16009, 'American Airlines', 16, '2022-05-07 04:17:12', 5912.00),
(17000, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17001, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17002, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17003, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17004, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17005, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17006, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17007, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17008, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(17009, 'American Airlines', 17, '2022-05-12 14:01:45', 3551.00),
(18000, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18001, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18002, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18003, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18004, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18005, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18006, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18007, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18008, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(18009, 'American Airlines', 18, '2022-04-13 02:27:59', 9212.00),
(19000, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19001, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19002, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19003, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19004, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19005, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19006, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19007, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19008, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(19009, 'American Airlines', 19, '2022-03-24 21:59:25', 4312.50),
(20000, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20001, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20002, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20003, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20004, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20005, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20006, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20007, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20008, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(20009, 'American Airlines', 20, '2022-03-01 08:32:56', 1498.00),
(21000, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21001, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21002, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21003, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21004, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21005, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21006, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21007, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21008, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(21009, 'China Eastern', 21, '2022-02-07 18:45:11', 4926.00),
(22000, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22001, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22002, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22003, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22004, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22005, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22006, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22007, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22008, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(22009, 'China Eastern', 22, '2021-12-11 02:18:22', 7330.00),
(23000, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23001, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23002, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23003, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23004, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23005, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23006, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23007, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23008, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(23009, 'China Eastern', 23, '2021-12-16 19:24:58', 5175.00),
(24000, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24001, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24002, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24003, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24004, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24005, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24006, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24007, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24008, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(24009, 'China Eastern', 24, '2022-03-02 15:50:48', 6360.00),
(25000, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25001, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25002, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25003, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25004, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25005, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25006, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25007, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25008, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(25009, 'China Eastern', 25, '2022-03-11 20:25:07', 2533.00),
(26000, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26001, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26002, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26003, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26004, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26005, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26006, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26007, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26008, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(26009, 'China Eastern', 26, '2022-01-20 04:58:25', 4005.00),
(27000, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27001, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27002, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27003, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27004, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27005, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27006, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27007, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27008, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(27009, 'China Eastern', 27, '2021-12-02 09:31:29', 2736.00),
(28000, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28001, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28002, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28003, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28004, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28005, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28006, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28007, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28008, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(28009, 'China Eastern', 28, '2022-05-05 19:17:04', 4784.00),
(29000, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29001, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29002, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29003, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29004, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29005, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29006, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29007, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29008, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(29009, 'China Eastern', 29, '2022-02-19 13:05:25', 9650.00),
(30000, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30001, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30002, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30003, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30004, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30005, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30006, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30007, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30008, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(30009, 'China Eastern', 30, '2022-02-15 14:16:15', 7089.00),
(31000, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31001, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31002, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31003, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31004, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31005, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31006, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31007, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31008, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(31009, 'China Eastern', 31, '2022-03-29 22:19:12', 9999.99),
(32000, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32001, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32002, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32003, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32004, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32005, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32006, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32007, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32008, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(32009, 'China Eastern', 32, '2022-01-02 21:08:32', 6211.00),
(33000, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33001, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33002, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33003, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33004, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33005, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33006, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33007, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33008, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(33009, 'China Eastern', 33, '2022-05-08 02:40:54', 9514.00),
(34000, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34001, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34002, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34003, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34004, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34005, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34006, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34007, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34008, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(34009, 'China Eastern', 34, '2021-12-01 21:28:18', 6798.75),
(35000, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35001, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35002, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35003, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35004, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35005, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35006, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35007, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35008, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(35009, 'China Eastern', 35, '2022-02-06 07:57:06', 2587.00),
(36000, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36001, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36002, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36003, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36004, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36005, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36006, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36007, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36008, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(36009, 'China Eastern', 36, '2022-02-13 05:02:34', 2584.00),
(37000, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37001, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37002, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37003, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37004, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37005, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37006, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37007, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37008, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(37009, 'China Eastern', 37, '2022-04-11 04:29:06', 2172.00),
(38000, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38001, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38002, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38003, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38004, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38005, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38006, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38007, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38008, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(38009, 'China Eastern', 38, '2022-03-02 16:28:34', 1892.50),
(39000, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39001, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39002, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39003, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39004, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39005, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39006, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39007, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39008, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(39009, 'China Eastern', 39, '2022-02-03 13:12:14', 270.00),
(40000, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40001, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40002, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40003, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40004, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40005, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40006, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40007, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40008, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00),
(40009, 'China Eastern', 40, '2022-05-17 15:39:14', 8385.00);

-- --------------------------------------------------------

--
-- Table structure for table `works_for`
--

CREATE TABLE `works_for` (
  `username` varchar(30) NOT NULL,
  `airline_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `works_for`
--

INSERT INTO `works_for` (`username`, `airline_name`) VALUES
('jj2798', 'American Airlines'),
('joe', 'China Eastern'),
('steve_block', 'China Eastern');

-- --------------------------------------------------------

--
-- Structure for view `available_tickets`
--
DROP TABLE IF EXISTS `available_tickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `available_tickets`  AS SELECT `ticket`.`ticket_id` AS `ticket_id`, `ticket`.`airline_name` AS `airline_name`, `ticket`.`flight_number` AS `flight_number`, `ticket`.`depart_ts` AS `depart_ts`, `ticket`.`price` AS `price` FROM `ticket` WHERE !(`ticket`.`ticket_id` in (select `purchases`.`ticket_id` from `purchases`)) ;

-- --------------------------------------------------------

--
-- Structure for view `max_num_tickets`
--
DROP TABLE IF EXISTS `max_num_tickets`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `max_num_tickets`  AS SELECT `ticket`.`flight_number` AS `flight_number`, count(`ticket`.`ticket_id`) AS `max_num_tickets` FROM `ticket` GROUP BY `ticket`.`flight_number` ;

-- --------------------------------------------------------

--
-- Structure for view `purchased_num_ticket_by_flightnum`
--
DROP TABLE IF EXISTS `purchased_num_ticket_by_flightnum`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `purchased_num_ticket_by_flightnum`  AS SELECT `ticket`.`flight_number` AS `flight_number`, count(`purchases`.`ticket_id`) AS `num_purchased` FROM (`purchases` join `ticket` on(`purchases`.`ticket_id` = `ticket`.`ticket_id`)) GROUP BY `ticket`.`flight_number` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `airline`
--
ALTER TABLE `airline`
  ADD PRIMARY KEY (`airline_name`);

--
-- Indexes for table `airline_staff`
--
ALTER TABLE `airline_staff`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `airplane`
--
ALTER TABLE `airplane`
  ADD PRIMARY KEY (`airplane_id`,`airline_name`),
  ADD KEY `airline_name` (`airline_name`);

--
-- Indexes for table `airport`
--
ALTER TABLE `airport`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `flights`
--
ALTER TABLE `flights`
  ADD PRIMARY KEY (`airline_name`,`flight_number`,`depart_ts`),
  ADD KEY `airplane_id` (`airplane_id`),
  ADD KEY `depart_airport_code` (`depart_airport_code`),
  ADD KEY `arrival_airport_code` (`arrival_airport_code`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `email` (`email`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`email`,`airline_name`,`flight_number`,`depart_ts`),
  ADD KEY `airline_name` (`airline_name`,`flight_number`,`depart_ts`);

--
-- Indexes for table `staff_phone`
--
ALTER TABLE `staff_phone`
  ADD PRIMARY KEY (`username`,`phone_number`);

--
-- Indexes for table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `airline_name` (`airline_name`,`flight_number`,`depart_ts`);

--
-- Indexes for table `works_for`
--
ALTER TABLE `works_for`
  ADD PRIMARY KEY (`username`),
  ADD KEY `airline_name` (`airline_name`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `airplane`
--
ALTER TABLE `airplane`
  ADD CONSTRAINT `airplane_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`airline_name`);

--
-- Constraints for table `flights`
--
ALTER TABLE `flights`
  ADD CONSTRAINT `flights_ibfk_1` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`airline_name`),
  ADD CONSTRAINT `flights_ibfk_2` FOREIGN KEY (`airplane_id`) REFERENCES `airplane` (`airplane_id`),
  ADD CONSTRAINT `flights_ibfk_3` FOREIGN KEY (`depart_airport_code`) REFERENCES `airport` (`code`),
  ADD CONSTRAINT `flights_ibfk_4` FOREIGN KEY (`arrival_airport_code`) REFERENCES `airport` (`code`);

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`),
  ADD CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`email`) REFERENCES `customer` (`email`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`email`) REFERENCES `customer` (`email`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`airline_name`,`flight_number`,`depart_ts`) REFERENCES `flights` (`airline_name`, `flight_number`, `depart_ts`);

--
-- Constraints for table `staff_phone`
--
ALTER TABLE `staff_phone`
  ADD CONSTRAINT `staff_phone_ibfk_1` FOREIGN KEY (`username`) REFERENCES `airline_staff` (`username`);

--
-- Constraints for table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`airline_name`,`flight_number`,`depart_ts`) REFERENCES `flights` (`airline_name`, `flight_number`, `depart_ts`);

--
-- Constraints for table `works_for`
--
ALTER TABLE `works_for`
  ADD CONSTRAINT `works_for_ibfk_1` FOREIGN KEY (`username`) REFERENCES `airline_staff` (`username`),
  ADD CONSTRAINT `works_for_ibfk_2` FOREIGN KEY (`airline_name`) REFERENCES `airline` (`airline_name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
