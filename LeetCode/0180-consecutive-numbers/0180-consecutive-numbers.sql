# Write your MySQL query statement below
SELECT DISTINCT a.Num AS ConsecutiveNums
FROM Logs AS a
INNER JOIN Logs AS b ON a.ID = b.ID + 1
INNER JOIN Logs AS c ON a.ID = c.ID + 2
WHERE a.Num = b.Num
  AND a.Num = c.Num;