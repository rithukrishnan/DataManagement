--HW3 DML
--Name: Rithu Anand Krishnan
--UT EID: RA38893

-- Question 1: 	Rithu Anand Krishnan RA38893
--  Write a SELECT statement that returns the following columns from the Customer_Payment table: Cardholder first name, cardholder last name, the card type, and the card expiration date.  Then, run this statement to make sure it works correctly.
--  Add an ORDER BY clause to this statement that sorts the result set by expiration date in ascending order (i.e. oldest to newest). Then, run this statement again to make sure it works correctly. Note, this is a good way to iteratively build and test a statement, one clause at a time.

SELECT cardholder_first_name, cardholder_last_name, card_type, expiration_date
FROM Customer_Payment
ORDER BY expiration_date ASC;




-- Question 2: 	Rithu Anand Krishnan RA38893
-- Write a SELECT statement that returns one column from the Customer table named customer_full_name that combines the first_name and last_name columns. Format this column with the first name, a space, and last name like this: Michael Jordan
-- Sort the result set by last name in descending sequence.

-- Using LIKE operator 
SELECT (first_name||' '||last_name) AS "customer_full_name"
FROM customer
WHERE first_name like 'L%'
or first_name like 'M%'
or first_name like 'O%'
ORDER BY last_name DESC;

-- Using SUBSTR function and IN
SELECT (first_name||' '||last_name) AS "customer_full_name"
FROM customer
WHERE SUBSTR(first_name,1,1) IN ('L', 'M','O')
ORDER BY last_name DESC;





-- Question 3: 	Rithu Anand Krishnan RA38893
-- Write a SELECT statement that returns these columns from Reservation: customer_id, confirmation_nbr, date_created, check_in_date, and number_of_guests. Return only the rows for reservations that have a status of “upcoming” that have check_in_dates that are today or in the future but only for this year.  That means to filter where only the check_in_date is greater or equal the current date (note: use SYSDATE here) and on or before Dec 31st 2021.
-- See if you can do this with only the following operators (<, >, <=, or >=).  Sort results by check_in_date to show the most recent first and the older dates at the bottom
SELECT reservation_id, confirmation_nbr, date_created, check_in_date,number_of_guests
FROM reservation
WHERE status = 'U'
and check_in_date >= SYSDATE and check_in_date <= '31-DEC-2022'
ORDER BY check_in_date DESC;




-- Question 4: 	Rithu Anand Krishnan RA38893
-- Create a duplicate of the previous query but this time update the WHERE clause to use the BETWEEN operator. Keep the rest of the query the same
SELECT reservation_id, confirmation_nbr, date_created, check_in_date,number_of_guests
FROM reservation
WHERE status = 'U'
and check_in_date between SYSDATE AND '31-DEC-2022'
ORDER BY check_in_date DESC;

-- Using the MINUS operator, compare the query from #3 to the query from Part A in #4.  If you get no rows returned, that means the queries produce the same results
SELECT reservation_id, confirmation_nbr, date_created, check_in_date,number_of_guests
FROM reservation
WHERE status = 'U'
and check_in_date >= SYSDATE and check_in_date <= '31-DEC-2022'
MINUS
SELECT reservation_id, confirmation_nbr, date_created, check_in_date,number_of_guests
FROM reservation
WHERE status = 'U'
and check_in_date between SYSDATE AND '31-DEC-2022';



-- Question 5: 	Rithu Anand Krishnan RA38893
-- Filter the query to only show completed reservations (i.e. status = ‘C’).  After you have that running correctly, update filter to use the ROWNUM pseudo column so the result set contains only the first 10 rows from the table.
-- Sort the result set by the column alias length_of_stay in descending order and then also by customer_id ascending 
SELECT customer_id AS "The customer_id column", location_id AS "The location_id column" ,(check_out_date - check_in_date) AS "length_of_stay"
FROM reservation
WHERE ROWNUM <= 10 and status = 'C'
ORDER BY "length_of_stay" DESC, "The customer_id column" ASC;



-- Question 6: 	Rithu Anand Krishnan RA38893
-- Write a SELECT statement that returns the first_name, last_name, email from Customer and also a fourth column called credits_available.  
-- The credits available is calculated by subtracting credits used from credits earned.  Once you have this, filter to only show customers with at least 10 or more credits available.  Sort results by the column alias credits_available in descending order
SELECT first_name, last_name, email, (stay_credits_earned - stay_credits_used) AS "credits_available"
FROM customer
WHERE (stay_credits_earned - stay_credits_used) >= 10
ORDER BY "credits_available" DESC;




-- Question 7: 	Rithu Anand Krishnan RA38893
-- Write a SELECT statement that returns the first, middle, and last name of a customer’s payment profile on Customer_Payment 
SELECT cardholder_first_name, cardholder_mid_name, cardholder_last_name
FROM customer_payment
WHERE cardholder_mid_name IS NOT NULL
ORDER BY 2,3 ASC;




-- Question 8: 	Rithu Anand Krishnan RA38893
-- This displays a number for the month, a number for the day, and a four-digit year. Use a FROM clause that specifies the Dual table
SELECT SYSDATE AS "today_unformatted",
TO_CHAR (SYSDATE, 'MM/DD/YYYY') AS "today_formatted",
25 AS credicts_earned,
25/10 AS Stays_Earned,
FLOOR(25/10) AS Redeemable_stays,
ROUND(25/10) AS Next_Stay_to_earn
FROM DUAL;




-- Question 9: 	Rithu Anand Krishnan RA38893
-- Write a SELECT statement that pulls Reservation records for all reservations that are completed (i.e. status of C) for location 2. Return only the following columns: Customer_id, Location_id, and a calculated column called length_of_stay which is just checkout date minus check-in date. Sort the results by length_of_stay descending and customer_id ascending. Lastly only pull in the top 20 rows.
-- That means we want you to sort the table before filtering the 20 rows
SELECT customer_id, location_id, (check_out_date - check_in_date) AS "length_of_stay"
FROM reservation
WHERE status = 'C' and location_id = 2
ORDER BY "length_of_stay" DESC, customer_id ASC
FETCH FIRST 20 ROWS ONLY;




-- Question 10: 	Rithu Anand Krishnan RA38893
-- Write a query that returns all the rows from Customer for customers that have a gmail.com address (i.e. an email that contains the word ‘Gmail’. The problem is that some people’s emails are gmail.com while others are Gmail.com or GMAIL.COM etc. We want a query that can pull all gmails regardless of capitalization.  
-- So in your where clause use the LOWER() function to compare the lowercase version of email to filter only rows that contain the word ‘gmail’
SELECT *
FROM customer
WHERE LOWER(email) LIKE '%gmail%';
