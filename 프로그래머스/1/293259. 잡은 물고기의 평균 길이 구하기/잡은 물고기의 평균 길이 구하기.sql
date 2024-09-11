-- 코드를 작성해주세요
select round(avg(leng),2) average_length from 
(select 
case when length is null then 10 else length end leng
from fish_info) a
