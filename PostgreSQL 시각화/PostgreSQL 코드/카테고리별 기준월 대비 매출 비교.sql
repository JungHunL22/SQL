/***********************************
 카테고리 별 기준 월 대비 배출 비율 추이(팬 차트)
 1. 상품 카테고리 별 월별 매출액 추출
 2. 1테이블에서 기준이 되는 월의 매출 대비 다음 월들의 비율
 ***********************************/

with temp_01 as (
select d.category_name,to_char(date_trunc('month',order_date)::date,'yyyymm') as month_day,
sum(amount) as sum_amt
from nw.orders a 
join nw.order_items b on a.order_id=b.order_id
join nw.products c on b.product_id=c.product_id
join nw.categories d on c.category_id=d.category_id
group by d.category_id,to_char(date_trunc('month',order_date)::date,'yyyymm') order by 1,2)
select *,first_value(sum_amt) over(partition by category_name order by month_day) base_amt,
round(100.0*sum_amt/first_value(sum_amt) over(partition by category_name order by month_day),2) base_pct from temp_01;