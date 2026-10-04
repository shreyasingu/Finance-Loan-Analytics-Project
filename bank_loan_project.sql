CREATE DATABASE bank_loan_project;
USE bank_loan_project;
SELECT * FROM Finance1 limit 10;
SELECT * FROM Finance2 LIMIT 10;
-- check number of records
SELECT COUNT(*) AS total_records FROM Finance1;
SELECT COUNT(*) AS total_records FROM Finance2;
-- Check whether IDs match
SELECT COUNT(*) FROM Finance1 F1 JOIN Finance2 F2 ON F1.id = F2.id;
-- Understand the JOIN
SELECT * FROM Finance1 F1 JOIN Finance2 F2 ON F1.id = F2.id;
-- Create a combined view
CREATE VIEW loan_data AS
SELECT F1.id, F1.member_id, F1.loan_amnt, F1.funded_amnt, F1.term, F1.int_rate, F1.installment, F1.grade, F1.sub_grade, F1.emp_length, F1.home_ownership,
    F1.annual_inc, F1.verification_status, F1.issue_d, F1.loan_status, F1.purpose, F1.addr_state, F1.dti, F2.revol_bal, F2.revol_util, F2.total_pymnt,
    F2.total_pymnt_inv, F2.total_rec_prncp, F2.total_rec_int, F2.total_rec_late_fee, F2.recoveries, F2.last_pymnt_d, F2.last_pymnt_amnt
FROM Finance1 F1
JOIN Finance2 F2
ON F1.id = F2.id;
SELECT * FROM loan_data LIMIT 10;
-- KPI 1 — Year-wise Loan Amount Statistics
SELECT YEAR(issue_d) AS loan_year, COUNT(*) AS total_loans, SUM(loan_amnt) AS total_loan_amount, AVG(loan_amnt) AS average_loan_amount,
    MIN(loan_amnt) AS minimum_loan, MAX(loan_amnt) AS maximum_loan FROM loan_data GROUP BY YEAR(issue_d) ORDER BY loan_year;
-- KPI 2 — Grade and Sub-Grade-wise Revolving Balance
SELECT grade, sub_grade, COUNT(*) AS total_customers, SUM(revol_bal) AS total_revol_bal, AVG(revol_bal) AS average_revol_bal
FROM loan_data GROUP BY grade, sub_grade ORDER BY grade, sub_grade;
-- KPI 3 — Total Payment: Verified vs Non-Verified
SELECT verification_status, COUNT(*) AS total_loans, SUM(total_pymnt) AS total_payment, AVG(total_pymnt) AS average_payment
FROM loan_data GROUP BY verification_status;
-- KPI 4 — State-wise and Month-wise Loan Status
SELECT addr_state AS state, MONTH(issue_d) AS loan_month, loan_status, COUNT(*) AS total_loans FROM loan_data GROUP BY addr_state, MONTH(issue_d),
    loan_status ORDER BY addr_state, loan_month, loan_status;
-- KPI 5 — Home Ownership vs Last Payment Date Statistics
SELECT home_ownership, COUNT(*) AS total_loans, MIN(last_pymnt_d) AS earliest_payment_date, MAX(last_pymnt_d) AS latest_payment_date,
    AVG(last_pymnt_amnt) AS average_last_payment FROM loan_data GROUP BY home_ownership ORDER BY home_ownership;

    