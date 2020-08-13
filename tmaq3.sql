
IF EXISTS(SELECT * from dbo.party) DROP TABLE dbo.party;
IF EXISTS(SELECT * from dbo.division)DROP TABLE dbo.division;

DROP TABLE dbo.Candidate;
DROP TABLE dbo.Candidacy;
DROP Table dbo.Division;
DROP TABLE dbo.party;

create table Party (
		abbreviation varchar(3) NOT NULL CONSTRAINT abbreviation PRIMARY KEY, 
		name varchar(25) NOT NULL, 
		yearFormed int NOT NULL,
		CHECK (yearFormed >=1954 AND yearFormed<=CONVERT(int, YEAR(GETDATE())))
		)
		

create table Division (
		divisionId varchar(2) NOT NULL  PRIMARY KEY,
		seat smallint NOT NULL,
		voters bigint NOT NULL,
		rejected int NOT NULL,
		check(seat>=1 AND seat<=6 and voters>=10000 and rejected >0)
		)

create table Candidacy  (
		candidacyId int NOT NULL IDENTITY (1,1) PRIMARY KEY,
		divisionId varchar(2)  NOT NULL FOREIGN KEY REFERENCES  Division(divisionId),
		votesObtained int NOT NULL,
		sampleVotesPer100 int NOT NULL
		)

create table Candidate (
		id varchar(9) NOT NULL PRIMARY KEY,
		name varchar(30),
		dateOfBirth date,
		party varchar(3) NOT NULL FOREIGN KEY REFERENCES Party(abbreviation) ,
		candidacyID int NOT NULL FOREIGN KEY REFERENCES Candidacy(candidacyId),
		CONSTRAINT id
		CHECK(len(id)=9  AND id NOT like '[^a-zA-Z]%'))
		/*CONSTRAINT dateOfBirth CHECK(DATEDIFF(dayofyear,   '1992-04-12 ', GETDATE())>=21)*/
		

		

INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('JPP', 'Justice Progress Party', 1957) 
INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('OPP', 'ONE PEOPLE PARTY', 1954) 
INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('TWP', 'TOGETHER WE PARTY', 2020) 

INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('A1', 2, 81232, 549) 
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('A2', 1, 31294, 491)
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('B1', 1, 29192, 325)
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('C1', 3, 129821,738)
SET IDENTITY_INSERT Candidacy ON
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (1, (SELECT divisionId from Division WHERE voters=81232), 52551, 65)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (2, (SELECT divisionId from Division WHERE voters= 81232 ), 27112, 35)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (3, (SELECT divisionId from Division WHERE voters= 31294 ), 12541, 40)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (4, (SELECT divisionId from Division WHERE voters= 31294 ), 18252, 60)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (5, (SELECT divisionId from Division WHERE voters= 29192 ), 14002, 49)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (6, (SELECT divisionId from Division WHERE voters= 29192 ), 4324 , 14)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (7, (SELECT divisionId from Division WHERE voters= 29192 ), 9324 , 37)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (8, (SELECT divisionId from Division WHERE voters= 129821 ), 59482, 45)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (9, (SELECT divisionId from Division WHERE voters= 129821 ), 69518, 55)
 
delete from candidate

INSERT INTO Candidate( id, name, dateOfBirth, candidacyID, party) VALUES
('A1111111A','Mohamad Faisal', '1990-01-01', 1, 'OPP'),
('A1111112A','Chia Hon Huat', '1999-07-16', 1, 'OPP'),
('A1111113A','Nurul Ahmad', '1955-02-06', 2, 'TWP'),
('A1111114A','Tan Chin Siong', '1960-03-12', 2, 'TWP'),
('A2222221A','Peter Thiagu', '1970-04-17', 3, 'OPP'),
('A2222222A','Ravi Pillay', '1973-05-19', 4, 'JPP'),
('B1111111B','Goh Hong Hui', '1965-08-09', 5, 'OPP'),
('B1111112B','Koh Li Choo', '1969-09-23', 6, 'JPP'),
('B1111113B','Ng Tiong Keng', '1958-10-30', 7, 'TWP'),
('C1111111C','Mohamed Azhar', '1984-11-01', 8, 'OPP'),
('C1111112C','Loganathan', '1997-07-07', 8, 'OPP'),
('C1111113C','Kelvin Ong', '1995-04-17', 8, 'OPP'),
('C1111114C','Vigneswan Menon', '1992-03-26', 9, 'JPP'),
('C1111115C','Lee Wei Zhong', '1994-02-04', 9, 'JPP'),
('C1111117C','Abiram Raj', '1990-01-19', 9, 'JPP')

select dateOfBirth from Candidate order by id;
select * from Candidate Order BY  dateoFBirth


Create Function getAge(@dob date)
returns int
as 
begin 
	declare @age int
	set @age = CONVERT(int, DATEDIFF(hour,@dob,GETDATE())/8766)
	return @age
end

/*Q3b i)*/
SELECT *,dbo.getAge(dateOfBirth)as age from Candidate order by age desc

SELECT candidacyID from Candidate where dbo.getAge(dateOfBirth)<25


/*3b ii)*/

SELECT * from Division 
where divisionId in 
(SELECT divisionId from candidacy 
where candidacyID in 
(SELECT candidacyID 
from Candidate 
where dbo.getAge(dateOfBirth)<25))


/*3b iii)*/

SELECT Division.divisionId,division.seat ,Candidate.party
from Division 
inner join Candidacy 
ON Division.divisionId = Candidacy.divisionId
inner join Candidate 
ON Candidacy.candidacyId = Candidate.candidacyID
AND Candidacy.votesObtained=(SELECT MAX(votesObtained) from Candidacy where Division.divisionId=Candidacy.divisionId)
group by Division.divisionId,division.seat ,Candidate.party, Candidacy.votesObtained



SELECT Division.divisionId,division.seat ,Candidate.party
from Division 
inner join Candidacy 
ON Division.divisionId = Candidacy.divisionId
inner join Candidate 
ON Candidacy.candidacyId = Candidate.candidacyID
AND Candidacy.votesObtained=(SELECT MAX(votesObtained) from Candidacy where Division.divisionId=Candidacy.divisionId)
group by Division.divisionId,division.seat ,Candidate.party, Candidacy.votesObtained 
AND Candidacy.party =

/*q3 iv)*/

SELECT abbreviation, name from party where 

/*q3 c i)*/
CREATE Trigger CheckSeatsLimit on 
after 