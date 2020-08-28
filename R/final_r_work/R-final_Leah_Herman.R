### R Intro - Final Exercise


library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)

### Try with the diferent driver strings to see what works for you
###conn <- dbConnect(odbc::odbc, .connection_string = driver)
con <- dbConnect(odbc(), "COLLEGE")


### Get the raw data from  tables
students  <- dbGetQuery(con, "SELECT * FROM Students$")
teachers  <- dbGetQuery(con, "SELECT * FROM Teachers$")
courses   <- dbGetQuery(con, "SELECT * FROM Courses$")
classrooms <- dbGetQuery(con, "SELECT * FROM Classrooms$")
departments <- dbGetQuery(con, "SELECT * FROM Departments$")

#DBI::dbDisconnect(con)
print(departments)
data(departments)
view(departments)
###Questions
### Q1. Count the number of students on each department

dfStudentsAndCourses <- merge(classrooms, courses, by = "CourseId", all.x = TRUE) 
head(dfStudentsAndCourses)
colnames(dfStudentsAndCourses)[5]  <- "DepartmentId"
dfAllDataNeeded <- merge(departments,dfStudentsAndCourses , by='DepartmentId')

dfAllDataNeeded[order(dfAllDataNeeded$DepartmentId),]
df  <- distinct(select(dfAllDataNeeded, DepartmentName, StudentId)) 
head(df)
g <- group_by(df, DepartmentName )
head(g)
q  <- summarise(g, studentsInDept =n())

head(q)

###


###Q2. How many students have each course of the English department and the total number of students in the department?
###
### num students per Course
englishDepartment = 1.0
dfStudentsCoursesDept <- merge(classrooms , courses  ,by="CourseId" , all.x=TRUE)
dfStudentsCoursesDeptA  <- rename(dfStudentsCoursesDept, DepartmentId = DepartmentID)
df  <-  dfStudentsCoursesDeptA %>% filter(DepartmentId == englishDepartment)
dfstudentsPerEnglishCourse <-  group_by(df ,CourseName )
dfStudentsPerCourse  <- summarise(dfstudentsPerEnglishCourse , Students = n())
print(dfStudentsPerCourse)


dfUnique <- distinct(select(df, DepartmentId, StudentId)) 

totalStudents  <- NROW(dfUnique)
lastRow  <-  c("total" ,totalStudents )
###cols <- c("CourseName", "Students" )
dfTotal <- data.frame(dfStudentsPerCourse)      ###cols)
dfSof <- rbind(dfTotal,lastRow)

print(dfSof)

####  order  examp
#iris3 %>%
#  arrange(Sepal.Length)
#
#iris3 %>%
#  arrange(desc(Petal.Width))


###############################################

###Q3. How many small (<22 students) and large (22+ students) classrooms are needed for the Science department?


scienceDepartment <- 2.0
bigClass <- 23.0

dfStudentsCoursesDept <- inner_join (classrooms %>% select(CourseId, StudentId) , 
                                     courses %>% select(CourseId  , DepartmentID ), by ="CourseId" )
dfStudentsCoursesDept  <- rename(dfStudentsCoursesDept, DepartmentId = DepartmentID)

dfStudentsCoursesDeptA  <- dfStudentsCoursesDept %>% filter(DepartmentId== scienceDepartment)
StudentPerCourse   <-  dfStudentsCoursesDeptA %>% group_by(CourseId) %>% summarise(NumStudents = n())
print(nrow(StudentPerCourse))

bigC <- 0

for (row in 1:nrow(StudentPerCourse)) {
  NumStudents <- StudentPerCourse[row, "NumStudents"]
  if(NumStudents  >= bigClass)
    {bigC <- bigC  + 1 
    }
}
sizeClasses = cbind(bigC , nrow(StudentPerCourse) - bigC)

x <- cbind("Big Classes", "Small Classes")
dfResult <- data.frame(sizeClasses)
colnames(dfResult) <- x
print(dfResult)






###Q4. A feminist student claims that there are more male than female in the College. Justify if the argument is correct

dfByGender   <-  group_by(students  , Gender)
summarise(dfByGender  , numStudents = n())



###Q5. For which courses the percentage of male/female students is over 70%?

merged_df <- inner_join(classrooms, students, by="StudentId")
df <- inner_join(merged_df, courses, by="CourseId")
dfNumStudentsPerCoursePerGender <- df %>% select(CourseName, Gender ,CourseId ,StudentId) %>% group_by(CourseName, Gender ,CourseId ) %>% summarise(NumStudents = n()) 

dfNumStudentsPerCoursePerGenderTotal <- group_by( df , CourseName, CourseId  ) %>%  summarise( TotalStudents = n())
size1  <-  NROW(dfNumStudentsPerCoursePerGender)
AbovePercent <- replicate(size1 , 0.0)
print(AbovePercent)
TotalStudents  <- AbovePercent
GenderPercent  <- AbovePercent
dfNumStudentsPerCoursePerGender <- dfNumStudentsPerCoursePerGender %>% select(CourseName, Gender ,CourseId ,NumStudents ,TotalStudents ,GenderPercent)  

for (row in 1:nrow(dfNumStudentsPerCoursePerGender)) {
  vCourseName <- dfNumStudentsPerCoursePerGender[row, "CourseName"]
  i <- filter(dfNumStudentsPerCoursePerGenderTotal , CourseName == vCourseName)  
  
  totalVal <- as.numeric (i["TotalStudents"] ,digits=4)   #.as.numeric
  genderVal <- as.numeric (dfNumStudentsPerCoursePerGender[row ,"NumStudents"] , digits =4)
  genderPercent <- genderVal / totalVal  
  TotalStudents[row] <- totalVal
  GenderPercent[row] <- genderPercent
}
cbind(dfNumStudentsPerCoursePerGender ,TotStudents=TotalStudents )
dfNum <- cbind(dfNumStudentsPerCoursePerGender ,GendPercent=GenderPercent )
print(dfNum)
 ## dfNum %>% arrange(  desc(GenderPercent))
dfResult <- dfNum %>% filter( GendPercent > 0.7)
print(dfResult)
 

  
  
  








###Q6. For each department, how many students passed with a grades over 80?


shmonim = 80.0
#find the num of students in each department
merged_df <- inner_join(classrooms, courses, by="CourseId")
df1 <-rename(merged_df, DepartmentId = DepartmentID)
print(df1)
df <- inner_join(df1, departments, by="DepartmentId")
dfAllData  <- df

dfDep <-  rename( df , allStudents = StudentId)

dfAllStd  <- unique (dfDep %>% select(DepartmentName ,allStudents))
dfAllStudents  <- dfAllStd %>% group_by(DepartmentName)%>% summarize (allStudents = n() )
print(dfAllStudents)

print(ddfAllDataf)


dfRelavant <- unique ( filter(dfAllData ,degree  >  shmonim))
print(dfRelavant)
dfResult = unique(dfRelavant  %>%  select(DepartmentName , StudentId ) ) 
dfRes  <-dfResult %>% group_by(  DepartmentName) %>% summarise(students80 = n())
dfAllCol <- inner_join(dfRes, dfAllStudents, by="DepartmentName")
size1  <-  NROW(dfAllCol)
demo <- replicate(size1 , 0.0)
pctStudents  <-  demo
for (x in 1:size1) {
  name = dfAllCol[ x ,"DepartmentName"]
  totalVal = as.integer(dfAllCol[x , "allStudents"])
  pctStudents[x]  <- as.integer( dfRes[x ,"students80"])  * 100 / totalVal
}
 dfResult <-  cbind ( dfAllCol ,percentStudents = pctStudents )
 options(digit=2)



print(dfResult)





###Q7. For each department, how many students passed with a grades under 60?

shishim = 60.0
zero = 0.0

merged_df <- inner_join(classrooms, courses, by="CourseId")
df1 <-rename(merged_df, DepartmentId = DepartmentID)
print(df1)
df <- inner_join(df1, departments, by="DepartmentId")
dfAllData  <- df
dfDep <-  rename( df , allStudents = StudentId)
dfAllStd  <- unique (dfDep %>% select(DepartmentName ,allStudents))
dfAllStudents  <- dfAllStd %>% group_by(DepartmentName)%>% summarize (allStudents = n() )
#print(dfAllStudents)

dfRelavant <- unique ( filter(dfAllData ,degree  <  shishim))
print(dfRelavant)
dfResult = unique(dfRelavant  %>%  select(DepartmentName , StudentId ) ) 
dfRes  <-dfResult %>% group_by(  DepartmentName) %>% summarise(students60 = n())
dfAllCol <- inner_join(dfRes, dfAllStudents, by="DepartmentName")
print(dfAllCol)

size1  <-  NROW(dfAllCol)
demo <- replicate(size1 , 0.0)
pctStudents  <-  demo
print( dfAllCol)

for (x in 1:size1) {
  name = dfAllCol[ x ,"DepartmentName"]
  totalVal = as.integer(dfAllCol[x , "allStudents"])
  pctStudents[x]  <- as.integer( dfRes[x ,"students60"])  * 100 / totalVal
}
dfResult <-  cbind ( dfAllCol ,percentStudents = pctStudents )
options(digit=2)



print(dfResult)




###Q8. Rate the teachers by their average student's grades (in descending order).

merged_df <- inner_join(classrooms, courses, by="CourseId")
df <- inner_join(merged_df, teachers, by="TeacherId")
dfAllData  <- df
dfTeachers  <-   unique (dfAllData %>% select(TeacherId , FirstName , LastName, degree ))
dfTeach <-dfTeachers %>% group_by(Teacher = FirstName +" "+LastName) %>% summarise(avgDegree = mean(degree))
dfResul = arrange(dfTeach , desc(avgDegree) )

dfResul$Teacher  <- paste(dfResul$FirstName," ",dfResul$LastName)

print ( dfResul[ ,4:3] )








###Q9. Create a dataframe showing the courses, departments they are associated with, the teacher in each course, and the number of students enrolled in the course (for each course, department and teacher show the names).

courses1 <-  rename( courses , DepartmentId = DepartmentID)

merged_df <- inner_join(departments, courses1, by="DepartmentId")
df <- inner_join(merged_df, classrooms, by="CourseId")
dfAllData <- inner_join(df, teachers, by="TeacherId")
print(merged_df)
classrommList  <-   unique (dfAllData %>% select(CourseId , CourseName , DepartmentName, FirstName , LastName ,StudentId ))
dfList <-classrommList %>% group_by(DepartmentName ,CourseName , FirstName ,LastName )
dfRes  <- summarise(dfList ,Students = n())
dfResul = arrange(dfRes , DepartmentName ,CourseName , FirstName , LastName  , Students) 
print(dfResul%>% select (  Students ,DepartmentName ,CourseName ,FirstName ,LastName  ))

print(dfResul)



###Q10. Create a dataframe showing the students, the number of courses they take, the average of the grades per class, and their overall average (for each student show the student name).

# view 10
  
dfClsCourseData <- left_join( classrooms ,courses ,  by = "CourseId")

dfStdClsCourseData = left_join(students,dfClsCourseData , by="StudentId")
dfStdClsCourseData1 <- rename( dfStdClsCourseData ,DepartmentId =DepartmentID)

dfStdClsCourseDeptData <-  inner_join(departments,dfStdClsCourseData1 , by="DepartmentId" )
dfStdDeptDegree <-  dfStdClsCourseDeptData %>% select (StudentId , DepartmentName ,degree )
classrommList <-  unique (dfStdClsCourseData1 %>% select (StudentId ,FirstName , LastName,CourseId  , degree,DepartmentId))  
dfResult <-  classrommList%>% group_by(StudentId ,FirstName, LastName ,DepartmentId) %>% summarise(numCourses= n())
dfResult1 <- arrange(dfResult ,StudentId ,FirstName)

dfMeanStdDeptDegree <-  dfStdDeptDegree%>% group_by(StudentId, DepartmentName )%>% summarize(avgDegree = mean(degree))

dfStdGeneral<- dfStdDeptDegree%>%group_by(StudentId)%>% summarise(GenMean = mean(degree))
print( dfStdDeptDegree)
head(dfMeanStdDeptDegree)


i=0

for (line1 in departments$DepartmentName)  {
   i<- i+1
   df11 <- data.frame()
   df11 <-  dfMeanStdDeptDegree%>%filter(DepartmentName == line1 )
   dfIter  <- data.frame(   df11%>% select(StudentId ,  avgDegree))

   #dfxx <-rename(dfIter , get(paste0(line1 ,"mean"))= avgDegree)
   if (i==1){
     df <-rename(dfIter , Englishmean= avgDegree)
     
      df1 <- full_join(dfStdGeneral , df  ,by="StudentId" )
    
  }
  else if (i==2){
    df22 <-rename(dfIter , Sciencemean= avgDegree)
    
    df2 <-  full_join(df1 , df22   ,by="StudentId" )
  
  
  }
    else if (i == 3){
      df33 <-rename(dfIter , Artsmean= avgDegree)
      
      df3 <-  full_join(df2 , df33   ,by="StudentId"   )
      
      
  }
    else {
      df44 <-rename(dfIter , Sportmean= avgDegree)
      
     df4 <-  full_join(df3 , df44  ,by="StudentId" )
  }
}
print(df4)

print(dfResult1)

dfff  <-  dfResult1 %>% group_by(StudentId)  %>% summarise(coursesNum = sum(numCourses)) %>% select(StudentId , coursesNum)
print(dfff)                                                          
dfR  <-  full_join(dfff%>% select(StudentId , coursesNum) , df4 , by="StudentId")

dfSof10 <- inner_join(  dfResult1 , dfR , by ="StudentId" )
print(dfSof10)

dfResult <-  unique( dfSof10 %>% select (StudentId,FirstName ,LastName,coursesNum  ,Englishmean , Sciencemean, , Artsmean , Sportmean , GenMean))
options(digits = 4)
col_names_vec = c( "coursesNum" ,"Englishmean" , "Sciencemean" , "Artsmean" , "Sportmean"  ,  "GenMean")
dfResult[,col_names_vec] % replace(.,is.na(.),0




print(dfResult)

