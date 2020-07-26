

use COLLEGE

select co.TeacherId , avg(cl.degree  )   as avgDegree from Classrooms$  as cl
join Courses$  as co
on co.CourseId = cl.CourseId

group by co.TeacherId  

order by  avgDegree desc