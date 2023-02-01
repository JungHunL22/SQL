-- 코드를 입력하세요
SELECT A.rest_id,rest_name,food_type,
favorites,address,
round(avg(review_score),2) score 
from rest_info A 
left join rest_review B on A.rest_id=B.rest_id 
where address like '서울%'
group by rest_id
having score is not null 
order by 6 desc ,4 desc