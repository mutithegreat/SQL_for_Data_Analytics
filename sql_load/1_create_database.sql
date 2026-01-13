CREATE DATABASE sql_course;

-- DROP DATABASE IF EXISTS sql_course;
WITH jobs AS(
SELECT 
    skill_id,
    COUNT(*) AS job_count
FROM 
    skills_job_dim
JOIN 
    job_postings_fact
ON 
    job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_work_from_home = True AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY 
    skill_id
ORDER BY
    job_count DESC
LIMIT 
    5)

SELECT 
    jobs.skill_id,
    skills_dim.skills,
    job_count
FROM 
    jobs
JOIN
    skills_dim
ON
    skills_dim.skill_id = jobs.skill_id
ORDER BY job_count DESC
;

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs
UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    february_jobs
UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM
    march_jobs;

SELECT 
    *
FROM 
    job_postings_fact,
    EXTRACT(QUARTER FROM job_posted_date) AS Quarter
WHERE 
    salary_year_avg > 70000 AND
    Quarter = 1;

SELECT DISTINCT(skills) FROM skills_dim
ORDER BY skills;

SELECT * FROM skills_job_dim;


WITH first_quarter AS(
SELECT
    *
FROM
    january_jobs

UNION ALL

SELECT
    *
FROM
    february_jobs

UNION ALL

SELECT
    *
FROM
    march_jobs)
SELECT
    first_quarter.job_title_short,
    first_quarter.job_location,
    first_quarter.job_via,
    first_quarter.job_posted_date::DATE,
    first_quarter.salary_year_avg
FROM
    first_quarter
WHERE 
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;

SELECT  
    job_id,
    job_title,
    c.name AS firm_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact as j
JOIN
    company_dim AS c
ON 
    c.company_id = j.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
ORDER BY 
    salary_year_avg DESC
LIMIT 10;

