

--this question like the previous one
--but the condition is different


--WHERE  CL.degree  < 60





--create     function CountStdPerDept  (  @deptNum   float  )
--returns  int
--as

--begin

--declare @numStd int
--select @numStd = 
-- count(1)  from    Classrooms$  as cl
--join  Students$ as std
--on std.StudentId = cl.StudentId
--join  Courses$ as co
--on co.CourseId = cl.CourseId

--where co.DepartmentID= @deptNum   

--return @numStd

--end






USE COLLEGE

SELECT  D.DepartmentName , COUNT( *  )  AS StdNum , count(*) * 100 /CountStdPerDept(deptid)  FROM Classrooms$  AS CL
JOIN Courses$  AS CO
ON CO.CourseId = CL.CourseId
JOIN Departments$  AS D
ON D.DepartmentId = CO.DepartmentID


WHERE  CL.degree  < 60

GROUP BY D.DepartmentId , D.DepartmentName