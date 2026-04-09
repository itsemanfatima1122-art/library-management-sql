CREATE DATABASE library;
USE library;

DROP TABLE IF EXISTS branch;

CREATE TABLE branch 
(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10), 
    branch_address VARCHAR(10),
    contact_no VARCHAR(10)
);

ALTER TABLE branch
MODIFY COLUMN branch_address VARCHAR(100),
MODIFY COLUMN contact_no VARCHAR(100);


DROP TABLE IF EXISTS employees;

CREATE TABLE employees
(
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(25),
    position VARCHAR(15),
    salary INT,
    branch_id VARCHAR(25)
);


DROP TABLE IF EXISTS books;

CREATE TABLE books
(
    isbn VARCHAR(100) PRIMARY KEY,
    book_title VARCHAR(22),
    category VARCHAR(30),
    rental_price FLOAT,
    status VARCHAR(10),
    author VARCHAR(50),
    publisher VARCHAR(100)
);

ALTER TABLE books 
MODIFY book_title VARCHAR(255);


DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status
(
    return_id VARCHAR(80) PRIMARY KEY,
    issued_id VARCHAR(80),
    return_book_name VARCHAR(85),
    return_date DATE,
    return_book_isbn VARCHAR(80)
);


DROP TABLE IF EXISTS issued_status;

CREATE TABLE issued_status
(
    issued_id VARCHAR(80) PRIMARY KEY,
    issued_member_id VARCHAR(100),
    issued_book_name VARCHAR(100),
    issued_date DATE, 
    issued_book_isbn VARCHAR(100),
    issued_emp_id VARCHAR(100)
);


DROP TABLE IF EXISTS members;

CREATE TABLE members
(
    member_id VARCHAR(100) PRIMARY KEY,
    member_name VARCHAR(100),
    member_address VARCHAR(100),
    reg_date DATE
);


-- adding forign key to issued table
ALTER TABLE issued_status
ADD CONSTRAINT fk_member
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


-- forign key in books table
ALTER TABLE issued_status
ADD CONSTRAINT fk_eman
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);


-- issued id 
ALTER TABLE return_status
ADD CONSTRAINT fk_id
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


ALTER TABLE employees
ADD CONSTRAINT fk_employe
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_er
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);



SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE members;
TRUNCATE TABLE books;
TRUNCATE TABLE branch;
TRUNCATE TABLE employees;
TRUNCATE TABLE issued_status;
TRUNCATE TABLE return_status;

SET FOREIGN_KEY_CHECKS = 1;


SELECT * FROM books;


-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co');


-- Update an Existing Member's Address
SELECT * FROM members;

UPDATE members
SET member_address = '124 main st'
WHERE member_id = 'c101';


--  Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121';


-- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


-- List Members Who Have Issued More Than One Book 
SELECT issued_member_id, issued_id
FROM issued_status
WHERE issued_id > 1
GROUP BY issued_id, issued_member_id;


--  List all members who registered after 2022.
SELECT * FROM members
WHERE reg_date > '2022-01-01';


-- Find total number of books available vs not available
SELECT COUNT(isbn) AS total_no_of_books, status
FROM books
GROUP BY status;


-- Show all employees working in branch B001.
SELECT emp_id, emp_name, position
FROM employees
WHERE branch_id = 'B001';


-- Count how many books are in each category.
SELECT category, COUNT(*) AS total_books  
FROM books
GROUP BY category;


-- Find the total number of books issued by each member
SELECT members.member_id AS member, members.member_name, COUNT(issued_status.issued_id) AS total_books
FROM members
JOIN issued_status 
ON members.member_id = issued_status.issued_member_id
GROUP BY members.member_id, members.member_name;


-- List all issued books along with member name and employee name who issued them.
SELECT issued_status.issued_book_name, members.member_name, employees.emp_name
FROM issued_status
JOIN members 
ON issued_status.issued_member_id = members.member_id
JOIN employees 
ON issued_status.issued_emp_id = employees.emp_id;


-- Find which branch has the highest number of employees.
SELECT branch.branch_id, COUNT(employees.emp_id) AS highest_emp, employees.emp_name
FROM branch
JOIN employees 
ON branch.branch_id = employees.branch_id
GROUP BY employees.emp_id, employees.emp_name
ORDER BY employees.emp_id DESC
LIMIT 1;


-- Get total revenue generated from book rentals (based on `rental_price`).
SELECT book_title, COUNT(issued_status.issued_id) * books.rental_price AS revneue
FROM books
JOIN issued_status 
ON books.isbn = issued_status.issued_book_isbn
GROUP BY books.rental_price, books.book_title;


-- Find top 5 most issued books
SELECT issued_status.issued_book_name, COUNT(issued_status.issued_id) AS total_issue
FROM issued_status
GROUP BY issued_status.issued_book_name 
ORDER BY total_issue DESC
LIMIT 5;


-- Find members who have issued more than 3 books.
SELECT members.member_id, members.member_name, COUNT(issued_status.issued_id) AS book_issued
FROM issued_status
JOIN members 
ON issued_status.issued_member_id = members.member_id
GROUP BY members.member_id, members.member_name
HAVING COUNT(issued_status.issued_id) > 3;


-- Find the average salary of employees in each branch
SELECT branch.branch_id, AVG(employees.salary) AS average_sal
FROM branch
JOIN employees 
ON branch.branch_id = employees.branch_id
GROUP BY branch.branch_id;


-- Identify which employee has issued the most books.
SELECT employees.emp_name, employees.emp_id, COUNT(issued_status.issued_id) AS issued_books
FROM employees
JOIN issued_status 
ON employees.emp_id = issued_status.issued_emp_id
GROUP BY employees.emp_name, employees.emp_id
ORDER BY issued_books DESC
LIMIT 1;


-- Find books that are issued but not yet returned.
SELECT issued_status.issued_book_name, issued_status.issued_id, return_status.return_id
FROM issued_status
LEFT JOIN return_status 
ON issued_status.issued_id = return_status.issued_id
WHERE return_id IS NULL
GROUP BY issued_status.issued_book_name, issued_status.issued_id, return_status.return_id;


-- Calculate the average number of days taken to return books.
SELECT issued_status.issued_book_name, ROUND(AVG(DATEDIFF(return_date, issued_date)), 0) AS avg_days
FROM return_status
JOIN issued_status 
ON return_status.issued_id = issued_status.issued_id
GROUP BY issued_status.issued_book_name;


-- Find the employee in each branch who has issued the highest number of books.
SELECT ranked.branch_id, ranked.emp_id, ranked.emp_name, ranked.total_issued
FROM (
    SELECT 
        employees.branch_id, 
        employees.emp_id, 
        employees.emp_name, 
        COUNT(issued_status.issued_id) AS total_issued,
        ROW_NUMBER() OVER (
            PARTITION BY employees.branch_id  
            ORDER BY COUNT(issued_status.issued_id) DESC
        ) AS rn
    FROM employees
    LEFT JOIN issued_status 
    ON employees.emp_id = issued_status.issued_emp_id
    GROUP BY employees.branch_id, employees.emp_id, employees.emp_name
) AS ranked
WHERE ranked.rn = 1;


-- Find the top 2 most active members (who issued the highest number of books) overall.
SELECT members.member_name, members.member_id, COUNT(issued_status.issued_id) AS total
FROM members
JOIN issued_status 
ON members.member_id = issued_status.issued_member_id
GROUP BY members.member_name, members.member_id
ORDER BY total DESC
LIMIT 2;


-- Rank all books based on how many times they have been issued (highest to lowest).
SELECT ranked.total, ranked.book_title
FROM (
    SELECT 
        COUNT(issued_status.issued_id) AS total,
        books.book_title,
        RANK() OVER (
            ORDER BY COUNT(issued_status.issued_id) DESC
        ) AS rn
    FROM issued_status
    JOIN books 
    ON issued_status.issued_book_isbn = books.isbn
    GROUP BY books.book_title
) AS ranked;


-- Find members who have issued more books than the average number of books issued by members.
SELECT members.member_id, members.member_name, COUNT(issued_status.issued_id) AS total_books
FROM members
JOIN issued_status 
ON members.member_id = issued_status.issued_member_id
GROUP BY members.member_id, members.member_name
HAVING COUNT(issued_status.issued_id) > (
    SELECT AVG(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM issued_status
        GROUP BY issued_member_id
    ) t
);
