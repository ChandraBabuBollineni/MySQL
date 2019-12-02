create table bank_user(user_id int primary key AUTO_INCREMENT,user_name varchar(50) not null,email varchar(50) not null, available_balance int not null default 0);
create table transaction_details(tx_id int primary key AUTO_INCREMENT,from_user_id int not null,to_user_id int not null,tx_date timestamp default now(),amount int not null);

select * from bank_user;
select * from transaction_details;

truncate table bank_user;
truncate table transaction_details;

drop table bank_user;
drop table transaction_details;