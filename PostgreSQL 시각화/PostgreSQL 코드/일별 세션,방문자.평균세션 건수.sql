-- 세션 로그데이터
select browser , count(*) from ga.ga_sess group by 1;

select user_id , count(*) from ga.ga_sess group by 1 having count(*)>1;

select * from ga.ga_users;

select sess_id,count(*) from ga.orders group by 1 having count(*)>1;

select * from ga.ga_sess_hits;

select * from ga.ga_sess_hits where sess_id='S0000505' order by hit_seq;


/*********************************
일별 사용자 세션 건수
*********************************/

with temp1 as(
select to_char(date_trunc('day',visit_stime),'yyyy-mm-dd') d_day
,count(distinct sess_id) daily_sess_cnt
,count(sess_id) daily_sess_cnt_a
,count(distinct user_id) daily_user_cnt
from ga.ga_sess
group by 1
)
-- 1.0*daily_sess_cnt/daily_user_cnt avg_cnt 방식아니면 daily_sess_cnt/daily_user_cnt avg_cnt::float로 자료형 변환해야 소수점까지 출력
select * , 1.0*daily_sess_cnt/daily_user_cnt avg_cnt
from temp1;