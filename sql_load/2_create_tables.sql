-- creating `branch` table

DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(10)
);

ALTER TABLE branch
ALTER COLUMN contact_no TYPE VARCHAR(100);




-- creating `employees` table

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(20),
    position VARCHAR(15),
    salary DECIMAL,
    branch_id VARCHAR(25)
);


-- creating `books` table

DROP TABLE IF EXISTS books;

CREATE TABLE books(
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(75),
    category VARCHAR(20),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(30),
    publisher VARCHAR(55)
);


-- creating `members` table

DROP TABLE IF EXISTS members;

CREATE TABLE members(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(70),
    reg_date DATE
);

-- creating `issued_status` table

DROP TABLE IF EXISTS issued_status;

CREATE TABLE issued_status(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_isbn VARCHAR(30),
    issued_emp_id VARCHAR(15)
);


-- creating `return_status` table

DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(20),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);

-- creating Foreign Keys for the 'issued_status' table

ALTER TABLE issued_status
ADD CONSTRAINT  fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT  fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);


ALTER TABLE issued_status
ADD CONSTRAINT  fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

-- creating Foreign Key for the 'return_status' table


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);



-- creating Foreign Key for the 'branch' table


ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

