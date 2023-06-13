select * from ga.ga_sess;

select * from ga.ga_sess_hits;

select * from ga.ga_sess_hits where sess_id='S0000505' order by hit_seq;

select hit_type,count(*) from ga.ga_sess_hits group by hit_type;

/* action_type
   Unknown = 0. (홈페이지)
   Click through of product lists = 1, (상품 목록 선택)
   Product detail views = 2, (상품 상세 선택)
   Add product(s) to cart = 3, (카트에 상품 추가)
   Remove product(s) from cart = 4, (카트에서 상품 제거)
   Check out = 5, (결재 시작)
   Completed purchase = 6, (구매 완료)
   Refund of purchase = 7, (환불)
   Checkout options = 8 (결재 옵션 선택)
   
   이 중 1, 3, 4가 주로 EVENT로 발생. 0, 2, 5, 6은 주로 PAGE로 발생. 
 */
select hit_type,action_type,count(*) from ga.ga_sess_hits group by hit_type,action_type;

-- action_type에 따른 건수
select action_type,count(*) action_cnt,
sum(case when hit_type='PAGE' then 1 else 0 end) page_action_cnt,
sum(case when hit_type='EVENT' then 1 else 0 end) event_action_cnt
from ga.ga_sess_hits
group by rollup(action_type)

/************************************
Hit수가 가장 많은 상위 5개 페이지(이벤트 포함)와 세션당 최대, 평균, 4분위 페이지/이벤트 Hit수
*************************************/

-- hit수가 가장 많은 상위 5개 페이지(이벤트 포함)
select page_path,count(*) hits_by_page
from ga.ga_sess_hits
group by page_path
order by hits_by_page desc
fetch first 5 row only;

-- 세션당 최대, 평균, 4분위 페이지(이벤트 포함) Hit 수
with temp1 as (
select sess_id,count(*) hits_by_sess
from ga.ga_sess_hits
group by sess_id)
select max(hits_by_sess),avg(hits_by_sess),
percentile_disc(0.25) within group(order by hits_by_sess),
percentile_disc(0.5) within group(order by hits_by_sess),
percentile_disc(0.75) within group(order by hits_by_sess),
percentile_disc(1) within group(order by hits_by_sess) 
from temp1;
