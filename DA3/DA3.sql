\sql
\connect root@localhost

create database lab_da_3;
use lab_da_3;

Create a course (CID, CTitle, credits) relation using the following:
-- 1. While creating the table impose “Primary key” constraint on one field.
CREATE TABLE course(
    CID INT PRIMARY KEY,
    CTitle VARCHAR(255),
    credits INT
);

-- 2. Using alteration impose “Unique” constraint on two fields.
ALTER TABLE
course ADD UNIQUE (CID),
ADD UNIQUE (CTitle);

-- 3. Create another relation Department (DID, Dname). Use DID as the foreign key of course relation.
CREATE TABLE Department (
    DID INT PRIMARY KEY,
    Dname VARCHAR(255)
);

ALTER TABLE course
ADD DID INT,
ADD FOREIGN KEY (DID) REFERENCES Department(DID);

-- 4. Alter the course table to impose a constraint to restrict the course credit between 2 and 4.
ALTER TABLE course
ADD CHECK(credits > 1 AND credits < 5);

-- 5. Give some examples (by inserting records into course relation) to violate the unique, foreign key and check constraints. [include the screenshot of the error as the answer along with the handwritten query]
INSERT INTO Department VALUES 
(1, 'science');

INSERT INTO course VALUES 
(1049, 'physics', 3, 1);

-- UNIQUE constraint violated
INSERT INTO course VALUES 
(1050, 'chemistry', 3, 1),
(1050, 'math', 3, 1);

-- FOREIGN KEY constraint violated
INSERT INTO course VALUES 
(1051, 'biology', 4, 2);

-- CHECK constraint violated
INSERT INTO course VALUES 
(2021, 'dbms', 10, 2);

-- 6. Explain the difference between ANY and ALL using examples. [can use either course or department relation to explain it]

-- Insering some Values 
INSERT INTO department VALUES 
(2, 'engineering'),
(6, 'management'),
(7, 'science');

INSERT INTO course VALUES 
(1045, 'calculus', 4, 7),
(1050, 'chemistry', 4, 7),
(2021, 'dbms', 3, 2),
(2030, 'java', 3, 2),
(3141, 'operations management', 2, 6),
(4022, 'principles of management', 4, 6);

/*
The ANY operator:
    returns a boolean value as a result
    returns TRUE if ANY of the subquery values meet the condition
ANY means that the condition will be true if the operation is true for any of the values in the range.
*/
SELECT *
FROM course
WHERE DID = ANY
  (SELECT DID
  FROM Department
  WHERE Dname = 'science');
/*
The ALL operator:
    returns a boolean value as a result
    returns TRUE if ALL of the subquery values meet the condition 
ALL means that the condition will be true only if the operation is true for all values in the range. 
*/
SELECT *
FROM course
WHERE DID = ALL
  (SELECT DID
  FROM Department
  WHERE Dname = 'science');

-- 7. Explain intersect using example. [can create tables as per your choice to explain it]
SELECT DISTINCT DID 
FROM course
WHERE DID IN (SELECT DID FROM Department);

DELETE FROM course WHERE CTitle = 'physics';

DELETE FROM department WHERE DID = 1;
