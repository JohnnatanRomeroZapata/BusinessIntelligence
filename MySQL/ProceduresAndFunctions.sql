USE employees;

/*
DROP PROCEDURE IF EXISTS averageSalary;
DELIMITER $$
CREATE PROCEDURE averageSalary()

BEGIN
	SELECT e.emp_no AS EmployeeId , e.first_name AS FirstName , e.last_name AS LastName , e.gender AS Gender , ROUND(AVG(s.salary)) AS Salary
    FROM employees.employees e
    JOIN employees.salaries s ON e.emp_no = s.emp_no
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 10;
END$$
DELIMITER ;
CALL averageSalary();
*/

/*
DROP PROCEDURE IF EXISTS oneEmployeeAverageSalary;
DELIMITER $$
CREATE PROCEDURE oneEmployeeAverageSalary(IN pNoEmployee INTEGER)

BEGIN

	SELECT e.emp_no AS EmployeeCode , e.first_name AS FirstName , e.last_name AS LastName , e.gender AS Gender , ROUND(AVG(s.salary)) AS Salary
    FROM employees.employees e
    JOIN employees.salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = pNoEmployee;
    
END$$
DELIMITER ;
*/


DROP FUNCTION IF EXISTS fEmployeeAverageSalary;
DELIMITER $$
CREATE FUNCTION fEmployeeAverageSalary(pNoEmployee INTEGER) RETURNS DECIMAL
DETERMINISTIC NO SQL READS SQL DATA
BEGIN

    DECLARE vEmployeeSalary DECIMAL;
    
    SELECT ROUND(AVG(s.salary)) AS Salary
    INTO vEmployeeSalary
    FROM employees.employees e
    JOIN employees.salaries s ON e.emp_no = s.emp_no
    WHERE e.emp_no = pNoEmployee;
	
    RETURN vEmployeeSalary;
    
END$$
DELIMITER ;

SELECT fEmployeeAverageSalary(11300);