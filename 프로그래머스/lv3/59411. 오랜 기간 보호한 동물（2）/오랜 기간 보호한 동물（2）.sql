-- 코드를 입력하세요
select animal_id,name
from (SELECT A.animal_id,A.name,datediff(B.datetime,A.datetime) from animal_ins A left join animal_outs B on A.animal_id=B.animal_id order by 3 desc) A
limit 2