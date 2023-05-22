/*********************************************
 이전 주문이후 현주문까지 걸린 기간 및 걸린 기간의 히스토그램
 1. 고객 별로 이전 주문부터 다음 주문까지 걸린 일 수 테이블 조회
 ********************************************/

select customer_id,order_date,lag(ORDER_date) over(PARTITION BY customer_id ORDER BY ORDER_date) AS prev_date,
order_date-lag(ORDER_date) over(PARTITION BY customer_id ORDER BY ORDER_date) AS prev_date
FROM nw.orders;


/******************************
주문 테이블에서 이전 주문 이후 걸린 기간 bin=10 간격으로 테이블 조회
 *****************************/
WITH temp_01 as(
SELECT order_id,customer_id,order_date,
lag(ORDER_date) over(PARTITION BY customer_id ORDER BY ORDER_date) AS prev_date
FROM nw.orders),
temp_02 as(
/* bin 간격을 10으로 설정(floor는 소수점 이하는 전부 잘리므로 10단위로 간격이 생성됨)
 * 0~9일은 0,10~19는 10..순서로 간격 생성
 */
SELECT order_id,customer_id,order_date,order_date-prev_date as days_since 
FROM temp_01 where prev_date is not null)
select floor(days_since/10)*10 as bin, count(*) bin_cnt
from temp_02 group by floor(days_since/10)*10 order by 1;

/*************************************
 주문 테이블에서 이전 주문 이후 걸린 기간
 *************************************/
WITH temp_01 as(
SELECT order_id,customer_id,order_date,
lag(ORDER_date) over(PARTITION BY customer_id ORDER BY ORDER_date) AS prev_date
FROM nw.orders),
temp_02 as(
/* bin 간격을 10으로 설정(floor는 소수점 이하는 전부 잘리므로 10단위로 간격이 생성됨)
 * 0~9일은 0,10~19는 10..순서로 간격 생성
 */
SELECT order_id,customer_id,order_date,order_date-prev_date as days_since 
FROM temp_01 where prev_date is not null)
select * from temp_02;