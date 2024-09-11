-- 코드를 작성해주세요
select a.item_id,item_name,rarity from item_info a left join item_tree b on a.item_id=b.item_id
where parent_item_id in (select item_id from item_info where rarity='rare')
order by a.item_id desc;
