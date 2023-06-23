select * from ga.orders;


/**********************************************
 전체 매출 전환율 및 일별, 월별 매출 전환율과 매출액
***********************************************/
/* 
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
 *
 **/

-- action_type별 hit_type에 따른 건수
-- 구매완료는 약 0.5%
select action_type, count(*) action_cnt
	, sum(case when hit_type='PAGE' then 1 else 0 end) as page_action_cnt
	, sum(case when hit_type='EVENT' then 1 else 0 end) as event_action_cnt
from ga.ga_sess_hits
group by rollup(action_type)
;

-- 전체 매출 전환율
-- 구매완료의 고유 세션건수
with
temp1 as (
select count(distinct sess_id) purchase_sess_cnt
from ga.ga_sess_hits
where action_type='6'
),
-- 전체 action의 세션건수
temp2 as( 
select count(distinct sess_id) sess_cnt
from ga.ga_sess_hits
)
select purchase_sess_cnt,sess_cnt,
100.0*purchase_sess_cnt/sess_cnt sale_cv_rate
from temp1 a
cross join temp2 b;



-- 과거 1주일간 매출 전환률
with 
temp_01 as ( 
select count(distinct a.sess_id) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
where a.action_type = '6'
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
),
temp_02 as ( 
select count(distinct a.sess_id) as sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
)
select a.purchase_sess_cnt, b.sess_cnt, 100.0* a.purchase_sess_cnt/sess_cnt as sale_cv_rate
from temp_01 a 
	cross join temp_02 b
;


-- 과거 1주일간 일별 매출 전환률 - 01
with 
temp_01 as ( 
select date_trunc('day', b.visit_stime)::date as cv_day, count(distinct a.sess_id) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
where a.action_type = '6'
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
group by date_trunc('day', b.visit_stime)::date
), 
temp_02 as ( 
select date_trunc('day', b.visit_stime)::date as cv_day, count(distinct a.sess_id) as sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
where b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
group by date_trunc('day', b.visit_stime)::date
)
select a.cv_day, a.purchase_sess_cnt, b.sess_cnt, 100.0* a.purchase_sess_cnt/sess_cnt as sale_cv_rate
from temp_01 a 
	join temp_02 b on a.cv_day = b.cv_day
;

-- 과거 1주일간 일별 매출 전환률 - 02
with 
temp_01 as ( 
select date_trunc('day', b.visit_stime)::date as cv_day
	, count(distinct a.sess_id) as sess_cnt
	, count(distinct case when a.action_type = '6' then a.sess_id end) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
group by date_trunc('day', b.visit_stime)::date
)
select a.cv_day, purchase_sess_cnt, sess_cnt, 100.0* purchase_sess_cnt/sess_cnt as sale_cv_rate
from temp_01 a 
;

-- 일자별 고유세선건수 및 구매완료 세션건수
select date_trunc('day', b.visit_stime)::date as cv_day
	, count(distinct a.sess_id) as sess_cnt
	, count(distinct case when a.action_type = '6' then a.sess_id end) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
group by date_trunc('day', b.visit_stime)::date;

-- 일자별 총매출 테이블
select date_trunc('day', a.order_time)::date as ord_day
	, sum(prod_revenue) as sum_revenue
from ga.orders a
	join ga.order_items b on a.order_id = b.order_id
where a.order_time >= (:current_date - interval '7 days') and a.order_time < :current_date 
group by date_trunc('day', a.order_time)::date;

-- 과거 1주일간 일별 매출 전환률 및 매출액
with 
temp_01 as ( 
select date_trunc('day', b.visit_stime)::date as cv_day
	, count(distinct a.sess_id) as sess_cnt
	, count(distinct case when a.action_type = '6' then a.sess_id end) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
and b.visit_stime >= (:current_date - interval '7 days') and b.visit_stime < :current_date
group by date_trunc('day', b.visit_stime)::date
),
temp_02 as ( 
select date_trunc('day', a.order_time)::date as ord_day
	, sum(prod_revenue) as sum_revenue
from ga.orders a
	join ga.order_items b on a.order_id = b.order_id
where a.order_time >= (:current_date - interval '7 days') and a.order_time < :current_date 
group by date_trunc('day', a.order_time)::date
)
select a.cv_day, b.ord_day, a.sess_cnt, a.purchase_sess_cnt, 100.0* purchase_sess_cnt/sess_cnt as sale_cv_rate
	, b.sum_revenue, b.sum_revenue/a.purchase_sess_cnt as revenue_per_purchase_sess
from temp_01 a
	left join temp_02 b on a.cv_day = b.ord_day
;

	
-- 월별 매출 전환률과 매출액
with 
temp_01 as ( 
select date_trunc('month', b.visit_stime)::date as cv_month
	, count(distinct a.sess_id) as sess_cnt
	, count(distinct case when a.action_type = '6' then a.sess_id end) as purchase_sess_cnt
from ga.ga_sess_hits a
	join ga.ga_sess b on a.sess_id = b.sess_id
group by date_trunc('month', b.visit_stime)::date
),
temp_02 as ( 
select date_trunc('month', a.order_time)::date as ord_month
	, sum(prod_revenue) as sum_revenue
from ga.orders a
	join ga.order_items b on a.order_id = b.order_id 
group by date_trunc('month', a.order_time)::date
)
select a.cv_month, b.ord_month, a.sess_cnt, a.purchase_sess_cnt, 100.0* purchase_sess_cnt/sess_cnt as sale_cv_rate
	, b.sum_revenue, b.sum_revenue/a.purchase_sess_cnt as revenue_per_purchase_sess
from temp_01 a
	left join temp_02 b on a.cv_month = b.ord_month
;