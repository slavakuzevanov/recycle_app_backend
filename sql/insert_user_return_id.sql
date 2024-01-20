INSERT INTO "User" (name, email, password)
VALUES (%s, %s, %s)
RETURNING user_id;