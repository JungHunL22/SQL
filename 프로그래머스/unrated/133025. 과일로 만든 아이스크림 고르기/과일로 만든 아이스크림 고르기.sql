-- 코드를 입력하세요
SELECT a.FLAVOR from first_half A left join icecream_info B on A.flavor=B.flavor where total_order>3000 AND ingredient_type='fruit_based'