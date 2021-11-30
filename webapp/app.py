from flask import Flask, render_template, request, session, url_for, redirect
import pymysql.cursors

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

	# If Staff
	if request.form.get('login_type') == 'on':
		#executes query
		query = 'SELECT * FROM airline_staff WHERE username = %s and staff_password = MD5(%s)'
		cursor.execute(query, (username, password))
		#stores the results in a variable
		data = cursor.fetchone()
		#use fetchall() if you are expecting more than 1 data row
		cursor.close()
		error = None
		if(data):
			#creates a session for the the user
			#session is a built in
			session['username'] = username
			session['type'] = 'staff'
			return redirect(url_for('home'))
		else:
			#returns an error message to the html page
			error = 'Invalid login or username'
			return render_template('login.html', error=error)
	
	# If Customer
	else:
		#executes query
		query = 'SELECT * FROM customer WHERE email = %s and customer_password = MD5(%s)'
		cursor.execute(query, (username, password))
		#stores the results in a variable
		data = cursor.fetchone()
		#use fetchall() if you are expecting more than 1 data row
		cursor.close()
		error = None
		if(data):
			#creates a session for the the user
			#session is a built in
			session['username'] = username
			session['type'] = 'customer'
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
LOGOUT
"""

# Logout
@app.route('/logout')
def logout():
	session.pop('username')
	return redirect('/')


app.secret_key = 'i dont know what this is'
if __name__ == '__main__':
    app.run(debug=True)
