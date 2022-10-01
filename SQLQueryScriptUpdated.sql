

--create database staging
CREATE DATABASE StagingCollageNAYA
COLLATE Hebrew_CI_AS
WITH TRUSTWORTHY ON, DB_CHAINING ON
/*

Extract from CollageDB

*/

GO
--Create Procedure To Build DIM DATE
USE StagingCollageNAYA

GO
CREATE OR ALTER PROCEDURE GenerateDates 
AS
BEGIN
	-- declare variables to hold the start and end date
	DECLARE @StartDate datetime
	DECLARE @EndDate datetime

	--- assign values to the start date and current day plus one year ahead 

	SET @StartDate = '01/01/2013'
	SET @EndDate =  getdate()

	-- using a while loop increment from the start date 
	-- to the end date
	DECLARE @LoopDate datetime



	SET @LoopDate = @StartDate

	WHILE @LoopDate <= @EndDate
	BEGIN
	 -- add a record into the date dimension table for this date
	  INSERT INTO [Date] VALUES
		(
			@LoopDate, -- date alt key --תאריך
			Year(@LoopDate), -- calendar year
			CONCAT('Q', CAST( datepart(qq, @LoopDate) AS nvarchar(10))), -- calendar quarter --רבעון
			Month(@LoopDate), -- month number of year -- חודש
			CASE
				WHEN Month(@LoopDate) = 1 THEN 'ינואר'
				WHEN Month(@LoopDate) = 2 THEN 'פברואר'
				WHEN Month(@LoopDate) = 3 THEN 'מרץ'
				WHEN Month(@LoopDate) = 4 THEN 'אפריל'
				WHEN Month(@LoopDate) = 5 THEN 'מאי'
				WHEN Month(@LoopDate) = 6 THEN 'יוני'
				WHEN Month(@LoopDate) = 7 THEN 'יולי'
				WHEN Month(@LoopDate) = 8 THEN 'אוגוסט'
				WHEN Month(@LoopDate) = 9 THEN 'ספטמבר'
				WHEN Month(@LoopDate) = 10 THEN 'אוקטובר'
				WHEN Month(@LoopDate) = 11 THEN 'נובמבר'
				WHEN Month(@LoopDate) = 12 THEN 'דצמבר'		
			END,	--חודש בעברית
			datepart(dw, @LoopDate), -- day number of week -מס' יום
			CASE 
				WHEN datepart(dw, @LoopDate) = 1 THEN 'ראשון'
				WHEN datepart(dw, @LoopDate) = 2 THEN 'שני'
				WHEN datepart(dw, @LoopDate) = 3 THEN 'שלישי'
				WHEN datepart(dw, @LoopDate) = 4 THEN 'רביעי'
				WHEN datepart(dw, @LoopDate) = 5 THEN 'חמישי'
				WHEN datepart(dw, @LoopDate) = 6 THEN 'שישי'
				WHEN datepart(dw, @LoopDate) = 7 THEN 'שבת'
			END --יום בעברית
		)  
		 -- increment the date by 1 day and do next loop
		SET @LoopDate = DateAdd(dd, 1, @LoopDate)
	END
END

GO
--reate Procedure To Chaenge Birthe Dates For Everybody
CREATE OR ALTER PROCEDURE ChangeBdayforAll
AS
BEGIN
	DECLARE @MinAge int;
	DECLARE @MaxAge int;
	DECLARE @MAxStudentID int;
	DECLARE @IDCounterMin int;
	DECLARE @IDCounterMax int;

	SET @MinAge = 22;
	SET @MaxAge = 28;
	SET @MAxStudentID = (SELECT MAX(id) FROM STGStudents)
	SET @IDCounterMax = @MAxStudentID * 0.15;
	SET @IDCounterMin = 1;

	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @IDCounterMax 
		----------------------------------------------------

	SET @MinAge = 29;
	SET @MaxAge = 41;
	SET @IDCounterMin = 1+ @IDCounterMax;
	SET @IDCounterMax = @MAxStudentID * 0.7 + @MAxStudentID * 0.15 ;


	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @IDCounterMax 
	------------------------------------------------------------------------
	SET @MinAge = 42;
	SET @MaxAge = 51;
	SET @IDCounterMin = @IDCounterMax;


	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @MAxStudentID 
	----------------------------------------------------------------------------------------


END

GO
--Create Procedure To Chaenge Birthe Dates For "סטודנט"
CREATE OR ALTER PROCEDURE ChangeBdayforStudents
AS
BEGIN
	DECLARE @MinAge int;
	DECLARE @MaxAge int;
	DECLARE @MAxStudentID int;
	DECLARE @IDCounterMin int;
	DECLARE @IDCounterMax int;

	SET @MinAge = 22;
	SET @MaxAge = 28;
	SET @MAxStudentID = (SELECT MAX(id) FROM STGStudents)
	SET @IDCounterMax = @MAxStudentID * 0.15;
	SET @IDCounterMin = 1;

	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @IDCounterMax AND KStatusFld = ('סטודנט')
		----------------------------------------------------

	SET @MinAge = 29;
	SET @MaxAge = 41;
	SET @IDCounterMin = 1+ @IDCounterMax;
	SET @IDCounterMax = @MAxStudentID * 0.7 + @MAxStudentID * 0.15 ;


	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @IDCounterMax AND KStatusFld = ('סטודנט')
	------------------------------------------------------------------------
	SET @MinAge = 42;
	SET @MaxAge = 51;
	SET @IDCounterMin = @IDCounterMax;


	UPDATE STGStudents
	SET [KBirthDateFld] = DATEADD(DAY
		, (1 - (CONVERT(int, CRYPT_GEN_RANDOM(2)) % ((@MaxAge - @MinAge) * 365)))
		, CONVERT(date, DATEADD(YEAR, 1 - @MinAge, '2018-12-31')))
		where id between @IDCounterMin and @MAxStudentID AND KStatusFld = ('סטודנט')
	----------------------------------------------------------------------------------------


END

GO
--create ExtractLog
CREATE TABLE StagingCollageNAYA.dbo.[ExtractLog](
	[UpdateDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[PackageName] nvarchar (255) NOT NULL,
	[TableName] nvarchar (255) NOT NULL,
	[Status] nvarchar (255) NULL,
	)
GO
--create STGAbsenceReasons
CREATE TABLE StagingCollageNAYA.dbo.[STGAbsenceReasons] (
    [id] int,
    [KReasonFld] nvarchar (255),
	[updateddate] [datetime] NULL
)
GO
--create STGAssignments
CREATE TABLE StagingCollageNAYA.dbo.[STGAssignments] (
    [id] int,
    [KDateFld] datetime,
    [KTitleFld] int,
    [containerid] int,
	[updateddate] [datetime] NULL
)
GO
--create STGAssignmentTypes
CREATE TABLE StagingCollageNAYA.dbo.[STGAssignmentTypes] (
    [id] int,
    [KNameFld] nvarchar(50),
	[updateddate] [datetime] NULL
)
GO
--create STGAttendances
CREATE TABLE StagingCollageNAYA.dbo.[STGAttendances] (
    [KStudentIdFld] int,
    [KPresenceFld] nvarchar(255),
    [containerid] int,
    [K_Absence] int,
	[updateddate] [datetime] NULL
)
GO
--create STGCategoriesCosts
CREATE TABLE StagingCollageNAYA.dbo.[STGCategoriesCosts] (
    [cc_CategoryCode] int,
    [ctfc_code] int,
    [cc_money] money,
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGCategories
CREATE TABLE StagingCollageNAYA.dbo.[STGCategories] (
    [id] int,
    [KNameFld] nvarchar(20),
	[updateddate] [datetime] NULL
)
GO

--create STGRentClassesCustomers
CREATE TABLE StagingCollageNAYA.dbo.[STGRentClassesCustomers] (
    [rcc_CustCode] int,
    [rcc_CustDesc] nvarchar(255),
	[updateddate] [datetime] NULL
)
GO
--create STGCities
CREATE TABLE StagingCollageNAYA.dbo.[STGCities] (
    [id] int,
    [KNameFld] nvarchar(225),
	[updateddate] [datetime] NULL
)
GO
--create STGClasses
CREATE TABLE StagingCollageNAYA.dbo.[STGClasses] (
    [id] int,
    [KNameFld] nvarchar(50),
	[updateddate] [datetime] NULL
)
GO
--create STGCostsTypesForCategories
CREATE TABLE StagingCollageNAYA.dbo.[STGCostsTypesForCategories] (
    [ctfc_code] int,
    [ctfc_desc] varchar(25),
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGCourses
CREATE TABLE StagingCollageNAYA.dbo.[STGCourses] (
    [id] int,
    [KStartDateFld] datetime,
    [KEndDateFld] datetime,
    [KFinalProjectDateFld] datetime,
    [KTitleFld] int,
	[KpriceFld] float,
    [KClassFld] int,
	[KMinStudentsNumFld] float,
	[KMaxStudentsNumFld] float,
    [KLecturersTbl] int,
    [KLocationFld] nvarchar(255),
    [KDayPartFld] nvarchar(255),
	[KNoOfStudentsFld] float,
    [KCourseFormatFld] nvarchar(255),
    [KCourseTypeFld] int,
	[updateddate] [datetime] NULL
)
GO
--create STGCourseTypes
CREATE TABLE StagingCollageNAYA.dbo.[STGCourseTypes] (
    [id] int,
    [KTitleFld] nvarchar(255),
    [KHoursFld] int,
    [KPassingGradeFld] int,
    [KCategoryFld] int,
	[updateddate] [datetime] NULL
)
GO
--create STGDiscountsTypes
CREATE TABLE StagingCollageNAYA.dbo.[STGDiscountsTypes] (
    [id] int,
    [KDiscountNameFld] nvarchar(50),
    [KPercentageFld] int,
	[updateddate] [datetime] NULL
)
GO
--create STGGrades
CREATE TABLE StagingCollageNAYA.dbo.[STGGrades] (
    [AssignCode] int,
    [StudentId] int,
	[Grade] float,
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGInvoices
CREATE TABLE StagingCollageNAYA.dbo.[STGInvoices] (
    [InvoiceNum] int,
    [StudentCode] int,
    [CourseCode] int,
	[Amount] float,
    [InvDate] datetime,
    [PayType] int,
    [NumbersOfPay] int,
    [Discount type] int,
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGLecturers
CREATE TABLE StagingCollageNAYA.dbo.[STGLecturers] (
    [id] int,
    [KLastNameFld] nvarchar(255),
    [KFirstNameFld] nvarchar(255),
    [KEmailFld] nvarchar(255),
    [KPhoneFld] nvarchar(255),
    [KBirthDateFld] datetime,
    [KGenderFld] nvarchar(255),
    [KStatusFld] nvarchar(255),
    [KCityFld] int,
	[KWorkHourFld] float,
    [KCourseTypesFld] nvarchar(255),
	[updateddate] [datetime] NULL
)
GO
--create STGMeetings
CREATE TABLE StagingCollageNAYA.dbo.[STGMeetings] (
    [id] int,
    [KTitleFld] nvarchar(255),
    [KDayFld] nvarchar(255),
    [KTimeStartFld] datetime,
    [KTypeFld] nvarchar(255),
    [containerid] int,
    [KMeetingLocationFld] int,
	[updateddate] [datetime] NULL
)
GO
--create STGPayment
CREATE TABLE StagingCollageNAYA.dbo.[STGPayment] (
    [InvoiceNum] int,
    [payment Line] int,
    [PayDate] datetime,
	[Payment val] float,
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGPaymentTypes
CREATE TABLE StagingCollageNAYA.dbo.[STGPaymentTypes] (
    [id] int,
    [KNameFld] nvarchar(50),
    [KIconFld] nvarchar(255),
	[updateddate] [datetime] NULL
)
GO
--create STGPayTerms
CREATE TABLE StagingCollageNAYA.dbo.[STGPayTerms] (
    [id] int,
    [KNameFld] nvarchar(50),
    [KDaysFld] int,
	[updateddate] [datetime] NULL
)
GO
--create STGRegistrations
CREATE TABLE StagingCollageNAYA.dbo.[STGRegistrations] (
    [id] int,
    [KRegisteredToFld] int,
    [KRegistrationStatusFld] nvarchar(255),
    [containerid] int,
    [KDropoutReasonFld] nvarchar(255),
    [KRegistrationDateFld] datetime,
	[KLastNameFld] nvarchar(255),
    [KFirstNameFld] nvarchar(255),
	[updateddate] [datetime] NULL
)
GO
--create STGRentIncome
CREATE TABLE StagingCollageNAYA.dbo.[STGRentIncome] (
    [Rent_Income_Inv] int,
    [ri_date] date,
    [ri_CustCode] int,
    [ri_StartTime] time(7),
    [ri_EndTime] time(7),
    [ri_costs] money,
    [ri_terms] int,
	[updateddate] [datetime] DEFAULT GETDATE() 
)
GO
--create STGStudents
CREATE TABLE StagingCollageNAYA.dbo.[STGStudents] (
    [id] int,
    [KFirstNameFld] nvarchar(255),
    [KLastNameFld] nvarchar(255),
    [KIDFld] int,
    [KBirthDateFld] datetime,
    [KCityFld] int,
    [KPhoneFld] nvarchar(255),
    [KEmailFld] nvarchar(255),
    [KSmsFld] nvarchar(255),
    [KStatusFld] nvarchar(255),
    [KCreateDateFld] datetime,
    [KAccountStatusFld] nvarchar(255),
    [KGenderFld] nvarchar(255),
    [KEducationsFld] nvarchar(255),
    [KTechnologicBackgroundFld] nvarchar(255),
    [KCurrentJobFld] nvarchar(255),
    [KProfessionalStatusFld] nvarchar(255),
	[updateddate] [datetime] NULL
)
GO
--Generate Dates
CREATE TABLE StagingCollageNAYA.dbo.[Date](
	[Date] [date] NOT NULL,
	[Year] [smallint] NOT NULL,
	[Quarter] [nvarchar](10) NOT NULL,
	[Month] [smallint] NOT NULL,
	[MonthNameHEB] [nvarchar](20) NOT NULL,
	[DayNumber] [tinyint] NOT NULL,
	[DayNameHEB] [nvarchar](20) NOT NULL
)
GO	
	
	--create STGSRegions
CREATE TABLE StagingCollageNAYA.dbo.[STGRegions] (
    [שם יישוב] nvarchar(255),
    [תיאור מחוז] nvarchar(255),
    [איזור] nvarchar(255)
)
GO		
	
	
	
	
	
	
	
	
--------------------------------------------------------------------------------------------
--create datab warehouse
CREATE DATABASE CollageNAYADW
COLLATE Hebrew_CI_AS
WITH TRUSTWORTHY ON, DB_CHAINING ON;
GO

--create ExtractLog
CREATE TABLE [CollageNAYADW].[dbo].[ExtractLog](
	[UpdateDate] DATETIME NOT NULL DEFAULT GETDATE(),
	[PackageName] [nvarchar] (255) NOT NULL,
	[TableName] [nvarchar] (255) NOT NULL,
	[Status] [nvarchar] (255) NULL,
)
GO
--create DIMDate
CREATE TABLE [CollageNAYADW].[dbo].[DIMDate] (
    [Date] date,
    [Year] int,
    [Quarter] nvarchar(10),
    [Month] int,
    [MonthNameHEB] nvarchar(20),
    [DayNumber] int,
    [DayNameHEB] nvarchar(20),
	[ExtractDate] datetime DEFAULT '01-01-2000'

)
GO
--create DIMRentingCustomers
CREATE TABLE [CollageNAYADW].[dbo].[DIMRentingCustomers] (
    [CustomerID] int,
    [CustomerName] nvarchar(255),
	[ExtractDate] datetime DEFAULT '01-01-2000'
)
GO
--create FactAttendence
CREATE TABLE [CollageNAYADW].[dbo].[FactAttendence](
	[MeetingID] [int] NULL,
	[MeetingDesc] [nvarchar] (255) NULL,
	[Day] nvarchar(255) NULL,
	[Date] [datetime] NULL,
	[Type] nvarchar(255) NULL,
	[ClassID] [int] NULL,
	[CourseID] [int] NULL,
	[LecturerID] [int] NULL,
	[StudentID] [int] NULL,
	[PresenceStatus] nvarchar(255) NULL,
	[Reason] nvarchar(255) NULL,
	[ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
) 
GO

--create DIMLecturers
CREATE TABLE [CollageNAYADW].[dbo].[DIMLecturers] (
    [LecturerID] int,
    [FullName] nvarchar(255),
    [Email] nvarchar(255),
    [Phone] nvarchar(255),
    [BirthDate] datetime,
    [Gender] nvarchar(255),
    [Status] nvarchar(255),
    [CityID] int,
    [WorkHour] float,
    [CourseType] int,
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create FactRentIncome
CREATE TABLE [CollageNAYADW].[dbo].[FactRentIncome] (
    [RentIncomeID] int,
	[CustomerID] int,
    [Date] date,
    [StartHour] DATETIME,
    [EndHour]DATETIME,
    [Cost] float,
    [PayTermID] int,
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO

--create DIMStudents
CREATE TABLE  [CollageNAYADW].[dbo].[DIMStudents] (
    [StudentID] int,
    [FullName] nvarchar(255),
    [IDNumber] int,
    [BirthDate] datetime,
    [CityID] int,
    [Phone] nvarchar(255),
    [Email] nvarchar(255),
    [SMS] nvarchar(255),
    [Status] nvarchar(255),
    [CreateDate] datetime,
    [LeadSource] nvarchar(255),
    [Gender] nvarchar(255),
    [Education] nvarchar(255),
    [Background] nvarchar(255),
    [Job] nvarchar(255),
    [ProStatus] nvarchar(255),
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create DIMCourses
CREATE TABLE [CollageNAYADW].[dbo].[DIMCourses] (
    [CourseID] int,
    [StartDate] datetime,
    [EndDate] datetime,
    [FinalProjectDate] datetime,
    [Price] float,
    [ClassID] int,
    [MinStudNum] float,
    [MaxStudNum] float,
    [LecturerID] int,
    [Location] nvarchar(255),
    [DayPart] nvarchar(255),
    [NoOfStudents] float,
    [FormatCourse] nvarchar(255),
	[CourseTypeID] int,
    [CourseTypeDesc] nvarchar(255),
    [CourseHours] int,
    [PassingGrade] int,
    [CategoryID] int,
	[ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create FactRegestrations
CREATE TABLE [CollageNAYADW].[dbo].[FactRegestrations] (
    [RegistrationID] int,
    [CourseID] int,
    [Status] nvarchar(255),
    [StudentID] int,
    [DropoutReason] nvarchar(255),
    [RegistrationDate] datetime,
	[ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO

--create FactGrades
CREATE TABLE [CollageNAYADW].[dbo].[FactGrades] (
    [AssignmentID] int,
	[AssignmentDesc] nvarchar(255),
	[AssignmentDate] datetime,
    [StudentID] int,
	[CourseID] int,
    [Grade] float,
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create DIMExpenses
CREATE TABLE [CollageNAYADW].[dbo].[DIMExpenses] (
    [CostTypeID] int,
    [CostTypeDesc] varchar(25),
    [CategoryID] int,
    [Cost] float,
	[ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create DIMGeography
CREATE TABLE [CollageNAYADW].[dbo].[DIMGeography] (
	[CityID] int,
    [CityName] nvarchar(255),
    [District] nvarchar(255),
    [Region] nvarchar(255),
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)
GO
--create FactPayments
CREATE TABLE [CollageNAYADW].[dbo]. [FactPayments] (
    [InvoiceNum] int,
    [InvoicePaymentNumber] int,
    [PayDate] datetime,
    [Payval] float,
    [updateddate] datetime,
    [StudentID] int,
    [CourseID] int,
    [InvocieAmount] float,
    [InvoiceDate] datetime,
    [PayTypeID] int,
    [NumbersOfPayments] int,
    [DiscountID] int,
    [PayTypeHebrewDesc] nvarchar(50),
    [PayTypeEnglishDesc] nvarchar(255),
    [DiscountDesc] nvarchar(255),
    [DiscountPrecentage] int,
    [ExtractDate] DateTime DEFAULT '01-01-2000' NULL
)
GO
--create DIMCategories
CREATE TABLE [CollageNAYADW].[dbo].[DIMCategories] (
    [CategoryID] int,
    [CategoryDesc] nvarchar(20),
    [ExtractDate] DateTime DEFAULT '01-01-2000' NULL
)
GO
--create DIMClasses
CREATE TABLE [CollageNAYADW].[dbo].[DIMClasses] (
    [ClassID] int,
    [ClassName] nvarchar(50),
	[ExtractDate] DateTime DEFAULT '01-01-2000' NULL
)
GO
--create DimPayTerms
CREATE TABLE [CollageNAYADW].[dbo].[DimPayTerms] (
    [PayTermsID] int,
    [PayTermsDesc] nvarchar(50),
    [PaymentDayes] int,
    [ExtractDate] [datetime] DEFAULT '01-01-2000' NULL
)

