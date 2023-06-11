-- 채널 리포트 개요
select * from ga.ga_sess;

select traffic_medium,traffic_source,count(*)
from ga.ga_sess
group by 1,2
order by 1,2;

select channel_grouping,traffic_medium,traffic_source,traffic_source,count(*)
from ga.ga_sess
group by 1,2,3
order by 1,2,3;


/************************************
채널별로 MAU를 신규 사용자, 기존 사용자로 나누고, 채널별 비율까지 함께 계산. 
*************************************/
select channel_grouping,count(distinct user_id)
from ga.ga_sess
group by 1;

with temp1 as(
select a.sess_id,a.user_id,a.visit_stime,b.create_time,channel_grouping
,case when b.create_time >= (:current_date - interval '30 days' ) and b.create_time < :current_date then 1
else 0 end as is_new_user
from ga.ga_sess a join ga.ga_users b on a.user_id=b.user_id
where visit_stime>=(:current_date - interval'30 days') and visit_stime < :current_date 
),
temp2 as (
-- distinct를 쓸때는 count 바로 뒤에 넣어야 함.
-- group by에 rollup(channel_grouping)을 넣으면 마지막줄에 합계가 계싼
select channel_grouping,
count(distinct case when is_new_user=1 then user_id end) as new_user_cnt,
count(distinct case when is_new_user=0 then user_id end) as repeat_user_cnt,
count(distinct user_id) channel_user_cnt,
count(*) as sess_cnt
from temp1
group by channel_grouping
)
select channel_grouping,new_user_cnt,repeat_user_cnt,channel_user_cnt,sess_cnt,
round(100.0*new_user_cnt/sum(new_user_cnt) over (),2) new_user_cnt_by_channel,
round(100.0*repeat_user_cnt/sum(repeat_user_cnt) over (),2) repeat_user_cnt_by_channel
from temp2;
-------------------------------------------------------------------------------------
