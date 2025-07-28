-- Write your PostgreSQL query statement below
select firstName,lastName,city,state from Person a left join Address b on a.personId=b.personId