CREATE TABLE DEPARTMENT
(DNO VARCHAR(20) PRIMARY KEY,
DNAME VARCHAR(20),
MGRSSN VARCHAR(20),
MGRSTARTDATE DATE);


CREATE TABLE EMPLOYEE
(SSN VARCHAR(20) PRIMARY KEY,
NAME VARCHAR(20),
ADDRESS VARCHAR(20),
GENDER CHAR(1),
SALARY INTEGER,
SUPERSSN VARCHAR(20),
DNO VARCHAR(20),
FOREIGN KEY (SUPERSSN) REFERENCES EMPLOYEE (SSN),
FOREIGN KEY (DNO) REFERENCES DEPARTMENT (DNO));

ALTER TABLE DEPARTMENT ADD MGRSSN REFERENCES EMPLOYEE(SSN);

CREATE TABLE DLOCATION
(DLOC VARCHAR(20),
DNO VARCHAR(20),
FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO),
PRIMARY KEY (DNO, DLOC));

CREATE TABLE PROJECT
(PNO INTEGER PRIMARY KEY,
PNAME VARCHAR(20),
PLOCATION VARCHAR(20),
DNO VARCHAR(20),
FOREIGN KEY (DNO) REFERENCES DEPARTMENT(DNO));


CREATE TABLE WORKS_ON
(HOURS INTEGER,
SSN VARCHAR(20),
PNO INTEGER,
FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN),
FOREIGN KEY (PNO) REFERENCES PROJECT(PNO),
PRIMARY KEY (SSN, PNO));


-- EMPLOYEE TABLE INSERT

INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN001','BEN SCOTT','USA','M', 450000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN002','ADINATH NIKAM','USA','M', 550000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN003','AYAZ PACHAPURE','UK','M', 350000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN004','ASHITOSH GOLBANVI','CHINA','M', 400000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN005','DARSHAN PATIL','USA','M', 700000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN006','RUPESH','USA','M', 800000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN007','ADAM EVE','USA','M', 750000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN008','DAVID UNCLE','USA','M', 650000);
INSERT INTO EMPLOYEE (SSN, NAME, ADDRESS, GENDER, SALARY) VALUES ('SSN009','PETER PARKER','USA','M', 900000);

-- DEPARTMENT TABLE INSERT

INSERT INTO DEPARTMENT VALUES ('1','ACCOUNTS','SSN003', '2022-01-03');
INSERT INTO DEPARTMENT VALUES ('2','IT','SSN002', '2022-02-04');
INSERT INTO DEPARTMENT VALUES ('3','HR','SSN001', '2022-04-05');
INSERT INTO DEPARTMENT VALUES ('4','HELPDESK', 'SSN004', '2022-06-03');
INSERT INTO DEPARTMENT VALUES ('5','SALES','SSN002', '2022-01-08');


-- UPDATE EMPLOYEE TABLE

UPDATE EMPLOYEE SET
SUPERSSN=NULL, DNO='3'
WHERE SSN='SSN001';


UPDATE EMPLOYEE SET
SUPERSSN=NULL, DNO='2'
WHERE SSN='SSN002';

UPDATE EMPLOYEE SET
SUPERSSN='SSN003', DNO='1'
WHERE SSN='SSN003';

UPDATE EMPLOYEE SET
SUPERSSN=NULL, DNO='1'
WHERE SSN='SSN004';

UPDATE EMPLOYEE SET
SUPERSSN='SSN001', DNO='5'
WHERE SSN='SSN002';


UPDATE EMPLOYEE SET
SUPERSSN='SSN002', DNO='5'
WHERE SSN='SSN005';


UPDATE EMPLOYEE SET
SUPERSSN='SSN002', DNO='5'
WHERE SSN='SSN006';

UPDATE EMPLOYEE SET
SUPERSSN='SSN002', DNO='5'
WHERE SSN='SSN007';

UPDATE EMPLOYEE SET
SUPERSSN='SSN002', DNO='5'
WHERE SSN='SSN008';

UPDATE EMPLOYEE SET
SUPERSSN='SSN002', DNO='5'
WHERE SSN='SSN009';

-- DLOCATION TABLE INSERT

INSERT INTO DLOCATION VALUES ('UK', '1');
INSERT INTO DLOCATION VALUES ('USA', '2');
INSERT INTO DLOCATION VALUES ('USA', '3');
INSERT INTO DLOCATION VALUES ('CHINA', '4');

-- PROJECT TABKE INSERT

INSERT INTO PROJECT VALUES (1000,'IOT','USA','2');
INSERT INTO PROJECT VALUES (1001,'CLOUD','USA','2');
INSERT INTO PROJECT VALUES (1002,'BIGDATA','USA','2');
INSERT INTO PROJECT VALUES (1003,'SENSORS','USA','3');
INSERT INTO PROJECT VALUES (1004,'BANK MANAGEMENT','UK','1');
INSERT INTO PROJECT VALUES (1006,'OPENSTACK','CHINA','4');

-- WORKSON TABLE INSERT

INSERT INTO WORKS_ON VALUES (6, 'SSN001', 1000);
INSERT INTO WORKS_ON VALUES (5, 'SSN001', 1002);
INSERT INTO WORKS_ON VALUES (4, 'SSN002', 1000);
INSERT INTO WORKS_ON VALUES (6, 'SSN002', 1001);
INSERT INTO WORKS_ON VALUES (8, 'SSN002', 1002);
INSERT INTO WORKS_ON VALUES (10,'SSN003', 1004);
INSERT INTO WORKS_ON VALUES (3, 'SSN004', 1006);

--  QUERIES

--1

SELECT DISTINCT P.PNO
FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
WHERE E.DNO=D.DNO
AND D.MGRSSN=E.SSN
AND E.NAME LIKE '%SCOTT'
UNION
SELECT DISTINCT P1.PNO
FROM PROJECT P1, WORKS_ON W, EMPLOYEE E1
WHERE P1.PNO=W.PNO
AND E1.SSN=W.SSN
AND E1.NAME LIKE '%SCOTT';

--2

SELECT E.NAME, 1.1*E.SALARY AS INCR_SAL
FROM EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE E.SSN=W.SSN
AND W.PNO=P.PNO
AND P.PNAME='IOT';

--3

SELECT SUM(E.SALARY), MAX(E.SALARY), MIN(E.SALARY), AVG(E.SALARY)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DNO=D.DNO
AND D.DNAME='ACCOUNTS';

--4

SELECT E.NAME
FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT PNO FROM PROJECT WHERE DNO='5' AND PNO NOT IN (SELECT
PNO FROM WORKS_ON
WHERE E.SSN=SSN));

--5

SELECT D.DNO, COUNT(*)
FROM DEPARTMENT D, EMPLOYEE E
WHERE D.DNO=E.DNO
AND E.SALARY > 600000
AND D.DNO IN (SELECT E1.DNO
FROM EMPLOYEE E1
GROUP BY E1.DNO
HAVING COUNT(*)>5)
GROUP BY D.DNO;
