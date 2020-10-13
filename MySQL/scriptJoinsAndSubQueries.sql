
/****************************************************************************************/
DROP TABLE IF EXISTS employees.departments_dup;
CREATE TABLE employees.departments_dup (dept_no CHAR(4) NULL , dept_name VARCHAR(40) NULL);
INSERT INTO employees.departments_dup (dept_no , dept_name) SELECT * FROM employees.departments;
INSERT INTO employees.departments_dup (dept_name) VALUES('Public Relations');
DELETE FROM employees.departments_dup WHERE dept_no = 'd002';
INSERT INTO employees.departments_dup(dept_no) VALUES ('d010') , ('d011'); 

/****************************************************************************************/
DROP TABLE IF EXISTS employees.dept_manager_dup;
CREATE TABLE employees.dept_manager_dup (emp_no INT(11) NOT NULL ,
dept_no CHAR(4) NULL ,
from_date DATE NOT NULL ,
to_date DATE NULL
);
INSERT INTO employees.dept_manager_dup SELECT * FROM employees.dept_manager;
INSERT INTO employees.dept_manager_dup (emp_no, from_date)
VALUES (999904 , '2017-01-01'),
(999905 , '2017-01-01'),
(999906 , '2017-01-01'),
(999907 , '2017-01-01');
DELETE FROM employees.dept_manager_dup WHERE dept_no = 'd001';

/****************************************************************************************/
DROP TABLE IF EXISTS employees.emp_manager;
CREATE TABLE employees.emp_manager(
emp_no INT(11) NOT NULL,
dept_no CHAR(4) NULL,
manager_no INT(11) NOT NULL
);


/********************************************JOINS****************************************/

/****************************************************************************************/
SELECT manager.dept_no , manager.emp_no , department.dept_name
FROM employees.dept_manager_dup manager
INNER JOIN employees.departments_dup department ON manager.dept_no = department.dept_no
ORDER BY manager.dept_no;

/****************************************************************************************/
SELECT m.emp_no , e.first_name , e.last_name , m.dept_no , e.hire_date
FROM employees.dept_manager m
INNER JOIN employees.employees e ON m.emp_no = e.emp_no
GROUP BY m.emp_no
ORDER BY m.emp_no;

/****************************************************************************************/
SELECT e.emp_no , e.first_name , e.last_name , m.dept_no , m.from_date
FROM employees.employees e
LEFT JOIN employees.dept_manager m ON e.emp_no = m.emp_no
WHERE e.last_name = "Markovitch"
ORDER BY m.dept_no DESC , e.emp_no;

/****************************************************************************************/
SELECT e.emp_no , e.first_name , e.last_name , e.hire_date , t.title
FROM employees.employees e
JOIN employees.titles t ON e.emp_no = t.emp_no
WHERE e.first_name = "Margareta"
AND e.last_name = "Markovitch"
ORDER BY e.emp_no;

/****************************************************************************************/
SELECT depman.* , dep.*
FROM employees.dept_manager depman
CROSS JOIN employees.departments dep
WHERE dep.dept_no = 'd009'
ORDER BY dep.dept_name;

/****************************************************************************************/
SELECT e.first_name , e.last_name , e.hire_date , t.title , dm.from_date , d.dept_name
FROM employees.employees e

JOIN employees.dept_manager dm ON e.emp_no = dm.emp_no

JOIN employees.departments d ON dm.dept_no = d.dept_no

JOIN employees.titles t ON e.emp_no = t.emp_no

WHERE t.title = "Manager"
ORDER BY e.emp_no;

/****************************************************************************************/
SELECT d.dept_name , ROUND(AVG(s.salary) , 0) AS average_salary
FROM employees.departments d

JOIN employees.dept_manager dm ON d.dept_no = dm.dept_no

JOIN employees.salaries s ON s.emp_no = dm.emp_no

GROUP BY d.dept_name
HAVING average_salary > 6000
ORDER BY average_salary ASC;

/****************************************************************************************/
SELECT e.gender AS Gender , COUNT(e.emp_no) AS Q
FROM employees.employees e

JOIN employees.dept_manager dm
ON dm.emp_no = e.emp_no

GROUP BY e.gender;

/****************************************************************************************/
SELECT *
FROM employees.dept_manager dm
WHERE dm.emp_no IN
(SELECT e.emp_no FROM employees.employees e WHERE e.hire_date BETWEEN "1990-01-01" AND "1995-01-01");

/****************************************************************************************/
SELECT *
FROM employees.employees e
WHERE EXISTS
	(SELECT * FROM employees.titles t
	WHERE e.emp_no = t.emp_no AND t.title = "Assistant Engineer");

/****************************************************************************************/
SELECT A.* FROM
	(SELECT e.emp_no AS employeeId , MAX(de.dept_no) AS departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110022) AS managerId 
	FROM employees.employees e

	JOIN employees.dept_emp de ON e.emp_no = de.emp_no

	WHERE e.emp_no <= 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no) AS A
UNION
SELECT B.* FROM
	(SELECT e.emp_no AS employeeId , MAX(de.dept_no) AS departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110039) AS managerId 
	FROM employees.employees e

	JOIN employees.dept_emp de ON e.emp_no = de.emp_no

	WHERE e.emp_no > 10020
	GROUP BY e.emp_no
	ORDER BY e.emp_no
    LIMIT 20) AS B;

/****************************************************************************************/
INSERT INTO employees.emp_manager SELECT U.* FROM
	(SELECT A.* FROM
		(SELECT e.emp_no AS employeeId , MAX(de.dept_no) as departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110022) AS managerId
		FROM employees.employees e
		JOIN employees.dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no <= 10020
		GROUP BY e.emp_no
		ORDER BY e.emp_no)
	AS A
	UNION
	SELECT B.* FROM
		(SELECT e.emp_no AS employeeId , MAX(de.dept_no) as departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110039) AS managerId
		FROM employees.employees e
		JOIN employees.dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no > 10020
		GROUP BY e.emp_no
		ORDER BY e.emp_no
        LIMIT 20)
	AS B
	UNION
	SELECT C.* FROM
		(SELECT e.emp_no AS employeeId , MAX(de.dept_no) as departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110039) AS managerId
		FROM employees.employees e
		JOIN employees.dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no = 110022
		GROUP BY e.emp_no)
	AS C
	UNION
	SELECT D.* FROM
		(SELECT e.emp_no AS employeeId , MAX(de.dept_no) as departmentCode , (SELECT dm.emp_no FROM employees.dept_manager dm WHERE dm.emp_no = 110022) AS managerId
		FROM employees.employees e
		JOIN employees.dept_emp de ON e.emp_no = de.emp_no
		WHERE e.emp_no = 110039 
		GROUP BY e.emp_no)
	AS D) 
AS U;