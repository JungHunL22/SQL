select A.orderdate, priceeach*quantityordered
from classicmodels.orders A 
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber;

select A.orderdate, sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber
group by 1
order by 1;

select substr(A.orderdate,1,7) MM,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber
group by 1
order by 1;

select substr(A.orderdate,1,4) MM,
sum(priceeach*quantityordered) SALES
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
group by 1
order by 1;

select orderdate,customernumber,ordernumber
from classicmodels.orders;

# ORDERNUMBER는 레코드수가 326이고, 중복없이 카운트했을 때도 326이므로 겹치는 번호가 존재하지 않음
select count(ordernumber) N_ORDERS,
COUNT(DISTINCT ORDERNUMBER) N_ORDERS_DISTINCT
FROM classicmodels.ORDERS;

# CUSTOMERNUMBER는 레코드수가 326이고, 중복없이 카운트했을 때 98이므로 겹치는 번호가 존재
select count(customerNUMBER) N_ORDERS,
COUNT(DISTINCT CUSTOMERNUMBER) N_ORDERS_DISTINCT
FROM classicmodels.ORDERS;

SELECT ORDERDATE,
COUNT(DISTINCT CUSTOMERNUMBER) N_PURCHASER,
COUNT(ORDERNUMBER) N_ORDERS
FROM CLASSICMODELS.ORDERS
group by 1
ORDER BY 1;


select substr(orderdate,1,4) YY,
count(distinct A.customernumber) N_PURCHASER,
SUM(PRICEEACH*QUANTITYORDERED) SALESorderdetailsorderdetails
FROM CLASSICMODELS.ORDERS A
LEFT JOIN CLASSICMODELS.ORDERDETAILS B
ON A.ORDERNUMBER=B.ORDERNUMBER
GROUP BY 1
ORDER BY 1;