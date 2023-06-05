/************************************
MAU를 신규 사용자, 기존 사용자(재 방문) 건수로 분리하여 추출(세션 건수도 함께 추출)
*************************************/
select * from ga.ga_users;

with temp1 as(
select a.sess_id,a.user_id,a.visit_stime,b.create_time
,case when b.create_time >= (:current_date - interval '30 days' ) and b.create_time < :current_date then 1
else 0 end as is_new_user
from ga.ga_sess a join ga.ga_users b on a.user_id=b.user_id
where visit_stime>=(:current_date - interval'30 days') and visit_stime < :current_date 
)
select is_new_user,count(distinct *) from temp1 group by is_new_user;

with temp1 as(
select a.sess_id,a.user_id,a.visit_stime,b.create_time
,case when b.create_time >= (:current_date - interval '30 days' ) and b.create_time < :current_date then 1
else 0 end as is_new_user
from ga.ga_sess a join ga.ga_users b on a.user_id=b.user_id
where visit_stime>=(:current_date - interval'30 days') and visit_stime < :current_date 
)
-- distinct를 쓸때는 count 바로 뒤에 넣어야 함.
select count(distinct user_id) as user_cnt,
count(distinct case when is_new_user=1 then user_id end) as new_usr_cnt,
count(distinct case when is_new_user=0 then user_id end) as repeat_usr_cnt,
count(*) as sess_cnt
from temp1;



/************************************
채널별로 MAU를 신규 사용자, 기존 사용자로 나누고, 채널별 비율까지 함께 계산. 
*************************************/