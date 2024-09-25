/*

Task 3: Branch Performance Report
Write a query that generates a performance report for each branch, showing the number of books issued,
the number of books returned, and the total revenue generated from book rentals.

*/
CREATE OR REPLACE TABLE branch_reports
AS
	SELECT
		br.branch_id,
		br.manager_id,
		COUNT(ist.issued_id) AS count_of_books_issued,
		COUNT(rst.issued_id) AS count_of_books_returned,
		SUM(b.rental_price) AS total_amount
		
	FROM
		books AS b
	JOIN
		issued_status AS ist
	ON
		b.isbn = ist.issued_book_isbn
	JOIN
		employees AS e
	ON
		ist.issued_emp_id = e.emp_id
	JOIN
		branch AS br
	ON
		e.branch_id = br.branch_id
	LEFT JOIN
		return_status AS rst
	ON
		ist.issued_id = rst.issued_id
	GROUP BY 
		br.branch_id,
		br.manager_id
		ORDER BY total_amount DESC;


SELECT * FROM branch_reports;






















































































	
	