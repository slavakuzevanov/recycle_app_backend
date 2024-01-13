import os
import psycopg2
from dotenv import load_dotenv
from flask import Flask, request
import json

with open('sql/table_creation.sql', 'r') as f:
    DATABASE_CREATION = f.read()

# print(creation_sql)


load_dotenv()

app = Flask(__name__)
url = os.getenv('DATABASE_URL')
# print(url)
connection = psycopg2.connect(url)
# создаю все необходимые таблицы базы данных
try:
    with connection:
        with connection.cursor() as cursor:
            cursor.execute(DATABASE_CREATION)
except Exception as e:
    print(e)
    pass


@app.get("/")
def home():
    return "HOME PAGE"

@app.post("/api/new_user")
def create_new_user():
    mimetype = request.mimetype
    if mimetype == 'application/x-www-form-urlencoded':
        data = request.form.to_dict()
    elif mimetype == 'multipart/form-data':
        data = dict(request.form)
    elif mimetype == 'application/json':
        data = request.json
    else:
        data = request.data.decode()
    print(mimetype, data, type(data))

    # получаю переданные параметры
    surname = data['surname'] 
    name = data['name']
    email = data['email']
    phone = data['phone']
    country = data['country']
    with connection:
        with connection.cursor() as cursor:
            with open('sql/insert_user_return_id.sql', 'r') as f:
                CREATE_NEW_USER = f.read()
            print(CREATE_NEW_USER)
            cursor.execute(CREATE_NEW_USER, (surname, name, email, phone, country))
            user_id = cursor.fetchone()[0]
    return {'user_id': user_id, 'message': f'User {user_id} with email {email} created.'}, 201