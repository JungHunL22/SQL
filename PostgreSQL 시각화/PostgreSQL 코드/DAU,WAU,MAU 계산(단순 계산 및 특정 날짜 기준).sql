/***************************************
 DAU,WAU,MAU 계산
 **************************************/

-- 이전데이터의 첫날 기준으로 DAU,WAU,MAU 계산
select date_trunc('day',visit_stime)::date d_day,count(distinct user_id) user_cnt  from ga.ga_sess
group by date_trunc('day',visit_stime)::date;

select date_trunc('week',visit_stime)::date w_day,count(distinct user_id) user_cnt  from ga.ga_sess
group by date_trunc('week',visit_stime)::date;

select date_trunc('month',visit_stime)::date m_day,count(distinct user_id) user_cnt  from ga.ga_sess
group by date_trunc('month',visit_stime)::date;

-- 최근 날짜를 기준으로 DAU,WAU,MAU 계산
SELECT to_date('20161101','yyyymmdd'),COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (to_date('20161101','yyyymmdd')-interval '1 days') and 
VISIT_STIME<to_date('20161101','yyyymmdd');

SELECT to_date('20161101','yyyymmdd'),COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (to_date('20161101','yyyymmdd')-interval '7 days') and 
VISIT_STIME<to_date('20161101','yyyymmdd');

SELECT to_date('20161101','yyyymmdd'),COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (to_date('20161101','yyyymmdd')-interval '30 days') and 
VISIT_STIME<to_date('20161101','yyyymmdd');

-- variation으로 날짜지정해서 출력 -> :current 입력 후 실행하면 변수를 지정 할 수 있음.
SELECT :CURRENT,COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (:CURRENT-interval '1 days') and 
VISIT_STIME<:CURRENT;


SELECT :CURRENT,COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (:CURRENT-interval '7 days') and 
VISIT_STIME<:CURRENT;

SELECT :CURRENT,COUNT(distinct USER_ID) from GA.ga_sess
where VISIT_STIME >= (:CURRENT-interval '30 days') and 
VISIT_STIME<:CURRENT;
-- 지정 변수만 바꿔주면 하루단위로 insert를 계속할 수 있음 -> 업데이트하기 간편함
-- 연산속도가 느리다는 단점이 있음
create table if not exists daily
(d_day date,
DAU integer,
WAU integer,
MAU integer);

select * from DAILY;

insert into DAILY
select 
:current,
(select COUNT(distinct user_id) DAU
from ga.ga_sess 
where VISIT_STIME>=(:current-interval '1 DAYS') and VISIT_STIME<:current),
(select COUNT(distinct user_id) WAU
from ga.ga_sess 
where VISIT_STIME>=(:current-interval '7 DAYS') and VISIT_STIME<:current),
(select COUNT(distinct user_id) MAU
from ga.ga_sess 
where VISIT_STIME>=(:current-interval '30 DAYS') and VISIT_STIME<:current);

select * from DAILY;

