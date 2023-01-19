# 10분위 계산
select *,row_number() over(order by F desc) RNK
from(select user_id,count(distinct order_id) F
from instacart.orders group by 1)A;

# 전체 고객수 3159명
select count(distinct user_id)
from(select user_id,count(distinct order_id) F
from instacart.orders group by 1)A;

# 랭크순으로 분위수 계산
select *,case when RNK between 1 and 316 then 'Quantile_1'
when RNK between 317 and 6326 then 'Quantile_2'
when RNK between 633 and 948 then 'Quantile_3'
when RNK between 949 and 1264 then 'Quantile_4'
when RNK between 1265 and 1580 then 'Quantile_5'
when RNK between 1581 and 1895 then 'Quantile_6'
when RNK between 1896 and 2211 then 'Quantile_7'
when RNK between 2212 and 2527 then 'Quantile_8'
when RNK between 2528 and 2843 then 'Quantile_9'
when RNK between 2844 and 3159 then 'Quantile_10' end Quantile
from(select *,row_number() over(order by F desc) RNK
from(select user_id,count(distinct order_id) F
from instacart.orders group by 1)A)A;

create table instacart.User_Quantile as
select *,case when RNK between 1 and 316 then 'Quantile_1'
when RNK between 317 and 632 then 'Quantile_2'
when RNK between 633 and 948 then 'Quantile_3'
when RNK between 949 and 1264 then 'Quantile_4'
when RNK between 1265 and 1580 then 'Quantile_5'
when RNK between 1581 and 1895 then 'Quantile_6'
when RNK between 1896 and 2211 then 'Quantile_7'
when RNK between 2212 and 2527 then 'Quantile_8'
when RNK between 2528 and 2843 then 'Quantile_9'
when RNK between 2844 and 3159 then 'Quantile_10' end Quantile
from(select *,row_number() over(order by F desc) RNK
from(select user_id,count(distinct order_id) F
from instacart.orders group by 1)A)A;

select quantile,sum(F) F
from instacart.user_quantile
group by 1;

# 전체 주문 건수
select sum(f) from instacart.user_quantile;

# 주문건수 별 분위 수 조회
# 주문건수 별 분위가 고르게 분포되어 있음
select quantile,sum(F)/3220
from instacart.user_quantile
group by 1;

# 상품 분석
# 재구매 비중 계산
select product_id,sum(reordered)/sum(1) reorder_rate,count(distinct order_id) od_id
from instacart.order_products__prior
group by 1
order by 2 desc;

# where문은 from에 위치한 테이블에만 조건을 설정 가능
# 이 구문에서 where 사용 불가능함
select A.product_id,sum(reordered)/sum(1) reorder_rate,count(distinct order_id) od_id
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
group by 1
where count(distinct order_id) >10;

# having은 조인한 테이블에도 조건을 설정 가능함(새롭게 생성된 컬럼에서도 사용 가능)
select A.product_id,sum(reordered)/sum(1) reorder_rate,count(distinct order_id) od_id
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
group by 1
having count(distinct order_id) >10;

# 주문건수 10건 이상 상품 조회
select A.product_id,B.product_name
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
group by 1,B.product_name
having count(distinct order_id) >10;

# 주문건수 10건 이상 상품 재구매율 조회
select A.product_id,B.product_name,sum(reordered)/sum(1) reorder_rate,count(distinct order_id) od_id
from instacart.order_products__prior A
left join instacart.products B
on A.product_id=B.product_id
group by 1,B.product_name
having count(distinct order_id) >10;