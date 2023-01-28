-- 코드를 입력하세요
SELECT ingredient_type ,sum(total_order) total_order from first_half A left join icecream_info B on A.flavor=B.flavor group by 1 order by 2