/* 1.Create a database with two tables: Persons(Id(PK), FirstName,
 LastName, SSN) and Accounts(Id(PK), PersonId(FK), Balance).
Insert few records for testing.
Write a stored procedure that selects the full names of all persons.
*/

CREATE DATABASE Bank;
GO

CREATE TABLE Persons(
[Id] INT IDENTITY PRIMARY KEY,
[FirstName] NVARCHAR(50),
[LastName] NVARCHAR(50),
[SSN] CHAR(10) UNIQUE
)
GO

CREATE TABLE Accounts(
[Id] INT IDENTITY PRIMARY KEY,
[PersonId] INT,
[Balance] MONEY

CONSTRAINT FK_Accounts_Persons
FOREIGN KEY(PersonId)
REFERENCES Persons(Id)
)
GO

INSERT INTO Persons(FirstName,LastName,SSN) VALUES
('Gosho', 'Goshov','0123456789'),
('Pesho', 'Peshov','1123456789'),
('Tosho', 'Toshov','2123456789'),
('Dushka', 'Dushkova','3123456789')

GO

INSERT INTO Accounts(PersonId,Balance) VALUES
('1',432),
('2',3432),
('3',4324),
('4',4432)
GO

CREATE PROC dbo.usp_SelectFullNames
AS 
SELECT FirstName+' '+LastName AS [Full name]
FROM Persons
GO

/* 2.Create a stored procedure that accepts a number as a parameter and
 returns all persons who have more money in their accounts than the supplied number.*/

 CREATE PROC dbo.usp_SelectPeopleWealthierThan(@amount int)
 AS
 SELECT P.FirstName+' '+P.LastName, A.Balance
 FROM Persons P, Accounts A
 WHERE P.Id = A.PersonId AND A.Balance > @amount
 GO

 /* 3.Create a function that accepts as parameters – sum, yearly interest rate and number of months.
It should calculate and return the new sum.
Write a SELECT to test whether the function works as expected.*/

 CREATE FUNCTION dbo.ufn_CalculateInterest(@amount int, @interest decimal, @months int)
	RETURNS money
AS
	BEGIN
		RETURN @amount * (1 + (@amount*@interest) / (100*12) )
	END

GO

SELECT Balance, ROUND(dbo.ufn_CalculateInterest(Balance,2.2 , 12), 2) as [Plus interest]
FROM Accounts
GO
/* 4.Create a stored procedure that uses the function from the previous example
 to give an interest to a person's account for one month.
It should take the AccountId and the interest rate as parameters.*/

CREATE PROC usp_GiveInterestToPersonForOneMonth(@accountID int, @interest decimal)
AS
DECLARE @currentBalance money;
SET @currentBalance =(SELECT Balance 
FROM Accounts
 WHERE Id = @accountId )

DECLARE @newBalance money SELECT dbo.ufn_CalculateInterest(@currentBalance,@interest, 1)

UPDATE Accounts
SET Balance = @newBalance
WHERE Id = @accountId
GO

/* 5.Add two more stored procedures WithdrawMoney(AccountId, money) 
and DepositMoney(AccountId, money) that operate in transactions. */

CREATE PROC usp_WithdrawMoney(@accountID int, @money decimal)
AS
DECLARE @currentBalance money;
SET @currentBalance =(SELECT Balance 
FROM Accounts
 WHERE Id = @accountId )

 DECLARE @newBalance money = @currentBalance - @money

 UPDATE Accounts
SET Balance = @newBalance
WHERE Id = @accountId
GO

CREATE PROC usp_Deposit(@accountID int, @money decimal)
AS
DECLARE @currentBalance money;
SET @currentBalance =(SELECT Balance 
FROM Accounts
 WHERE Id = @accountId )

 DECLARE @newBalance money = @currentBalance + @money

 UPDATE Accounts
SET Balance = @newBalance
WHERE Id = @accountId
GO

/* 6.Create another table – Logs(LogID, AccountID, OldSum, NewSum).
Add a trigger to the Accounts table that enters a new entry into the
 Logs table every time the sum on an account changes. */

CREATE TABLE Logs(
LogID int IDENTITY PRIMARY KEY,
AccountID INT,
OldSum MONEY,
NewSum MONEY

CONSTRAINT FK_Accounts_Persons
FOREIGN KEY(AccountID)
REFERENCES Accounts(Id)
)
GO

CREATE TRIGGER trg_Accounts_Update ON dbo.Accounts AFTER UPDATE
AS
INSERT INTO dbo.Logs(AccountID,OldSum,NewSum)
SELECT I.Id, D.Balance, I.Balance
FROM inserted I, deleted D
WHERE I.ID = D.Id
GO

/* 7. Define a function in the database TelerikAcademy that returns all Employee's
names (first or middle or last name) and all town's names that are comprised of given set of letters.
Example: 'oistmiahf' will return 'Sofia', 'Smith', … but not 'Rob' and 'Guy'. */

CREATE FUNCTION ufn_SearchForWordsInGivenPattern(@pattern nvarchar(255))
RETURNS @MatchedNames TABLE (Name varchar(50))
AS
BEGIN
INSERT @MatchedNames
SELECT *
FROM ( SELECT e.FirstName FROM TelerikAcademy.dbo.Employees e UNION
 SELECT e.LastName FROM TelerikAcademy.dbo.Employees e UNION
 SELECT t.Name FROM TelerikAcademy.dbo.Towns t) as temp(name)
        WHERE PATINDEX('%[' + @pattern + ']', Name) > 0
		RETURN       
END
GO

/* 8.Using database cursor write a T-SQL script that scans all 
employees and their addresses and prints all pairs of employees that live in the same town. */

DECLARE empCursor CURSOR READ_ONLY FOR
    SELECT emp1.FirstName, emp1.LastName, t1.Name, emp2.FirstName, emp2.LastName
    FROM TelerikAcademy.dbo.Employees emp1
    JOIN TelerikAcademy.dbo.Addresses a1
        ON emp1.AddressID = a1.AddressID
    JOIN TelerikAcademy.dbo.Towns t1
        ON a1.TownID = t1.TownID,
        TelerikAcademy.dbo.Employees emp2
    JOIN TelerikAcademy.dbo.Addresses a2
        ON emp2.AddressID = a2.AddressID
    JOIN TelerikAcademy.dbo.Towns t2
        ON a2.TownID = t2.TownID
    WHERE t1.TownID = t2.TownID AND emp1.EmployeeID != emp2.EmployeeID
    ORDER BY emp1.FirstName, emp2.FirstName

OPEN empCursor

DECLARE @firstName1 nvarchar(50), 
        @lastName1 nvarchar(50),
        @townName nvarchar(50),
        @firstName2 nvarchar(50),
        @lastName2 nvarchar(50)
FETCH NEXT FROM empCursor INTO @firstName1, @lastName1, @townName, @firstName2, @lastName2

DECLARE @counter int;
SET @counter = 0;

WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @counter = @counter + 1;

		PRINT @firstName1 + ' ' + @lastName1 + 
			  '     ' + @townName + '       ' +
			  @firstName2 + ' ' + @lastName2;

		FETCH NEXT FROM empCursor 
		INTO @firstName1, @lastName1, @townName, @firstName2, @lastName2
	END

print 'Total records: ' + CAST(@counter AS nvarchar(10));

CLOSE empCursor
DEALLOCATE empCursor

/* 9.*Write a T-SQL script that shows for each town a list of all employees that live in it. */

IF NOT EXISTS (
    SELECT value
    FROM sys.configurations
    WHERE name = 'clr enabled' AND value = 1
)
BEGIN
    EXEC sp_configure @configname = clr_enabled, @configvalue = 1
    RECONFIGURE
END
GO

-- Remove the aggregate and assembly if they're there
IF (OBJECT_ID('dbo.concat') IS NOT NULL) 
    DROP Aggregate concat; 
GO 

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'concat_assembly') 
    DROP assembly concat_assembly; 
GO      

CREATE Assembly concat_assembly 
   AUTHORIZATION dbo 
   FROM 'C:\SqlStringConcatenation.dll' --- CHANGE THE LOCATION
   WITH PERMISSION_SET = SAFE; 
GO 

CREATE AGGREGATE dbo.concat ( 
    @Value NVARCHAR(MAX),
    @Delimiter NVARCHAR(4000) 
) 
    RETURNS NVARCHAR(MAX) 
    EXTERNAL Name concat_assembly.concat; 
GO 

--- CURSOR
DECLARE empCursor CURSOR READ_ONLY FOR
    SELECT t.Name, dbo.concat(e.FirstName + ' ' + e.LastName, ', ')
    FROM Towns t
    JOIN Addresses a
        ON t.TownID = a.TownID
    JOIN Employees e
        ON a.AddressID = e.AddressID
    GROUP BY t.Name
    ORDER BY t.Name

OPEN empCursor

DECLARE @townName nvarchar(50), 
        @employeesNames nvarchar(max)        
FETCH NEXT FROM empCursor INTO @townName, @employeesNames

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @townName + ' -> ' + @employeesNames;

    FETCH NEXT FROM empCursor 
    INTO @townName, @employeesNames
END

CLOSE empCursor
DEALLOCATE empCursor
GO

DROP Aggregate concat; 
DROP assembly concat_assembly; 
GO

/* 10. Define a .NET aggregate function StrConcat that takes as input a sequence of 
strings and return a single string that consists of the input strings separated by ','.
For example the following SQL statement should return a single string: */

IF NOT EXISTS (
    SELECT value
    FROM sys.configurations
    WHERE name = 'clr enabled' AND value = 1
)
BEGIN
    EXEC sp_configure @configname = clr_enabled, @configvalue = 1
    RECONFIGURE
END
GO

-- Remove the aggregate and assembly if they're there
IF (OBJECT_ID('dbo.concat') IS NOT NULL) 
    DROP Aggregate concat; 
GO 

IF EXISTS (SELECT * FROM sys.assemblies WHERE name = 'concat_assembly') 
    DROP assembly concat_assembly; 
GO      

CREATE Assembly concat_assembly 
   AUTHORIZATION dbo 
   FROM 'C:\SqlStringConcatenation.dll' --- CHANGE THE LOCATION
   WITH PERMISSION_SET = SAFE; 
GO 

CREATE AGGREGATE dbo.concat ( 
    @Value NVARCHAR(MAX),
    @Delimiter NVARCHAR(4000) 
) 
    RETURNS NVARCHAR(MAX) 
    EXTERNAL Name concat_assembly.concat; 
GO 

SELECT dbo.concat(FirstName + ' ' + LastName, ', ')
FROM Employees
GO

DROP Aggregate concat; 
DROP assembly concat_assembly; 
GO
