SELECT 
    c.name,
    EXTRACT(quarter FROM j.job_posted_date) AS posting_quarter
FROM
    company_dim c
JOIN
    job_postings_fact j 
ON 
    c.company_id = j.company_id    
WHERE
    EXTRACT(quarter FROM j.job_posted_date) = 2
    AND
    j.job_health_insurance = TRUE;


--January Job Postings Table
CREATE TABLE january_jobs AS
SELECT 
    *
FROM
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 1;
--February Job Postings Table
CREATE TABLE february_jobs AS
SELECT 
    *
FROM
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 2;
--March Job Postings Table
CREATE TABLE march_jobs AS
SELECT 
    *
FROM        
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 3;
--April Job Postings Table
CREATE TABLE april_jobs AS
SELECT 
    *
FROM        
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 4;
--May Job Postings Table
CREATE TABLE may_jobs AS
SELECT 
    *
FROM        
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 5;
--June Job Postings Table
CREATE TABLE june_jobs AS
SELECT 
    *
FROM        
    job_postings_fact
WHERE
    EXTRACT(MONTH FROM job_posted_date) = 6;

select * from job_postings_fact limit 5;

SELECT
    job_title_short,
    CASE
        WHEN job_health_insurance = TRUE THEN 'Has Health Insurance'
        WHEN job_health_insurance = FALSE THEN 'Has No Health Insurance'
        ELSE 'No Desription Available'
    END AS health_insurance_status
FROM
    job_postings_fact;

SELECT
    COUNT(job_id) AS job_count,
    
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote Job'
        WHEN job_location = 'New York, NY' THEN 'Onsite Job'
        ELSE 'No Description Available'
        
    END AS job_location_category
FROM
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst'    
GROUP BY
    job_location_category
ORDER BY
    job_count DESC;

select
    count(salary_year_avg)
from
    job_postings_fact
where
    salary_year_avg IS NOT NULL;

SELECT
    
    CASE
        WHEN salary_year_avg < 50000 THEN 'Low Salary'
        WHEN salary_year_avg BETWEEN 50000 AND 100000 THEN 'Medium Salary'
        WHEN salary_year_avg > 100000 THEN 'High Salary'
        ELSE 'No Salary Info'
    END AS salary_range,
    COUNT(job_id) AS job_count
FROM
    job_postings_fact
where
    job_title_short = 'Data Analyst'    
GROUP BY
    salary_range
ORDER BY
    job_count DESC; 

WITH january_jobs_cte AS (
    SELECT 
        *
    FROM
        job_postings_fact
    WHERE
        EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT 
    COUNT(job_id) AS january_job_count
FROM
    january_jobs_cte;

select
    count(job_id)
from
    january_jobs;


SELECT
    company_id,
    name AS company_name
FROM
    company_dim
WHERE
    company_id IN (    

SELECT
    company_id
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = TRUE
ORDER BY 
    company_id);

WITH company_name_cte2 AS(
    SELECT
        company_id,
        COUNT(*) AS job_count
    FROM
        job_postings_fact
    GROUP BY 
    company_id
)

SELECT
    c.name AS company_name,
    company_name_cte2.job_count
FROM
    company_name_cte2
JOIN
    company_dim c
ON 
    company_name_cte2.company_id = c.company_id
ORDER BY
    company_name_cte2.job_count DESC;

SELECT
    c.name AS company_name,
    count(j.job_id) AS job_count
FROM
    job_postings_fact j
JOIN
    company_dim c
ON 
    j.company_id = c.company_id
GROUP BY
    c.name
ORDER BY
    job_count DESC;




SELECT
    skills_job_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS job_count
FROM
    skills_job_dim
JOIN
    skills_dim
ON
    skills_dim.skill_id = skills_job_dim.skill_id
JOIN
    job_postings_fact
ON
    skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_postings_fact.job_work_from_home = TRUE
    AND
    job_postings_fact.job_title_short = 'Data Analyst'
    AND
    skills_job_dim.skill_id IN 

(SELECT
    
    skill_id
FROM
    skills_job_dim
GROUP BY
    skill_id
    
ORDER BY
    COUNT(*) DESC
LIMIT 5)



GROUP BY
    skills_job_dim.skill_id,
    skills_dim.skills

    
ORDER BY
    job_count DESC;


SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
WHERE
job_title_short LIKE '%Data%'

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs
WHERE
    job_title_short LIKE '%Data%';


with first_quarter AS (
    select
        *
    from
        january_jobs
    UNION ALL
    select
        *
    from
        february_jobs
    UNION ALL
    select
        *
    from
        march_jobs
)
SELECT
    job_title_short,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM
    first_quarter
WHERE
    salary_year_avg > 70000
ORDER BY
    salary_year_avg DESC;

    