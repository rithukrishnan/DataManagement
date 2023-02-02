--HW4 #1        YW22559
--Listed out the patron's full name, phone type, and phone by joining patron table and patron_phone table
SELECT first_name ||' ' || last_name AS "Full_Name", phone_type, phone
FROM Patron p
INNER JOIN Patron_Phone pp
ON p.patron_id = pp.patron_id
ORDER BY last_name, phone_type DESC;

--HW4 #2        YW22559
--List out all the patron from northeast central branch who has a accured fee by joining location table and patron table
SELECT first_name, last_name, email, accrued_fees
FROM location l
INNER JOIN patron p
ON l.branch_id = p.primary_branch
WHERE branch_name = 'Northeast Central Branch' AND accrued_fees > 0
ORDER BY accrued_fees DESC;

--HW4 #3        YW22559
--list out the fiction books' information by joining title table and title_author_linking table and author table
SELECT t.title AS "Fiction Title", number_of_pages, first_name ||' ' || last_name AS Author_Name
FROM title t
INNER JOIN title_author_linking tal
ON t.title_id = tal.title_id
INNER JOIN author a
ON tal.author_id = a.author_id
WHERE format = 'B' AND t.genre = 'FIC'
ORDER BY Author_Name, title;

--HW4 #4        YW22559
--list out the titles that is not on hold and sort by genre and title by joining title table and patron_title_holds table
SELECT title, format, genre,isbn
FROM title t
FULL OUTER JOIN patron_title_holds pth
ON t.title_id = pth.title_id
WHERE hold_id IS NULL
ORDER BY GENRE, TITLE;

--HW4 #5        YW22559
--list out all the science title and who put the holds by joining title table and patron table and patron_title-hold table
SELECT title, first_name, last_name, hold_id
FROM patron_title_holds pth
INNER JOIN patron p
ON p.patron_id = pth.patron_id
FULL OUTER JOIN title t
ON pth.title_id = t.title_id
WHERE t.genre = 'SCI';

--HW4 #6        YW22559
-- seperate all the book into three different reading level by using union between select statements
SELECT title, publisher, number_of_pages, 'College' AS reading_level, genre
FROM title
WHERE number_of_pages > 700 AND (FORMAT IN('B','E'))

UNION

SELECT title, publisher, number_of_pages, 'High School' AS reading_level, genre
FROM title
WHERE number_of_pages BETWEEN 250 AND 700 AND (FORMAT IN('B','E'))

UNION

SELECT title, publisher, number_of_pages, 'Middle School' AS reading_level, genre
FROM title
WHERE number_of_pages < 250 AND (FORMAT IN('B','E'))
ORDER BY reading_level, title;

--HW4 #7        YW22559
-- count the number of patron and number zip with MINIMUN, AVERAGE AND MAXIUM accrued fees.
SELECT 
COUNT(patron_id) AS patron_count,
COUNT(DISTINCT zip) AS distinct_zipcodes,
ROUND(MIN(accrued_fees),2) AS lowest_fees,
ROUND(AVG(accrued_fees),2) AS average_fees,
ROUND(MAX(accrued_fees),2) AS highest_fees
FROM patron;

--HW4 #8        YW22559
--query the patrons count in each branches by joining location table and patron table
SELECT branch_name,
COUNT(patron_id) AS patron_count
FROM location l
LEFT JOIN patron p
ON l.branch_id = p.primary_branch
GROUP BY branch_name
ORDER BY branch_name;

--HW4 #9        YW22559
-- summarize the average accrued late fee in each zipcode filtering out the late flag on ones by joining checkouts table and patron table
SELECT zip,
ROUND(AVG(accrued_fees),2) AS average_accrued_fees
FROM patron p
LEFT JOIN checkouts c
ON p.patron_id = c.patron_id
WHERE late_flag = 'N'
GROUP BY zip
ORDER BY average_accrued_fees DESC;

--HW4 #10        YW22559
--summarize the average days overdue for each branch and show the one that is over 10 days by joining checkouts table and title_loc_linking table and location table
SELECT branch_name,
ROUND(AVG(SYSDATE - due_back_date), 2) AS avg_days_overdue
FROM checkouts c
LEFT JOIN title_loc_linking tll
ON c.title_copy_id = tll.title_copy_id
LEFT JOIN location l 
ON tll.last_location = l.branch_id
WHERE late_flag = 'Y' AND date_in IS NULL
GROUP BY branch_name
HAVING ROUND(AVG(SYSDATE - due_back_date), 2) >= 10
ORDER BY branch_name, avg_days_overdue;

--HW4 #11        YW22559
--list out the title that has more then 1 author by joining title table and title_author_linking table
SELECT title, genre,
COUNT(DISTINCT tal.author_id) AS author_count
FROM title t
INNER JOIN title_author_linking tal
ON t.title_id = tal.title_id
GROUP BY title, genre
HAVING COUNT(DISTINCT tal.author_id) > 1
ORDER BY title DESC, genre;

--HW4 #12        YW22559
--list out the titles that has more than 1 author where the last name contains Phd by adding to the previous codes
SELECT title, genre,
COUNT(DISTINCT tal.author_id) AS author_count
FROM title t
INNER JOIN title_author_linking tal
ON t.title_id = tal.title_id
LEFT JOIN author a
ON tal.author_id = a.author_id
WHERE last_name LIKE '%PhD%'
GROUP BY title, genre
HAVING COUNT(DISTINCT tal.author_id) > 1
ORDER BY title DESC, genre;

--HW4 #13        YW22559
--PART A: query that returns the average accrued fees for each city on the patron table
SELECT city,
ROUND(AVG(accrued_fees),2) AS average_accrued_fees
FROM patron
GROUP BY ROLLUP(city);
-- The city of West Guillory has a higher average for the late fee. People from that city need to learn return books on time.

--PART B: Update the query to now include Patron.Zip into the SELECT and ROLLUP.  Then also filter out patrons that have 0 accrued_fees.
SELECT city, zip,
ROUND(AVG(accrued_fees),2) AS average_accrued_fees
FROM patron
WHERE accrued_fees != 0
GROUP BY ROLLUP(city, zip);
--The most problematic zip code that has the highest late fees are 73940 and 73946.

--HW4 #14        YW22559
--summarize the how many copies of title in each branch and find the branch has too many or too few copies by joining location table and title_loc_linking table
SELECT branch_id, branch_name,
COUNT(tll.title_copy_id) AS count_of_title_copies
FROM location l
INNER JOIN title_loc_linking tll
ON l.branch_id = tll.last_location
GROUP BY l.branch_id, l.branch_name
HAVING COUNT(tll.title_copy_id) NOT BETWEEN 40 AND 50
ORDER BY branch_name;