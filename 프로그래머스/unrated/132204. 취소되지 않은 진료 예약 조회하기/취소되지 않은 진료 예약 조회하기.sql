-- 코드를 입력하세요
SELECT APNT_NO,PT_NAME,A.PT_NO,A.MCDP_CD,DR_NAME,A.APNT_YMD from appointment A left join patient B on A.pt_no=B.pt_no left join doctor C on A.mddr_id=C.dr_id where date_format(A.apnt_ymd,'%Y-%m-%d')='2022-04-13' and A.apnt_cncl_yn='N' and A.MCDP_CD='CS' order by APNT_YMD

