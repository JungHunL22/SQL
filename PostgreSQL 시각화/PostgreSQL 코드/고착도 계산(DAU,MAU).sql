with temp1 as(
select :current_date as curr_date,count(distinct user_id) DAU
from ga.ga_sess 
where visit_stime>=( :current_date - interval '1 days') and visit_stime<:current_date),
temp2 as(
select :current_date as curr_date,count(distinct user_id) MAU
from ga.ga_sess where visit_stime>=(:current_date-interval '30 days') and visit_stime<:current_date)
select a.curr_date,a.dau,b.mau,round(100.0*a.dau/b.mau,2) as stickness
from temp1 A join temp2 B on A.curr_date=B.curr_date;

select *,round(100.0*dau/mau,2) stickness,round(avg(100.0*dau/mau) over(),2) as avg_stickness
from daily 
where curr_date between to_date('2016-10-25','yyyy-mm-dd') and to_date('2016-10-31','yyyy-mm-dd')