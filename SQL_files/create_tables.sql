/*
NOT SURE IF ARROW FOR EMAIL BETWEEN REVIEWS AND CUSTOMER SHOULD BE IN OTHER ORDER
IF SO ITS MY BAD SINCE I WAS RESPONSIBLE FOR THAT PART
*/
CREATE TABLE Customer(
    email VARCHAR(30),
    customer_name VARCHAR(30),
    customer_password VARCHAR(300),
    building_number INT,
    street VARCHAR(30),
    city VARCHAR(30),
    phone_number VARCHAR(12),
    passport_number VARCHAR(20),
    passport_expiration DATE,
    passport_country VARCHAR(30),
    date_of_birth DATE,
    PRIMARY KEY(email)
);

CREATE TABLE Flights(
    airline_name VARCHAR(20),
    flight_number INT,
    depart_date DATE,
    depart_time DATETIME,
    airplane_id INT,
    arrival_date DATE,
    arrival_time DATETIME,
    depart_airport_code INT,
    arrival_airport_code INT,
    base_price FLOAT(6,2),  
    PRIMARY KEY(airline_name, flight_number, depart_date, depart_time)
);

CREATE TABLE Airport(
    code INT,
    airport_name VARCHAR(30),
    city VARCHAR(30),
    PRIMARY KEY(code),    
);

CREATE TABLE Purchases(
    ticket_id INT,
    email VARCHAR(30),
    FOREIGN KEY(ticket_id) REFERENCES Ticket,
);

CREATE TABLE Ticket(
    ticket_id INT,
    airline_name VARCHAR(20),
    flight_number INT,
    depart_date DATE,
    depart_time DATETIME,
    card_type VARCHAR(20),
    card_number INT,
    name_on_card VARCHAR(30)
    expiration_date DATE,
    purchase_date DATE,
    purchase_time, DATETIME,
    sell_price FLOAT(6,2),
    PRIMARY KEY(ticket_id),
    FOREIGN KEY(airline_name, flight_number, depart_date, depart_time) REFERENCES Flights
);

CREATE TABLE Staff_Phone(
    username VARCHAR(30),
    phone_number VARCHAR(12)
);

CREATE TABLE Airline_Staff(
    username VARCHAR(30),
    staff_password VARCHAR(300),
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    date_of_birth DATE
);

CREATE TABLE Works_For(
    username VARCHAR(30),
    phone_number VARCHAR(12)
);

CREATE TABLE Airline(
    airline_name VARCHAR(20)
    PRIMARY KEY(airline_name)
);

CREATE TABLE Airplane(
    airline_name VARCHAR(20),
    airplane_id INT,
    num_seats INT,
    PRIMARY KEY(airplane_id),
    FOREIGN KEY(airplane_name) REFERENCES Airline
);

CREATE TABLE Reviews(
    email VARCHAR(30)
    airline_name VARCHAR(20),
    flight_number INT,
    depart_date DATE,
    depart_time DATETIME,
    rating INT,
    comments VARCHAR(100),
    FOREIGN KEY(email) REFERENCES Customer,
    FOREIGN KEY(airline_name, flight_number, depart_date, depart_time) REFERENCES Flights
);