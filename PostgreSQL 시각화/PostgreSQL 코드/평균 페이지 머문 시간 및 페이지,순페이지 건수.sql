/************************************
 과거 한달간 페이지별 조회수와 순 페이지(세션 고유 페이지) 조회수
*************************************/
-- 페이지별 조회수와 순페이지 조회수
with
temp_01 as (
	select page_path, count(*) as page_cnt
	from ga.ga_sess_hits 
	where hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct sess_id, page_path
		from ga.ga_sess_hits 
		where hit_type = 'PAGE'
	) a group by page_path
)
select a.page_path, page_cnt, unique_page_cnt
from temp_01 a
	join temp_02 b on a.page_path = b.page_path
order by 2 desc;


 
-- subquery에 row_number를 이용해 중복을 제거하고 첫번째 세션 id,path를 추출하면 속도가 훨씬 개선됨.
with
temp_01 as (
	select a.page_path, count(*) as page_cnt
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	where hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select sess_id, page_path
			, row_number() over (partition by sess_id, page_path order by page_path) as rnum
		from ga.ga_sess_hits 
		where hit_type = 'PAGE'
	) a 
	where rnum = 1 
    group by page_path
)
select a.page_path, page_cnt, unique_page_cnt
from temp_01 a
	join temp_02 b on a.page_path = b.page_path
order by 2 desc;

-- 아래는 과거 한달간 페이지별 조회수와 순 페이지(세션 고유 페이지) 조회수
with
temp_01 as (
	select a.page_path, count(*) as page_cnt
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	where hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct a.sess_id, a.page_path
		from ga.ga_sess_hits a
			join ga.ga_sess b on a.sess_id = b.sess_id 
		where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
		where hit_type = 'PAGE'
	) a group by page_path
)
select a.page_path, page_cnt, unique_page_cnt
from temp_01 a
	join temp_02 b on a.page_path = b.page_path
order by 2 desc;


-- 페이지별 조회 건수와 순수 조회(세션별 unique 페이지), 평균 머문 시간(초)를 한꺼번에 구하기
-- 개별적인 집합을 각각 만든 뒤 이를 조인
with
temp_01 as (
	select a.page_path, count(*) as page_cnt
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
	group by page_path
), 
temp_02 as (
	select page_path, count(*) as unique_page_cnt
	from (
		select distinct a.sess_id, a.page_path
		from ga.ga_sess_hits a
			join ga.ga_sess b on a.sess_id = b.sess_id 
		where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
		and a.hit_type = 'PAGE'
	) a group by page_path
), 
temp_03 as (
	select a.sess_id, page_path, hit_seq, hit_time
		, lead(hit_time) over (partition by a.sess_id order by hit_seq) as next_hit_time
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id 
	where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
	and a.hit_type = 'PAGE'
), 
temp_04 as (
select page_path, count(*) as page_cnt
	, round(avg(next_hit_time - hit_time)/1000.0, 2) as avg_elapsed_sec
from temp_03
group by page_path
)
select a.page_path, a.page_cnt, b.unique_page_cnt, c.avg_elapsed_sec
from temp_01 a
	left join temp_02 b on a.page_path = b.page_path
	left join temp_04 c on a.page_path = c.page_path
order by 2 desc;