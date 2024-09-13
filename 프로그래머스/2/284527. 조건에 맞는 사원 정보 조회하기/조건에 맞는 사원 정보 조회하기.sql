-- 코드를 작성해주세요
select score,a.emp_no,emp_name,position,email from hr_employees a 
left join (select emp_no,year,sum(score) score
from hr_grade group by 1,2) b on a.emp_no=b.emp_no
order by score desc limit 1;