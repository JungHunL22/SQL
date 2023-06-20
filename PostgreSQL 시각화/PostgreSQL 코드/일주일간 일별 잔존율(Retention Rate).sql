with temp1 as(
select date_trunc('day',create_time)::date d_day,count(*) cnt
from ga.ga_users
group by 1
)
select *,sum(cnt) over(order by d_day rows between unbounded preceding and current row)
from temp1;

with temp1 as(
select * from ga.ga_users a
join ga.ga_sess b on a.user_id=b.user_id
)
select *,date_trunc('day',create_time)::date crt_t,date_trunc('day',visit_stime)::date log_t  from temp1;

/*******************************
 사용자 생성 날짜 별 일주일간 잔존율(Retention Rate) 구하기
 ********************************/
-- 2016/11/01 기준으로 8일 전 범위까지 -> 2016/10/24~2016/10/30(ga_users에서 마지막 생성일자는 10월30일임)
select max(create_time) from ga.ga_users;
select max(visit_stime) from ga.ga_sess;

with temp1 as(
select a.user_id,date_trunc('day',create_time)::date user_create_date,
date_trunc('day',visit_stime)::date user_create_date,count(*) cnt
from ga.ga_users a left join ga.ga_sess b on a.user_id=b.user_id 
where create_time>=(:current_date-interval '8 days') and (create_time<:current_date)
group by 1,2,3
)
select * from temp1;

with temp1 as(
select a.user_id,date_trunc('day',create_time)::date user_create_date,
date_trunc('day',visit_stime)::date sess_visit_date,count(*) cnt
from ga.ga_users a left join ga.ga_sess b on a.user_id=b.user_id 
where create_time>=(:current_date-interval '8 days') and (create_time<:current_date)
group by 1,2,3
),
temp2 as(
select user_create_date,count(*)
from temp1
group by 1 order by 1)
select * from temp2;

-- 잔존율 접속자 수로 계산
with temp1 as(
select a.user_id,date_trunc('day',create_time)::date user_create_date,
date_trunc('day',visit_stime)::date sess_visit_date,count(*) cnt
from ga.ga_users a left join ga.ga_sess b on a.user_id=b.user_id 
where create_time>=(:current_date-interval '8 days') and (create_time<:current_date)
group by 1,2,3
),
temp2 as(
select user_create_date,count(*) create_cnt,
sum(case when sess_visit_date=user_create_date+interval '1 days' then 1 else 0 end) D1_cnt,
sum(case when sess_visit_date=user_create_date+interval '2 days' then 1 else 0 end) D2_cnt,
sum(case when sess_visit_date=user_create_date+interval '3 days' then 1 else 0 end) D3_cnt,
sum(case when sess_visit_date=user_create_date+interval '4 days' then 1 else 0 end) D4_cnt,
sum(case when sess_visit_date=user_create_date+interval '5 days' then 1 else 0 end) D5_cnt,
sum(case when sess_visit_date=user_create_date+interval '6 days' then 1 else 0 end) D6_cnt,
sum(case when sess_visit_date=user_create_date+interval '7 days' then 1 else 0 end) D7_cnt
from temp1
group by 1 order by 1)
select * from temp2;
)

-- 잔존율 비율로 계산
with temp1 as(
select a.user_id,date_trunc('day',create_time)::date user_create_date,
date_trunc('day',visit_stime)::date sess_visit_date,count(*) cnt
from ga.ga_users a left join ga.ga_sess b on a.user_id=b.user_id 
where create_time>=(:current_date-interval '8 days') and (create_time<:current_date)
group by 1,2,3
),
temp2 as(
select user_create_date,count(*) create_cnt,
sum(case when sess_visit_date=user_create_date+interval '1 days' then 1 else 0 end) D1_cnt,
sum(case when sess_visit_date=user_create_date+interval '2 days' then 1 else 0 end) D2_cnt,
sum(case when sess_visit_date=user_create_date+interval '3 days' then 1 else 0 end) D3_cnt,
sum(case when sess_visit_date=user_create_date+interval '4 days' then 1 else 0 end) D4_cnt,
sum(case when sess_visit_date=user_create_date+interval '5 days' then 1 else 0 end) D5_cnt,
sum(case when sess_visit_date=user_create_date+interval '6 days' then 1 else 0 end) D6_cnt,
sum(case when sess_visit_date=user_create_date+interval '7 days' then 1 else 0 end) D7_cnt
from temp1
group by 1 order by 1)
select user_create_date,create_cnt,
round(100.0*d1_cnt/create_cnt,2) d1_ratio,
round(100.0*d2_cnt/create_cnt,2) d2_ratio,
round(100.0*d3_cnt/create_cnt,2) d3_ratio,
round(100.0*d4_cnt/create_cnt,2) d4_ratio,
round(100.0*d5_cnt/create_cnt,2) d5_ratio,
round(100.0*d6_cnt/create_cnt,2) d6_ratio,
round(100.0*d7_cnt/create_cnt,2) d7_ratio
from temp2;
)