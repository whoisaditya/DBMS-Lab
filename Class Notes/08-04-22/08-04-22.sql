create database 08_04_22;
use 08_04_22;

create table parents(
    id int primary key,
    name varchar(255),
    city varchar(255),
    phoneno varchar(255),
    occupation varchar(255),
    value int
);

create table students(
    roll_no int primary key,
    student_name varchar(255),
    address varchar(20),
    course varchar(255)
);

insert into students(student_name, student_id, course) values('priya', 1, 'JAVA');$$
insert into students(student_name, student_id, course) values('john', 2, 'DBMS');$$

/* Code 1 */
desc students;
delimiter $$
drop procedure if exists nullchk;
CREATE PROCEDURE nullchk()
BEGIN
    /* exit if the null occurs */
    DECLARE EXIT HANDLER FOR 1364
    BEGIN
     SELECT ('roll number, student name cant be null') AS message;
    END;
    
     /* insert a new row into students*/
    #INSERT INTO students(roll_no, course) VALUES(1, 'JAVA');
    #INSERT INTO students(course) VALUES('JAVA');
    INSERT INTO students(student_name, course) VALUES('priya', 'JAVA');
    
END$$

CALL nullchk;

/* Code 2 */
delimiter $$
drop procedure if exists notable$$
CREATE PROCEDURE notable()
BEGIN
    -- exit if the no table present
    DECLARE EXIT HANDLER FOR 1146
    BEGIN
     SELECT ('used table not exists') AS message;
    END;
    
    -- insert a new row into student
    INSERT INTO student(student_name, course) VALUES('priya', 'JAVA');
    
END$$

CALL notable;

/* Code 3 */
delimiter $$
drop procedure if exists table_exists$$
CREATE PROCEDURE table_exists()
BEGIN
    -- exit if table already exists
    DECLARE EXIT HANDLER FOR 1050
    BEGIN
     SELECT ('table already exists') AS message;
    END;
    
    create table students (sturoll int);
    
END$$

CALL table_exists;

/* Code 4 */
delimiter $$
drop procedure if exists unknown_col$$
CREATE PROCEDURE unknown_col()
BEGIN
    -- exit if the column does not exists
    DECLARE EXIT HANDLER FOR 1054
    BEGIN
     SELECT ('column does not exists') AS message;
    END;
    
    INSERT INTO students(roll_no, student_name, courses) VALUES(1, 'priya', 'JAVA');
    
END$$

CALL unknown_col();

/* Code 5 */
insert into students values(1, 'priya', 'mumbai' ,'JAVA' ), (2, 'john','la', 'DBMS');$$

delimiter $$
drop procedure if exists stu_add_chk;
CREATE PROCEDURE stu_add_chk(stu_id int, stu_address varchar (20))
 BEGIN
   DECLARE stu_count INT;
   DECLARE address_count INT; 

  -- check if student exists
   SELECT COUNT(*) INTO stu_count
   FROM students
   WHERE roll_no = stu_id;

  IF stu_count != 1 THEN 
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'stu_id not found in students table.';
   END IF;

  -- check if address exists
   SELECT COUNT(*) INTO address_count
   FROM students
   WHERE address = stu_address;

  IF address_count != 1 THEN 
     SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'stu_address not found in students table.';
   END IF; 

END$$

call stu_add_chk(1,'mumbai');$$
call stu_add_chk(2,'USA');$$

/* Code 6 */
#BEFORE UPDATE
#First, create a new table:
drop table if exists sales_info;
CREATE TABLE sales_info (  
    id INT AUTO_INCREMENT,  
    product VARCHAR(100) NOT NULL,  
    quantity INT NOT NULL DEFAULT 0,  
    fiscalYear SMALLINT NOT NULL,  
    CHECK(fiscalYear BETWEEN 2000 and 2050),  
    CHECK (quantity >=0),  
    UNIQUE(product, fiscalYear),  
    PRIMARY KEY(id)  
);  

 

#Next, we will insert some records into the sales_info table as follows:
INSERT INTO sales_info(product, quantity, fiscalYear)  
VALUES  
    ('2003 Maruti Suzuki',110, 2020),  
    ('2015 Avenger', 120,2020),  
    ('2018 Honda Shine', 150,2020),  
    ('2014 Apache', 150,2020);  
 select * from sales_info;

 

/*Next, create a BEFORE UPDATE trigger that is invoked before a change is made to the sales_info table.
The trigger produces an error message and stops the updation if we update the value in the quantity 
column to a new value two times greater than the current value.*/
DELIMITER $$   
drop trigger if exists before_update_salesInfo; 
CREATE TRIGGER before_update_salesInfo  
BEFORE UPDATE  
ON sales_info FOR EACH ROW  
BEGIN  
    DECLARE error_msg VARCHAR(255);  
    SET error_msg = ('The new quantity cannot be greater than 2 times the current quantity');  
    IF new.quantity > old.quantity * 2 THEN  
    SIGNAL SQLSTATE '45000'   #SQLSTATE is a code which identifies SQL error conditions. It composed by five characters, which can be numbers or uppercase. To signal a generic SQLSTATE value, use '45000', which means “unhandled user-defined exception.”
    SET MESSAGE_TEXT = error_msg;  
    END IF;  
END $$ 

 

#Then, show all triggers in the current database by using the SHOW TRIGGERS statement:
SHOW TRIGGERS;

 

#call the trigger
UPDATE sales_info SET quantity = 135 WHERE id = 2; select * from sales_info; #This statement works well because it does not violate the rule.
UPDATE sales_info SET quantity = 700 WHERE id = 2;  #It will give the error as follows because it violates the rule. 