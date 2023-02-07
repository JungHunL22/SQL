-- 코드를 입력하세요
select A.flavor from first_half A left join july B on A.flavor=B.flavor group by A.flavor order by sum(A.total_order)+sum(B.total_order) desc limit 3