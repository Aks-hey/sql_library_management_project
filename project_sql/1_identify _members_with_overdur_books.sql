/*

Task 1: Identify the members with overdue books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member_id's, member_name's, book_title, issue_date and number of overdue days.

*/

SELECT
	b.book_title,
	ist.issued_member_id,
	m.member_name,
	ist.issued_date,
	rst.return_date,
CASE	
	WHEN rst.return_date IS NULL THEN
		CURRENT_DATE - ist.issued_date
	ELSE
		(rst.return_date - ist.issued_date)
	END AS "no. of days overdue"

FROM
	books AS b
JOIN
	issued_status AS ist
ON
	b.isbn = ist.issued_book_isbn
JOIN
	members AS m
ON
	ist.issued_member_id = m.member_id
LEFT JOIN
	return_status AS rst
ON
	ist.issued_id = rst.issued_id
WHERE 
	rst.return_date IS NULL OR
	(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 
	"no. of days overdue" ASC;

	






















































	
