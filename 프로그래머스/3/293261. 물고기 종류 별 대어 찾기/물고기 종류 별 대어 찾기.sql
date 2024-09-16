-- 코드를 작성해주세요
select id,fish_name,length 
from (select *,row_number() over(partition by fish_type order by length desc) rnk from fish_info) a 
left join fish_name_info b on a.fish_type=b.fish_type
where rnk=1
order by id
