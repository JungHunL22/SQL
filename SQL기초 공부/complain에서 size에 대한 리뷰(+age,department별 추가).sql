# 리뷰 데이터에서 사이즈에 관한 complain 여부
select 'review text',
case when `review text` like '%size%' then 1 else 0 end Size_YN
from mydata.dataset2;

# 약 30%가 사이즈에 관한 리뷰임
select sum(case when `review text` like '%size%' then 1 else 0 end) Size_N,
count(*) TOTAL,
sum(case when `review text` like '%size%' then 1 else 0 end) / count(*) Prop
from mydata.dataset2;

# 사이즈는 large,loose,small,tight가 존재
# 어떤 사이즈에 complain이 가장 많았는 지 조회
select sum(case when `review text` like '%size%' then 1 else 0 end) Size_N,
sum(case when `review text` like '%large%' then 1 else 0 end) size_Large,
sum(case when `review text` like '%Loose%' then 1 else 0 end) size_Loose,
sum(case when `review text` like '%Small%' then 1 else 0 end) size_Small,
sum(case when `review text` like '%Tight%' then 1 else 0 end) size_Tight
from mydata.dataset2;

# department,size별 complain 총계
# sum(1)과 count(*)은 같은 연산 값을 출력
select `department name`,
sum(case when `review text` like '%size%' then 1 else 0 end) Size_N,
sum(case when `review text` like '%large%' then 1 else 0 end) size_Large,
sum(case when `review text` like '%Loose%' then 1 else 0 end) size_Loose,
sum(case when `review text` like '%Small%' then 1 else 0 end) size_Small,
sum(case when `review text` like '%Tight%' then 1 else 0 end) size_Tight,
sum(1) TOTAL
from mydata.dataset2
group by 1;

# 연령,department별 size에 대한 complain
select floor(age/10)*10 AGEBAND,
`department name`,
sum(case when `review text` like '%size%' then 1 else 0 end) Size_N,
sum(case when `review text` like '%large%' then 1 else 0 end) size_Large,
sum(case when `review text` like '%Loose%' then 1 else 0 end) size_Loose,
sum(case when `review text` like '%Small%' then 1 else 0 end) size_Small,
sum(case when `review text` like '%Tight%' then 1 else 0 end) size_Tight,
sum(1) TOTAL
from mydata.dataset2
group by 1,2
order by 1,2;

# 연령,department별 size에 대한 complain 비중
select floor(age/10)*10 AGEBAND,
`department name`,
sum(case when `review text` like '%size%' then 1 else 0 end)/sum(1)Size_N,
sum(case when `review text` like '%large%' then 1 else 0 end)/sum(1) Large,
sum(case when `review text` like '%Loose%' then 1 else 0 end)/sum(1) Loose,
sum(case when `review text` like '%Small%' then 1 else 0 end)/sum(1) Small,
sum(case when `review text` like '%Tight%' then 1 else 0 end)/sum(1) Tight,
sum(1) TOTAL
from mydata.dataset2
group by 1,2
order by 1,2;