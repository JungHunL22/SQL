-- 코드를 입력하세요
select A.member_name,review_text,date_format(B.review_date,'%Y-%m-%d') from member_profile A left join rest_review B on A.member_id=B.member_id where A.member_id = (select member_id from rest_review group by member_id order by count(1) desc limit 1) order by 3,2

