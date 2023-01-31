--Assignemnt 3 

-- Part 1: commit and rollback :Rithu Anand Krishnan RA38893
COMMIT;

ROLLBACK;

-- Part 2: Drop section :Rithu Anand Krishnan RA38893

-- Drop tables  :Rithu Anand Krishnan RA38893

DROP TABLE "RIDER" CASCADE CONSTRAINTS;

DROP TABLE "DRIVER" CASCADE CONSTRAINTS;

DROP TABLE "VEHICLE" CASCADE CONSTRAINTS;

DROP TABLE "BANK" CASCADE CONSTRAINTS;

DROP TABLE "RIDER_PAYMENT" CASCADE CONSTRAINTS;

DROP TABLE "DISCOUNTS" CASCADE CONSTRAINTS;

DROP TABLE "VEHICLE_DRIVER_LINK" CASCADE CONSTRAINTS;

DROP TABLE "RIDE" CASCADE CONSTRAINTS;

-- Drop Sequence  :Rithu Anand Krishnan RA38893

DROP SEQUENCE rider_id_seq;

DROP SEQUENCE driver_id_seq;

DROP SEQUENCE vehicle_id_seq;

DROP SEQUENCE bank_acc_id_seq;

DROP SEQUENCE payment_id_seq;

DROP SEQUENCE discount_id_seq;

DROP SEQUENCE ride_id_seq;



-- Part 3: Create seciton :Rithu Anand Krishnan RA38893

-- Create sequence   :Rithu Anand Krishnan RA38893

CREATE SEQUENCE rider_id_seq
START WITH 3000001
INCREMENT BY 1;

CREATE SEQUENCE driver_id_seq
START WITH 100001
INCREMENT BY 1;

CREATE SEQUENCE vehicle_id_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE bank_acc_id_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE payment_id_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE discount_id_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE ride_id_seq
START WITH 1
INCREMENT BY 1;

-- Create tables   :Rithu Anand Krishnan RA38893

-- Rider Table
CREATE TABLE Rider
(
    rider_id       number(12)   DEFAULT    rider_id_seq.NEXTVAL  PRIMARY KEY,
    first_name     varchar(20)  NOT NULL,
    last_name      varchar(20)  NOT NULL,
    email          varchar(40)  NOT NULL   UNIQUE,
    phone          char(12)     NOT NULL,
    address        varchar(100) NOT NULL,
    city           varchar(30)  NOT NULL,
    zip            char(5)      NOT NULL,
    CONSTRAINT rider_email_length_check CHECK (Length(email) >=7)
);

-- Driver Table
CREATE TABLE Driver
(
    driver_id       number(12)   DEFAULT   driver_id_seq.NEXTVAL  PRIMARY KEY,
    first_name      varchar(20)  NOT NULL,
    last_name       varchar(20)  NOT NULL,
    email           varchar(40)  NOT NULL  UNIQUE,
    phone           char(12)     NOT NULL,
    address         varchar(100) NOT NULL,
    state           char(2),
    city            varchar(30)  NOT NULL,
    zip             char(5)      NOT NULL,
    dob             date         NOT NULL,
    license_number  varchar(12)  NOT NULL  UNIQUE,
    CONSTRAINT driver_email_length_check CHECK (Length(email) >=7)
);

CREATE TABLE Vehicle
(
    vehicle_id                number(12)    DEFAULT     vehicle_id_seq.NEXTVAL  PRIMARY KEY,
    year                      date          DEFAULT     trunc(sysdate, 'YYYY'),
    make                      varchar(20)   NOT NULL,
    model                     varchar(20)   NOT NULL,
    color                     varchar(10)   NOT NULL,
    vin                       char(17)      NOT NULL    UNIQUE,
    plate_number              varchar(12)   NOT NULL    UNIQUE,
    insurance_company         varchar(12)   NOT NULL,
    insurance_policy_number   number(17)    NOT NULL,
    inspection_exp_date       date          NOT NULL
);


-- Bank Table
CREATE TABLE Bank
(
    bank_acc_id         number(12)  DEFAULT     bank_acc_id_seq.NEXTVAL  PRIMARY KEY,
    driver_id           number(12)  UNIQUE      REFERENCES Driver(driver_id),
    routing_number      char(9)     NOT NULL,
    account_number      number(17)  NOT NULL
);

-- Rider Payment Table
CREATE TABLE rider_payment
(
    payment_id          number(12)      DEFAULT     payment_id_seq.NEXTVAL  PRIMARY KEY,
    rider_id            number(12)      REFERENCES Rider(rider_id),
    first_name          varchar(30)     NOT NULL,
    middle_name         varchar(30)     NULL,
    last_name           varchar(40)     NOT NULL,
    card_type           char(4)         NOT NULL,
    card_number         number(16)      NOT NULL,
    expiration_date     date            NOT NULL,
    cc_id               char(3)         NOT NULL,
    billing_address     varchar(100)    NOT NULL,
    state               char(2),
    city                varchar(20)     NOT NULL,
    zip                 char(5)         NOT NULL,
    primary_card_flag   char(1)         CHECK (primary_card_flag IN ('N','Y'))
);


-- Discounts Table
CREATE TABLE discounts
(
    discount_id         number(12)      DEFAULT     discount_id_seq.NEXTVAL  PRIMARY KEY,
    rider_id            number(12)      REFERENCES Rider(rider_id),
    discount_type       varchar(12)     NOT NULL,
    discount_percent    number(3)       NOT NULL,
    used_flag           char(1)         DEFAULT 'N' CHECK (used_flag IN ('N','Y')),
    expiration_date     date            DEFAULT (SYSDATE +30)
);


-- Vehicle and Driver link Table
CREATE TABLE vehicle_driver_link
(
    driver_id               number(20)      REFERENCES Driver(driver_id),
    vehicle_id              number(20)      REFERENCES Vehicle(vehicle_id),
    active_vehicle_flag     char(1)         CHECK(active_vehicle_flag IN ('Y','N')),
    CONSTRAINT vehicle_driver_pk            PRIMARY KEY (driver_id, vehicle_id)
);


-- Ride Table
CREATE TABLE ride
(
    ride_id             number(12)      DEFAULT     ride_id_seq.NEXTVAL  PRIMARY KEY,
    driver_id           number(12)      REFERENCES Driver(driver_id),
    rider_id            number(12)      REFERENCES Rider(rider_id),
    vehicle_id          number(12)      REFERENCES Vehicle(vehicle_id),
    pickup_address      varchar(30)     NOT NULL,
    drop_address        varchar(30)     NOT NULL,
    request_time        date            DEFAULT     TO_DATE (SYSDATE, 'DD-MM-YYYY'),
    start_time          date            NULL,
    end_time            date            NULL,
    initial_fare        number(6)       NULL,
    rating              number(1)       NOT NULL,
    discount_amount     number(6)       NULL,
    final_fare          number(6)       NULL,
    check (final_fare = (initial_fare - discount_amount))
);


-- Create index   :Rithu Anand Krishnan RA38893

-- Index for non-FK values
CREATE INDEX driver_name_ix
  on Driver (first_name,last_name);
  
CREATE INDEX rider_name_ix
  on Rider (first_name,last_name);
  
CREATE INDEX driver_phone_ix
  on Driver (phone);
  
CREATE INDEX rider_phone_ix
  on Rider (phone);
 
CREATE INDEX acc_num_ix
  on Bank (account_number);  
  
CREATE INDEX card_number_ix
  on rider_payment (card_number);




-- Index for all FK values
  
CREATE INDEX vehicle_driver_id_ix
  ON vehicle_driver_link (driver_id);
  
CREATE INDEX ride_driver_id_ix
  ON Ride (driver_id);

CREATE INDEX rider_id_ix
  ON rider_payment (rider_id);
  
CREATE INDEX ride_rider_id_ix
  ON ride (rider_id);
  
CREATE INDEX discount_rider_id_ix
  ON discounts (rider_id);
  
CREATE INDEX vehicle_id_ix
  ON vehicle_driver_link (vehicle_id);  

CREATE INDEX ride_vehicle_id_ix
  ON ride (vehicle_id);  
  
  
  
  


-- Part 4: Insert seciton :Rithu Anand Krishnan RA38893

-- Insert into Rider
INSERT INTO Rider
VALUES (rider_id_seq.NEXTVAL,'Rithu','Anand Krishnan','ra38893@utexas.edu','7374205116','101 E 33rd street','austin',78705);

INSERT INTO Rider
VALUES (rider_id_seq.NEXTVAL,'Anand','Krishnan M','ak@utexas.edu','7374205117','102 E 37rd street','austin',78707);

INSERT INTO Rider
VALUES (rider_id_seq.NEXTVAL,'Sujatha','TN','suji@utexas.edu','7304205116','1001 E st street','austin',78775);



-- Insert into Driver
INSERT INTO Driver
VALUES (driver_id_seq.NEXTVAL,'Deeksha','Krishnan','deek@utexas.edu','7008905116','1 E 33rd street','KA','Bangalore',56705,'25-APR-01', 'AGE64722892');

INSERT INTO Driver
VALUES (driver_id_seq.NEXTVAL,'Adhi','Viraj','advij@utexas.edu','8904205000','401 W 11th street','IL','Fort Wayne',34778, '30-MAR-02', 'GHE647223JI2');

INSERT INTO Driver
VALUES (driver_id_seq.NEXTVAL,'MAdhu','GB','grama@utexas.edu','4504905781','1004 W st street','WA','Chicago',48767, '02-MAY-05', 'KQS367722I89');



-- Insert into Bank
INSERT INTO Bank
VALUES (bank_acc_id_seq.NEXTVAL,100001,'8792746','9264204786');

INSERT INTO Bank
VALUES (bank_acc_id_seq.NEXTVAL,100002,'4792216','1328400300');

INSERT INTO Bank
VALUES (bank_acc_id_seq.NEXTVAL,100003,'1002789','7260200022');



-- Insert into Vehicle
INSERT INTO Vehicle
VALUES (vehicle_id_seq.NEXTVAL,'12-DEC-1995','Make1','Model1','Black','HJKA3456OLK','JKF450','Life Ins',890002,'09-AUG-26');

INSERT INTO Vehicle
VALUES (vehicle_id_seq.NEXTVAL,'02-MAR-1978','Make2','Model2','Blue','NKKA8450OQQ','PAL809','UHS',945019,'18-JUN-24');

INSERT INTO Vehicle
VALUES (vehicle_id_seq.NEXTVAL,'08-FEB-2005','Make3','Model3','White','PORU093465L','WRI777','MyIns',342560,'24-NOV-23');



-- Insert into Vehicle Driver Link
INSERT INTO vehicle_driver_link
VALUES (100001,1,'Y');

INSERT INTO vehicle_driver_link
VALUES (100002,2,'N');

INSERT INTO vehicle_driver_link
VALUES (100003,3,'Y');



-- Insert into Ride
INSERT INTO ride
VALUES (ride_id_seq.NEXTVAL, 100001, 3000001, 2,'220 N 45th St Austin TX 78678', '109 W 5th St Austin TX 78098', SYSDATE, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' MINUTE , 15, 4, 2, 13);

INSERT INTO ride
VALUES (ride_id_seq.NEXTVAL, 100002, 3000002, 1,'10 N 9th St Austin TX 78907', '14th E 59th St Austin TX 78000', '02-MAY-05', SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '1' HOUR, 20, 5, 1, 19);

INSERT INTO ride
VALUES (ride_id_seq.NEXTVAL, 100003, 3000003, 3,'208 E VIP App Austin TX 78937', '316th S Austin TX 78609', DEFAULT, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '45' MINUTE , 26, 5, 3, 23);


-- Insert into Discount
INSERT INTO discounts
VALUES (discount_id_seq.NEXTVAL, 3000002, 'PROMO', 10, 'Y', DEFAULT);


-- To test if insert was done properly  
-- SELECT * FROM discounts;
    





