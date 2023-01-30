-- 코드를 입력하세요
SELECT category,sum(sales) total_sales from book A left join book_sales B on A.book_id=B.book_id where date_format(sales_date,'%Y-%m')='2022-01' group by 1 order by 1