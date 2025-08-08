-- Write your PostgreSQL query statement below
select department,employee,salary from
(select b.name department,a.name employee,dense_rank() over(partition by departmentid order by salary desc) rank,a.id sort,salary from employee a left join department b on a.departmentid=b.id) as c
where rank=1
order by sort;