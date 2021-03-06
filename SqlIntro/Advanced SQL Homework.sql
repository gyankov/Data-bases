USE TelerikAcademy
--1. Write a SQL query to find the names and salaries of the employees that take
-- the minimal salary in the company.
-- Use a nested SELECT statement.
SELECT FirstName + ' ' + LastName AS [FullName], Salary FROM Employees
WHERE Salary = 
	(SELECT MIN(Salary) FROM Employees)

--2. Write a SQL query to find the names and salaries of the employees 
-- that have a salary that is up to 10% higher than the minimal salary for the company.
SELECT FirstName + ' ' + LastName AS [FullName], Salary AS [10% up the min Salary]
FROM Employees
WHERE Salary <
	(SELECT MIN(Salary) * 1.1 FROM Employees)

--3. Write a SQL query to find the full name, salary and department 
-- of the employees that take the minimal salary in their department.
-- Use a nested SELECT statement.
SELECT e.FirstName + ' ' + e.LastName AS [FullName], e.Salary, d.Name AS [Department Name]
FROM Employees e
	JOIN Departments d
ON e.DepartmentID = d.DepartmentID
	WHERE Salary = 
		(SELECT MIN(Salary)
		FROM Employees
		WHERE DepartmentID = e.DepartmentID)

--4. Write a SQL query to find the average salary in the department #1.
SELECT AVG(Salary) AS [Department 1 Average Salary]
FROM Employees
WHERE DepartmentID = '1'

--5. Write a SQL query to find the average salary in the "Sales" department.
SELECT AVG(e.Salary) AS [Sales Dept Avg Salary]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'

--6. Write a SQL query to find the number of employees in the "Sales" department.
SELECT COUNT(*) AS [Sales Employees Count]
FROM Employees e
JOIN Departments d
	ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'

--7. Write a SQL query to find the number of all employees that have manager.
SELECT COUNT(*) AS [Number of Employees with Manager]
FROM Employees
WHERE ManagerID IS NOT NULL

--8. Write a SQL query to find the number of all employees that have no manager.
SELECT COUNT(*) AS [Number of Employees without Manager]
FROM Employees
WHERE ManagerID IS NULL

--9. Write a SQL query to find all departments and the average salary for each of them.
SELECT AVG(Salary) AS [Average Salary], d.Name
FROM Employees e
	JOIN Departments d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY [Average Salary]

--10. Write a SQL query to find the count of all employees in each department and for each town.
SELECT COUNT(e.FirstName) AS [Employee count], d.Name AS [Department Name], t.Name AS [Town Name]
FROM Employees e
  JOIN Departments d
ON e.DepartmentID = d.DepartmentID
  JOIN Addresses a
ON e.AddressID = a.AddressID
  JOIN Towns t
ON a.TownID = t.TownID
GROUP BY t.Name, d.Name

--11. Write a SQL query to find all managers that have exactly 5 employees. 
-- Display their first name and last name.
SELECT m.FirstName, m.LastName 
FROM Employees e, Employees m
WHERE e.ManagerID = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(*) = 5

--12. Write a SQL query to find all employees along with their managers.
-- For employees that do not have manager display the value "(no manager)".
SELECT e.FirstName, e.LastName, ISNULL(m.FirstName + ' ' + m.LastName, ('no manager')) AS [Manager Name]
FROM Employees e
	LEFT OUTER JOIN Employees m
ON e.ManagerID = m.ManagerID

--13. Write a SQL query to find the names of all employees whose last name is exactly 5 characters long.
-- Use the built-in LEN(str) function.
SELECT LastName 
FROM Employees
WHERE LEN(LastName) = 5

--14. Write a SQL query to display the current date and time in 
-- the following format "day.month.year hour:minutes:seconds:milliseconds".
-- Search in Google to find how to format dates in SQL Server.
SELECT FORMAT (GETDATE(), 'dd.MM.yyyy hh:mm:ss:ms') AS [Current Date and Time]

--15. Write a SQL statement to create a table Users. Users should have username, password, full name and last login time.
-- Choose appropriate data types for the table fields. Define a primary key column with a primary key constraint.
-- Define the primary key column as identity to facilitate inserting records.
-- Define unique constraint to avoid repeating usernames.
-- Define a check constraint to ensure the password is at least 5 characters long.
CREATE TABLE Users(
	Id int IDENTITY,
	[Username] nvarchar(50) NOT NULL UNIQUE,
	[Password] nvarchar(30) NOT NULL CHECK(LEN([Password]) > 4),
	[FullName] nvarchar(100),
	[Last Login] date NOT NULL,
	CONSTRAINT PK_Users PRIMARY KEY (Id)
)

--16. Write a SQL statement to create a view that displays the users from the 
-- Users table that have been in the system today.
-- Test if the view works correctly.
SELECT * FROM Users
WHERE [Last Login] = '2016-10-19'


--17. Write a SQL statement to create a table Groups. Groups should have unique name (use unique constraint).
-- Define primary key and identity column.
CREATE TABLE Groups(
	Id int IDENTITY,
	Name nvarchar(50) UNIQUE,
	CONSTRAINT PK_Groups PRIMARY KEY (Id)
)

--18. Write a SQL statement to add a column GroupID to the table Users.
-- Fill some data in this new column and as well in the `Groups table.
-- Write a SQL statement to add a foreign key constraint between tables Users and Groups tables.
ALTER TABLE Users
ADD GroupID int

ALTER TABLE Users
ADD FOREIGN KEY (GroupID)
REFERENCES Groups(Id)

--19. Write SQL statements to insert several records in the Users and Groups tables.
-- NOTE: THIS COMMAND IS ALREDY EXECTURED SO IT WONT WORK
-- USERS
INSERT INTO Users([Username], 
				  [Password], 
				  [FullName], 
				  [Last Login],
				  GroupID)
VALUES ('NqmamIdeq0', 'parola', 'NeznamVeche0', GETDATE(), 1),
	   ('NqmamIdeq1', 'parola', 'NeznamVeche1', GETDATE(), 2),
	   ('NqmamIdeq2', 'parola', 'NeznamVeche2', GETDATE(), 3),
	   ('NqmamIdeq3', 'parola', 'NeznamVeche3', GETDATE(), 1)

-- GROUPS
-- NOTE: THIS COMMAND IS ALREDY EXECTURED SO IT WONT WORK
INSERT INTO Groups ([Name])
VALUES ('Group5'),
	   ('Group6')


--20. Write SQL statements to update some of the records in the Users and Groups tables.
-- USERS
UPDATE Users
SET [Username] = 'Updated1'
WHERE [Username] = 'User 1'

-- GROUPS
UPDATE Groups
SET [Name] = 'Group7'
WHERE [Name] = 'Group5'

--21. Write SQL statements to delete some of the records from the Users and Groups tables.
-- USERS
DELETE FROM Users
WHERE [Username] = 'User 2'

-- GROUPS
DELETE FROM Groups
WHERE [Name] = 'Group7'

--22. Write SQL statements to insert in the Users table the names of all employees from the Employees table.
-- Combine the first and last names as a full name.
-- For username use the first letter of the first name + the last name (in lowercase).
-- Use the same for the password, and NULL for last login time.
INSERT INTO Users ([Username],[Password],[FullName],[Last Login])
SELECT 
SUBSTRING(FirstName,1,1) + LOWER(LastName),
SUBSTRING(FirstName,1,1) + LOWER(LastName) + 'parola',
FirstName + ' ' + LastName,
NULL
FROM Employees

--23. Write a SQL statement that changes the password to NULL for all users 
-- that have not been in the system since 10.03.2010.
UPDATE Users
SET [Password] = NULL
WHERE [Last Login] >= Convert(datetime, '2016-03-10')

--24. Write a SQL statement that deletes all users without passwords (NULL password).
DELETE FROM Users
WHERE [Password] IS NULL

--25. Write a SQL query to display the average employee salary by department and job title.
SELECT AVG(Salary) as [Average Salary], DepartmentID, JobTitle 
FROM Employees
GROUP BY DepartmentID, JobTitle

--26. Write a SQL query to display the minimal employee 
-- salary by department and job title along with the name of some of the employees that take it.
SELECT e.FirstName, e.Salary, e.DepartmentID, e.JobTitle
FROM Employees e 
  JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = 
  (SELECT MIN(Salary) FROM Employees 
   WHERE DepartmentID = d.DepartmentID)

--27. Write a SQL query to display the town where maximal number of employees work.
SELECT TOP 1 t.Name, COUNT(t.Name) AS [Town where maximum employees work] FROM Employees e
  JOIN Addresses a
ON e.AddressID = a.AddressID
  JOIN Towns t
ON a.TownID = t.TownID
GROUP BY  t.Name
ORDER BY  [Town where maximum employees work] DESC

--28. Write a SQL query to display the number of managers from each town.
SELECT t.Name, COUNT(*) as [Number of managers] FROM Towns t
	JOIN Addresses a ON t.TownID = a.TownID
	JOIN Employees e ON a.AddressID = e.AddressID
	WHERE e.EmployeeID IN 
	(SELECT DISTINCT ManagerID FROM Employees)
	GROUP BY t.Name
ORDER BY [Number of managers] DESC

--29. Write a SQL to create table WorkHours to store work reports for each employee (employee id, date, task, hours, comments).
-- Don't forget to define identity, primary key and appropriate foreign key.
-- Issue few SQL statements to insert, update and delete of some data in the table.
-- Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
-- For each change keep the old record data, the new record data and the command (insert / update / delete).
CREATE TABLE WorkHours
(
	[Id] INT IDENTITY PRIMARY KEY,
	[EmployeeId] INT NOT NULL,
	[Date] DATETIME,
	[Task] NVARCHAR(50),
	[Hours] INT,
	[Comments] VARCHAR(250),
	CONSTRAINT FK_WorkHours_Employees 
		FOREIGN KEY (EmployeeId) 
		REFERENCES Employees(EmployeeID)
)
GO

INSERT INTO WorkHours
VALUES (1, GETDATE(), 'Task1', 10, NULL),
	   (2, GETDATE(), 'Task2', 9, NULL),
	   (3, GETDATE(), 'Task3', 8, 'TODO')
GO

UPDATE WorkHours
SET [Comments] = 'Did bad work'
WHERE [EmployeeId] = 1
GO

DELETE FROM WorkHours
WHERE [Hours] = 9
GO

CREATE TABLE ReportsLogs(
	[Id] INT IDENTITY PRIMARY KEY,
	[EmployeeId] INT NOT NULL,
	[Date] DATETIME,
	[Task] NVARCHAR(50),
	[Hours] INT,
	[Comments] VARCHAR(250),
	[For] VARCHAR(50)
)
GO

CREATE TRIGGER trg_WorkHours_Insert ON WorkHours
FOR INSERT 
AS
INSERT INTO ReportsLogs([EmployeeId], [Date], [Task], [Hours], [Comments], [For])
    SELECT [EmployeeId], [Date], [Task], [Hours], [Comments], 'INSERT'
    FROM INSERTED
GO

CREATE TRIGGER trg_WorkHours_Delete ON WorkHours
FOR DELETE 
AS
INSERT INTO ReportsLogs([EmployeeId], [Date], [Task], [Hours], [Comments], [For])
    SELECT [EmployeeId], [Date], [Task], [Hours], [Comments], 'DELETE'
    FROM DELETED
GO

CREATE TRIGGER trg_WorkHours_Update ON WorkHours
FOR UPDATE 
AS
INSERT INTO ReportsLogs([EmployeeId], [Date], [Task], [Hours], [Comments], [For])
    SELECT [EmployeeId], [Date], [Task], [Hours], [Comments], 'UPDATE'
    FROM INSERTED
GO

INSERT INTO WorkHours
VALUES(2, GETDATE(), 'Task2', 9, NULL)
GO

DELETE FROM  WorkHours 
WHERE [Hours] = 9
GO

UPDATE WorkHours
SET Comments = 'Done'
WHERE Comments = 'TODO'

--30. Start a database transaction, delete all employees from the 'Sales' 
-- department along with all dependent records from the pother tables.
-- At the end rollback the transaction.

BEGIN TRAN
	ALTER TABLE Departments
	DROP CONSTRAINT FK_Departments_Employees

	ALTER TABLE WorkHours
	DROP CONSTRAINT FK_WorkHours_Employees

	ALTER TABLE EmployeesProjects
	DROP CONSTRAINT FK_EmployeesProjects_Employees

	DELETE FROM Employees
	SELECT d.Name
	FROM Employees e
		JOIN Departments d
			ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'
	GROUP BY d.Name
ROLLBACK TRAN

--31. Start a database transaction and drop the table EmployeesProjects.
-- Now how you could restore back the lost table data?
BEGIN TRAN
	DROP TABLE EmployeesProjects
ROLLBACK TRAN

--32. Find how to use temporary tables in SQL Server.
-- Using temporary tables backup all records from EmployeesProjects and restore 
-- them back after dropping and re-creating the table.
BEGIN TRAN
SELECT *  INTO  #TempEmployeesProjects
FROM EmployeesProjects

DROP TABLE EmployeesProjects

SELECT * INTO EmployeesPRojects
FROM #TempEmployeesProjects

ROLLBACK TRAN