







create     function GetTotalStd  (  @courseNum   float  )
returns  int
as

begin

declare @numStd int
select @numStd = 
 count(1)  from    Classrooms$  as cl
join  Students$ as std
on std.StudentId = cl.StudentId
join  Courses$ as co
on co.CourseId = cl.CourseId

where cl.CourseId= @courseNum

return @numStd

end






