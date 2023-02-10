-- 코드를 입력하세요
SELECT A.author_id,B.author_name,A.category,sum(A.price*C.sales) total_sales from book A inner join author B on A.author_id=B.author_id inner join book_sales C on A.book_id=C.book_id where date_format(sales_date,'%Y-%m')='2022-01' group by 1,3 order by 1,3 desc

