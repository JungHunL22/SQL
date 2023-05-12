/***********************************
 전체 매출액 중에서 카테고리별 비율
 * 1. 상품 카테고리 별 월별 매출액 추출
 * 2. 1번에서 구한 매출액 테이블을 이용해 전체 매출액에서 차지하는 비율 계산
 ***********************************/
-- categories 테이블 내에 category_id가 존재하고,
select * from nw.categories;
-- products 테이블 내에 category_id와 조인해서 category_name을 추출
select * from nw.products;
-- 카테고리 및 월별 매출액과 주문건수 테이블 조회- 카테고리별 월별 매출액을 월별 총 매출액으로 나눠 비율 추출
with table_01 as (select d.category_name,to_char(date_trunc('month',order_date),'yyyymm') as month_day
	,sum(amount) as sum_amount, count(distinct a.order_id) monthly_ord_cnt
from nw.orders a 
	join nw.order_items b on a.order_id=b.order_id
	join nw.products c on b.product_id =c.product_id 
	join nw.categories d on c.category_id =d.category_id 
group by d.category_name,to_char(date_trunc('month',order_date),'yyyymm')
)
select *,sum(sum_amount) over(partition by month_day) as month_total_amt,
round(sum_amount/sum(sum_amount) over(partition by month_day),3) as month_rate
from table_01;

/***********************************
해당 상품 카테고리에서 매출액 비율 및 순위
 * 1. 주문상품,상품,카테고리 테이블 조인
 * 2. 상품별 총매출액과 상품이름 카테고리 이름 출력,순위 계산
 ***********************************/

select * from nw.order_items;
select * from nw.products;
select * from nw.categories;

-- 상품명과 카테고리명에 max() 함수를 적용한 이유는 group by를 했기 떄문에 aggregation 함수를 넣어야 출력되기 떄문
with table_02 as (
select a.product_id,sum(amount) as sum_amount,max(product_name) pd_name,max(category_name) as ct_name
from nw.order_items a
	join nw.products b on a.product_id=b.product_id
	join nw.categories c on b.category_id=c.category_id
	group by a.product_id)
select pd_name,sum_amount as pd_sales,
ct_name,sum(sum_amount) over(partition by ct_name) as ct_sales
,round(sum_amount/sum(sum_amount) over(partition by ct_name),3) as pd_ct_rate
,row_number() over (partition by ct_name order by sum_amount desc) as pd_rn
from table_02 order by ct_name,pd_sales desc;