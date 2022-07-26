-- Current Employees that are expected to start retiring are born in 1952 to 1955, 
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
