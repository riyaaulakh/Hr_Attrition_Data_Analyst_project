SELECT * FROM hr_table LIMIT 10;


/* 1.What is the overall attrition rate across the company?*/
SELECT 
    (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 
     / COUNT(*)) * 100 AS overall_attrition_rate
FROM hr_table;


/*2.Which department has the highest attrition rate?*/

select department,((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 
     / COUNT(*)) * 100 ) as attrition_rate
from hr_table
group by department
order by attrition_rate desc
limit 1;

/* 3 Does working overtime affect the attrition rate? Compare attrition % for employees who work overtime vs those who don't.*/
select overtime,((COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 
     / COUNT(*)) * 100 ) as attrition_rate from hr_table
group by overtime

/*4. Which job roles have the highest average monthly income?*/
select jobrole,avg(monthlyincome) as avg_monthincome from hr_table
group by jobrole
order by avg_monthincome desc
limit 1

/*5.How does attrition rate vary across different age groups?*/
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    COUNT(*) AS total_employees,
    (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) * 100 AS attrition_rate
FROM hr_table
GROUP BY age_group
ORDER BY age_group;

/*6.Is there a relationship between job satisfaction level and attrition?*/
SELECT 
    jobsatisfaction,
    (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 
     / COUNT(*)) * 100 AS attrition_rate
FROM hr_table
GROUP BY jobSatisfaction
ORDER BY jobSatisfaction;

/*7.Do employees with higher performance ratings actually get higher salary hikes?*/
SELECT 
    CASE performanceRating
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Average'
        WHEN 3 THEN 'Good'
        WHEN 4 THEN 'Outstanding'
    END AS rating_label,
    AVG(percentSalaryHike) AS avg_salary_hike
FROM hr_table
GROUP BY performanceRating
ORDER BY performanceRating;

/*8.Does the number of years since an employee's last promotion affect their likelihood of leaving?*/
select totalworkingyears,avg(worklifebalance) as avg_worklifebalance from hr_table
group by totalworkingyears
order by totalworkingyears

/*9.Within each department, rank job roles by their attrition rate to find the riskiest roles.*/
SELECT 
    department,
    jobRole,
    (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 
     / COUNT(*)) * 100 AS attrition_rate,
    RANK() OVER (PARTITION BY department ORDER BY 
                 (COUNT(CASE WHEN attrition = 'Yes' THEN 1 END) * 1.0 / COUNT(*)) DESC) AS role_rank
FROM hr_table
GROUP BY department, jobRole
ORDER BY department, role_rank;

/*10.Segment employees into High/Medium/Low attrition risk categories based on a combination of factors (overtime, job satisfaction, tenure) — which employees should HR prioritize for retention?*/
SELECT
    jobrole,
    overtime,
    jobsatisfaction,
    yearsatcompany,
    CASE 
        WHEN overtime = 'Yes' 
             AND jobsatisfaction <= 2 
             AND yearsatcompany < 3 
        THEN 'High Risk'
        
        WHEN (overTime = 'Yes' AND jobsatisfaction = 3) 
             OR (yearsatcompany BETWEEN 3 AND 6) 
        THEN 'Medium Risk'
        
        ELSE 'Low Risk'
    END AS attrition_risk_category
FROM hr_table;

