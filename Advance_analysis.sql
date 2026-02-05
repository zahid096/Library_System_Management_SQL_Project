/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/
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

SELECT DATEDIFF(CURRENT_DATE, '2024-03-26');

/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

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

SELECT * FROM issue_status WHERE issued_id = 'IS135';

SELECT * FROM books WHERE isbn = '978-0-307-58837-1'

SELECT * FROM return_status WHERE issued_id = 'IS135';

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.
*/

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

DROP Table branch_reports;

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members 
who have issued at least one book in the last 2 months.*/

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

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.*/

SELECT e.emp_name, e.branch_id, count(i.issued_id) as Total_books
FROM employees as e
    JOIN issue_status as i on e.emp_id = i.issued_emp_id
GROUP BY
    1,
    2
ORDER BY count(i.issued_id) DESC
LIMIT 3;

/* Task 18: 
Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). If the book is available, it should 
be issued, and the status in the books table should be updated to 'no'. If the book is not available 
(status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

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

call issue_book ( 'IS155', 'C108', '978-0-553-29698-2', 'E104' );

--End the analysis