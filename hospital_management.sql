-- =========================================================
-- HOSPITAL MANAGEMENT SYSTEM
-- Simple DBMS Project - MySQL
-- =========================================================


-- =========================================================
-- 2. CREATE TABLES
-- =========================================================

-- DEPARTMENT TABLE
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);


-- DOCTOR TABLE
CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    phone VARCHAR(15),
    department_id INT,

    FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);


-- PATIENT TABLE
CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    city VARCHAR(50)
);


-- APPOINTMENT TABLE
CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    appointment_time TIME,
    status VARCHAR(20),

    FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);


-- TREATMENT TABLE
CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    diagnosis VARCHAR(100),
    treatment_description VARCHAR(200),
    treatment_cost DECIMAL(10,2),

    FOREIGN KEY (appointment_id)
        REFERENCES Appointment(appointment_id)
);


-- BILL TABLE
CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    bill_date DATE,
    amount DECIMAL(10,2),
    payment_status VARCHAR(20),

    FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id)
);


-- =========================================================
-- 3. INSERT SAMPLE DATA
-- =========================================================

-- DEPARTMENTS
INSERT INTO Department VALUES
(1, 'Cardiology', 'Block A'),
(2, 'Neurology', 'Block B'),
(3, 'Orthopedics', 'Block C'),
(4, 'General Medicine', 'Block D');


-- DOCTORS
INSERT INTO Doctor VALUES
(101, 'Dr. Arun Kumar', 'Cardiologist', '9876543210', 1),
(102, 'Dr. Priya Sharma', 'Neurologist', '9876543211', 2),
(103, 'Dr. Ravi Kumar', 'Orthopedic', '9876543212', 3),
(104, 'Dr. Meena Raj', 'General Physician', '9876543213', 4),
(105, 'Dr. Karthik', 'Cardiologist', '9876543214', 1);


-- PATIENTS
INSERT INTO Patient VALUES
(1, 'Sathish Kumar', 18, 'Male', '9000000001', 'Coimbatore'),
(2, 'Arun Prakash', 25, 'Male', '9000000002', 'Chennai'),
(3, 'Priya Devi', 32, 'Female', '9000000003', 'Coimbatore'),
(4, 'Rahul Kumar', 45, 'Male', '9000000004', 'Erode'),
(5, 'Divya Raj', 28, 'Female', '9000000005', 'Salem'),
(6, 'Vijay Anand', 52, 'Male', '9000000006', 'Coimbatore');


-- APPOINTMENTS
INSERT INTO Appointment VALUES
(1001, 1, 104, '2026-10-01', '10:00:00', 'Completed'),
(1002, 2, 101, '2026-10-02', '11:00:00', 'Completed'),
(1003, 3, 102, '2026-10-03', '09:30:00', 'Completed'),
(1004, 4, 103, '2026-10-04', '14:00:00', 'Pending'),
(1005, 5, 104, '2026-10-05', '10:30:00', 'Completed'),
(1006, 6, 105, '2026-10-06', '12:00:00', 'Pending');


-- TREATMENTS
INSERT INTO Treatment VALUES
(501, 1001, 'Fever', 'General medication and rest', 500.00),
(502, 1002, 'Heart Checkup', 'ECG and cardiac examination', 2500.00),
(503, 1003, 'Migraine', 'Medication and neurological examination', 1800.00),
(504, 1004, 'Knee Pain', 'X-Ray and physiotherapy', 2200.00),
(505, 1005, 'Cold and Cough', 'Medication and consultation', 700.00),
(506, 1006, 'Chest Pain', 'ECG and heart examination', 3000.00);


-- BILLS
INSERT INTO Bill VALUES
(9001, 1, '2026-10-01', 500.00, 'Paid'),
(9002, 2, '2026-10-02', 2500.00, 'Paid'),
(9003, 3, '2026-10-03', 1800.00, 'Paid'),
(9004, 4, '2026-10-04', 2200.00, 'Pending'),
(9005, 5, '2026-10-05', 700.00, 'Paid'),
(9006, 6, '2026-10-06', 3000.00, 'Pending');


-- =========================================================
-- 4. BASIC QUERIES
-- =========================================================

-- Display all patients
SELECT * FROM Patient;

-- Display all doctors
SELECT * FROM Doctor;

-- Display patients from Coimbatore
SELECT *
FROM Patient
WHERE city = 'Coimbatore';

-- Display patients above age 30
SELECT *
FROM Patient
WHERE age > 30;

-- Display pending bills
SELECT *
FROM Bill
WHERE payment_status = 'Pending';


-- =========================================================
-- 5. JOIN QUERIES
-- =========================================================

-- Patient + Doctor + Appointment
SELECT
    p.patient_name,
    d.doctor_name,
    a.appointment_date,
    a.status
FROM Patient p
JOIN Appointment a
    ON p.patient_id = a.patient_id
JOIN Doctor d
    ON a.doctor_id = d.doctor_id;


-- Doctor + Department
SELECT
    d.doctor_name,
    d.specialization,
    dp.department_name
FROM Doctor d
JOIN Department dp
    ON d.department_id = dp.department_id;


-- Patient + Treatment
SELECT
    p.patient_name,
    t.diagnosis,
    t.treatment_description,
    t.treatment_cost
FROM Patient p
JOIN Appointment a
    ON p.patient_id = a.patient_id
JOIN Treatment t
    ON a.appointment_id = t.appointment_id;


-- Patient + Bill
SELECT
    p.patient_name,
    b.bill_date,
    b.amount,
    b.payment_status
FROM Patient p
JOIN Bill b
    ON p.patient_id = b.patient_id;


-- =========================================================
-- 6. AGGREGATE QUERIES
-- =========================================================

-- Total number of patients
SELECT COUNT(*) AS total_patients
FROM Patient;


-- Average patient age
SELECT AVG(age) AS average_age
FROM Patient;


-- Maximum treatment cost
SELECT MAX(treatment_cost) AS highest_treatment_cost
FROM Treatment;


-- Minimum treatment cost
SELECT MIN(treatment_cost) AS lowest_treatment_cost
FROM Treatment;


-- Total hospital revenue
SELECT SUM(amount) AS total_revenue
FROM Bill
WHERE payment_status = 'Paid';


-- Number of doctors in each department
SELECT
    department_id,
    COUNT(*) AS doctor_count
FROM Doctor
GROUP BY department_id;


-- =========================================================
-- 7. SUBQUERIES
-- =========================================================

-- Patients older than the average patient age
SELECT patient_name, age
FROM Patient
WHERE age > (
    SELECT AVG(age)
    FROM Patient
);


-- Treatment costing more than the average treatment
SELECT
    diagnosis,
    treatment_cost
FROM Treatment
WHERE treatment_cost > (
    SELECT AVG(treatment_cost)
    FROM Treatment
);


-- Patient with the highest bill
SELECT
    patient_name
FROM Patient
WHERE patient_id = (
    SELECT patient_id
    FROM Bill
    WHERE amount = (
        SELECT MAX(amount)
        FROM Bill
    )
);


-- Doctors working in Cardiology
SELECT doctor_name
FROM Doctor
WHERE department_id = (
    SELECT department_id
    FROM Department
    WHERE department_name = 'Cardiology'
);


-- =========================================================
-- 8. UPDATE AND DELETE
-- =========================================================

-- Update patient city
UPDATE Patient
SET city = 'Tiruppur'
WHERE patient_id = 5;

-- Check updated record
SELECT *
FROM Patient
WHERE patient_id = 5;


-- Update pending bill
UPDATE Bill
SET payment_status = 'Paid'
WHERE bill_id = 9004;


-- =========================================================
-- 9. VIEW
-- =========================================================

CREATE VIEW Patient_Appointment_View AS
SELECT
    p.patient_id,
    p.patient_name,
    d.doctor_name,
    dp.department_name,
    a.appointment_date,
    a.status
FROM Patient p
JOIN Appointment a
    ON p.patient_id = a.patient_id
JOIN Doctor d
    ON a.doctor_id = d.doctor_id
JOIN Department dp
    ON d.department_id = dp.department_id;


-- Display the view
SELECT *
FROM Patient_Appointment_View;


-- =========================================================
-- 10. TRANSACTION
-- =========================================================

START TRANSACTION;

-- Change a pending bill to paid
UPDATE Bill
SET payment_status = 'Paid'
WHERE bill_id = 9006;

-- Check the change
SELECT *
FROM Bill
WHERE bill_id = 9006;

-- Save the transaction
COMMIT;


-- =========================================================
-- 11. FINAL REPORT QUERIES
-- =========================================================

-- Complete patient report
SELECT
    p.patient_name,
    p.age,
    p.gender,
    d.doctor_name,
    dp.department_name,
    t.diagnosis,
    t.treatment_cost,
    b.amount,
    b.payment_status
FROM Patient p
JOIN Appointment a
    ON p.patient_id = a.patient_id
JOIN Doctor d
    ON a.doctor_id = d.doctor_id
JOIN Department dp
    ON d.department_id = dp.department_id
JOIN Treatment t
    ON a.appointment_id = t.appointment_id
JOIN Bill b
    ON p.patient_id = b.patient_id;


-- Total amount collected
SELECT
    SUM(amount) AS total_amount_collected
FROM Bill
WHERE payment_status = 'Paid';


-- Pending payment amount
SELECT
    SUM(amount) AS pending_amount
FROM Bill
WHERE payment_status = 'Pending';


-- =========================================================
-- END OF PROJECT
-- =========================================================
