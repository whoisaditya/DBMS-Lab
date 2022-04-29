\sql
\connect root@localhost

create database lab_da_2;
use lab_da_2;

CREATE TABLE course (
    courseid INT,
    title VARCHAR(255),
    credits INT,
    departmentid INT
);

INSERT INTO course VALUES 
(1045, 'calculus', 4, 7),
(1050, 'chemistry', 4, 7),
(2021, 'dbms', 3, 2),
(2030, 'java', 3, 2),
(3141, 'operations management', 2, 6),
(4022, 'principles of management', 4, 6);

CREATE TABLE department (
    departmentid INT,
    name VARCHAR(255),
    budget FLOAT,
    startdate DATE,
    adminid VARCHAR(255)
);

INSERT INTO department VALUES 
(2, 'engineering', 4500.75, '2021-05-02', 'A05'),
(6, 'management',  3000.25, '2021-05-22', 'A02'),
(7, 'science', 3200, '2021-05-15', 'A03');


CREATE TABLE administrator (
    adminid VARCHAR(255),
    name VARCHAR(255),
    salary INT
);

INSERT INTO administrator VALUES 
('A02', 'manoj', 55000),
('A03', 'mampi',  57000),
('A05', 'sukumar', 60000);
/*
Question 1
Retrieve the course id, title and credits of engineering department, Use alias 'c' for the course table
*/
SELECT courseid, title, credits 
FROM c 
WHERE (
    SELECT departmentid
    FROM department 
    WHERE name = 'engineering')
    = c.departmentid;
/*
Question 2
Retrieve the course name and course credit of courses which have the highest credit in each department.
Display the record having the highest credit first.
*/
SELECT
    title, credits
FROM
    course
WHERE
    credits in
    (SELECT
        max(credits) as maxcreds
    FROM 
        course
    GROUP BY
        departmentid)
ORDER BY
    credits desc;
/*
Question 3
Retrieve the course id and course name which are satisfying the following condition: (i) administrator of the 
respective department is making the salary more than 55000.
*/
SELECT
    courseid, title
FROM
    course
WHERE
    departmentid in
    (SELECT
        departmentid
    FROM
        department
    WHERE
    adminid in
        (SELECT
            adminid
        FROM 
            administrator
        WHERE
            salary > 55000
        )
    );

/*
Question 4
Increase the salary (new salary: salary + 1000) of the administrator who is managing the 'operations 
management' course. Display the updated record. 
*/
UPDATE 
    administrator set salary = salary + 1000
WHERE
    adminid in
    (SELECT
        adminid
    FROM
        department
    WHERE
        departmentid in
        (SELECT
            departmentid
        FROM
            course
        WHERE
            title =0'operations management'
        )
    );

SELECT * FROM administrator;
/*
Question 5
Delete the tuples from the course table where the department starts before 15th of May, 2021.
*/
DELETE
FROM
    course
WHERE
    departmentid in
    (SELECT
        departmentid
    FROM
        department
    WHERE
        startdate < '2021-05-15'
    );

SELECT * FROM course;
/*
Question 6
Perform the right join on department and administrator table and retrieve department (id, Name) and administrator (name, salary).
*/

Select dept.departmentid, dept.name, admin.name, admin.salary
From
    department as dept
Right Join
    administrator as admin
On
    dept.adminid = admin.adminid