/*
3. Write and execute INSERT statements to insert data representing one airline's air ticket reservation
system. As for example, you can insert data in the appropriate tables as follows or you can insert data
for other airline or your own make up airline:
a. One Airline name "China Eastern".
b. At least Two airports named "JFK" in NYC and "PVG" in Shanghai.
c. Insert at least three customers with appropriate names and other attributes.
d. Insert at least three airplanes.
e. Insert At least One airline Staff working for China Eastern.
f. Insert several flights with on-time, and delayed statuses.
g. Insert some tickets for corresponding flights and insert some purchase records (customers
bought some tickets).
*/

/*a) One Airline name "China Eastern".*/
INSERT INTO Airline VALUES("China Eastern");
INSERT INTO Airline VALUES("American Airlines");

/*b) At least Two airports named "JFK" in NYC and "PVG" in Shanghai.*/
INSERT INTO Airport VALUES(111, "JFK", "New York City");
INSERT INTO Airport VALUES(222, "PVG", "Shanghai");

/*c) Insert at least three customers with appropriate names and other attributes.*/
INSERT INTO Customer VALUES("jj2798@nyu.edu", "Jeremy Jang", "incorrect", 111, "Somestreet", "New York", "408-123-4567", "P-111", '2023-06-01', "USA", '2000-12-25');
INSERT INTO Customer VALUES("thisanemail@gmail.com", "Johnny Boy", "hellomynameisjohnny", 122, "Anotherstreet", "San Jose", "408-891-0111", "P-213", '2026-02-01', "USA", '2007-10-02');
INSERT INTO Customer VALUES("andyhamilton@nyu.edu", "Andy Hamilton", "money", 116, "wallstreet", "New York", "621-141-5161", "P-718", '2023-06-01', "USA", '1952-11-03');

/*d) Insert at least three airplanes.*/
INSERT INTO Airplane VALUES("China Eastern", 100, 300);
INSERT INTO Airplane VALUES("American Airlines", 200, 10);
INSERT INTO Airplane VALUES("American Airlines", 201, 10);

/*e) Insert At least One airline Staff working for China Eastern.*/
INSERT INTO Airline_Staff VALUES("steve_block", "dedicatedram", "Steve", "Block", 2009-05-16);
INSERT INTO WORKS_FOR VALUES("steve_block", "China Eastern");
INSERT INTO Staff_Phone VALUES("steve_block", "202-555-0155")
INSERT INTO Staff_Phone VALUES("steve_block", "202-555-0176")

/*f) Insert several flights with on-time, and delayed statuses.*/
INSERT INTO Flights VALUES("China Eastern", 1, '2021-11-10 22:41:00', 100, '2021-11-20 20:30:00', 222, 111, "Delayed", 1850.00);
INSERT INTO Flights VALUES("American Airlines", 2, '2021-12-23 22:00:00', 200, '2021-12-24 12:30:00', 111, 222, "On-time", 2500.00);
INSERT INTO Flights VALUES("China Eastern", 3, '2023-05-23 14:00:00', 100, '2023-05-26 20:30:00', 111, 222, "On-time", 4000.00);

/*g) Insert some tickets for corresponding flights and insert some purchase records (customers
bought some tickets).*/
INSERT INTO Ticket VALUES(1000, "China Eastern", 1, '2021-11-10 22:41:00');
INSERT INTO Ticket VALUES(1001, "China Eastern", 1, '2021-11-10 22:41:00');
INSERT INTO Ticket VALUES(1002, "China Eastern", 1, '2021-11-10 22:41:00');
INSERT INTO Ticket VALUES(1003, "China Eastern", 1, '2021-11-10 22:41:00');
INSERT INTO Ticket VALUES(1004, "China Eastern", 1, '2021-11-10 22:41:00');
INSERT INTO Ticket VALUES(2000, "American Airlines", 2, '2021-12-23 22:00:00');
INSERT INTO Ticket VALUES(2001, "American Airlines", 2, '2021-12-23 22:00:00');
INSERT INTO Ticket VALUES(2002, "American Airlines", 2, '2021-12-23 22:00:00');
INSERT INTO Ticket VALUES(2003, "American Airlines", 2, '2021-12-23 22:00:00');
INSERT INTO Ticket VALUES(2004, "American Airlines", 2, '2021-12-23 22:00:00');
INSERT INTO Ticket VALUES(3000, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3001, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3002, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3003, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3004, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3005, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3006, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3007, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3008, "China Eastern", 3, '2023-05-23 14:00:00');
INSERT INTO Ticket VALUES(3009, "China Eastern", 3, '2023-05-23 14:00:00');

INSERT INTO Purchases VALUES(1000, "jj2798@nyu.edu", "VISA", "1111-1111-1111-1111", '2023-09-01', '2021-11-10 23:06:00', 2121.00)
INSERT INTO Purchases VALUES(2003, "jj2798@nyu.edu", "VISA", "1111-1111-1111-1111", '2023-09-01', '2021-12-01 23:06:00', 2000.00)
INSERT INTO Purchases VALUES(1001, "thisanemail@gmail.com", "MasterCard", "0112-3581-3213-4558", '2029-06-09', '2021-11-10 23:06:00', 2121.00)
INSERT INTO Purchases VALUES(2002, "thisanemail@gmail.com", "MasterCard", "0112-3581-3213-4558", '2029-06-09', '2020-05-08 14:00:00', 1000.00)
INSERT INTO Purchases VALUES(1002, "thisanemail@gmail.com", "MasterCard", "0112-3581-3213-4558", '2029-06-09', '2020-06-12 12:00:00', 200.00)
INSERT INTO Purchases VALUES(3004, "andyhamilton@nyu.edu", "American Express", "7128-4932-5578-1924", '2026-04-01', '2021-12-25 06:00:00', 9999.99)
INSERT INTO Purchases VALUES(3005, "andyhamilton@nyu.edu", "American Express", "7128-4932-5578-1924", '2026-04-01', '2021-12-25 06:00:00', 9999.99)
INSERT INTO Purchases VALUES(3006, "andyhamilton@nyu.edu", "American Express", "7128-4932-5578-1924", '2026-04-01', '2021-12-25 06:00:00', 9999.99)
INSERT INTO Purchases VALUES(3007, "andyhamilton@nyu.edu", "American Express", "7128-4932-5578-1924", '2026-04-01', '2021-12-25 06:00:00', 9999.99)


