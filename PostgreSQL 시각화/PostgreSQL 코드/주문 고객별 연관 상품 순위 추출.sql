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