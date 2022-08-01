-- Job titles for potential retiries
SELECT e.emp_no, e.first_name, e.last_name, titles.title, titles.from_date, titles.to_date
INTO retirement_titles
FROM retirement_info as e  -- e is for list of employees
JOIN titles ON e.emp_no = titles.emp_no
ORDER BY e.emp_no;

-- retirement_titles has duplicate entries for employees due to promotions and job changes. 
-- make them unique and only current employees, 
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE (to_date= '9999-01-01')
ORDER BY emp_no, to_date DESC;

-- counting all positions retiring
SELECT COUNT (emp_no) as retiring, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY retiring DESC;

-- how is the retiring distributed accross the company?
SELECT DISTINCT ON (e.emp_no) e.*, titles.title
INTO rt_dept_titles
FROM retirement_info as e
JOIN titles ON e.emp_no = titles.emp_no
WHERE (titles.to_date= '9999-01-01')
ORDER BY e.emp_no, titles.to_date DESC;

SELECT COUNT (emp_no) as retiring, title, dept_name
INTO company_impact
FROM rt_dept_titles
GROUP BY title, dept_name
ORDER BY dept_name, retiring DESC;

-- current mentorship program requires employess born in 1965 or later.
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

-- who is expected to retire in the next wave, 5 years from now.
SELECT distinct on (e.emp_no) e.emp_no, e.first_name, e.last_name, 
        titles.title, d.dept_name
INTO retirement_next_5
FROM current_emp AS e
INNER JOIN departments as d ON e.dept_no = d.dept_no
INNER JOIN titles ON e.emp_no = titles.emp_no
WHERE (e.birthdate BETWEEN '1956-01-01' AND '1960-12-31')
ORDER BY e.emp_no, titles.to_date DESC;

-- Who is expected to retire in the another wave, 10 years from now.
SELECT distinct on (e.emp_no) e.emp_no, e.first_name, e.last_name, 
        titles.title, d.dept_name 
INTO retirement_next_10
FROM current_emp as e
INNER JOIN departments AS d ON e.dept_no = d.dept_no
INNER JOIN titles ON e.emp_no = titles.emp_no
WHERE (e.birthdate BETWEEN '1961-01-01' AND '1965-12-31')
ORDER BY e.emp_no, titles.to_date DESC;

-- count of the next wave of retiries, 5 years from now.
SELECT COUNT (emp_no) AS n5,
	title, dept_name
INTO rt_next_5
FROM retirement_next_5
GROUP BY title, dept_name
ORDER BY dept_name, n5 DESC;

-- count of the wave of retiries, 10 years from now.
SELECT COUNT (emp_no) AS n10,
	title, dept_name
INTO rt_next_10
FROM retirement_next_10
GROUP BY title, dept_name
ORDER BY dept_name;


-- ========================================


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



Select * from retirement_next_10;





-- count of vacant positions from retiring emplyees, 5 year intervals
Select distinct on (r5.title, ci.dept_name) 
    ci.retiring as now, r5.n5, r10.n10, r5.title, ci.dept_name
from company_impact as rt
full join rt_next_5 as r5 on (ci.title, ci.dept_name)= (r5.title, r5.dept_name)
full join rt_next_10 as r10 on (ci.title, ci.dept_name)= (r10.title, r10.dept_name)
ORDER BY ci.dept_name;

-- checking for positions not having new vacancies every wave
Select *
from rt_next_5
where ((title, dept_name) not in (select title, dept_name from company_impact))
or ((title, dept_name) not in (select title, dept_name from rt_next_10));

Select *
from rt_next_10
where ((title, dept_name) not in (select title, dept_name from company_impact))
or ((title, dept_name) not in (select title, dept_name from rt_next_5));

Select *
from company_impact
where ((title, dept_name) not in (select title, dept_name from rt_next_5))
or ((title, dept_name) not in (select title, dept_name from rt_next_10));

-- Not enough mentors are eligable for the mentorship program, what if the pool of potentail eligible candidates was expanded?
select mp.retiring, r10.n10, mp.mentorship, mp.mentor_title, mp.dept_name 
from mentor_program as mp
full join rt_next_10 as r10 on (mp.mentor_title, mp.dept_name) = (r10.title, r10.dept_name);

