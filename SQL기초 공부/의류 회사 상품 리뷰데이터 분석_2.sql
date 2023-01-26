# department,clothing별 평점 평균
select `Department Name`, `clothing id`,
avg(rating) AVG_RATE
from mydata.dataset2
group by 1,2;

# department별 순위 생성
select *,row_number() over(partition by `department name` order by avg_rate) RNK
from (select `department name`,`clothing id`,avg(rating) AVG_RATE 
from mydata.dataset2 group by 1,2) A; 

# department별 10위 순위 가져오기
select *
from (select *,row_number() over(partition by `department name` order by avg_rate) RNK
from (select `department name`,`clothing id`,avg(rating) AVG_RATE 
from mydata.dataset2 group by 1,2)A) A
where RNK<=10; 

# temporary table 응용 순위 테이블 생성(session 이 끝나거나 connection 이 종료되었을 때 자동으로 삭제)
create temporary table mydata.stat as
select * from
(select *,row_number() over(partition by `department name` order by avg_rate) RNK
from (select `department name`,`clothing id`,avg(rating) AVG_RATE
from mydata.dataset2
group by 1,2) A) A
where RNK<=10;

# 평점이 낮은 10개 상품의 상품번호 조회
select `clothing id` from mydata.stat
where `department name`='bottoms';

# subquery를 이용해 평점이 낮은 상품의 상품리뷰 출력(파이썬으로 TD-IDF 분석 해보기)
select `clothing id`,`review text` from mydata.dataset2
where `Clothing ID` in (select `clothing id` from mydata.stat where `department name`='bottoms')
order by 1;