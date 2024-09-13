COPY books
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\books.csv'
DELIMITER ',' CSV HEADER;


COPY branch
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\branch.csv'
DELIMITER ',' CSV HEADER;


COPY employees
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\employees.csv'
DELIMITER ',' CSV HEADER;


COPY members
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\members.csv'
DELIMITER ',' CSV HEADER;

COPY issued_status
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\issued_status.csv'
DELIMITER ',' CSV HEADER;



COPY return_status
FROM 'C:\Users\aksha\OneDrive\Desktop\PostgreSQL\sql_library_management_project\csv_files\return_status.csv'
DELIMITER ',' CSV HEADER;

