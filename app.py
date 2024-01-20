import os
import psycopg2
from dotenv import load_dotenv
from flask import Flask, request
import json
from recycling_app_func import get_data_from_request

load_dotenv()

app = Flask(__name__)
url = os.getenv('DATABASE_URL')
# print(url)
connection = psycopg2.connect(url)
# создаю все необходимые таблицы базы данных
try:
    with connection:
        with connection.cursor() as cursor:
            with open('sql/table_creation.sql', 'r') as f:
                DATABASE_CREATION = f.read()
            cursor.execute(DATABASE_CREATION)
except Exception as e:
    print(e)
    pass


@app.get("/")
def home():
    return "HOME PAGE"


@app.get("/api/users_number")
def users_num():
    with connection:
        with connection.cursor() as cursor:
            with open('sql/users_number.sql', 'r') as f:
                USERS_NUM = f.read()
            print(USERS_NUM)
            cursor.execute(USERS_NUM)
            users_number = cursor.fetchone()[0]
            print(users_number)
    return {'users_number': users_number, 'message': f'There are {users_number} users'}, 200


@app.post("/api/new_user")
def create_new_user():
    data = get_data_from_request(request)

    # получаю переданные параметры
    surname = data['surname'] 
    name = data['name']
    email = data['email']
    password = data['password']
    phone = data['phone']
    country = data['country']

    with connection:
        with connection.cursor() as cursor:
            with open('sql/check_user_existence.sql', 'r') as f:
                CHECK_USER = f.read()
            print(CHECK_USER)
            cursor.execute(CHECK_USER, (email, ))
            user_id = cursor.fetchone()
            print(user_id)

            # Если пользователь с таким email есть, то выходим из функции
            if user_id:
                return {'message': f'User with email: {email} already exists'}, 200
            with open('sql/insert_user_return_id.sql', 'r') as f:
                CREATE_NEW_USER = f.read()
            print(CREATE_NEW_USER)
            cursor.execute(CREATE_NEW_USER, (surname, name, email, password, phone, country))
            user_id = cursor.fetchone()[0]
            print(user_id)
    return {'user_id': user_id, 'message': f'User {user_id} with email {email} created.'}, 201

@app.post("/api/login")
def login_user():
    data = get_data_from_request(request)

    # получаю переданные параметры
    email = data['email']
    password = data['password']

    with connection:
        with connection.cursor() as cursor:
            with open('sql/login_user.sql', 'r') as f:
                LOGIN_USER = f.read()
            print(LOGIN_USER)
            cursor.execute(LOGIN_USER, (email, ))
            response = cursor.fetchone()

            # Если пользователь с таким email есть, то сравниваем пароли
            if response:
                print(response[2])
                if password == response[2]:
                    return {'message': f'User with email: {email} logged in successfully'}, 200
                else:
                    return {'message': f'Password is incorrect. Please, try again'}, 300
            else:
                return {'message': f'User with email: {email} does not exists'}
