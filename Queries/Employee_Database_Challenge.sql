-- Job titles for potential retiries
SELECT e.emp_no, e.first_name, e.last_name, titles.title, titles.from_date, titles.to_date
INTO retirement_titles
FROM employees as e
JOIN titles ON e.emp_no = titles.emp_no
WHERE e.birthdate BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;


-- retirement_titles has duplicate entries for employees due to promotions and job changes. 
-- make them unique and only current employees, 
-- exported all columns except to_date because it was not needed for report, but is needed to filter and create the list
SELECT DISTINCT (emp_no), first_name, last_name, title, to_date
INTO unique_titles
FROM retirement_titles
WHERE (to_date= '9999-01-01')
ORDER BY to_date DESC, emp_no;


-- count of titles about to retire
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;


-- current employees that are eligable for the mentorship program are born in 1965
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
    e.first_name, e.last_name, e.birthdate, 
    de.from_date, de.to_date, titles.title
INTO mentorship_eligibility
FROM dept_emp AS de 
INNER JOIN employees as e ON e.emp_no = de.emp_no
INNER JOIN titles ON e.emp_no = titles.emp_no
WHERE (e.birthdate BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, titles.to_date DESC;


