-- 코드를 입력하세요
select category,price max_price,product_name from food_product where (category,price) in (select category,max(price) price from food_product where category in ('과자','국','김치','식용유') group by 1) order by price desc