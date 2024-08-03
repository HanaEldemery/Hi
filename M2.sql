--2 1 1
CREATE DATABASE Advising_Team_108
DROP DATABASE Advising_Team_108

--2 1 2
CREATE FUNCTION status
(@StudentID INT)
RETURNS BIT
AS 
begin
DECLARE @O BIT
DECLARE @currdate DATETIME = CURRENT_TIMESTAMP
DECLARE @countfato INT 
DECLARE @payid INT
SELECT @payid=payment_id
from payment
where student_id=@StudentID
select @countfato=count(payment_id)
from Installment 
where payment_id=@payid AND @currdate>deadline and status='notPaid'
if @countfato>0--blocked
begin
SET @O='0'
end
else
begin
SET @O='1'
end
RETURN @O
end

CREATE PROC CreateAllTables

AS

CREATE TABLE Instructor(
instructor_id INT PRIMARY KEY IDENTITY,
name VARCHAR(40),
email VARCHAR(40),
faculty VARCHAR(40),
office VARCHAR(40)
)

CREATE TABLE Advisor(
advisor_id INT PRIMARY KEY IDENTITY,
name VARCHAR(40),
email VARCHAR(40),
office VARCHAR(40),
password VARCHAR(40)
)

CREATE TABLE Student(
student_id INT PRIMARY KEY IDENTITY,
f_name VARCHAR(40),
l_name VARCHAR(40),
gpa DECIMAL(10,2),
faculty VARCHAR(40),
email VARCHAR(40),
major VARCHAR(40),
password VARCHAR(40),
financial_status BIT,
semester INT,
acquired_hours INT,
assigned_hours INT,
advisor_id INT,
CONSTRAINT cons1
FOREIGN KEY (advisor_id) REFERENCES Advisor
)

CREATE TABLE Student_Phone(
student_id INT,
phone_number VARCHAR(40),
PRIMARY KEY (student_id, phone_number),
CONSTRAINT cons2
FOREIGN KEY (student_id) REFERENCES Student
)

CREATE TABLE Course(
course_id INT PRIMARY KEY IDENTITY,
name VARCHAR(40),
major VARCHAR(40),
is_offered BIT,
credit_hours INT,
semester INT
)

CREATE TABLE PreqCourse_course(
prerequisite_course_id INT,
course_id INT,
PRIMARY KEY (prerequisite_course_id, course_id),
CONSTRAINT cons3
FOREIGN KEY (prerequisite_course_id) REFERENCES Course,
CONSTRAINT cons4
FOREIGN KEY (course_id) REFERENCES Course
)

CREATE TABLE Instructor_Course(
course_id INT,
instructor_id INT,
PRIMARY KEY (course_id, instructor_id),
CONSTRAINT cons5
FOREIGN KEY (course_id) REFERENCES Course,
CONSTRAINT cons6
FOREIGN KEY (instructor_id) REFERENCES Instructor
)

CREATE TABLE Student_Instructor_Course_Take(
student_id INT,
course_id INT,
instructor_id INT,
PRIMARY KEY (student_id, course_id, semester_code),
semester_code VARCHAR(40),
exam_type VARCHAR(40) DEFAULT 'Normal',
grade VARCHAR(40),
CONSTRAINT cons7
FOREIGN KEY (student_id) REFERENCES Student,
CONSTRAINT cons8
FOREIGN KEY (course_id) REFERENCES Course,
CONSTRAINT cons9
FOREIGN KEY (instructor_id) REFERENCES Instructor
)

CREATE TABLE Semester(
semester_code VARCHAR(40) PRIMARY KEY,
start_date DATETIME,
end_date DATETIME
)

CREATE TABLE Course_Semester(
course_id INT,
semester_code VARCHAR(40),
PRIMARY KEY (course_id, semester_code),
CONSTRAINT cons10
FOREIGN KEY (course_id) REFERENCES Course,
CONSTRAINT cons11
FOREIGN KEY (semester_code) REFERENCES Semester
)

CREATE TABLE Slot(
slot_id INT PRIMARY KEY IDENTITY,
day VARCHAR(40),
time VARCHAR(40),
location VARCHAR(40),
course_id INT,
instructor_id INT,
CONSTRAINT cons12
FOREIGN KEY (course_id) REFERENCES Course,
CONSTRAINT cons13
FOREIGN KEY (instructor_id) REFERENCES Instructor
)

CREATE TABLE Graduation_Plan(
plan_id INT IDENTITY,
semester_code VARCHAR(40),
PRIMARY KEY (plan_id, semester_code),
semester_credit_hours INT,
expected_grad_date DATETIME,
advisor_id INT,
student_id INT,
CONSTRAINT cons14
FOREIGN KEY (advisor_id) REFERENCES Advisor,
CONSTRAINT cons15
FOREIGN KEY (student_id) REFERENCES Student
)

CREATE TABLE GradPlan_Course(
plan_id INT,
semester_code VARCHAR(40),
course_id INT,
PRIMARY KEY (plan_id, semester_code, course_id),
CONSTRAINT cons16
FOREIGN KEY (plan_id, semester_code) REFERENCES Graduation_Plan(plan_id, semester_code)
)

CREATE TABLE Request(
request_id INT PRIMARY KEY IDENTITY,
type VARCHAR(40),
comment VARCHAR(40),
status VARCHAR(40) DEFAULT 'Pending',
credit_hours INT,
student_id INT,
advisor_id INT,
course_id INT,
CONSTRAINT cons17
FOREIGN KEY (student_id) REFERENCES Student,
CONSTRAINT cons18
FOREIGN KEY (advisor_id) REFERENCES Advisor,
CONSTRAINT cons19
FOREIGN KEY (course_id) REFERENCES Course
)

CREATE TABLE MakeUp_Exam(
exam_id INT PRIMARY KEY IDENTITY,
date DATETIME,
type VARCHAR(40),
course_id INT,
CONSTRAINT cons20
FOREIGN KEY (course_id) REFERENCES Course
)

CREATE TABLE Exam_Student(
exam_id INT,
student_id INT,
course_id INT,
PRIMARY KEY (exam_id, student_id),
CONSTRAINT cons21
FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam,
CONSTRAINT cons22
FOREIGN KEY (student_id) REFERENCES Student
)

CREATE TABLE Payment(
payment_id INT PRIMARY KEY IDENTITY,
amount INT,
deadline DATETIME,
n_installments INT NOT NULL DEFAULT 0,
status VARCHAR(40) DEFAULT 'notPaid',
fund_percentage DECIMAL(10,2),
start_date DATETIME,
student_id INT,
semester_code VARCHAR(40),
CONSTRAINT cons23
FOREIGN KEY (student_id) REFERENCES Student,
CONSTRAINT cons24
FOREIGN KEY (semester_code) REFERENCES Semester
)

CREATE TABLE Installment(
payment_id INT,
deadline DATETIME,
amount INT,
status VARCHAR(40) DEFAULT 'notPaid',
start_date DATETIME,
PRIMARY KEY (payment_id, deadline),
CONSTRAINT cons25
FOREIGN KEY (payment_id) REFERENCES Payment
)

EXEC CreateAllTables

-- Adding 10 records to the Course table
drop proc insertions
CREATE PROC insertions
as
INSERT INTO Course(name, major, is_offered, credit_hours, semester)  VALUES
( 'Mathematics 2', 'Science', 1, 3, 2),
( 'CSEN 2', 'Engineering', 1, 4, 2),
( 'Database 1', 'MET', 1, 3, 5),
( 'Physics', 'Science', 0, 4, 1),
( 'CSEN 4', 'Engineering', 1, 3, 4),
( 'Chemistry', 'Engineering', 1, 4, 1),
( 'CSEN 3', 'Engineering', 1, 3, 3),
( 'Computer Architecture', 'MET', 0, 3, 6),
( 'Computer Organization', 'Engineering', 1, 4, 4),
( 'Database2', 'MET', 1, 3, 6);
-- Adding 10 records to the Instructor table
INSERT INTO Instructor(name, email, faculty, office) VALUES
( 'Professor Smith', 'prof.smith@example.com', 'MET', 'Office A'),
( 'Professor Johnson', 'prof.johnson@example.com', 'MET', 'Office B'),
( 'Professor Brown', 'prof.brown@example.com', 'MET', 'Office C'),
( 'Professor White', 'prof.white@example.com', 'MET', 'Office D'),
( 'Professor Taylor', 'prof.taylor@example.com', 'Mechatronics', 'Office E'),
( 'Professor Black', 'prof.black@example.com', 'Mechatronics', 'Office F'),
( 'Professor Lee', 'prof.lee@example.com', 'Mechatronics', 'Office G'),
( 'Professor Miller', 'prof.miller@example.com', 'Mechatronics', 'Office H'),
( 'Professor Davis', 'prof.davis@example.com', 'IET', 'Office I'),
( 'Professor Moore', 'prof.moore@example.com', 'IET', 'Office J');
-- Adding 10 records to the Semester table
INSERT INTO Semester(semester_code, start_date, end_date) VALUES
('W23', '2023-10-01', '2024-01-31'),
('S23', '2023-03-01', '2023-06-30'),
('S23R1', '2023-07-01', '2023-07-31'),
('S23R2', '2023-08-01', '2023-08-31'),
('W24', '2024-10-01', '2025-01-31'),
('S24', '2024-03-01', '2024-06-30'),
('S24R1', '2024-07-01', '2024-07-31'),
('S24R2', '2024-08-01', '2024-08-31')
-- Adding 10 records to the Advisor table
INSERT INTO Advisor(name, email, office, password) VALUES
( 'Dr. Anderson', 'anderson@example.com', 'Office A', 'password1'),
( 'Prof. Baker', 'baker@example.com', 'Office B', 'password2'),
( 'Dr. Carter', 'carter@example.com', 'Office C', 'password3'),
( 'Prof. Davis', 'davis@example.com', 'Office D', 'password4'),
( 'Dr. Evans', 'evans@example.com', 'Office E', 'password5'),
( 'Prof. Foster', 'foster@example.com', 'Office F', 'password6'),
( 'Dr. Green', 'green@example.com', 'Office G', 'password7'),
( 'Prof. Harris', 'harris@example.com', 'Office H', 'password8'),
( 'Dr. Irving', 'irving@example.com', 'Office I', 'password9'),
( 'Prof. Johnson', 'johnson@example.com', 'Office J', 'password10');
-- Adding 10 records to the Student table
INSERT INTO Student (f_name, l_name, GPA, faculty, email, major, password, financial_status, semester, acquired_hours, assigned_hours, advisor_id)   VALUES 
( 'John', 'Doe', 3.5, 'Engineering', 'john.doe@example.com', 'met', 'password123', 1, 1, 90, 30, 1),
( 'Jane', 'Smith', 3.8, 'Engineering', 'jane.smith@example.com', 'CS', 'password456', 1, 2, 85, 34, 2),
( 'Mike', 'Johnson', 3.2, 'Engineering', 'mike.johnson@example.com', 'CS', 'password789', 1, 3, 75, 34, 3),
( 'Emily', 'White', 3.9, 'Engineering', 'emily.white@example.com', 'CS', 'passwordabc', 0, 4, 95, 34, 4),
( 'David', 'Lee', 3.4, 'Engineering', 'david.lee@example.com', 'IET', 'passworddef', 1, 5, 80, 34, 5),
( 'Grace', 'Brown', 3.7, 'Engineering', 'grace.brown@example.com', 'IET', 'passwordghi', 0, 6, 88, 34, 6),
( 'Robert', 'Miller', 3.1, 'Engineerings', 'robert.miller@example.com', 'IET', 'passwordjkl', 1, 7, 78, 34, 7),
( 'Sophie', 'Clark', 3.6, 'Engineering', 'sophie.clark@example.com', 'Mechatronics', 'passwordmno', 1, 8, 92, 34, 8),
( 'Daniel', 'Wilson', 3.3, 'Engineering', 'daniel.wilson@example.com', 'DMET', 'passwordpqr', 1, 9, 87, 34, 9),
( 'Olivia', 'Anderson', 3.7, 'Engineeringe', 'olivia.anderson@example.com', 'Mechatronics', 'passwordstu', 0, 10, 89, 34, 10);
-- Adding 10 records to the Student_Phone table
INSERT INTO Student_Phone(student_id, phone_number) VALUES
(4, '456-789-0123'),
(5, '567-890-1234'),
(6, '678-901-2345'),
(7, '789-012-3456'),
(8, '890-123-4567'),
(9, '901-234-5678'),
(10, '012-345-6789');
-- Adding 10 records to the PreqCourse_course table
INSERT INTO PreqCourse_course(prerequisite_course_id, course_id) VALUES
(2, 7),
(3, 10),
(2, 4),
(5, 6),
(4, 7),
(6, 8),
(7, 9),
(9, 10),
(9, 1),
(10, 3);
-- Adding 10 records to the Instructor_Course table
INSERT INTO Instructor_Course (instructor_id, course_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
-- Adding 10 records to the Student_Instructor_Course_Take table
INSERT INTO Student_Instructor_Course_Take (student_id, course_id, instructor_id, semester_code,exam_type, grade) VALUES
(1, 1, 1, 'W23', 'Normal', 'A'),
(2, 2, 2, 'S23', 'First_makeup', 'B'),
(3, 3, 3, 'S23R1', 'Second_makeup', 'C'),
(4, 4, 4, 'S23R2', 'Normal', 'B+'),
(5, 5, 5, 'W23', 'Normal', 'A-'),
(6, 6, 6, 'W24', 'First_makeup', 'B'),
(7, 7, 7, 'S24', 'Second_makeup', 'C+'),
(8, 8, 8, 'S24R1', 'Normal', 'A+'),
(9, 9, 9, 'S24R2', 'Normal', 'FF'),
(10, 10, 10, 'S24', 'First_makeup', 'B-');
-- Adding 10 records to the Course_Semester table
INSERT INTO Course_Semester (course_id, semester_code) VALUES
(1, 'W23'),
(2, 'S23'),
(3, 'S23R1'),
(4, 'S23R2'),
(5, 'W23'),
(6, 'W24'),
(7, 'S24'),
(8, 'S24R1'),
(9, 'S24R2'),
(10, 'S24');
-- Adding 10 records to the Slot table
INSERT INTO Slot (day, time, location, course_id, instructor_id) VALUES
( 'Monday', 'First', 'Room A', 1, 1),
( 'Tuesday', 'First', 'Room B', 2, 2),
( 'Wednesday', 'Third', 'Room C', 3, 3),
( 'Thursday', 'Fifth', 'Room D', 4, 4),
( 'Saturday', 'Second', 'Room E', 5, 5),
( 'Monday', 'Fourth', 'Room F', 6, 6),
( 'Tuesday', 'Second', 'Room G', 7, 7),
( 'Wednesday', 'Fifth', 'Room H', 8, 8),
( 'Thursday', 'First', 'Room I', 9, 9),
( 'Sunday', 'Fourth', 'Room J', 10, 10);
-- Adding 10 records to the Graduation_Plan table
INSERT INTO Graduation_Plan (semester_code, semester_credit_hours, expected_grad_date, student_id, advisor_id) VALUES
( 'W23', 90,    '2024-01-31' ,   1, 1),
( 'S23', 85,    '2025-01-31'  ,     2, 2),
( 'S23R1', 75,  '2025-06-30' ,  3, 3),
( 'S23R2', 95,  '2024-06-30' , 4, 4),
( 'W23', 80,    '2026-01-31'   ,  5, 5),
( 'W24', 88,    '2024-06-30'   ,    6, 6),
( 'S24', 78,    '2024-06-30'    ,  7, 7),
( 'S24R1', 92,  '2025-01-31'  , 8, 8),
( 'S24R2', 87,  '2024-06-30'    ,  9, 9),
( 'S24', 89,    '2025-01-31'    ,    10, 10);
-- Adding 10 records to the GradPlan_Course table
INSERT INTO GradPlan_Course(plan_id, semester_code, course_id) VALUES
(1, 'W23', 1),
(2, 'S23', 2),
(3, 'S23R1', 3),
(4, 'S23R2', 4),
(5, 'W23', 5),
(6, 'W24', 6),
(7, 'S24', 7),
(8, 'S24R1', 8),
(9, 'S24R2', 9),
(10, 'S24', 10);
-- Adding 10 records to the Request table
INSERT INTO Request (type, comment, status, credit_hours, course_id, student_id, advisor_id) VALUES 
( 'course', 'Request for additional course', 'pending', null, 1, 1, 2),
( 'course', 'Need to change course', 'approved', null, 2, 2, 2),
( 'credit_hours', 'Request for extra credit hours', 'pending', 3, null, 3, 3),
( 'credit_hours', 'Request for reduced credit hours', 'approved', 1, null, 4, 5),
( 'course', 'Request for special course', 'rejected', null, 5, 5, 5),
( 'credit_hours', 'Request for extra credit hours', 'pending', 4, null, 6, 7),
( 'course', 'Request for course withdrawal', 'approved', null, 7, 7, 7),
( 'course', 'Request for course addition', 'rejected', null, 8, 8, 8),
( 'credit_hours', 'Request for reduced credit hours', 'approved', 2, null, 9, 8),
( 'course', 'Request for course substitution', 'pending', null, 10, 10, 10);
-- Adding 10 records to the MakeUp_Exam table
INSERT INTO MakeUp_Exam (date, type, course_id) VALUES
('2023-02-10', 'First MakeUp', 1),
('2023-02-15', 'First MakeUp', 2),
('2023-02-05', 'First MakeUp', 3),
('2023-02-25', 'First MakeUp', 4),
('2023-02-05', 'First MakeUp', 5),
('2024-09-10', 'Second MakeUp', 6),
('2024-09-20', 'Second MakeUp', 7),
('2024-09-05', 'Second MakeUp', 8),
('2024-09-10', 'Second MakeUp', 9),
( '2024-09-15', 'Second MakeUp', 10);
-- Adding 10 records to the Exam_Student table
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (1, 1, 1);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (1, 2, 2);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (1, 3, 3);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (2, 2, 4);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (2, 3, 5);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (2, 4, 6);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (3, 3, 7);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (3, 4, 8);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (3, 5, 9);
INSERT INTO Exam_Student(exam_id, student_id,course_id) VALUES (4, 4, 10);
-- Adding 10 records to the Payment table
INSERT INTO Payment (amount, start_date,n_installments, status, fund_percentage, student_id, semester_code, deadline)  VALUES
( 500, '2023-11-22', 1, 'notPaid', 50.00, 1, 'W23', '2023-12-22'),
( 700, '2023-11-23', 1, 'notPaid', 60.00, 2, 'S23', '2023-12-23'),
( 600, '2023-11-24', 4, 'notPaid', 40.00, 3, 'S23R1', '2024-03-24'),
( 800, '2023-11-25', 1, 'notPaid', 70.00, 4, 'S23R2', '2023-12-25'),
( 550, '2023-11-26', 5, 'notPaid', 45.00, 5, 'W23', '2024-04-26'),
( 900, '2023-11-27', 1, 'notPaid', 80.00, 6, 'W24', '2023-12-27'),
( 750, '2023-10-28', 2, 'Paid', 65.00, 7, 'S24', '2023-12-28'),
( 620, '2023-08-29', 4, 'Paid', 55.00, 8, 'S24R1', '2023-12-29'),
( 720, '2023-11-30', 2, 'notPaid', 75.00, 9, 'S24R2', '2024-01-30'),
( 580, '2023-11-30', 1, 'Paid', 47.00, 10, 'S24', '2023-12-31');
-- Adding 10 records to the Installment table
INSERT INTO Installment (payment_id, start_date, amount, status, deadline) VALUES
(1, '2023-11-22', 50, 'notPaid','2023-12-22'),
(2, '2023-11-23', 70, 'notPaid','2023-12-23'),
(3, '2023-12-24', 60, 'notPaid','2024-01-24'),
( 4,'2023-11-25', 80, 'notPaid','2023-12-25'),
(5, '2024-2-26', 55, 'notPaid','2024-3-26'),
( 6,'2023-11-27', 90, 'notPaid','2023-12-06'),
(7, '2023-10-28', 75, 'Paid','2023-11-28'),
( 7,'2023-11-28', 62, 'Paid','2023-12-28'),
( 9,'2023-12-30', 72, 'notPaid','2024-01-30'),
( 10,'2023-11-30', 58, 'Paid','2023-12-30');

exec insertions

--2 1 3
CREATE PROC DropAllTables
AS
DROP TABLE Installment
DROP TABLE Payment
DROP TABLE Exam_Student
DROP TABLE MakeUp_Exam
DROP TABLE Request
DROP TABLE GradPlan_Course
DROP TABLE Graduation_Plan
DROP TABLE Slot
DROP TABLE Course_Semester
DROP TABLE Semester
DROP TABLE Student_Instructor_Course_Take
DROP TABLE Instructor_Course
DROP TABLE PreqCourse_course
DROP TABLE Course
DROP TABLE Student_Phone
DROP TABLE Student
DROP TABLE Advisor
DROP TABLE Instructor

EXEC DropAllTables

--2 1 4
DROP PROC clearAllTables

CREATE PROC clearAllTables
AS
ALTER TABLE Installment DROP CONSTRAINT cons25
ALTER TABLE Payment DROP CONSTRAINT cons24;
ALTER TABLE Payment DROP CONSTRAINT cons23;
ALTER TABLE Exam_Student DROP CONSTRAINT cons22;
ALTER TABLE Exam_Student DROP CONSTRAINT cons21;
ALTER TABLE MakeUp_Exam DROP CONSTRAINT cons20;
ALTER TABLE Request DROP CONSTRAINT cons19;
ALTER TABLE Request DROP CONSTRAINT cons18;
ALTER TABLE Request DROP CONSTRAINT cons17;
ALTER TABLE GradPlan_Course DROP CONSTRAINT cons16;
ALTER TABLE Graduation_Plan DROP CONSTRAINT cons15;
ALTER TABLE Graduation_Plan DROP CONSTRAINT cons14;
ALTER TABLE Slot DROP CONSTRAINT cons13;
ALTER TABLE Slot DROP CONSTRAINT cons12;
ALTER TABLE Course_Semester DROP CONSTRAINT cons11;
ALTER TABLE Course_Semester DROP CONSTRAINT cons10;
ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT cons9;
ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT cons8;
ALTER TABLE Student_Instructor_Course_Take DROP CONSTRAINT cons7;
ALTER TABLE Instructor_Course DROP CONSTRAINT cons6;
ALTER TABLE Instructor_Course DROP CONSTRAINT cons5;
ALTER TABLE PreqCourse_course DROP CONSTRAINT cons4;
ALTER TABLE PreqCourse_course DROP CONSTRAINT cons3;
ALTER TABLE Student_Phone DROP CONSTRAINT cons2;
ALTER TABLE Student DROP CONSTRAINT cons1;
TRUNCATE TABLE Installment;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Exam_Student;
TRUNCATE TABLE MakeUp_Exam;
TRUNCATE TABLE Request;
TRUNCATE TABLE GradPlan_Course;
TRUNCATE TABLE Graduation_Plan;
TRUNCATE TABLE Slot;
TRUNCATE TABLE Course_Semester;
TRUNCATE TABLE Semester;
TRUNCATE TABLE Student_Instructor_Course_Take;
TRUNCATE TABLE Instructor_Course;
TRUNCATE TABLE PreqCourse_course;
TRUNCATE TABLE Course;
TRUNCATE TABLE Student_Phone;
TRUNCATE TABLE Student;
TRUNCATE TABLE Instructor;
TRUNCATE TABLE Advisor;
ALTER TABLE Installment ADD CONSTRAINT cons25 FOREIGN KEY (payment_id) REFERENCES Payment;
ALTER TABLE Payment ADD CONSTRAINT cons24 FOREIGN KEY (semester_code) REFERENCES Semester;
ALTER TABLE Payment ADD CONSTRAINT cons23 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE Exam_Student ADD CONSTRAINT cons22 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE Exam_Student ADD CONSTRAINT cons21 FOREIGN KEY (exam_id) REFERENCES MakeUp_Exam;
ALTER TABLE MakeUp_Exam ADD CONSTRAINT cons20 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE Request ADD CONSTRAINT cons19 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE Request ADD CONSTRAINT cons18 FOREIGN KEY (advisor_id) REFERENCES Advisor;
ALTER TABLE Request ADD CONSTRAINT cons17 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE GradPlan_Course ADD CONSTRAINT cons16 FOREIGN KEY (plan_id, semester_code) REFERENCES Graduation_Plan(plan_id, semester_code);
ALTER TABLE Graduation_Plan ADD CONSTRAINT cons15 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE Graduation_Plan ADD CONSTRAINT cons14 FOREIGN KEY (advisor_id) REFERENCES Advisor;
ALTER TABLE Slot ADD CONSTRAINT cons13 FOREIGN KEY (instructor_id) REFERENCES Instructor;
ALTER TABLE Slot ADD CONSTRAINT cons12 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE Course_Semester ADD CONSTRAINT cons11 FOREIGN KEY (semester_code) REFERENCES Semester;
ALTER TABLE Course_Semester ADD CONSTRAINT cons10 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT cons9 FOREIGN KEY (instructor_id) REFERENCES Instructor;
ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT cons8 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE Student_Instructor_Course_Take ADD CONSTRAINT cons7 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE Instructor_Course ADD CONSTRAINT cons6 FOREIGN KEY (instructor_id) REFERENCES Instructor;
ALTER TABLE Instructor_Course ADD CONSTRAINT cons5 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE PreqCourse_course ADD CONSTRAINT cons4 FOREIGN KEY (course_id) REFERENCES Course;
ALTER TABLE PreqCourse_course ADD CONSTRAINT cons3 FOREIGN KEY (prerequisite_course_id) REFERENCES Course;
ALTER TABLE Student_Phone ADD CONSTRAINT cons2 FOREIGN KEY (student_id) REFERENCES Student;
ALTER TABLE Student ADD CONSTRAINT cons1 FOREIGN KEY (advisor_id) REFERENCES Advisor;

EXEC clearAllTables

--2.2.A
CREATE VIEW view_Students
AS
SELECT *
FROM Student;

SELECT * FROM view_Students

--2 2 b
CREATE VIEW view_Course_prerequisites
AS
SELECT C.*, CC.course_id AS prereq_course_id, CC.name AS prereq_name, CC.major AS prereq_major, CC.is_offered AS prereq_is_offered, CC.credit_hours AS prereq_credit_hours, CC.semester AS prereq_semester
FROM Course C LEFT OUTER JOIN PreqCourse_course P ON C.course_id=P.course_id
     LEFT OUTER JOIN Course CC ON P.prerequisite_course_id=CC.course_id
SELECT * FROM COURSE
SELECT * FROM view_Course_prerequisites

--2.2.C
CREATE VIEW Instructors_AssignedCourses
AS
SELECT I.*, C.course_id, C.name AS course_name, C.major , C.is_offered, C.credit_hours, C.semester
FROM Instructor I LEFT OUTER JOIN Instructor_Course IC ON I.instructor_id = IC.instructor_id
     LEFT OUTER JOIN Course C ON C.course_id = IC.course_id;

SELECT * FROM Instructors_AssignedCourses

--2.2D
Create view Student_Payment
AS
SELECT p.*, s.student_id students_id, s.f_name student_f_name, s.l_name student_l_name, s.gpa student_gpa, s.faculty student_faculty, s.email student_email, s.major student_major, s.password student_password, s.financial_status student_financial_status, s.semester student_semester, s.acquired_hours student_acquired_hours, s.assigned_hours student_assigned_hours, s.advisor_id student_advisor_id
From Payment p LEFT OUTER JOIN Student s on p.student_id = s.student_id

SELECT * FROM Student_Payment

--2.2.E
CREATE VIEW [Courses_Slots_Instructor] AS
SELECT C.course_id, C.name AS course_name, S.slot_id, S.day, S.time, S.location, I.name
FROM Course C
LEFT OUTER JOIN Slot S
ON C.course_id = S.course_id
LEFT OUTER JOIN Instructor I
ON S.instructor_id = I.instructor_id;

SELECT * FROM [Courses_Slots_Instructor]

--2.2.F
CREATE VIEW [Courses_MakeupExams] AS
SELECT C.name, C.semester, M.*
FROM Course C
LEFT OUTER JOIN MakeUp_Exam M
ON C.course_id = M.course_id;

SELECT * FROM Courses_MakeupExams

--2.2.G
CREATE VIEW [Students_Courses_transcript] AS
SELECT S.student_id, S.f_name, S.l_name, SIC.course_id, C.name AS course_name, SIC.exam_type, SIC.grade, SIC.semester_code, I.name
FROM Student S
INNER JOIN Student_Instructor_Course_Take SIC
ON S.student_id = SIC.student_id
INNER JOIN Instructor I
ON SIC.instructor_id = I.instructor_id
INNER JOIN Course C
ON SIC.course_id=C.course_id
WHERE SIC.grade IS NOT NULL

SELECT * FROM Students_Courses_transcript

--2.2H
Create view Semester_offered_Courses as
SELECT c.course_id, c.name, s.semester_code
From Semester S LEFT OUTER JOIN Course_Semester CS ON S.semester_code=CS.semester_code
     LEFT OUTER JOIN Course C ON CS.course_id=C.course_id

SELECT * FROM Semester_offered_Courses 

--2 2 I
Create view Advisors_Graduation_Plan as
SELECT g.* , a.advisor_id AS advisors_id, a.name
From Graduation_Plan g
LEFT OUTER JOIN Advisor a on g.advisor_id = a.advisor_id

SELECT * FROM Advisors_Graduation_Plan

--2 3 a
CREATE PROC Procedures_StudentRegistration
@first_name VARCHAR(40),
@last_name VARCHAR(40),
@password VARCHAR(40),
@faculty VARCHAR(40),
@email VARCHAR(40),
@major VARCHAR(40),
@Semester INT,
@Student_id INT OUTPUT
AS
INSERT INTO Student(f_name,l_name, password, faculty, email, major, semester)
VALUES(@first_name, @last_name, @password, @faculty, @email, @major, @semester)
SELECT @Student_id=student_id
FROM Student
WHERE f_name=@first_name AND l_name=@last_name AND password=@password AND faculty=@faculty AND email=@email AND major=@major AND semester=@semester

DECLARE @Student_id INT
EXEC Procedures_StudentRegistration 'hana', 'eldemery', '123456', 'engineering', 'hana@guc', 'met', 3, @Student_id OUTPUT
PRINT @Student_id

SELECT * FROM Student

--2 3 b
CREATE PROC Procedures_AdvisorRegistration
@advisor_name VARCHAR(40),  
@password VARCHAR(40),  
@email VARCHAR(40),
@office VARCHAR(40),
@Advisor_id INT OUTPUT
AS
INSERT INTO Advisor(name, password, email, office)
VALUES(@advisor_name, @password, @email, @office)
SELECT @Advisor_id=advisor_id
FROM Advisor
WHERE name=@advisor_name AND password=@password AND email=@email AND office=office

DECLARE @Advisor_id INT
EXEC Procedures_AdvisorRegistration 'amr','123456', 'amr@guc', 'office1', @Advisor_id OUTPUT
PRINT @Advisor_id

SELECT * FROM Advisor

--2 3 c
CREATE PROC Procedures_AdminListStudents
AS
SELECT *
FROM Student

EXEC Procedures_AdminListStudents

--2-3(D)
CREATE PROC Procedures_AdminListAdvisors
AS
SELECT *
FROM Advisor

EXEC Procedures_AdminListAdvisors;

--2 3 e
drop proc AdminListStudentsWithAdvisors 

CREATE PROC AdminListStudentsWithAdvisors
AS
SELECT S.*, A.*
FROM Student S LEFT OUTER JOIN Advisor A ON S.advisor_id=A.advisor_id--walla inner join?

EXEC AdminListStudentsWithAdvisors

--2-3(F)
drop proc AdminAddingSemester

CREATE PROC AdminAddingSemester
@start_date DATETIME,
@end_date DATETIME,
@semester_code VARCHAR(40)
AS
INSERT INTO Semester (start_date, end_date, semester_code)
VALUES (@start_date, @end_date, @semester_code)

EXEC AdminAddingSemester @start_date='2023-10-01', @end_date='2023-10-01', @semester_code= 'Winter 2024 à W23';

--2 3 g
CREATE PROC Procedures_AdminAddingCourse
@major VARCHAR(40),  
@semester INT,  
@credit_hours INT,
@course_name VARCHAR(40),
@offered BIT
AS
INSERT INTO Course(major,semester,credit_hours,name,is_offered)
VALUES(@major,@semester,@credit_hours,@course_name,@offered)

EXEC Procedures_AdminAddingCourse 'met',3,5,'cs 6', 0

--2 3 h
CREATE PROC Procedures_AdminLinkInstructor
@InstructorId INT,
@courseId INT,
@slotID INT
AS
DECLARE @count INT
SELECT @count=count(instructor_id)
FROM Instructor_Course
WHERE course_id=@courseId AND instructor_id=@InstructorId
IF @count=0--if he doesn't teach it, make him teach it
BEGIN
INSERT INTO Instructor_Course
VALUES(@InstructorId,@courseId)
UPDATE Slot
SET Slot.instructor_id=@InstructorId, Slot.course_id=@courseId
WHERE slot_id=@slotID
END
ELSE
UPDATE Slot
SET Slot.instructor_id=@InstructorId, Slot.course_id=@courseId
WHERE slot_id=@slotID

EXEC Procedures_AdminLinkInstructor 1,2,4

--2 3 i
CREATE PROC Procedures_AdminLinkStudent
@InstructorId INT,
@student_ID INT,
@course_id INT,
@semester_code VARCHAR(40)
AS
DECLARE @count INT
SELECT @count=count(instructor_id)
FROM Instructor_Course
WHERE course_id=@course_id AND instructor_id=@InstructorId
IF @count>0
INSERT INTO Student_Instructor_Course_Take(student_id, course_id, instructor_id,semester_code)
VALUES (@student_ID,@course_id,@InstructorId,@semester_code)
ELSE
INSERT INTO Instructor_Course
VALUES(@InstructorId,@course_id)
INSERT INTO Student_Instructor_Course_Take(student_id, course_id, instructor_id,semester_code)
VALUES (@student_ID,@course_id,@InstructorId,@semester_code)

EXEC Procedures_AdminLinkStudent 2,1,3,'Winter 2023 à W23,'

--2-3(J)
CREATE PROC Procedures_AdminLinkStudentToAdvisor
@studentID INT,
@advisorID INT
AS
UPDATE Student
SET advisor_id= @advisorID
WHERE student_id= @studentID

EXEC Procedures_AdminLinkStudentToAdvisor @studentID= 1, @advisorID= 2

--2-3(K)
CREATE PROC Procedures_AdminAddExam
@Type VARCHAR(40),
@date DATETIME,
@courseID INT
AS
INSERT INTO MakeUp_Exam(date, type, course_id) 
VALUES(@date, @Type, @courseID);

EXEC Procedures_AdminAddExam @Type= 'Second Makeup', @date= '2023-11-11',@courseID= 1

--2-3(L)
CREATE PROC Procedures_AdminIssueInstallment
@payment_ID INT
AS
DECLARE @count INT
DECLARE @payment_amount INT
DECLARE @number_installments INT
DECLARE @newamm INT
DECLARE @startdate DATETIME
DECLARE @deadline Datetime
DECLARE @deadlineold DATETIME

SELECT @payment_amount=amount, @number_installments=n_installments, @count=n_installments, @startdate=start_date, @deadline=start_date, @deadlineold=deadline
FROM Payment
WHERE payment_id=@payment_ID

if @number_installments=0
INSERT INTO Installment(payment_id, deadline, amount, start_date)
VALUES (@payment_ID,@deadlineold,@payment_amount, @startdate)
else
SET @newamm=@payment_amount/@number_installments
WHILE @count>0
BEGIN
SELECT @deadline=DATEADD(month, 1, @deadline)
INSERT INTO Installment(payment_id, deadline, amount, start_date)
VALUES (@payment_ID,@deadline,@newamm, @startdate)
SELECT @startdate=DATEADD(month, 1, @startdate)
SET @count=@count-1
END

exec Procedures_AdminIssueInstallment 3

--2-3(M)
CREATE PROC Procedures_AdminDeleteCourse
@courseID INT
AS
UPDATE Slot
SET instructor_id=NULL, course_id=NULL
WHERE course_id=@courseID
DELETE
FROM Course
WHERE course_id= @courseID

exec Procedures_AdminDeleteCourse 1
select * from slot
select * from course0

--2.3.N
CREATE PROC Procedure_AdminUpdateStudentStatus
@StudentID INT
AS 
DECLARE @currdate DATETIME = CURRENT_TIMESTAMP
DECLARE @countfato INT 
DECLARE @payid INT

SELECT @payid=payment_id
from payment
where student_id=@StudentID

select @countfato=count(payment_id)
from Installment 
where payment_id=@payid AND @currdate>deadline and status='notPaid'

if @countfato>0
begin
UPDATE Student
SET financial_status='0'--BLOCKED
WHERE student_id=@StudentID
end
else
begin
UPDATE Student
SET financial_status='1'--BLOCKED
WHERE student_id=@StudentID
end

exec Procedure_AdminUpdateStudentStatus 1

--2.3.O
CREATE VIEW [all_Pending_Requests] AS
SELECT R.*,S.f_name AS student_f_name ,S.l_name AS student_l_name,A.name  
FROM Request R INNER JOIN Student S on R.student_id=S.student_id INNER JOIN Advisor A ON A.advisor_id=R.advisor_id
WHERE R.status='Pending'

select * from [all_Pending_Requests]

--2.3.P
drop proc Procedures_AdminDeleteSlots

CREATE PROC Procedures_AdminDeleteSlots
@current_semester varchar (40)
AS
DELETE FROM Slot
WHERE course_id IN (SELECT C.course_id
                    FROM Course C INNER JOIN Course_Semester CS ON CS.course_id=C.course_id
                    WHERE CS.semester_code<>@current_semester)

EXEC Procedures_AdminDeleteSlots 'W23'

--2 3 Q
CREATE FUNCTION FN_AdvisorLogin
(@ID int, 
@password varchar (40))
RETURNS BIT
AS
BEGIN
DECLARE @count INT
DECLARE @Success_bit BIT
SELECT @count=count(advisor_id)
FROM Advisor
WHERE advisor_id=@ID AND password=@password
IF @count=0
SET @Success_bit='0'
ELSE
SET @Success_bit='1'
RETURN @Success_bit
END

DECLARE @Success_bit BIT
SET @Success_bit=dbo.FN_AdvisorLogin(1,'password1')
print @Success_bit

--2.3R
--acquired hours greater than 157
drop proc Procedure_AdvisorCreateGP
CREATE PROC Procedure_AdvisorCreateGP
@semester_code VARCHAR(40),
@expected_graduation_date DATETIME,
@sem_credit_hours INT,
@advisor_id INT,
@student_id INT
AS
DECLARE @acq INT
DECLARE @advid INT
SELECT @acq=acquired_hours, @advid=advisor_id
FROM Student
WHERE student_id=@student_id
if (@acq>157) and @advid=@advisor_id
INSERT INTO Graduation_plan (semester_code,expected_grad_date, semester_credit_hours,advisor_id ,student_id)
VALUES (@semester_code, @expected_graduation_date, @sem_credit_hours ,@advisor_id ,@student_id);
else
print('An advisor can not create a graduation plan for a student with less than 158 acquired hours or wrong advisor creating the plan for the student')

insert into student(f_name, advisor_id, acquired_hours)
values ('hana',1,150)
insert into student(f_name, advisor_id, acquired_hours)
values ('omar',1,180)
exec Procedure_AdvisorCreateGP 'w23','2023-11-11',15,1,1
exec Procedure_AdvisorCreateGP 'w23','2023-11-11',15,1,12

--2.3 S
CREATE PROC Procedures_AdvisorAddCourseGP
@student_id INT,
@semester_code VARCHAR (40),
@course_name VARCHAR(40)
AS
DECLARE @cid INT
DECLARE @pid INT

SELECT @cid=course_id
FROM Course
WHERE name=@course_name

SELECT @pid=plan_id
FROM Graduation_Plan
WHERE student_id=@student_id AND semester_code=@semester_code

INSERT INTO GradPlan_Course
VALUES(@pid,@semester_code,@cid)

exec Procedures_AdvisorAddCourseGP 1,'w23','physics'

--2.3T
CREATE PROC Procedures_AdvisorUpdateGP
@expected_grad_date DATETIME,
@student_id INT
AS
UPDATE Graduation_Plan
SET expected_grad_date=@expected_grad_date
WHERE @student_id=student_id

exec Procedures_AdvisorUpdateGP '2023-11-11',1

--2-3(U)
--Delete course from certain graduation plan in certain semester
CREATE PROC Procedures_AdvisorDeleteFromGP
@studentID INT,
@semester_code VARCHAR(40),
@courseID INT --(the course he/she wants to delete)
AS
DELETE GPC
FROM Graduation_Plan GP INNER JOIN GradPlan_Course GPC ON (GP.plan_id=GPC.plan_id AND GP.semester_code=GPC.semester_code)
WHERE GP.student_id=@studentID AND GP.semester_code= @semester_code AND GPC.course_id= @courseID

exec Procedures_AdvisorDeleteFromGP 1,'w23',1

--2 3 v
CREATE FUNCTION FN_Advisors_Requests
(@advisorID INT)
RETURNS Table
AS
RETURN(SELECT *
       FROM Request
       WHERE advisor_id=@advisorID);

select * from dbo.FN_Advisors_Requests(2)

--2-3(W)
drop proc Procedures_AdvisorApproveRejectCHRequest
CREATE PROC Procedures_AdvisorApproveRejectCHRequest--request up to 3 credit hours
@RequestID INT,
@Current_semester_code VARCHAR(40)
AS
DECLARE @rtype VARCHAR(40)
DECLARE @sid INT
DECLARE @wanthrs INT
DECLARE @reqadv INT
DECLARE @actadv INT
DECLARE @sgpa INT
DECLARE @takenhrs INT
DECLARE @prevpay INT
DECLARE @previnst INT
DECLARE @payid INT
DECLARE @currtime DATETIME=CURRENT_TIMESTAMP
DECLARE @deadlineinst DATETIME
declare @asshrs INT

SELECT @rtype=type, @sid=student_id, @reqadv=advisor_id, @wanthrs=credit_hours 
FROM Request
WHERE request_id=@RequestID

SELECT @takenhrs=sum(C.credit_hours)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@sid AND SIC.semester_code=@Current_semester_code
GROUP BY SIC.student_id

SELECT @sgpa=gpa, @actadv=advisor_id, @asshrs=assigned_hours
FROM Student
WHERE student_id=@sid

IF @reqadv<>@actadv OR @sgpa>3.7 OR (@asshrs+@wanthrs+@takenhrs>34) OR @rtype<>'credit_hours' OR @wanthrs>3--@wanthrs+@takenhrs>@assigned hours
BEGIN
UPDATE Request
SET status='Rejected'
WHERE request_id=@RequestID 
END

ELSE
BEGIN
UPDATE Request
SET status='Accepted'
WHERE request_id=@RequestID 

UPDATE Student
SET assigned_hours=assigned_hours+@wanthrs
WHERE student_id=@sid

SELECT top 1 @payid=payment_id, @prevpay=amount
FROM Payment
WHERE student_id=@sid AND semester_code=@Current_semester_code AND start_date>@currtime AND deadline>@currtime
ORDER BY start_date

UPDATE Payment
SET amount=@prevpay+1000
WHERE student_id=@sid AND semester_code=@Current_semester_code

SELECT top 1 @previnst=amount,@deadlineinst=deadline
FROM Installment
WHERE payment_id=@payid AND start_date>@currtime AND deadline>@currtime
ORDER BY start_date

UPDATE Installment
SET amount=@previnst+1000
WHERE payment_id=@payid AND deadline=@deadlineinst
END

insert into request 
values('credit_hours','.','pending',1,1,1,NULL)--accepted 
exec Procedures_AdvisorApproveRejectCHRequest 11, 'w23'

update student
set assigned_hours=32
where student_id=1

--2.3.X
CREATE PROCEDURE Procedures_AdvisorViewAssignedStudents
@AdvisorID INT,
@major VARCHAR(40)
AS
SELECT S.student_id, S.f_name, S.l_name, S.major, C.name as course_name
FROM Student S
    INNER JOIN Student_Instructor_Course_Take SIC
    ON S.student_id = SIC.student_id
    INNER JOIN Course C
    ON SIC.course_id = C.course_id
WHERE S.advisor_id = @AdvisorID AND S.major = @major

exec Procedures_AdvisorViewAssignedStudents 1, 'cs'

--2.3.Y
drop proc Procedures_AdvisorApproveRejectCourseRequest
CREATE PROC Procedures_AdvisorApproveRejectCourseRequest--request up to 3 credit hours
@RequestID INT,
@Current_semester_code VARCHAR(40)
AS
DECLARE @rtype VARCHAR(40)
DECLARE @sid INT
DECLARE @addcrs INT
DECLARE @addhrs INT
DECLARE @reqadv INT
DECLARE @actadv INT
DECLARE @takenhrs INT
DECLARE @count INT
DECLARE @asshrs INT 

SELECT @rtype=type, @sid=student_id, @reqadv=advisor_id, @addcrs=course_id 
FROM Request
WHERE request_id=@RequestID

SELECT @addhrs=credit_hours
FROM Course 
WHERE @addcrs=course_id

SELECT @count=count(SIC.course_id)
FROM (SELECT prerequisite_course_id--table of all prereqs
      FROM PreqCourse_course 
      WHERE course_id=@addcrs) AS P
     INNER JOIN Student_Instructor_Course_Take SIC ON SIC.course_id=P.prerequisite_course_id
WHERE SIC.grade IS NULL--counts null(counts not taken(counts not taken prereqs))

SELECT @actadv=advisor_id, @asshrs=assigned_hours
FROM Student
WHERE student_id=@sid

SELECT @takenhrs=sum(C.credit_hours)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@sid AND SIC.semester_code=@Current_semester_code
GROUP BY SIC.student_id

IF @reqadv<>@actadv OR (@asshrs<@addhrs) OR @rtype<>'course' OR @count>0--ass hrs stude>=crs ccr hrs
begin
UPDATE Request
SET status='Rejected'
WHERE request_id=@RequestID
end
ELSE
begin
UPDATE Request
SET status='Accepted'--assigned hrs=ass hrs-crs cr hrs
WHERE request_id=@RequestID
UPDATE Student
SET assigned_hours=assigned_hours-@addhrs
WHERE student_id= @sid
INSERT INTO Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type)--exam normal
VALUES(@sid,@addcrs,@Current_semester_code,'Normal')
end

insert into request 
values('course','.','pending',NULL,5,5,6)
exec Procedures_AdvisorApproveRejectCourseRequest 11, 'w23'

UPDATE Student
set assigned_hours=1 
where student_id=5

--2-3(Z)
CREATE PROC Procedures_AdvisorViewPendingRequests
@Advisor_ID INT --{this advisor should be the one advising the student}
AS
SELECT R.request_id, R.type, R.comment, R.status, R.credit_hours, R.student_id, R.advisor_id, R.course_id
FROM Request R
WHERE R.status= 'Pending' AND R.advisor_id=@Advisor_ID AND R.student_id IN (SELECT student_id
                                                                            FROM Student
                                                                            WHERE advisor_id=@advisor_id)

exec Procedures_AdvisorViewPendingRequests 2

--2 3 aa
drop function FN_StudentLogin
CREATE FUNCTION FN_StudentLogin
(@Student_ID int, 
@password varchar (40))
RETURNS BIT
AS
BEGIN
DECLARE @count INT
DECLARE @financial_status BIT
DECLARE @Success_bit BIT
SELECT @financial_status=financial_status
FROM Student
Where student_id=@Student_ID
SELECT @count=count(student_id)
FROM Student
WHERE student_id=@Student_ID AND password=@password
IF @count>=1 and @financial_status='1'
SET @Success_bit='1'
ELSE
SET @Success_bit='0'
RETURN @Success_bit
END

DECLARE @Success_bit BIT
SET @Success_bit=dbo.FN_StudentLogin(4,'passwordabc')
print @Success_bit


--2 3 BB
CREATE PROC Procedures_StudentaddMobile
@StudentID INT,
@mobile_number VARCHAR(40)
AS
INSERT INTO Student_Phone
VALUES(@StudentID,@mobile_number)

exec Procedures_StudentaddMobile 4,'010'

--2 3 cc
CREATE FUNCTION FN_SemsterAvailableCourses
(@semester_code varchar (40))
RETURNS TABLE
AS
RETURN (SELECT C.*
        FROM Course C INNER JOIN Course_Semester CS ON C.course_id=CS.course_id
        WHERE CS.semester_code=@semester_code)

select * from dbo.FN_SemsterAvailableCourses('w23')

--2 3 DD
CREATE PROC Procedures_StudentSendingCourseRequest
@Student_ID int,
@course_ID int,
@type varchar (40),
@comment varchar (40)
AS
INSERT INTO Request(student_id,course_id,type,comment)
VALUES(@Student_ID,@course_ID,@type,@comment)

--2 3 EE
CREATE PROC Procedures_StudentSendingCHRequest
@Student_ID int,
@credit_hours int,
@type varchar (40),
@comment varchar (40)
AS
INSERT INTO Request(student_id,credit_hours,type,comment)
VALUES(@Student_ID,@credit_hours,@type,@comment)

exec Procedures_StudentSendingCHRequest 1,2,'course','comment'

--2 3 ff
CREATE FUNCTION FN_StudentViewGP
(@student_ID INT)
RETURNS Table
AS
RETURN (SELECT GP.student_id, S.f_name AS student_first_name, S.l_name AS student_last_name, GP.plan_id, C.course_id, C.name, GP.semester_code, GP.expected_grad_date, GP.semester_credit_hours, GP.advisor_id
        FROM Graduation_Plan GP INNER JOIN GradPlan_Course GPC ON (GP.plan_id=GPC.plan_id AND GP.semester_code=GPC.semester_code) INNER JOIN Student S ON GP.student_id=S.student_id INNER JOIN Course C ON GPC.course_id=C.course_id
        WHERE GP.student_id=@student_ID)

select * from dbo.FN_StudentViewGP(1)

--2 3 gg
CREATE FUNCTION FN_StudentUpcoming_installment
(@StudentID int)
RETURNS DATETIME
AS
BEGIN
DECLARE @deadline DATETIME
SELECT TOP 1 @deadline=I.deadline
FROM Installment I INNER JOIN Payment P ON I.payment_id = P.payment_id
WHERE P.student_id = @StudentID AND I.status = 'Notpaid'
ORDER BY I.deadline
RETURN @deadline
END


DECLARE @deadline DATETIME
SET @deadline=dbo.FN_StudentUpcoming_installment(1)
print @deadline

--2 3 hh
CREATE FUNCTION FN_StudentViewSlot
(@CourseID int, 
@InstructorID int)
RETURNS TABLE
AS 
RETURN (SELECT S.slot_id, S.location, S.time, S.day,C.name AS course_name, I.name AS instructor_name
        FROM Slot S INNER JOIN Course C ON S.course_id=C.course_id INNER JOIN Instructor I ON I.instructor_id=S.instructor_id
        WHERE S.course_id=@CourseID AND S.instructor_id=@InstructorID)

select * from dbo.FN_StudentViewSlot(1,1)

--2 3 II
DROP PROC Procedures_StudentRegisterFirstMakeup
CREATE PROC Procedures_StudentRegisterFirstMakeup
@StudentID INT,
@courseID INT,
@studentCurrent_semester VARCHAR(40)
AS
DECLARE @exid INT
DECLARE @semno INT
DECLARE @semnomod INT
DECLARE @evod VARCHAR(40)
DECLARE @grade VARCHAR(40)
DECLARE @count INT
DECLARE @currDate DATETIME = CURRENT_TIMESTAMP;

SELECT top 1 @exid=exam_id--i got the 1st upcoming fisr makeup exam id for this course
FROM MakeUp_Exam 
WHERE course_id=@courseID AND type='First Makeup' AND date>@currdate
order by date

SELECT @grade=grade----the student’s grade in the normal exam should be null, ‘FF’, or ‘F’
FROM Student_Instructor_Course_Take
WHERE student_id=@StudentID AND course_id=@courseID AND exam_type='Normal'

SELECT @count=count(exam_id)--the student shouldn’t have taken any makeup exam before in this course
FROM Exam_Student
WHERE student_id=@StudentID AND course_id=@courseID

IF (@grade IS NOT NULL AND @grade<>'FF' AND @grade<>'F') OR @count>0
begin
Print('This student is not elligible for the first makeup')
end
ELSE
begin
INSERT INTO Exam_Student
VALUES(@exid,@StudentID,@courseID)
INSERT INTO Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type)
VALUES(@StudentID,@courseID,@studentCurrent_semester,'First Makeup')
end

EXEC Procedures_StudentRegisterFirstMakeup 1, 1,'W23'

--2 3 jj 
drop function FN_StudentCheckSMEligiability
CREATE FUNCTION FN_StudentCheckSMEligiability
(@CourseID int, 
@StudentID int)
RETURNS BIT
AS 
BEGIN
DECLARE @O BIT
DECLARE @failodd INT 
DECLARE @faileven INT
DECLARE @count INT

SELECT @failodd=COUNT(SIC.course_id)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@StudentID AND (SIC.grade='F' OR SIC.grade='FF' OR SIC.grade='FA') AND (semester_code LIKE '%W%' OR semester_code LIKE '%S__R1%') AND C.semester%2=1

SELECT @faileven=COUNT(SIC.course_id)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@StudentID AND (SIC.grade='F' OR SIC.grade='FF' OR SIC.grade='FA') AND (semester_code LIKE '%S__' OR semester_code LIKE '%S__R2%') AND C.semester%2=0

SELECT @count=count(course_id)
FROM Student_Instructor_Course_Take
WHERE @StudentID=student_id AND @courseID=course_id AND exam_type='First Makeup' AND (grade='F' OR grade='FF' OR grade='FA' OR grade IS NULL)--counts 1 if the makeup is failed or not attended



IF @count>0 AND @failodd<=2 AND @faileven<=2
SET @O='1'
ELSE
SET @O='0'

Return @O
END

--2 3 kk
drop proc Procedures_StudentRegisterSecondMakeup
CREATE PROC Procedures_StudentRegisterSecondMakeup
@StudentID int, 
@courseID int, 
@Student_Current_Semester Varchar (40)
AS
BEGIN
DECLARE @currDate DATETIME = CURRENT_TIMESTAMP;
DECLARE @exid INT 
DECLARE @elig BIT = DBO.FN_StudentCheckSMEligiability(@courseID,@StudentID)
SELECT top 1 @exid=exam_id 
FROM MakeUp_Exam 
WHERE course_id=@courseID AND @currdate<date AND type='Second Makeup' 
order by date
IF @elig='1'
BEGIN
INSERT INTO Exam_Student
VALUES(@exid,@StudentID,@courseID)
INSERT INTO Student_Instructor_Course_Take(student_id,course_id,semester_code,exam_type)
VALUES(@StudentID,@courseID,@student_Current_semester,'Second Makeup')
END
ELSE
begin
Print('This student is not elligible for the second makeup')
END
end

select * from Student_Instructor_Course_Take
select * from Exam_Student
select * from MakeUp_Exam
select * from course
INSERT INTO Student_Instructor_Course_Take(instructor_id,course_id, semester_code, student_id, grade)
VALUES(1,1, 's23',2,'F')
INSERT INTO Student_Instructor_Course_Take(instructor_id,course_id, semester_code, student_id, grade)
VALUES(5,5, 's23',2,'F')
INSERT INTO Student_Instructor_Course_Take(instructor_id,course_id, semester_code, student_id, grade)
VALUES(8,8, 's23',2,'F')
exec Procedures_StudentRegisterSecondMakeup 2, 2 ,'S23'
UPDate Student_Instructor_Course_Take set grade='f' where student_id=2
exec clearAllTables
exec insertions
UPDATE MakeUp_Exam SET type='Second makeup' where exam_id=2
update MakeUp_Exam set date='2024-11-11' where exam_id=2
--2 3 LL


CREATE PROC Procedures_ViewRequiredCourses
@StudentID int,
@Current_semester_code Varchar (40)
AS
DECLARE @currstart DATETIME
DECLARE @semint INT
DECLARE @faileven INT
DECLARE @failodd INT

SELECT @semint=semester--student's current semester
FROM Student 
WHERE student_id=@StudentID

SELECT @failodd=COUNT(SIC.course_id)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@StudentID AND (SIC.grade='F' OR SIC.grade='FF' OR SIC.grade='FA') AND (semester_code LIKE '%W%' OR semester_code LIKE '%S__R1%') AND C.semester%2=1

SELECT @faileven=COUNT(SIC.course_id)
FROM Student_Instructor_Course_Take SIC INNER JOIN Course C ON SIC.course_id=C.course_id
WHERE SIC.student_id=@StudentID AND (SIC.grade='F' OR SIC.grade='FF' OR SIC.grade='FA') AND (semester_code LIKE '%S__' OR semester_code LIKE '%S__R2%') AND C.semester%2=0

SELECT C.*
FROM Courses C INNER JOIN Student_Instructor_Course_Take SIC ON C.course_id=SIC.course_id INNER JOIN Student S ON S.student_id=SIC.student_id INNER JOIN Course_Semester CS ON CS.course_id=C.course_id 
WHERE ((SIC.student_id=@StudentID AND (SIC.grade='F' OR SIC.grade='FF' OR SIC.grade='FA') AND--failed this course before
       (((exam_type='First MakeUp' AND grade<>'FF' OR grade<>'FA' or grade<>'F' or grade IS NOT NULL) OR--and attended and passed 1st makeup
       (@faileven>2 OR @failodd>2))))--and failed more than 2 courses in odd or even semesters 
       OR 
       (SIC.student_id=@StudentID AND S.major=C.major AND C.semester<@semint AND C.course_id NOT IN (SELECT C1.course_id
                                                                                                     FROM Student_Instructor_Course_Take SIC INNER JOIN Course C1 ON C1.course_id=SIC.course_id
                                                                                                     WHERE @StudentID=SIC.student_id AND SIC.grade IS NOT NULL)))
       AND
       CS.semester_code=@Current_semester_code

--2 3 MM
CREATE PROC Procedures_ViewOptionalCourse
@StudentID int,
@Current_semester_code Varchar (40)
AS
DECLARE @semint INT
DECLARE @major VARCHAR(40)
SELECT @semint=semester, @major=major
FROM Student 
WHERE @StudentID=student_id
SELECT C.* 
FROM Course C 
WHERE C.semester>=@semint AND C.major=@major AND NOT EXISTS(SELECT * 
                                                            FROM PreqCourse_course PR INNER JOIN Student_Instructor_Course_Take SIC ON PR.course_id=SIC.course_id
                                                            WHERE PR.course_id=C.course_id AND SIC.student_id=@StudentID AND grade IS NULL)--there doesnt exist a prereq that the student did not take (grade is null)

--2 3 nn
CREATE PROC Procedures_ViewMS
@studentID INT
AS
DECLARE @stmaj VARCHAR(40)
SELECT @stmaj=major
FROM Student
WHERE @studentID=student_id
SELECT C.*
FROM Course C 
WHERE C.major=@stmaj AND C.course_id NOT IN (SELECT course_id
                                              FROM Student_Instructor_Course_Take
                                              WHERE student_id=@studentID AND grade IS NOT NULL AND grade<>'F' AND grade<>'FF' AND grade<>'FA')

EXEC Procedures_ViewMS 1

--2 3 oo
CREATE PROC [Procedures_ChooseInstructor]
@Student_Id int,
@Instructor_Id int,
@Course_Id int,
@current_semester_code varchar(40)
AS
DECLARE @count int
select @count=count(Instructor_id)
from Instructor_Course
where instructor_id=@Instructor_Id AND course_id=@Course_Id
if @count=0
begin
insert into Instructor_Course
values(@Course_Id,@Instructor_Id)
UPDATE Student_Instructor_Course_Take
SET instructor_id = @Instructor_ID
WHERE student_id = @Student_Id AND course_id = @Course_Id AND semester_code=@current_semester_code;
end
else
begin
UPDATE Student_Instructor_Course_Take
SET instructor_id = @Instructor_ID
WHERE student_id = @Student_Id AND course_id = @Course_Id AND semester_code=@current_semester_code;
end

exec [Procedures_ChooseInstructor] 1,2,1,'w23'
