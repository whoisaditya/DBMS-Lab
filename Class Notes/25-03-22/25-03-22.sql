create database 22_03_22;
use 22_03_22;

create table parents(
    id int primary key,
    name varchar(255),
    city varchar(255),
    phoneno varchar(255),
    occupation varchar(255),
    value int
);

[15:55] Jyotismita Chaki
    
//BEFORE insert
select * from parents;
/*We will use a CREATE TRIGGER statement to create a BEFORE INSERT trigger. 
This trigger is invoked automatically that inserts the occupation = 'doctor' if someone 
tries to insert the occupation = 'nurse'.*/

drop trigger if exists before_insert_occupation; 

DELIMITER //
Create Trigger before_insert_occupation  
BEFORE INSERT ON parents FOR EACH ROW  
BEGIN  
IF NEW.occupation = 'nurse' THEN SET NEW.occupation = 'Doctor';  
END IF;  
END //

INSERT INTO parents VALUES 
(7, 'puja', 'chennai', '524-745', 'teacher', 4),
(8, 'rani', 'gujrat', '251-854', 'nurse', 5);
select * from parents;
###############################################################################################

#AFTER INSERT
#First, create a new table called members:
DROP TABLE IF EXISTS members;
CREATE TABLE members(
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    birthDate DATE,
    PRIMARY KEY (id)
);

 

#Second, create another table called reminders that stores reminder messages to members.
DROP TABLE IF EXISTS reminders;
CREATE TABLE reminders (
    id INT AUTO_INCREMENT,
    memberId INT,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (id , memberId)
);

 

/*The following statement creates an AFTER INSERT trigger that inserts a reminder into the reminders 
table if the birth date of the member is NULL*/
DELIMITER $$
CREATE TRIGGER after_members_insert
AFTER INSERT
ON members FOR EACH ROW
BEGIN
    IF NEW.birthDate IS NULL THEN
        INSERT INTO reminders(memberId, message)
        VALUES(new.id,CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
    END IF;
END$$

 

#call the trigger
INSERT INTO members(name, email, birthDate)
VALUES
    ('John Doe', 'john.doe@example.com', NULL),
    ('Jane Doe', 'jane.doe@example.com','2000-01-01'),
    ('Alex', 'alex@example.com', NULL);

 

SELECT * FROM members;    
SELECT * FROM reminders;  

###############################################################################################

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
UPDATE sales_info SET quantity = 135 WHERE id = 2; select * from sales_info; 

#This statement works well because it does not violate the rule.

UPDATE sales_info SET quantity = 700 WHERE id = 2;  

#It will give the error as follows because it violates the rule.
###############################################################################################################
    
#AFTER UPDATE
#Suppose we have created a table named studentdetails to store the students information as follows:
drop table if exists studentdetails;
CREATE TABLE studentdetails(    
    id int NOT NULL AUTO_INCREMENT,    
    name varchar(45) NOT NULL,    
    class int NOT NULL,    
    email_id varchar(65) NOT NULL,    
    PRIMARY KEY (id)    
);  
#Next, we will insert some records into this table using the below statement:
INSERT INTO studentdetails (name, class, email_id)     
VALUES ('Stephen', 6, 'stephen@example.com'),   
('Bob', 7, 'bob@example.com'),   
('Steven', 8, 'steven@example.com'),   
('Alexandar', 7, 'alexandar@example.com');  
select * from studentdetails;


#Third, we will create another table named students_log that keeps the updated information in the selected user.
drop table if exists students_log;
CREATE TABLE students_log(    
    descreptions varchar(65) NOT NULL  
);  


/*We will then create an AFTER UPDATE trigger that promotes all students in the next class, 
i.e., 6 will be 7, 7 will be 8, and so on. Whenever an updation is performed on a single row 
in the "studentdetails" table, a new row will be inserted in the "students_log" table. 
This table keeps the current user id and a description regarding the current update.*/
DELIMITER $$  
drop trigger if exists after_update_studentsInfo$$
CREATE TRIGGER after_update_studentsInfo  
AFTER UPDATE  
ON studentdetails FOR EACH ROW  
BEGIN  
    if old.class <> new.class then
    INSERT into students_log VALUES (CONCAT('Update Student Record ', OLD.name, ' Previous Class :',  
    OLD.class, ' Present Class ', NEW.class));  
    end if;
END $$  


#call the trigger
UPDATE studentdetails SET class = class + 1;  $$
update studentdetails set class = class + 1 where id = 3; $$
select * from studentdetails;
select * from students_log;
###################################################################################################
 
#BEFORE DELETE
#Suppose we have created a table named salaries to store the salary information of an employee as follows:
drop table if exists salaries;
CREATE TABLE salaries (  
    emp_num INT PRIMARY KEY,  
    valid_from DATE NOT NULL,  
    amount DEC(8 , 2 ) NOT NULL DEFAULT 0  
);  

 

#Next, we will insert some records into this table using the below statement:
INSERT INTO salaries (emp_num, valid_from, amount)  
VALUES  
    (102, '2020-01-10', 45000),  
    (103, '2020-01-10', 65000),  
    (105, '2020-01-10', 55000),  
    (107, '2020-01-10', 70000),  
    (109, '2020-01-10', 40000);  
select * from salaries;    

 

#Third, we will create another table named salary_archives that keeps the information of deleted salary.
drop table if exists salary_archives;
CREATE TABLE salary_archives (  
    id INT PRIMARY KEY AUTO_INCREMENT,  
    emp_num INT,  
    valid_from DATE NOT NULL,  
    amount DEC(18 , 2 ) NOT NULL DEFAULT 0,  
    deleted_time TIMESTAMP DEFAULT NOW()  
);  

 

/*We will then create a BEFORE DELETE trigger that inserts a new record into the salary_archives 
table before a row is deleted from the salaries table.*/
DELIMITER $$  
CREATE TRIGGER before_delete_salaries  
BEFORE DELETE  
ON salaries FOR EACH ROW  
BEGIN  
    INSERT INTO salary_archives (emp_num, valid_from, amount)  
    VALUES(OLD. emp_num, OLD.valid_from, OLD.amount);  
END$$   

 

#call the trigger
DELETE FROM salaries WHERE emp_num = 102;  
SELECT * FROM salary_archives;  
DELETE FROM salaries; 
#################################################################################################


#AFTER DELETE
#Suppose we have created a table named salaries to store the salary information of an employee as follows:
drop table if exists salaries;
CREATE TABLE salaries (  
    emp_num INT PRIMARY KEY,  
    valid_from DATE NOT NULL,  
    amount DEC(8 , 2 ) NOT NULL DEFAULT 0  
);  
#Next, we will insert some records into this table using the below statement:
INSERT INTO salaries (emp_num, valid_from, amount)  
VALUES  
    (102, '2020-01-10', 45000),  
    (103, '2020-01-10', 65000),  
    (105, '2020-01-10', 55000),  
    (107, '2020-01-10', 70000),  
    (109, '2020-01-10', 40000);  
select * from salaries;

 

#Third, we will create another table named total_salary_budget that keeps the salary information from the salaries table.
drop table if exists total_salary_budget;
CREATE TABLE total_salary_budget(  
    total_budget DECIMAL(10,2) NOT NULL  
);  

 

/*Fourth, we will use the SUM() function that returns the total salary from the salaries table 
and keep this information in the total_salary_budget table:*/
INSERT INTO total_salary_budget (total_budget)
SELECT SUM(amount) FROM salaries;  

 

select * from total_salary_budget;

 

/*We will then create an AFTER DELETE trigger that updates the total salary into the 
total_salary_budget table after a row is deleted from the salaries table.*/
DELIMITER $$  
CREATE TRIGGER after_delete_salaries  
AFTER DELETE  
ON salaries FOR EACH ROW  
BEGIN  
   UPDATE total_salary_budget SET total_budget = total_budget - old.amount;  
END$$   

 

#call the trigger
DELETE FROM salaries WHERE emp_num = 102;  
SELECT * FROM total_salary_budget; 
DELETE FROM salaries; 
#############################################################################################


[15:57] Jyotismita Chaki
    
#CREATE MULTIPLE TRIGGER FOR A SINGLE TABLE
#Suppose that you want to change the price of a product (column MSRP ) and log the old price in a separate table named PriceLogs .


DROP TABLE IF EXISTS products;
CREATE TABLE products (
  productCode varchar(15) NOT NULL,
  productName varchar(70) NOT NULL,
  productLine varchar(50) NOT NULL,
  productScale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription text NOT NULL,
  quantityInStock smallint(6) NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  PRIMARY KEY (productCode)
  );


insert  into products(productCode,productName,productLine,productScale,productVendor,productDescription,quantityInStock,buyPrice,MSRP) values 
('S10_1678','1969 Harley Davidson Ultimate Chopper','Motorcycles','1:10','Min Lin Diecast','This replica features working kickstand, front suspension, gear-shift lever, footbrake lever, drive chain, wheels and steering. All parts are particularly delicate due to their precise scale and require special care and attention.',7933,'48.81','95.70'),
('S10_1949','1952 Alpine Renault 1300','Classic Cars','1:10','Classic Metal Creations','Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',7305,'98.58','214.30'),
('S10_2016','1996 Moto Guzzi 1100i','Motorcycles','1:10','Highway 66 Mini Classics','Official Moto Guzzi logos and insignias, saddle bags located on side of motorcycle, detailed engine, working steering, working suspension, two leather seats, luggage rack, dual exhaust pipes, small saddle bag located on handle bars, two-tone paint with chrome accents, superior die-cast detail , rotating wheels , working kick stand, diecast metal with plastic parts and baked enamel finish.',6625,'68.99','118.94'),
('S10_4698','2003 Harley-Davidson Eagle Drag Bike','Motorcycles','1:10','Red Start Diecast','Model features, official Harley Davidson logos and insignias, detachable rear wheelie bar, heavy diecast metal with resin parts, authentic multi-color tampo-printed graphics, separate engine drive belts, free-turning front fork, rotating tires and rear racing slick, certificate of authenticity, detailed engine, display stand\r\n, precision diecast replica, baked enamel finish, 1:10 scale model, removable fender, seat and tank cover piece for displaying the superior detail of the v-twin engine',5582,'91.02','193.66'),
('S10_4757','1972 Alfa Romeo GTA','Classic Cars','1:10','Motor City Art Classics','Features include: Turnable front wheels; steering function; detailed interior; detailed engine; opening hood; opening trunk; opening doors; and detailed chassis.',3252,'85.68','136.00');


select * from products; 


#First, create a new price_logs table using the following CREATE TABLE statement:
drop table if exists PriceLogs;
CREATE TABLE PriceLogs (
    id INT AUTO_INCREMENT,
    productCode VARCHAR(15) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    updated_at TIMESTAMP NOT NULL 
            DEFAULT CURRENT_TIMESTAMP 
            ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (productCode)
        REFERENCES products (productCode)
);


#Second, create a new trigger that activates when the BEFORE UPDATE event of the products table occurs:
DELIMITER $$
drop trigger if exists before_products_update$$
CREATE TRIGGER before_products_update 
   BEFORE UPDATE ON products 
   FOR EACH ROW 
BEGIN
     IF OLD.msrp <> NEW.msrp THEN
         INSERT INTO PriceLOgs(productcode,price)
         VALUES(old.productCode,old.msrp);
     END IF;
END$$


#Third, check the price of the product S12_1099:
SELECT 
    productCode, 
    msrp 
FROM 
    products
WHERE 
    productCode = 'S10_4698';


#Third, change the price of a product using the following UPDATE statement:
UPDATE products
SET msrp = 240
WHERE productCode = 'S10_4698';


#Fourth, query data from the PriceLogs table:
SELECT * FROM PriceLogs;


#Fifth, create the UserChangeLogs table: Suppose that you want to log the user who changed the price.
CREATE TABLE UserChangeLogs (
    id INT AUTO_INCREMENT,
    productCode VARCHAR(15) DEFAULT NULL,
    updatedAt TIMESTAMP NOT NULL 
    DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    updatedBy VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (productCode)
        REFERENCES products (productCode)
);


/*Sixth, create a BEFORE UPDATE trigger for the products table. This trigger activates 
after the before_products_update trigger.*/
DELIMITER $$
CREATE TRIGGER before_products_update_log_user
   BEFORE UPDATE ON products 
   FOR EACH ROW 
   FOLLOWS before_products_update
BEGIN
    IF OLD.msrp <> NEW.msrp THEN
    INSERT INTO 
            UserChangeLogs(productCode,updatedBy)
        VALUES
            (OLD.productCode,USER());
    END IF;
END$$


#Seventh, update the price of a product using the following UPDATE statement:
UPDATE 
    products
SET 
    msrp = 190
WHERE 
    productCode = 'S10_4698';


#Eighth, query data from both PriceLogs and UserChangeLogs tables:
SELECT * FROM PriceLogs;
SELECT * FROM UserChangeLogs;


#to see the order of trigger execution
SELECT 
    trigger_name, 
    action_order
FROM
    information_schema.triggers
WHERE
    trigger_schema = 'unidb'
ORDER BY 
    event_object_table , 
    action_timing , 
    event_manipulation;
####################################################################################################