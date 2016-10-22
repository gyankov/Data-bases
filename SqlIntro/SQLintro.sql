--4. Write a SQL query to find all information about all departments (use "TelerikAcademy" database).
SELECT * FROM Departments

--5.Write a SQL query to find all department names.
SELECT Name FROM Departments

--6.Write a SQL query to find the salary of each employee.
SELECT FirstName+' '+ LastName AS [Name], Salary FROM Employees

--7.Write a SQL to find the full name of each employee.
SELECT FirstName+' '+MiddleName +' '+ LastName AS [Full name] FROM Employees

--8.Write a SQL query to find the email addresses of each employee (by his first and last name).
-- Consider that the mail domain is telerik.com. Emails should look like �John.Doe@telerik.com".
-- The produced column should be named "Full Email Addresses".
SELECT FirstName+'.'+LastName+'@telerik.com' AS [Full Email Addresses]  FROM Employees


--9.Write a SQL query to find all different employee salaries.
SELECT DISTINCT Salary AS [Different employee salaries] FROM Employees

--10.Write a SQL query to find all information about the employees whose job title is �Sales Representative�.
SELECT * FROM Employees
WHERE JobTitle = 'Sales Representative'

--11.Write a SQL query to find the names of all employees whose first name starts with "SA".
SELECT FirstName, MiddleName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

--12.Write a SQL query to find the names of all employees whose last name contains "ei".
SELECT FirstName, MiddleName, LastName FROM Employees
WHERE FirstName LIKE '%ei%'

--13.Write a SQL query to find the salary of all employees whose salary is in the range [20000�30000].
SELECT Salary FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

--14.Write a SQL query to find the names of all employees whose salary is 25000, 14000, 12500 or 23600.
SELECT Salary FROM Employees
WHERE Salary IN(25000,14000,12500,23600)

--15.Write a SQL query to find all employees that do not have manager.
SELECT FirstName,LastName FROM Employees
WHERE ManagerID IS NULL

--16.Write a SQL query to find all employees that have salary more than 50000.
-- Order them in decreasing order by salary.
SELECT FirstName, LastName, Salary FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

--17.Write a SQL query to find the top 5 best paid employees.

SELECT TOP 5 FirstName, LastName, Salary FROM Employees
ORDER BY Salary DESC

--18.Write a SQL query to find all employees along with their address. Use inner join with ON clause.
SELECT E.FirstName, E.LastName, A.AddressText
FROM Employees E
INNER JOIN Addresses A
ON E.AddressID = A.AddressID

--19.Write a SQL query to find all employees along with their address. Use inner join with ON clause.
SELECT E.FirstName, E.LastName, A.AddressText
FROM Employees E, Addresses A
WHERE E.AddressID = A.AddressID

--20.Write a SQL query to find all employees along with their manager.
SELECT E.FirstName, E.LastName, M.FirstName,M.LastName
FROM Employees E
INNER JOIN Employees M
ON E.ManagerID = M.EmployeeID

--21.Write a SQL query to find all employees, along with their manager and their address.
-- Join the 3 tables: Employees e, Employees m and Addresses a.
SELECT E.FirstName+' '+ E.LastName AS EMPLOYEE, M.FirstName+' '+ M.LastName AS MANAGER, A.AddressText AS [ADDRESS]
FROM Employees E, Employees M, Addresses A
WHERE E.ManagerID = M.EmployeeID AND E.AddressID = A.AddressID

--22.Write a SQL query to find all departments and all town names as a single list. Use UNION.
SELECT Name FROM Departments
UNION
SELECT Name FROM Towns

--23.Write a SQL query to find all the employees and the manager 
--for each of them along with the employees that do not have manager.
 --Use right outer join. Rewrite the query to use left outer join.

 SELECT E.FirstName AS MANAGER, M.FirstName AS EMPLOYEE
 FROM Employees E
RIGHT OUTER JOIN Employees M
ON E.EmployeeID = M.ManagerID

 SELECT E.FirstName AS MANAGER, M.FirstName AS EMPLOYEE
 FROM Employees E
LEFT OUTER JOIN Employees M
ON E.ManagerID = M.EmployeeID

--24.Write a SQL query to find the names of all employees from
-- the departments "Sales" and "Finance" whose hire year is between 1995 and 2005.

SELECT E.FirstName, E.LastName, E.HireDate, D.Name AS DEPARTMENT
FROM Employees E, Departments D
WHERE E.DepartmentID = D.DepartmentID
AND (D.Name = 'Sales' OR D.Name = 'Finance')
AND e.HireDate BETWEEN '1995' AND '2005'
