/*
*************************************
일/주/월/분기별 매출 및 주문건수 실적
*************************************
*/
/* 학습함수 : date_trunc
 * date_trunc(날짜형식,필드명) : 날짜필드를 입력한 날짜형식 기준으로 인수를 사용하여 다양한 날짜, 시간 형식으로 데이터를 자를 
 * ::date를 넣어주면 출력값 디폴트가 타임스탬프에서 날짜 형식으로 변환되어 출력됨 
 * orders,order_items 테이블 사용
 * */

select * from nw.orders;
select * from nw.order_items;
-- 일별 매출 및 주문건수
select date_trunc('day', order_date)::date as day
	, sum(amount) as sum_amount, count(distinct a.order_id) as daily_ord_cnt
from nw.orders a
	join nw.order_items b on a.order_id = b.order_id
group by date_trunc('day', order_date)::date 
order by 1;

-- 월별 매출 및 주문건수
select date_trunc('month',order_date)::date as month_day,
sum(amount) as sum_amount,count(distinct a.order_id) as month_ord_cnt
from nw.orders a
join nw.order_items b on a.order_id=b.order_id
group by date_trunc('month',order_date)::date order by 1;

-- 주별 매출 및 주문건수
select date_trunc('week',order_date)::date as week_day,
sum(amount) as sum_amount,count(distinct a.order_id) as week_ord_cnt
from nw.orders a
join nw.order_items b on a.order_id=b.order_id
group by date_trunc('week',order_date)::date order by 1;

--분기 매출 및 주문건수
select date_trunc('quarter',order_date)::date as qt_day,
sum(amount) as sum_amount,count(distinct a.order_id) as qt_ord_cnt
from nw.orders a
join nw.order_items b on a.order_id=b.order_id
group by date_trunc('quarter',order_date)::date order by 1;