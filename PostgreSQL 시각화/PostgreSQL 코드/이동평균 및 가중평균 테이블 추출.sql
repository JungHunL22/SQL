/**************************************
 월별/분기별 누적매출액 추출
 * * 1. 월별 매출액 계산
 * 2. 월별 매출액테이블과 동일년도 월별/분기별 누적매출 필드를 추가하여 계산
 **************************************/

-- 월별 매출액 테이블
with temp_01 as(
select date_trunc('month',order_date)::date as month_day
, sum(amount) as sum_amount
from nw.orders a join nw.order_items b on a.order_id=b.order_id
group by date_trunc('month',order_date)::date)
select *,date_trunc('year',month_day)::date as year_day,sum(sum_amount) over(partition by date_trunc('year',month_day) order by month_day) as acum_month_amt,
date_trunc('quarter',month_day)::date as qt_day,sum(sum_amount) over(partition by date_trunc('quarter',month_day) order by month_day) as acum_qt_amt from temp_01 order by month_day;

/**********************************
 * 5일 이동평균 매출액 구하기. 매출액은 주로 일주일 단위 이동평균을 구하지만 실습데이터는 토,일x
 * 1. 일별 매출 계산
 * 2. 5일단위의 평균매출 추출
 **********************************/
-- 날짜 순대로 다섯번쨰가 되는 1996/07/12부터 5일 이동평균을 계산함
-- 1. 순위함수를 사용해 5미만은 제거
with temp_02 as(
select date_trunc('day',order_date)::date as d_day,
sum(amount) as sum_amt
from nw.orders a join nw.order_items b on a.order_id=b.order_id
where order_date >= to_date('1996-07_08','yyyy-mm-dd')
group by date_trunc('day',order_date)::date),
temp_03 as(
select d_day,sum_amt,avg(sum_amt) over(order by d_day rows between 4 preceding and current row) as d5_avg,
row_number() over(order by d_day) from temp_02 
 order by d_day)
select * from temp_03 where row_number>=5;


-- 2. 이동평균의 최소일보다 낮은 날은 이동평균값에서 null로 제외
with temp_02 as(
select date_trunc('day',order_date)::date as d_day,
sum(amount) as sum_amt
from nw.orders a join nw.order_items b on a.order_id=b.order_id
where order_date >= to_date('1996-07_08','yyyy-mm-dd')
group by date_trunc('day',order_date)::date),
temp_03 as(
select d_day,sum_amt,avg(sum_amt) over(order by d_day rows between 4 preceding and current row) as d5_avg,
row_number() over(order by d_day) from temp_02 
 order by d_day)
select *,case when row_number<5 then null else d5_avg end d5_avg_n from temp_03;



-- 5일 이동평균매출과 가중평균매출 테이블
with temp_02 as(
select date_trunc('day',order_date)::date as d_day,
sum(amount) as sum_amt,row_number() over(order by date_trunc('day',order_date)::date) as rnum
from nw.orders a join nw.order_items b on a.order_id=b.order_id
where order_date >= to_date('1996-07_08','yyyy-mm-dd')
group by date_trunc('day',order_date)::date),
temp_03 as(
select a.d_day,a.sum_amt,a.rnum,b.d_day as d_day_2,b.sum_amt as sum_amt2,b.rnum as rnum2
from temp_02 a join temp_02 b on a.rnum between b.rnum and b.rnum+4)
select d_day,avg(sum_amt2) as m_avg_5d,
-- sum을 건수인 5로 나누면 평균(5일째부터 제대로된 이동평균이 계산됨 1~4일째는 건수가 5가 되지않아 이동평균값이 아님)
sum(sum_amt2)/5 as m_avg_5d_2,
/*5일 매출 합
자기자신은*1.5
1~3일차이는 매출*1
4일차이는 매출*0.5를 곱해 가중평균 산출
*/
sum(case when rnum-rnum2=4 then 0.5*sum_amt2
-- rnum-rnum2 in (1,2,3) then 0.5*sum_amt2으로 써도 됨.
when rnum-rnum2 between 1 and 3 then sum_amt2
when rnum-rnum2=0 then 1.5*sum_amt2 end) as wt_sum_5d,
sum(case when rnum-rnum2=4 then 0.5*sum_amt2
-- rnum-rnum2 in (1,2,3) then 0.5*sum_amt2으로 써도 됨.
when rnum-rnum2 between 1 and 3 then sum_amt2
when rnum-rnum2=0 then 1.5*sum_amt2 end) / 5 as wt_avg_5d,
count(*)
-- 5건이하는 가중평균값이 아니므로 제거하기위해 count해놓음
from temp_03 group by d_day having count(*)>4 order by d_day ;

-- 가중평균 테이블 조인 설명하기위한 테이블
with temp_02 as(
select date_trunc('day',order_date)::date as d_day,
sum(amount) as sum_amt,row_number() over(order by date_trunc('day',order_date)::date) as rnum
from nw.orders a join nw.order_items b on a.order_id=b.order_id
where order_date >= to_date('1996-07_08','yyyy-mm-dd')
group by date_trunc('day',order_date)::date),
temp_03 as(
select a.d_day,a.sum_amt,a.rnum,b.d_day as d_day_2,b.sum_amt as sum_amt2,b.rnum as rnum2
from temp_02 a cross join temp_02 b)
select * from temp_03;
