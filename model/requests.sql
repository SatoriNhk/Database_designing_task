select * from get_balance; 

select * from get_balance_finished;

select * from get_balance
left join get_balance_finished 
on get_balance.object_id = get_balance_finished .object_id;

select * from top_foreman;

select * from get_balance_full;

select * from get_balance_full_time_period;
