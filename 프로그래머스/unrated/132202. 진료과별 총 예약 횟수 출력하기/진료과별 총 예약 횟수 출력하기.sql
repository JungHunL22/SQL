-- 코드를 입력하세요
SELECT MCDP_CD '진료과 코드',count(*) '5월예약건수' from appointment where month(apnt_ymd)=5 group by mcdp_cd order by 2,1