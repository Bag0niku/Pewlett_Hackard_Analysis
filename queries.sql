

-- Employees that are expected to start retiring are born in 1952 to 1955, 
-- and started working with the company in 1985 to 1988.

-- All current employees
SELECT emp.*, de.dept_no
INTO current_emp
FROM employees AS emp
INNER JOIN dept_emp as de on de.emp_no = emp.emp_no
WHERE (de.to_date = '9999-01-01')
ORDER BY emp.emp_no;

-- Potential retiries with the company
SELECT ce.emp_no, ce.first_name, ce.last_name, ce.birthdate, ce.gender, ce.hire_date, de.dept_no, dept.dept_name 
INTO retirement_info
FROM dept_emp as de
INNER JOIN current_emp as ce ON ce.emp_no = de.emp_no
INNER JOIN departments as dept ON de.dept_no = dept.dept_no
WHERE (ce.birthdate BETWEEN '1952-01-01' AND '1955-12-31')
AND (ce.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count of potential retiries by department
SELECT COUNT(emp_no), dept_no
FROM retirement_info
GROUP BY dept_no
ORDER BY dept_no;

-- Current department managers
SELECT emp.emp_no, emp.first_name, emp.last_name, dm.dept_no, dept.dept_name, emp.hire_date, dm.to_date 
INTO current_managers
FROM dept_managers AS dm
INNER JOIN employees AS emp ON emp.emp_no = dm.emp_no
INNER JOIN departments AS dept ON dept.dept_no = dm.dept_no
WHERE dm.to_date='9999-01-01';

-- current employees info + salaries
SELECT ri.*, sal.salary
FROM  retirement_info AS ri
LEFT JOIN salaries AS sal ON sal.emp_no = ri.emp_no
ORDER BY ri.emp_no;

-- current retiring employees just in Sales Department 
SELECT emp_no, first_name, last_name, dept_name
FROM retirement_info
WHERE (dept_name= 'Sales')
ORDER BY dept_name;

-- Mentorship Program for retiring Sales and Development Departments only
SELECT emp_no, first_name, last_name, dept_name
FROM retirement_info
WHERE ((dept_name= 'Sales') OR (dept_name= 'Development'))
ORDER BY dept_name;