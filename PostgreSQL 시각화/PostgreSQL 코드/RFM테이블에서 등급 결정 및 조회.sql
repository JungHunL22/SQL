/*************************************
 고객별 RFM 구하기 
 ************************************/

-- Recency,Frequency,Monetary

with temp1 as(
select a.user_id,max(date_trunc('day',order_time)::date) max_date,
to_date('20161101','yyyymmdd')-max(date_trunc('day',order_time)::date) Recency,
-- order_id는 유저별로 여러건이 존재하므로
count(distinct A.order_id) Frequency,
sum(B.prod_revenue) Monetary
from ga.orders A join ga.order_items B on A.order_id=B.order_id
group by A.user_id),
-- Recency는 오름차순 정렬해야 함. 가장 높은 등급이 1 낮은 등급이 5이므로 recency가 낮을수록 등급이 높아야 함.
temp2 as(select *,
ntile(5) over(order by Recency asc rows between unbounded preceding and unbounded following) as R_rnk,
ntile(5) over(order by Frequency desc rows between unbounded preceding and unbounded following) as F_rnk,
ntile(5) over(order by Recency desc rows between unbounded preceding and unbounded following) as M_rnk
from temp1)
select Recency,count(*)
from temp2
group by 1 order by 1;

-- 해당방법으로 등급을 구하면 한쪽으로 치우친 분포를 가지는 데이터의 경우에 제대로된 등급이 매겨지지 않음.
with temp1 as(
select a.user_id,max(date_trunc('day',order_time)::date) max_date,
to_date('20161101','yyyymmdd')-max(date_trunc('day',order_time)::date) Recency,
-- order_id는 유저별로 여러건이 존재하므로
count(distinct A.order_id) Frequency,
sum(B.prod_revenue) Monetary
from ga.orders A join ga.order_items B on A.order_id=B.order_id
group by A.user_id),
-- Recency는 오름차순 정렬해야 함. 가장 높은 등급이 1 낮은 등급이 5이므로 recency가 낮을수록 등급이 높아야 함.
temp2 as(select *,
ntile(5) over(order by Recency asc rows between unbounded preceding and unbounded following) as R_rnk,
ntile(5) over(order by Frequency desc rows between unbounded preceding and unbounded following) as F_rnk,
ntile(5) over(order by Recency desc rows between unbounded preceding and unbounded following) as M_rnk
from temp1)
select Frequency,count(*)
from temp2
group by 1 order by 1;

with temp1 as(
select a.user_id,max(date_trunc('day',order_time)::date) max_date,
to_date('20161101','yyyymmdd')-max(date_trunc('day',order_time)::date) Recency,
-- order_id는 유저별로 여러건이 존재하므로
count(distinct A.order_id) Frequency,
sum(B.prod_revenue) Monetary
from ga.orders A join ga.order_items B on A.order_id=B.order_id
group by A.user_id),
-- Recency는 오름차순 정렬해야 함. 가장 높은 등급이 1 낮은 등급이 5이므로 recency가 낮을수록 등급이 높아야 함.
temp2 as(select *,
ntile(5) over(order by Recency asc rows between unbounded preceding and unbounded following) as R_rnk,
ntile(5) over(order by Frequency desc rows between unbounded preceding and unbounded following) as F_rnk,
ntile(5) over(order by Recency desc rows between unbounded preceding and unbounded following) as M_rnk
from temp1)
select Monetary,count(*)
from temp2
group by 1 order by 1;


-- 구간을 지정해서 등급을 매기는 방법
-- 필드별 시작조건과 마지막조건을 임의로 지정
with temp1 as(
select 'A' as grade,1 as fr_rec,14 as to_rec,5 as fr_freq,9999 as to_freq,100.0 as fr_money,999999.0 as to_money
union all
select 'B', 15,50,3,4,50.0,99.999
union all
select 'C', 51,99999,1,2,0.0,49.999
)
select * from temp1;

with temp1 as(
select a.user_id,max(date_trunc('day',order_time)::date) max_date,
to_date('20161101','yyyymmdd')-max(date_trunc('day',order_time)::date) Recency,
-- order_id는 유저별로 여러건이 존재하므로
count(distinct A.order_id) Frequency,
sum(B.prod_revenue) Monetary
from ga.orders A join ga.order_items B on A.order_id=B.order_id
group by A.user_id),
-- Recency는 오름차순 정렬해야 함. 가장 높은 등급이 1 낮은 등급이 5이므로 recency가 낮을수록 등급이 높아야 함.
temp2 as(select 'A' as grade,1 as fr_rec,14 as to_rec,5 as fr_freq,9999 as to_freq,300.0 as fr_money,999999.0 as to_money
union all
select 'B', 15,50,3,4,50.0,99.999
union all
select 'C', 51,99999,1,2,0.0,49.999
),
temp3 as(
select a.*,b.grade R_grade,c.grade F_grade,d.grade M_grade
from temp1 A
left join temp2 B on A.recency between B.fr_rec and B.to_rec
left join temp2 C on A.frequency between C.fr_freq and C.to_freq
left join temp2 D on A.monetary between D.fr_money and D.to_money
),
temp4 as(
-- 최종등급을 매기기 위한 임의 등급 지정(평가자가 지정)
select *,
case when r_grade='A' and f_grade in ('A','B') and m_grade='A' then 'A'
when r_grade='B' and f_grade='A' and m_grade='A' then 'A'
when r_grade='B' and f_grade in ('A','B','C') and m_grade='B' then 'B'
when r_grade='C' and f_grade in ('A','B') and m_grade='B' then 'B'
when r_grade='C' and f_grade='C' and m_grade='A' then 'B'
when r_grade='C' and f_grade='C' and m_grade in ('B','C') then 'C'
when r_grade in ('B','C') and m_grade='C' then 'C'
else 'C' end as total_grade
from temp3)
select total_grade,'rfm_grade_'||r_grade||f_grade||m_grade as rfm_grade,
count(*) grade_cnt
from temp4
group by 1,2 order by 1