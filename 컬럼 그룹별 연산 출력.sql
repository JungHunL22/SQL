# 일 건별 매출액
select A.orderdate,
priceeach*quantityordered total
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber;

# 일자별 매출액 합
select A.orderdate,
sum(priceeach*quantityordered) total
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

# 월별 매출액 substr이용
select substr(A.orderdate,1,7) Month,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

select substr(A.orderdate,1,7) Month,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

select substr(A.orderdate,1,4) year,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

# 고객번호에 중복되는 값이 존재
select orderdate,customernumber,ordernumber
from classicmodels.orders;

# 중복없이 카운트(중복X)
select count(ordernumber) N_orders,
count(distinct ordernumber) N_orders_distinct
from classicmodels.orders;

# 중복없이 카운트(중복O)
select count(customernumber) N_orders,
count(distinct customernumber) N_orders_distinct
from classicmodels.orders;

# 구매자수 및 매출액
select substr(A.orderdate,1,4) YY,
count(distinct A.customernumber) N_purcharse,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;


# 인당 매출액(연도별)
select substr(A.orderdate,1,4) YY,
count(distinct A.customernumber) N_purcharse,
sum(priceeach*quantityordered) SALES,
sum(priceeach*quantityordered)/count(distinct A.customernumber) Avg_SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

# 건당 매출액(연도별)
select substr(A.orderdate,1,4) YY,
count(distinct A.ordernumber) N_purcharse,
sum(priceeach*quantityordered) SALES,
sum(priceeach*quantityordered)/count(distinct A.ordernumber) Avg_SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;
