-- Write your PostgreSQL query statement below
with a as(select a.name employee,b.name department,dense_rank() over(partition by departmentid order by salary desc) rank,* from employee a left join department b on a.departmentid=b.id)
select department,employee,salary from a
where rank<=3;

