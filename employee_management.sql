-- Create Database
CREATE DATABASE employee_db;
USE employee_db;

-- Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

-- Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Salaries Table
CREATE TABLE salaries (
    salary_id INT PRIMARY KEY,
    emp_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Attendance Table
CREATE TABLE attendance (
    att_id INT PRIMARY KEY,
    emp_id INT,
    att_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Employee Status Table
CREATE TABLE employee_status (
    emp_id INT PRIMARY KEY,
    status VARCHAR(20),
    last_working_day DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Insert Data
INSERT INTO departments VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance');

INSERT INTO employees VALUES
(101,'Ravi','ravi@gmail.com','2023-01-10',1),
(102,'Anu','anu@gmail.com','2023-02-15',2),
(103,'Sai','sai@gmail.com','2023-03-01',2);

INSERT INTO salaries VALUES
(1,101,50000),
(2,102,60000),
(3,103,55000);

-- Join Query
SELECT e.emp_name, d.dept_name
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id;

-- Subquery
SELECT emp_id, salary
FROM salaries
WHERE salary > (SELECT AVG(salary) FROM salaries);

-- Trigger
DELIMITER $$

CREATE TRIGGER trg_employee_left
BEFORE UPDATE ON employee_status
FOR EACH ROW
BEGIN
    IF OLD.status <> 'LEFT' AND NEW.status = 'LEFT' THEN
        SET NEW.last_working_day = CURDATE();
    END IF;
END$$

DELIMITER ;

-- Stored Procedure
DELIMITER $$

CREATE PROCEDURE increase_salary (
    IN p_emp_id INT,
    IN p_percent DECIMAL(5,2)
)
BEGIN
    UPDATE salaries
    SET salary = salary + (salary * p_percent / 100)
    WHERE emp_id = p_emp_id;
END$$

DELIMITER ;

