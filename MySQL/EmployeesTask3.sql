/* Compare the average salary of female versus male employees in the entire company until year 2002, and add a filter allowing you to see that per each department. */

SELECT e.gender , ds.dept_name , ROUND(AVG(s.salary) , 0) AS Avg_Salary , YEAR(s.from_date) AS year_salary_from
FROM employees_mod.t_salaries s
JOIN employees_mod.t_employees e ON s.emp_no = e.emp_no
JOIN employees_mod.t_dept_emp de ON e.emp_no = de.emp_no
JOIN employees_mod.t_departments ds ON de.dept_no = ds.dept_no
GROUP BY e.gender , ds.dept_name , year_salary_from
HAVING year_salary_from <= 2002
ORDER BY ds.dept_name ASC;