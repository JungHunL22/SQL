# 국가별,상품코드별 구매자수 및 총판매액
select country,stockcode,count(distinct customerid) BU,sum(quantity*unitprice) SALES 
from mydata.dataset3 group by 1,2 order by 3 desc,4 desc;

# 특정 상품 구매자가 많이 구매한 상품
# 1) 가장 많이 판매된 2개 상품
select stockcode,sum(quantity) TOTAL from mydata.dataset3
group by 1;

select StockCode from (select *,row_number() over(order by TOTAL desc) RNK from (select stockcode,sum(quantity) TOTAL from mydata.dataset3
group by 1)A)B where RNK<=2;

# 상위 2개 상품을 구매한 구매자들의 다른 구매 상품
# 상위 2개(84077,85123A) 상품을 구매한 고객아이디 테이블 생성
create table mydata.LIST as
select customerid from mydata.dataset3
group by 1
having max(case when StockCode='84077' then 1 else 0 end)=1 and max(case when stockcode='85123A' then 1 else 0 end)=1;

select * from mydata.LIST;

# 생성한 테이블을 이용해 해당 고객아이디가 구매한 다른 상품 조회 
select distinct stockcode from mydata.dataset3
where StockCode not in ('84077','85123A') and CustomerID in (select * from mydata.LIST);

