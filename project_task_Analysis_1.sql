-- Project Task

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
-- Task 2: Update an Existing Member's Address where member_address = "125 main st" to member_id = "C101";
-- Task 3: Delete a Record from the Issued Status Table  -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
-- Task 7. Retrieve All Books in a Specific Category:
-- Task 8: Find Total Rental Income by Category:
-- Task 9: List Members Who Registered in the Last 180 Days:
-- task 10 List Employees with Their Branch Manager's Name and their branch details:
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
-- Task 12: Retrieve the List of Books Not Yet Returned

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
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

-- Task 2: Update an Existing Member's Address
UPDATE members
SET
    member_address = "125 main st"
WHERE
    member_id = "C101";

SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table  -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
SELECT * FROM issue_status;

DELETE FROM issue_status WHERE issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT * FROM issue_status WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT i.issued_emp_id, e.emp_name, COUNT(i.issued_id) as Total_Number
FROM issue_status as i
    JOIN employees as e on i.issued_emp_id = e.emp_id
GROUP BY
    i.issued_emp_id,
    e.emp_name
HAVING
    COUNT(i.issued_id) > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE book_issue_summuey as
SELECT b.isbn, b.book_title, count(i.issued_id) as no_of_issued
FROM books as b
    join issue_status as i on b.isbn = i.issued_book_isbn
GROUP BY
    1,
    2;

SELECT * FROM book_issue_summuey;

-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books WHERE category = "Classic";

-- Task 8: Find Total Rental Income by Category:
SELECT b.category, sum(b.rental_price) as total
FROM books as b
    JOIN issue_status as i on i.issued_book_isbn = b.isbn
GROUP BY
    1;

-- Task 9: List Members Who Registered in the Last 180 Days:
SELECT *
FROM members
WHERE
    reg_date >= CURRENT_DATE - INTERVAL 180 day;

INSERT INTO
    members (
        member_id,
        member_name,
        member_address,
        reg_date
    )
VALUES (
        'C120',
        'sam',
        '145 Main St',
        '2025-10-10'
    ),
    (
        'C121',
        'john',
        '133 Main St',
        '2025-09-09'
    );

-- task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT e.*, b.manager_id, e2.emp_name as manager
FROM
    employees as e
    join branch as b on e.branch_id = b.branch_id
    join employees as e2 on e2.emp_id = b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
CREATE TABLE books_price_greter_than_7 as
SELECT *
FROM books
WHERE
    rental_price > 7;

SELECT * FROM books_price_greter_than_7

-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT DISTINCT
    i.issued_book_name
FROM
    issue_status as i
    LEFT JOIN return_status as rs on i.issued_id = rs.issued_id
WHERE
    rs.return_id is NULL;

--End project_task_analysis