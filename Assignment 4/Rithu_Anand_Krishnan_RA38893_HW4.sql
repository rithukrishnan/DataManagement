-- HW 4   


-- Question 1: Rithu Anand Krishnan  RA38893
-- Pull all riders and their rides.  Filter data to only show completed rides (i.e. end_datetime is not null). Return just the 
-- following columns: first_name, last_name, phone, request_datetime, pickup_address, dropoff_address, 
-- discount_amount, final_fare, rating.  Sort results by rider_id ascending and request_datetime descending so that we 
-- see all riders with rides and their most recent rides first.

SELECT first_name, last_name, phone, request_datetime, pickup_address, dropoff_address, discount_amount, final_fare, rating
FROM Rider rider_table 
INNER JOIN Ride ride_table
ON rider_table.rider_id = ride_table.rider_id
WHERE ride_table.end_datetime IS NOT NULL
ORDER BY ride_table.rider_id ASC, ride_table.request_datetime DESC;



-- Question 2: Rithu Anand Krishnan  RA38893
-- Write a query that joins matching records between the following tables (Drivers, Rides, Riders) so we can 
-- understand who gave rides to whom.  Only return rows for rides that have ratings and ended in the month of 
-- February

SELECT request_datetime, dr.first_name ||' '|| dr.last_name AS "Driver Name", rd.vehicle_id, rdr.first_name ||' '|| rdr.last_name AS "Rider Name", pickup_address,final_fare
FROM driver dr
INNER JOIN Ride rd 
ON dr.driver_id = rd.driver_id
INNER JOIN Rider rdr
ON rdr.rider_id = rd.rider_id
WHERE rating IS NOT NULL AND end_datetime <= '28-FEB-22'
ORDER BY request_datetime, rd.driver_id, rd.rider_id;




-- Question 3: Rithu Anand Krishnan  RA38893
-- Write a query that returns any riders in our system’s Rider table that have never taken a ride.  We’re going 
-- to use this query to send them a proactive discount for a free ride!  Show that you can use the proper type of 
-- join that will return all riders even when there’s no matching ride for them. Results should display the 
-- following columns for the customer: rider_id, first_name, email, phone  

SELECT rdr.rider_id, rdr.first_name, rdr.email, rdr.phone
FROM rider rdr
LEFT JOIN ride rd
ON rdr.rider_id = rd.rider_id
WHERE rd.rider_id IS NULL;




-- Question 4: Rithu Anand Krishnan  RA38893
-- If the driver has given less than 3 rides, they are considered to a Newbie so their driver_level column 
-- should contain a literal string value of ‘0-Newbie’. If the driver has given at least 3 rides but not more 
-- than 10, their driver_level column should contain a literal string value of ‘0-Bronze Level’. Drivers with 
-- 10 to 24 are ‘2-Silver Level’. Drivers with 25 or more rides should have a driver_level of ‘3-Gold Level’

SELECT '0-Neibie' AS Driver_level, first_name, last_name, email, rides_given
FROM driver 
WHERE rides_given < 3 

UNION

SELECT '1-Bronze Level' AS Driver_level, first_name, last_name, email, rides_given
FROM driver 
WHERE rides_given >= 3 AND rides_given < 10 

UNION

SELECT '2-Silver Level' AS Driver_level, first_name, last_name, email, rides_given
FROM driver 
WHERE rides_given >= 10 AND rides_given < 25

UNION

SELECT '3-Gold Level' AS Driver_level, first_name, last_name, email, rides_given
FROM driver 
WHERE rides_given >= 25
ORDER BY Driver_level, last_name;




-- Question 5: Rithu Anand Krishnan  RA38893
-- Write a SELECT statement that returns one row for each city and discount type with the following columns 
-- The count of discounts with a column alias of discounts_used        Be sure to only show the count of discounts that have a used flag of ‘Y’ 
-- Sort the results by city and discount_type.

SELECT rd.city, ds.discount_type, COUNT(ds.used_flag) as discounts_used 
FROM rider rd INNER JOIN discounts ds 
ON rd.rider_id = ds.rider_id
WHERE ds.used_flag = 'Y'
group by rd.city, ds.discount_type 
order by rd.city, ds.discount_type;
 
 
 
 
-- Question 6: Rithu Anand Krishnan  RA38893
-- We’d like to look at the all the driver/rider combinations and the count of rides this driver and rider have 
-- had together.  We also only want to pull the data where the rider is from the city of ‘Bend’.  We also want the query to 
-- just show the driver’s full name, rider’s full name, and the count of rides for each pair of driver/rider that has ever 
-- ridden together. Then filter out any results that have a count_of_rides of less than 2 so we can just see the driver who has 
-- been matched to the same rider more than once

 SELECT dr.first_name|| ' ' ||dr.last_name as Driver, rdr.first_name|| ' ' ||rdr.last_name as Rider, COUNT(rd.ride_id) AS count_of_rides
 FROM driver dr,rider rdr,ride rd 
 WHERE rdr.city = 'Bend' AND dr.driver_id = rd.driver_id AND rdr.rider_id = rd.rider_id AND rd.discount_amount IS NULL    
 GROUP BY dr.first_name|| ' ' ||dr.last_name, rdr.first_name|| ' ' ||rdr.last_name 
 HAVING COUNT(rd.ride_id)  >= 2 
 ORDER BY rdr.first_name|| ' ' ||rdr.last_name ASC;
 
 
 
 
 
-- Question 7: Rithu Anand Krishnan  RA38893
-- Write a query that returns the first_name, last_name, address, city, state, and zip of each rider that has taken 
-- more than 5 rides. We want you to utilize a subquery to do this to show that you can.  Hint: Start by selecting all 
-- rider_ids and count of ride_ids from RIDE and group by rider_id and filter down to only the rider_ids that have a 
-- count of rides than is more than 5. Once you have this query running you can remove the count(ride_id) from the 
-- select so you only have a list of rider_ids. Once you have your list of rider_ids that have taken more than 5 rides, use 
-- this as a subquery in the WHERE portion of another query that pulls the columns from rider   

SELECT rdr.first_name, rdr.last_name, rdr.address, rdr.city, rdr.zip 
FROM rider rdr 
WHERE rdr.rider_id IN
        (SELECT rd.rider_id 
         FROM ride rd 
         GROUP BY rd.rider_id 
         HAVING COUNT(rd.ride_id) > 5) 
         AND rdr.zip IN ('97702','97703');
 
 
 
 
-- Question 8: Rithu Anand Krishnan  RA38893
-- Using an inline view, write a statement that will return one row per rider that has only 1 ride and is using 
-- AMEX. Each row should include the following columns we need to process the credit: cardholder_first_name, 
-- cardholder_last_name, cardnumber, expiration_date, and cc_id
-- Using an inline view means you will have a subquery in the main query’s FROM clause that acts as its own table that 
-- you will join rider_payment to. 

SELECT rider_payment.rider_id, cardholder_first_name, cardholder_last_name, cardnumber, max(expiration_date) as expiration_date, min(cc_id) as cc_id
FROM
    (SELECT rider_id 
     FROM ride 
     WHERE end_datetime >= '01-Feb-22' and end_datetime <= '28-Feb-22'  
     GROUP BY rider_id 
     HAVING COUNT(rider_id) = 1) ride1
INNER JOIN rider_payment 
ON ride1.rider_id = rider_payment.rider_id
WHERE cardtype = 'AMEX'
GROUP BY rider_payment.rider_id, cardholder_first_name, cardholder_last_name, cardnumber;




-- Question 9: Rithu Anand Krishnan  RA38893
-- Write a query to retrieve a row for each ride requested since February 1st
-- The discount column that returns the values from ride.discount formatted as a currency if there is a value and if 
-- there is no value, it shows “none”.  Use NVL or NVL2 to do this.
-- The final_fare column that returns the values from ride.final_fare formatted as a currency.

SELECT ride_id, 'Driver ' || driver_id || ' dropped rider ' || rider_id || ' at ' || dropoff_address AS details, 
       TO_CHAR(end_datetime,'MON-DD') AS drop_date, 
       SUBSTR(TO_CHAR(end_datetime,'YYYY-MM-DD HH24:MM:SS'), 11,9) AS drop_time, 
       CONCAT('$',final_fare) AS final_fare,
       NVL2(discount_amount, CONCAT('$',discount_amount), 'none') AS discount
FROM ride 
WHERE end_datetime >= '01-FEB-22'
ORDER BY ride_id,driver_id ;




-- Question 10: Rithu Anand Krishnan  RA38893​
-- The first portion of their email (i.e. before the @ symbol) with a column alias of emailname
-- The last portion of their email (i.e. after the @ symbol) with a column alias of emaildomain
-- Sort results by emaildomain so drivers using the same email service are grouped together.

SELECT driver_id, last_name, email,
    SUBSTR(email,1,INSTR(email,'@') - 1) emailname,
    SUBSTR(email,INSTR(email,'@') + 1)  emaildomain
FROM driver
ORDER BY emaildomain;




-- Question 11: Rithu Anand Krishnan  RA38893​
-- Write a single SELECT that returns the same results that the UNION query did on 4 above but this time use a CASE 
-- statement to dynamically change the driver_level column.  Make sure your new query returns the same results as the 
-- union query. 
SELECT 
    CASE
        WHEN rides_given < 3 THEN '0-Newbie'
        WHEN rides_given >= 3 AND rides_given < 10 THEN '1-Bronze Level'
        WHEN rides_given >= 10 AND rides_given < 25 THEN '2-Silver Level'
        WHEN rides_given > 24 THEN '3-Gold Level'
    END AS "Driver_level", first_name, last_name, email, rides_given
FROM driver
ORDER BY 1, last_name;




-- Question 12: Rithu Anand Krishnan  RA38893​
-- The “Driver_Rank” column which assigns a dense rank based on rides_given.

SELECT first_name, last_name, driver_id, email, rides_given,
       DENSE_RANK() OVER (
                ORDER BY rides_given DESC)  AS "Driver_Rank" 
FROM driver;




-- Question 13: Rithu Anand Krishnan  RA38893​
-- PART A
-- Update the previous query by making it into an in-line join subquery, meaning, go select from the query itself.  Then 
-- add in a row filter to only pull rownum less than or equal to 7 and see now if the rownum filter works as you would 
-- want it to.  

SELECT * 
FROM  (SELECT first_name, last_name, driver_id, email, rides_given,
       DENSE_RANK() OVER (
                ORDER BY rides_given DESC)  AS "Driver_Rank" 
       FROM driver)
WHERE ROWNUM <= 7;



-- PART B
-- Create a copy of the query you wrote in Part A of this question but this time swap out the filter with rownum to 
-- include a row filter that uses column alias (driver_rank) and only pulls driver_rank of less than or equal to 3

SELECT * 
FROM  (SELECT first_name, last_name, driver_id, email, rides_given,
       DENSE_RANK() OVER (
                ORDER BY rides_given DESC)  AS "Driver_Rank" 
       FROM driver) dr
where dr."Driver_Rank" <= 3;














