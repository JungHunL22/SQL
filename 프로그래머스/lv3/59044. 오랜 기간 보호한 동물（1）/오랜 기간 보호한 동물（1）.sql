-- 코드를 입력하세요
SELECT A.name,A.datetime from animal_ins A left join animal_outs B on A.animal_id=B.animal_id where B.animal_id is null order by 2 limit 3