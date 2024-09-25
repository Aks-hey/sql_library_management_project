# Introduction
Welcome to the Library Management System project! This project simulates a comprehensive system to manage books, members, and the issuance process in a library.

The goal is to streamline and automate key library operations using SQL queries and PostgreSQL, ensuring efficient book tracking and management.

SQL queries? Check them out here: [project_sql](/project_sql/).


# Background
This project was born out of the need to manage library operations effectively, reducing manual errors and improving resource management. With a focus on book availability, member management, and book issuance.

The project aims to create a scalable and robust system for real-world library environments.

## Tools Used
For building this library management system, I utilized the following tools:

- **SQL**: The backbone of the system, managing all data manipulation and querying for book availability, member details, and issuance tracking.
- **PostgreSQL**: The chosen database management system, perfect for handling library data, including tables for books, members, and issuance records.
- **Visual Studio Code**: Used as my integrated development environment (IDE) for writing and executing SQL scripts.
- **Git & GitHub**: Essential for version control and project tracking, ensuring easy collaboration and sharing of SQL queries and system updates.

# Analysis
Each query focuses on the various functions involves in a real-world library.

### 1. Identify the members with overdue books
```sql
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
```
Here's the breakdown of the above query:
- **Selects Key Information**: The query retrieves the book title, member ID, member name, issue date, return date, and calculates the number of overdue days for each book issued.
  
- **Joins Tables**: It joins the `books`, `issued_status`, `members`, and `return_status` tables to gather all necessary information regarding issued books and their respective members.

- **Calculates Overdue Days**: The query uses a `CASE` statement to calculate the overdue days based on whether the book has been returned. If the return date is NULL, it calculates the overdue days from the issue date to the current date; otherwise, it calculates the days between the issue date and return date.

- **Filters Overdue Records**: The `WHERE` clause filters the results to include only those records where the return date is NULL or the number of days since the issue date exceeds `30` days, indicating overdue books.

| Book Title                                          | Issued Member ID | Member Name      | Issued Date | Return Date  | No. of Days Overdue |
|-----------------------------------------------------|------------------|------------------|-------------|--------------|----------------------|
| Animal Farm                                        | C106             | Frank Thomas      | 2024-03-10  | 2024-05-01   | 52                   |
| One Hundred Years of Solitude                      | C107             | Grace Taylor      | 2024-03-11  | 2024-05-03   | 53                   |
| The Great Gatsby                                   | C108             | Henry Anderson    | 2024-03-12  | 2024-05-05   | 54                   |
| Jane Eyre                                          | C109             | Ivy Martinez      | 2024-03-13  | 2024-05-07   | 55                   |
| The Alchemist                                      | C110             | Jack Wilson       | 2024-03-14  | 2024-05-09   | 56                   |
| Harry Potter and the Sorcerers Stone               | C109             | Ivy Martinez      | 2024-03-15  | 2024-05-11   | 57                   |
| A Game of Thrones                                  | C109             | Ivy Martinez      | 2024-03-16  | 2024-05-13   | 58                   |
| A People's History of the United States            | C109             | Ivy Martinez      | 2024-03-17  | 2024-05-15   | 59                   |
| The Guns of August                                 | C109             | Ivy Martinez      | 2024-03-18  | 2024-05-17   | 60                   |
| The Histories                                      | C109             | Ivy Martinez      | 2024-03-19  | 2024-05-19   | 61                   |

*Members with the overdue books(sample output)*


### 2. Update Book Status on Return
Query to update the status of books in the books table to "Yes" when they're returned.

```sql
- STORED PROCEDURE

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

-- Calling the stored procedure

CALL add_return_records('RS122', 'IS140', 'Good');
```

Here's the breakdown of the above query

- **Stored Procedure Definition**: The procedure `add_return_records` is created to handle the return process of books. It accepts parameters for the return ID, issued ID, and the quality of the returned book.

- **Variable Declaration**: Two local variables, `v_isbn` and `v_book_title`, are declared to store the ISBN and title of the returned book fetched from the `issued_status` table based on the provided issued ID.

- **Insert Return Record**: The procedure inserts a new record into the `return_status` table, capturing the return details, including the current date as the return date and the book quality.

- **Update Book Status**: After successfully inserting the return record, the procedure updates the status of the corresponding book in the `books` table to "Yes" to indicate that it has been returned. A notification message is raised to confirm the return.


### 3. Branch Performance Report

Query that generates a performance report for each branch, showing the number of books issued,
the number of books returned, and the total revenue generated from book rentals.

```sql
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
```
Here's the breakdown of the above query

**Table Creation**: The `branch_reports` table is created to store the performance data for each branch, which includes the number of books issued, the number of books returned, and the total revenue generated from book rentals.

- **Joins for Data Retrieval**: The query utilizes several JOIN operations to aggregate data from the `books`, `issued_status`, `employees`, `branch`, and `return_status` tables. This allows for a comprehensive view of each branch's performance.

- **Aggregating Book Data**: Using the `COUNT` function, the query calculates the total number of books issued and returned per branch. The `SUM` function is employed to calculate the total rental revenue generated from the issued books.

- **Grouping and Ordering**: The results are grouped by `branch_id` and `manager_id`, ensuring that the report is structured to provide branch-specific data. The final output is ordered by `total_amount` in descending order, highlighting the highest revenue-generating branches at the top of the report.

| Branch ID | Manager ID | Count of Books Issued | Count of Books Returned | Total Amount |
|-----------|------------|-----------------------|-------------------------|--------------|
| B001      | E109       | 17                    | 10                      | $111.50      |
| B005      | E110       | 9                     | 3                       | $50.00       |
| B004      | E110       | 4                     | 4                       | $26.50       |
| B003      | E109       | 3                     | 0                       | $20.00       |
| B002      | E109       | 2                     | 2                       | $12.00       |

*Each branch with their total earnings*


### 4.Manage Status of Books Library.
The Store Procedure takes the book_id as an input parameter and checks the availability(yes/no).

If 'yes', the book will be issued and the status will be updated in the 'books' & 'issued_status' tables accordingly 

If 'no', a message should be displayed stating book is currently not available.

```sql
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

-- Calling the stored procedure

CALL book_issue_status('IS143', 'C109', '978-0-553-29698-2', 'E104');

```
Here's the breakdown of the above query

**Procedure Declaration:**
  - `CREATE OR REPLACE PROCEDURE book_issue_status(...)`: Declares the procedure with parameters for issued ID, member ID, book ISBN, and employee ID.

- **Variable Declaration:**
  - Declares local variables:
    - `v_status VARCHAR(10)`: Holds the availability status of the book.
    - `v_book_title VARCHAR(50)`: Stores the title of the book.
    - `v_isbn VARCHAR(50)`: Stores the ISBN of the book.

- **Book Availability Check:**
  - Executes a `SELECT` query to retrieve the book's title, status, and ISBN from the `books` table based on the provided ISBN. The results are stored in the declared variables.

- **Conditional Logic:**
  - Checks if the book is available (`IF v_status = 'yes'`):
    - If **available**:
      - Raises a notice that the book is available.
      - Inserts a new record in the `issued_status` table to log the issuance.
      - Updates the `books` table to mark the book as unavailable (`status = 'no'`).
    - If **not available**:
      - Raises a notice indicating the book is not available.

