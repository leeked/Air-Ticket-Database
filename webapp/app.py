from flask import Flask, render_template, request, session, url_for, redirect
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
	return render_template('staffreg.html')

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
		username = request.form['username']
		password = request.form['password']
		fname = request.form['fname']
		lname = request.form['lname']
		DoB = request.form['DoB']

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
			return render_template('staffreg.html', error = error)
		else:
			ins = "INSERT INTO airline_staff VALUES(%s, MD5(%s), %s, %s, %s)"
			cursor.execute(ins, (username, password, fname, lname, DoB))
			conn.commit()
			cursor.close()
			return render_template('index.html')

	# For Customer/User
	#grabs information from the forms
	username = request.form['email']
	name = request.form['name']
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

	# Show all upcoming flights
	cursor = conn.cursor()

	query = "SELECT flights.airline_name, ticket.flight_number, depart_airport_code, arrival_airport_code, flights.depart_ts, arrival_ts, flight_status "\
		"FROM purchases INNER JOIN ticket USING (ticket_id) INNER JOIN flights USING (flight_number) "\
		"WHERE purchases.email = %s"

	cursor.execute(query,(username))

	data = cursor.fetchall()
	display_name = 0

	# Change display name based on user type
	if usertype=='customer':
		query = 'SELECT customer_name FROM customer WHERE email = %s'

		cursor.execute(query, (username))
		
		display_name = cursor.fetchone()['customer_name']

	elif usertype=='staff':
		query = 'SELECT first_name FROM airline_staff WHERE username = %s'

		cursor.execute(query, (username))

		display_name = cursor.fetchone()['first_name']


	cursor.close()
	return render_template('home.html', flights=data, display_name=display_name, usertype=usertype)

"""
SEARCH
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
	username=session['username']
	airline_name=request.form['airline_name']
	flight_num=request.form['flight_num']
	depart_ts=request.form['depart_ts']
	rating=request.form['rating']
	review=request.form['review']
	curr_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

	cursor = conn.cursor()

	# Get real depart_ts
	get_ts = 'SELECT depart_ts FROM flights WHERE airline_name = %s AND flight_number = %s AND DATE(depart_ts) = %s'

	cursor.execute(get_ts, (airline_name, flight_num, depart_ts))

	ts = cursor.fetchone()

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
	#debugging to see whats in session object
	print(f"session = {session}")
	#get username for welcome, employer to only show company information
	username=session['username']
	airline = session["employer"]
	cursor = conn.cursor()

	#query all flights under that Airline
	all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))

	data = cursor.fetchall()
	cursor.close()
	return render_template('flightmanager.html', flights=data, username=username)

@app.route('/flightreg')
def flightreg():
	return render_template('flightreg.html')

@app.route('/airplanereg', methods=['GET', 'POST'])
def airplanereg():
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

	#query to see if flight already exists, we know airline_name, flight_number, and depart_ts
	# make up the primary key of Flights
	check_flight = "SELECT * FROM Flights WHERE airline_name = %s AND flight_number = %s AND depart_ts = %s"
	cursor.execute(check_flight, (airline, flight_number, dep_ts))

	#we only need to check if its empty/non-empty
	data = cursor.fetchone()

	if(data):
		#if data is not empty, then the flight must already exist
		error = f"Flight {flight_number} for {airline} already exists"
		return render_template('flightreg.html', error=error)
	
	#otherwise, this flight does not exist and we can add it to our database
	new_flight = "INSERT INTO Flights VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s)"
	cursor.execute(new_flight, (airline, flight_number, dep_ts, airplane_id, arr_ts, dep_airport_code, arr_airport_code, flight_status, base_price))
	conn.commit()

	all_flights = "SELECT * FROM Flights WHERE airline_name = %s"
	cursor.execute(all_flights, (airline))
	flight_history = cursor.fetchall()

	return render_template('flightreg.html', flights=flight_history, company=airline)
	
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
