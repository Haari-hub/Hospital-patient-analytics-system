create database hospital_analytics;

# EXPLORING THE DATA

SELECT * FROM patients limit 5;
SELECT COUNT(*) FROM visits;
SELECT DISTINCT specialty FROM doctors;
SELECT DISTINCT COUNT(*) FROM patients;

#ANALYZING THE DATA FOR BUSINESS REQUIREMENT

# Patient Trends

SELECT gender,COUNT(*) AS total_patients
FROM patients
GROUP BY gender;

# Top Prescribed Drugs

SELECT drug_name,COUNT(*) AS prescriptions
FROM medications
GROUP BY drug_name ORDER BY prescriptions desc limit 10;

# Monthly visits

SELECT date_format(visit_date,'%y-%m') AS monthly,COUNT(*) AS total_visits
FROM visits
GROUP BY monthly ORDER BY monthly;

# No.of patients recieving by doctor

SELECT d.name , d.specialty , COUNT(v.visit_id) AS visit_count
FROM doctors d join visits v
ON d.doctor_id = v.doctor_id
GROUP BY d.name , d.specialty
ORDER BY visit_count desc;

# Finding Unpaid bills

SELECT payment_status , COUNT(*) AS total
FROM billings
GROUP BY payment_status HAVING payment_status = 'unpaid';

# Ranking the patients who visted most by month

SELECT patient_id , visit_date, RANK()
OVER (PARTITION BY patient_id ORDER BY visit_date) AS visit_rank
FROM visits;

# Readmission risky detection of patients

WITH cte AS(SELECT patient_id , visit_date ,
LEAD(visit_date) OVER(PARTITION BY patient_id ORDER BY visit_date) AS next_visit
FROM visits)

SELECT patient_id , visit_date AS discharge_date , next_visit AS readmitted_date,
                    DATEDIFF(next_visit , visit_date) AS days_between
                    FROM cte WHERE next_visit IS NOT NULL AND DATEDIFF(next_visit , visit_date) <= 30
                    ORDER BY patient_id , visit_date;

