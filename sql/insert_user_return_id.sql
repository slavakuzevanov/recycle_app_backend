INSERT INTO "User" (surname, name, email, phone, country)
VALUES (%s, %s, %s, %s, %s)
RETURNING user_id;