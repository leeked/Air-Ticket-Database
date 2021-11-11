CREATE TABLE Customer(
    email VARCHAR(60),
    customer_name VARCHAR(30) not null,
    customer_password VARCHAR(300) not null,
    addr_building_number INT,
    addr_street VARCHAR(30),
    addr_city VARCHAR(30),
    addr_state VARCHAR(30),
    phone_number VARCHAR(12) not null,
    passport_number VARCHAR(20) not null,
    passport_expiration DATE not null,
    passport_country VARCHAR(60) not null,
    date_of_birth DATE not null,
    PRIMARY KEY(email)
);

CREATE TABLE Flights(
    airline_name VARCHAR(20),
    flight_number INT,
    depart_ts DATETIME,
    airplane_id INT not null,
    arrival_ts DATETIME not null,
    depart_airport_code INT not null,
    arrival_airport_code INT not null,
    flight_status VARCHAR(30),
    base_price FLOAT(6,2) not null,
    PRIMARY KEY(airline_name, flight_number, depart_ts),
    FOREIGN KEY(airline_name) REFERENCES Airline(airline_name),
    FOREIGN KEY(airplane_id) REFERENCES Airplane(airplane_id),
    FOREIGN KEY(depart_airport_code, arrival_airport_code) REFERENCES Airport(code)
);

CREATE TABLE Airport(
    code INT,
    airport_name VARCHAR(30),
    city VARCHAR(30),
    PRIMARY KEY(code),
);

CREATE TABLE Purchases(
    ticket_id INT,
    email VARCHAR(30) not null,
    card_type VARCHAR(20) not null,
    card_number INT not null,
    name_on_card VARCHAR(30) not null,
    expiration_date DATE not null,
    purchase_ts, DATETIME not null,
    sell_price FLOAT(6,2) not null,
    PRIMARY KEY(ticket_id),
    FOREIGN KEY(ticket_id) REFERENCES Ticket(ticket_id),
    FOREIGN KEY(email) REFERENCES Customer(email)
);

CREATE TABLE Ticket(
    ticket_id INT,
    airline_name VARCHAR(20) not null,
    flight_number INT not null,
    depart_ts DATETIME not null,
    PRIMARY KEY(ticket_id),
    FOREIGN KEY(airline_name, flight_number, depart_ts) REFERENCES Flights(airline_name, flight_number, depart_ts)
);

CREATE TABLE Staff_Phone(
    username VARCHAR(30),
    phone_number VARCHAR(12),
    PRIMARY KEY(username, phone_number),
    FOREIGN KEY(username) REFERENCES Airline_Staff(username)
);

CREATE TABLE Airline_Staff(
    username VARCHAR(30),
    staff_password VARCHAR(300) not null,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    date_of_birth DATE,
    PRIMARY KEY(username)
);

CREATE TABLE Works_For(
    username VARCHAR(30),
    airline_name VARCHAR(20) not null,
    PRIMARY KEY(username),
    FOREIGN KEY(username) REFERENCES Airline_Staff(username),
    FOREIGN KEY(airline_name) REFERENCES Airline(airline_name)
);

CREATE TABLE Airline(
    airline_name VARCHAR(20),
    PRIMARY KEY(airline_name)
);

CREATE TABLE Airplane(
    airline_name VARCHAR(20),
    airplane_id INT,
    num_seats INT,
    PRIMARY KEY(airplane_id, airline_name),
    FOREIGN KEY(airline_name) REFERENCES Airline(airline_name)
);

CREATE TABLE Reviews(
    email VARCHAR(30),
    airline_name VARCHAR(20),
    flight_number INT,
    depart_ts DATETIME,
    rating INT,
    comments VARCHAR(100),
    PRIMARY KEY(email, airline_name, flight_number, depart_ts),
    FOREIGN KEY(email) REFERENCES Customer(email),
    FOREIGN KEY(airline_name, flight_number, depart_ts) REFERENCES Flights(airline_name, flight_number, depart_ts)
);