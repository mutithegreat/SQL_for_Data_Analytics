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