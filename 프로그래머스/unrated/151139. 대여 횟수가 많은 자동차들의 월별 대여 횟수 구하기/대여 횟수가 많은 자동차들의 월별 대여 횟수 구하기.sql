-- 코드를 입력하세요
select month(start_date) month,car_id, count(*) records from car_rental_company_rental_history 
where car_id in (select car_id from car_rental_company_rental_history where month(start_date) between 8 and 10 group by car_id having count(*)>=5) and month(start_date) between 8 and 10 group by 1,2 order by 1,2 desc

# SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(*) AS RECORDS
# FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
# WHERE CAR_ID IN (
#     SELECT CAR_ID
#     FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
#     WHERE START_DATE >= '2022-08-01' AND START_DATE < '2022-11-01'
#     GROUP BY CAR_ID
#     HAVING COUNT(*) >= 5
# ) AND START_DATE >= '2022-08-01' AND START_DATE < '2022-11-01'
# GROUP BY CAR_ID, MONTH(START_DATE)
# ORDER BY MONTH ASC, CAR_ID DESC