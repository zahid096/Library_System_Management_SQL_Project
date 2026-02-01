-- Active: 1766597285355@@localhost@3306@library_management_system
CREATE DATABASE Library_Management_System;

use Library_Management_System;

--Create table "Branch"
DROP TABLE IF EXISTS branch;

CREATE TABLE branch (
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);

--Create table "Books"
DROP TABLE IF EXISTS books;

CREATE TABLE books (
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10, 2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(50)
);

--create table "Employee"
DROP Table IF EXISTS employees;

CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(30),
    salary DECIMAL(10, 2),
    branch_id VARCHAR(10),
    FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
);

--Create table "Members"
DROP TABLE IF EXISTS members;

CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(100),
    reg_date DATE
);

--Create table IssueStatus
DROP Table IF EXISTS issue_status;

CREATE Table issue_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(30),
    issued_book_name VARCHAR(80),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),
    Foreign Key (issued_member_id) REFERENCES members (member_id),
    Foreign Key (issued_book_isbn) REFERENCES books (isbn),
    Foreign Key (issued_emp_id) REFERENCES employees (emp_id)
);

--Create Table Return_status
DROP Table IF EXISTS return_status;

CREATE Table return_status (
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(30),
    return_book_name VARCHAR(80),
    return_date DATE,
    return_book_isbn VARCHAR(50),
    FOREIGN KEY (return_book_isbn) REFERENCES books (isbn)
);

--Table create done