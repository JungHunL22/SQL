/************************************
주별 잔존율(Retention rate) 및 주별 특정 채널 잔존율
*************************************/
-- 일별 잔존율과 이론은 같다. date_trunc의 주기를 week로 바꾸면 주별 잔존율이 계산됨 
with temp_01 as (
	select a.user_id, date_trunc('week', a.create_time)::date as user_create_date,  date_trunc('week', b.visit_stime)::date as sess_visit_date
		, count(*) cnt
	from ga.ga_users a
		left join ga.ga_sess b
			on a.user_id = b.user_id
	--where  create_time >= (:current_date - interval '7 weeks') and create_time < :current_date
	where create_time >= to_date('20160912', 'yyyymmdd') and create_time < to_date('20161101', 'yyyymmdd')
	group by a.user_id, date_trunc('week', a.create_time)::date, date_trunc('week', b.visit_stime)::date
), 
temp_02 as (
select user_create_date, count(*) as create_cnt
     -- w1 에서 w7까지 주단위 접속 사용자 건수 구하기.
	, sum(case when sess_visit_date = user_create_date + interval '1 week' then 1 else null end ) as w1_cnt
	, sum(case when sess_visit_date = user_create_date + interval '2 week' then 1 else null end) as w2_cnt
	, sum(case when sess_visit_date = user_create_date + interval '3 week' then 1 else null end) as w3_cnt
	, sum(case when sess_visit_date = user_create_date + interval '4 week' then 1 else null end) as w4_cnt
	, sum(case when sess_visit_date = user_create_date + interval '5 week' then 1 else null end) as w5_cnt
	, sum(case when sess_visit_date = user_create_date + interval '6 week' then 1 else null end) as w6_cnt
	, sum(case when sess_visit_date = user_create_date + interval '7 week' then 1 else null end) as w7_cnt
from temp_01 
group by user_create_date
)
select user_create_date, create_cnt
    -- w1 에서 w7 주별 잔존율 구하기.
	, round(100.0 * w1_cnt/create_cnt, 2) as w1_ratio
	, round(100.0 * w2_cnt/create_cnt, 2) as w2_ratio
	, round(100.0 * w3_cnt/create_cnt, 2) as w3_ratio
	, round(100.0 * w4_cnt/create_cnt, 2) as w4_ratio
	, round(100.0 * w5_cnt/create_cnt, 2) as w5_ratio
	, round(100.0 * w6_cnt/create_cnt, 2) as w6_ratio
	, round(100.0 * w7_cnt/create_cnt, 2) as w7_ratio
from temp_02 order by 1;

-- 주 단위 특정 채널 잔존율(Retention rate) (Referral채널에서 유입된 사용자를 기준으로 Retention을 계산)
with temp_01 as (
	select a.user_id, date_trunc('week', a.create_time)::date as user_create_date,  date_trunc('week', b.visit_stime)::date as sess_visit_date
		, count(*) cnt
	from ga.ga_users a
		left join ga.ga_sess b
			on a.user_id = b.user_id
	--where  create_time >= (:current_date - interval '7 weeks') and create_time < :current_date
	where create_time >= to_date('20160912', 'yyyymmdd') and create_time < to_date('20161101', 'yyyymmdd')
	and channel_grouping='Referral' -- Social Organic Search, Direct, Referral
	group by a.user_id, date_trunc('week', a.create_time)::date, date_trunc('week', b.visit_stime)::date
), 
temp_02 as (
select user_create_date, count(*) as create_cnt
	-- w1 에서 w7까지 주단위 접속 사용자 건수 구하기.
	, sum(case when sess_visit_date = user_create_date + interval '1 week' then 1 else null end ) as w1_cnt
	, sum(case when sess_visit_date = user_create_date + interval '2 week' then 1 else null end) as w2_cnt
	, sum(case when sess_visit_date = user_create_date + interval '3 week' then 1 else null end) as w3_cnt
	, sum(case when sess_visit_date = user_create_date + interval '4 week' then 1 else null end) as w4_cnt
	, sum(case when sess_visit_date = user_create_date + interval '5 week' then 1 else null end) as w5_cnt
	, sum(case when sess_visit_date = user_create_date + interval '6 week' then 1 else null end) as w6_cnt
	, sum(case when sess_visit_date = user_create_date + interval '7 week' then 1 else null end) as w7_cnt
from temp_01 
group by user_create_date
)
select user_create_date, create_cnt
     -- w1 에서 w7 주별 잔존율 구하기.
	, round(100.0 * w1_cnt/create_cnt, 2) as w1_ratio
	, round(100.0 * w2_cnt/create_cnt, 2) as w2_ratio
	, round(100.0 * w3_cnt/create_cnt, 2) as w3_ratio
	, round(100.0 * w4_cnt/create_cnt, 2) as w4_ratio
	, round(100.0 * w5_cnt/create_cnt, 2) as w5_ratio
	, round(100.0 * w6_cnt/create_cnt, 2) as w6_ratio
	, round(100.0 * w7_cnt/create_cnt, 2) as w7_ratio
from temp_02 order by 1;

with temp_01 as (
	select a.user_id, date_trunc('week', a.create_time)::date as user_create_date,  date_trunc('week', b.visit_stime)::date as sess_visit_date
		, count(*) cnt,
	from ga.ga_users a
		left join ga.ga_sess b
			on a.user_id = b.user_id
	--where  create_time >= (:current_date - interval '7 weeks') and create_time < :current_date
	where create_time >= to_date('20160912', 'yyyymmdd') and create_time < to_date('20161101', 'yyyymmdd')
--	and channel_grouping='Social' -- Social Organic Search, Direct, Referral
	group by a.user_id, date_trunc('week', a.create_time)::date, date_trunc('week', b.visit_stime)::date
), 
temp_02 as (
select user_create_date, count(*) as create_cnt
	-- w1 에서 w7까지 주단위 접속 사용자 건수 구하기.
	, sum(case when sess_visit_date = user_create_date + interval '1 week' then 1 else null end ) as w1_cnt
	, sum(case when sess_visit_date = user_create_date + interval '2 week' then 1 else null end) as w2_cnt
	, sum(case when sess_visit_date = user_create_date + interval '3 week' then 1 else null end) as w3_cnt
	, sum(case when sess_visit_date = user_create_date + interval '4 week' then 1 else null end) as w4_cnt
	, sum(case when sess_visit_date = user_create_date + interval '5 week' then 1 else null end) as w5_cnt
	, sum(case when sess_visit_date = user_create_date + interval '6 week' then 1 else null end) as w6_cnt
	, sum(case when sess_visit_date = user_create_date + interval '7 week' then 1 else null end) as w7_cnt
from temp_01 
group by user_create_date
)
select user_create_date, create_cnt
     -- w1 에서 w7 주별 잔존율 구하기.
	, round(100.0 * w1_cnt/create_cnt, 2) as w1_ratio
	, round(100.0 * w2_cnt/create_cnt, 2) as w2_ratio
	, round(100.0 * w3_cnt/create_cnt, 2) as w3_ratio
	, round(100.0 * w4_cnt/create_cnt, 2) as w4_ratio
	, round(100.0 * w5_cnt/create_cnt, 2) as w5_ratio
	, round(100.0 * w6_cnt/create_cnt, 2) as w6_ratio
	, round(100.0 * w7_cnt/create_cnt, 2) as w7_ratio
from temp_02 group by channel_grouping order by 1;


/************************************
 (2016년 9월 12일 부터) 일주일간 생성된 사용자들에 대해 채널별 주 단위 잔존율(Retention rate)
*************************************/

-- 2016/09/12기준으로 일주일 주기로 봤을 때, W+1에서 가장 잔존율이 낮은 채널은 Paid Search(광고배너)
-- 총계 봤을 때는 W+1의 잔존율은 19.56%로 Organic Search, Paid Search, Social을 제외한 다른 채널은 전체 평균보다 잔존율이 높음 
with temp_01 as (
	select a.user_id, channel_grouping
		, date_trunc('week', a.create_time)::date as user_create_date,  date_trunc('week', b.visit_stime)::date as sess_visit_date
		, count(*) cnt
	from ga.ga_users a
		left join ga.ga_sess b
			on a.user_id = b.user_id
	where  create_time >= to_date('20160912', 'yyyymmdd') and create_time < to_date('20160919', 'yyyymmdd')
	--and channel_grouping='Referral' -- Social Organic Search, Direct, Referral
	group by a.user_id, channel_grouping, date_trunc('week', a.create_time)::date, date_trunc('week', b.visit_stime)::date
), 
temp_02 as (
select user_create_date, channel_grouping, count(*) as create_cnt
     -- w1 에서 w7까지 주단위 접속 사용자 건수 구하기.
	, sum(case when sess_visit_date = user_create_date + interval '1 week' then 1 else null end ) as w1_cnt
	, sum(case when sess_visit_date = user_create_date + interval '2 week' then 1 else null end) as w2_cnt
	, sum(case when sess_visit_date = user_create_date + interval '3 week' then 1 else null end) as w3_cnt
	, sum(case when sess_visit_date = user_create_date + interval '4 week' then 1 else null end) as w4_cnt
	, sum(case when sess_visit_date = user_create_date + interval '5 week' then 1 else null end) as w5_cnt
	, sum(case when sess_visit_date = user_create_date + interval '6 week' then 1 else null end) as w6_cnt
	, sum(case when sess_visit_date = user_create_date + interval '7 week' then 1 else null end) as w7_cnt
from temp_01 
group by user_create_date, rollup(channel_grouping)
)
select user_create_date, channel_grouping, create_cnt
    -- w1 에서 w7 주별 잔존율 구하기
	, round(100.0 * w1_cnt/create_cnt, 2) as w1_ratio
	, round(100.0 * w2_cnt/create_cnt, 2) as w2_ratio
	, round(100.0 * w3_cnt/create_cnt, 2) as w3_ratio
	, round(100.0 * w4_cnt/create_cnt, 2) as w4_ratio
	, round(100.0 * w5_cnt/create_cnt, 2) as w5_ratio
	, round(100.0 * w6_cnt/create_cnt, 2) as w6_ratio
	, round(100.0 * w7_cnt/create_cnt, 2) as w7_ratio
from temp_02 order by 2;