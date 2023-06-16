-- 페이지별 이탈율 계산 절차
-- 1. sess_id,seq,page,cnt 추출
--select * from ga.ga_sess_hits;
--
--select sess_id,hit_seq,page_path
--from ga.ga_sess_hits
--group by 1;


/************************************
과거 30일간 페이지별 이탈율(bounce rate)
페이지별 이탈율을 계산할 경우 전체 세션이 아니라 현재 페이지가 세션별 첫페이지와 동일한 경우만 대상
즉 bounce 세션 건수/현재 페이지가 세션별 첫페이지와 동일한 고유 세션 건수로 이탈율 계산
*************************************/
-- 과거 30일간 페이지별 이탈율(bounce rate)
with 
temp_01 as ( 
select a.page_path, b.sess_id, hit_seq, hit_type, action_type
	-- 세션별 페이지 건수를 구함. 
	, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
	-- 세션별 첫페이지를 구해서 추후에 현재 페이지와 세션별 첫페이지가 같은지 비교하기 위한 용도. 
	, first_value(page_path) over (partition by b.sess_id order by hit_seq) as first_page_path
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
), 
temp_02 as (
select page_path, count(*) as page_cnt
	--세션별 페이지 건수가 1일때만 bounce session이므로 페이지별 bounce session 건수를 구함. 
	, sum(case when sess_cnt = 1 then 1 else 0 end) as bounce_cnt_per_page
	-- path_page와 세션별 첫번째 페이지가 동일한 경우에만 고유 세션 건수를 구함. 
	, count(distinct case when first_page_path = page_path then sess_id else null end) as sess_cnt_per_page_01
	, count(distinct sess_id) as sess_cnt_per_page_02
	from temp_01
group by page_path
)
select *
	-- 이탈율 계산. sess_cnt_01이 0 일 경우 0으로 나눌수 없으므로 Null값 처리. sess_cnt_01이 0이면 bounce session이 없으므로 이탈율은 0임. 
	, coalesce(round(100.0 * bounce_cnt_per_page / (case when sess_cnt_per_page_01 = 0 then null else sess_cnt_per_page_01 end), 2), 0) as bounce_pct_01
	, round(100.0 * bounce_cnt_per_page / sess_cnt_per_page_02, 2) as bounce_pct_02
from temp_02
order by page_cnt desc;

-- 데이터 검증. /basket.html 페이지에 대해서 /basket.html 으로 시작하는 session의 count와 그렇지 않은 count를 구하기. 
with
temp_01 as ( 
select a.page_path, b.sess_id, hit_seq, hit_type, action_type
	-- 세션별 페이지 건수를 구함. 
	, count(*) over (partition by b.sess_id rows between unbounded preceding and unbounded following) as sess_cnt
	-- 세션별 첫페이지를 구해서 추후에 현재 페이지와 세션별 첫페이지가 같은지 비교하기 위한 용도. 
	, first_value(page_path) over (partition by b.sess_id order by hit_seq) as first_page_path
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id 
where visit_stime >= (:current_date - interval '30 days') and visit_stime < :current_date
and a.hit_type = 'PAGE'
), 
temp_02 as (
select *
	-- 해당 page가 first page 인지 여부를 1과 0으로 표시
	, case when first_page_path=page_path then 1 else 0 end as first_gubun
from temp_01 
where page_path='/basket.html'
)
select first_gubun, count(distinct sess_id)
from temp_02
group by first_gubun
-- select * from temp_02;
