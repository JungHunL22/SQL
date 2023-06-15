select *
from ga.ga_sess_hits;
--order by sess_id,hit_seq;

with temp1 as(
select sess_id,hit_seq,hit_type,page_path,
-- sess_id에서 가장 첫번째 hit_seq에 해당하는 page_path의 값
first_value(page_path) over(partition by sess_id order by hit_seq 
rows between unbounded preceding and current row) landing_page,
last_value(page_path) over(partition by sess_id order by hit_seq 
rows between unbounded preceding and unbounded following) exit_page,
case when row_number() over(partition by sess_id,hit_type order by hit_seq desc)=1 and hit_type='PAGE' 
							then 'True' else '' end is_exit_new,
--case when row_number() over(partition by sess_id order by hit_seq desc)=1 then 'True' else '' end is_exit_new,
exit_screen_name,
is_exit
from ga.ga_sess_hits
)
select *
from temp1
--where is_exit_new !=is_exit
where 'shop.googlemerchandisestore.com'||exit_page != regexp_replace(exit_screen_name, 'shop.|www.', '');