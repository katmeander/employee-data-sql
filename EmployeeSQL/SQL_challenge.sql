-- Add the tables from the csv files

CREATE TABLE "Titles" (
    "TitleID" varchar(10) NOT NULL,
    "Title" varchar(30) NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "TitleID"
     )
);
SELECT * FROM Titles;

CREATE TABLE "Employees" (
    "EmpNo" int NOT NULL,
    "TitleID" varchar(10) NOT NULL,
    "BirthDate" date NOT NULL,
    "FirstName" varchar(30) NOT NULL,
    "LastName" varchar(30) NOT NULL,
    "Sex" varchar(30) NOT NULL,
    "HireDate" date NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "EmpNo"
     )
);

CREATE TABLE "Departments" (
    "DeptNo" varchar(10) NOT NULL,
    "DeptName" varchar(30) NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "DeptNo"
     )
);

CREATE TABLE "DeptManager" (
    "DeptNo" varchar(10) NOT NULL,
    "EmpNo" int NOT NULL
);

CREATE TABLE "DeptEmp" (
    "EmpNo" int NOT NULL,
    "DeptNo" varchar(10) NOT NULL
);

CREATE TABLE "Salaries" (
    "EmpNo" int NOT NULL,
    "Salary" varchar(10) NOT NULL
);

ALTER TABLE "Employees" ADD CONSTRAINT "fk_Employees_TitleID" FOREIGN KEY("TitleID")
REFERENCES "Titles" ("TitleID");

ALTER TABLE "DeptManager" ADD CONSTRAINT "fk_DeptManager_DeptNo" FOREIGN KEY("DeptNo")
REFERENCES "Departments" ("DeptNo");

ALTER TABLE "DeptManager" ADD CONSTRAINT "fk_DeptManager_EmpNo" FOREIGN KEY("EmpNo")
REFERENCES "Employees" ("EmpNo");

ALTER TABLE "DeptEmp" ADD CONSTRAINT "fk_DeptEmp_EmpNo" FOREIGN KEY("EmpNo")
REFERENCES "Employees" ("EmpNo");

ALTER TABLE "DeptEmp" ADD CONSTRAINT "fk_DeptEmp_DeptNo" FOREIGN KEY("DeptNo")
REFERENCES "Departments" ("DeptNo");

ALTER TABLE "Salaries" ADD CONSTRAINT "fk_Salaries_EmpNo" FOREIGN KEY("EmpNo")
REFERENCES "Employees" ("EmpNo");

-- List all employees name, gender, and salary
SELECT "Employees"."EmpNo", "Employees"."FirstName", "Employees"."LastName", "Employees"."Sex", "Salaries"."Salary" 
FROM "Employees"
INNER JOIN "Salaries" on "Salaries"."EmpNo" = "Employees"."EmpNo"

-- change datatype date to varchar
ALTER TABLE "Employees"
ALTER COLUMN "HireDate" TYPE varchar;

ALTER TABLE "Employees"
ALTER COLUMN "BirthDate" TYPE varchar;

-- Use a wildcard to find all employees hired in 1986
SELECT "Employees"."FirstName", "Employees"."LastName", "Employees"."HireDate"
FROM "Employees"
WHERE "HireDate" Like '1986%';

-- List the manager name and employee number for each department
SELECT "Departments"."DeptNo", "Departments"."DeptName", 
	"Employees"."EmpNo", "Employees"."FirstName", "Employees"."LastName"
FROM "Employees"
LEFT JOIN "DeptManager" on "DeptManager"."EmpNo" = "Employees"."EmpNo"
INNER JOIN "Departments" on "Departments"."DeptNo" = "DeptManager"."DeptNo";

-- List the each employee, include name, number, department no. and name.
SELECT "DeptEmp"."DeptNo", "Departments"."DeptName", 
	"Employees"."EmpNo", "Employees"."FirstName", "Employees"."LastName"
FROM "Employees"
INNER JOIN "DeptEmp" on "DeptEmp"."EmpNo" = "Employees"."EmpNo" 
INNER JOIN "Departments" on "Departments"."DeptNo" = "DeptEmp"."DeptNo";

-- List the name and sex of employees whose first name is 'Hercules' and last
-- name starts with 'B'
SELECT "Employees"."FirstName", "Employees"."LastName", "Employees"."Sex"
FROM "Employees"
WHERE 
	"FirstName" = 'Hercules'
	And "LastName" Like 'B%';

-- Lookup employees whose department No is Sales, List their employee number,
-- first and last name
SELECT "Employees"."EmpNo", "Employees"."FirstName", "Employees"."LastName",
"Departments"."DeptName"
FROM "Employees"
INNER JOIN "DeptEmp" on "DeptEmp"."EmpNo" = "Employees"."EmpNo"
INNER JOIN "Departments" on "Departments"."DeptNo" = "DeptEmp"."DeptNo"
WHERE "DeptName" = 'Sales';

-- list employee number, last and first name and department name. Create a join
-- between DeptEmp and Departments tables to get the Department names. Only 
-- list those in Sales and Development
SELECT "Employees"."EmpNo", "Employees"."FirstName", "Employees"."LastName",
"Departments"."DeptName"
FROM "Employees"
INNER JOIN "DeptEmp" on "DeptEmp"."EmpNo" = "Employees"."EmpNo"
INNER JOIN "Departments" on "Departments"."DeptNo" = "DeptEmp"."DeptNo"
WHERE "DeptName" IN ('Sales', 'Development');

--List the frequency counts, descending of all employees with the same last name
SELECT "Employees"."LastName", COUNT("LastName") AS "Number Duplicate Last Names"
FROM "Employees"
GROUP BY "LastName"
HAVING COUNT("LastName") > 1
ORDER BY COUNT("LastName") DESC;

