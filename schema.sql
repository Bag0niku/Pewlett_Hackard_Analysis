
-- Creating the tables for PH-EmployeeDB
CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL UNIQUE,
	dept_name VARCHAR(40) NOT NULL UNIQUE,
	PRIMARY KEY (dept_no)
);

CREATE TABLE employees (
	emp_no INT NOT NULL UNIQUE,
	birthdate DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR(4),
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(40),
	from_date DATE,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE  dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no, from_date) 
);   -- 

CREATE TABLE  salaries (
	emp_no INT NOT NULL,
	salary BIGINT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	Primary Key (emp_no, salary, from_date)
);

CREATE TABLE  dept_managers (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	From_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no, from_date)
);  -- 
