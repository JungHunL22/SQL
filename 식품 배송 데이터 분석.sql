# 주문건수
select count(distinct order_id) order_n
from instacart.orders;

#고객수
select count(distinct user_id) User_n
from instacart.orders;

# 상품별 주문 건수
# 1. 테이블 조인
select *
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id;

# 2. group & count
select B.product_name,count(distinct A.order_id) F
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
group by 1;

# 장바구니에 먼저 넣는 상품 상위 10개(add_to_cart_order 이용)

# 1. 가장 먼저 넣는 상품은 1출력
select product_id,case when add_to_cart_order=1 then 1 else 0 end 1st
from instacart.order_products__prior;

# 2. 가장 먼저 넣은 상품 그룹핑
select product_id,case when add_to_cart_order=1 then 1 else 0 end 1st
from instacart.order_products__prior
group by 1;

# 3. 가장 먼저 넣은 상품별 합계
select product_id,sum(case when add_to_cart_order=1 then 1 else 0 end) 1st_total
from instacart.order_products__prior
group by 1;

# 3. 장바구니 담긴 건수대로 순위 10위까지 출력
select*
from(
select *,row_number() over(order by 1st_total desc) RNK
from(select product_id,sum(case when add_to_cart_order=1 then 1 else 0 end) 1st_total
from instacart.order_products__prior
group by 1) A) B
where RNK<=10;

select product_id,sum(case when add_to_cart_order=1 then 1 else 0 end) 1st_total
from instacart.order_products__prior
group by 1
order by 2 desc limit 10;

