# Library Management System (SQL Project)

## Project Overview
This project demonstrates the implementation of a Library Management System using SQL. It includes database creation, table relationships, and queries to manage and analyze library data.

The project focuses on using SQL for data manipulation and extracting meaningful insights.

---

## Objectives
- Create a relational database for a library system
- Manage data for books, members, employees, and transactions
- Perform CRUD operations
- Write SQL queries for data analysis

---

## Database Structure

The project consists of the following tables:

- branch
- employees
- members
- books
- issued_status
- return_status

These tables are connected using primary and foreign keys.

---

## Key SQL Concepts Used

- Joins (INNER JOIN, LEFT JOIN)
- Aggregate Functions (COUNT, AVG)
- GROUP BY and HAVING
- Subqueries
- Window Functions (ROW_NUMBER, RANK)

---

## Features / Tasks Performed

- Insert new book records
- Update member information
- Delete issued records
- Retrieve books issued by specific employees
- Identify top-performing employees and active members
- Calculate average return time of books
- Rank books based on issue frequency

---

## Example Query
-- Find the most active members based on number of books issued

SELECT 
    members.member_id, 
    members.member_name, 
    COUNT(issued_status.issued_id) AS total_books
FROM members
JOIN issued_status 
ON members.member_id = issued_status.issued_member_id
GROUP BY members.member_id, members.member_name
ORDER BY total_books DESC
limit 3;
LIMIT 3;

