create or replace view income 
as select object_id, sum(amount) Summa1 
from payment 
where payment_type_id = 3
group by object_id;

create or replace view outcome as select object_id, sum(amount) Summa2 
from payment 
where payment_type_id != 3
group by object_id;
 
create or replace view get_balance as 
select o.object_id, p1.Summa1 - p2.Summa2 as balance 
from object o 
join income p1 
	on o.object_id = p1.object_id
join outcome p2 
	on o.object_id = p2.object_id;



create or replace view income_finished 
as select object_id, sum(amount) Summa1 
from payment 
where payment_type_id = 3 and object_id in 
	(select object_id 
    from object 
    where finished = true)
group by object_id;

create or replace view outcome_finished
as select object_id, sum(amount) Summa2 
from payment 
where payment_type_id != 3 and object_id in 
	(select object_id 
    from object 
    where finished = true) 
group by object_id;
 
create or replace view get_balance_finished
as select o.object_id, inc.Summa1 - outc.Summa2 as balance 
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

