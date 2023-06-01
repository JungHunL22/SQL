-- generate_series로 최근날짜를 생성
select generate_series('2016-08-02'::date,'2016-11-01'::date, '1 day'::interval)::date as current_date 

--8/2일 기준 하루전의 DAU~11/01 기준 하루전의 DAU 전부 출력
-- 루프문보다 연산속도가 빠름
with
temp1 as (
select generate_series('2016-08-02'::date,'2016-11-01'::date, '1 day'::interval)::date as current_date)
select b.current_date,count(distinct user_id) DAU
from ga.ga_sess A cross join temp1 B
where visit_stime>=(B.current_date-interval '1 days') and visit_stime<B.current_date
group by 1

create table daily_dau as
with
temp1 as (
select generate_series('2016-08-02'::date,'2016-11-01'::date, '1 day'::interval)::date as current_date)
select b.current_date,count(distinct user_id) DAU
from ga.ga_sess A cross join temp1 B
where visit_stime>=(B.current_date-interval '1 days') and visit_stime<B.current_date
group by 1;

select * from daily_dau;

create table daily_wau as
with
temp1 as (
select generate_series('2016-08-02'::date,'2016-11-01'::date, '1 day'::interval)::date as current_date)
select b.current_date,count(distinct user_id) WAU
from ga.ga_sess A cross join temp1 B
where visit_stime>=(B.current_date-interval '7 days') and visit_stime<B.current_date
group by 1;
--select * from daily_wau;
drop table daily_wau;
select * from daily_wau;

create table daily_mau as
with
temp1 as (
select generate_series('2016-08-02'::date,'2016-11-01'::date, '1 day'::interval)::date as current_date)
select b.current_date,count(distinct user_id) MAU
from ga.ga_sess A cross join temp1 B
where visit_stime>=(B.current_date-interval '30 days') and visit_stime<B.current_date
group by 1;
select * from daily_mau;
--drop table daily_mau;
drop table daily;


create table if not exists daily
as
select a.current_date,a.DAU,B.WAU,C.MAU
from daily_dau A join daily_wau B on A.current_date=B.current_date
join daily_mau C on A.current_date=C.current_date;

select * from daily;