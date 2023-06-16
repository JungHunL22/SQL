/************************************
이탈율(Bounce Ratio) 추출
최초 접속 후 다른 페이지로 이동하지 않고 바로 종료한 세션 비율
전체 페이지를 기준으로 이탈율을 구할 경우 bounce session 건수/고유 session 건수
*************************************/
select * from ga.ga_sess_hits;

-- bounce session 추출
select sess_id,count(*) from ga.ga_sess_hits
group by sess_id having count(*)=1; 


select sess_id,count(*),max(hit_type),min(hit_type) from ga.ga_sess_hits
group by sess_id having count(*)=1; 


-- 전체 세션 24만 건 중 12만건이 이탈하여 이탈율은 약 50%로 계산됨
with temp1 as(
select sess_id,count(*) page_cnt
from ga.ga_sess_hits
group by 1
)
select count(*) total_page_cnt,
sum(case when page_cnt=1 then 1 else 0 end) bounce_sess_cnt,
round(100.0*sum(case when page_cnt=1 then 1 else 0 end)/count(*),2) bounce_rate
from temp1;

-- 이전에 구했던 건수의 분포를 대략 살펴봤을 때 전체 50%까지도 세션건수가 1건이었음.(left skewed 분포)
with temp1 as( 
select sess_id,count(*) hits_by_sess
from ga.ga_sess_hits
group by sess_id
)
select max(hits_by_sess),avg(hits_by_sess),min(hits_by_sess),count(*) cnt,
percentile_disc(0.25) within group(order by hits_by_sess) percentile_25,
percentile_disc(0.5) within group(order by hits_by_sess) percentile_50,
percentile_disc(0.75) within group(order by hits_by_sess) percentile_75,
percentile_disc(0.80) within group(order by hits_by_sess) percentile_80,
percentile_disc(1.00) within group(order by hits_by_sess) percentile_100
from temp1;

