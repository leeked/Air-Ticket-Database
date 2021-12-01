from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors
from datetime import datetime

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
	cursor = conn.cursor()

	query = "SELECT flights.airline_name, ticket.flight_number, depart_airport_code, arrival_airport_code, flights.depart_ts, arrival_ts, flight_status "\
		"FROM purchases INNER JOIN ticket USING (ticket_id) INNER JOIN flights USING (flight_number) "\
		"WHERE purchases.email = %s"

	cursor.execute(query,(username))

	data = cursor.fetchall()
	display_name = 0

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
	flight_num = request.form['flight_num']
	cursor = conn.cursor()

	query = 'SELECT * FROM ticket WHERE flight_number = %s AND ticket.ticket_id NOT IN (SELECT purchases.ticket_id FROM purchases)'

	cursor.execute(query, (flight_num))

	res = cursor.fetchall()

	cursor.close()

	return render_template('purchasepage.html', res=res, searched=True)

@app.route('/purchaseTicket', methods=['POST'])
def purchaseTicket():
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
	email = request.form['email']
	card_type = request.form['card_type']
	card_number = request.form['card_number']
	name_on_card = request.form['name_on_card']
	exp_date = request.form['exp_date']
	purchase_ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
	ticket_id = 0
	purchase_price = 0

	if 'ticket_id' in session:
		ticket_id = session.pop('ticket_id')
	else:
		error = 'Session lost Ticket ID!'
		return render_template('purchasepage.html', error=error)

	cursor = conn.cursor()

	query = 'SELECT price FROM available_tickets WHERE ticket_id = %s'

	cursor.execute(query, (ticket_id))

	res_price = cursor.fetchone()

	if res_price:
		purchase_price = res_price['price']
	else:
		error = 'This ticket is no longer available!'
		cursor.close()
		return render_template('purchasepage.html', error=error)

	ins = 'INSERT INTO purchases VALUES(%s, %s, %s, %s, %s, %s, %s, %s)'

	cursor.execute(ins, (ticket_id, email, card_type, card_number, name_on_card, exp_date, purchase_ts, purchase_price))
	conn.commit()
	cursor.close()

	return render_template('purchasesuccess.html')


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
