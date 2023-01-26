# Division Name별 평점 평균
select `Division Name`,avg(rating) AVG_RATE
from mydata.dataset2
group by 1 
order by 2 desc;

# Departmend별 평점 평균
select `Department Name`,avg(rating) AVG_RATE
from mydata.dataset2
group by 1 
order by 2 desc;

# Trend 종류 3점 이하 
select *
from mydata.dataset2
where `Department Name`='Trend'
and rating<=3;

# 연령대 생성(case when 함수)
select case when age between 0 and 9 then '0009'
when age between 10 and 19 then '1019'
when age between 20 and 29 then '2029'
when age between 30 and 39 then '3039'
when age between 40 and 49 then '4049'
when age between 50 and 59 then '5059'
when age between 60 and 69 then '6069'
when age between 70 and 79 then '7079'
when age between 80 and 89 then '8089'
when age between 90 and 99 then '9099' end AGEBAND,
age
from mydata.dataset2
where `department name`='trend'
and rating<=3;

# 연령별로 나누기(floor함수 몫으로 계산)
select floor(age/10)*10 AGEBAND,
age
from mydata.dataset2
where `department name`='trend'
and rating <=3;

# 3점 이하 연령별 리뷰개수(floor함수 몫으로 계산)
select floor(age/10)*10 AGEBAND,
count(*) CNT
from mydata.dataset2
where `department name`='trend'
and rating<=3
group by 1
order by 2 desc;

# 50대 3점이하 리뷰 10개
select *
from mydata.dataset2
where `department name` = 'trend'
and rating <=3 and age between 50 and 59 limit 10;