-- 코드를 입력하세요
select food_type,rest_id,rest_name,favorites from(select *,row_number() over(partition by food_type order by favorites desc) RNK from rest_info)A where RNK=1 order by 1 desc