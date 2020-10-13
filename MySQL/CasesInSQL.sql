SELECT e.emp_no , e.first_name , e.last_name , (MAX(s.salary) - MIN(s.salary)) AS SalaryDiference ,
	CASE
		WHEN (MAX(s.salary) - MIN(s.salary)) > 30000 THEN "Salary raised by more than $30.000"
		WHEN (MAX(s.salary) - MIN(s.salary)) BETWEEN 20000 AND 30000 THEN "Salary raised by more than $20.000 but less than $30.000"
		ELSE "Salary raised by less than $20.000"
	END AS SalaryIncrease
FROM employees.employees e
JOIN employees.salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

SELECT  e.emp_no , e.first_name , e.last_name , 
	CASE
		WHEN e.emp_no = dm.emp_no THEN "YES"
        ELSE "NO"
	END AS Manager
FROM employees.employees e
LEFT JOIN employees.dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990;

SELECT e.emp_no , e.first_name , e.last_name , (MAX(s.salary) - MIN(s.salary)) AS SalaryDiference,
	CASE
		WHEN (MAX(s.salary) - MIN(s.salary)) > 30000 THEN "Salary raised by more than $30.000"
        ELSE "Salary NOT raised by more than $30.000"
	END AS SalaryRaise
FROM employees.employees e
JOIN employees.salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no;

SELECT e.emp_no , e.first_name , e.last_name , de.to_date ,
	CASE
		WHEN de.to_date > sysdate() THEN "YES"
        ELSE "NO"
	END AS IsStillWorkin
FROM employees.employees e
JOIN employees.dept_emp de ON e.emp_no = de.emp_no
GROUP BY e.emp_no
LIMIT 100;