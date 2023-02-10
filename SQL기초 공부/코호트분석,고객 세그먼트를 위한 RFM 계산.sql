# Retention Rate = 일정기간동안 제품을 지속적으로 사용하는 고객비율
select A.country,substr(A.invoicedate,1,4) YY,count(distinct B.customerid)/count(distinct A.customerid) RT_R
from (select * from mydata.dataset3) A left join (select * from mydata.dataset3) B
on substr(A.invoicedate,1,4) = substr(B.invoicedate,1,4)-1
and A.country=B.country and A.customerid=B.customerid
group by 1,2 order by 1,2;

# 코호트 분석 = 시간의 흐름에 따른 고객의 구매패턴 및 행동패턴 파악하는 분석

# 고객별 첫 구매일 및 구매액 조회
select customerid,min(invoicedate) MN,round(Quantity*unitprice) SALES from mydata.dataset3 group by 1;

select * from (select customerid,min(invoicedate) MN from mydata.dataset3 group by 1 )A
left join (select customerid,invoicedate,round(Quantity*unitprice,2) SALES from mydata.dataset3) B on A.customerid=B.customerid ;

select substr(MN,1,7),timestampdiff(month,MN,invoicedate) DATEDIFF,count(distinct A.customerid) cust_n,round(sum(sales),2) TOTAL
from (select customerid,min(invoicedate) MN 
from mydata.dataset3 
group by 1 )A
left join (select customerid,invoicedate,round(Quantity*unitprice,2) SALES 
from mydata.dataset3) B on A.customerid=B.customerid
group by 1,2;

# 고객세그먼트
# RFM (Recency,Frequency,Monetary)
# R-가장 최근 구매일자, F-구매 빈도, M-구매 총액

# 가장최근 구매일자 조회
select customerid,max(invoicedate) MX from mydata.dataset3
group by 1 order by 2 desc;

# 전체 구매일자 중 2011-12-01이 마지막 구매일자이므로 2011-12-02일자 기준으로 최근 구매일 조회
select customerid,datediff('2011-12-02',MX) R from (select customerid,max(invoicedate) MX from mydata.dataset3
group by 1) A ;

# 구매빈도와 구매액 조회
select customerid,count(distinct invoicedate) F,sum(quantity*unitprice) M from mydata.dataset3 group by 1 order by 1;

# RFM 테이블 조회
# LTV,Retention_Rate,RFM 등을 계산해 군집화를 통해 고객 세그먼트 진행 가능
select customerid,datediff('2011-12-02',MX) Recency,Frequancy,Monetary from (select customerid,max(InvoiceDate) MX,count(distinct invoicedate) Frequancy,sum(unitprice*quantity) Monetary
from mydata.dataset3 group by 1) A;

