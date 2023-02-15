# 1. 재구매 고객 조회(max_yy가 1이면 재구매X, 2 이상이면 재구매 고객)
# 상품,연도별 구매건수  우선 조회
select customerid,stockcode,count(distinct substr(invoiceDate,1,4)) cnt_y
from mydata.dataset3 group by 1,2;

# max_yy가 1이면 재구매X, 2 이상이면 재구매 고객
select customerid,max(cnt_y) max_yy
from (select customerid,stockcode,count(distinct substr(invoiceDate,1,4)) cnt_y
from mydata.dataset3 group by 1,2)a group by 1;

# 임시 테이블 생성(위테이블)
CREATE TEMPORARY TABLE  mydata.repurchase
select customerid,max(cnt_y) max_yy
from (select customerid,stockcode,count(distinct substr(invoiceDate,1,4)) cnt_y
from mydata.dataset3 group by 1,2)a group by 1;

# 재구매인 경우 1, 재구매가 아닌 경우 0으로 새로운 컬럼 생성
select customerid,case when max_yy>=2 then 1 else 0 end repurchas_yn
from mydata.repurchase;

# 2. 일자별 첫 구매 고객수
# 고객들의 첫 구매일자 우선 조회
select customerid,min(invoicedate) Min_date from mydata.dataset3 group by 1;

# 위 테이블로 일자별 첫 구매 고객수 조회
select customerid,count(*) First_purchase 
from (select customerid,min(invoicedate) Min_date from mydata.dataset3 group by 1)A group by Min_date;

# 3. 상품별 첫 구매 고객수
# 고객별,상품별 첫 구매일자 우선 조회
select customerid,stockcode,min(invoicedate) Min_date from mydata.dataset3 group by 1,2; 

# 위 테이블을 이용해 고객별 첫 구매일자 순위 생성
select * , row_number() over(partition by customerid order by Min_date) RNK_Date 
from (select customerid,stockcode,min(invoicedate) Min_date from mydata.dataset3 group by 1,2)A;

-- drop temporary table mydata.RNK_date;
# 임시 테이블 생성
create temporary table mydata.RNK_Date
select * , row_number() over(partition by customerid order by Min_date) RNK_Date 
from (select customerid,stockcode,min(invoicedate) Min_date from mydata.dataset3 group by 1,2)A;

# 각 상품별 RNK_date가 1인 데이터만 조회
select * from mydata.RNK_date where RNK_date=1;

# 상품별 첫 구매고객수 count
select stockcode,count(customerid) cnt_stock 
from (select * from mydata.RNK_date where RNK_date=1)A group by 1 order by 2 desc;