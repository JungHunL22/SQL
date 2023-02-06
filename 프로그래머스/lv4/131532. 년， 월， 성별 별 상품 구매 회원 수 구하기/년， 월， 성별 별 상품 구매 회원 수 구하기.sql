-- 코드를 입력하세요
SELECT year(sales_date) year,month(sales_date) month,gender,count(distinct B.user_id) users from online_sale A
left join user_info B
on A.user_id=B.user_id
where gender is not null
group by 1,2,3
order by 1,2,3