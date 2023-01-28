/* Create database*/

create table EMPLOYEE( emp_id varchar(10) NOT NULL PRIMARY KEY, Fname varchar(20), 
                       Lname varchar(10), Salary int,
                       contact_no varchar(20), Responsibility varchar(20));

create table DISCOUNT( discount_id varchar(20) NOT NULL PRIMARY KEY ,  
                       cust_type varchar(20),discount_amt int);

create table PAYMENT(payment_id varchar(20) NOT NULL PRIMARY KEY, pay_method varchar(20), 
                     downpay float, discount_id varchar(20),
                     FOREIGN KEY (discount_id) REFERENCES DISCOUNT(discount_id), 
                     total_amt float,tax float,vehicle_model varchar(10), 
                     FOREIGN KEY (vehicle_model) REFERENCES COST_TABLE(vehicle_model));

create table COST_TABLE(vehicle_model varchar(20) NOT NULL PRIMARY KEY,amount_per_km int); 

create table DISTANCE_INFO(payment_id varchar(20), 
                           FOREIGN KEY (payment_id) REFERENCES PAYMENT(payment_id), 
                           start_distance int, end_distance int, tot_distance int); 

create table RESERVATION(reservation_id varchar(20) NOT NULL PRIMARY KEY, pickup_date varchar(20), 
                         pickup_location varchar(20),no_of_days int, return_date varchar(20), 
                         customer_id varchar(20), 
                         FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE, 
                         vehicle_id varchar(20), 
                         FOREIGN KEY(vehicle_id) REFERENCES VEHICLE(vehicle_id) ON DELETE CASCADE, 
                         payment_id varchar(20), 
                         FOREIGN KEY(payment_id) REFERENCES PAYMENT(payment_id) ON DELETE CASCADE);

create table MANAGES(emp_id varchar(20), FOREIGN KEY (emp_id) REFERENCES EMPLOYEE(emp_id) ON DELETE CASCADE, 
                     reservation_id varchar(10),
                     FOREIGN KEY(reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE);

create table CUSTOMER(customer_id varchar(20) NOT NULL PRIMARY KEY, country varchar(20),
                      city varchar(20),street varchar(20), 
                      fname varchar(20),lname varchar(20),dl_no int, contact_no varchar(20));

create table VEHICLE(vehicle_id varchar(20) NOT NULL PRIMARY KEY, mileage int,plate_no varchar(20), 
                     model varchar(20), 
                     color varchar(20));


alter table reservation add cust_type varchar(10);

/*Insert tuples using insert query*/
insert into cost_table values( 'Dzire', 9);
insert into cost_table values( 'Baleno', 8);
insert into cost_table values( 'Ertiga', 9);
insert into cost_table values( 'City', 10);
insert into cost_table values( 'Creta', 9);
insert into cost_table values( 'XUV', 11);
insert into cost_table values( 'Alto', 8);
insert into cost_table values( 'WagonR', 7);
insert into cost_table values( 'Civic', 9);

/*insert using mass insert*/

LOAD DATA INFILE "Customer.csv" into TABLE customer
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;




/* UPDATE 1*/
UPDATE distance_info
SET tot_distance = end_distance-start_distance;

/*UPDATE 2*/
update reservation set no_of_days = return_date-pickup_date;

/*UPDATE 3*/
update customer set cust_type= 'regular' where customer_id in (select customer_id from reservation group by customer_id having count(*)=1);
update customer set cust_type= 'special' where customer_id in (select customer_id from reservation group by customer_id having count(*)=2);
update customer set cust_type= 'VIP' where customer_id in (select customer_id from reservation group by customer_id having count(*)>=3);

/* UPDATE 4*/
create view cust_discount as  select customer_id, discount_id, discount_amt from customer JOIN discount ON customer.cust_type=discount.cust_type;

create view payment_discount as  select payment_id, discount_id, discount_amt from cust_discount JOIN reservation ON cust_discount.customer_id = reservation.customer_id;

UPDATE payment SET payment.discount_id= (select discount_id from payment_discount where payment.payment_id= payment_discount.payment_id);


/*UPDATE 5*/
 create view tot_amt_calc2 as select payment_id, tot_distance, vehicle_model,amount_per_km,discount_id,discount_amt,total_amt,tax from ((payment natural join distance_info) natural join cost_table) natural join discount;
 update tot_amt_calc2 set total_amt= ( tot_distance* amount_per_km - discount_amt );
 update tot_amt_calc2 set tax= (7.5/100 * total_amt );
 update tot_amt_calc2 set total_amt= (total_amt + tax );

  UPDATE payment SET payment.total_amt= (select total_amt from tot_amt_calc2 where payment.payment_id= tot_amt_calc2.payment_id);
  UPDATE payment SET payment.tax= (select tax from tot_amt_calc2 where payment.payment_id= tot_amt_calc2.payment_id);


  /*join 1*/
select vehicle_id, vehicle_model, color, amount_per_km from vehicle natural join cost_table;

/*join 2*/
select fname,lname,reservation_id from employee natural join manages;

/*join 3*/
 select fname,lname from customer natural join reservation where pickup_date > '06-06-2022';

/*join 4*/
select plate_no from vehicle natural join cost_table where amount_per_km >8;


/*AGGREGATE 1*/
select responsibility, count(emp_id) as count from employee group by responsibility;

/*AGGREGATE 2*/
 select pay_method, sum(total_amt) as total from payment group by pay_method;

/*AGGREGATE 3*/
select vehicle_id, vehicle_model, max(mileage) as max_mileage from vehicle;

/*AGGREGATE 4*/
select vehicle_model, avg(total_amt) as average_amount from payment group by vehicle_model;

/*AGGREGATE 5*/
 select cust_type, count(customer_id) as count from customer group by cust_type;

/*SET 1*/
select contact_no from customer
UNION
select contact_no from employee;

/*SET 2*/
select fname,lname from customer
UNION ALL
select fname,lname from employee;

/*SET 3*/
select vehicle_id from vehicle
MINUS
select vehicle_id from reservation;

/*SET 4*/
select customer_id from customer where cust_type='VIP'
INTERSECT
select customer_id from reservation where no_of_days>5;

 /*FUNCTION*/

DELIMITER $$
CREATE FUNCTION ELIGIBLE_CRITERIA_2(dl_no varchar(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE VALUE varchar(50);
IF dl_no is not NULL then
return("Eligible");
ELSE 
return("Non-Eligible");
end if; 
END;
$$

DELIMITER ;

insert into customer values ( 'C16', 'India', 'Bengaluru','Ecity','Sakshi','Sharma', NULL, '9918735246', 'regular');

with t as (Select customer_id,dl_no from customer )
select customer_id,ELIGIBLE_CRITERIA_2(dl_no) as eligibility_to_rent,dl_no from t;







DELIMITER ;

/*STORED PROCEDURE*/
DELIMITER &&  
CREATE PROCEDURE consultant_salary__ (IN resp varchar(20), OUT highest_sal int )  
BEGIN  
    SELECT * FROM employee where responsibility=resp;  
    SELECT AVG(salary)
    INTO highest_sal
    FROM employee
    WHERE responsibility = resp;
END &&  
DELIMITER ;

mysql> CALL consultant_salary__('Consultant',@A);
SELECT @A; 


/*TRIGGER*/

DELIMITER $$
create Trigger city_check
BEFORE INSERT 
ON customer 
FOR EACH ROW
BEGIN
DECLARE error_msg VARCHAR(255);
 declare count int;
 SET error_msg = ('City has to be Bengaluru, since currently the rental services are only availbale in Bengaluru');
 IF (new.city != 'Bengaluru') THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = error_msg;
 END IF;
END $$
DELIMITER ;

insert into customer values ('C17','India','Chennai','Mount Road','Krishna','Raj','DL155','9102345692','regular');




/*CURSOR*/
create table manages_backup(emp_id varchar(10) ,reservation_id varchar(20));

DELIMITER $$
create PROCEDURE backup_7( rid varchar(20))
BEGIN
DECLARE done INT DEFAULT 0;
declare emp_id varchar(10);
declare reservation_id varchar(10);

declare cur cursor for
select * from manages where manages.reservation_id = rid;

Declare continue handler for not found set done=1;

Open cur;


Fetch from cur into emp_id,reservation_id;
While done=0 DO
  insert into manages_backup values (emp_id,reservation_id);
  Fetch from cur into emp_id,reservation_id;

END WHILE

CLOSE cur;

END ;$$
DELIMITER ;




DELIMITER $$
CREATE TRIGGER before_delete_manage
BEFORE DELETE
ON manages FOR EACH ROW
BEGIN
CALL backup_7(OLD.reservation_id);
END$$
DELIMITER ;


delete from manages where reservation_id='R02';


/*EXTRA*/
/*Trigger 2*/
DELIMITER $$
create Trigger insert_reservation
BEFORE INSERT 
ON reservation 
FOR EACH ROW
BEGIN
update customer set cust_type= 'VIP' where customer.customer_id = new.customer_id AND customer.cust_type='special';

update customer set cust_type= 'special' where customer.customer_id = new.customer_id AND customer.cust_type='regular';

insert into payment values(new.payment_id,'online',1000,NULL,NULL,NULL,'XUV');
END$$
DELIMITER ;

--
insert into reservation values('R27','02-05-2022','Begur',4,'06-05-2022','C12','V3','P27')






/*CURSOR 2*/
create table vehicle_backup(vehicle_id varchar(10) ,mileage int, plate_no varchar(20),vehicle_model varchar(20),color varchar(10));

DELIMITER $$
create PROCEDURE backup_8( vid varchar(20))
BEGIN
DECLARE done1 INT DEFAULT 0;
declare vehicle_id varchar(10);
declare mileage int;
declare plate_no varchar(10);
declare vehicle_model varchar(20);
declare color varchar(10);

declare cur cursor for
select * from vehicle where vehicle.vehicle_id = vid;

Declare continue handler for not found set done1=1;

Open cur;
Fetch from cur into vehicle_id,mileage,plate_no,vehicle_model,color;
While done1=0 DO
  insert into vehicle_backup values (vehicle_id,mileage,plate_no,vehicle_model,color);
  Fetch from cur into vehicle_id,mileage,plate_no,vehicle_model,color;
END WHILE;
CLOSE cur;
END ;$$
DELIMITER ;




DELIMITER $$
CREATE TRIGGER before_delete_vehicle
BEFORE DELETE
ON vehicle FOR EACH ROW
BEGIN
CALL backup_8(OLD.vehicle_id);
END$$
DELIMITER ;






/*Function 2*/

DELIMITER $$
CREATE FUNCTION update_payment6(payment_id varchar(20),vehicle_model varchar(20))
RETURNS int
DETERMINISTIC
BEGIN
update payment set discount_id= (select discount_id from discount where discount.cust_type=(select cust_type from customer where customer_id= (select customer_id from reservation where reservation.payment_id=payment_id))) where payment.payment_id= payment_id;
update payment set total_amt=((select tot_distance from distance_info where distance_info.payment_id=payment_id)*(select amount_per_km from cost_table where cost_table.vehicle_model=vehicle_model) - (select discount_amt from discount where discount.discount_id= 'D2')) where payment.payment_id= payment_id;
update payment set tax= 7.5/100 * total_amt where payment.payment_id= payment_id;

return 1; 
END;
$$

DELIMITER ;


select update_payment6('P21','XUV');




