-- Instructor Stephen D. Rader
-- Student Oscar Flores

-- In SQL Server Management Studio (SSMS), a comment in the query window is preceded by two dashes (--). 
-- All comments appear in green and are not run when real SQL code is executed.  
-- Comments are the way to communicate valuable information between analysts writing and running the queries.

/** Large block of comment can be preceded by a forward-slash / and two asterisks ** and then end ed by two asterisks ** and a backslash /
	To begin selecting data, first use the database that you wish to pull data FROM. Execute the command below to USE the 'Medical' database, where all our data are found.
	Highlight the command with your mouse and click "Execute.”
**/

-- GETTING STARTED

	USE Medical

-- You can use the Object Explorer to the left to list the tables under the Medical database.
-- To begin pulling some data, highlight and execute the command below. It will return every row in the Doctors TABLE of the Medical database.
-- SELECT * can be used if you do not know the specific column names to SELECT. Highlight the code below and Execute.

	SELECT * 
	FROM Doctors

-- EXERCISE - Try this for Patients, Facilities, Diagnoses

-- to limit the number of rows returned, highlight and execute the code below

-- SELECT TOP

	SELECT TOP 10 * 
	FROM Doctors

-- EXERCISE - Try this for Encounters, Medications, Diagnoses

	SELECT TOP 10 * 
	FROM Encounters

	SELECT TOP 10 * 
	FROM Medications

	SELECT TOP 10 * 
	FROM Diagnoses

-- To SELECT specific data by column name, list the column names (exactly) the SELECT line, they are NOT case sensitive. 
-- Try the code below by selecting it and clicking Execute

	SELECT LastName, 
	       FirstName 
	FROM Doctors

-- EXERCISE - SELECT PatientID, LastName, DOB FROM Patients, get LastName and Specialty FROM the Doctors TABLE.

-- The code below will CONCATENATE (put together) the last and first names into a single column and will rename that column (for output purposes only) 'Doctor Name'

-- RENAMING COLUMNS FOR OUTPUT

	SELECT LastName+', '+FirstName 'Doctor Name'
	FROM Doctors

-- EXERCISE - Pull Diagnosis code and description FROM the Diagnoses TABLE and name the description column "Disease Name"

-- The code below will put those Doctor Names in order alphabetically, starting with the beginning of the alphabet.

-- SORTING

	SELECT LastName+', '+FirstName 'Doctor Name'
	FROM Doctors
	ORDER BY LastName+', '+FirstName

-- and the code below will put them in reverse alphabetical order. Try it.

	SELECT LastName+', '+FirstName 'Doctor Name'
	FROM Doctors
	ORDER BY LastName+', '+FirstName DESC

-- EXERCISE - Modify the code above to include Doctor Specialty and sort by that column the doctor name

	SELECT LastName+', '+FirstName 'Doctor Name',
		   Specialty
	FROM Doctors
	ORDER BY Specialty

-- WHERE CLAUSE

-- To limit the data returned by some criterion or criteria, use a WHERE clause.
-- The code below will return Doctors whose last name is Dalton.

	SELECT LastName, 
		   FirstName
	FROM Doctors
	WHERE LastName = 'Dalton'

-- Change the code above to find Doctors with last name "Gates"

	SELECT LastName, 
		   FirstName
	FROM Doctors
	WHERE LastName = 'Gates'

--We can specify multiple criteria. With the method below, the LastName must EXACTLY match what is in the single quotes. Try it.

	SELECT LastName, 
		   FirstName
	FROM Doctors
	WHERE LastName IN ('Dalton', 'Hood')

-- EXERCISE - Change the code above to include Doctors named "Collins" as well.
	
	SELECT LastName, 
		   FirstName
	FROM Doctors
	WHERE LastName IN ('Dalton', 
					   'Hood',
					   'Collins')

-- If we forget to close a quote or a parentheses, we will get an error.

	SELECT LastName, 
		   FirstName
	FROM Doctors
	WHERE LastName IN ('Dalton', 
					   'Hood') -- NOTE:  You will need to fix this problem in order not to see red squiggliest in the rest of this code -- FIXED

-- JOINS

-- To get data FROM multiple tables pulled together, we must JOIN the tables. We usually JOIN the tables ON the PRIMARY KEY (the column showing unique values in that table) of one TABLE to the FOREIGN KEY value of the other. 
-- These are the same values. When PRIMARY KEY values appear in other tables, they are called FOREIGN KEYS. 

-- The code below joins the Encounters TABLE with the Patients table, because we want to pull information FROM both tables together into one report. 
-- We know that the PRIMARY KEY in the Patients TABLE is PatientID and that value appears in the Encounters TABLE as a FOREIGN KEY with the same name.
-- To return rows in common between the two tables, use an INNER JOIN. This will only return rows WHERE the PRIMARY and FOREIGN KEY values match between the two tables. 

-- We are also going to give each of our tables a nickname or alias, so it is easier to refer to them in the query. We will call Encounters "e" and Patients "p".
-- Here we are pulling the concatenated Patient Name FROM the Patients TABLE and the DATE of their Encounters FROM the Encounters table, joined on the column common to both, PatientID.
-- For an INNER JOIN such as this (note, using the word "JOIN" alone automatically makes it an INNER JOIN) the order of the tables listed does not matter. SELECT and execute the code below.

	SELECT p.LastName+', '+p.FirstName 'Patient Name', 
		   e.DATE 'Encounter Date'
	FROM Encounters e
	JOIN Patients p ON e.PatientID = p.PatientID

-- EXERCISE - Add an INNER JOIN to the query above to the Doctors TABLE (the column in common is "DoctorID") and include doctor last and first name in the selection to put the data in ORDER BY Patient Name and by most recent encounter first, we will sort by both, making the DATE DESC

	SELECT p.LastName+', '+p.FirstName 'Patient Name', 
		   e.DATE 'Encounter Date'
	FROM Encounters e
	JOIN Patients p ON e.PatientID = p.PatientID
	ORDER BY p.LastName+', '+p.FirstName, 
			 e.DATE DESC

-- OUTER JOIN

-- To return all rows in the first TABLE listed and only the matching rows in the second, use an OUTER JOIN. 
-- In this case it is a LEFT JOIN because the TABLE listed first (which is on the left if you drew a picture) is the TABLE we want all rows FROM, and TABLE second will only show the rows where that PatientID appears in the Encounters TABLE.

	SELECT p.LastName, 
		   e.DATE
	FROM Patients p 
	LEFT JOIN Encounters e ON p.PatientID = e.PatientID

-- EXERCISE - If I wanted to pull all Doctors (LastName, FirstName) and any encounter dates they have, and include all Doctors even if they do not have Encounters, how would I do it?

-- In the Encounters table, a single DATE will appear multiple times, because there are many Encounters in a single day. To return each DATE in the Encounters TABLE only one time, USE DISTINCT.

	SELECT distinct DATE
	FROM Encounters

-- EXERCISE - How would I get a unique list of PatientIDs FROM the Encounters Table?

--WILDCARDS and COMPARISON

-- You can use a wildcard such as '%' in your WHERE CLAUSE to stand for multiple items. 
-- In the query below, we will see only Patients whose last name starts with A, regardless of what follows.

	SELECT *
	FROM Patients
	WHERE LastName like 'a%'

-- EXERCISE - Change the code above to pull all Patients whose last name ends in "s" regardless of what precedes it.
-- You can also use comparison operators in your WHERE clause. They include things like 'BETWEEN', '<', '>', etc. 
-- Highlight and execute the code below to see Encounters after/1/2020

	SELECT * 
	FROM Encounters
	WHERE DATE >'2020-01-01'

-- How would I pull every column FROM the Encounters TABLE for dates prior to 1/1/2019?

-- And to see Encounters in the last month of 2021, try this one.

	SELECT * 
	FROM Encounters
	WHERE DATE BETWEEN '2021-12-01' AND '2021-12-31' -- It is inclusive, so it will include the start and END dates.

-- FUNCTIONS

-- You can use built-in FUNCTIONS to return and/or manipulate values. The code below returns today's date, regardless of when you run it.

	SELECT GETDATE() 'The DATE Today'

-- And this code allows us to calculate someone's birthday in years as of the day the code was run. It uses the DATADIFF function.

	SELECT LastName, 
		   FirstName, 
		   DOB, DATEDIFF(YEAR, DOB, GETDATE()) 'Age IN Years'
	FROM Patients

-- EXERCISE - Change the query above to add the Encounters TABLE and get dates of Encounters for all Patients who were seen BETWEEN '2022-01-01' AND '2022-03-01'

	SELECT p.LastName, 
		   p.FirstName, 
		   p.DOB, 
		   DATEDIFF(YEAR, DOB, GETDATE()) 'Age IN YEARs',
		   e.Date 'Encounter Date'
	FROM Patients p
	JOIN Encounters e ON p.PatientID = e.PatientID
	WHERE e.Date BETWEEN '2022-01-01' AND '2022-03-01'
	ORDER BY e.Date

-- CASE STATEMENTS

-- A CASE STATEMENT allows us to organize OR group data into categories or to otherwise transform it. 
-- Highlight the code below and execute it to see.

	SELECT LastName, 
		   FirstName, 
		   DOB, 
		   DATEDIFF(YEAR, DOB, GETDATE()) 'Age IN YEARs',
		   case 
				WHEN DATEDIFF(YEAR, DOB, GETDATE())<10 then 'Under 10 YEARs of age'
				WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 11 and 19 then '11 - 19 YEARs old'
				ELSE 'Over 19' END  'Age Range'
	FROM Patients

-- EXERCISE - Change the query above to include age range 20 - 29, 30 - 39 and 40 - 49 and make the last one Over 50

	SELECT LastName, 
		   FirstName, 
		   DOB, 
		   DATEDIFF(YEAR, DOB, GETDATE()) 'Age IN YEARs',
		   CASE 
				WHEN DATEDIFF(YEAR, DOB, GETDATE())<10 THEN 'Under 10 YEARs of age'
				WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 11 and 19 THEN '11 - 19 YEARs old'
				WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 20 and 29 THEN '20 - 29 YEARs old'
				WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 30 and 39 THEN '30 - 39 YEARs old'
				WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 40 and 49 THEN '40 - 49 YEARs old'
		   ELSE 'Over 50' END  'Age Range'
	FROM Patients
	ORDER BY [Age Range]


-- AGGREGATION AND GROUPING

-- We can aggregate data in our output. We can COUNT it, ADD it, average (AVG) it. 
-- When we are aggregating across some other data point, we must GROUP BY that data point.  
-- Here we will COUNT all the visits.

	SELECT COUNT(EncounterID) 'Total Number of Visits'
	FROM Encounters

-- Here we will COUNT all the visits by YEAR

	SELECT YEAR(DATE) 'YEAR', 
		   COUNT(EncounterID) 'Total Number of Visits'
	FROM Encounters
	GROUP BY YEAR(DATE)

-- EXERCISE - Change the query above to add the Facility Name and also GROUP BY it.

	SELECT YEAR(e.DATE) 'YEAR', 
		   COUNT(e.EncounterID) 'Total Number of Visits',
		   f.Name 'Facility Name'
	FROM Encounters e
	JOIN Facilities f ON e.FacilityID = f.FacilityID
	GROUP BY YEAR(DATE), 
			 f.Name

-- If we use a CASE STATEMENT and wish to GROUP BY it, we must include it in the GROUP BY statement.

	SELECT 
		CASE 
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE())<10 then 'Under 10 YEARs of age'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 11 and 19 then '11 - 19 YEARs old'
		ELSE 'Over 19' END  'Age Range', COUNT(e. EncounterID) 'Visits'
	FROM Encounters e
	JOIN Patients p ON e.PatientID = p.PatientID
	GROUP BY 
		CASE 
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE())<10 then 'Under 10 YEARs of age'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 11 and 19 then '11 - 19 YEARs old'
		 ELSE 'Over 19' END 

-- EXERCISE - Change the query above as you did earlier to include age range 20 - 29, 30 - 39 and 40 - 49 and make the last one Over 50.  
	SELECT 
		CASE 
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE())<10 then 'Under 10 YEARs of age'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 11 AND 19 then '11 - 19 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 20 AND 29 then '20 - 29 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 30 AND 39 then '30 - 39 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 40 AND 49 then '40 - 49 YEARs old'
		ELSE 'Over 50' END  'Age Range', 
		COUNT(e. EncounterID) 'Visits'
	FROM Encounters e
	JOIN Patients p ON e.PatientID = p.PatientID
	GROUP BY 
		CASE 
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE())<10 then 'Under 10 YEARs of age'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 11 AND 19 then '11 - 19 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 20 AND 29 then '20 - 29 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 30 AND 39 then '30 - 39 YEARs old'
			WHEN DATEDIFF(YEAR, p.DOB, GETDATE()) BETWEEN 40 AND 49 then '40 - 49 YEARs old'
		 ELSE 'Over 50' END 

-- Make sure to update both CASE statements use MIN to get the first or smallest of something and MAX to get the last or greatest.

	SELECT MIN(DATE) 'The Very First Visit', 
		   MAX(DATE) 'The Ver Last Visit'
	FROM Encounters

-- TEMPORARY TABLES AND TRANSACTIONS

-- You can CREATE a TEMPORARY TABLE by preceding its name with '#' LOCAL or '##' GLOBAL. 
-- TEMPORARY TABLES will remain active in the current SQL session and then will be dropped when that session ends.
-- Using '#' will make the temporary TABLE available only in the current query window while '##' will make it available in any open query window. 
-- Highlight and execute the code below to make a TABLE called 'RPatients' and to have the PatientID of any patient whose name starts with 'R'.

	DROP TABLE IF EXISTS ##RPatients --This is to avoid the error of existing table
	CREATE TABLE ##RPatients(PatientID int, LastName varchar(100))
	INSERT INTO ##RPatients
	SELECT PatientID, 
		   LastName FROM Patients WHERE LastName like 'r%'
	
	SELECT * FROM ##RPatients

-- EXERCISE - CREATE a temporary TABLE for all Patients (PatientID, LastName) whose birthday is before 6/1/1975.
	
	DROP TABLE IF EXISTS ##RPatientsBirtday --This is to avoid the error of existing table
	CREATE TABLE ##RPatientsBirtday (PatientID int, LastName varchar(100))
	
	INSERT INTO ##RPatientsBirtday
	SELECT PatientID, 
		   LastName FROM Patients WHERE DOB < '1975-06-01'
	
	SELECT * FROM ##RPatientsBirtday

-- TRANSACTIONS, COMMIT AND ROLLBACK

-- Use a transaction to evaluate the code without executing it. If it is correct, COMMIT the transaction. If not, USE ROLLBACK. 
-- NOTE: Once a TRAN has been begun, it MUST either be committed or rolled back. If you run the code below, you will get the RPatients Table, but it will not be dropped until you COMMIT it. 
-- NOTE: We must DROP it at the beginning because it still exists FROM the last query.

	DROP TABLE ##RPatients
	CREATE TABLE ##RPatients(PatientID int, LastName varchar(100))
	INSERT INTO ##RPatients
	SELECT PatientID, LastName FROM Patients WHERE LastName like 'r%'

	SELECT * FROM ##RPatients

	BEGIN TRAN
		DROP TABLE ##RPatients

	--COMMIT TRAN
	--ROLLBACK TRAN

-- EXERCISE - Do the above exercise but for your Patients born before 6/1/1975 temporary table

	DROP TABLE ##RPatientsBorn1975
	CREATE TABLE ##RPatientsBorn1975(PatientID int, LastName varchar(100))
	INSERT INTO ##RPatientsBorn1975
	SELECT PatientID, LastName FROM Patients WHERE DOB > '1975-06-01'

	SELECT * FROM ##RPatientsBorn1975

	BEGIN TRAN
		DROP TABLE ##RPatientsBorn1975

	--COMMIT TRAN
	--ROLLBACK TRAN
