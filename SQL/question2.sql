

  use COLLEGE

  select co.CourseId , co.CourseName ,count(1)  as studentinclass  from  Courses$ as co
  join ( select distinct Classrooms$.CourseId, Classrooms$.StudentId  from    Classrooms$   )  as cr
  on co.CourseId = cr.CourseId
  join Departments$  d
  on d.DepartmentId =co.DepartmentID

  
  where co.DepartmentID = 1 
  group by co.CourseId , d.DepartmentId , co.CourseName





סהכ התלמידים בכל הקורסים


  select co.DepartmentID , d.DepartmentName ,count(1)  as studentinclass  from  Courses$ as co
  join ( select distinct Classrooms$.CourseId, Classrooms$.StudentId  from    Classrooms$   )  as cr
  on co.CourseId = cr.CourseId
  join Departments$  d
  on d.DepartmentId =co.DepartmentID

  
  where d.DepartmentID = 1 
  group by  co.DepartmentId , d.DepartmentName

