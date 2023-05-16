/*******************************
 작년 대비 동월 매출 비교, 작년 동월 대비 차이/비율/매출 성장 비율 추출
* 1. 월별 매출액 추출
* 1의 테이블에서 12개월 이전 매출 데이터를 가져와 연도별 월별 매출 비교
********************************/

with temp_01 as(
select date_trunc('month',order_date)::date as month_day
,sum(amount) sum_amt
from nw.orders a join nw.order_items b on a.order_id=b.order_id
group by date_trunc('month',order_date)::date
),
temp_02 as(
select month_day,sum_amt cur_amt
,lag(month_day,12) over(order by month_day) as prev_month_1y
,lag(sum_amt,12) over(order by month_day) as prev_amt_1y from temp_01 order by 1)
select *,cur_amt-prev_amt_1y as diff_amt,
100.0*cur_amt/prev_amt_1y as rate_amt,
100.0*(cur_amt-prev_amt_1y)/prev_amt_1y gr_amt from temp_02
where prev_amt_1y is not null;

/*****************************
 * 분기별 매출 비교
 *****************************/
-- 1997년 3분기 -> 1996년 3분기
with temp_01 as(
select date_trunc('quarter',order_date)::date as qt_day
,sum(amount) sum_amt
from nw.orders a join nw.order_items b on a.order_id=b.order_id
group by date_trunc('quarter',order_date)::date
),
temp_02 as(
select qt_day,sum_amt cur_amt
,lag(qt_day,4) over(order by qt_day) as prev_qt_1y
,lag(sum_amt,4) over(order by qt_day) as prev_amt_1y from temp_01 order by 1)
select *,cur_amt-prev_amt_1y as diff_amt,
100.0*cur_amt/prev_amt_1y as rate_amt,
100.0*(cur_amt-prev_amt_1y)/prev_amt_1y gr_amt from temp_02
where prev_amt_1y is not null;