select * from ga.temp_funnel_base;

select sess_id,hit_type,action_type,channel_grouping
from ga.temp_funnel_base
where action_type='0';

-- 채널별 action_type 전환 퍼널 세션 수 구하기
-- 채널별로 action_type 0 -> 1 -> 2 -> 3 -> 6 순으로의 전환 퍼널 세션 수를 구함.
with temp_act0 as(
select sess_id,hit_type,action_type,channel_grouping
from ga.temp_funnel_base
where action_type='0'
),
-- action_type 기준 s001 0,1,2/s002 0,1/s003 0일 경우
-- left join이므로 tepm_funnel_base에서 action_type=1인 경우만 조인하면 s003은 사라지는게 아니라 null로 조인되고 s001,s002는 값이 1임.
-- count를 하더라도 null은 계산되지 않음.
temp_hit as (select a.channel_grouping home_cgrp,a.sess_id home_sess_id,b.sess_id plist_sess_id,c.sess_id pdetail_sess_id,
d.sess_id cart_sess_id,e.sess_id check_sess_id,f.sess_id pur_sess_id from temp_act0 a
left join ga.temp_funnel_base b on a.sess_id=b.sess_id and b.action_type='1'
left join ga.temp_funnel_base c on b.sess_id=c.sess_id and c.action_type='2'
left join ga.temp_funnel_base d on c.sess_id=d.sess_id and d.action_type='3'
left join ga.temp_funnel_base e on d.sess_id=e.sess_id and e.action_type='5'
left join ga.temp_funnel_base f on e.sess_id=f.sess_id and f.action_type='6')
select home_cgrp,
count(home_sess_id) as home_sess_cnt,
count(plist_sess_id) as plist_sess_cnt,
count(pdetail_sess_id) as pdetail_sess_cnt,
count(cart_sess_id) as cart_sess_cnt,
count(check_sess_id) as check_sess_cnt,
count(pur_sess_id) as purchase_sess_cnt
from temp_hit
group by home_cgrp