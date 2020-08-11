
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
		dateOfBirth varchar(11),
		party varchar(3) NOT NULL FOREIGN KEY REFERENCES Party(abbreviation) ,
		candidacyID int NOT NULL FOREIGN KEY REFERENCES Candidacy(candidacyId),
		CHECK((DATEDIFF(dayofyear,   '1992-04-12 ', GETDATE())>=21 AND id like '(c|C).*[0-9]$' )
		))

		

INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('JPP', 'Justice Progress Party', 1957) 
INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('OPP', 'ONE PEOPLE PARTY', 1954) 
INSERT into PARTY (abbreviation, name, yearFormed) VALUES ('TWP', 'TOGETHER WE PARTY', 2020) 

INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('A1', 2, 81232, 549) 
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('A2', 1, 31294, 491)
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('B1', 1, 29192, 325)
INSERT INTO DIVISION (divisionId, seat, voters, rejected) VALUES ('C1', 3, 129821, 738)
SET IDENTITY_INSERT Candidacy ON
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (1, (SELECT divisionId from Division WHERE voters=81232), 52551, 65)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (2, (SELECT divisionId from Division WHERE voters= 81232 ), 27112, 35)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (3, (SELECT divisionId from Division WHERE voters= 31294 ), 12541, 40)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (4, (SELECT divisionId from Division WHERE voters= 29192 ), 18252, 60)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (5, (SELECT divisionId from Division WHERE voters= 29192 ), 14002, 49)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (6, (SELECT divisionId from Division WHERE voters= 29192 ), 4324 , 14)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (7, (SELECT divisionId from Division WHERE voters= 129821 ), 9324 , 37)
INSERT INTO Candidacy( candidacyId, divisionId, votesObtained, sampleVotesPer100) VALUES (8, (SELECT divisionId from Division WHERE voters= 129821 ), 59482, 45)


