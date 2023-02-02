--1.	Create the members table with the key and data types noted in ERD. 
CREATE TABLE members
(
    uteid       varchar(20)     primary key,
    first_name  varchar(30),
    last_name   varchar(40),
    email       varchar(40),
    phone       varchar(12),
    grade       number(1),
    birthdate   date
);


--2.	Create the committees table with the key and data types noted in ERD.  
CREATE TABLE committees
(
    committee_id NUMBER(5) PRIMARY KEY,
    committee_name VARCHAR(30),
    semester_year VARCHAR(4)
);


--3.	Create the members_committees table with composite PK and two FKs like shown above
CREATE TABLE members_committees 
(
   uteid           VARCHAR(20)         REFERENCES  MEMBERS (UTEID),
   committee_id    NUMBER(5)           References  COMMITTEES (COMMITTEE_id),
   CONSTRAINT   uteid_committtee_pkk   PRIMARY KEY  (uteid, committee_id)
);


--4.	Add a DEFAULT constraint to members so that grade defaults to 1 when you enter a new member.  Assume 1 is 1st year. 2 is 2nd year, 3 is 3rd year, etc.
ALTER TABLE members
MODIFY grade DEFAULT 1;

--5.	Write separate inserts (one per table).
--5a	Insert a member without providing a value for grade. This will test the default constraint from #4
insert into members
values ('xyz987', 'Harriet', 'Williams', 'harriet@email.com', '136-555-1321',1,'09-AUG-84');

--5b	Insert a committee.  Note, semester_year is should be formatted like so: FA21
insert into committees (committee_id, committee_name, semester_year)
values (1,'VIP Speaker Series', 'FA21');

--5c	Write an insert that adds your member to the committee you created.
insert into members_committees
values ('xyz987', 1);

--6.	Write more inserts to test your constraints
--a	    Validate you cannot enter a 2nd member with same uteid
insert into members
values ('xyz987', 'Xavier', 'Yoko', 'xavier@email.com', '241-555-1321',1,'19-SEP-88');

--b	    Validate you cannot enter a 2nd committee with the same committee_id
insert into committees (committee_id, committee_name, semester_year)
values (1,'DINE with Professors', 'FA21');

--c	    Validate you can only assign valid members to valid committees 
insert into member_committees
values ('abc123', 1);

insert into member_committees
values ('xyz987', 99);

--d	    Insert a 2nd member and then assign that member to the committee to confirm you can have many members on a committee
insert into members
values ('abc123', 'Albert', 'Cliford', 'albert@email.com', '745-555-7454',1,'01-MAR-85');

insert into members_committees
values ('abc123', 1);

--7.	Add Check constraint to members.  The grade column should be only be 1,2,3, or 4.  
ALTER TABLE members
ADD CHECK (grade > 0);
    --or--
ALTER TABLE members
ADD CONSTRAINT check_grade CHECK (grade > 0);
 
--8.	Change the phone column’s name to be phone_num.  Note: this isn’t in the reading so you’ll need to google it.   
alter table members
RENAME COLUMN phone to phone_num;

--9.	Add a UNIQUE constraint to members.email.  Try to do this with an ALTER statement.
alter table members
ADD UNIQUE (email); 
 
--10.	Write three drop statements that will drop your three tables 
drop table members_committees;
drop table members;
drop table committees;

--11.	Update the original CREATE TABLE statement for memebers to include your constraints and updates for #7, 8, and 9.  
CREATE TABLE members
(
    uteid       varchar(20)     primary key ,
    first_name  varchar(30),
    last_name   varchar(40),
    email       varchar(40)     UNIQUE,
    phone_num   varchar(12),
    grade       number(1)       CONSTRAINT check_grade CHECK (grade > 0),
    birthdate   date
);

--12.	Update the original CREATE TABLE statement for committees to default the committee_id to be the next value of a sequence
--create sequence
create sequence committee_id_seq;

--update create statement to default committee_id to the sequence next value
CREATE TABLE committees
(
    committee_id NUMBER(5) default committee_id_seq.nextval PRIMARY KEY,
    committee_name VARCHAR(30),
    semester_year VARCHAR(4)
);
 
----13.	Run the drops, creates, and inserts as a script so that it results with the proper tables seeded with data.

--DROP Database objects (Tables and sequences)
drop table members_committees;
drop table members;
drop table committees;
drop sequence committee_id_seq;

--CREATE TABLES
CREATE TABLE members
(
    uteid       varchar(20)     primary key,
    first_name  varchar(30),
    last_name   varchar(40),
    email       varchar(40)     UNIQUE,
    phone_num   varchar(12),
    grade       number(1)       CONSTRAINT check_grade CHECK (grade > 0),
    birthdate   date
);

create sequence committee_id_seq;

CREATE TABLE committees
(
    committee_id NUMBER(5) default committee_id_seq.nextval PRIMARY KEY,
    committee_name VARCHAR(30),
    semester_year VARCHAR(4)
);


CREATE TABLE members_committees 
(
    uteid           VARCHAR(20)         REFERENCES  MEMBERS (UTEID),
    committee_id    NUMBER(5)           References  COMMITTEES (COMMITTEE_id),
    CONSTRAINT   uteid_committtee_pkk   PRIMARY KEY  (uteid, committee_id)
);
 
insert into members
values ('xyz987', 'Harriet', 'Williams', 'harriet@email.com', '136-555-1321',1,'09-AUG-84');

insert into members
values ('abc123', 'Albert', 'Cliford', 'albert@email.com', '745-555-7454',1,'01-MAR-85');

insert into committees (committee_name, semester_year)
values ('VIP Speaker Series', 'FA21');

 insert into members_committees
values ('xyz987', 1);

insert into members_committees
values ('abc123', 1);

Commit;

----Update, Delete, and Truncate
--14.	Write a statement that updates the last_name of one of the members
Update members
set last_name = 'Slater'
where uteid = 'abc123';

--15.	Write a statement that updates all members by adding 1 to their grade
update members
set grade = grade + 1;

--16.	Write TRUNCATE statements to purge data from members. Note, that you’ll have to deal with the FK constraints for members.  
--To do this write a delete statement to purge member_committee assignments. 
truncate table members_committees;
delete from members;
 

 
----Want more DDL constraint practice
--16.	Write an alter statement to change the length of a column. e.g. UTEID should be a max length of 10.   
ALTER table members
modify uteid VARCHAR(10);

--17.	Write an alter statement to change a column’s data type. e.g. Change phone_num from VARCHAR to CHAR
ALTER table members
modify phone_num CHAR(12);
 
--18.	Change the name of a table.  Refresh left panel in SQL Developer to see change took affect
rename members to member;
rename member to members; --this changes it back to original name

--19.	Drop a constraint 
ALTER table members
DROP Constraint check_grade;

--20.	Drop a column 
ALTER table members
DROP column grade;    
    