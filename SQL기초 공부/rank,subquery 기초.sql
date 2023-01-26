# buyprice 순으로 랭크 함수를 이용해 순위 출력
select buyprice,row_number() over(order by buyprice) rownumber,
rank() over(order by buyprice) rnk,
dense_rank() over(order by buyprice) denserank
from classicmodels.products;
# rownumber: 랭크 순서대로 인덱스값
# rank : 값이 겹치면 동점 랭크 다음 랭크는 겹친만큼 건너뜀
# dense_rank : 값이 겹쳐도 동점 랭크 다음 랭크는 순서대로 1씩 올라감

# productline별로 buyprice 순으로 랭크함수를 이용해 순위 출력
select buyprice,
row_number() over(partition by productline order by buyprice) rownumber,
rank() over(partition by productline order by buyprice) rnk,
dense_rank() over(partition by productline order by buyprice) denserank
from classicmodels.products;

# subquery
# 서브 쿼리문을 이용해 뉴욕에 거주하는 고객의 ordernumber 출력
select ordernumber
from classicmodels.orders
where customerNumber in (select customerNumber from classicmodels.customers where city='nyc');

# 뉴욕에 사는 고객의 customernumber를 출력(from 과 join에 서브쿼리 이용시에 뒤에 A와 같은 문자열 입력해줘야 함)
# 입력안할 시 에러 -> Error Code: 1248. Every derived table must have its own alias
select customernumber
from (select customernumber from classicmodels.customers where city='nyc') A;

# classicmodels.customers와 classics.orders를 이용해 미국 거주자의 주문번호 출력
select ordernumber
from classicmodels.orders
where customernumber in (select customernumber from classicmodels.customers
where country='usa');

# 위의 서브쿼리에 이용(미국에서 거주하는 고객의 customernumber 출력)
select customernumber from classicmodels.customers
where country='usa';