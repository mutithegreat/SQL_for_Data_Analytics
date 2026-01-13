
/*
Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

-- Identifies skills in high demand for Data Analyst roles
-- Use Query #3

WITH skills_demand AS(

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
        WHERE 
            job_title_short = 'Data Analyst' AND
            salary_year_avg IS NOT NULL AND
            job_work_from_home = TRUE
        )

    SELECT
        COUNT(data_analyst_jobs.skills) AS demand_count,
        data_analyst_jobs.skills
    FROM
        data_analyst_jobs
    GROUP BY
        data_analyst_jobs.skills
    
) , avarage_pay AS
(
    SELECT
        skills,
        ROUND(AVG(salary_year_avg),0) AS avarage_salary
        
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE

    GROUP BY
        skills
 

)

SELECT
    skills_demand.skills,
    demand_count,
    avarage_salary
FROM
    skills_demand
INNER JOIN
    avarage_pay
ON
    skills_demand.skills = avarage_pay.skills
ORDER BY avarage_salary DESC,demand_count DESC
LIMIT 25;