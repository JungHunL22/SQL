-- 코드를 입력하세요
select concat('/home/grep/src/',board_id,'/',file_id,file_name,file_ext) FILE_PATH from used_goods_file where board_id in (select board_id from(select board_id,rank() over(order by views desc) as rankk from used_goods_board)A where A.rankk=1) order by file_id desc
