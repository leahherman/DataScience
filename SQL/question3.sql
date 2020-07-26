
use COLLEGE

select DepartmentName , count('big')  as bigClasses , count('small')  as smallClasses  from


(

select DepartmentName , CourseName , sizeClass ,
	sizeType = case 
				when sizeClass > 22 then 'big' 
				else   'small'
			end
from (
select d.DepartmentName ,co.CourseName , count(1)   as sizeClass  from Courses$ as co
join  Departments$  as d
on co.DepartmentID = d.DepartmentId
join Classrooms$  as cl
on cl.CourseId = co.CourseId
where d.DepartmentId=2

group by d.DepartmentId , d.DepartmentName , cl.CourseId , co.CourseName


 ) as  myfile
 ) as dd
   group by departmentName
 
 

