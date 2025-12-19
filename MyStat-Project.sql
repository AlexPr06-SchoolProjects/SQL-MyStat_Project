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



CREATE TABLE countries (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(64) NULL
);

CREATE TABLE cities (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(64) NULL,
	country_id int NOT NULL,

	CONSTRAINT FK_cities_countries FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE branches (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(64) NULL,
	city_id int NOT NULL,

	CONSTRAINT FK_branches_cities FOREIGN KEY (city_id) REFERENCES cities(id),
	CONSTRAINT FK_branches_countries FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE TABLE classrooms (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	number nvarchar(32) NOT NULL,
	title nvarchar(64) NULL,
	branch_id int NOT NULL,

	CONSTRAINT FK_classrooms_branch_id FOREIGN KEY (branch_id) REFERENCES branches(id)
);

--! schedule-items
CREATE TABLE schedule_items(
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	number tinyint NOT NULL,
	item_start time NOT NULL,
	item_end time NOT NULL,
	status tinyint DEFAULT(1) NOT NULL,
);

CREATE TABLE flows (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(128) NOT NULL,
	created_at datetime DEFAULT(GETDATE()) NOT NULL,
	deleted_at datetime NULL,
);

CREATE TABLE subjects (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(128) NOT NULL,
	deleted_at datetime NULL,
	flow_id int NOT NULL,

	CONSTRAINT FK_subjects_flows FOREIGN KEY (flow_id) REFERENCES flows(id)
);








---- Auth

CREATE TABLE users (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	email nvarchar(128) NOT NULL,
	pass_hash char(256) NOT NULL,
	created_at datetime DEFAULT(GETDATE()) NOT NULL,
	deleted_at datetime NULL
);

CREATE TABLE roles (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(32) NOT NULL,
	slug nvarchar(32) UNIQUE NOT NULL,
);

CREATE TABLE permissions (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(128) NOT NULL,
	slug nvarchar(128) UNIQUE NOT NULL,
);


CREATE TABLE permissions_roles (
	permission_id int NOT NULL,
	role_id int NOT NULL,

	CONSTRAINT PK_permissions_roles PRIMARY KEY (permission_id, role_id),
	CONSTRAINT FK_permissions_roles_permission FOREIGN KEY (permission_id) REFERENCES permissions(id),
	CONSTRAINT FK_permissions_roles_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE roles_users (
	role_id int NOT NULL,
	user_id int NOT NULL,

	CONSTRAINT PK_roles_users PRIMARY KEY (role_id, user_id),
	CONSTRAINT FK_roles_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
	CONSTRAINT FK_roles_users_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE permission_users (
	permission_id int NOT NULL,
	user_id int NOT NULL,

	CONSTRAINT PK_permission_users PRIMARY KEY (permission_id, user_id),
	CONSTRAINT FK_permission_users_permission FOREIGN KEY (permission_id) REFERENCES permissions(id),
	CONSTRAINT FK_permission_users_user FOREIGN KEY (user_id) REFERENCES users(id)
);

---profiles

CREATE TABLE employee_profiles (
	id int PRIMARY KEY NOT NULL,
	first_name nvarchar(64) NOT NULL,
	last_name nvarchar(64) NOT NULL,
	phone varchar(32) NOT NULL,
	-- ....

	CONSTRAINT FK_employee_profiles_user FOREIGN KEY (id) REFERENCES users(id)
);


CREATE TABLE student_profiles (
	id int PRIMARY KEY NOT NULL,
	first_name nvarchar(64) NOT NULL,
	last_name nvarchar(64) NOT NULL,
	phone varchar(32) NOT NULL,
	-- ....

	CONSTRAINT FK_student_profiles_user FOREIGN KEY (id) REFERENCES users(id)
);


CREATE TABLE groups (
	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	title nvarchar(32) NOT NULL,
	status tinyint DEFAULT(1) NOT NULL,
	flow_id int NOT NULL,

	CONSTRAINT FK_groups_flows FOREIGN KEY (flow_id) REFERENCES flows(id)
);

--! pairs
CREATE TABLE pairs (
	id int PRIMARY KEY IDENTITY(1, 1) 	NOT NULL,
	pair_date datetime					NOT NULL,

	is_online bit  DEFAULT(1)			NOT NULL,
	schedule_item_id int 				NOT NULL,
	subject_id int NOT NULL,
	classroom_id int NOT NULL,
	teacher_id int NOT NULL,

	CONSTRAINT FK_pairs_schedule_item FOREIGN KEY(schedule_item_id) REFERENCES schedule_items(id),
	CONSTRAINT FK_pairs_subject FOREIGN KEY(subject_id) REFERENCES subjects(id),
	CONSTRAINT FK_pairs_classroom FOREIGN KEY(classroom_id) REFERENCES classrooms(id),
	CONSTRAINT FK_pairs_teacher FOREIGN KEY(teacher_id) REFERENCES employee_profiles(id)
);


CREATE TABLE groups_pairs (
	group_id int NOT NULL,
	pair_id int NOT NULL,

	CONSTRAINT PK_groups_pairs PRIMARY KEY (group_id, pair_id),
	CONSTRAINT FK_groups_pairs_group FOREIGN KEY (group_id) REFERENCES groups(id),
	CONSTRAINT FK_groups_pairs_pair FOREIGN KEY (pair_id) REFERENCES pairs(id)
);






















----! subjects
--CREATE TABLE subjects(
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	name nvarchar(50) NULL,

--	CONSTRAINT UC_subjects_name UNIQUE (name)
--);


----! groups
--CREATE TABLE groups(
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	name nvarchar(50) NULL,

--	CONSTRAINT UC_groups_name UNIQUE (name)
--);


----! groups_subjects
--CREATE TABLE groups_subjects (
--	id int PRIMARY KEY IDENTITY(1, 1),
--	group_id int NOT NULL,
--	subject_id int NOT NULL

--	CONSTRAINT PK_groups_subjects UNIQUE(group_id, subject_id),
--	CONSTRAINT FK_groups_subjects_group_id FOREIGN KEY (group_id) REFERENCES groups(id),
--	CONSTRAINT FK_groups_subjects_subject_id FOREIGN KEY (subject_id) REFERENCES subjects(id),
--);


----! pairs
--CREATE TABLE pairs (
--	id int PRIMARY KEY IDENTITY(1, 1) 	NOT NULL,
--	pair_date datetime					NOT NULL,
--	schedule_item_id int 				NOT NULL,
--	group_subject_id int				NOT NULL,

--	CONSTRAINT FK_pairs_schedule_items FOREIGN KEY (schedule_item_id) REFERENCES schedule_items(id),
--	CONSTRAINT FK_pairs_group_subject_id FOREIGN KEY (group_subject_id) REFERENCES groups_subjects(id)
--);



----! students
--CREATE TABLE students (
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	first_name nvarchar(50) NULL,
--	last_name nvarchar(50) NULL,
--	group_id int NOT NULL,

--	CONSTRAINT FK_students_groups FOREIGN KEY (group_id) REFERENCES groups(id)
--);

----! teachers
--CREATE TABLE teachers (
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	first_name nvarchar(50) NULL,
--	last_name nvarchar(50) NULL,
--	group_id int NOT NULL,

--	CONSTRAINT FK_teachers_groups FOREIGN KEY (group_id) REFERENCES groups(id)
--);

--------------------------------------------------------
----TODO: grade logic

--CREATE TABLE grades (
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	student_id int NOT NULL,
--	subject_id int NOT NULL,
--	grade int NULL,

--	CONSTRAINT FK_grades_students FOREIGN KEY (student_id) REFERENCES students(id),
--	CONSTRAINT FK_grades_subjects FOREIGN KEY (subject_id) REFERENCES subjects(id)
--);


----TODO: grade logic
--------------------------------------------------------

--------------------------------------------------------
----TODO: homework

--CREATE TABLE homeworks (
--	id int PRIMARY KEY IDENTITY(1, 1) NOT NULL,
--	name nvarchar(50) NULL,
--	task nvarchar(1000) NULL,
--	reference nvarchar(50) NULL,
--	groups_subjects_id int NOT NULL,
--	teacher_id int NOT NULL,

--	CONSTRAINT FK_homework_teachers FOREIGN KEY (teacher_id) REFERENCES teachers(id),
--	CONSTRAINT FK_homework_groups_subjects FOREIGN KEY (groups_subjects_id) REFERENCES groups_subjects(id)
--);

--TODO: homework
------------------------------------------------------
--! DROPS
DROP TABLE IF EXISTS groups_subjects;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS pairs;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS homeworks;
DROP TABLE IF EXISTS employee_profiles;
DROP TABLE IF EXISTS student_profiles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS permissions_roles;
DROP TABLE IF EXISTS roles_users;
DROP TABLE IF EXISTS permission_users;
DROP TABLE IF EXISTS schedule_items;
DROP TABLE IF EXISTS classrooms;
DROP TABLE IF EXISTS flows;


