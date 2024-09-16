-- 코드를 작성해주세요
select a.dept_id,dept_name_en, round(avg(sal),0) avg_sal from hr_employees a left join hr_department b 
on a.dept_id=b.dept_id
group by a.dept_id
order by 3 desc