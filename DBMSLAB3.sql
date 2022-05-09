-- ACTOR TABLE

CREATE TABLE ACTOR(
ACTID INTEGER,
ACTNAME VARCHAR(50),
ACTGENDER VARCHAR(6),
PRIMARY KEY (ACTID));

-- DIRECTOR TABLE

CREATE TABLE DIRECTOR(
DIRID INTEGER,
DIRNAME VARCHAR(50),
DIRPHONE INTEGER,
PRIMARY KEY (DIRID));

-- MOVIES TABLE

CREATE TABLE MOVIES(
MOVID INTEGER,
MOVTITLE VARCHAR(25),
MOVYEAR VARCHAR(4),
MOVLANG VARCHAR(20),
DIRID INTEGER,
PRIMARY KEY (MOVID),
FOREIGN KEY (DIRID) REFERENCES DIRECTOR(DIRID));

-- MOVIE CAST

CREATE TABLE MOVIECAST(
ACTID INTEGER,
MOVID INTEGER,
ROLE VARCHAR(20),
PRIMARY KEY (ACTID,MOVID),
FOREIGN KEY (ACTID) REFERENCES ACTOR(ACTID),
FOREIGN KEY (MOVID) REFERENCES MOVIES(MOVID));

-- MOVIE RATING

CREATE TABLE RATING(
MOVID INTEGER,
REVSTARS VARCHAR(25),
PRIMARY KEY(MOVID),
FOREIGN KEY (MOVID) REFERENCES MOVIES(MOVID));


-- INSERT INTO ACTOR

INSERT INTO ACTOR VALUES(001,'ROBERT DOWNEY JR','MALE');
INSERT INTO ACTOR VALUES(002,'DANIEL RADCLIFFE','MALE');
INSERT INTO ACTOR VALUES(003,'ANGELINA JOULIE','FEMALE');
INSERT INTO ACTOR VALUES(004,'EMMA WATSON','FEMALE');

SELECT * FROM ACTOR;

-- INSERT INTO DIRECTOR

INSERT INTO DIRECTOR VALUES(01,'CHRISTOPHER NOLAN',1234567890);
INSERT INTO DIRECTOR VALUES(02,'HITCHCOCK',1122334455);
INSERT INTO DIRECTOR VALUES(03,'GEORGE LUCAS',1112345690);
INSERT INTO DIRECTOR VALUES(04,'STEVEN SPIELBERG',1111123456);

SELECT * FROM DIRECTOR;

-- INSERT INTO MOVIES

INSERT INTO MOVIES VALUES(1001,'INTERSTELLAR',2017,'ENGLISH',01);
INSERT INTO MOVIES VALUES(1002,'HARRY POTTER',2015,'ENGLISH',02);
INSERT INTO MOVIES VALUES(1003,'IRON MAN',2008,'ENGLISH',03);
INSERT INTO MOVIES VALUES(1004,'SPIDER MAN',2011,'ENGLISH',04);

SELECT * FROM MOVIES;

-- INSERT INTO MOVIECAST

INSERT INTO MOVIECAST VALUES(001,1002,'HERO');
INSERT INTO MOVIECAST VALUES(001,1001,'HERO');
INSERT INTO MOVIECAST VALUES(003,1003,'HEROINE');
INSERT INTO MOVIECAST VALUES(003,1002,'GUEST');
INSERT INTO MOVIECAST VALUES(004,1004,'HEROINE');

SELECT * FROM MOVIECAST;

-- INSERT INTO RATING

INSERT INTO RATING VALUES(1001,4);
INSERT INTO RATING VALUES(1002,2);
INSERT INTO RATING VALUES(1003,5);
INSERT INTO RATING VALUES(1004,4);

SELECT * FROM RATING;

--QUERIES

-- QUERY 1

SELECT MOVTITLE
FROM MOVIES
WHERE DIRID IN (SELECT DIRID
FROM DIRECTOR
WHERE DIRNAME='HITCHCOCK');

-- QUERY 2

SELECT MOVTITLE
FROM MOVIES M,MOVIECAST MV
WHERE M.MOVID=MV.MOVID AND ACTID IN (SELECT ACTID
FROM MOVIECAST GROUP BY ACTID
HAVING COUNT(ACTID)>1)
GROUP BY MOVTITLE
HAVING COUNT(*)>1;

-- QUERY 3

SELECT ACTNAME,MOVTITLE,MOVYEAR
FROM ACTOR A
JOIN MOVIECAST C
ON A.ACTID=C.ACTID
JOIN MOVIES M
ON C.MOVID=M.MOVID
WHERE M.MOVYEAR NOT BETWEEN 2000 AND 2015;

--(OR)

SELECT A.ACTNAME,C.MOVTITLE,C.MOVYEAR
FROM ACTOR A,MOVIECAST B,MOVIES C
WHERE A.ACTID=B.ACTID
AND B.MOVID=C.MOVID
AND C.MOVYEAR NOT BETWEEN 2000 AND 2005;

-- QUERY 4

SELECT MOVTITLE,MAX(REVSTARS)
FROM MOVIES
INNER JOIN RATING USING (MOVID)
GROUP BY MOVTITLE
HAVING MAX(REVSTARS)>0
ORDER BY MOVTITLE;

-- QUERY 5

UPDATE RATING
SET REVSTARS=5
WHERE MOVID IN (SELECT MOVID FROM MOVIES
WHERE DIRID IN (SELECT DIRID
FROM DIRECTOR
WHERE DIRNAME='STEVEN SPIELBERG'));

SELECT * FROM RATING;
