# 3개 테이블 조합(국가별,도시별 매출액 연산)
select *
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
left join classicmodels.customers C
on A.customernumber=C.customernumber;

# 3개 테이블 조합해 매출액 구하기
select country, city, priceeach*quantityordered Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.ordernumber
left join classicmodels.customers C
on A.customernumber=C.customernumber;

# 국가,도시별 매출액
select C.country,C.city,sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.orderNumber
left join classicmodels.customers C
on A.customerNumber=C.customerNumber
group by 1,2;

# 국가,도시별 매출액(국가,도시순 정렬)
select C.country,C.city,sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.orderNumber
left join classicmodels.customers C
on A.customernumber=C.customerNumber
group by 1,2
order by 1,2;

# 대륙별 구분
select case when country in ('canada','usa') then 'North America'
else 'others' end country_group
from classicmodels.customers;

# 국가,도시별 매출액(내림차순)
select C.country,C.city,sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.ordernumber=B.orderNumber
left join classicmodels.customers C
on A.customernumber=C.customerNumber
group by 1,2
order by 3 desc;

# 대륙별 매출액
select case when country in ('usa','canada') then 'North America'
else 'others' end country_grp,
sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber
left join classicmodels.customers C
on A.customernumber=C.customerNumber
group by 1
order by 2 desc;

# 매출 상위 5개국 생성
create table classicmodels.stat as
select C.country,
sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber
left join classicmodels.customers C
on A.customerNumber=C.customerNumber
group by 1
order by 2 desc;

select * from classicmodels.stat;

# 테이블 직접 생성 방식
# dense_rank는 동점인 등수 이후에도 연속으로 바로 다음 등수를 매김
# rank는 동점인 등수 이후에는 동점수만큼 순위 제외하고 등수매김
# row_number는 동점이 존재하더라도 무조건 다른 등수를 매김
select *,
dense_rank() over(order by Sales desc) DENSE_RNK,
rank() over(order by Sales desc) RNK,
row_number() over(order by Sales desc) ROW_NUMBERs
from classicmodels.stat;

# 매출액 순위 테이블 생성
create table classicmodels.stat_RNK as
select country,Sales,
dense_rank() over(order by Sales desc) RNK
from classicmodels.stat;

select * from classicmodels.stat_RNK;

# 상위 5개국 출력(create table 방식)
select * from classicmodels.stat_RNK
where RNK between 1 and 5;


# 상위 5개국 출력(서브쿼리방식)
select *
from
(select country,Sales,dense_rank() over(order by Sales desc) RNK
from
(select C.country,
sum(priceeach*quantityordered) Sales
from classicmodels.orders A
left join classicmodels.orderdetails B
on A.orderNumber=B.orderNumber
left join classicmodels.customers C
on A.customerNumber=C.customerNumber
group by 1) A) A
where RNK<=5;