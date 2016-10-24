USE TelerikAcademy
--1.Write a SQL query to find the names and salaries of the employees that take the minimal salary in the company.
--Use a nested SELECT statement.

SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary= (SELECT MIN(Salary) FROM Employees)

--2.Write a SQL query to find the names and salaries of the employees that have a salary 
--that is up to 10% higher than the minimal salary for the company.

SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary < (SELECT MIN(Salary)* 1.1 FROM Employees)

--3.Write a SQL query to find the full name, salary and department of the employees 
--that take the minimal salary in their department.
--Use a nested SELECT statement.

SELECT E.FirstName+' '+E.MiddleName+' '+E.LastName AS [Full name], E.Salary, D.Name AS DEPARTMENT
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary = (SELECT MIN(Salary) FROM Employees WHERE DepartmentID = E.DepartmentID )

--4.Write a SQL query to find the average salary in the department #1.

SELECT AVG(Salary) AS [Average salary for dep 1] FROM Employees
WHERE DepartmentID = 1

--5.Write a SQL query to find the average salary in the "Sales" department.
SELECT AVG(E.Salary)
 FROM Employees E
 JOIN Departments D
 ON E.DepartmentID = D.DepartmentID
 WHERE D.Name = 'Sales'

 --6.Write a SQL query to find the number of employees in the "Sales" department.
 SELECT COUNT(E.EmployeeID) 
 FROM Employees E
 JOIN Departments D
 ON E.DepartmentID = D.DepartmentID
 WHERE D.Name = 'Sales'

 --7.Write a SQL query to find the number of all employees that have manager.
 SELECT COUNT(E.EmployeeID)
 FROM Employees E
 WHERE E.ManagerID IS NOT NULL

 --8.Write a SQL query to find the number of all employees that have no manager.
 SELECT COUNT(*)
 FROM Employees
 WHERE ManagerID IS NULL

 --9.Write a SQL query to find all departments and the average salary for each of them.
 SELECT AVG(E.Salary), D.Name
 FROM Employees E
 JOIN Departments D
 ON E.DepartmentID = D.DepartmentID
 GROUP BY D.Name

 --10.Write a SQL query to find the count of all employees in each department and for each town.
 SELECT COUNT(E.EmployeeID) AS [EMPLOYEE COUNT], D.Name AS DEPARTMENT, T.Name
 FROM Employees E
 JOIN Departments D
 ON E.DepartmentID = D.DepartmentID
 JOIN Addresses A
 ON E.AddressID = A.AddressID
 JOIN Towns T
 ON A.TownID = T.TownID
 GROUP BY  T.Name, D.Name

 --11.Write a SQL query to find all managers that have exactly 5 
 --employees. Display their first name and last name.
SELECT M.FirstName, M.LastName, COUNT(*)
FROM Employees E
JOIN Employees M
ON E.ManagerID = M.EmployeeID
GROUP BY M.FirstName, M.LastName
HAVING COUNT(*) = 5

--12.Write a SQL query to find all employees along with their managers.
--For employees that do not have manager display the value "(no manager)".
SELECT E.FirstName+' '+E.LastName AS [EMPLOYEE NAME], ISNULL(M.FirstName+' '+M.LastName,'NO MANAGER') AS [MANAGER NAME]
FROM Employees E
LEFT OUTER JOIN Employees M
ON E.ManagerID = M.EmployeeID

--13.Write a SQL query to find the names of all employees whose last name is
-- exactly 5 characters long. Use the built-in LEN(str) function.
SELECT FirstName, LastName  FROM Employees
WHERE LEN(LastName) = 5

--14.Write a SQL query to display the current date and time in the following format 
--"day.month.year hour:minutes:seconds:milliseconds".
--Search in Google to find how to format dates in SQL Server.
SELECT FORMAT(GETDATE(),'dd.MM.yyyy hh:mm:ss:ms') AS [CURRENT DADE]

--15.Write a SQL statement to create a table Users. Users should have username, password, full name and last login time.
--Choose appropriate data types for the table fields. Define a primary key column with a primary key constraint.
--Define the primary key column as identity to facilitate inserting records.
--Define unique constraint to avoid repeating usernames.
--Define a check constraint to ensure the password is at least 5 characters long.
CREATE TABLE Users(
Id int IDENTITY,
[Username] nvarchar(50) NOT NULL UNIQUE,
[Password] nvarchar(30) NOT NULL CHECK(LEN([Password])>4),
[Fullname] nvarchar(100) NOT NULL,
[Last login] date ,
CONSTRAINT PK_Users PRIMARY KEY(Id)
)

--16.Write a SQL statement to create a view that displays the users from the
-- Users table that have been in the system today.
--Test if the view works correctly.
SELECT * FROM Users
WHERE [Last login] = '2016-10-19'


--17.Write a SQL statement to create a table Groups. Groups should have unique name (use unique constraint).
--Define primary key and identity column.
CREATE TABLE Groups(
Id int IDENTITY,
[name] nvarchar(50) NOT NULL UNIQUE,
CONSTRAINT PK_Groups PRIMARY KEY(Id)
)

--18.Write a SQL statement to add a column GroupID to the table Users.
--Fill some data in this new column and as well in the `Groups table.
--Write a SQL statement to add a foreign key constraint between tables Users and Groups tables.
ALTER TABLE Users
ADD GroupID int

ALTER TABLE Users
ADD FOREIGN KEY(GroupID)
REFERENCES Groups(Id)

--19.Write SQL statements to insert several records in the Users and Groups tables.
INSERT INTO Users(
[Username],
[Password],
[Fullname],
[Last login]
)
VALUES('GOSHO', 'GFDSHOS', 'FDASSF', GETDATE())

INSERT INTO Groups(
[name]
)
VALUES('GOSHO')

--20.Write SQL statements to update some of the records in the Users and Groups tables.

UPDATE Users
SET [Username]='PESHO'
WHERE [Username] = 'GOSHO' 

UPDATE Groups
SET [name]='PESHO'
WHERE name = 'GOSHO' 

--21.Write SQL statements to delete some of the records from the Users and Groups tables.
DELETE FROM Users
WHERE Username = 'PESHO'

DELETE FROM Groups
WHERE name = 'PESHO'

--22.Write SQL statements to insert in the Users table the names of all employees from the Employees table.
--Combine the first and last names as a full name.
--For username use the first letter of the first name + the last name (in lowercase).
--Use the same for the password, and NULL for last login time.

INSERT INTO Users(Username,[Password],[Fullname],[Last login])
SELECT
SUBSTRING(FirstName,1,1) + LOWER(LastName),
SUBSTRING(FirstName,1,1) + LOWER(LastName) + 'parola',
FirstName + ' ' + LastName,
NULL

FROM Employees

--23.Write a SQL statement that changes the password to NULL
-- for all users that have not been in the system since 10.03.2010.

UPDATE Users
SET[Password] = NULL
WHERE [Last login] < Convert(datetime,'2016-03-10')

--24.Write a SQL statement that deletes all users without passwords (NULL password).

DELETE FROM Users
WHERE Password IS NULL

--25.Write a SQL query to display the average employee salary by department and job title
SELECT AVG(Salary) AS[AVERAGE SALARY],E.JobTitle , D.Name AS [DEPARTMENT]
FROM Employees E
JOIN Departments D
ON E.DepartmentID= D.DepartmentID
GROUP BY E.JobTitle, D.Name

--26.Write a SQL query to display the minimal employee salary by department and job title
-- along with the name of some of the employees that take it.

SELECT E.FirstName, E.Salary AS SALARY, E.JobTitle, D.Name
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary =(SELECT MIN(Salary) FROM Employees WHERE DepartmentID = E.DepartmentID)

--27.Write a SQL query to display the town where maximal number of employees work.
SELECT TOP 1 T.Name , COUNT(T.Name)
FROM Employees E
JOIN Addresses A 
ON E.AddressID = A.AddressID
JOIN Towns T
ON A.TownID= T.TownID
GROUP BY T.Name
ORDER BY COUNT(T.Name) DESC

--28.Write a SQL query to display the number of managers from each town.
SELECT T.Name, COUNT(*) AS [NUMBER OF MANAGERS]
FROM Towns T
JOIN Addresses A
ON T.TownID = A.TownID
JOIN Employees E
ON E.AddressID = A.AddressID
WHERE E.ManagerID IS NULL
GROUP BY T.Name

--29.Write a SQL to create table WorkHours to store work reports for each employee (employee id, date, task, hours, comments).
--Don't forget to define identity, primary key and appropriate foreign key.
--Issue few SQL statements to insert, update and delete of some data in the table.
--Define a table WorkHoursLogs to track all changes in the WorkHours table with triggers.
--For each change keep the old record data, the new record data and the command (insert / update / delete).

CREATE TABLE WorkHours(
[Id] INT IDENTITY PRIMARY KEY,
[EmployeeId] INT NOT NULL,
[Date] DATETIME,
[Task] NVARCHAR(50),
[Hours] INT,
[Comments] NVARCHAR(50)

CONSTRAINT FK_WorkHours_Employees
FOREIGN KEY (EmployeeId)
REFERENCES Employees(EmployeeID)
)
GO

INSERT INTO WorkHours
VALUES (1, GETDATE(), 'Task1', 10, NULL),
 (2, GETDATE(), 'Task2', 8, NULL),
 (3, GETDATE(), 'Task3', 10, NULL)

GO

UPDATE WorkHours
SET [Comments]= 'DONE'
WHERE [EmployeeId] = 1
GO

DELETE FROM WorkHours
WHERE [Hours]= 8

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
FROM inserted
GO

CREATE TRIGGER trg_WorkHours_Delete ON WorkHours
FOR INSERT
AS
INSERT INTO ReportsLogs([EmployeeId], [Date], [Task], [Hours], [Comments], [For])
SELECT [EmployeeId], [Date], [Task], [Hours], [Comments], 'DELETE'
FROM deleted
GO

CREATE TRIGGER trg_WorkHours_Update ON WorkHours
FOR INSERT
AS
INSERT INTO ReportsLogs([EmployeeId], [Date], [Task], [Hours], [Comments], [For])
SELECT [EmployeeId], [Date], [Task], [Hours], [Comments], 'UPDATE'
FROM inserted
GO

INSERT INTO WorkHours
VALUES(2, GETDATE(), 'Task2', 9, NULL)
GO

DELETE FROM  WorkHours 
WHERE [Hours] = 9
GO

UPDATE WorkHours
SET Comments = 'Done'
WHERE Comments = NULL

--30.Start a database transaction, delete all employees 
--from the 'Sales' department along with all dependent records from the pother tables.
--At the end rollback the transaction.

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


--31.Start a database transaction and drop the table EmployeesProjects.
--Now how you could restore back the lost table data?

BEGIN TRAN
	DROP TABLE EmployeesProjects
ROLLBACK TRAN

--32.Find how to use temporary tables in SQL Server.
--Using temporary tables backup all records from EmployeesProjects and 
--restore them back after dropping and re-creating the table.

BEGIN TRAN
SELECT *  INTO  #TempEmployeesProjects
FROM EmployeesProjects

DROP TABLE EmployeesProjects

SELECT * INTO EmployeesPRojects
FROM #TempEmployeesProjects

ROLLBACK TRAN