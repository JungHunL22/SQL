select * from ga.ga_sess_hits;

with temp1 as(
select sess_id,action_type,count(distinct action_type) from ga.ga_sess_hits
group by 1,2)
select action_type,sum(count)
from temp1
group by 1
order by 1;

/************************************
 전환 퍼널(conversion funnel) 구하기
*************************************/
/* 
   Unknown = 0. (홈페이지)
   Click through of product lists = 1, (상품 목록 선택)
   Product detail views = 2, (상품 상세 선택)
   Add product(s) to cart = 3, (카트에 상품 추가)
   Remove product(s) from cart = 4, (카트에서 상품 제거)
   Check out = 5, (결재 시작)
   Completed purchase = 6, (구매 완료)
   Refund of purchase = 7, (환불)
   Checkout options = 8 (결재 옵션 선택)
   
   이 중 1, 3, 4가 주로 EVENT로 발생. 0, 2, 5, 6은 주로 PAGE로 발생.
   전환 퍼널 계산에 쓰이는 action_type은 0,1,2,3,5,6(홈,상품선택,상세선택,카트추가,결제시작,결제완료) 
 *
 **/

select a.sess_id,action_type,hit_seq,row_number() over (partition by a.sess_id, action_type order by hit_seq) as action_seq 
from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id
where a.sess_id = 'S0213506'
order by 3;


-- 1주일간 세션 히트 데이터에서 세션별로 action_type의 중복 hit를 제거하고 세션별 고유한 action_type만 추출
drop table if exists ga.temp_funnel_base;

create table ga.temp_funnel_base
as
select * 
from (
	select a.*, b.visit_stime, b.channel_grouping 
		, row_number() over (partition by a.sess_id, action_type order by hit_seq) as action_seq
	from ga.ga_sess_hits a
		join ga.ga_sess b on a.sess_id = b.sess_id
	where visit_stime >= (to_date('2016-10-31', 'yyyy-mm-dd') - interval '7 days') and visit_stime < to_date('2016-10-31', 'yyyy-mm-dd')
	) a where a.action_seq = 1
;

select * from ga.temp_funnel_base
order by sess_id;

-- count()를 사용해서 각 퍼널별로 null이아닌 값만 sess_id를 세면 퍼널 전환 유저가 계산됨.
with 
temp_act_0 as ( 
select sess_id, hit_type, action_type
from ga.temp_funnel_base a
where a.action_type = '0'
), 
temp_hit_02 as ( 
select a.sess_id as home_sess_id
	, b.sess_id as plist_sess_id
	, c.sess_id as pdetail_sess_id
	, d.sess_id as cart_sess_id
	, e.sess_id as check_sess_id
	, f.sess_id as pur_sess_id
from temp_act_0 a
	left join ga.temp_funnel_base b on (a.sess_id = b.sess_id and b.action_type = '1')
	left join ga.temp_funnel_base c on (b.sess_id = c.sess_id and c.action_type = '2')
	left join ga.temp_funnel_base d on (c.sess_id = d.sess_id and d.action_type = '3')
	left join ga.temp_funnel_base e on (d.sess_id = e.sess_id and e.action_type = '5')
	left join ga.temp_funnel_base f on (e.sess_id = f.sess_id and f.action_type = '6')
)
select * from temp_hit_02;

-- action_type 전환 퍼널 세션 수 구하기(FLOW를 순차적으로 수행한 전환 퍼널)
-- action_type 0 -> 1 -> 2 -> 3 -> 5 -> 6 순으로의 전환 퍼널 세션 수를 구함.  
with 
temp_act_0 as ( 
select sess_id, hit_type, action_type
from ga.temp_funnel_base a
where a.action_type = '0'
), 
temp_hit_02 as ( 
select a.sess_id as home_sess_id
	, b.sess_id as plist_sess_id
	, c.sess_id as pdetail_sess_id
	, d.sess_id as cart_sess_id
	, e.sess_id as check_sess_id
	, f.sess_id as pur_sess_id
from temp_act_0 a
	left join ga.temp_funnel_base b on (a.sess_id = b.sess_id and b.action_type = '1')
	left join ga.temp_funnel_base c on (b.sess_id = c.sess_id and c.action_type = '2')
	left join ga.temp_funnel_base d on (c.sess_id = d.sess_id and d.action_type = '3')
	left join ga.temp_funnel_base e on (d.sess_id = e.sess_id and e.action_type = '5')
	left join ga.temp_funnel_base f on (e.sess_id = f.sess_id and f.action_type = '6')
)
select count(home_sess_id) as home_sess_cnt
	, count(plist_sess_id) as plist_sess_cnt
	, count(pdetail_sess_id) as pdetail_sess_cnt
	, count(cart_sess_id) as cart_sess_cnt
	, count(check_sess_id) as check_sess_cnt
	, count(pur_sess_id) as purchase_sess_cnt
from temp_hit_02
;

-- action_type 전환 퍼널 세션 수 구하기(FLOW를 스킵한 세션까지 포함한 전환 퍼널)
with
temp_01 as (
select count(sess_id) as home_sess_cnt
from temp_funnel_base
where action_type = '0'
),
temp_02 as (
select count(sess_id) as plist_sess_cnt
from temp_funnel_base
where action_type = '1'
),
temp_03 as (
select count(sess_id) as pdetail_sess_cnt
from temp_funnel_base
where action_type = '2'
),
temp_04 as (
select count(sess_id) as cart_sess_cnt
from temp_funnel_base
where action_type = '3'
),
temp_05 as (
select count(sess_id) as check_sess_cnt
from temp_funnel_base
where action_type = '5'
),
temp_06 as (
select count(sess_id) as purchase_sess_cnt
from temp_funnel_base
where action_type = '6'
)
select home_sess_cnt, plist_sess_cnt, pdetail_sess_cnt
	, cart_sess_cnt, check_sess_cnt, purchase_sess_cnt
from temp_01
	cross join temp_02
	cross join temp_03
	cross join temp_04
	cross join temp_05
	cross join temp_06
;