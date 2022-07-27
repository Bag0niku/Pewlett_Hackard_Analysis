-- Past and Current Employees that are expected to start retiring are born in 1952 to 1955, 
-- and started working with the company in 1985 to 1988, including their department and position.
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name, ti.title
INTO retirement_info
FROM dept_emp as de
INNER JOIN employees AS e ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
INNER JOIN titles AS ti ON ti.emp_no = de.emp_no
WHERE (de.to_date = ('9999-01-01'))
AND (ti.to_date = '9999-01-01')
AND (e.birthdate BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Potential retiries that are currently employed with the company and their info
SELECT ri.emp_no, ri.first_name, ri.last_name, ri.birthdate, ri.gender, ri.hire_date, de.dept_no, dept.dept_name 
INTO current_emp
FROM dept_emp as de
INNER JOIN retirement_info as ri ON ri.emp_no = de.emp_no
INNER JOIN departments as dept ON de.dept_no = dept.dept_no
WHERE (de.to_date = '9999-01-01');

-- Count of potential retiries by department
SELECT COUNT(emp_no), dept_no
FROM current_emp 
GROUP BY dept_no
ORDER BY dept_no;

-- Current department managers
SELECT emp.emp_no, emp.first_name, emp.last_name, dm.dept_no, dept.dept_name, emp.hire_date, dm.to_date 
INTO current_managers
FROM dept_managers AS dm
INNER JOIN employees AS emp ON emp.emp_no = dm.emp_no
INNER JOIN departments AS dept ON dept.dept_no = dm.dept_no
WHERE dm.to_date='9999-01-01';

-- current retiring employees info + salaries
SELECT ce.*, sal.salary
FROM current_emp AS ce
LEFT JOIN salaries AS sal ON sal.emp_no = ce.emp_no
ORDER BY ce.emp_no;

