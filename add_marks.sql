CREATE PROCEDURE `add_marks`(
inputProjectName VARCHAR(50)
    ,inputStudentId int
     ,inputStartDate date
     ,inputEndDate date
      ,inputMarks int
      ,subjectId int
    ,out tranStatus varchar(50) 
)
BEGIN
DECLARE `should_rollback` boolean DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `should_rollback` = TRUE;
  SET autocommit=0;
    START TRANSACTION;
    IF EXISTS (SELECT id FROM student where id=InputStudentId) THEN
insert into project (project_name,student_id,start_date,end_date) values (inputProjectName,inputStudentId,inputStartDate,inputEndDate);
insert into marks (student_id,subject_id,marks) values(inputStudentId,subjectId,inputMarks);
IF `should_rollback` THEN
	SET TranStatus="error occured";
    ROLLBACK;
ELSE
	SET TranStatus="Success";
    COMMIT;
END IF;
else
SET TranStatus="student not available";
END IF;
END