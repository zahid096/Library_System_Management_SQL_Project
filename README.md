# Library_System_Management_SQL_Project

## Project Overview

**Project Title**: Library Management System  
**Database**: `library_management_sestem`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](library_management.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Structure
![ERD](Database_Structure.png)

- **Database Creation**: Created a database named `library_management_sestem`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE Library_Management_System;

use Library_Management_System;

--Create table "Branch"
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

--Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10, 2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(50)
);

--create table "Employee"
DROP Table IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(30),
    salary DECIMAL(10, 2),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

--Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(100),
    reg_date DATE
);

--Create table IssueStatus
DROP Table IF EXISTS issue_status;
CREATE Table issue_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(30),
    issued_book_name VARCHAR(80),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),
    Foreign Key (issued_member_id) REFERENCES members (member_id),
    Foreign Key (issued_book_isbn) REFERENCES books (isbn),
    Foreign Key (issued_emp_id) REFERENCES employees (emp_id)
);

--Create Table Return_status
DROP Table IF EXISTS return_status;
CREATE Table return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(30),
    return_book_name VARCHAR(80),
    return_date DATE,
    return_book_isbn VARCHAR(50),
    FOREIGN KEY (return_book_isbn) REFERENCES books (isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO
    books (
        isbn,
        book_title,
        category,
        rental_price,
        status,
        author,
        publisher
    )
VALUES (
        '978-1-60129-456-2',
        'To Kill a Mockingbird',
        'Classic',
        6.00,
        'yes',
        'Harper Lee',
        'J.B. Lippincott & Co.'
    );
SELECT * FROM books;
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET
    member_address = "125 main st"
WHERE
    member_id = "C101";
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issue_status WHERE issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issue_status WHERE issued_emp_id = 'E101';
```

**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT i.issued_emp_id, e.emp_name, COUNT(i.issued_id) as Total_Number
FROM issue_status as i
    JOIN employees as e on i.issued_emp_id = e.emp_id
GROUP BY
    i.issued_emp_id,
    e.emp_name
HAVING
    COUNT(i.issued_id) > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issue_summuey as
SELECT b.isbn, b.book_title, count(i.issued_id) as no_of_issued
FROM books as b
    join issue_status as i on b.isbn = i.issued_book_isbn
GROUP BY
    1,
    2;
```

### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books WHERE category = "Classic";
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT b.category, sum(b.rental_price) as total
FROM books as b
    JOIN issue_status as i on i.issued_book_isbn = b.isbn
GROUP BY
    1;
```

9. **List Members Who Registered in the Last 180 Days**:

```sql
SELECT *
FROM members
WHERE
    reg_date >= CURRENT_DATE - INTERVAL 180 day;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT e.*, b.manager_id, e2.emp_name as manager
FROM
    employees as e
    join branch as b on e.branch_id = b.branch_id
    join employees as e2 on e2.emp_id = b.manager_id;
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold 7**:
```sql
CREATE TABLE books_price_greter_than_7 as
SELECT *
FROM books
WHERE
    rental_price > 7;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT DISTINCT
    i.issued_book_name
FROM
    issue_status as i
    LEFT JOIN return_status as rs on i.issued_id = rs.issued_id
WHERE
    rs.return_id is NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT
    i.issued_member_id,
    m.member_name,
    i.issued_book_name as Book_title,
    i.issued_date,
    DATEDIFF(CURRENT_DATE, i.issued_date) as over_due_days
FROM
    issue_status as i
    JOIN members as m on m.member_id = i.issued_member_id
    LEFT JOIN return_status as r ON r.issued_id = i.issued_id
WHERE
    r.return_date is null
    and (CURRENT_DATE - issued_date) > 30
ORDER BY 1;
```

**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql
DELIMITER $$

CREATE PROCEDURE add_return_records (
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);


    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE(), p_book_quality);

    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issue_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    SELECT CONCAT ('Thank you for returning the book: ', v_book_name) as massage;
END $$

--Call Procedures
CALL add_return_records ('RI138', 'IS135', 'Good');
```

**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE Branch_reports as
SELECT
    b.branch_id,
    b.manager_id,
    COUNT(i.issued_id) as number_of_books_issued,
    COUNT(r.return_id) as num_of_return_books,
    SUM(bk.rental_price) as total_revenue
FROM
    branch as b
    join employees as e on b.branch_id = e.branch_id
    join issue_status as i on i.issued_emp_id = e.emp_id
    JOIN return_status as r ON r.issued_id = i.issued_id
    JOIN books as bk on bk.isbn = i.issued_book_isbn
GROUP BY
    1,
    2
ORDER BY 1;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_members as
SELECT *
FROM members
WHERE
    member_id IN (
        SELECT DISTINCT
            issued_member_id
        FROM issue_status
        WHERE
            issued_date >= CURRENT_DATE - INTERVAL 2 MONTH
    );

```

**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT e.emp_name, e.branch_id, count(i.issued_id) as Total_books
FROM employees as e
    JOIN issue_status as i on e.emp_id = i.issued_emp_id
GROUP BY
    1,
    2
ORDER BY count(i.issued_id) DESC
LIMIT 3;
```

**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

DELIMITER $$

CREATE Procedure issue_book (
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN

    DECLARE v_status VARCHAR(10);

    SELECT status 
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN
        INSERT INTO issue_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        SELECT CONCAT('Book issued successfully: ', p_issued_book_isbn) AS message;

    ELSE
        SELECT CONCAT('Book not available: ', p_issued_book_isbn) AS message;
        END if;

END $$

DELIMITER;

--Call procedures
call issue_book ( 'IS155', 'C108', '978-0-553-29698-2', 'E104' );
```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

## 👨‍💻 Author

**Md. Zahid Hasan**  
📧 [mdzahidhasan096@gmail.com](mailto:mdzahidhasan096@gmail.com)  
📍 Data Analyst | Excel Enthusiast | Research-driven Learner 

