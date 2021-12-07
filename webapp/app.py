from flask import Flask, render_template, request, session, url_for, redirect, abort
import pymysql.cursors
import datetime

app = Flask(__name__)

#Configure MySQL
# Probably will have to change port for different machines
conn = pymysql.connect(host='localhost',
                       port=3306,
                       user='root',
                       password='',
                       db='airsystem',
                       charset='utf8mb4',
                       cursorclass=pymysql.cursors.DictCursor)

"""
INDEX
"""

# Index Route
@app.route('/')
def index():
	# If already logged in:
	if 'username' in session:
		return redirect(url_for('home'))

	else:
		return render_template('index.html')

"""
LOGIN
"""

# Login Route
@app.route('/login')
def login():
	# If already logged in:
	if 'username' in session:
		return redirect(url_for('home'))

	return render_template('login.html')

# User Login Authentication
@app.route('/loginAuth', methods=['GET','POST'])
def loginAuth():
    #grabs information from the forms
	username = request.form['username']
	password = request.form['password']
	
	#cursor used to send queries
	cursor = conn.cursor()
	# If login as Staff
	if request.form.get('login_type') == 'on':
		#executes query
		query = 'SELECT * FROM airline_staff WHERE username = %s and staff_password = MD5(%s)'
		cursor.execute(query, (username, password))
		#stores the results in a variable
		data = cursor.fetchone()
		#use fetchall() if you are expecting more than 1 data row

		#query Works_for to get airline company user works for
		query2 = 'SELECT * FROM Works_For WHERE username = %s'
		cursor.execute(query2, (username))
		data2 = cursor.fetchone()
		print(f"data2 = {data2}")
		#add to session object
		session['employer'] = data2["airline_name"]
		session['type'] = 'staff'
		#close
		cursor.close()
		error = None
		if(data):
			#creates a session for the the user
			#session is a built in
			session['username'] = username

			return redirect(url_for('home'))
		else:
			#returns an error message to the html page
			error = 'Invalid login or username'
			return render_template('login.html', error=error)

	# If login as customer
	else:
		#executes query
		query = 'SELECT * FROM customer WHERE email = %s and customer_password = MD5(%s)'
		cursor.execute(query, (username, password))
		#stores the results in a variable
		data = cursor.fetchone()
		#use fetchall() if you are expecting more than 1 data row
		cursor.close()
		error = None
		#set session type
		session['type'] = 'customer'
		if(data):
			#creates a session for the the user
			#session is a built in
			session['username'] = username
			return redirect(url_for('home'))
		else:
			#returns an error message to the html page
			error = 'Invalid login or username'
			return render_template('login.html', error=error)


"""
REGISTRATION
"""

# Register Route
@app.route('/register')
def register():
    return render_template('regchoice.html')

# Register as Staff
@app.route('/staffreg')
def staffreg():
	# Grab existing airlines

	cursor = conn.cursor()

	query = 'SELECT airline_name FROM airline'
	cursor.execute(query)

	airlines = cursor.fetchall()

	# Patching for wonky space handling by html
	for val in airlines:
		val['visual'] = val['airline_name']
		val['airline_name'] = val['airline_name'].replace(' ', '&nbsp;')

	cursor.close()

	print(airlines)

	if 'error' in session:
		error = session.pop('error')
		return render_template('staffreg.html', error=error, airlines=airlines)

	return render_template('staffreg.html', airlines=airlines)

# Register as User
@app.route('/userreg')
def userreg():
	return render_template('userreg.html')

# Register Authentication 
@app.route('/registerAuth', methods=['GET', 'POST'])
def registerAuth():
	# Determine what kind of user (staff or customer/user)
	regtype = request.form['type']
	# For Staff
	if regtype == 'staff':
		#grabs information from the forms
		username = request.form['username'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
		password = request.form['password']
		fname = request.form['fname'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
		lname = request.form['lname'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
		DoB = request.form['DoB']
		airline_employer = request.form['employer'].replace('&nbsp;', ' ')

		print(airline_employer)

		#cursor used to send queries
		cursor = conn.cursor()
		#executes query
		query = 'SELECT * FROM airline_staff WHERE username = %s'
		cursor.execute(query, (username))
		#stores the results in a variable
		data = cursor.fetchone()

		#use fetchall() if you are expecting more than 1 data row
		error = None
		if(data):
			#If the previous query returns data, then user exists
			error = "This user already exists"
			session['error'] = error
			return redirect(url_for('staffreg'))
		else:
			ins = "INSERT INTO airline_staff VALUES(%s, MD5(%s), %s, %s, %s)"
			cursor.execute(ins, (username, password, fname, lname, DoB))
			conn.commit()

			# Insert into works_for new registered employee
			empl_check = 'SELECT * FROM works_for WHERE username = %s AND airline_name = %s'
			cursor.execute(empl_check, (username,airline_employer))

			check_res = cursor.fetchone()

			# If not already registered into table, create entry
			if not check_res:
				ins_wf = 'INSERT INTO works_for VALUES(%s, %s)'
				cursor.execute(ins_wf, (username, airline_employer))
				conn.commit()
			cursor.close()
			return render_template('index.html')

	# For Customer/User
	#grabs information from the forms
	username = request.form['email'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
	name = request.form['name'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
	password = request.form['password']

	addr_num = request.form['addr_building_num']
	street = request.form['street']
	city = request.form['city']
	state = request.form['state']

	phone = request.form['phone']

	pass_num = request.form['passport_num']
	pass_exp = request.form['passport_exp']
	pass_country = request.form['passport_country']

	DoB = request.form['DoB']

	#cursor used to send queries
	cursor = conn.cursor()
	#executes query
	query = 'SELECT * FROM customer WHERE email = %s'
	cursor.execute(query, (username))
	#stores the results in a variable
	data = cursor.fetchone()
	#use fetchall() if you are expecting more than 1 data row
	error = None
	if(data):
		#If the previous query returns data, then user exists
		error = "This user already exists"
		return render_template('userreg.html', error = error)
	else:
		ins = 'INSERT INTO customer VALUES(%s, %s, MD5(%s), %s, %s, %s, %s, %s, %s, %s, %s, %s)'
		cursor.execute(ins, (username, name, password, addr_num, street, city, state, phone, pass_num, pass_exp, pass_country, DoB))
		conn.commit()
		cursor.close()
		return render_template('index.html')

"""
HOME
"""

# Home Route
@app.route('/home')
def home():
	username=session['username']
	usertype=session['type']

	# Cleanup for straggling errors
	if 'error' in session:
		session.pop('error')

	cursor = conn.cursor()

	display_name = 0

	# Change display name based on user type
	if usertype=='customer':
		# Show all upcoming flights
		query = "SELECT flights.airline_name, ticket.flight_number, depart_airport_code, arrival_airport_code, flights.depart_ts, arrival_ts, flight_status "\
		"FROM purchases INNER JOIN ticket USING (ticket_id) INNER JOIN flights USING (flight_number) "\
		"WHERE purchases.email = %s"

		cursor.execute(query,(username))

		customer_flights = cursor.fetchall()

		query = 'SELECT customer_name FROM customer WHERE email = %s'

		cursor.execute(query, (username))
		
		display_name = cursor.fetchone()['customer_name']

		cursor.close()
		return render_template('home.html', customer_flights=customer_flights, display_name=display_name, usertype=usertype)

	elif usertype=='staff':
		query = 'SELECT first_name FROM airline_staff WHERE username = %s'

		cursor.execute(query, (username))

		display_name = cursor.fetchone()['first_name']

		cursor.close()
		return render_template('home.html', display_name=display_name, usertype=usertype)


	

"""
Search
"""

# Search Page
@app.route('/searchpage')
def searchpage():
	return render_template('search.html')

# Search
@app.route('/search', methods=['POST', 'GET'])
def search():
	# Grab information from form
	src = request.form['src']
	dest = request.form['dest']
	dep_date = request.form['dep_date']
	
	cursor = conn.cursor()

	query1 = "SELECT airline_name, flight_number, depart_ts, arrival_ts FROM flights WHERE "\
	"depart_airport_code = (SELECT code FROM airport WHERE airport_name = %s) AND "\
	"arrival_airport_code = (SELECT code FROM airport WHERE airport_name = %s) AND DATE(depart_ts) = %s"
	cursor.execute(query1, (src, dest, dep_date))

	data = cursor.fetchall()

	# If round trip
	if request.form.get('round_trip') == 'on':
		arr_date = request.form['arr_date']

		query2 = "SELECT airline_name, flight_number, depart_ts, arrival_ts FROM flights WHERE "\
		"depart_airport_code = (SELECT code FROM airport WHERE airport_name = %s) AND "\
		"arrival_airport_code = (SELECT code FROM airport WHERE airport_name = %s) AND DATE(depart_ts) = %s"
		cursor.execute(query2, (dest, src, arr_date))

		data.extend(cursor.fetchall())

	
	cursor.close()
	error = None
	if data:
		return render_template('search.html', res = data)
	else:
		error = "No results!"
		return render_template('search.html', error=error)

"""
Customer
"""

# Purchase Page Default
@app.route('/purchasepage')
def purchasepage():
	if session['type'] == 'staff':
		abort(401)
	cursor = conn.cursor()

	# Display all available tickets for purchase
	query = 'SELECT * FROM available_tickets'

	cursor.execute(query)

	res = cursor.fetchall()

	cursor.close()

	if 'error' in session:
		error = session.pop('error')
		return render_template('purchasepage.html', res=res, searched=True, error=error)

	return render_template('purchasepage.html', res=res)

@app.route('/purchaseSearch', methods=['POST'])
def purchaseSearch():
	if session['type'] == 'staff':
		abort(401)
	# Allows user to search for tickets based on a user input flight number
	flight_num = request.form['flight_num']
	cursor = conn.cursor()

	query = 'SELECT * FROM ticket WHERE flight_number = %s AND ticket.ticket_id NOT IN (SELECT purchases.ticket_id FROM purchases)'

	cursor.execute(query, (flight_num))

	res = cursor.fetchall()

	cursor.close()

	return render_template('purchasepage.html', res=res, searched=True)

@app.route('/purchaseTicket', methods=['POST'])
def purchaseTicket():
	if session['type'] == 'staff':
		abort(401)
	# Allows the user to specify which ticket they would like to purchase.
	# If that ticket is unavailable, the page will display an error saying so
	ticket_id = request.form['ticket_id']
	cursor = conn.cursor()

	query = 'SELECT * FROM available_tickets WHERE ticket_id = %s'

	cursor.execute(query, (ticket_id))

	res = cursor.fetchall()

	cursor.close()

	if res:
		session['ticket_id'] = ticket_id

		return render_template('purchaseform.html')
	else:
		error = 'This ticket is not available!'
		session['error'] = error
		return redirect(url_for('purchasepage'))

@app.route('/purchaseForm', methods=['POST'])
def purchaseForm():
	if session['type'] == 'staff':
		abort(401)
	# Finalizes purchase of ticket
	email = request.form['email']
	card_type = request.form['card_type']
	card_number = request.form['card_number']
	name_on_card = request.form['name_on_card']
	exp_date = request.form['exp_date']
	purchase_ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	ticket_id = 0
	purchase_price = 0

	# Grab ticket_id from session 'cookie'
	if 'ticket_id' in session:
		ticket_id = session.pop('ticket_id')
	else:
		error = 'Session lost Ticket ID!'
		session['error'] = error
		return redirect(url_for('purchasepage'))

	cursor = conn.cursor()

	# A checkpoint that serves both as a last minute availability check
	# and a query for the sales price of the ticket
	query = 'SELECT price FROM available_tickets WHERE ticket_id = %s'

	cursor.execute(query, (ticket_id))

	res_price = cursor.fetchone()

	if res_price:
		purchase_price = res_price['price']
	else:
		error = 'This ticket is no longer available!'
		cursor.close()
		session['error'] = error
		return redirect(url_for('purchasepage'))

	ins = 'INSERT INTO purchases VALUES(%s, %s, %s, %s, %s, %s, %s, %s)'

	cursor.execute(ins, (ticket_id, email, card_type, card_number, name_on_card, exp_date, purchase_ts, purchase_price))
	conn.commit()
	cursor.close()

	return render_template('purchasesuccess.html')


# Rating
@app.route('/reviewpage')
def reviewpage():
	if session['type'] == 'staff':
		abort(401)
	# Displays all flights the user is able to rate and review
	username=session['username']
	curr_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	cursor = conn.cursor()

	get_prev_flights = 'SELECT flights.airline_name, flights.flight_number, flights.depart_ts, flights.arrival_ts, sell_price '\
	    'FROM flights INNER JOIN ticket USING (flight_number) INNER JOIN purchases USING (ticket_id) '\
		'WHERE email = %s AND arrival_ts < %s'
	
	cursor.execute(get_prev_flights, (username,curr_date))

	res = cursor.fetchall()
	
	# Displays all ratings and reviews the user has made in the past
	get_prev_reviews = 'SELECT airline_name, flight_number, depart_ts, rating, comments FROM reviews WHERE email = %s'

	cursor.execute(get_prev_reviews, (username))

	reviews = cursor.fetchall()

	cursor.close()

	if 'error' in session:
		error = session.pop('error')
		return render_template('reviewpage.html', res=res, reviews=reviews, error=error)

	return render_template('reviewpage.html', res=res, reviews=reviews)

@app.route('/leaverating', methods=['POST'])
def leaverating():
	if session['type'] == 'staff':
		abort(401)
	username=session['username']
	airline_name=request.form['airline_name']
	flight_num=request.form['flight_num']
	depart_ts=request.form['depart_ts']
	rating=request.form['rating']
	review=request.form['review'].replace("&", "&amp;").replace('"', "&quot;").replace("<", "&lt;").replace(">", "&gt;")
	curr_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	cursor = conn.cursor()

	# Get real depart_ts
	get_ts = 'SELECT depart_ts FROM flights WHERE airline_name = %s AND flight_number = %s AND DATE(depart_ts) = %s'

	cursor.execute(get_ts, (airline_name, flight_num, depart_ts))

	ts = cursor.fetchone()

	if not ts:
		error = 'Invalid Flight'

		cursor.close()
		session['error'] = error
		return redirect(url_for('reviewpage'))


	depart_ts = ts['depart_ts']

	# Check if flight is applicable to user review
	check = 'SELECT * FROM flights INNER JOIN ticket USING (flight_number) INNER JOIN purchases USING (ticket_id) '\
		'WHERE email = %s AND arrival_ts < %s AND flights.airline_name = %s AND flights.flight_number = %s AND flights.depart_ts = %s'

	cursor.execute(check, (username, curr_date, airline_name, flight_num, depart_ts))

	res = cursor.fetchone()

	if not res:
		error = 'Invalid Flight'
		
		cursor.close()
		session['error'] = error
		return redirect(url_for('reviewpage'))

	# Check if the user already reviewed this flight
	check2 = 'SELECT * FROM reviews '\
		'WHERE email = %s AND airline_name = %s AND flight_number = %s AND depart_ts = %s'

	cursor.execute(check2, (username, airline_name, flight_num, depart_ts))

	res2 = cursor.fetchone()

	if res2:
		error = 'You have already reviewed this flight!'
		
		cursor.close()
		session['error'] = error
		return redirect(url_for('reviewpage'))

	# Finalize rating and insert into table
	ins = 'INSERT INTO reviews VALUES(%s, %s, %s, %s, %s, %s)'

	cursor.execute(ins, (username, airline_name, flight_num, depart_ts, rating, review))
	conn.commit()
	cursor.close()

	return redirect(url_for('reviewpage'))

# View Spending
@app.route('/viewspend', methods=['POST', 'GET'])
def viewspend():
	if session['type'] == 'staff':
		abort(401)
	username=session['username']

	cursor = conn.cursor()

	query = 'SELECT SUM(sell_price) as Total FROM purchases WHERE email = %s AND DATE(purchase_ts) > %s AND DATE(purchase_ts) < %s'
	spend_list = []

	# If user specified range
	if request.form.get('searched') == 'on':
		lim = datetime.datetime.strptime(request.form['start'], "%Y-%m-%d")
		curr_bound = datetime.datetime.strptime(request.form['end'], "%Y-%m-%d")
		next_bound = curr_bound - datetime.timedelta(days = 31)

		while(next_bound > lim):
			cursor.execute(query, (username, next_bound.strftime("%Y-%m-%d"), curr_bound.strftime("%Y-%m-%d")))

			res = cursor.fetchone()

			res['date_range'] = next_bound.strftime("%Y-%m-%d") + ' to ' + curr_bound.strftime("%Y-%m-%d")

			spend_list.append(res)

			curr_bound = next_bound
			next_bound = next_bound - datetime.timedelta(days = 31)

		# Left over days
		cursor.execute(query, (username, lim.strftime("%Y-%m-%d"), curr_bound.strftime("%Y-%m-%d")))

		res = cursor.fetchone()

		res['date_range'] = lim.strftime("%Y-%m-%d") + ' to ' + curr_bound.strftime("%Y-%m-%d")

		spend_list.append(res)

	# Otherwise
	else:
		months = 6
		curr_bound = datetime.datetime.now()
		next_bound = curr_bound - datetime.timedelta(days = 31)

		for i in range(months):
			cursor.execute(query, (username, next_bound.strftime("%Y-%m-%d"), curr_bound.strftime("%Y-%m-%d")))

			res = cursor.fetchone()

			res['date_range'] = next_bound.strftime("%Y-%m-%d") + ' to ' + curr_bound.strftime("%Y-%m-%d")

			spend_list.append(res)

			curr_bound = next_bound
			next_bound = next_bound - datetime.timedelta(days = 31)

	# Determine how much was spent in the past year
	curr_bound = datetime.datetime.now()
	next_bound = curr_bound - datetime.timedelta(days = 365)

	cursor.execute(query, (username, next_bound.strftime("%Y-%m-%d"), curr_bound.strftime("%Y-%m-%d")))

	year_spent = cursor.fetchone()['Total']

	cursor.close()

	return render_template('viewspend.html', spend_list=spend_list, year_spent=year_spent)

"""
Staff
"""

@app.route('/staffview', methods=['GET', 'POST'])
def staffview():
	if session['type'] == 'customer':
		abort(401)
	#debugging to see whats in session object
	print(f"session = {session}")
	#get username for welcome, employer to only show company information
	username=session['username']
	airline = session["employer"]
	cursor = conn.cursor()

	#query all flights under that Airline (in the upcoming 30 days)
	all_flights = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s AND depart_ts BETWEEN NOW() and DATE_ADD(NOW(), INTERVAL 30 DAY) ORDER BY depart_ts"
	#comment below one for original
	# all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))

	data = cursor.fetchall()
	cursor.close()
	return render_template('flightmanager.html', flights=data, username=username)

@app.route('/staffsearchflight', methods=['GET', 'POST'])
def staffsearchflight():
	if session['type'] == 'customer':
		abort(401)
	#debugging to see whats in session object
	print(f"session = {session}")
	#get username for welcome, employer to only show company information
	username=session['username']
	airline = session["employer"]
	cursor = conn.cursor()

	#query all flights under that Airline (in the upcoming 30 days)
	all_flights = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s AND depart_ts BETWEEN NOW() and DATE_ADD(NOW(), INTERVAL 30 DAY) ORDER BY depart_ts"
	#comment below one for original
	# all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))

	data = cursor.fetchall()

	#get flights within range of dates from form
	print(f"{request.form}")
	depart_ts_start = request.form['depart_ts_start']
	depart_ts_end = request.form['depart_ts_end']
	flight_number = request.form['flight_number']
	depart_airport = request.form['depart_airport']
	arrival_airport = request.form['arrival_airport']
	depart_city = request.form['depart_city']
	arrival_city = request.form['arrival_city']

	#original between two depart_ts
	# search_flights = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s AND depart_ts BETWEEN %s and %s ORDER BY depart_ts"
	resulting_str = ""

	#check cases for form to determine type of query
	if(depart_ts_start != ''): #if depart_ts_start is not '', then we selected the range of dates radio button
		depart_ts_start = datetime.datetime.strptime(depart_ts_start, "%Y-%m-%d")
		#we have a start date for our range, now check if we have an end date
		if(depart_ts_end != ''): 
			depart_ts_end = datetime.datetime.strptime(depart_ts_end, "%Y-%m-%d")
			#if we do, we can check for flight between this query
			resulting_str = f"AND F.depart_ts BETWEEN '{depart_ts_start}' AND '{depart_ts_end}'"
		else:
			#if we don't have an end date, we search for flights that depart on or after the start date
			resulting_str = f"AND F.depart_ts >= '{depart_ts_start}'"
	elif(depart_ts_end != ''): 
		depart_ts_end = datetime.datetime.strptime(depart_ts_end, "%Y-%m-%d")
		#if depart_ts_start is blank but we have a depart_ts_end, we search for flights that depart/departed on/before the given date
		resulting_str = f"AND F.depart_ts <= '{depart_ts_end}'"
	elif(flight_number != ''):
		#if we have a flight number, we can just search for the flight number
		resulting_str = f"AND F.flight_number = {flight_number}"
	elif(depart_airport != ''):
		#if we have a depart airport
		if(arrival_airport != ''):
			#if we also have an arrival airport, we can check for a flight that takes us from city A to city B
			resulting_str = f"AND D.airport_name = '{depart_airport}' AND A.airport_name = '{arrival_airport}'"
		else:
			#just check for departing from airport A
			resulting_str = f"AND D.airport_name = '{depart_airport}'"
	elif(arrival_airport != ''):
			#if we just have an arrival airport, we check for flights that takes us to city B
			resulting_str = f"AND A.airport_name = '{arrival_airport}'"
	#apply the same concepts from airport to city
	elif(depart_city != ''):
		#if we have a depart airport
		if(arrival_city != ''):
			#if we also have an arrival airport, we can check for a flight that takes us from city A to city B
			resulting_str = f"AND D.city = '{depart_city}' AND A.city = '{arrival_city}'"
		else:
			#just check for departing from airport A
			resulting_str = f"AND D.city = '{depart_city}'"
	elif(arrival_city != ''):
			#if we just have an arrival airport, we check for flights that takes us to city B
			resulting_str = f"AND A.city = '{arrival_city}'"


	#query all flights under that Airline (between the dates)
	search_flights = f"SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s {resulting_str} ORDER BY depart_ts"
	# print(f"QUERY = {search_flights}")
	cursor.execute(search_flights, (airline))

	flight_range_dt = cursor.fetchall()

	cursor.close()
	return render_template('flightmanager.html', flights=data, username=username, flights_in_range=flight_range_dt)

@app.route('/flightreg')
def flightreg():
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]
	cursor=conn.cursor()
	#get all flights in database to display
	# all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	all_flights = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city AS arrival, D.city AS depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s ORDER BY depart_ts"
	cursor.execute(all_flights, (airline))
	flight_history = cursor.fetchall()
	cursor.close()
	return render_template('flightreg.html', company=airline, flights=flight_history)

@app.route('/airplanereg', methods=['GET', 'POST'])
def airplanereg():
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]
	cursor = conn.cursor()
	#query to display all currently owned airplanes for company
	get_planes = "SELECT airplane_id, num_seats FROM Airplane WHERE airline_name = %s"
	cursor.execute(get_planes, (airline))

	#check if we get a non-empty query
	planes = cursor.fetchall()
	cursor.close()
	return render_template('airplanereg.html', planes=planes, company=airline)

@app.route('/airportreg')
def airportreg():
	if session['type'] == 'customer':
		abort(401)
	cursor = conn.cursor()
	#query to display all Airports in system
	get_airports = "SELECT * FROM Airport"
	cursor.execute(get_airports)

	#check if we get a non-empty query
	airports = cursor.fetchall()
	cursor.close()

	return render_template('airportreg.html', airports=airports)

@app.route('/staffaddplane', methods=['GET', 'POST'])
def staffaddplane():
	if session['type'] == 'customer':
		abort(401)
	#fetch data from form
	airline = session["employer"]
	airplane_id = request.form['airplane_id']
	num_seats = request.form['num_seats']

	cursor = conn.cursor()
	#query to check if airplane already exists
	check_plane = "SELECT * FROM Airplane WHERE airline_name = %s AND airplane_id = %s"
	cursor.execute(check_plane, (airline, int(airplane_id)))

	#check if we get a non-empty query
	data = cursor.fetchone()
	if(data):
		#if non-empty, a plane already exists with under the company 
		error = f"This airplane already exists under {airline}"
		return render_template('airplanereg.html', error = error)
	
	#if empty, we can add this plane into our database
	insert_plane = "INSERT INTO Airplane VALUES(%s, %s, %s)"
	cursor.execute(insert_plane, (airline, int(airplane_id), int(num_seats)))
	conn.commit()


	#query to display all currently owned airplanes for company
	get_planes = "SELECT airplane_id, num_seats FROM Airplane WHERE airline_name = %s"
	cursor.execute(get_planes, (airline))

	#check if we get a non-empty query
	planes = cursor.fetchall()

	cursor.close()

	return render_template('airplanereg.html', planes=planes, company=airline)

@app.route('/staffaddairport', methods=['GET', 'POST'])
def staffaddairport():
	if session['type'] == 'customer':
		abort(401)
	#fetch data from form
	airport_name = request.form['airport_name']
	airport_code = request.form['airport_code']
	city = request.form['airport_city']

	cursor = conn.cursor()
	#query to check if airport already exists
	check_airport = "SELECT * FROM Airport WHERE code = %s"
	cursor.execute(check_airport, (airport_code))

	#check if we get a non-empty query
	data = cursor.fetchone()

	if(data):
		#if non-empty, a plane already exists with under the company 
		error = f"An airport already exists with code {airport_code}"
		return render_template('airportreg.html', error = error)
	
	#if empty, we can add this plane into our database
	insert_plane = "INSERT INTO Airport VALUES(%s, %s, %s)"
	cursor.execute(insert_plane, (int(airport_code), airport_name, city))
	conn.commit()

	#query to display all Airports in system
	get_airports = "SELECT * FROM Airport"
	cursor.execute(get_airports)

	#check if we get a non-empty query
	airports = cursor.fetchall()

	cursor.close()
	return render_template('airportreg.html', airports=airports)

@app.route('/staffaddflight', methods=['GET', 'POST'])
def staffaddflight():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]
	#get variables from form
	flight_number = request.form['flight_number']
	dep_ts = request.form['depart_ts']
	airplane_id = request.form['airplane_id']
	arr_ts = request.form['arrival_ts']
	dep_airport_code = request.form['depart_airport_code']
	arr_airport_code = request.form['arrival_airport_code']
	flight_status = request.form['flight_status']
	base_price = request.form['base_price']



	#initialize cursor to begin queries
	cursor = conn.cursor()

	all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))
	flight_history = cursor.fetchall()
	
	#check if arrival time comes before departure time
	if(datetime.datetime.fromisoformat(arr_ts) < datetime.datetime.fromisoformat(dep_ts)):
		error = "Arrival date comes before departure date"
		return render_template('flightreg.html', flights=flight_history, error=error, company=airline)

	#check if airplane belongs to airline
	check_plane = "SELECT * FROM airplane WHERE airline_name = %s AND airplane_id = %s"
	cursor.execute(check_plane, (airline, airplane_id))
	plane_owned = cursor.fetchall()

	if (not plane_owned):
		error = f"{airline} does not own plane with plane ID {airplane_id}"
		return render_template('flightreg.html', flights=flight_history, error=error, company=airline)

	#query to see if flight already exists, we know airline_name, flight_number, and depart_ts
	# make up the primary key of Flights
	check_flight = "SELECT * FROM Flights WHERE airline_name = %s AND flight_number = %s AND depart_ts = %s"
	cursor.execute(check_flight, (airline, flight_number, dep_ts))

	#we only need to check if its empty/non-empty
	data = cursor.fetchone()

	if(data):
		#if data is not empty, then the flight must already exist
		error = f"Flight {flight_number} for {airline} already exists"
		return render_template('flightreg.html', flights=flight_history, error=error, company=airline)
	
	#otherwise, this flight does not exist and we can add it to our database
	new_flight = "INSERT INTO Flights VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
	cursor.execute(new_flight, (airline, flight_number, dep_ts, airplane_id, arr_ts, dep_airport_code, arr_airport_code, flight_status, base_price))
	conn.commit()

	#get updated query with new flight
	all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))
	flight_history = cursor.fetchall()
	cursor.close()

	return render_template('flightreg.html', flights=flight_history, company=airline)
	
@app.route('/manageflight', methods = ['GET', 'POST'])
def manageflight():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	cursor = conn.cursor()
	check_flight = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s"
	cursor.execute(check_flight, (airline))
	flights = cursor.fetchall()

	#count number of delayed flights
	count_delayed = "SELECT COUNT(flight_status) AS num_delayed FROM flights WHERE airline_name = %s AND flight_status= 'Delayed'"
	cursor.execute(count_delayed, (airline))
	num_delayed = cursor.fetchone()['num_delayed']

	count_ontime = "SELECT COUNT(flight_status) AS num_ontime FROM flights WHERE airline_name = %s AND flight_status= 'On-time'"
	cursor.execute(count_ontime, (airline))
	num_ontime = cursor.fetchone()['num_ontime']

	#retrieve and display query results of all company flights for initial display
	cursor.close()
	return render_template('modifyflight.html', flights=flights, num_delayed=num_delayed, num_ontime=num_ontime)

@app.route('/staffmodifyflight', methods = ['GET', 'POST'])
def staffmodifyflight():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	# print(f"{request.form}")
	flight_number = request.form['flight_number']
	status = request.form['status']
	# print(f"changed status to {status}")
	# print(f"flight number {flight_number}")
	
	cursor = conn.cursor()

	check_flight = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s AND flight_number = %s"
	cursor.execute(check_flight, (airline, flight_number))
	flight_to_modify = cursor.fetchone()

	#check if empty query
	if (not flight_to_modify):
		error = "Flight not found"
		return render_template('modifyflight.html', error = error)

	#update the flight data and commit it to database server
	update_status = "UPDATE flights SET flight_status = %s WHERE flight_number = %s"
	cursor.execute(update_status, (status, flight_number))
	conn.commit()

	#query to display updated flight	
	check_flight = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(check_flight, (airline))
	flight_to_modify = cursor.fetchall()

	cursor.close()
	return render_template('modifyflight.html', flights=flight_to_modify)

@app.route('/flightdetails', methods=['GET', 'POST'])
def flightdetails():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	#initialize cursor
	cursor = conn.cursor()
	get_avg_flightrating = "SELECT AVG(rating) AS 'average' FROM `reviews` WHERE airline_name = %s"
	cursor.execute(get_avg_flightrating, (airline))
	overall_average = cursor.fetchone()['average']

	cursor.close()

	return render_template('flightviewdetails.html', airline=airline, avgrating = overall_average)

@app.route('/getflightdetails', methods=['GET', 'POST'])
def flightratings():

	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	flight_number = request.form['flight_number']

	#initialize cursor
	cursor = conn.cursor()
	get_avg_flightrating = "SELECT AVG(rating) AS 'average' FROM `reviews` WHERE airline_name = %s"
	cursor.execute(get_avg_flightrating, (airline))
	overall_average = cursor.fetchone()['average']

	get_avgforflight = "SELECT AVG(rating) AS 'average' FROM `reviews` WHERE airline_name = %s AND flight_number = %s"
	cursor.execute(get_avgforflight, (airline, flight_number))
	avg_forflight = cursor.fetchone()

	if(not avg_forflight):
		error = f"Flight number {flight_number} not found."
		return render_template('flightviewdetails.html', airline=airline, avgrating = overall_average, error=error)

	check_flight = "SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, A.city as arrival, D.city as depart, F.flight_status, F.base_price FROM flights as F, airport as A, airport as D WHERE F.arrival_airport_code = A.code and F.depart_airport_code = D.code AND airline_name = %s AND flight_number = %s"
	cursor.execute(check_flight, (airline, flight_number))
	flights = cursor.fetchall()

	if(not flights):
		error = f"Flight number {flight_number} not found."
		return render_template('flightviewdetails.html', airline=airline, avgrating = overall_average, error=error)
	
	get_customers = "SELECT DISTINCT C.email AS email, C.customer_name AS name, C.phone_number AS phone_number, COUNT(C.email) AS tickets_purchased FROM Ticket AS T, Purchases AS P, Flights AS F, Customer AS C WHERE F.airline_name = %s AND F.flight_number = %s AND F.flight_number = T.flight_number AND T.ticket_id = P.ticket_id AND C.email = P.email GROUP BY(C.email)"
	cursor.execute(get_customers, (airline, flight_number))
	customers = cursor.fetchall()
	
	get_feedback = "SELECT email, rating, comments FROM reviews WHERE airline_name = %s AND flight_number = %s"
	cursor.execute(get_feedback, (airline, flight_number))
	comments = cursor.fetchall()
	cursor.close()
	return render_template('flightviewdetails.html', airline=airline, flights=flights, avgrating = overall_average, flight_number = flight_number, avgforflight=avg_forflight['average'], customers = customers, reviews=comments)

@app.route('/financialanalytics', methods = ['GET', 'POST'])
def financialanalytics():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	#session cursor
	cursor = conn.cursor()

	#view frequent customers
	get_top_customers = "SELECT P.email, P.name_on_card, COUNT(P.email) as frequency FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND P.purchase_ts BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW() GROUP BY P.email ORDER BY frequency DESC"
	cursor.execute(get_top_customers, (airline))
	top_customers = cursor.fetchall()

	#view reports
	get_summary = "SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, COUNT(T.flight_number) as total_purchases FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s GROUP BY Year, Month ORDER BY Year, Month"
	cursor.execute(get_summary, (airline))
	summary = cursor.fetchall()

	#view revenue by month/year
	#past month
	get_month_revenue = "SELECT SUM(P.sell_price) as Revenue FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND YEAR(P.purchase_ts) = YEAR(NOW()) AND MONTH(P.purchase_ts) = MONTH(NOW())"
	cursor.execute(get_month_revenue, (airline))
	month_revenue = cursor.fetchone()

	#past year
	get_year_revenue = "SELECT SUM(P.sell_price) as Revenue FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND YEAR(P.purchase_ts) = YEAR(NOW())"
	cursor.execute(get_year_revenue, (airline))
	year_revenue = cursor.fetchone()

	#view top 3 destinations
	#past 3 months
	get_top_destinations_month = "SELECT B.city as destination_city, COUNT(B.city) as frequency FROM flights as F, airport as A, airport as B, ticket AS T, purchases as P WHERE B.code = F.arrival_airport_code AND A.code = F.depart_airport_code AND F.airline_name = %s and T.ticket_id = P.ticket_id and T.flight_number = F.flight_number AND F.depart_ts BETWEEN DATE_SUB(NOW(), INTERVAL 3 MONTH) AND NOW() GROUP BY B.city ORDER BY frequency DESC LIMIT 3"
	cursor.execute(get_top_destinations_month, (airline))
	top_destinations_month = cursor.fetchall()

	#past year
	get_top_destinations_year = "SELECT B.city as destination_city, COUNT(B.city) as frequency FROM flights as F, airport as A, airport as B, ticket AS T, purchases as P WHERE B.code = F.arrival_airport_code AND A.code = F.depart_airport_code AND F.airline_name = %s and T.ticket_id = P.ticket_id and T.flight_number = F.flight_number AND YEAR(F.depart_ts) = YEAR(NOW()) GROUP BY B.city ORDER BY frequency DESC LIMIT 3"
	cursor.execute(get_top_destinations_year, (airline))
	top_destinations_year = cursor.fetchall()

	cursor.close()

	return render_template("staffanalytics.html", frequentflyers = top_customers, popular_places_month=top_destinations_month, popular_places_year=top_destinations_year, month_revenue=month_revenue['Revenue'], year_revenue=year_revenue['Revenue'], summary=summary)

@app.route('/getanalytics', methods = ['GET', 'POST'])
def getanalytics():
	#making sure only staff can access this page
	if session['type'] == 'customer':
		abort(401)
	airline = session["employer"]

	#session cursor
	cursor = conn.cursor()

	#view frequent customers
	get_top_customers = "SELECT P.email, P.name_on_card, COUNT(P.email) as frequency FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND P.purchase_ts BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW() GROUP BY P.email ORDER BY frequency DESC"
	# get_top_customers = "SELECT P.email, P.name_on_card, COUNT(P.email) as frequency FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s GROUP BY P.email ORDER BY frequency DESC"
	cursor.execute(get_top_customers, (airline))
	top_customers = cursor.fetchall()

	#view reports
	get_summary = "SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, COUNT(T.flight_number) as total_purchases FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s GROUP BY Year, Month ORDER BY Year, Month"
	cursor.execute(get_summary, (airline))
	summary = cursor.fetchall()

	#get from form
	form_ts_start = request.form['ts_start']
	form_ts_end = request.form['ts_end']

	ts_start = datetime.datetime.strptime(form_ts_start, "%Y-%m-%d")
	ts_end = datetime.datetime.strptime(form_ts_end, "%Y-%m-%d")

	#view tickets sold by custom range
	get_custom_summary = f"SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, COUNT(T.flight_number) as total_purchases FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND P.purchase_ts BETWEEN '{ts_start}' AND '{ts_end}' GROUP BY Year, Month ORDER BY Year, Month"
	# get_custom_summary = "SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, COUNT(T.flight_number) as total_purchases FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s GROUP BY Year, Month ORDER BY Year, Month"
	cursor.execute(get_custom_summary, (airline))
	custom_summary = cursor.fetchall()

	#view revenue by month/year
	#past month
	get_month_revenue = "SELECT SUM(P.sell_price) as Revenue FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND YEAR(P.purchase_ts) = YEAR(NOW()) AND MONTH(P.purchase_ts) = MONTH(NOW())"
	cursor.execute(get_month_revenue, (airline))
	month_revenue = cursor.fetchone()

	#past year
	get_year_revenue = "SELECT SUM(P.sell_price) as Revenue FROM purchases as P, ticket as T WHERE P.ticket_id = T.ticket_id and T.airline_name = %s AND YEAR(P.purchase_ts) = YEAR(NOW())"
	cursor.execute(get_year_revenue, (airline))
	year_revenue = cursor.fetchone()

	#view top 3 destinations
	#past 3 months
	get_top_destinations_month = "SELECT B.city as destination_city, COUNT(B.city) as frequency FROM flights as F, airport as A, airport as B, ticket AS T, purchases as P WHERE B.code = F.arrival_airport_code AND A.code = F.depart_airport_code AND F.airline_name = %s and T.ticket_id = P.ticket_id and T.flight_number = F.flight_number AND F.depart_ts BETWEEN DATE_SUB(NOW(), INTERVAL 3 MONTH) AND NOW() GROUP BY B.city ORDER BY frequency DESC LIMIT 3"
	cursor.execute(get_top_destinations_month, (airline))
	top_destinations_month = cursor.fetchall()

	#past year
	# get_top_destinations_year = "SELECT B.city as destination_city, COUNT(B.city) as frequency FROM flights as F, airport as A, airport as B, ticket AS T, purchases as P WHERE B.code = F.arrival_airport_code AND A.code = F.depart_airport_code AND F.airline_name = %s and T.ticket_id = P.ticket_id and T.flight_number = F.flight_number AND YEAR(F.depart_ts) = YEAR(NOW()) GROUP BY B.city ORDER BY frequency DESC LIMIT 3"
	get_top_destinations_year = "SELECT B.city as destination_city, COUNT(B.city) as frequency FROM flights as F, airport as A, airport as B, ticket AS T, purchases as P WHERE B.code = F.arrival_airport_code AND A.code = F.depart_airport_code AND F.airline_name = %s and T.ticket_id = P.ticket_id and T.flight_number = F.flight_number AND F.depart_ts BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW() GROUP BY B.city ORDER BY frequency DESC LIMIT 3"

	cursor.execute(get_top_destinations_year, (airline))
	top_destinations_year = cursor.fetchall()

	cursor.close()

	return render_template("staffanalytics.html", frequentflyers = top_customers, popular_places_month=top_destinations_month, popular_places_year=top_destinations_year, month_revenue=month_revenue['Revenue'], year_revenue=year_revenue['Revenue'], summary=summary,custom_summary=custom_summary)

def somequeries():
	'''
	based on the airline you work for, perform the following queries:

	template below:
	'''
	
	'''
	SELECT 
	FROM
	WHERE
	'''
	#get all flights in the upcoming 30 days
	#
	'''
	time_now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	time_in_30days = time_now + datetime.timedelta(days=30)

	SELECT *
	FROM Flights
	WHERE airline_name = %s AND depart_ts BETWEEN %s[time_now] AND %s[time_in_30days]
	'''
	# SELECT * FROM `flights` WHERE depart_ts BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY);
	

	#get all flights based on range of dates (start and end)
	'''
	SELECT *
	FROM Flights
	WHERE airline_name = %s AND depart_ts BETWEEN %s[start_date] AND %s[end_date]
	'''

	#get all flights based on source airport
	'''
	SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price
	FROM Flights AS F, Airport AS A
	WHERE F.airline_name = %s AND  F.depart_airport_code = A.code AND A.airport_name = %s
	'''
	# SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price FROM Flights AS F, Airport AS A WHERE F.airline_name = "American Airlines" AND F.depart_airport_code = A.code AND A.airport_name = "TOK";

	#get all flights based on source city
	'''
	SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price,
	FROM Flights AS F, Airport AS A
	WHERE F.airline_name = %s AND  F.depart_airport_code = A.code AND A.city = %s
	'''
	# SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price FROM flights AS F, airport AS A WHERE F.airline_name = "American Airlines" AND F.arrival_airport_code = A.code AND A.city = "Paris";


	#get all flights based on destination airport
	'''
	SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price
	FROM Flights AS F, Airport AS A
	WHERE F.airline_name = %s AND  F.arrival_airport_code = A.code AND A.airport_name = %s
	'''

	#get all flights based on destination city
	'''
	SELECT F.airline_name, F.flight_number, F.depart_ts, F.airplane_id, F.arrival_ts, F.depart_airport_code, F.arrival_airport_code, F.flight_status, F.base_price,
	FROM Flights AS F, Airport AS A
	WHERE F.airline_name = %s AND  F.arrival_airport_code = A.code AND A.city = %s
	'''

	#see all customers of a particular flight
	'''
	SELECT C.email AS email, C.customer_name AS name
	FROM Ticket AS T, Purchases AS P, Flights AS F, Customer AS C
	WHERE F.airline_name = %s AND F.flight_number = %s AND F.flight_number = T.flight_number AND T.ticket_id = P.ticket_id AND C.email = P.email
	'''

	#view each flight's average ratings
	'''
	SELECT flight_number, depart_ts, AVG(rating)
	FROM Reviews
	WHERE airline_name = %s
	GROUP BY flight_number, depart_ts
	ORDER BY AVG(rating) DESC
	'''

	#view comments and ratings of the flight given by the customer
	'''
	SELECT rating, comments
	FROM Reviews
	WHERE airline_name = %s AND flight_number = %s 
	'''

	#view the most frequent customer within the past year to the air line you work for
	'''
	SELECT C.email, C.customer_name, C.phone_number, COUNT(P.ticket_id) AS frequency 
	FROM customer AS C, purchases AS P, ticket AS T 
	WHERE C.email = P.email AND T.ticket_id = P.ticket_id AND T.airline_name = "American Airlines" AND depart_ts BETWEEN DATE_SUB(NOW(), INTERVAL 1 YEAR) AND NOW() 
	GROUP BY C.email 
	ORDER BY COUNT(P.ticket_id) DESC;
	'''

	#show all the flights a particular customer has taken with that airline
	'''
	SELECT T.flight_number, T.ticket_id FROM customer AS C, purchases AS P, ticket AS T WHERE C.email = P.email AND T.ticket_id = P.ticket_id AND T.airline_name = "American Airlines" AND C.email = "dummy@nyu.edu";
	'''


	#show total number of tickets sold based on a range of dates/past year/last month/etc
	''' something similar to:
	SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, SUM(P.sell_price) as Revenue
	FROM purchases as P, ticket as T
	WHERE P.ticket_id = T.ticket_id and T.airline_name = "American Airlines"
	GROUP BY Year, Month
	ORDER BY Revenue;
	'''
	#show monthwise ticket sales in a barchart/table

	#show the total amount of revenue earned from ticket sales in the last month and last year
	'''
	most revenue by month of the year (not exact but maybe useful later)
	SELECT YEAR(P.purchase_ts) as Year, MONTH(P.purchase_ts) as Month, SUM(P.sell_price) as Revenue
	FROM purchases as P, ticket as T
	WHERE P.ticket_id = T.ticket_id and T.airline_name = "American Airlines"
	GROUP BY Year, Month
	ORDER BY Revenue
	'''
	#find the 3 most popular destination in the past 3 months and past year (based on tickets sold)

	return 0
"""
LOGOUT
"""
# Logout
@app.route('/logout')
def logout():
	#debugging
	# print(f"session = {session}")
	if 'error' in session:
		session.pop('error')
	if 'ticket_id' in session:
		session.pop('ticket_id')
	if 'type' in session:
		sessiontype = session.pop('type')
		if sessiontype == 'staff':
			session.pop('employer')

	if 'username' in session:
		session.pop('username')

	return redirect('/')


app.secret_key = 'i dont know what this is'
if __name__ == '__main__':
    app.run(debug=True)
