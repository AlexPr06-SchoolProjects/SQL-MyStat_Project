-- student
-- teacher
-- grade
-- homework 
-- pair                  # - начать с того, что будет обновлятся каждый день
-- schedule-items
-- subject
-- group
-- ....
-----------


--! Create database
 
	-- FIRST
	IF DB_ID('p41_mystat_db') IS NULL
	BEGIN
		CREATE DATABASE p41_mystat_db;
	END
	-- SECOND
	USE p41_mystat_db;

--! Drop database 
USE master;
ALTER DATABASE p41_mystat_db
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
DROP DATABASE IF EXISTS p41_mystat_db;


--! schedule-items
CREATE TABLE schedule_items(
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	number tinyint NOT NULL,
	item_start time NOT NULL,
	item_end time NOT NULL,
	status tinyint DEFAULT(1) NOT NULL,
);


--! subjects
CREATE TABLE subjects(
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	name nvarchar(50) NULL,

	CONSTRAINT UC_subjects_name UNIQUE (name)
);


--! groups
CREATE TABLE groups(
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	name nvarchar(50) NULL,

	CONSTRAINT UC_groups_name UNIQUE (name)
);


--! groups_subjects
CREATE TABLE groups_subjects (
	id int PRIMARY KEY IDENTITY(1, 1),
	group_id int NOT NULL,
	subject_id int NOT NULL

	CONSTRAINT PK_groups_subjects UNIQUE(group_id, subject_id),
	CONSTRAINT FK_groups_subjects_group_id FOREIGN KEY (group_id) REFERENCES groups(id),
	CONSTRAINT FK_groups_subjects_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id),
);


--! pairs
CREATE TABLE pairs (
	id int PRIMARY KEY IDENTITY(1, 1) 	NOT NULL,
	pair_date datetime					NOT NULL,
	schedule_item_id int 				NOT NULL,
	group_subject_id int				NOT NULL,

	CONSTRAINT FK_pairs_schedule_items FOREIGN KEY (schedule_item_id) REFERENCES schedule_items(id),
	CONSTRAINT FK_pairs_group_subject_id FOREIGN KEY (group_subject_id) REFERENCES groups_subjects(id)
);



--! students
CREATE TABLE students (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	first_name nvarchar(50) NULL,
	last_name nvarchar(50) NULL,
	group_id int NOT NULL,

	CONSTRAINT FK_students_groups FOREIGN KEY (group_id) REFERENCES groups(id)
);

--! teachers
CREATE TABLE teachers (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	first_name nvarchar(50) NULL,
	last_name nvarchar(50) NULL,
	group_id int NOT NULL,

	CONSTRAINT FK_teachers_groups FOREIGN KEY (group_id) REFERENCES groups(id)
);

------------------------------------------------------
--TODO: grade logic

CREATE TABLE grades (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	student_id int NOT NULL,
	subject_id int NOT NULL,
	grade int NULL,

	CONSTRAINT FK_grades_students FOREIGN KEY (student_id) REFERENCES students(id),
	CONSTRAINT FK_grades_subjects FOREIGN KEY (subject_id) REFERENCES subjects(id)
);


--TODO: grade logic
------------------------------------------------------

------------------------------------------------------
--TODO: homework

CREATE TABLE homeworks (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	name nvarchar(50) NULL,
	task nvarchar(1000) NULL,
	reference nvarchar(50) NULL,
	groups_subjects_id int NOT NULL,
	teacher_id int NOT NULL,

	CONSTRAINT FK_homework_teachers FOREIGN KEY (teacher_id) REFERENCES teachers(id),
	CONSTRAINT FK_homework_groups_subjects FOREIGN KEY (groups_subjects_id) REFERENCES groups_subjects(id)
);

--TODO: homework
------------------------------------------------------
--! DROPS
DROP TABLE schedule_items;
DROP TABLE pairs;
DROP TABLE subjects;
DROP TABLE groups;
DROP TABLE students;
DROP TABLE teachers;
DROP TABLE groups_subjects;
DROP TABLE grades;
DROP TABLE homeworks;


