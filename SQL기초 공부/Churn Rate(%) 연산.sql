# Churn Rate(%) : 특정 날짜로 부터 일정기간동안 접속or구매하지 않은 경과일
# 고객별 마지막 주문날짜
select customernumber,max(orderdate) MX_order
from classicmodels.orders
group by 1;

# 고객별 2005-06-01 기준 마지막 주문날짜 경과일
# datediff(d1,d2) d2와 d1의 날짜차이 계산
select customernumber,MX_order,'2005-06-01',datediff('2005-06-01',MX_order) DIFF
from (select customernumber,max(orderdate) MX_order from classicmodels.orders group by 1) BASE;

# 마지막 주문경과일이 90이상이면 churn 아니면 non_churn
select *,case when diff >= 90 then 'churn' else 'non-order' end churn_type
from (select customernumber,MX_order,'2005-06-01' END_point,
datediff('2005-06-01',MX_order) DIFF
from (select customernumber,max(orderdate) MX_order
from classicmodels.orders
group by 1) BASE)BASE;

# churn 고객이 가장 많이 구매한 상품
create table classicmodels.churn_list as
select case when DIFF >= 90 then 'CHURN' else 'NON_CHURN' end CHURN_TYPE,
customernumber
from (select customernumber,MX_order,'2005-06-01' END_point,
datediff('2005-06-01',MX_order) DIFF
from (select customernumber,MAX(orderdate) MX_order
from classicmodels.orders
group by 1) BASE) BASE;

# 고객별  churn 여부
select * from classicmodels.churn_list;

#
select C.productline,count(distinct B.customernumber) BU
from classicmodels.orderdetails A
left join classicmodels.orders B
on A.orderNumber=B.orderNumber
left join classicmodels.products C
on A.productCode=C.productCode
group by 1;

# Churn 여부,상품라인 별 구매자수
select D.churn_type,C.productline,count(distinct B.customernumber) BU
from classicmodels.orderdetails A
left join classicmodels.orders B
on A.ordernumber=B.ordernumber
left join classicmodels.products C
on A.productCode=C.productCode
left join classicmodels.churn_list D
on B.customernumber=D.customernumber
group by 1,2
order by 1,2,3 desc;