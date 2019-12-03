create table student (id int primary key AUTO_INCREMENT,name varchar(50) NOT NULL,email varchar(50) NOT NULL,address varchar(100) NOT NULL ,CONSTRAINT uc_email UNIQUE (email));
create table subject (id int primary key AUTO_INCREMENT,name varchar(50) NOT NULL);
create table marks(id int primary key AUTO_INCREMENT,student_id int not null,subject_id int not null, marks int not null CONSTRAINT `marks_chk` CHECK (`marks` >= 0) CHECK (`marks` <= 100));
create table project (id int primary key AUTO_INCREMENT,project_name varchar(50) not null,student_id int not null unique,start_date date not null,end_date date not null);

truncate table student;
truncate table subject;
truncate table marks;
truncate table project;

drop table student;
drop table subject;
drop table marks;
drop table project;

select * from student;
select * from subject;
select * from marks;
select * from project;
