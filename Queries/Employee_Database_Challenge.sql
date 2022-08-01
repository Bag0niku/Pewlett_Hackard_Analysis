
-- Mentorship Program for retiring Sales and Development Departments only
SELECT DISTINCT (ri.emp_no), ri.first_name, ri.last_name, ri.dept_name, titles.title, titles.to_date
INTO mentor_prog
FROM retirement_info AS ri
INNER JOIN titles ON titles.emp_no = ri.emp_no
WHERE ((ri.dept_name= 'Sales') OR (ri.dept_name= 'Development'))
ORDER BY titles.to_date DESC, ri.emp_no;

-- count of positions eligable for the mentorship program occupied by retiries
SELECT COUNT (emp_no), title
FROM mentor_prog
GROUP BY title
ORDER BY title;

-- Job titles for potential retiries
SELECT e.emp_no, e.first_name, e.last_name, titles.title, titles.from_date, titles.to_date
INTO retirement_titles
FROM current_emp as e
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

-- how is the retiring distributed accross the company?
SELECT COUNT (emp_no) as retiring, title, dept_name
INTO company_impact
FROM unique_titles
GROUP BY title, dept_name
ORDER BY dept_name, retiring DESC;

-- current employees that are eligable for the mentorship program are born in 1965
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
    e.first_name, e.last_name, e.birthdate, 
    de.from_date, de.to_date, titles.title
INTO mentorship_eligibility
FROM dept_emp AS de 
INNER JOIN current_emp as e ON e.emp_no = de.emp_no
INNER JOIN titles ON e.emp_no = titles.emp_no
WHERE (e.birthdate BETWEEN '1965-01-01' AND '1965-12-31')
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


-- comparing eligible mentors to retires
Select distinct on (rt.title, rt.dept_name) rt.retiring, 
    mt.mentorship, mt.mentor_title, rt.dept_name
INTO mentor_program
from mentor_titles as mt
full join company_impact as rt on (mt.mentor_title, mt.mentor_dept) = (rt.title, rt.dept_name)
ORDER BY rt.dept_name;

-- retiring Positions with no mentors eligible 
Select *
from retiring_titles
where (rt_title, rt_dept) not in (select mentor_title, mentor_dept from mentor_titles);


-- who is expected to retire in the next wave, 5 years from now.
SELECT distinct on (e.emp_no) e.emp_no, e.first_name, e.last_name, titles.title, d.dept_name 
INTO retirement_next_5
FROM dept_emp as de
INNER JOIN employees AS e ON e.emp_no = de.emp_no
INNER JOIN titles ON e.emp_no = titles.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no
WHERE (e.birthdate BETWEEN '1956-01-01' AND '1960-12-31')
AND (de.to_date= '9999-01-01')
ORDER BY e.emp_no, titles.to_date DESC;


-- Who is expected to retire in the another wave, 10 years from now.
SELECT distinct on (e.emp_no) e.emp_no, e.first_name, e.last_name, titles.title, d.dept_name 
INTO retirement_next_10
FROM dept_emp as de
INNER JOIN employees AS e ON e.emp_no = de.emp_no
INNER JOIN titles ON e.emp_no = titles.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no
WHERE (e.birthdate BETWEEN '1961-01-01' AND '1965-12-31')
AND (de.to_date= '9999-01-01')
ORDER BY e.emp_no, titles.to_date DESC;


Select * from retirement_next_10;

-- count of the next wave of retiries, 5 years from now.
select count(emp_no) as n5,
	title, dept_name
into rt_next_5
from retirement_next_5
GROUP BY title, dept_name
ORDER BY dept_name;

-- count of the wave of retiries, 10 years from now.
select count(emp_no) as n10,
	title, dept_name
into rt_next_10
from retirement_next_10
GROUP BY title, dept_name
ORDER BY dept_name;


-- count of vacant positions from retiring emplyees, 5 year intervals
Select distinct on (r5.title, rt.rt_dept) 
    rt.retiring as now, r5.n5, r10.n10, r5.title, rt.rt_dept
from retiring_titles as rt
full join rt_next_5 as r5 on (rt.rt_title, rt.rt_dept)= (r5.title, r5.dept_name)
full join rt_next_10 as r10 on (rt.rt_title, rt.rt_dept)= (r10.title, r10.dept_name)
ORDER BY rt.rt_dept;

-- checking for positions not having new vacancies every wave
Select *
from rt_next_5
where ((title, dept_name) not in (select rt_title, rt_dept from retiring_titles))
or ((title, dept_name) not in (select title, dept_name from rt_next_10));

Select *
from rt_next_10
where ((title, dept_name) not in (select rt_title, rt_dept from retiring_titles))
or ((title, dept_name) not in (select title, dept_name from rt_next_5));

Select *
from retiring_titles
where ((rt_title, rt_dept) not in (select title, dept_name from rt_next_5))
or ((rt_title, rt_dept) not in (select title, dept_name from rt_next_10));

-- Not enough mentors are eligable for the mentorship program, what if the pool of potentail eligible candidates was expanded?
select mp.retiring, r10.n10, mp.mentorship, mp.mentor_title, mp.rt_dept 
from mentor_prog as mp
full join rt_next_10 as r10 on (mp.mentor_title, mp.rt_dept) = (r10.title, r10.dept_name);