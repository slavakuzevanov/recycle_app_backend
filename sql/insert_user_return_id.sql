INSERT INTO "User" (surname, name, email, password, phone, country)
VALUES (%s, %s, %s, %s, %s, %s)
RETURNING user_id;