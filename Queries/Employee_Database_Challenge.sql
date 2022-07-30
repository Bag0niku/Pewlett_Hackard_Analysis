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


-- Breakdown of job titles and departments of mentorship eligiable employees.
SELECT count(me.emp_no) AS mentorship,
    me.title AS mentor_title,	d.dept_name as mentor_dept
INTO mentor_titles
FROM dept_emp as de
INNER JOIN mentorship_eligibility AS me on de.emp_no = me.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
GROUP BY mentor_title, d.dept_name
ORDER BY d.dept_name, mentor_title;


-- counting retiring job titles by department
SELECT COUNT(emp_no) AS retiring, 
    title AS rt_title, 
	dept_name AS rt_dept
INTO retiring_titles
FROM retirement_titles
GROUP BY rt_title, rt_dept 
ORDER BY rt_dept, rt_title;

-- comparing eligible mentors to retires
Select rt.retiring, mt.mentorship, mt.mentor_title, rt.rt_dept
INTO mentor_prog
from mentor_titles as mt
Left join retiring_titles as rt on rt.rt_dept=mt.mentor_dept
where ((mt.mentor_title, mt.mentor_dept) = (rt.rt_title, rt.rt_dept))
ORDER BY rt.rt_dept;


-- retiring Positions with no mentors eligible 
Select *
from retiring_titles
where (rt_title, rt_dept) not in (select mentor_title, mentor_dept from mentor_titles);
