





create  VIEW Std_data_view  AS


select  DISTINCT CO.CourseName , D.DepartmentName , TEACH.FirstName +' ' +TEACH.LastName  as  TeachersName ,
  count(cl.StudentId) OVER (ORDER by CO.CourseId)  as numStd  

 
 from  COLLEGE.dbo.Courses$  as co
 JOIN Classrooms$  AS CL
 ON CL.CourseId = CO.CourseId
 JOIN Departments$ AS D
 ON D.DepartmentId = CO.DepartmentID  
 JOIN Teachers$  AS TEACH
 ON  TEACH.TeacherId = CO.TeacherId

