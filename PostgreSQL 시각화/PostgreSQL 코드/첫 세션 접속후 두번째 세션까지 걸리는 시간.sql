with
temp_01 as (
	select distinct visit_stime,user_id, 
	row_number() over (partition by user_id order by visit_stime) as session_rnum 
	-- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, count(*) over (partition by user_id) as session_cnt
from ga.ga_sess
)
select * from temp_01
where session_rnum<=2 and session_cnt>1
order by user_id;

-- 1번 세션과 2번 세션이 같은 시간인 경우가 존재해 순위 1,2번을 선택하면 시간의 차이가 0으로 계산됨.
-- distinct 함수를 사용해 중복인 시간을 제거한 뒤 1,2번째 접속시간의 차이를 계산
with temp1 as(
select distinct visit_stime,user_id from ga.ga_sess),
temp2 as(
select user_id,row_number() over (partition by user_id order by visit_stime) as session_rnum,
	visit_stime
	-- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, count(*) over (partition by user_id) as session_cnt
	from temp1
)
select user_id,
max(visit_stime) max_time,min(visit_stime) min_time,
max(visit_stime)-min(visit_stime) diff_stime
from temp2
where session_rnum<=2 and session_cnt>1
group by user_id
order by user_id;

with temp1 as(
select distinct visit_stime,user_id from ga.ga_sess),
temp2 as(
select user_id,row_number() over (partition by user_id order by visit_stime) as session_rnum,
	visit_stime
	-- 추후에 1개 session만 있는 사용자는 제외하기 위해 사용. 
	, count(*) over (partition by user_id) as session_cnt
	from temp1
),
temp3 as(
select user_id,
max(visit_stime) max_time,min(visit_stime) min_time,
max(visit_stime)-min(visit_stime) diff_stime
from temp2
where session_rnum<=2 and session_cnt>1
group by user_id
order by user_id)
-- postgresql avg(time)은 interval이 제대로 고려되지 않음. justify_inteval()을 적용해야 함. 
-- justify_interval을 쓸 경우 5 days 31:15:54.813129 24시간을 넘어선 시간이 출력 됨.
select justify_interval(avg(diff_stime)) as avg_time
    , max(diff_stime) as max_time, min(diff_stime) as min_time 
	, percentile_disc(0.25) within group (order by diff_stime) as percentile_1
	, percentile_disc(0.5) within group (order by diff_stime)	as percentile_2
	, percentile_disc(0.75) within group (order by diff_stime)	as percentile_3
	, percentile_disc(1.0) within group (order by diff_stime)	as percentile_4
from temp3
where diff_stime::interval > interval '0 second';
;
