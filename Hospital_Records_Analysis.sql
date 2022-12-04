-- Example of SQl queries written for use on a patient, doctors and admission records. 
-- Tables names as:
-- patients (4530 rows, 10 cols)
-- admissions (5067 rows, 5 cols)
-- doctors (27 rows, 4 cols)

-- Sorting patients into weight groups and showing the totals of each
SELECT COUNT(*) AS patient_group,
FLOOR(weight/10) * 10 AS weightgroup
FROM patients
group by weightgroup
order by weightgroup DESC;

-- Showing if patients are obese or not
SELECT patient_id, weight, height, case when weight/power(height/100.0,2) >=30 THEN 1 ELSE 0 end AS IsObese
FROM patients;

-- Showing only the patients who have a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa' as well as patients name and doctor
SELECT patients.patient_id, patients.first_name, patients.last_name, doctors.specialty
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
WHERE admissions.diagnosis = 'Epilepsy' AND doctors.first_name =  'Lisa';

-- Creating a password for patients 
SELECT DISTINCT patients.patient_id, concat(patients.patient_id, LEN(patients.last_name), YEAR(patients.birth_date))
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id;

-- Identifying total patients with insurance (all patients with an even patient_id have insurance) and admission costs (50 for without insurance and 10 with insurance)
SELECT 
(CASE WHEN admissions.patient_id % 2 = 0 THEN 'Yes'
	ELSE 'No'
    END) AS has_insurance,
SUM(CASE wheN admissions.patient_id % 2 = 0 THEN 10
    ELSE 50
    END) AS admission_cost
FROM admissions
group by has_insurance;

-- Looking for a specific patient
SELECT * FROM patients
where first_name LIKE '__r%'
AND gender = 'F'
AND MONTH(birth_date) IN (02,05,12)
AND weight between 60 AND 80
AND patient_id % 2 = 1
AND CITY =  'Kingston';

-- Showing the percent of patients that have 'M' as their gender. Rounded the answer to the nearest hundreth number and in percent form.
SELECT concat(ROUND(
    (SELECT COUNT(*)
	FROM patients
	where gender = 'M')/
  	(cast (COUNT(*) AS float)), 4) * 100.0, '%')
from patients;

-- Displaying the total amount of admissions on that day. Also the amount changed from the previous date.
SELECT distinct admission_date as adm, count(admission_date), count(admission_date) - lag(count(admission_date), 1) over() AS 'change' 
FROM admissions
GROUP BY adm
ORDER BY admission_date asc
