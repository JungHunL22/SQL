-- 코드를 입력하세요
SELECT date_format(sales_date,'%Y-%m-%d') sales_date,product_id,user_id,sales_amount from online_sale 
where month(sales_date)=3 union all select sales_date,product_id,null as user_id, sales_amount 
from offline_sale where month(sales_date)=3
order by sales_date,product_id,user_id
                   
# SELECT DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE, PRODUCT_ID,USER_ID,SALES_AMOUNT  FROM ONLINE_SALE
                  
# WHERE SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'
# UNION ALL
# SELECT SALES_DATE, PRODUCT_ID, NULL AS USER_ID, SALES_AMOUNT  FROM OFFLINE_SALE
# WHERE SALES_DATE BETWEEN '2022-03-01' AND '2022-03-31'
# ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC;