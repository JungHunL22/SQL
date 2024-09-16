-- 코드를 작성해주세요
select count(*) fish_count,fish_name from fish_info a left join fish_name_info b on a.fish_type=b.fish_type
group by 2
order by 1 desc;