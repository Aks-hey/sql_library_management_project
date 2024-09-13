-- creating `branch` table

DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(55),
    contact_no VARCHAR(10)
);


-- 