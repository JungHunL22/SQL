/****************************************
월별 사용자 평균 주문 건수
1. 고객별 월별 주문 건수를 조회
2. 월별로 사용자 당 평균적으로 몇 건을 주문했는 지 추출
*****************************************/
select customer_id,date_trunc('month',order_date)::date month_day,count(*) cnt from nw.orders
group by 1,2 order by 1,2;

with temp_01 as(
select date_trunc('month',order_date)::date month_day,count(*) cnt from nw.orders
group by customer_id,date_trunc('month',order_date)
)
select month_day,avg(cnt) avg,max(cnt) max,min(cnt) min from temp_01 group by month_day
order by month_day;