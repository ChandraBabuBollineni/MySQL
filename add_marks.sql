CREATE DEFINER=`root`@`localhost` PROCEDURE `add_marks`(
Input_Project_Name VARCHAR(50)
    ,Input_Student_Id int
     ,Input_Start_Date date
     ,Input_End_Date date
      ,Input_Marks int
    ,out tran_status varchar(50) 
)
BEGIN
DECLARE `should_rollback` boolean DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `should_rollback` = TRUE;
  SET autocommit=0;
    START TRANSACTION;
    IF EXISTS (SELECT student_id FROM db1.student where student_id=Input_Student_Id) THEN
insert into project (project_name,student_id,start_date,end_date) values (Input_Project_Name,Input_Student_Id,Input_Start_Date,Input_End_Date);
insert into marks (student_id,subject_id,marks) values(Input_Student_Id,5,'90');
IF `should_rollback` THEN
	SET tran_status="error occured";
    ROLLBACK;
ELSE
	SET tran_status="Success";
    COMMIT;
END IF;
else
SET tran_status="student not available";
END IF;
END