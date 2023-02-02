--Name: Yilin Wen
--UT EID: YW22559
--HW5


--HW4 #1.       YW22559
--list out he titles that has holds on

SELECT DISTINCT title, format, genre, isbn
FROM title
WHERE title_id IN
    (SELECT title_id
     FROM patron_title_holds)
ORDER BY genre, title;

--HW4 #2.       YW22559
--list of titles have more than the avarage page number.

SELECT title, publisher, number_of_pages, genre
FROM title
WHERE number_of_pages >
    (SELECT AVG(number_of_pages)
     FROM title)
ORDER BY genre, number_of_pages DESC;

--HW4 #3.       YW22559
--list out the patrons who did not register a phone with lib.

SELECT first_name, last_name, email
FROM patron
WHERE patron_id NOT IN
    (SELECT patron_id
     FROM patron_phone)
ORDER BY last_name;

--HW4 #4.       YW22559
-- Querry the title, publisher, genre, and ISBN for all the titles that are published by a publisher that has more than 3 books in our Title table. 

SELECT title, t.publisher, genre, isbn
FROM title t INNER JOIN
    (SELECT COUNT(title), publisher
     FROM title
     GROUP BY publisher
     HAVING COUNT(title) > 3) tp
ON t.publisher = tp.publisher
ORDER BY publisher;

--HW4 #5.       YW22559
--list out the patronts that has a accrued fees.

SELECT patron_id, email, accrued_fees, primary_branch
FROM patron
WHERE patron_id IN
    (SELECT DISTINCT patron_id
     FROM checkouts
     WHERE date_in IS NULL)
AND accrued_fees > 0
ORDER BY primary_branch, email;

--HW4 #6.       YW22559
--Querry from Dual table for date formatting practice.

SELECT SYSDATE,
TO_CHAR(SYSDATE, 'YEAR') AS Year_caps,
RTRIM((TO_CHAR(SYSDATE, 'Day Month'))) AS Day_Month_caps,
TO_CHAR(SYSDATE, 'HH') AS Hour,
TRIM(TO_CHAR(TO_DATE('31-DEC-21'), 'DDD') - TO_CHAR(SYSDATE, 'DDD')) AS Days_left,
TO_CHAR(SYSDATE, 'mon dy YYYY') AS Month_Day_Year
FROM dual;

--HW4 #7.       YW22559
--Querry the status of checkouts for current status.

SELECT first_name||' '||last_name AS Patron, 
'checkout' ||' '|| checkout_id ||' '|| 'due back on' ||' ' || due_back_date AS Checkout_due_back, 
NVL2(date_in, 'returned', 'not returned yet') AS Return_Status, 
'Accrued Fee Total is: ' ||''|| TO_CHAR(accrued_fees, '$99.99') AS Fees
FROM patron p INNER JOIN checkouts c
ON p.patron_id = c.patron_id
ORDER BY Return_Status, due_back_date;

--HW4 #8.       YW22559
--Querry about the in-active patrons within the systems.

SELECT SUBSTR(LOWER(first_name),1,1) ||'. '|| UPPER(last_name) AS Inactive_patron
FROM patron
Where patron_id NOT IN
    (SELECT patron_id
     FROM checkouts)
ORDER BY last_name;

--HW4 #9.       YW22559
--List out titles that are published for more than 5 years.

SELECT title, LENGTH(title) AS title_length, publish_date,
TRUNC((sysdate - publish_date)/365.25) AS age_of_book
FROM title
WHERE TRUNC((sysdate - publish_date)/365.25) >= 5
ORDER BY TRUNC((sysdate - publish_date)/365.25);

--HW4 #10.       YW22559
--Querry out the address seperately of each branch location.

SELECT branch_id, 
SUBSTR(branch_name,1, (INSTR(branch_name,' ')-1)) AS district,
SUBSTR(address,1, (INSTR(address,' ')-1)) AS Street_Number,
SUBSTR(address, (INSTR(address,' ')+1)) AS Street_Name
FROM location;

--HW4 #11.       YW22559
--query that provides a redacted contact list with first and last name, redacted email, phone type, and redacted_phone

SELECT first_name, last_name,
'*******' ||SUBSTR(email, INSTR(email,'@')) AS Redacted_email,
phone_type,
'***-***-' ||SUBSTR(phone,9,4) AS Redacted_phone
FROM patron p INNER JOIN patron_phone pp
ON p.patron_id = pp.patron_id;

--HW4 #12.       YW22559
--Using a single select statement querry the book reading level.

SELECT title, publisher, number_of_pages, genre,
CASE
    WHEN number_of_pages > 700 THEN 'College'
    WHEN number_of_pages BETWEEN 250 AND 700 THEN 'High School' 
    WHEN number_of_pages <= 250 THEN 'Middle School'
    END AS Reading_Level
FROM title
WHERE format IN ('B','E')
ORDER BY Reading_Level, title;

--HW4 #13.       YW22559
-- using number of checkout to query about the most popular titles

SELECT DENSE_RANK() OVER (ORDER BY (COUNT(DISTINCT checkout_id)))as Popularity_rank,
title, COUNT(DISTINCT checkout_id) AS Number_of_checkouts
FROM title t LEFT JOIN title_loc_linking tll
ON t.title_id = tll.title_id
LEFT JOIN checkouts c
ON c.title_copy_id = tll.title_copy_id
GROUP BY title
ORDER BY Number_of_checkouts DESC, title;

--HW4 #14.       YW22559
--Updated the previous querry to return row 58 using inline join.

SELECT *
FROM (SELECT ROW_NUMBER() OVER (ORDER BY (COUNT(DISTINCT checkout_id))DESC)as Row_number,
title, COUNT(DISTINCT checkout_id) AS Number_of_checkouts
FROM title t LEFT JOIN 
    (SELECT title_id, title_copy_id
     FROM title_loc_linking) tll
     ON t.title_id = tll.title_id
     LEFT JOIN checkouts c
     ON c.title_copy_id = tll.title_copy_id
GROUP BY title
ORDER BY Number_of_checkouts DESC, title)
WHERE ROW_NUMBER = 58;
