from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

# Retrieve the database URL from environment variables
DB_URL = os.environ.get("DATABASE_URL",  "postgresql://${azurerm_postgresql_server.jobathon.name}.postgres.database.azure.com:5432/${azurerm_postgresql_database.jobathon.name}?sslmode=require&user=${azurerm_postgresql_server.jobathon.administrator_login}@${azurerm_postgresql_server.jobathon.name}&password=${azurerm_postgresql_server.jobathon.administrator_login_password}")

# Configure the Flask application to use the database
app.config['SQLALCHEMY_DATABASE_URI'] = DB_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Create a SQLAlchemy database instance
db = SQLAlchemy(app)

# Define a simple model for demonstration
class ExampleModel(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(255))

# Create tables in the database (this is a simplified example)
db.create_all()

@app.route('/live')
def live():
    try:
        # Example: Insert data into the database
        example_data = ExampleModel(data="Hello, Database!")
        db.session.add(example_data)
        db.session.commit()

        # Example: Query data from the database
        result = ExampleModel.query.first()
        
        return f'Well done: Application connected to the database at {DB_URL}. Data from the database: {result.data}'
    except Exception as e:
        print(f"Error connecting to the database: {e}")
        return 'Maintenance: Some error occurred during the connection with the database', 500

if __name__ == '__main__':
    app.run(debug=True, port=int(os.environ.get("PORT", 5000)))
