# Write your MySQL query statement below
select email from (select email,count(*) cnt from person
group by 1) as b
where cnt>1
;