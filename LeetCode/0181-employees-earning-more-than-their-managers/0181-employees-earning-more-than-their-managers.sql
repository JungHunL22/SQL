# Write your MySQL query statement below
select a.name employee from employee a left join employee b on a.managerid=b.id
where a.salary>b.salary;