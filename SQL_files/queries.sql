SELECT *
FROM Flights
WHERE departs_ts > CURRENT_TIMESTAMP();

SELECT *
FROM Flights
WHERE flight_status = "Delayed";

SELECT customer_name
FROM Customer INNER JOIN Purchases
ON Customer.email = Purchases.email;

SELECT *
FROM Airplane
WHERE airline_name = "China Eastern";