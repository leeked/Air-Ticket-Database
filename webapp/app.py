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

# Index Route
@app.route('/')
def index():
    return render_template('index.html')


"""
LOGIN
"""

# Login Route
@app.route('/login')
def login():
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



# Home Route
@app.route('/home')
def home():
	return "hello xd"

app.secret_key = 'i dont know what this is'
if __name__ == '__main__':
    app.run(debug=True)
