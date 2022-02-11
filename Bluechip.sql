---drop table UserRegistration

create table UserRegistration    
(    
 UserId int not null primary key identity(1,1),    
 Username nvarchar(150),    
 Firstname nvarchar(150),    
 Lastname nvarchar(150),    
 [Password] nvarchar(100),    
 [Confirmpwd] nvarchar(100),    
 [Email] nvarchar(150),    
 DOB DateTime,
 Gender char,    
 MaritalStatus nvarchar(100),
 [Address] nvarchar(150),   
  IsActive bit default(1)     
); 

Go 

----   Exec  Usp_UserRegistration 'OneUser','!@#123','123!@#','One@outlook.com','M','Married'

ALTER Proc Usp_UserRegistration
(
@Username nvarchar(150),    
@Firstname nvarchar(150),    
@Lastname nvarchar(150),   
@Password nvarchar(100),    
@Confirmpwd nvarchar(100),    
@Email nvarchar(150), 
@DOB DateTime,   
@Gender char,    
@MaritalStatus nvarchar(100),
@Address nvarchar(150)
)
As Begin
Set Nocount On

---------------

Insert UserRegistration(Username,Firstname,Lastname,[Password],[Confirmpwd],[Email],DOB,Gender,MaritalStatus,[Address])
Values(@Username,@Firstname,@Lastname,@Password,@Confirmpwd,@Email,@DOB,@Gender,@MaritalStatus,@Address)
Select Scope_identity() ID

END


Go

Alter table dbo.Course
Add CreatedDate Datetime default(getdate())
Go

CREATE Proc Usp_AddCourse
(
@CourseName nvarchar(150)   
)
As Begin
Set Nocount On
---------------

Insert Course(CourseName)
Values(@CourseName)
Select Scope_identity() ID

END
Go


CREATE Proc Usp_GetAllRegistration
As Begin
Set Nocount On
---------------
Select Username,Firstname,Lastname,[Email],DOB,Gender,MaritalStatus,[Address]  from UserRegistration  where IsActive=1

END
Go

ALTER Proc Usp_GetAllCourse
As Begin
Set Nocount On
---------------
Select CourseName,CourseCode,CreatedDate from Course  ---where IsActive=1

END
Go

Alter table dbo.Course
Add CreatedDate Datetime default(getdate())
Go


Create Table Dbo.Enroll
(
EnrollmentID int identity(1000,1) primary key,
RegistrationID int References UserRegistration(UserID),
CourseID int References Course(CourseCode),
EnrollmentDate DateTime ,
IsActive bit default(1)
)
Go

----   Exec  Usp_UserRegistration 'OneUser','!@#123','123!@#','One@outlook.com','M','Married'

CREATE Proc Usp_EnrollCourse
(
@UserID Int,    
@CourseID int,
@EnrollmentDate DateTime

)
As Begin
Set Nocount On
---------------
set @EnrollmentDate= (select case when @EnrollmentDate is null then getdate() else @EnrollmentDate end)
Insert Enroll(RegistrationID,CourseID,EnrollmentDate)
Values(@UserID,@CourseID,@EnrollmentDate)
Select Scope_identity() ID

END