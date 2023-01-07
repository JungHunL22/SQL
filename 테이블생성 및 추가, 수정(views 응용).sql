select ordernumber
from classicmodels.orders
where customernumber in (select customernumber
from classicmodels.customers
where city='NYC');

select customernumber
from (select customernumber
from classicmodels.customers
where city='NYC') A;

select ORDERNUMBER
from classicmodels.orders
where customernumber in (select customernumber
from classicmodels.customers where country='USA');

# 테이블생성
create table example.product(
상품번호 char(10),
카테고리 varchar(10),
색상 varchar(10),
성별 varchar(10),
사이즈 varchar(10),
원가 int
);

# 데이터 추가
insert into example.product(
상품번호,카테고리,색상,성별,사이즈,원가)
values('a001','트레이닝','red','f','xs','30000'),
('a002','라이프스타일','white','m','m','60000');

insert into example.product(상품번호,카테고리,색상,성별,사이즈,원가)
value('a003','트레이닝','purple','f','xs','80000');

# 데이터 행 삭제
delete from example.product
where 원가=80000;

delete from example.product
where 성별='f';

select *
from example.product;


# 데이터 수정
update example.product
set 카테고리='잠옷'
where 원가=60000 or 성별='m';

update example.product
set 원가=원가+20000
where 카테고리='트레이닝';

create table example.procedure(
상품번호 varchar(10),
원가 int,
판매일자 date,
취소여부 char);

insert into example.procedure(상품번호,원가,판매일자,취소여부)
values('13252',100,'2022-1-1','N'),
('13252','100','2020-1-2','Y'),
('36362','300','2022-12-27','N');

select * from example.procedure;

# 원가 수정
update example.procedure
set 원가=-1*원가
where 취소여부='N' and 판매일자='2022-12-27';

# 해당날짜 기준으로 원가 수정(하루가 지났을 때 사용)
update example.procedure
set 원가=-1*원가
where 상품번호='36362' and 판매일자=curdate()-1;

-- DELIMITER $$
-- create procedure sales_minus()
-- begin
-- update example.product
-- set 원가=(-1)*원가
-- where 취소여부='Y'and 판매일자=curdate()-1;
-- end $$
-- DELIMITER ;product


# View 테이블을 직접 생성하지 않고 select 결과를 보여줌
# View의 특징
# 가상 테이블로 실제 테이블과 같은 결과를 보여주지만 실제 데이터를 갖고있지는 않음
# 실제 테이블에 링크된 개념
# 엑세스 제한을 위해 주로 사용

select 상품번호
from example.procedure
where 취소여부='Y';

create VIEW  example.views as select 상품번호,원가
from example.procedure where 취소여부='Y';