select *,last_value(page_path) over(partition by sess_id order by hit_seq) from ga.ga_sess_hits;

/************************************
과거 30일간 페이지별 종료율(Exit ratio) 구하기
*************************************/
-- is_exit는 세션당 하나의 1을 가짐.
with 
temp_01 as ( 
select a.sess_id, a.page_path, hit_seq, hit_type, action_type, is_exit
	-- 종료 페이지 여부를 구함. 종료 페이지면 1 아니면 0
	, case when row_number() over(partition by a.sess_id order by hit_seq desc)=1 then 1 else 0 end is_exit_page
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
)
select * from temp_01 order by sess_id,hit_seq;

-- 과거 30일간 페이지별 종료율(Exit ratio) 구하기 
with 
temp_01 as ( 
select a.sess_id, a.page_path, hit_seq, hit_type, action_type, is_exit
	-- 종료 페이지 여부를 구함. 종료 페이지면 1 아니면 0
	, case when row_number() over(partition by a.sess_id order by hit_seq desc)=1 then 1 else 0 end is_exit_page
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
)
select page_path, count(*) as page_cnt
	-- 페이지별 고유 세션 건수를 구함. 
	, count(distinct sess_id) as sess_cnt
	-- 해당 페이지가 종료 페이지일 경우에만 고유 세션 건수를 구함. 
	, count(distinct case when is_exit_page = 1 then sess_id else null end) as exit_cnt
	-- 아래와 같이 is_exit_page가 1, 0 이고 개별 session에 exit page는 최대 1개 이므로 아래와 같이 사용해도 됨. 
	-- is_exit_page는 1인 값을 갖는 경우가 세션당 하나이므로 sum을 해도 같은 값이 출력됨.	
    , sum(is_exit_page) as exit_cnt_01
	, round(100.0 * count(distinct case when is_exit_page = 1 then sess_id else null end)/count(distinct sess_id), 2) as exit_pct
from temp_01
group by page_path order by page_cnt desc;

-- 앞에서 구한 페이지별 페이지 조회수, 순 페이지 조회수, 평균 머문시간, 이탈율과 함께 종료율 집계
with
temp_01 as (
	select a.sess_id, a.page_path, hit_seq, hit_time
		, lead(hit_time) over (partition by a.sess_id order by hit_seq) as next_hit_time
		-- 세션내에서 동일한 page_path가 있을 경우 rnum은 2이상이 됨. 추후에 1값만 count를 적용. 
		, row_number() over (partition by a.sess_id, page_path order by hit_seq) as rnum
		-- 세션별 페이지 건수를 구함. 
		, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
		-- 세션별 첫페이지를 구해서 추후에 현재 페이지와 세션별 첫페이지가 같은지 비교하기 위한 용도. 
		, first_value(page_path) over (partition by b.sess_id order by hit_seq) as first_page_path
		---종료 페이지 여부를 구함. 종료 페이지면 1 아니면 0
		, case when row_number() over (partition by b.sess_id order by hit_seq desc) = 1 then 1 else 0 end as is_exit_page
	from ga.ga_sess_hits a
		join ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
), 
temp_02 as (
select page_path, count(*) as page_cnt
	, count(case when rnum = 1 then '1' else null end) as unique_page_cnt
	, round(avg(next_hit_time - hit_time)/1000.0, 2) as avg_elapsed_sec
	--세션별 페이지 건수가 1일때만 bounce session이므로 페이지별 bounce session 건수를 구함. 
	, sum(case when sess_cnt = 1 then 1 else 0 end) as bounce_cnt_per_page
	-- path_page와 세션별 첫번째 페이지가 동일한 경우에만 고유 세션 건수를 구함. 
	, count(distinct case when first_page_path = page_path then sess_id else null end) as sess_cnt_per_page
	, count(distinct sess_id) as sess_cnt
	-- 해당 페이지가 종료 페이지일 경우에만 고유 세션 건수를 구함. 
	, count(distinct case when is_exit_page = 1 then sess_id else null end) as exit_cnt
from temp_01
group by page_path 
)
select page_path, page_cnt, unique_page_cnt, sess_cnt as visit_cnt, avg_elapsed_sec
     -- 이탈율 집계
    , coalesce(round(100.0 * bounce_cnt_per_page / (case when sess_cnt_per_page = 0 then null else sess_cnt_per_page end), 2), 0) as bounce_pct
    -- 종료율 집계
    , round(100.0 * exit_cnt / sess_cnt, 2) as exit_pct
from temp_02 order by page_cnt desc;