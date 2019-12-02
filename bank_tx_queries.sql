create table bank_user(id int primary key AUTO_INCREMENT,user_name varchar(50) not null,email varchar(50) not null, available_balance int not null default 0);
create table transaction_details(id int primary key AUTO_INCREMENT,from_user_id int not null,to_user_id int not null,tx_date timestamp default now(),amount int not null);
create table transaction_failure(id int primary key AUTO_INCREMENT,from_user_id int not null,tx_date timestamp default now(),message varchar(50) not null,amount int not null);
select * from bank_user;
select * from transaction_details;
select * from transaction_failure;
truncate table bank_user;
truncate table transaction_details;
truncate table transaction_failure;

drop table bank_user;
drop table transaction_details;
drop table transaction_failure;

		update bank_user SET available_balance=available_balance-10  WHERE user_id=1;



insert into transaction_failure(from_user_id,message,amount) values (1,"error",1000);