/*
Task 6: Create a Stored Procedure to manage the status of the books in a library system.

The Store Procedure takes the book_id as an input parameter and check if the availability(yes/no),
If 'yes, the book should be issued and the status should be updated in the 'books' & 'issued_status' tables accordingly 
If 'no', a message should be displayed stating book is currently not available.

*/

CREATE OR REPLACE PROCEDURE book_issue_status(p_issued_id VARCHAR, p_issued_member_id VARCHAR, p_issued_book_isbn VARCHAR, p_issued_emp_id VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_status VARCHAR(10);
	v_book_title VARCHAR(50);
	v_isbn VARCHAR(50);
BEGIN
	-- checking if the book is available in the 'books' table
	SELECT
		book_title,
		status,
		isbn
		INTO
		v_book_title,
		v_status,
		v_isbn
	FROM 
		books
	WHERE	
		isbn = p_issued_book_isbn;

	-- Using IF to check the status and raise notices

	IF v_status = 'yes' THEN		
		
		RAISE NOTICE 'The % is available!!', v_book_title;
		
		-- updating the 'books' table and 'issued_status' table
	
		INSERT INTO
			issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
		VALUES
			(p_issued_id, p_issued_member_id, v_book_title, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);
	
		UPDATE books
		SET status = 'no'
		WHERE isbn = v_isbn;
		
    ELSE
        RAISE NOTICE 'The % is not available.', v_book_title;
    END IF; 		
		
END;
$$


CALL book_issue_status('IS143', 'C109', '978-0-553-29698-2', 'E104');



SELECT * FROM books;
SELECT * FROM issued_status;








































































