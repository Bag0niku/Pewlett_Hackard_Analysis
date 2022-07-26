-- Employees expected to start retiring are born in 1952 to 1955, 
-- and started working with the company in 1985 to 1988.
SELECT *
INTO retirement_info
FROM employees
WHERE (birthdate BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
