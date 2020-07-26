

use COLLEGE

select   std.Gender , count(1)   as StdNum   from  Students$  as std
inner join Teachers$  as teach
on  teach .Gender = std.Gender
group by std.Gender

