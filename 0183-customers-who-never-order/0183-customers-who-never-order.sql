# Write your MySQL query statement below
select name customers from customers a left join orders b on a.id=b.customerid
where b.id is null;