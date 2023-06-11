/************************************
채널별 고유 사용자 건수와 매출금액 및 비율, 주문 사용자 건수와 주문 매출 금액 및 비율
채널별로 고유 사용자 건수와 매출 금액을 구하고 고유 사용자 건수 대비 매출 금액 비율을 추출. 
또한 고유 사용자 중에서 주문을 수행한 사용자 건수를 추출 후 주문 사용자 건수 대비 매출 금액 비율을 추출
*************************************/

-- 매출이 존재하는 테이블( 매출 : prod_revenue )/(여러개의 주문을 가짐)
select * from ga.order_items;

-- 세션과 조인하기 위해 필요한 테이블 : orders(하나의 주문을 가지면서,여러개의 세션을 가짐)
select * from ga.orders;

--세션과 유저가 하나의 고유 값을 가짐
select * from ga.ga_sess;

-- 주문을 하지않은 세션
with temp_01 as(
select a.sess_id,a.user_id,a.channel_grouping,b.order_id,c.prod_revenue
from ga.ga_sess a
left join ga.orders b on a.sess_id=b.sess_id
left join ga.order_items c on b.order_id=c.order_id
where a.visit_stime >= (:current_date - interval '30 days') 
and a.visit_stime<:current_date
)
select * from temp_01
where order_id is null;

-- 채널별 사용자 대비 매출이 얼마나 나오는지 비교가능
with temp_01 as(
select a.sess_id,a.user_id,a.channel_grouping,b.order_id,c.prod_revenue
from ga.ga_sess a
left join ga.orders b on a.sess_id=b.sess_id
left join ga.order_items c on b.order_id=c.order_id
where a.visit_stime >= (:current_date - interval '30 days') 
and a.visit_stime<:current_date
)
select channel_grouping,
sum(prod_revenue) ch_amt,
count(distinct user_id) ch_user_cnt,-- 접속 고유 사용자수
count(distinct case when order_id is not null then user_id end) ch_ord_user_cnt,-- 주문 고유 사용자수
sum(prod_revenue)/count(distinct user_id) ch_amt_per_user,-- 접속자 당 주문 매출
sum(prod_revenue)/count(distinct case when order_id is not null then user_id end) ch_amt_per_ord -- 주문자 당 주문 매출
from temp_01 
--group by rollup(channel_grouping) 
group by channel_grouping 
order by ch_user_cnt desc;
