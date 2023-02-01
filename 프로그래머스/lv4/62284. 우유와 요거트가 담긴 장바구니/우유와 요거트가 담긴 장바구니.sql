-- 코드를 입력하세요
select cart_id from cart_products where name='yogurt' and cart_id in (select cart_id from cart_products where name='milk')group by cart_id order by 1