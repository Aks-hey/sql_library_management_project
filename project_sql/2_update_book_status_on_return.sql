/*

Task 2: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes"
when they are returned (based on entries in the return_status table).

*/

-- STORED PROCEDURE

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR, p_issued_id VARCHAR, p_book_quality VARCHAR)
LANGUAGE plpgsql	
AS $$

DECLARE
	v_isbn VARCHAR(50);
	v_book_title VARCHAR(75);

BEGIN
	-- inserting into returns based on users input
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES
	(p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	SELECT
		issued_book_isbn, 
		issued_book_name
		INTO 
			v_isbn,
			v_book_title
	FROM issued_status WHERE issued_id = p_issued_id;
	

	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE
		'Thank you for returning the book: %',v_book_title;

END;
$$

CALL add_return_records('RS122', 'IS140', 'Good');

SELECT * FROM books;










































































































