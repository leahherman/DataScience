use COLLEGE
go


select co.DepartmentID , d.DepartmentName , count(1) as studentsPerDepartment from Courses$ as co inner join ( select distinct  Classrooms$.CourseId , Classrooms$.StudentId from  Classrooms$ )  as cl
 on  cl.CourseId = co.CourseId
 join Departments$  as d
 on d.DepartmentId = co.DepartmentID
 group by co.DepartmentID ,d.DepartmentName

 go


 