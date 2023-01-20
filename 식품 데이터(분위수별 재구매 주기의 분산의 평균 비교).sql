# 상품별 재구매율 및 재구매율 순위
select * from(select *,row_number() over(order by ret_ratio desc) RNK
from(select product_id,sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products__prior
group by 1) A) A;

# 재구매율 10분위
create temporary table instacart.product_repurchase_quantile as
select A.product_id,
case when RNK <=929 then 'Q1'
when RNK<=1829 then 'Q2'
when RNK<=2786 then 'Q3'
when RNK<=3715 then 'Q4'
when RNK<=4644 then 'Q5'
when RNK<=5573 then 'Q6'
when RNK<=6502 then 'Q7'
when RNK<=7430 then 'Q8'
when RNK<=8359 then 'Q9'
when RNK<=9288 then 'Q10' end RNK_Q
from(select *,row_number() over(order by ret_ratio desc) RNK
from(select product_id,sum(case when reordered=1 then 1 else 0 end)/count(*) ret_ratio
from instacart.order_products__prior
group by 1) A) A
group by 1,2;

select * from instacart.product_repurchase_quantile;

# 테이블 결합
create temporary table instacart.order_products__prior_2 as
select product_id,
days_since_prior_order
from instacart.order_products__prior A
inner join instacart.orders B
on A.order_id=B.order_id;

-- drop temporary table instacart.order_products__prior_2;

select * from instacart.order_products__prior_2;

# 분위수, 상품별 구매기간 분산 계산
select A.RNK_Q,A.product_id,variance(days_since_prior_order) VAR
from instacart.product_repurchase_quantile A
left join instacart.order_products__prior_2 B
on A.product_id=B.product_id
group by 1,2
order by 1;


# 각 분위 수의 상품 소요 기간 분산의 평균 계산
select RNK_Q,product_id,avg(var_days) avg_var
from (select A.RNK_Q,A.product_id,variance(days_since_prior_order) var_days
from instacart.product_repurchase_quantile A
left join instacart.order_products__prior B
on A.product_id=B.product_id
left join instacart.orders C
on B.order_id=C.order_id
group by 1,2) A
group by 1 order by 1;