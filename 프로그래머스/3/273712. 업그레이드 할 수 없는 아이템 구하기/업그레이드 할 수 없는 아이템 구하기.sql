-- 코드를 작성해주세요
select a.item_id,a.item_name,a.rarity from item_info a left join item_tree b on a.item_id=b.item_id
where a.item_id not in (select parent_item_id from item_tree where parent_item_id is not null)
order by item_id desc;
# parent_item_i에 존재하는 애들을 제외한 나머지 item_id 추출
