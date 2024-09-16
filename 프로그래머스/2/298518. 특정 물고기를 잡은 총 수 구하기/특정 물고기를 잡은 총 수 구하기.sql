-- 코드를 작성해주세요
select count(*) fish_count from fish_info a left join fish_name_info b on a.fish_type=b.fish_type
where fish_name in ('bass','snapper')