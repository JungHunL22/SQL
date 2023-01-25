-- 코드를 입력하세요
SELECT product_code,sum(price*sales_amount) sales from offline_sale A left join product B on A.product_id=B.product_id group by 1 order by 2 desc ,1