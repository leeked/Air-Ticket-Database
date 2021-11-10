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
INSERT INTO Customer VALUES("jj2798@nyu.edu", "Jeremy Jang", "incorrect", 111, "Somestreet", "New York", "408-123-4567", "P-111", 2023-06-01, "USA", 2000-12-25);
INSERT INTO Customer VALUES("thisanemail@gmail.com", "Johnny Boy", "hellomynameisjohnny", 122, "Anotherstreet", "San Jose", "408-891-0111", "P-213", 2026-02-01, "USA", 2007-10-02);
INSERT INTO Customer VALUES("jj2798@nyu.edu", "Jeremy Jang", "incorrect", 111, "Somestreet", "New York", "408-123-4567", "P-111", 2023-06-01, "USA", 2000-12-25);

/*d) Insert at least three airplanes.*/
INSERT INTO Airplane VALUES("China Eastern", 100, 300);
INSERT INTO Airplane VALUES("American Airlines", 200, 10);
INSERT INTO Airplane VALUES("American Airlines", 201, 10);


/*e) Insert At least One airline Staff working for China Eastern.*/
INSERT INTO Airline VALUES("China Eastern");

/*f) Insert several flights with on-time, and delayed statuses.*/
INSERT INTO Airline VALUES("China Eastern");

/*g) Insert some tickets for corresponding flights and insert some purchase records (customers
bought some tickets).*/
INSERT INTO Airline VALUES("China Eastern");
