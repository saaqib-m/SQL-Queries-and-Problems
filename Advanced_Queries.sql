-- create database firstbase
-- use firstbase 

-- drop table account_balance
create table account_balance(
    account_no          varchar(20),
    transaction_date    date,
    debit_credit        varchar(10),
    transaction_amount  decimal
);

insert into account_balance values ('acc_1', STR_STR_TO_DATE('2022-01-20', '%Y-%m-%d'), 'credit', 100);
insert into account_balance values ('acc_1', STR_STR_TO_DATE('2022-01-21', '%Y-%m-%d'), 'credit', 500);
insert into account_balance values ('acc_1', STR_STR_TO_DATE('2022-01-22', '%Y-%m-%d'), 'credit', 300);
insert into account_balance values ('acc_1', STR_STR_TO_DATE('2022-01-23', '%Y-%m-%d'), 'credit', 200);
insert into account_balance values ('acc_2', STR_STR_TO_DATE('2022-01-20', '%Y-%m-%d'), 'credit', 500);
insert into account_balance values ('acc_2', STR_STR_TO_DATE('2022-01-21', '%Y-%m-%d'), 'credit', 1100);
insert into account_balance values ('acc_2', STR_STR_TO_DATE('2022-01-22', '%Y-%m-%d'), 'debit', 1000);
insert into account_balance values ('acc_3', STR_STR_TO_DATE('2022-01-20', '%Y-%m-%d'), 'credit', 1000);
insert into account_balance values ('acc_4', STR_STR_TO_DATE('2022-01-20', '%Y-%m-%d'), 'credit', 1500);
insert into account_balance values ('acc_4', STR_STR_TO_DATE('2022-01-21', '%Y-%m-%d'), 'debit', 500);
insert into account_balance values ('acc_5', STR_STR_TO_DATE('2022-01-20', '%Y-%m-%d'), 'credit', 900);

SELECT * FROM account_balance;

WITH cte as (
	SELECT account_no, transaction_date, 
    case when debit_credit = 'debit' then transaction_amount * -1 ELSE transaction_amount END AS trns
    FROM account_balance
) ,
final_data as(
select *,
sum(trns) over(partition by account_no order by transaction_date
					range between unbounded preceding and unbounded following) as final_total,
sum(trns) over(partition by account_no order by transaction_date) AS currrent_total,
case when sum(trns) over(partition by account_no order by transaction_date) >= 1000 THEN 1 ELSE 0 END AS flag
FROM CTE)
SELECT * FROM final_data;
-- select account_no, min(transaction_date ) as transaction_date 
-- FROM final_data
-- WHERE final_total >= 1000
-- AND FLAG = 1
-- GROUP BY account_no

-- New table
create table files
(
id              int primary key,
date_modified   date,
file_name       varchar(50)
);
insert into files values (1	,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'thresholds.svg');
insert into files values (2	,   STR_TO_DATE('2021-06-01','%Y-%m-%d'), 'redrag.py');
insert into files values (3	,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'counter.pdf');
insert into files values (4	,   STR_TO_DATE('2021-06-06','%Y-%m-%d'), 'reinfusion.py');
insert into files values (5	,   STR_TO_DATE('2021-06-06','%Y-%m-%d'), 'tonoplast.docx');
insert into files values (6	,   STR_TO_DATE('2021-06-01','%Y-%m-%d'), 'uranian.pptx');
insert into files values (7	,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'discuss.pdf');
insert into files values (8	,   STR_TO_DATE('2021-06-06','%Y-%m-%d'), 'nontheologically.pdf');
insert into files values (9	,   STR_TO_DATE('2021-06-01','%Y-%m-%d'), 'skiagrams.py');
insert into files values (10,   STR_TO_DATE('2021-06-04','%Y-%m-%d'), 'flavors.py');
insert into files values (11,   STR_TO_DATE('2021-06-05','%Y-%m-%d'), 'nonv.pptx');
insert into files values (12,   STR_TO_DATE('2021-06-01','%Y-%m-%d'), 'under.pptx');
insert into files values (13,   STR_TO_DATE('2021-06-02','%Y-%m-%d'), 'demit.csv');
insert into files values (14,   STR_TO_DATE('2021-06-02','%Y-%m-%d'), 'trailings.pptx');
insert into files values (15,   STR_TO_DATE('2021-06-04','%Y-%m-%d'), 'asst.py');
insert into files values (16,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'pseudo.pdf');
insert into files values (17,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'unguarded.jpeg');
insert into files values (18,   STR_TO_DATE('2021-06-06','%Y-%m-%d'), 'suzy.docx');
insert into files values (19,   STR_TO_DATE('2021-06-06','%Y-%m-%d'), 'anitsplentic.py');
insert into files values (20,   STR_TO_DATE('2021-06-03','%Y-%m-%d'), 'tallies.py');

with cte as
    (select date_modified
   , substr(file_name,instr(file_name, '.')+1)  as file_ext
    , count(1) as cnt
    from files
	group by date_modified
    , substr(file_name,instr(file_name, '.')+1))
select date_modified, file_ext, concat(file_ext, ',') as extension, max(cnt) as count
from cte c1
where cnt = (select max(cnt) from cte c2 where c1.date_modified=c2.date_modified )
group by date_modified
order by 1;
