CREATE DEFINER=`root`@`localhost` PROCEDURE `bank_tx`(in inputFromUserId int,in  User1 int,in User2 int,in User3 int,in Amount int,out tranStatus varchar(50),out tranStatus_Rev varchar(50) )
BEGIN
declare balance double;
DECLARE `should_rollback` boolean DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `should_rollback` = TRUE;
    SET autocommit=0;
    START TRANSACTION;
   savepoint sp1; 
    IF EXISTS (SELECT user_id FROM bank_user where user_id=inputFromUserId) THEN
      IF EXISTS (SELECT available_balance as balance FROM bank_user where user_id=inputFromUserId and available_balance>=Amount) THEN
		IF EXISTS (SELECT user_id FROM bank_user where user_id=User1) THEN
			insert into  transaction_details(from_user_id,to_user_id,amount) values (inputFromUserId,User1,Amount/3);
                            update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User1;
		else 
				SET tranStatus="User-1 not available! Transaction rolled back";
				set  should_rollback=true;
		end if;
		IF EXISTS (SELECT user_id FROM bank_user where user_id=User3) THEN
				insert into  transaction_details(from_user_id,to_user_id,amount) values (inputFromUserId,User3,Amount/3);
                update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User3;
			else 
				SET tranStatus="User-3 not available! Transaction rolled back";
				set  should_rollback=true;
			end if;
			IF EXISTS (SELECT user_id FROM  bank_user where user_id=User2) THEN
				insert into  transaction_details(from_user_id,to_user_id,amount) values (inputFromUserId,User2,Amount/3);
                  update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=User2;
			else 
				SET tranStatus="User-2 not available! Transaction rolled back";
				set  should_rollback=true;
			end if;
		update bank_user SET available_balance=available_balance-Amount  WHERE user_id=inputFromUserId;

				IF `should_rollback` THEN
					ROLLBACK to sp1;
                    insert into transaction_failure(from_user_id,message,amount) values (inputFromUserId,tranStatus,Amount);
				ELSE
					SET tranStatus="Successfully transferred";
                    
                    SAVEPOINT sp2;
						insert into  transaction_details(from_user_id,to_user_id,amount) values (User1,inputFromUserId,Amount/3);
						update bank_user SET available_balance=available_balance-Amount/3  WHERE user_id=User1;
                        update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=inputFromUserId;

                   insert into  transaction_details(from_user_id,to_user_id,amount) values (User2,inputFromUserId,Amount/3);
						update bank_user SET available_balance=available_balance-Amount/3  WHERE user_id=User2;
                        update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=inputFromUserId;
                    
                    insert into  transaction_details(from_user_id,to_user_id,amount) values (inputFromUserId,Amount/3);
						update bank_user SET available_balance=available_balance-Amount/3  WHERE user_id=User3;
                        update bank_user SET available_balance=available_balance+Amount/3  WHERE user_id=inputFromUserId;
                    IF `should_rollback` THEN
                    SET tranStatus_Rev="ERROR OCCURED!";
					ROLLBACK to sp2;
				ELSE
					SET tranStatus_Rev="Successfully transferred";
					COMMIT;
                    END IF;
			
					END IF;
		else
		SET tranStatus="insufficient funds";
		insert into transaction_failure(from_user_id,message,amount) values (inputFromUserId,tranStatus,Amount);
		END IF;
                    
	else
		SET tranStatus="you are not a valid user";
		insert into transaction_failure(from_user_id,message,amount) values (inputFromUserId,tranStatus,Amount);
		END IF;
END