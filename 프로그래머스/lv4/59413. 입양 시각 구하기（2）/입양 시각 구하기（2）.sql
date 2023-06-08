-- 코드를 입력하세요
with RECURSIVE time (hour) as (
select 0
union all
select hour+1
from time
where hour<23)
select A.hour,count(B.hour) from time A left join (select *,hour(datetime) hour from animal_outs) B
on A.hour=B.hour
group by 1