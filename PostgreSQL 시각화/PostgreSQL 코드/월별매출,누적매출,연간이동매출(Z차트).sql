/*************************
 Z차트 매출 추출
 *************************/

with temp_01 as(
select to_char(a.order_date,'yyyymm') as year_m,sum(amount) as sum_amt
from nw.orders a join nw.order_items b on a.order_id=b.order_id
group by to_char(a.order_date,'yyyymm') order by 1
),
temp_02 as(
select year_m,sum_amt,substring(year_m,1,4) as y,
	sum(sum_amt) over(partition by substring(year_m,1,4) order by year_m) as cul_amt,
	sum(sum_amt) over(order by year_m rows between 11 preceding and current row) year_amt
	from temp_01)
/*바로 where절을 이용해 where year_m between '199708' and '199805'
 * 처럼 쓰면 where절이 먼저 실행되어 다른 달의 매출을 계산하지못함. */
select * from temp_02 where y='1997';
-- temp_02를 생성해 마지막에 97년 데이터만 불러옴