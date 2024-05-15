-- Hashed passsword is: $2b$12$V/cXqWN/M2vTnYUcXMB9oODcNBX/QorJekmaDkq1Z7aeD3I5ZAjfu


DROP TABLE IF EXISTS roles;
--skal muligvis sættes anderledes op
CREATE TABLE roles(
    role_id INTEGER UNIQUE,
    role_name TEXT UNIQUE,
    PRIMARY KEY(role_id)
) WITHOUT ROWID;

INSERT INTO roles VALUES (1,'admin'), (2,'partner'), (3,'user');

DROP TABLE IF EXISTS users;
--TODO_ændre pk til id:
--TODO:verification_key skal være uniqe
--TODO: tilføj is_deleted(soft delete)
CREATE TABLE users(
    user_pk                 TEXT,
    user_username           TEXT,
    user_first_name               TEXT,
    user_last_name          TEXT,
    user_email              TEXT UNIQUE,
    user_password           TEXT,
    role_id                 INTEGER,
    user_created_at         INTEGER,
    user_updated_at         INTEGER,
    user_verification_key   TEXT UNIQUE,
    user_is_verified        INTEGER,
    user_is_verified_at     INTEGER,
    user_is_blocked         INTEGER,
    FOREIGN KEY(role_id) REFERENCES roles(role_id),
    PRIMARY KEY(user_pk)
) WITHOUT ROWID;


--admin-user
INSERT INTO users VALUES(
    "d11854217ecc42b2bb17367fe33dc8f4",
    "johndoe",
    "John",
    "Doe",
    "admin@company.com",
    "$2b$12$V/cXqWN/M2vTnYUcXMB9oODcNBX/QorJekmaDkq1Z7aeD3I5ZAjfu",
    (SELECT role_id FROM roles WHERE role_name = 'admin'),
    1712674758,
    0,
    1,
    1,
    1,
    0
);

--partner-user
INSERT INTO users VALUES(
    "d11854217ecc42b2bb17367fe33dc8f5",
    "janedoe",
    "Jane",
    "Doe",
    "partner@partner.com",
    "$2b$12$V/cXqWN/M2vTnYUcXMB9oODcNBX/QorJekmaDkq1Z7aeD3I5ZAjfu",
    (SELECT role_id FROM roles WHERE role_name = 'partner'),
    1712674758,
    0,
    2,
    1,
    1,
    0
);
--user_user
INSERT INTO users VALUES(
    "d11854217ecc42b2bb17367fe33dc8f6",
    "userUser",
    "Just",
    "Auser",
    "user@user.com",
    "$2b$12$V/cXqWN/M2vTnYUcXMB9oODcNBX/QorJekmaDkq1Z7aeD3I5ZAjfu",
    (SELECT role_id FROM roles WHERE role_name = 'user'),
    1712674758,
    0,
    3,
    1,
    1,
    0
);


DROP TABLE IF EXISTS items;
--TODO_ændre pk til id:
CREATE TABLE items(
    item_pk                         TEXT,
    item_name                       TEXT,
    item_splash_image               TEXT,
    item_lat                        TEXT,
    item_lon                        TEXT,
    item_stars                      REAL,
    item_price_per_night            REAL,
    item_created_at                 INTEGER,
    item_updated_at                 INTEGER,
    item_is_blocked                 INTEGER,
    item_blocked_updated_at         INTEGER,
    item_owned_by                   TEXT,
    PRIMARY KEY(item_pk)
) WITHOUT ROWID;

INSERT INTO items VALUES
("5dbce622fa2b4f22a6f6957d07ff4951", "Christiansborg Palace", "5dbce622fa2b4f22a6f6957d07ff4951.webp", 55.6761, 12.5770, 5, 2541, 1, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4952", "Tivoli Gardens", "5dbce622fa2b4f22a6f6957d07ff4952.webp", 55.6736, 12.5681, 4.97, 985, 2, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4953", "Nyhavn", "5dbce622fa2b4f22a6f6957d07ff4953.webp", 55.6794, 12.5918, 3.45, 429, 3, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4954", "The Little Mermaid statue", "5dbce622fa2b4f22a6f6957d07ff4954.webp", 55.6929, 12.5998, 4, 862, 4, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4955", "Amalienborg Palace", "5dbce622fa2b4f22a6f6957d07ff4955.webp", 55.6846, 12.5949, 2.67, 1200, 5, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4956", "Copenhagen Opera House", "5dbce622fa2b4f22a6f6957d07ff4956.webp",  55.6796, 12.6021, 4.57, 1965, 6, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4957", "Rosenborg Castle", "5dbce622fa2b4f22a6f6957d07ff4957.webp", 55.6867, 12.5734, 4, 1700, 7, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4958", "The National Museum of Denmark", "5dbce622fa2b4f22a6f6957d07ff4958.webp", 55.6772, 12.5784, 5, 2100, 8, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4959", "Church of Our Saviour", "5dbce622fa2b4f22a6f6957d07ff4959.webp", 55.6732, 12.5986, 4.3, 985, 9, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5"),
("5dbce622fa2b4f22a6f6957d07ff4910", "Round Tower", "5dbce622fa2b4f22a6f6957d07ff4910.webp",  55.6813, 12.5759, 4.8, 1200, 10, 0,0,0,"d11854217ecc42b2bb17367fe33dc8f5");

-- (page_number - 1) * items_per_page
-- (1 - 1) * 3 = 10 1 2
-- (2 - 1) * 3 = 3 4 5
-- (3 - 1) * 3 = 6 7 8


-- Page 4
-- 0 3 6 9
SELECT * FROM items 
ORDER BY item_created_at
LIMIT 9,3;


-- offset = (currentPage - 1) * itemsPerPage
-- page 1 = 1 2 3+
-- page 2 = 4 5 6
-- page 3 = 7 8 9
-- page 4 = 10
SELECT * FROM items 
ORDER BY item_created_at
LIMIT 3 OFFSET 9;

SELECT * FROM items WHERE item_pk = '5dbce622fa2b4f22a6f6957d07ff4910';

UPDATE items 
SET item_is_blocked = 1, item_blocked_updated_at = 2 
WHERE item_pk = '5dbce622fa2b4f22a6f6957d07ff4910';

SELECT * FROM items;

UPDATE users
SET user_username ='updateuserName',  user_first_name='updateName', user_last_name='updateLastName', 
 user_email = 'updateEmail',  user_updated_at=67 WHERE user_pk='d11854217ecc42b2bb17367fe33dc8f6';         
             

UPDATE users
SET user_is_verified = 1,
    user_is_verified_at = 2222
WHERE user_verification_key = '18c0312bf32345aea8c4cb6b980ba958';

DELETE FROM users WHERE user_pk='a749ea0f2dac49f286c7377443d7148d';

SELECT 
    users.user_username,
    users.user_email
FROM 
    items
JOIN 
    users
ON 
    items.item_owned_by = users.user_pk
WHERE 
    items.item_pk = 'd11854217ecc42b2bb17367fe33dc8f5';










