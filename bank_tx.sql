CREATE DEFINER=`root`@`localhost` PROCEDURE `bank_tx`(
in Input_From_User_Id int,
  in  User1 int
     ,in User2 int
     ,in User3 int
      ,in Amount int
    ,out tran_status varchar(50) 
)
BEGIN

DECLARE `should_rollback` boolean DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `should_rollback` = TRUE;
    SET autocommit=0;
    START TRANSACTION;

    IF EXISTS (SELECT user_id FROM bank_user where user_id=Input_From_User_Id) THEN
      IF EXISTS (SELECT available_balance as balance FROM bank_user where user_id=Input_From_User_Id and available_balance>=Amount) THEN
		IF EXISTS (SELECT user_id FROM bank_user where user_id=User1) THEN
			insert into  transaction_details(from_user_id,to_user_id,amount) values (Input_From_User_Id,User1,Amount/3);
                            update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User1;
		else 
				SET tran_status="User-1 not available! Transaction rolled back";
				set  should_rollback=true;
		end if;
            
		IF EXISTS (SELECT user_id FROM bank_user where user_id=User3) THEN
				insert into  transaction_details(from_user_id,to_user_id,amount) values (Input_From_User_Id,User3,Amount/3);
                update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User3;
			else 
				SET tran_status="User-3 not available! Transaction rolled back";
				set  should_rollback=true;
			end if;
			IF EXISTS (SELECT user_id FROM  bank_user where user_id=User2) THEN
				insert into  transaction_details(from_user_id,to_user_id,amount) values (Input_From_User_Id,User2,Amount/3);
                  update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User2;
			else 
				SET tran_status="User-2 not available! Transaction rolled back";
				set  should_rollback=true;
			end if;
		update bank_user SET available_balance=available_balance-Amount  WHERE user_id=Input_From_User_Id;

				IF `should_rollback` THEN
					ROLLBACK;
				ELSE
					SET tran_status="Successfully transferred";
					COMMIT;
					END IF;
		else
		SET tran_status="insufficient funds";
		END IF;
                    
	else
		SET tran_status="you are not a valid user";
		END IF;
END