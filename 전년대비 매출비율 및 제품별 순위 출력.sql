# A.orderdate 거래년도와 B.orderdate의 거래년도 한 해 전의 테이블 결합
select A.customernumber,A.orderdate,B.customernumber,B.orderdate
from classicmodels.orders A
left join classicmodels.orders B
on A.customernumber=B.customernumber and substr(A.orderdate,1,4)=substr(B.orderdate,1,4)-1;

# 전년대비 거래량 비율
select c.country,
substr(A.orderdate,1,4) YY,
count(distinct A.customernumber) BU_1,
count(distinct B.customernumber) BU_2,
count(distinct B.customernumber)/count(distinct A.customernumber) RETENTION_RATE
from classicmodels.orders A
left join classicmodels.orders B
on A.customernumber=B.customernumber and substr(A.orderdate,1,4)=substr(B.orderdate,1,4)-1
left join classicmodels.customers C
on A.customernumber=C.customernumber
group by 1,2;

# 제품별 판매량 테이블 생성
create table classicmodels.product_sales as
select D.productname,
sum(quantityordered*priceeach) sales
from classicmodels.orders A
left join classicmodels.customers B
on A.customernumber=B.customernumber
left join classicmodels.orderdetails C
on A.ordernumber=C.ordernumber
left join classicmodels.products D
on C.productcode=D.productcode
where B.country='USA'
group by 1;

select * from classicmodels.product_sales;

# 제품별 판매량 top 5 출력(판매량 내림차순)
select *
from (select *, row_number() over(order by sales desc) RNK
from classicmodels.product_sales) A
where RNK<=5
order by RNK;