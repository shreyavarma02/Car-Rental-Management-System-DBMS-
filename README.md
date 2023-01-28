# Car-Rental-Management-System-DBMS-
A DBMS application to manage a car rental booking business which uses mysql. It uses Streamlit in the front-end to connect a python application to the mysql server.
This is a system where customers can rent cars of the desired model etc, for a specified number of days. It also provides different pickup, drop locations.
Customers can make reservation of car for a particular date, and must provide the pickup location. Different employees manage different reservations.
The database consists of a distance info table which keeps track of the total distance covered by each customer in the car. It also consists of a cost table which 
contains the amount per km for each car model. The system also provides discount to customers based on how many reservations they have made, and the payment 
amount for each customer is calculated based on that.


ER diagram:
![image](https://user-images.githubusercontent.com/97691078/215281865-7066c5b2-1dbe-44c4-a465-6a16c927caa2.png)

Relational Schema:
![image](https://user-images.githubusercontent.com/97691078/215281905-1f04941a-a2cf-40f4-b4a7-1b5b70f6e15e.png)

