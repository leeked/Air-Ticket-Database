-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2021 at 11:12 PM
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
('alexblock', '0a840ef45467fb3932dbf2c2896c5cbf', 'Alex', 'Block', '2021-11-02'),
('enderman', '14511f2f5564650d129ca7cabc333278', 'ender', 'man', '2021-11-25'),
('steve_block', 'dedicatedram', 'Steve', 'Block', '2009-05-16'),
('test', '098f6bcd4621d373cade4e832627b4f6', 'Testing', 'Dummy', '2021-12-09'),
('test2', '098f6bcd4621d373cade4e832627b4f6', 'Testing2', 'Dummy', '2021-12-13'),
('xsstest&amp;', '202cb962ac59075b964b07152d234b70', 'Kevin&amp;', 'Lee&gt;', '2021-12-20');

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
('China Eastern', 100, 300),
('American Airlines', 200, 10),
('American Airlines', 201, 10);

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
(222, 'PVG', 'Shanghai');

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
('andyhamilton@nyu.edu', 'Andy Hamilton', 'money', 116, 'wallstreet', 'New York', 'New York', '621-141-5161', 'P-718', '2023-06-01', 'USA', '1952-11-03'),
('dummy@nyu.edu', 'Dummy Thicc', '275876e34cf609db118f3d84b799a790', 412, '7th Street', 'New York', 'New York', '123-456-7890', 'P-472', '2021-11-16', 'Venezuela', '2021-11-21'),
('jj2798@nyu.edu', 'Jeremy Jang', '6119442a08276dbb22e918c3d85c1c6e', 111, 'Somestreet', 'New York', 'New York', '408-123-4567', 'P-111', '2023-06-01', 'USA', '2000-12-25'),
('thisanemail@gmail.com', 'Johnny Boy', 'hellomynameisjohnny', 122, 'Anotherstreet', 'San Jose', 'California', '408-891-0111', 'P-213', '2026-02-01', 'USA', '2007-10-02');

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
('American Airlines', 2, '2021-12-23 22:00:00', 200, '2021-12-24 12:30:00', 111, 222, 'On-time', 2500.00),
('China Eastern', 1, '2021-11-10 22:41:00', 100, '2021-11-20 20:30:00', 222, 111, 'Delayed', 1850.00),
('China Eastern', 3, '2023-05-23 14:00:00', 100, '2023-05-26 20:30:00', 111, 222, 'On-time', 4000.00);

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
(1000, 'jj2798@nyu.edu', 'VISA', '1111-1111-1111-1111', 'Jeremy', '2023-09-01', '2021-11-10 23:06:00', 2121.00),
(1001, 'thisanemail@gmail.com', 'MasterCard', '0112-3581-3213-4558', 'Johnny', '2029-06-09', '2021-11-10 23:06:00', 2121.00),
(1002, 'thisanemail@gmail.com', 'MasterCard', '0112-3581-3213-4558', 'Johnny', '2029-06-09', '2020-06-12 12:00:00', 200.00),
(1003, 'dummy@nyu.edu', 'VISA', '1111-1111-1111-1111', 'dummy', '2021-12-30', '2021-12-01 15:27:17', 1850.00),
(2000, 'dummy@nyu.edu', 'VISA', '1111-1111-1111-1111', 'dummy', '2023-12-26', '2021-12-01 02:04:39', 2500.00),
(2001, 'dummy@nyu.edu', 'VISA', '1111-1111-1111-1111', 'dummy', '2021-12-22', '2021-12-01 12:03:41', 2500.00),
(2002, 'thisanemail@gmail.com', 'MasterCard', '0112-3581-3213-4558', 'Johnny', '2029-06-09', '2020-05-08 14:00:00', 1000.00),
(2003, 'jj2798@nyu.edu', 'VISA', '1111-1111-1111-1111', 'Jermie', '2023-09-01', '2021-12-01 23:06:00', 2000.00),
(2004, 'dummy@nyu.edu', 'VISA', '1111-1111-1111-1111', 'dummy', '2021-12-23', '2021-12-01 12:04:07', 3125.00),
(3004, 'andyhamilton@nyu.edu', 'American Express', '7128-4932-5578-1924', 'Andy Hamilton', '2026-04-01', '2021-12-25 06:00:00', 9999.99),
(3005, 'andyhamilton@nyu.edu', 'American Express', '7128-4932-5578-1924', 'Andy Hamilton', '2026-04-01', '2021-12-25 06:00:00', 9999.99),
(3006, 'andyhamilton@nyu.edu', 'American Express', '7128-4932-5578-1924', 'Andy Hamilton', '2026-04-01', '2021-12-25 06:00:00', 9999.99),
(3007, 'andyhamilton@nyu.edu', 'American Express', '7128-4932-5578-1924', 'Andy Hamilton', '2026-04-01', '2021-12-25 06:00:00', 9999.99);

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
('dummy@nyu.edu', 'China Eastern', 1, '2021-11-10 22:41:00', 8, 'it was aight');

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
(1000, 'China Eastern', 1, '2021-11-10 22:41:00', 2312.50),
(1001, 'China Eastern', 1, '2021-11-10 22:41:00', 2312.50),
(1002, 'China Eastern', 1, '2021-11-10 22:41:00', 2312.50),
(1003, 'China Eastern', 1, '2021-11-10 22:41:00', 2312.50),
(1004, 'China Eastern', 1, '2021-11-10 22:41:00', 2312.50),
(2000, 'American Airlines', 2, '2021-12-23 22:00:00', 3125.00),
(2001, 'American Airlines', 2, '2021-12-23 22:00:00', 3125.00),
(2002, 'American Airlines', 2, '2021-12-23 22:00:00', 3125.00),
(2003, 'American Airlines', 2, '2021-12-23 22:00:00', 3125.00),
(2004, 'American Airlines', 2, '2021-12-23 22:00:00', 3125.00),
(3000, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3001, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3002, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3003, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3004, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3005, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3006, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3007, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3008, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00),
(3009, 'China Eastern', 3, '2023-05-23 14:00:00', 4000.00);

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
('test', 'American Airlines'),
('steve_block', 'China Eastern'),
('test2', 'China Eastern');

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
