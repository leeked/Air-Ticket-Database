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
    PRIMARY KEY email
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
    base_price FLOAT(6,2)  
);

CREATE TABLE Airport(
    code INT,
    airport_name VARCHAR(30),
    city VARCHAR(30)    
);

CREATE TABLE Purchases(
    ticket_id INT,
    email VARCHAR(30)
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
    sell_price FLOAT(6,2)
);