### What is PostgreSQL?

- PostgreSQL is an advanced, enterprise-class, and open-source relational database system. PostgreSQL supports both SQL (relational) and JSON (non-relational) querying.

- PostgreSQL is a highly stable database backed by more than 20 years of development by the open-source community.

- PostgreSQL is used as a primary database for many web applications as well as mobile and analytics applications.

---

### PostgreSQL Installation on ubuntu

If you not installed the postgreSQL, use this command,

---

database owner change

ALTER DATABASE name OWNER TO new_owner;

revoke database permissoion

revoke all on database common from usera;

To view the user privileges \du+

schema list
SELECT schema_name
FROM information_schema.schemata;

user permission

first connect with database

GRANT CONNECT ON DATABASE database_name TO username;

second

rgrant permission in schema

GRANT USAGE ON SCHEMA schema_name TO username;

specific permission given to user
GRANT SELECT ON table_name TO username;

or

GRANT SELECT ON ALL TABLES IN SCHEMA schema_name TO username;






---

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

### Uninstall the postgres

If you uninstalled the packages, use this command,

```bash
sudo apt-get --purge remove postgresql postgresql-*
sudo apt autoremove
```

### Start the service

```bash
sudo systemctl start postgresql.service
```

### Check the status of the service

```bash
sudo systemctl status postgresql.service
```

**Database Details:**
---------------------
|db_name|Table_name|
|-------|----------|
|demo|users|
|demo|photos|
|demo|comments|

**Login into the postgreSQL server**
-----------------------------------

```bash
sudo -u postgres psql
```

**Check the version of psql**
---------------------------

```bash
SELECT version();
```

**Create the database**
-------------------------

```bash
CREATE DATABASE demo
```
**DROP DATABASE**
-------------
- If you want to delete the database. Use this command,
```bash
# DROP TABLE
DROP DATABASE demo;
```

**Enter into the database**
---------------------------

```bash
\c demo
```

**Create the table inside the database**
------------------------------------------

```bash
CREATE TABLE users (
	id serial PRIMARY KEY,
	username VARCHAR ( 50 ) NOT NULL
);
```

```bash
CREATE TABLE photos (
   id serial PRIMARY KEY,
   photo_name VARCHAR ( 50 ) NOT NULL,
   user_id INTEGER REFERENCES users(id)
);
```

```bash
CREATE TABLE comments (
   id serial PRIMARY KEY,
   content VARCHAR ( 50 ) NOT NULL,
   user_id INTEGER REFERENCES users(id),
   photo_id INTEGER REFERENCES photos(id)
);
```
**DROP TABLE**
-------------
If you want to delete the table. use this below command,
```bash
# DROP TABLE
DROP TABLE users;
```
**Insert the values into 3 tables**
-----------------------------------

```bash
INSERT INTO users (username) VALUES ('joe'),('vicky'),('mervin'),('joseph'),('johnson'),('ashli');
```

```bash
INSERT INTO photos (photo_name,user_id) VALUES ('nature',2),('rainbow',3),('rainfall',5),('flower',6),('rabbit',1),('elephant',4);
```

```bash
INSERT INTO comments (content,user_id,photo_id) VALUES ('looks so beautiful',2,2),('it is a big bunny',4,1),('rainfall is awesome',5,4);
```

**To view the detailed content in table using SELECT statement**
-------------------------------------------------------------------

```bash
SELECT * FROM users;
SELECT * FROM comments;
SELECT * FROM photos;
```

**To view the specified column in table using SELECT statement with WHERE Condidtion**
---------------------------------------------------------------------------------------

```bash
SELECT content,user_id FROM comments;
SELECT username FROM users WHERE id=6;
```

**Arithmetic operators**
------------------------

```bash
SELECT content, user_id + photo_id AS sum_content FROM comments;
SELECT content, user_id * photo_id AS mul_content FROM comments;
```
![image](https://user-images.githubusercontent.com/91359308/172539896-74679176-92c5-4548-b1f1-2d6c6b16e6c0.png)

![image](https://user-images.githubusercontent.com/91359308/172534697-f69f9301-1cf4-4f05-aad6-64476e4cf496.png)

**Aggregate functions**
-----------------------
|symbol|Details|
|------|-----|
|`COUNT()`|Returns the number of values in a group|
|`SUM()`|Returns the sum of values|
|`MAX()`|Returns the maximum number of values|
|`MIN()`|Returns the minimum number of values|
|`AVG()`|Returns the average value of a group|

```bash
      SELECT COUNT(*) FROM users;
      SELECT MAX(id),COUNT(*) FROM photos;
```
![image](https://user-images.githubusercontent.com/91359308/172539682-c81c2cc6-ef2f-4112-8bef-5753c8f2707b.png)

**Comparison Operators**
------------------------

| symbol    | Details of the comparison        |
| --------- | -------------------------------- |
| `BETWEEN` | Values between two other values  |
| `=`       | Equal Values                     |
| `>`       | Greater than Values              |
| `<`       | Less than Values                 |
| `<=`      | Less than or equal to Values     |
| `>=`      | Greater than or equal to Values  |
| `NOT IN`  | The value not present in a list? |
| `IN`      | Present in the list              |

```bash
SELECT id,username FROM users WHERE id BETWEEN 3 and 6;
SELECT id,username FROM users WHERE id > 3;
SELECT id,username FROM users WHERE id < 3;
```
![image](https://user-images.githubusercontent.com/91359308/172541583-a18c9247-49d9-4a19-a19f-b2d60a9f86cf.png)

**ORDER BY Clause**
-------------------
-  ORDER BY clause is used to sort the data in ascending(**ASC**) order descending(**DESC**) order, based on one or more columns.
```bash
SELECT username FROM users ORDER BY username ASC;
SELECT username FROM users ORDER BY username DESC;
```
![image](https://user-images.githubusercontent.com/91359308/172542358-5ed0df24-8f92-4044-a472-87758384ee8e.png)

**GROUP BY Clause**
------------------
- Groups row by a unique set of values.
```bash
 SELECT COUNT(*), user_id FROM photos GROUP BY user_id;
 SELECT count(*), username FROM users WHERE username='ashli' GROUP BY username;
 ```
![image](https://user-images.githubusercontent.com/91359308/172544576-7fc3fede-da30-44cd-b6d2-dba515abda68.png)

**DISTINCT clause**
----------------
- The PostgreSQL DISTINCT clause, which is used to delete the matching rows or data from a table and get only the unique records.

```bash
SELECT DISTINCT username FROM users;
SELECT DISTINCT photo_name AS photo, user_id FROM photos ORDER BY photo_name, user_id;

```

![image](https://user-images.githubusercontent.com/91359308/172545974-77811237-054a-49b4-962c-152f746af372.png)

**Having clause**
----------------
- The HAVING clause allows us to filter groups of rows as per the defined condition.
- The HAVING clause is useful to **groups of rows.**

```bash
SELECT count(*), username FROM users GROUP BY username HAVING count(*) < 2;
```
![image](https://user-images.githubusercontent.com/91359308/172555964-3bb72b9d-b10d-4007-a00d-6c3e75cd7843.png)

**LIMIT**
---------
- Will show the first two rows. Other rows will be skipped.
```bash
SELECT * FROM users LIMIT 2;
```
![image](https://user-images.githubusercontent.com/91359308/172557839-00b2592a-0a4b-4a26-8b09-87030534a7a7.png)

**OFFSET Clause**
------------------
- OFFSET is used to skip the number of records from the results.
```bash
SELECT * FROM users OFFSET 3;
```
![image](https://user-images.githubusercontent.com/91359308/172558687-39beb0bd-d601-45db-8ca6-98b4809e70fa.png)

**JOIN**
--------

- A PostgreSQL Join statement is used to combine data (or) rows from one(self-join) or more tables based on a common field between them. 
- These common fields are generally the Primary key of the first table and Foreign key of other tables.
- There are 4 basic types of joins supported by PostgreSQL, namely:

   **1.Inner Join** 

   **2. Left Join** 

   **3. Right Join**

   **4. Full Outer Join**

```bash
# INNER JOIN
SELECT username,photo_name FROM users INNER JOIN photos ON photos.user_id = users.id;
```
![image](https://user-images.githubusercontent.com/91359308/172560971-816f38ec-6220-4f1b-9379-ceee1bbe9bce.png)

```bash
# LEFT JOIN
SELECT username,photo_name FROM users LEFT JOIN photos ON photos.user_id = users.id LIMIT 2;
```
![image](https://user-images.githubusercontent.com/91359308/172561666-b702b4f1-3385-43e4-b345-a6e2d2b5c37f.png)

```bash
# RIGHT JOIN
SELECT * FROM users RIGHT JOIN photos ON photos.user_id = users.id LIMIT 2;
```
![image](https://user-images.githubusercontent.com/91359308/172561942-81369279-6d0e-4980-a532-78fa4a286316.png)

```bash
# FULL OUTER JOIN
 SELECT * FROM users FULL JOIN photos ON photos.user_id = users.id LIMIT 2;
 ```
![image](https://user-images.githubusercontent.com/91359308/172562366-02b92db9-9ecc-43f4-beca-d7e81355166d.png)

**UNION**
---------
|S.No.|Symbol|Details|
|-----|------|----------|
|1.|`UNION`|Join together the results of 2 queries and remove duplicate rows.|
|2.|`UNION ALL`|Join together the results of 2 queries.|
|3.|`INTERSECT`|find the rows common in the results of two queries. remove duplicates.|
|4.|`INTERSECT ALL`|find the rows common in the results of two queries.|
|5.|`EXCEPT`|find the rows that are present in first query but not second query. remove duplicates.|
|6.|`EXCEPT ALL`|find the rows that are present in first query but not second query.|
|7.|`DISTRINCT`|DISTINCT clause to remove duplicate rows from a result set returned by a query.|
|8.|`GREATEST`|Returns the greatest value from the list of expressions|
9.|`LEAST`|Returns the least from the list of expressions.|
- Join together the results of 2 queries and remove duplicate rows.

```bash
# UNION
SELECT id FROM users 
UNION 
SELECT user_id FROM photos;
```
![image](https://user-images.githubusercontent.com/91359308/172564116-f4eb5a8b-8d8c-450e-bf18-36346e45c80f.png)

```bash
# INTERSECT
SELECT id FROM users 
INTERSECT 
SELECT user_id FROM photos;
```
![image](https://user-images.githubusercontent.com/91359308/172565028-d09a7e6b-99a5-4b94-b434-11b487c73b11.png)

```bash
# EXCEPT
SELECT id FROM users 
EXCEPT 
SELECT user_id FROM photos;
```
![image](https://user-images.githubusercontent.com/91359308/172565292-07c7fb96-a9bc-477b-b400-8149a9e72d33.png)

```bash
# Greatest()
SELECT GREATEST(1,202,3);
```
```bash
# Least()
SELECT LEAST(1,202,3);
```

![image](https://user-images.githubusercontent.com/91359308/172566440-60e81745-075e-4b5c-887d-03dd421ca175.png)

**ALTER TABLE**
-----------------
```bash
# add a new column
ALTER TABLE users ADD price INT;
```
![image](https://user-images.githubusercontent.com/91359308/172570322-57f938b3-c040-443e-a85c-44c63643c61b.png)

```bash
#Change the DATA TYPE of a column
ALTER TABLE users ALTER COLUMN price TYPE varchar(34);
```

```bash
# drop the added column
ALTER TABLE users DROP COLUMN price;
```
![image](https://user-images.githubusercontent.com/91359308/172571220-dee1584c-e883-449e-a218-e29b6065f3cd.png)

