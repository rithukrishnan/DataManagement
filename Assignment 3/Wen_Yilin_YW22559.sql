--Name: Yilin Wen
--UT EID: YW22559

-- 1.--Yilin Wen   YW22559
--updated the checkouts table for all the new late flag
UPDATE CHECKOUTS
SET late_flag = 'Y'
WHERE late_flag = 'N' AND date_in IS NULL AND due_back_date < sysdate;

ROLLBACK;

--2.--Yilin Wen   YW22559
--ordered the title table by the number of pages.
SELECT genre, title, publisher, number_of_pages
FROM title
ORDER BY number_of_pages ASC;

--3.--Yilin Wen   YW22559
--list out the author full name if the author's first name start with A,B,C.
SELECT (first_name||' '||last_name) AS "author_full_name"
FROM author
WHERE SUBSTR(first_name,1,1) IN ('A', 'B','C')
ORDER BY last_name DESC;

--4.--Yilin Wen   YW22559
--list out the book information that were checkout from 2/1/2021 to 2/28/2021 
SELECT patron_id, title_copy_id, date_out, due_back_date,date_in
FROM checkouts
WHERE date_out between '01-FEB-2021' AND '28-FEB-2021'
ORDER BY date_in ASC, date_out ASC;

--5.--Yilin Wen   YW22559
--list out the book information that were checkout from 2/1/2021 to 2/28/2021 using and operator
SELECT patron_id, title_copy_id, date_out, due_back_date,date_in
FROM checkouts
WHERE date_out >= '01-FEB-2021' AND date_out <= '28-FEB-2021'
ORDER BY date_in ASC, date_out ASC;

--6.--Yilin Wen   YW22559
--pulled out checkout id and title copy id and renewal left from checkouts table sorted the renewal left column from small to big number.
SELECT checkout_id AS "The checkout_id column", title_copy_id AS "The title_copy_id column" ,(2-times_renewed) AS "renewals_left"
FROM checkouts
WHERE ROWNUM <= 5
ORDER BY "renewals_left" ASC;

--7.--Yilin Wen   YW22559
--list out the book with book level greater than 9
SELECT title,genre, ROUND(number_of_pages/100) AS "book_level"
FROM title
WHERE number_of_pages/100 > 9;

--8.--Yilin Wen   YW22559
--list out the author with middle name and order them by middle name and last name
SELECT first_name, middle_name, last_name
FROM author
WHERE middle_name IS NOT NULL
ORDER BY 2,3 ASC;

--9.--Yilin Wen   YW22559
--using dual table to insert the following data.
SELECT SYSDATE AS "today_unformatted",
TO_CHAR (SYSDATE, 'MM/DD/YYYY') AS "today_formatted",
5 AS days_late,
.25 AS late_fee,
5*.25 AS total_late_fees,
5-(5*.25) AS late_fees_until_lock
FROM DUAL;

--10.--Yilin Wen   YW22559
--list out the first 5 checkout_id and title copy id and revewals left from the checkouts 
SELECT checkout_id, title_copy_id,(2-times_renewed) AS "renewals_left"
FROM checkouts
ORDER BY "renewals_left"
FETCH FIRST 5 ROWS ONLY;

--11.--Yilin Wen   YW22559
--list out the distinct genre from title with accending genre 
SELECT DISTINCT genre
FROM title
ORDER BY genre ASC;

--12.--Yilin Wen   YW22559
--list out the title that has "bird" in it.
SELECT title
FROM title
WHERE LOWER(title) LIKE '%bird%';
