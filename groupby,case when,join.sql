# classicmodels.customers와 classics.orders 테이블 결합, ordernumber,country 출력(left join)
select a.ordernumber,b.country
from classicmodels.orders a left join classicmodels.customers b
on a.customerNumber=b.customerNumber;

# classicmodels.customers와 classics.orders 테이블 결합,미국 거주자 ordernumber,country 출력(left join)
select a.ordernumber,b.country
from classicmodels.orders a left join classicmodels.customers b
on a.customernumber = b.customernumber
where b.country = 'usa' ;

# classicmodels.customers와 classics.orders 테이블 결합,미국 거주자 ordernumber,country 출력(inner join)
select a.ordernumber, b.country
from classicmodels.orders a inner join classicmodels.customers b
on a.customerNumber=b.customernumber
where b.country='usa';

# # classicmodels.customers의 country안에서 캐나다와 미국,그 외 구분하여 출력
select country,
case when country in ('usa','canada') then 'north america' else
'others' end as region
from classicmodels.customers;

#   classicmodels.customers의 country안에서 캐나다와 미국,그 외 구분하고, 그룹별 거주 고객수 출력
select case when country in ('usa','canada') then 'north america' else
'others' end as region,
count(customernumber) n_customers
from classicmodels.customers
group by case when country in ('usa','canada') then 'north america' else
'others' end;

# 위와 동일 함(group by 1에서 1은 select의 첫번째 컬럼을 기준으로 그룹화
select case when country in ('usa','canada') then 'north america' else
'others' end as region,count(customernumber) n_customers
from classicmodels.customers
group by 1;