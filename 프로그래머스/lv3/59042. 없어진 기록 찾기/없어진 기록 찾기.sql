-- 코드를 입력하세요
SELECT A.animal_id,A.name from animal_outs A left join animal_ins B on A.animal_id=B.animal_id 
where B.animal_id is null and A.animal_id is  not null order by 1