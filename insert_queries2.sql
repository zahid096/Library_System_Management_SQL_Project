SELECT * from issue_status;
--Insert some data in issue_status table
INSERT INTO
    issue_status (
        issued_id,
        issued_member_id,
        issued_book_name,
        issued_date,
        issued_book_isbn,
        issued_emp_id
    )
VALUES (
        'IS151',
        'C118',
        'The Catcher in the Rye',
        CURRENT_DATE - INTERVAL 24 day,
        '978-0-553-29698-2',
        'E108'
    ),
    (
        'IS152',
        'C119',
        'The Catcher in the Rye',
        CURRENT_DATE - INTERVAL 13 day,
        '978-0-553-29698-2',
        'E109'
    ),
    (
        'IS153',
        'C106',
        'Pride and Prejudice',
        CURRENT_DATE - INTERVAL 7 day,
        '978-0-14-143951-8',
        'E107'
    ),
    (
        'IS154',
        'C105',
        'The Road',
        CURRENT_DATE - INTERVAL 32 day,
        '978-0-375-50167-0',
        'E101'
    );

--Add new colomn in return_status table
ALTER Table return_status
ADD COLUMN book_quality VARCHAR(30) DEFAULT("Good")

SELECT * FROM return_status;

UPDATE return_status
SET
    book_quality = "Damaged"
WHERE
    issued_id in ('IS112', 'IS117', 'IS118');

--End update database;