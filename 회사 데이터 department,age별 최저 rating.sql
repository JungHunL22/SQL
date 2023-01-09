# 연령별 가장 낮은 점수를 준 department를 구하기
# 1. 연령,department별 낮은 점수 계산
# 2. 생성한 점수를 기반으로 rank함수 연산
# 3. rank가 1인 데이터 조회

select `department name`,floor(age/10)*10 AGEBAND,
avg(Rating) AVG_RT
from mydata.dataset2
group by 1, 2;

# 연령대별 점수 순위 테이블
select *,row_number() over(partition by AGEBAND order by AVG_RT) RNK
from (select `department name`,floor(age/10)*10 AGEBAND,
avg(Rating) AVG_RT
from mydata.dataset2
group by 1, 2)A;

# 부서별 가장 낮은 점수를 준 연령대
select *
from (select *,row_number() over(partition by AGEBAND order by AVG_RT) RNK
from (select `department name`,floor(age/10)*10 AGEBAND,
avg(Rating) AVG_RT
from mydata.dataset2
group by 1, 2) A) A
where RNK=1;