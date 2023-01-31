--commit and rollback the inserted data
COMMIT;

ROLLBACK;


--Section 1: DROP sequence/tables section--Yilin Wen    YW22559

--DROP all sequences for branchID,patron_ID,phone_ID,title_ID,author_ID,hold_ID,title_copy_ID,and checkout_ID--Yilin Wen    YW22559
DROP SEQUENCE patron_ID_seq;

DROP SEQUENCE phone_ID_seq;

DROP SEQUENCE title_ID_seq;

DROP SEQUENCE author_ID_seq;

DROP SEQUENCE hold_ID_seq;

DROP SEQUENCE title_copy_ID_seq;

DROP SEQUENCE checkout_ID_seq;

--DROP all table--Yilin Wen    YW22559
DROP TABLE "CHECKOUTS" CASCADE CONSTRAINTS;

DROP TABLE "TITLE_LOC_LINKING" CASCADE CONSTRAINTS;

DROP TABLE "PATRON_TITLE_HOLDS" CASCADE CONSTRAINTS;

DROP TABLE "TITLE_AUTHOR_LINKING" CASCADE CONSTRAINTS;

DROP TABLE "AUTHOR" CASCADE CONSTRAINTS;

DROP TABLE "TITLE" CASCADE CONSTRAINTS;

DROP TABLE "PATRON_PHONE" CASCADE CONSTRAINTS;

DROP TABLE "PATRON" CASCADE CONSTRAINTS;

DROP TABLE "LOCATION" CASCADE CONSTRAINTS;

--Section 2: CREATE sequence/tables section--Yilin Wen    YW22559

--CREATE sequences for branchID,patron_ID,phone_ID,title_ID,author_ID,hold_ID,title_copy_ID,and checkout_ID--Yilin Wen    YW22559
CREATE SEQUENCE patron_ID_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE phone_ID_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE title_ID_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE author_ID_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE hold_ID_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE title_copy_ID_seq
START WITH 100001
INCREMENT BY 1;

CREATE SEQUENCE checkout_ID_seq
START WITH 1
INCREMENT BY 1;

--CREATE Location table--Yilin Wen    YW22559
CREATE TABLE Location
(
Branch_ID     NUMBER   PRIMARY KEY,
Branch_Name   VARCHAR(50)   UNIQUE,
Address       VARCHAR(50),
City          VARCHAR(50),
State         CHAR(2),
Zip           CHAR(5),
Phone         CHAR(12)
);

--CREATE Patron table--Yilin Wen    YW22559
CREATE TABLE Patron
(
Patron_ID      NUMBER(12)   DEFAULT patron_ID_seq.NEXTVAL     PRIMARY KEY,
First_Name     VARCHAR(20)    NOT NULL,
Last_Name      VARCHAR(20)    NOT NULL,
Email          VARCHAR(50)        NOT NULL     UNIQUE,
Address_Line_1 VARCHAR(100)  NOT NULL,
Address_Line_2 VARCHAR(100)  NULL,
City           VARCHAR(50),
State          CHAR(2),
Zip            CHAR(5),
Accrued_Fee    NUMBER     DEFAULT 0,
Primary_Branch NUMBER    REFERENCES Location(Branch_ID),
CONSTRAINT email_length_check CHECK (Length(Email) >=7)
);

--CREATE Patron_phone table--Yilin Wen    YW22559
CREATE TABLE Patron_Phone
(
Phone_ID     NUMBER(12)   DEFAULT phone_ID_seq.NEXTVAL     PRIMARY KEY,
Patron_ID    NUMBER(12)     REFERENCES Patron(Patron_ID),
Phone_Type   VARCHAR(20),
Phone        VARCHAR(20)
);

--CREATE Title table--Yilin Wen    YW22559
CREATE TABLE Title
(
Title_ID     NUMBER(12)   DEFAULT title_ID_seq.NEXTVAL     PRIMARY KEY,
Title        VARCHAR(50)     NOT NULL,
Publisher     VARCHAR(50),
Publish_Date         DATE,
Number_of_pages    NUMBER     NULL, 
Format        CHAR(1),   
Genre         VARCHAR(3),
ISBN          VARCHAR(20)     UNIQUE
);

--CREATE Author table--Yilin Wen   YW22559
CREATE TABLE Author
(
Author_ID     NUMBER(12)   DEFAULT author_ID_seq.NEXTVAL   PRIMARY KEY,
First_Name     VARCHAR(20)    NOT NULL,
Middle_Name    VARCHAR(20)    NULL,
Last_Name      VARCHAR(20)    NOT NULL,
Bio_Notes      VARCHAR(100)   NULL
);

--CREATE Title_Author_Linking table--Yilin Wen   YW22559
CREATE TABLE Title_Author_Linking
(
Author_ID     NUMBER(12)   REFERENCES Author(Author_ID),
Title_ID      NUMBER(12)   REFERENCES Title(Title_ID),
CONSTRAINT Author_Title_ID_pk PRIMARY KEY (Author_ID, Title_ID)
);

--CREATE Patron_Title_Holds table--Yilin Wen   YW22559
CREATE TABLE Patron_Title_Holds
(
Hold_ID       NUMBER(12)     DEFAULT hold_ID_seq.NEXTVAL   PRIMARY KEY,
Patron_ID     NUMBER(12)     REFERENCES Patron(Patron_ID),
Title_ID      NUMBER(12)     REFERENCES Title(Title_ID),
Date_Held     DATE
);

--CREATE Title_Loc_Linking table--Yilin Wen   YW22559
CREATE TABLE Title_Loc_Linking
(
Title_copy_ID   NUMBER   DEFAULT title_copy_ID_seq.NEXTVAL   PRIMARY KEY,
Title_ID        NUMBER(12)     REFERENCES Title(Title_ID),
Last_Location   NUMBER         REFERENCES Location(Branch_ID),
Status          CHAR(1)        CHECK(Status IN ('I','A'))
--I=in-transit A=available for pickup            
);

--CREATE Checkouts table--Yilin Wen   YW22559
CREATE TABLE Checkouts
(
Checkout_ID   NUMBER   DEFAULT checkout_ID_seq.NEXTVAL   PRIMARY KEY,
Patron_ID     NUMBER(12)   NOT NULL     REFERENCES Patron(Patron_ID),
Title_copy_ID NUMBER   NOT NULL      REFERENCES Title_Loc_Linking(Title_copy_ID),
Date_Out  DATE  DEFAULT SYSDATE,
Due_Back_Date DATE  DEFAULT (SYSDATE +21),
Date_In      DATE  NULL,
Times_Renewed NUMBER(1) DEFAULT 0  CHECK (Times_Renewed <= 2),
Late_Flag     CHAR(1)  DEFAULT 'N' CHECK (Late_Flag IN ('N','Y'))
);

--Secion 3: INSERT data section--Yilin Wen    YW22559

--INSERT data into Location table--Yilin Wen YW22559
INSERT INTO Location
VALUES (1,'sugar land','1456 Mesquite Blvd','Land Sugar','TX','77477','832-330-3784');

INSERT INTO Location
VALUES (2,'wander land','1 Mes Blvd','Land wander','TX','74177','974-320-2345');

INSERT INTO Location
VALUES (3,'wuhu','9874 easy ln','Land','TX','12345','831-360-3714');

INSERT INTO Location
VALUES (4,'beijing','1456 Mesquite dr','austin','TX','85204','999-330-3784');

INSERT INTO Location
VALUES (5,'shenzhen','1456 same street','dallas','TX','10212','888-330-3784');

INSERT INTO Location
VALUES (6,'guangzhou','1789 different dr','houston','TX','36529','777-330-3784');

--INSERT data into Patron table--Yilin Wen   YW22559
INSERT INTO Patron
VALUES (Patron_ID_seq.NEXTVAL,'Yilin','Wen','yw22559@utexas.edu','1234 easy street','','austin','TX',78741,DEFAULT,4);

INSERT INTO Patron
VALUES (Patron_ID_seq.NEXTVAL,'Paul','Dravis','pd55664@utexas.edu','5678 easy street','','austin','TX',78741,DEFAULT,4);

--INSERT Phone number for Patrons into Patron_Phone table--Yilin Wen   YW22559
INSERT INTO Patron_Phone
VALUES (PHONE_ID_SEQ.NEXTVAL,1,'att','626-420-3784');

INSERT INTO Patron_Phone
VALUES (PHONE_ID_SEQ.NEXTVAL,2,'tmobile','832-740-2365');

INSERT INTO Patron_Phone
VALUES (PHONE_ID_SEQ.NEXTVAL,2,'verizon','626-424-3222');

--INSERT 4 tittles into the title table--Yilin Wen   YW22559
INSERT INTO Title
VALUES (Title_ID_seq.NEXTVAL,'Hunger Game','NORTON INC.','01-AUG-14','500','B','FIC','000-0000');

INSERT INTO Title
VALUES (Title_ID_seq.NEXTVAL,'Perfect life','hous INC.','01-APR-15','50','B','NON','000-0001');

INSERT INTO Title
VALUES (Title_ID_seq.NEXTVAL,'Evolution of the Earth','husu INC.','01-AUG-16','','D','BIO','000-0011');

INSERT INTO Title
VALUES (Title_ID_seq.NEXTVAL,'Nice','new york INC.','01-AUG-17','4520','B','SCI','000-0111');

--INSERT 5 Author into Author table--Yilin Wen   YW22559
INSERT INTO Author
VALUES (Author_ID_seq.NEXTVAL,'ROLWING','','J.K','female author from U.K');

INSERT INTO Author
VALUES (Author_ID_seq.NEXTVAL,'Obob','PAUL','Trumb','male author from USA');

INSERT INTO Author
VALUES (Author_ID_seq.NEXTVAL,'Ethan','','Dub','');

INSERT INTO Author
VALUES (Author_ID_seq.NEXTVAL,'Pei','Ran','Wang','author from China');

INSERT INTO Author
VALUES (Author_ID_seq.NEXTVAL,'yoyo','','Jack','female author from Russia');

--INSERT author_id and title_id into the linking table--Yilin Wen   YW22559
INSERT INTO TITLE_AUTHOR_LINKING
VALUES (1,1);

INSERT INTO TITLE_AUTHOR_LINKING
VALUES (2,2);

INSERT INTO TITLE_AUTHOR_LINKING
VALUES (3,3);

INSERT INTO TITLE_AUTHOR_LINKING
VALUES (4,4);

INSERT INTO TITLE_AUTHOR_LINKING
VALUES (5,4);

--INSERT 8 title copies into sugar land branch--Yilin Wen   YW22559
INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,1,1,'A');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,1,1,'I');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,2,1,'A');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,2,1,'I');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,3,1,'A');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,3,1,'I');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,4,1,'A');

INSERT INTO TITLE_LOC_LINKING
VALUES (Title_copy_ID_seq.NEXTVAL,4,1,'I');

--INSERT 3 Holds into the Patron_Title_Holds table-- Yilin Wen   YW22559
INSERT INTO Patron_Title_Holds
VALUES (Hold_ID_seq.NEXTVAL,1,1,'04-MAR-21');

INSERT INTO Patron_Title_Holds
VALUES (Hold_ID_seq.NEXTVAL,1,4,'04-MAR-21');

INSERT INTO Patron_Title_Holds
VALUES (Hold_ID_seq.NEXTVAL,2,2,'01-MAR-21');

--INSERT 3 books checked out by patron into the Checkouts table--Yilin Wen   YW22559
INSERT INTO Checkouts
VALUES (Checkout_ID_seq.NEXTVAL,1,'100007',DEFAULT,DEFAULT,NULL,DEFAULT,DEFAULT);

INSERT INTO Checkouts
VALUES (Checkout_ID_seq.NEXTVAL,2,'100001',DEFAULT,DEFAULT,NULL,DEFAULT,DEFAULT);

INSERT INTO Checkouts
VALUES (Checkout_ID_seq.NEXTVAL,2,'100003','01-JAN-21','01-MAR-21',NULL,2,'Y');

--Section 4: CREATE index section--Yilin Wen    YW22559

--CREATE indexes for all 8 Foreign Keys--Yilin Wen   YW22559
CREATE INDEX Primary_Branch_ix
  ON Patron (Primary_Branch);
  
CREATE INDEX Patron_ID_ix
  ON Patron_Phone (Patron_ID);

CREATE INDEX Patron_ID_ix1
  ON Patron_Title_Holds (Patron_ID);
  
CREATE INDEX Title_ID_ix
  ON Patron_Title_Holds (Title_ID);

CREATE INDEX Title_ID_ix1
  ON Title_Loc_Linking (Title_ID);
  
CREATE INDEX Last_Location_ix
  ON Title_Loc_Linking (Last_Location);
  
CREATE INDEX Patron_ID_ix2
  ON Checkouts (Patron_ID);
  
CREATE INDEX Title_copy_ID_ix
  ON Checkouts (Title_copy_ID);

--CREATE index for non-FK attribute--Yilin Wen   YW22559
CREATE INDEX Title_ix
  ON Title (Title);
  
CREATE INDEX Patron_Name_ix
  on Patron (First_Name,Last_Name);

  