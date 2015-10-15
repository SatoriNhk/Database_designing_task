create or replace view finished_objects as select object_id from object where finished = true;
create or replace view income as select object_id, sum(amount) Summa1 from payment where payment_type_id = 3 and object_id in (select object_id from object where finished = true) group by object_id;
create or replace view outcome as select object_id, sum(amount) Summa2 from payment where payment_type_id != 3 and object_id in (select object_id from object where finished = true) group by object_id;
 
create or replace view get_balance as select o.object_id, p1.Summa1 - p2.Summa2 as balance from object o left join 
	income p1 on o.object_id = p1.object_id
 left join outcome p2 on o.object_id = p2.object_id;
 select * from get_balance;
 
 create or replace view top_foreman as select foreman_id from foreman 
 