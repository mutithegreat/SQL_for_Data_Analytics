WITH data_analyst_jobs AS(
    SELECT
        job_postings_fact.job_id,
        skills
    FROM
        job_postings_fact
    JOIN
        skills_job_dim
    ON  
        job_postings_fact.job_id = skills_job_dim.job_id
    JOIN
        skills_dim
    ON
        skills_dim.skill_id = skills_job_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
    )

SELECT
    COUNT(data_analyst_jobs.skills),
    data_analyst_jobs.skills
FROM
    data_analyst_jobs
GROUP BY
    data_analyst_jobs.skills
ORDER BY
    COUNT(data_analyst_jobs.skills) DESC
LIMIT 5;
