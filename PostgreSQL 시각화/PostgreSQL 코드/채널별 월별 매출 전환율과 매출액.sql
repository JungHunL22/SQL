/************************************
채널별 월별 매출 전환율과 매출액
*************************************/
with temp1 as(
select b.channel_grouping,date_trunc('month',visit_stime)::date cv_month,
count(distinct a.sess_id ) sess_cnt,
count(distinct case when a.action_type='6' then a.sess_id end) pur_sess_cnt
from ga.ga_sess_hits a
join ga.ga_sess b on a.sess_id=b.sess_id
group by b.channel_grouping,date_trunc('month',visit_stime)::date
),
temp2 as(
select a.channel_grouping,date_trunc('month',b.order_time)::date ord_month,
sum(prod_revenue) as sum_revenue
from ga.ga_sess a
join ga.orders b on a.sess_id=b.sess_id
join ga.order_items c on b.order_id=c.order_id
group by a.channel_grouping,date_trunc('month',b.order_time)::date
)
select a.channel_grouping,a.cv_month,a.pur_sess_cnt,a.sess_cnt,
round(100.0*pur_sess_cnt/sess_cnt,2) sale_cv_rate,
b.ord_month,round(sum_revenue::numeric,2) sum_revenue
,round(100.0*sum_revenue::numeric/pur_sess_cnt,2) rev_per_pur_sess
from temp1 a
left join temp2 b
on a.channel_grouping=b.channel_grouping and a.cv_month=b.ord_month
order by 1,2;

