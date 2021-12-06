import datetime
import random

from random import randrange
from datetime import timedelta

#dictionary mapping airlines to the planes they own
airlines_airplanes = {
    "American Airlines":[100, 101, 102, 103, 104, 105],
    "China Eastern": [200, 201, 202, 203, 204, 205],
}

#airports in the database
airports = [
    111,    #NYC - New York City
    222,    #PVG - Shanghai
    333,    #SJC - San Jose
    444,    #PAR - Paris
    555,    #TOK - Tokyo
    666,    #CHC - Chicago
    777,    #MOS - Moscow
    888,    #SYD - Sydney
    999,    #DUB - Dubai
]

#statuses of flights
status = ["On-time", "Delayed"]

#customers in the database + payment info
customers = {
    "andyhamilton@nyu.edu"  :{
                                "name_on_card": "Andy",
                                "card_type": "American Express",
                                "card_number": "7128-4932-5578-1924",
                                "expiration_date": "2026-04-01"
                            },
    "dummy@nyu.edu"         :{
                                "name_on_card": "Dummy",
                                "card_type": "VISA",
                                "card_number": "1111-1111-1111-1111",
                                "expiration_date": "2021-12-22"
                            },
    "jj2798@nyu.edu"        :{
                                "name_on_card": "Jeremy",
                                "card_type": "VISA",
                                "card_number": "1111-1111-1111-1111",
                                "expiration_date": "2023-09-01"
                            },
    "thisanemail@gmail.com" :{
                                "name_on_card": "Johnny",
                                "card_type": "MasterCard",
                                "card_number": "0112-3581-3213-4558",
                                "expiration_date": "2029-06-09"
                            },
}

#starting index for flight_number & ticket_id generator
flight_start = 1
ticket_start = 1

#generate sql insert statments for airplanes
def insert_planes():
    plane_data = {}
    #insert statement using dictionary defined above
    for key in airlines_airplanes.keys():
        for value in airlines_airplanes[key]:
            num_seats = random.randint(10, 120)
            insert = f"INSERT INTO airplane VALUES('{key}', '{value}', {num_seats});"
            print(insert)
            plane_data[value] = num_seats
    return plane_data


#This function will return a random datetime between two datetime objects.
def random_date(start, end):
    
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)

def generate_flights(num_flights, airline, airplane_ids):
    global flight_start
    flight_number = flight_start

    d1 = datetime.datetime.strptime('12/01/2021 12:00 PM', '%m/%d/%Y %I:%M %p')
    d2 = datetime.datetime.strptime('06/01/2022 12:00 AM', '%m/%d/%Y %I:%M %p')
    
     #create a dictionary to hold flight info to be used in later functions
    flight_info = {}

    for i in range(num_flights):
        
        #pick a random sub-sequence of size 2 from airports
        rand_airports = random.sample(airports, 2)
        dept_airport = rand_airports[0]
        arr_airport = rand_airports[1]

        #pick a random airplane
        airplane_id = random.sample(airplane_ids, 1)[0]

        #pick between delayed and ontime
        rand_status = random.sample(status, 1)[0]

        #generate a random departure time, assume flight take between 1 to 14 hours
        dept_ts = random_date(d1, d2)
        arr_ts = dept_ts + timedelta(hours=random.randint(1,14))

        #generate a random base ticket price
        base_price = random.randint(100,9999)

        #store flight info for that flight number key
        flight_info[str(flight_number)] = {
            "airline": airline,
            "dept_ts": dept_ts,
            "airplane_id": airplane_id,
            "arr_ts": arr_ts,
            "dept_airport_code": dept_airport,
            "arr_airport_code": arr_airport,
            "status": status,
            "base_price": base_price
        }

        #generate and print SQL command 
        o_string = f"INSERT INTO flights VALUES('{airline}', {flight_number}, '{dept_ts}', {airplane_id}, '{arr_ts}', {dept_airport}, {arr_airport}, '{rand_status}', {base_price});"
        flight_number += 1
        flight_start += 1
        print(o_string)

    return flight_info 

#generate sql insert statements for ticket
def generate_tickets(flight_data):
    global ticket_start
    #dictionary to hold ticket ids for each flight number
    flight_ticket = {}
    base_prices = []
    for flight in flight_data.keys():
        flight_ticket[flight] = []
        for i in range(10): #generate 10 tickets per flight
            #flight for ticket id is by the 1000s

            #retrieve needed fields and store into sql line
            ticket_id = 1000*ticket_start + i
            airline_name = flight_data[flight]["airline"]
            flight_number = flight
            depart_ts = flight_data[flight]["dept_ts"]
            price = flight_data[flight]["base_price"]
            make_ticket = f"INSERT INTO ticket VALUES({ticket_id}, '{airline_name}', '{flight_number}', '{depart_ts}', '{price}');"
            print(make_ticket)
            flight_ticket[flight].append(ticket_id)
            base_prices.append(price)
            
        ticket_start += 1
    return flight_ticket, base_prices

#generate sql insert statements for purchases
def generate_purchases(ticket_data, flight_data, ticket_prices):
    #purchase history
    purchase_tracker = {}
    #store an initially empty set for each customer in the database
    for key in customers:
        purchase_tracker[key] = set()

    for flight in ticket_data.keys():
        ticket_sequence = ticket_data[flight]
        random.shuffle(ticket_sequence)
        #determine how many tickets to sell for each flight
        num_sold = random.randint(1, len(ticket_sequence)-1)
        for i in range(num_sold):
            #select a random customer email
            rand_customer = random.sample(customers.keys(), 1)[0]
            # print(f"random customer {rand_customer}")
            #get desired info for sql statement
            ticket_id = ticket_sequence[i]
            email = rand_customer
            card_type = customers[rand_customer]["card_type"]
            card_number = customers[rand_customer]["card_number"]
            name_on_card = customers[rand_customer]["name_on_card"]
            expiration_date = customers[rand_customer]["expiration_date"]

            purchase_ts = flight_data[flight]['dept_ts'] - datetime.timedelta(days=20)
            sell_price = ticket_prices[int(flight) - 1] + random.randint(100,2000)
            insert_purchase = f"INSERT INTO purchases VALUES({ticket_id}, '{email}', '{card_number}', '{card_type}', '{name_on_card}', '{expiration_date}', '{purchase_ts}',  '{sell_price}');"
            print(insert_purchase)
            purchase_tracker[email].add((flight, flight_data[flight]['dept_ts'], flight_data[flight]['airline']))

    return purchase_tracker

def generate_reviews(airline, purchase_data):
    comments = ["good flight", 
    "chill", 
    "horrendous", 
    "down bad", 
    "mad bumpy", 
    "oh my god i cannot tell you more this was the best flight ever", 
    "Im never flying ever again", 
    "I wanna go home. bing bong"]

    # print(purchase_data)
    # random_flight_number = random.sample(purchase_data.keys(), 1)[0]
    # print("\n\n\n\n") 
    # print(purchase_data[random_flight_number])
    key = list(purchase_data.keys())
    # print("before: " + str(key))
    random.shuffle(key)
    # print("after: " + str(key))
    # for flight_num in key:
    #     num_reviews = random.randint(0,len(purchase_data[flight_num]))
    #     entry = random.sample(purchase_data[flight_num],1)[0]
    #     for i in range(num_reviews):
    #         # print(purchase_data[random_flight_number])
    #         email = entry[0]
    #         # print("email" + email)
    #         flight_number = flight_num
    #         depart_time = entry[-1]

    #         rating = random.randint(1,10)

    #         comment = random.sample(comments, 1)[0]

            # query = f"INSERT INTO reviews VALUES('{email}', '{airline}', {flight_number}, '{depart_time}', {rating}, '{comment}');"
            # print(query)

    #purchase_data = {"customer_email" : [(flight_number, departure_time, airline), (flight_number, departure_time, airline), ...]}
    for customer in purchase_data.keys(): #for all customers in the database

        for flight in purchase_data[customer]: #iterates through each tuple for each customer
            #random number, either 0 or 1
            review_or_not = random.randint(0,1)
            if review_or_not == 1: #if 1 the customer will review that flight
                email = customer
                airline = flight[-1]
                flight_number = flight[0]
                depart_time = flight[1]
                rating = random.randint(1,10)
                comment = random.sample(comments, 1)[0]

                query = f"INSERT INTO reviews VALUES('{email}', '{airline}', {flight_number}, '{depart_time}', {rating}, '{comment}');"
                print(query)


# generate_reviews("American Airlines", email_list, flights, 60)

aa_airline = "American Airlines"
aa_airline_planes = airlines_airplanes[aa_airline]
ce_airline = "China Eastern"
ce_airline_planes = airlines_airplanes[ce_airline]
insert_planes()
data = generate_flights(10, aa_airline, aa_airline_planes)
ce_data = generate_flights(10, ce_airline, ce_airline_planes)
# # print(data)
tix, price = generate_tickets(data)
ce_tix, ce_price = generate_tickets(ce_data)
# print(tix)
res = generate_purchases(tix, data, price)
ce_res = generate_purchases(ce_tix, ce_data, ce_price)
generate_reviews(aa_airline, res)
generate_reviews(ce_airline, ce_res)

# print(res)
# print(data)
# print(tix)



