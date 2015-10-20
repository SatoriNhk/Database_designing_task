create or replace view income 
as select object_id, sum(amount) summa1 
from payment 
where payment_type_id = 3
group by object_id;

create or replace view outcome as select object_id, sum(amount) summa2 
from payment 
where payment_type_id != 3
group by object_id;
 
create or replace view get_balance as 
select o.object_id, p1.summa1 - p2.summa2 as balance, p1.summa1 + p2.summa2 as cash_turnover, (p1.summa1 - p2.summa2) /  p2.summa2 * 100 as margin
from object o 
join income p1 
	on o.object_id = p1.object_id
join outcome p2 
	on o.object_id = p2.object_id;

create or replace view income_finished 
as select object_id, sum(amount) summa1 
from payment 
where payment_type_id = 3 and object_id in 
	(select object_id 
    from object 
    where finished = true)
group by object_id;

create or replace view outcome_finished
as select object_id, sum(amount) summa2 
from payment 
where payment_type_id != 3 and object_id in 
	(select object_id 
    from object 
    where finished = true) 
group by object_id;
 
create or replace view get_balance_finished
as select o.object_id, inc.summa1 - outc.summa2 as balance 
from object o 
join income_finished inc 
	on o.object_id = inc.object_id
join outcome_finished outc
	on o.object_id = outc.object_id;
    


select * from get_balance
left join get_balance_finished 
on get_balance.object_id = get_balance_finished .object_id;

create or replace view top_foreman as
select foreman.foreman_id as ForemanID, foreman.name as Surname, sum(gbf.balance) as Profit
from foreman
join foreman_object
	on foreman.foreman_id = foreman_object.foreman_id
join object
	on foreman_object.object_id = object.object_id
join get_balance_finished gbf
	on object.object_id = gbf.object_id
group by foreman.foreman_id
order by Profit DESC;

create or replace view income_full
as select sum(amount) summa 
from payment 
where payment_type_id = 3;

create or replace view outcome_full as 
select sum(amount) summa
from payment 
where payment_type_id != 3;

create or replace view get_balance_full as 
select income_full.summa - outcome_full.summa as balance, 
	income_full.summa + outcome_full.summa as cash_turnover, 
	(income_full.summa - outcome_full.summa) /  outcome_full.summa * 100 as margin_actual,
	generate.generate_type_id, 
	generate.margin, generate.date_start,
	generate.date_end,
	generate.amount
from income_full, outcome_full, generate;

select * from get_balance_full;

create or replace view income_full_time_period
as select sum(amount) summa 
from payment 
where payment_type_id = 3 AND payment.date between 
	(select date_start from generate ORDER BY generate_id DESC limit 1) and 
	(select date_end from generate ORDER BY generate_id DESC limit 1);

create or replace view outcome_full_time_period 
as select sum(amount) summa
from payment 
where payment_type_id != 3 AND payment.date between 
	(select date_start from generate ORDER BY generate_id DESC limit 1) and 
	(select date_end from generate ORDER BY generate_id DESC limit 1);
    
create or replace view get_balance_full_time_period  as 
select income_full_time_period.summa - outcome_full_time_period.summa as balance, 
	income_full_time_period.summa + outcome_full_time_period.summa as cash_turnover, 
	(income_full_time_period.summa - outcome_full_time_period.summa) /  outcome_full_time_period.summa * 100 as margin_actual,
	generate.generate_type_id, 
	generate.margin, generate.date_start,
	generate.date_end,
	generate.amount
from income_full_time_period, outcome_full_time_period, generate;

select * from get_balance_full_time_period