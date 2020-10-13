SELECT ds.dept_name , e.gender , ROUND(AVG(s.salary) , 0) AS avg_salary
FROM employees_mod.t_salaries s
JOIN employees_mod.t_employees e ON s.emp_no = e.emp_no
JOIN employees_mod.t_dept_emp de ON e.emp_no = de.emp_no
JOIN employees_mod.t_departments ds ON de.dept_no = ds.dept_no
WHERE s.salary >= 1 AND s.salary <= 50000
GROUP BY ds.dept_name , e.gender
ORDER BY ds.dept_name;