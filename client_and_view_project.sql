--Complete Project Script

--Initialize database
CREATE DATABASE Views4U;

--Use database
USE Views4U;

--Add Department table
CREATE TABLE Department(
	Dept_ID TINYINT PRIMARY KEY NOT NULL,
	Dept_Name NVARCHAR(40)
);

--Add Employee table
CREATE TABLE Employee(
	Employee_ID BIGINT PRIMARY KEY NOT NULL,
	FirstName NVARCHAR(255),
	LastName NVARCHAR(255),
	Gender NVARCHAR(255),
	Position NVARCHAR(255) ,
	Dept_ID TINYINT,
	Salary FLOAT,
	Head NVARCHAR(25)
);

--*****FR1: Human Resources*****

--Add Operations Department
INSERT INTO Department VALUES (3, 'Operations');

--First edit table to allow NULLs
ALTER TABLE Employee ALTER COLUMN Dept_ID TINYINT NULL

INSERT INTO Employee
VALUES(2020, 'Ryan', 'Moore', 'M', 'CSO', NULL, 150000)

INSERT INTO Employee
VALUES(2021, 'Bill', 'South', 'M', 'COO', NULL, 150000)

INSERT INTO Employee
VALUES(2022, 'Chuck', 'Hebdin', 'M', 'CITO', NULL, 200000)

--Add new head column to employee table
ALTER TABLE Employee
ADD Head TINYINT NULL;

--Update data for department heads and all other employees
UPDATE Employee
SET 
    Head = 1
WHERE
    Employee_ID = 2020

UPDATE Employee
SET 
    Head = 3
WHERE
    Employee_ID = 2021

UPDATE Employee
SET 
    Head = 2
WHERE
    Employee_ID = 2022;

UPDATE Employee
SET 
    Head = NULL
WHERE
    Employee_ID <> 2020 AND Employee_ID <> 2021 AND Employee_ID <> 2022;


--*****FR2: Data Model*****
--Add Client table
CREATE TABLE Client(
	ClientID INT PRIMARY KEY,
	[Name] NVARCHAR(40),
	TypeID SMALLINT,
	City NVARCHAR(25),
	Region NVARCHAR(6),
	Pricing INT
);

--Insert data into client table
BULK INSERT Client
FROM 'C:\Users\rjmoo\Desktop\PowerBI\client_clean.csv'
WITH(
	FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '\n'
);
GO

--View client table to ensure accuracy
SELECT * FROM Client

--Add View table
CREATE TABLE [View](
	ViewID INT PRIMARY KEY,
	ViewDate DATETIME,
	ID INT,
	Device NVARCHAR(25),
	Browser NVARCHAR(30),
	Host VARCHAR(15)
);

--Insert data into view table
BULK INSERT [View]
FROM 'C:\Users\rjmoo\Desktop\PowerBI\views_clean.csv'
WITH(
	FIRSTROW = 2
	, FIELDTERMINATOR = ','
	, ROWTERMINATOR = '\n'
);
GO

--View view table to ensure accuracy
SELECT * FROM [View];

--Add Pricing table (copy/paste from excel used to fill table)
CREATE TABLE Pricing(
	PlanNo INT PRIMARY KEY,
	PlanName NVARCHAR(25),
	Monthly INT
);
GO

--Add TypeClient table (copy/paste from excel used to fill table)
CREATE TABLE TypeClient(
	TypeName NVARCHAR(50),
	TypeID SMALLINT PRIMARY KEY
);
GO

--Add AgentRegion table (copy/paste from excel used to fill table)
CREATE TABLE AgentRegion(
	Region NVARCHAR(6) PRIMARY KEY,
	EmployeeID BIGINT NOT NULL
);
GO

--View last three table to check for accuracy
SELECT * FROM Pricing;
SELECT * FROM TypeClient;
SELECT * FROM AgentRegion;
GO


--*****FR3: Queries*****
--Q1: Top ten Group 7 with highest views
SELECT TOP 10 COUNT(*) AS [Number of Views]
	, c.ClientID
	, c.[Name]
	, tc.TypeName
FROM TypeClient tc
	INNER JOIN Client c ON c.TypeID = tc.TypeID
	INNER JOIN [View] v ON v.ID = C.ClientID
WHERE TypeName = 'Restaurant Group 7'
GROUP BY c.ClientID, c.[Name], tc.TypeName
ORDER BY [Number of Views] DESC;


--Q2: All clients whose names start OR end with the term �Coffee�, along with their cities, subscription fees, and number of views.
--client and average subscription fees sorted with respect to average views per
--client in descending order.
	, tc.TypeName
	, Avg(t1.[Number of Views]) AS [Average Views Per Client]
	, Avg(p.Monthly) AS [Average Fees]
FROM CLient c JOIN TypeClient tc ON c.TypeID = tc.TypeID	
			  JOIN Pricing p ON c.Pricing = p.PlanNo
			  JOIN (
						SELECT v.ID
						, Count(*) AS [Number of Views]
						FROM [View] v 
						GROUP BY v.ID

					)t1 ON c.ClientID = t1.ID
GROUP BY tc.TypeName
ORDER BY [Average Views Per Client] DESC;
	, AVG(p.Monthly) AS [Average Fees]
	, AVG(t1.[Number of Views]) AS [Average Views]
	, t1.Host
FROM Client c
	INNER JOIN Pricing p ON p.PlanNo = c.Pricing
		INNER JOIN (
						SELECT COUNT(*) AS [Number of Views]
							, v.ID
							, Host FROM [View] v
						GROUP BY v.ID, v.Host) t1 ON t1.ID = c.ClientID
GROUP BY t1.Host
ORDER BY [Average Views] DESC;
--devices, hosted by Yelp from cities where there are more than 100 clients. Also
--add the name of the client for each view.
--their regions, number of their clients, and number of views for those clients in
--columns 2, 3, and 4, respectively.