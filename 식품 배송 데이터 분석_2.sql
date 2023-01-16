# 시간별 주문 건수
select order_hour_of_day,count(distinct order_id) order_n
from instacart.orders
group by 1 order by 1;

# 첫 구매로부터 다음 구매까지의 평균 기간
select avg(days_since_prior_order) avg_recency
from instacart.orders
where order_number=2;

# 주문 건당 평균 상품 수
select count(product_id)/count(distinct order_id) avg_item
from instacart.order_products__prior;

# 인당 평균 주문건수
select count(distinct order_id)/count(distinct user_id) AVG_F
from instacart.orders;

# 상품별 재구매율
select product_id,sum(case when reordered=1 then 1 else 0 end)/count(*) reorder_ratio
from instacart.order_products__prior
group by 1;

# 재구매율 상위 10개 상품
select *
from(select *,row_number() over(order by reorder_ratio desc) RNK
from (select product_id,sum(case when reordered=1 then 1 else 0 end)/count(*) reorder_ratio
from instacart.order_products__prior
group by 1) A) A
where RNK <=10;

# department별 재구매율 상위 10개
select * 
from
(select *,
row_number() over(order by reorder_ratio desc) RNK
from 
(select C.department,
A.product_id,
sum(case when reordered=1 then 1 else 0 end)/count(*) reorder_ratio
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
left join instacart.departments C
on B.department_id=C.department_id
group by 1,2) A) A
where RNK <=10;