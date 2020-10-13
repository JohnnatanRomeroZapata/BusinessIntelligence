/* Compare the number of male managers to the number of female managers from different departments for each year, starting from 1990.*/

SELECT d.dept_name , e3.gender , e3.emp_no , dm.from_date , dm.to_date , e2.Year , 
	CASE
		WHEN YEAR(dm.from_date) <= e2.Year AND YEAR(dm.to_date) >= e2.Year THEN 1 ELSE 0
	END AS Active
FROM 
(SELECT YEAR(e1.hire_date) AS Year
	FROM employees_mod.t_employees e1
    GROUP BY Year) e2
	CROSS JOIN employees_mod.t_dept_manager dm
	JOIN employees_mod.t_departments d ON dm.dept_no = d.dept_no
	JOIN employees_mod.t_employees e3 ON dm.emp_no = e3.emp_no
    ORDER BY dm.emp_no , Year;