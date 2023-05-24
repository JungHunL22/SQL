-- ga 스키마 확인
select * from ga.ga_users;

select * from ga.orders;

select count(*) from ga.orders

select min(order_time),max(order_time) from ga.orders

select * from ga.products

select * from ga.order_items;

select count(*) from ga.order_items;
---------------------------------------------------------------
-- 임시 테이블 생성
with temp_01 as(
select 'ord001' as order_id, 'A' as product_id
union all 
select 'ord001','B'
union all 
select 'ord001','C'
union all 
select 'ord002','B'
union all 
select 'ord002','D'
union all 
select 'ord003','A'
union all 
select 'ord003','B'
union all 
select 'ord003','D'
)
select * from temp_01;

with temp_01 as(
select 'ord001' as order_id, 'A' as product_id
union all 
select 'ord001','B'
union all 
select 'ord001','C'
union all 
select 'ord002','B'
union all 
select 'ord002','D'
union all 
select 'ord003','A'
union all 
select 'ord003','B'
union all 
select 'ord003','D'
),
temp_02 as(
select A.order_id,A.product_id as a_pro,B.product_id as b_pro 
from temp_01 A 
join temp_01 B on A.order_id=B.order_id
where A.product_id!=B.product_id
),
temp_03 as(
select a_pro,b_pro,count(*) cnt from temp_02 group by 1,2 order by 1,2,3
),
temp_04 as(
select a_pro,b_pro,cnt, row_number() over(partition by a_pro order by cnt desc) rnk from temp_03)
select * from temp_04 where rnk=1;

/************************************************
 order별 특정 상품 주문시 함께 가장 많이 주문된 상품 추출하기
*************************************************/
select *
from ga.order_items
where product_id in ('GGOEYAAJ032514','GGOEYAEB028414');

with temp1 as (
select B.user_id,A.order_id,a.product_id
from ga.order_items A join ga.orders B on A.order_id=B.order_id),
-- temp1을 user_id로 셀프 조인하면 M:M 조인으로 개별 user_id별 주문 상품별로 연관딘 주문 상품 집합을 생성
temp2 as(
select A.user_id,A.product_id as prd_a,B.product_id as prd_b
from temp1 A join temp1 B on A.user_id=B.user_id
where A.product_id!=B.product_id),
-- prd_a와prd_b 레벨로 group by
temp3 as(
select prd_a,prd_b,count(*) as cnt
from temp2
group by 1,2),
-- prd_a와 prd_b 상품별 가장 많은 조합을 cnt 순위로 추출
temp4 as(
select prd_a,prd_b,cnt,row_number() over(partition by prd_a order by cnt desc) rnk
from temp3)
select prd_a,prd_b,cnt,rnk
from temp4
where rnk=1;



)
