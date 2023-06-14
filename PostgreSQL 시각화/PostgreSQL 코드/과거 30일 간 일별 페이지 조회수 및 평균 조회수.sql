-- 과거 30일 간 일별 페이지 조회수 및 평균 조회수 
-- 방법 1
select date_trunc('day',visit_stime)::date,count(*) page_cnt, 
avg(count(*)) over()
from ga.ga_sess A
join ga.ga_sess_hits B on A.sess_id=B.sess_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and hit_type='PAGE'
group by 1;

-- 방법 2
with temp1 as(
select date_trunc('day',visit_stime)::date,count(*) page_cnt
from ga.ga_sess A
join ga.ga_sess_hits B on A.sess_id=B.sess_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and hit_type='PAGE'
group by 1)
select *,avg(page_cnt) over()
from temp1;


-- 방법 3(선호)
with temp1 as (select date_trunc('day',visit_stime)::date,count(*) page_cnt from ga.ga_sess A
join ga.ga_sess_hits B on A.sess_id=B.sess_id
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and hit_type='PAGE'
group by 1),
temp2 as(
select avg(page_cnt) page_avg from temp1
)
select a.*,b.* from temp1 a cross join temp2 b;

