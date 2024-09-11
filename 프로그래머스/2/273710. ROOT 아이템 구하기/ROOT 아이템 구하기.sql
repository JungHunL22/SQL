-- 코드를 작성해주세요
select a.item_id,a.item_name from item_info a left join item_tree b on a.item_id=b.item_id
where parent_item_id is null order by a.item_id