USE Medical
--Write a query to return all all patients (lastname, firstname) in order by age (youngest to oldest).  
--You don't need to calculate ages, you can use date of birth.

SELECT LastName,
               FirstName 
FROM Patients
ORDER BY DOB DESC
---Write a query to select all rows and columns from the Patients table.

SELECT *
FROM Patients

--Write a query to return all patients whose last name starts with R

SELECT *
FROM Patients
WHERE LastName LIKE 'R%'

--Write a query to return any patient (lastname, firstname) whose last name is either Lee or Smith.
SELECT LastName, 
               FirstName
FROM Patients
WHERE LastName IN ('Lee', 'Smith')

--Write a query to return patients (lastname, firstname) whose last name starts and ends with A
SELECT LastName, 
              FirstName
FROM Patients
WHERE LastName LIKE 'a%a'

--Write a query to return all providers (lastname, firstname) in order by last name from A-Z.
SELECT LastName, 
       FirstName
FROM Doctors
ORDER BY LastName

--Write a query to return all patients whose last name is Jones.

SELECT *
FROM Patients
WHERE LastName = 'Jones'

--Write a query to list each patient and their encounter dates in order by patient last name (A-Z) and encounter date (oldest first).

SELECT p.LastName,
              p.FirstName,
              e.Date       
FROM Patients p
JOIN Encounters e ON p.PatientID = e.PatientID
ORDER BY p.LastName, e.Date

--Write a query to identify all blood pressures that are either too long or too short.  A valid blood pressure contains 2 or 3 numbers, a backslash (/), and 2 or 3 numbers. Include the patient name, date of visit, facility and provider.

SELECT p.LastName+','+p.FirstName 'Patient Name',
              e.Date 'Date of Visit',
              f.Name 'Facility Name',
             d.LastName+','+d.FirstName 'Provider'
FROM Encounters e
JOIN Patients p ON e.PatientID = p.PatientID
JOIN Facilities f ON e.FacilityID = f.FacilityID
JOIN Doctors d ON e.DoctorID = d.DoctorID
JOIN BloodPressure b ON e.EncounterID = b.EncounterID
WHERE BP NOT LIKE '%/%'
                     AND Len(bp) BETWEEN 5 AND 7
                     AND bp NOT LIKE '%[A-Z, A-Z]%'
                     AND Charindex('/', bp) BETWEEN 3 AND 4
                     AND bp NOT LIKE '%.%'
                     AND bp NOT LIKE '%/%/%'
                     AND Charindex(Char(39), bp) < 1
 --Write a query to return patient name and encounter date and make sure it includes patients who have had no encounters, if any.  
 --For those, we should still see the name but no encounter date.

SELECT p.LastName+','+p.FirstName 'Name',
               e.Date 'Encounter Date'
FROM Patients p
LEFT JOIN Encounters e ON p.PatientID = e.PatientID
------------------------------------------------------------------
SELECT p.LastName+','+p.FirstName 'Patient Name',
	   e.Date 'Encounter Date',
	   f.Name 'Facility',
	   d.LastName+','+d.FirstName 'Provider Name',
	   e.VisitType 'Visit Type'
	   
FROM Patients p
JOIN Encounters e ON p.PatientID = e.PatientID
JOIN Facilities f ON e.FacilityID = f.FacilityID
JOIN Doctors d ON e.DoctorID = e.DoctorID
ORDER BY p.LastName,p.FirstName,e.Date
-------------------------------------------------------------------------
SELECT d.LastName+','+d.FirstName 'Provider',
	   COUNT(e.EncounterID) 'Number of Patients'
FROM Encounters e
JOIN Doctors d ON e.DoctorID = d.DoctorID
GROUP BY d.LastName,d.FirstName
-------------------------------------------------------------------------
SELECT p.LastName+','+p.FirstName 'Patient Name',
	   e.Date 'Date of Visit',
	   f.Name 'Facility',
	   d.LastName+','+d.FirstName 'Provider Name',
	   d.Specialty 'Provider Specialty'

FROM Patients p
JOIN Encounters e ON p.PatientID = e.PatientID
JOIN Facilities f ON e.FacilityID = f.FacilityID
JOIN Doctors d ON e.DoctorID = e.DoctorID
WHERE e.Date BETWEEN '2021-01-01' AND '2021-03-01'
GROUP BY p.LastName,p.FirstName,e.Date,f.Name,d.Specialty,d.LastName,d.FirstName

--Write a query to show the facility with the most encounters.

SELECT f.Name,
	   MAX(e.EncounterID) 'Encounters'
FROM Encounters e
JOIN Facilities f ON e.FacilityID = f.FacilityID
GROUP BY f.Name
ORDER BY MAX(e.EncounterID)

--Who is the oldest patient and how old are they in years?

SELECT LastName+','+FirstName'Patient',
	   (DATEDIFF(YEAR, DOB, GETDATE())) 'Age in Years'
FROM Patients
WHERE DOB = (SELECT MIN(DOB) FROM Patients) OR DOB = (SELECT MAX(DOB) FROM Patients)

--Write a query to select cardiology visits from the first of 2024 to the present day (regardless of what day the query is run).  
--Show patient name, date of visit, facility and provider.

SELECT p.LastName+','+p.FirstName 'Patient Name',
	   e.Date 'Date of Visit',
	   f.Name 'Facility Name',
	   d.LastName+','+d.FirstName 'Provider'
FROM Encounters e
JOIN Patients p ON e.PatientID = p.PatientID
JOIN Facilities f ON e.FacilityID = f.FacilityID
JOIN Doctors d ON e.DoctorID = e.DoctorID
WHERE d.Specialty LIKE 'Card%' AND e.Date BETWEEN '2024-01-01' AND GETDATE()

-- Create a temporary table that is available in any current SSMS session.  It should have the columns PatientID and Name).  
--Insert the following data into this temporary table:  99997, Elmo and  99998, Kermit the Frog and 99999, Miss Piggy.

--Now write a query to delete the Miss Piggy row from your temporary table.  
--Wrap this in a transaction. 
--Run it and then roll it back.

CREATE TABLE ##TempTable (PatientID Int, Name Varchar(50)) 
INSERT INTO ##TempTable VALUES (99997, 'Elmo')
INSERT INTO ##TempTable VALUES (99998, 'Kermit the Frog')
INSERT INTO ##TempTable VALUES (99999, 'Miss Piggy')

BEGIN TRAN 

DELETE FROM ##TempTable
WHERE PatientID = '99999'

--COMMIT TRAN
--ROLLBACK TRAN

SELECT * 
FROM ##TempTable
--Write a query that lists the numbers of patients in the age groups 0 - 1, 2 - 10, 11 - 20, over 20 (in years).

SELECT AgeGroup,
       COUNT(*) 'PatientCount'
FROM (SELECT 
			CASE 
			   WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 0 AND 1 THEN '0-1'
			   WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 2 AND 10 THEN '2-10'
			   WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 11 AND 20 THEN '11-20'
			   ELSE 'Over 20'
			END AS AgeGroup
      FROM Patients) AS PatientAgeGroups
GROUP BY AgeGroup;

--Is the facility that had the most visits on the first day of operations also the facility that has had the most visits overall?

SELECT f.Name,
	   MAX(e.EncounterID) 'Encounters',
	   MIN(e.Date) 'Date'
FROM Encounters e
JOIN Facilities f ON e.FacilityID = f.FacilityID
GROUP BY f.Name
ORDER BY MAX(e.EncounterID),MIN(e.Date) 

--Write a query to list patient id's of patients taking the medication Nicorette.  
--Save these patient id's to a temporary table that will be available to any query window in the current SSMS session. 
--Write another query that will list all patients by name and date of birth and make sure this data set excludes the patients in your Nicorette temporary table.

CREATE TABLE ##Nico (PatientID Int)
INSERT INTO ##Nico(PatientID)  (SELECT p.PatientID 
								FROM Patients p
								JOIN Medications m ON p.PatientID = m.PatientID
								WHERE m.MedName = 'Nicorette')

SELECT p.LastName+','+p.FirstName 'Patient Name',
	   p.DOB
FROM Patients p
JOIN ##Nico n ON p.PatientID = n.PatientID
WHERE p.PatientID NOT IN (n.PatientID)

--DELETE FROM ##Nico
--SELECT * FROM ##Nico

--Write a query to identify all blood pressures that are not valid because they don't contain a single backslash (/).

SELECT *
FROM BloodPressure
WHERE BP NOT LIKE '%/%'

--Write a query to identify all blood pressures that are either too long or too short.  
--A valid blood pressure contains 2 or 3 numbers, a backslash (/), and 2 or 3 numbers. 
--Include the patient name, date of visit, facility and provider.
SELECT p.LastName+','+p.FirstName 'Patient Name',
	   e.Date 'Date of Visit',
	   f.Name 'Facility Name',
	   d.LastName+','+d.FirstName 'Provider'
FROM Encounters e
JOIN Patients p ON e.PatientID = p.PatientID
JOIN Facilities f ON e.FacilityID = f.FacilityID
JOIN Doctors d ON e.DoctorID = d.DoctorID
JOIN BloodPressure b ON e.EncounterID = b.EncounterID
WHERE BP NOT LIKE '%/%'
               AND Len(bp) BETWEEN 5 AND 7
               AND bp NOT LIKE '%[A-Z, A-Z]%'
               AND Charindex('/', bp) BETWEEN 3 AND 4
               AND bp NOT LIKE '%.%'
               AND bp NOT LIKE '%/%/%'
               AND Charindex(Char(39), bp) < 1