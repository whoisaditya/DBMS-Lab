\sql
\connect root@localhost

create database lab_da_1;
use lab_da_1;

CREATE TABLE Employee (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT,
    department VARCHAR(255),
    branch VARCHAR(255),
    salary INT
);

INSERT INTO Employee VALUES 
(1, 'Prabhat', 25, 'Sales', 'Delhi', 25000),
(2, 'Rimpa', 27, 'Manufacturing', 'Mumbai', 20000),
(3, 'Saikat', 31, 'Manufacturing', 'Kolkata', 30000),
(4, 'Sagar', 29, 'Finance', 'Noida', 34000),
(5, 'Naina', 30, 'Finance', 'Kerala', 29000),
(6, 'Rahul', 28, 'Finance', 'Chennai', 27000);

INSERT INTO Employee VALUES 
(7, 'Raktim', 25, 'Design', 'Noida', 31000);

SELECT id, salary FROM Employee WHERE salary BETWEEN 20000 AND 30000;

SELECT AVG(salary) FROM Employee;

SELECT COUNT(DISTINCT department) FROM Employee;

SELECT SUM(salary), department, COUNT(department) FROM Employee GROUP BY department;

SELECT id, salary FROM Employee WHERE salary > 25000;

SELECT * FROM Employee ORDER BY salary DESC;

SELECT department, COUNT(*)  FROM Employee GROUP BY department HAVING COUNT(*) > 2;

SELECT * FROM Employee WHERE name = 'Rimpa' AND salary > 25000;