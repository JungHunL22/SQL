-- 코드를 입력하세요
SELECT history_id,car_id,substr(start_date,1,10) START_DATE,substr(end_date,1,10) END_DATE,case when datediff(end_date,start_date)+1>=30 then '장기 대여' else '단기 대여' end RENT_TYPE from car_rental_company_rental_history
where substr(start_date,6,2)=09
order by history_id desc
# select * from car_rental_company_rental_history