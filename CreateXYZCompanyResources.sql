USE master
GO

/** Object: Database **/
IF DB_ID('XYZCompanyResources') IS NOT NULL
	DROP DATABASE XYZCompanyResources
GO

CREATE DATABASE XYZCompanyResources
GO

USE XYZCompanyResources
GO

/*Object: Table Job*/
CREATE TABLE Job(
	JobID				INT				PRIMARY KEY IDENTITY,
	Title				VARCHAR(20)		NOT NULL,
	Salary				MONEY,
	Benefits			VARCHAR(50),
	WorkType			VARCHAR(25)		NOT NULL,
	Quantity			INT				NOT NULL
);

/*Object: Table Offer*/
CREATE TABLE Offer(
	OfferID				INT				PRIMARY	KEY IDENTITY,
	JobID				INT				FOREIGN KEY REFERENCES Job(JobID),
	Salary				MONEY			NOT NULL,
	Benefits			VARCHAR(50)		NOT NULL,
	OfferStatus			VARCHAR(15)		NOT NULL
);

/*Object: Table CarRental*/
CREATE TABLE CarRental(
	CarRentalID			INT				PRIMARY KEY IDENTITY,
	Car					VARCHAR(40),
	InvoiceNum			VARCHAR(25)		NOT NULL,
	Total				MONEY			NOT NULL
);

/*Object: Table HotelReservation*/
CREATE TABLE HotelReservation(
	HotelReservationID	INT				PRIMARY KEY IDENTITY,
	Hotel				VARCHAR(30),
	InvoiceNum			VARCHAR(20)		NOT NULL,
	Total				MONEY			NOT NULL
);

/*Object: Table AirlineReservation*/
CREATE TABLE AirlineReservation(
	AirlineReservationID	INT				PRIMARY KEY IDENTITY,
	Airline					VARCHAR(30),
	InvoiceNum				VARCHAR(20)		NOT NULL,
	Total					MONEY			NOT NULL
);

/*Object: Table Reimbursement*/
CREATE TABLE Reimbursement(
	ReimbursementID			INT			PRIMARY KEY IDENTITY,
	CarRentalID				INT			REFERENCES CarRental(CarRentalID),
	HotelReservationID		INT			REFERENCES HotelReservation(HotelReservationID),
	AirlineReservationID	INT			REFERENCES AirlineReservation(AirlineReservationID),
	Total					MONEY		DEFAULT 0.00
);			

/*Object: Table Applicant*/
CREATE TABLE Applicant(
	ApplicantID			INT				PRIMARY KEY IDENTITY,
	ReimbursementID		INT				REFERENCES Reimbursement(ReimbursementID),
	OfferID				INT				REFERENCES Offer(OfferID),
	FirstName			VARCHAR(20)		NOT NULL,
	LastName			VARCHAR(25)		NOT NULL,
	AddressLine			VARCHAR(60)		NOT NULL,
	City				VARCHAR(40)		NOT NULL,
	Zip					VARCHAR(10)		NOT NULL,
	State				VARCHAR(2)		NOT NULL,
	PhoneNumber			VARCHAR(12)		NOT NULL,
	ApplicationStatus	VARCHAR(30)		NOT NULL
);

/*Object: Table Appliocations*/
CREATE TABLE Applications(
	ApplicationID		INT				PRIMARY KEY IDENTITY,
	ApplicantID			INT				REFERENCES Applicant(ApplicantID),
	JobID				INT				REFERENCES Job(JobID)
);

/*Object: Table Onboarding*/
CREATE TABLE Onboarding(
	OnboardingID		INT				PRIMARY KEY IDENTITY,
	ApplicantID			INT				REFERENCES Applicant(ApplicantID),
	RequiredDays		INT				DEFAULT 100,
	DaysFinished		INT				DEFAULT 0,
	Result				VARCHAR(15)		DEFAULT 'Not Initiated'
);

/*Object: Table Employee*/
CREATE TABLE Employee(
	EmployeeID			INT				PRIMARY KEY IDENTITY,
	ReimbursementID		INT				REFERENCES Reimbursement(ReimbursementID),
	FirstName			VARCHAR(20)		NOT NULL,
	LastName			VARCHAR(25)		NOT NULL,
	AddressLine			VARCHAR(60)		NOT NULL,
	City				VARCHAR(40)		NOT NULL,
	State				VARCHAR(2)		NOT NULL,
	Zip					VARCHAR(10)		NOT NULL,
	PhoneNumber			VARCHAR(12)		NOT NULL,
	Position			VARCHAR(20)		NOT NULL,
	WorkType			VARCHAR(20)		NOT NULL
);

/*Object: Table Recruiter*/
CREATE TABLE Recruiter(
	RecruiterID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	Department			VARCHAR(25)		NOT NULL
);

/*Object: Table Interview*/
CREATE TABLE Interview(
	InterviewID			INT				PRIMARY KEY IDENTITY,
	ApplicantID			INT				REFERENCES Applicant(ApplicantID),
	RecruiterID			INT				REFERENCES Recruiter(RecruiterID),
	InterviewDate		DATETIME,
	ApplicantReview		VARCHAR(200),
	InterviewerReview	VARCHAR(200),
	InterviewType		VARCHAR(50)
);

/*Object: Table RecruitmentManager*/
CREATE TABLE RecruitmentManager(
	ManagerID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	Department			VARCHAR(25)
);

/*Object: Table BudgetManager*/
CREATE TABLE BudgetManager(
	ManagerID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	AccountID			VARCHAR(25)
);

/*Object: Table PortfolioManager*/
CREATE TABLE PortfolioManager(	
	ManagerID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	AccountID			VARCHAR(25)		NOT NULL
);

/*Object: Table HeadOfOperation*/
CREATE TABLE HeadOfOperation(
	DepartmentID		INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	DepartmentName		VARCHAR(20)		NOT NULL,
	Project				VARCHAR(25)		NOT NULL
);

/*Object: Table SectorManager*/
CREATE TABLE SectorManager(
	SectorID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	DepartmentID		INT				REFERENCES HeadOfOperation(DepartmentID),
	SectorName			VARCHAR(20)		NOT NULL,
	Epic				VARCHAR(25)		NOT NULL
);

/*Object: Table Engineer*/
CREATE TABLE Engineer(
	EngineerID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	SectorID			INT				REFERENCES SectorManager(SectorID),
	UserStory			VARCHAR(25)		NOT NULL
);

/*Object: Table Tester*/
CREATE TABLE Tester(
	TesterID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	SectorID			INT				REFERENCES SectorManager(SectorID),
	UserStory			VARCHAR(25)		NOT NULL
);


/*Object: Table Invoices*/
CREATE TABLE Invoices(
	InvoiceID			INT				PRIMARY KEY IDENTITY,
	Description			VARCHAR(50),
	Balanace			MONEY			NOT NULL,
	Credits				MONEY			NOT NULL,
	Quantity			INT				NOT NULL,
	DueDate				DATETIME		NOT NULL
	);

/*Object: Table Salary*/
CREATE TABLE Salary(
	SalaryID			INT				PRIMARY KEY IDENTITY,
	InvoiceID			INT				REFERENCES Invoices(InvoiceID),
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	Wage				Money			NOT NULL,
);

/*Object: Table Tester*/
CREATE TABLE Expenses(
	ExpenseID			INT				PRIMARY KEY IDENTITY,
	ReimbursementID		INT				REFERENCES Reimbursement(ReimbursementID),
	InvoiceID			INT				REFERENCES Invoices(InvoiceID),
	TotalExpenses		MONEY			NOT NULL
);

CREATE TABLE FormerEmployee(
	EmployeeID			INT				PRIMARY KEY IDENTITY,
	FirstName			VARCHAR(20)		NOT NULL,
	LastName			VARCHAR(25)		NOT NULL,
	AddressLine			VARCHAR(60)		NOT NULL,
	City				VARCHAR(40)		NOT NULL,
	State				VARCHAR(2)		NOT NULL,
	Zip					VARCHAR(10)		NOT NULL,
	PhoneNumber			VARCHAR(12)		NOT NULL,
	FormerPosition		VARCHAR(20)		NOT NULL
);

/*Object: Table Pension/Severance*/
CREATE TABLE PensionAndSeverance(
	ServiceID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	InvoiceID			INT				REFERENCES Invoices(InvoiceID),
	FundAmount			MONEY			NOT NULL,
	Type				VARCHAR(20)		NOT NULL
);

/*Object: Table Portfolio*/
CREATE TABLE Portfolio(
	PortfolioID			INT				PRIMARY KEY IDENTITY,
	EmployeeID			INT				REFERENCES Employee(EmployeeID),
	ManageID			INT				REFERENCES PortfolioManager(ManagerID),
	Active				BIT				DEFAULT 0
);

/*Object: Table Stocks*/
CREATE TABLE Stocks(
	AccountID			INT				PRIMARY KEY IDENTITY,
	PortfolioID			INT				REFERENCES Portfolio(PortfolioID),
	TotalShares			INT				DEFAULT 0,
	Investment			MONEY			DEFAULT 0.00
);

/*Object: Table Portfolio*/
CREATE TABLE A401K(
	AccountID			INT				PRIMARY KEY IDENTITY,
	PortfolioID			INT				REFERENCES Portfolio(PortfolioID),
	AccountType			VARCHAR(20)		NOT NULL,
	Contribution		MONEY			DEFAULT 0.00,
	Investment			MONEY			DEFAULT 0.00,
	Matching			INT				DEFAULT 0
);
/*Object: Table Vacation*/
CREATE TABLE Vacation(
	AccountID			INT				PRIMARY KEY IDENTITY,
	PortfolioID			INT				REFERENCES Portfolio(PortfolioID),
	AccountType			VARCHAR(20)		NOT NULL,
	YearlyHours			INT				NOT NULL,
	CurrentHours		INT				NOT NULL,
	UsedHours			INT				DEFAULT 0
);

--Insert data

SET IDENTITY_INSERT CarRental ON;

INSERT INTO CarRental(CarRentalID, Car, InvoiceNum, Total) VALUES
(0, 'Honda Civic', '56478-15784', 328.15),
(1, 'Ford Fusion', '88521-11541', 116.05),
(2, 'Audi A3', '95142-75352', 84.25),
(3, 'Toyota Avalon', '55664-13975', 108.42),
(4, 'Bentley Continental', '14562-63256', 65.10),
(5, 'Suburu Crosstrek', '78495-95612', 845.15)

SET IDENTITY_INSERT CarRental OFF;


SET IDENTITY_INSERT HotelReservation ON;

INSERT INTO HotelReservation(HotelReservationID, Hotel, InvoiceNum, Total) VALUES
(0, '', '', 0),
(1, 'The Granny Smith Hotel', '125-451', 318.12),
(2, 'The Royal Hotel', '554-995', 242.50),
(3, 'Motel 8', '451-875', 456.18)

SET IDENTITY_INSERT HotelReservation OFF;


SET IDENTITY_INSERT AirlineReservation ON;

INSERT INTO AirlineReservation(AirlineReservationID, Airline, InvoiceNum, Total) VALUES
(0, '', '', 0),
(1, 'Jet Blue', '12-14', 224.84),
(2, 'Jet Blue', '18-22', 184.48)

SET IDENTITY_INSERT AirlineReservation OFF;


SET IDENTITY_INSERT Reimbursement ON;

INSERT INTO Reimbursement(ReimbursementID, CarRentalID, HotelReservationID, AirlineReservationID, Total) VALUES
(1000, 0, NULL, NULL, 328.15), (1001, NULL, NULL, NULL, 0), (1002, NULL, NULL, NULL, 0), 
(1003, NULL, NULL, NULL, 0), (1004, NULL, NULL, NULL, 0), (1005, NULL, NULL, NULL, 0), 
(1006, NULL, NULL, NULL, 0), (1007, NULL, NULL, NULL, 0), (1008, NULL, NULL, NULL, 0), 
(1009, NULL, NULL, NULL, 0), (1010, 1, 1, 1, 659.01), (1011, 2, 0, 0, 84.25), 
(1012, 3, 3, 0, 564.60), (1013, 4, 2, 0, 307.6), (1014, 5, 0, 2, 1029.63)

SET IDENTITY_INSERT Reimbursement OFF;


SET IDENTITY_INSERT Job ON;

INSERT INTO Job(JobID, Title, Salary, Benefits, WorkType, Quantity) VALUES
(1, 'Engineer', '68000.00', '401k, 3Weeks Vacation, No Stock', 'Full-time Job', 3),
(2, 'Tester', '72000.00', '401k, 3Weeks Vacation, Stock Options', 'Full-time Job', 2),
(3, 'Manager', '68000.00', '401k, 3Weeks Vacation, No Stock', 'Full-time Job', 1),
(4, 'HeadOfOperation', '72000.00', '401k, 3Weeks Vacation, Stock Options', 'Full-time Job', 0),
(5, 'Recruiter', '52000.00', '401k, 3Weeks Vacation, No Stock', 'Contract Based', 0),
(6, 'RecruitmentManager', '94000.00', '401k, 4Weeks Vacation, Stock Options', 'Full-time Job', 0),
(7, 'BudgetManager', '84000.00', '401k, 4Weeks Vacation, Stock Options', 'Contract Based', 1),
(8, 'PortfolioManager', '102000.00', '401k, 4Weeks Vacation, Stock Options', 'Full-time Job', 1),
(9, 'Engineer Intro', '32000.00', 'No Options', 'Summer Internship', 5)

SET IDENTITY_INSERT Job OFF;


SET IDENTITY_INSERT Offer ON;

INSERT INTO Offer (OfferID, JobID, Salary, Benefits, OfferStatus) VALUES
(0, 1, 70500.00, '401K, 3Weeks Vacation, No Stock', 'Accepted'),
(1, 7, 82000.00, '401K, 4Weeks Vacation, Stock Options', 'Accepted'),
(2, 8, 122000.00, '401K, 4Weeks Vacation, Sotck Options', 'Accepted')

SET IDENTITY_INSERT Offer OFF;


SET IDENTITY_INSERT Applicant ON;

INSERT INTO Applicant (ApplicantID, OfferID, ReimbursementID, FirstName, LastName, AddressLine, City, Zip, State, PhoneNumber, ApplicationStatus) VALUES
(1000, NULL, 1000, 'Sarah', 'Straus', '123 Mars Plaza', 'Red Valley', '65402-0001', 'S2', '110-101-0010', 'Interview 1'),
(1001, NULL, 1010, 'Kalif', 'Amede', '465 Rocky Road Lane', 'New Mars', '65423-8241', 'S1', '010-546-8524', 'Interview 1'),
(1002, NULL, 1011, 'George', 'Smithers', '121 Astroid Bend', 'New Mars', '65423-8241', 'S1', '010-328-2111', 'Interview 2'),
(1003, 0, 1012, 'Chris', 'Hemsworth', '876 Rockbury Plaze', 'Queens', '22542-1185', 'NY', '652-197-5375', 'Onboarding'),
(1004, 1, 1013, 'Bruce', 'Springstein', '8451 Man on the Moon Way', 'Manlius', '13104-0405', 'NY', '315-654-4512', 'Blacklisted'),
(1005, 2, 1014, 'Julia', 'Childs', '22 Burbank Circle', 'Port St. Lucie', '22525-1185', 'FL', '717-635-2212', 'Onboarded Successfully')

SET IDENTITY_INSERT Applicant OFF;


SET IDENTITY_INSERT Onboarding ON;

INSERT INTO Onboarding(OnboardingID, ApplicantID, RequiredDays, DaysFinished, Result) VALUES
(0, 1003, 100, 0, 'In Progress'),
(1, 1004, 100, 10, 'Blacklisted'),
(2, 1005, 100, 20, 'In Progess')

SET IDENTITY_INSERT Onboarding OFF;
/*
SET IDENTITY_INSERT Onboarding ON;

INSERT INTO Onboarding(OnboardingID, ApplicantID) VALUES
(1, 1000)

SET IDENTITY_INSERT Onboarding OFF;
*/

/*SET IDENTITY_INSERT Offer ON;

INSERT INTO Offer(OfferID, JobID, Salary, Benefits, OfferStatus) VALUES
(1, 101, '78000.72', '401K, 4Weeks Vacation, Stock Options', 'Not Initiated')

SET IDENTITY_INSERT Offer OFF;
*/


SET IDENTITY_INSERT Applications ON;

INSERT INTO Applications(ApplicationID, ApplicantID, JobID) VALUES
(1, 1000, 1),
(2, 1001, 1),
(3, 1002, 1),
(4, 1003, 1),
(5, 1004, 7),
(6, 1005, 8)

SET IDENTITY_INSERT Applications OFF;


SET IDENTITY_INSERT Employee ON;

INSERT INTO Employee(EmployeeID, ReimbursementID, FirstName, LastName, AddressLine, City, Zip, State, PhoneNumber, Position, WorkType) VALUES
(10000, 1001, 'Job', 'Malbec', '418 Endless Winter Rd', 'Pluto', '43285-1001', 'XY', '888-818-8118', 'HeadOfOperation', 'Full time job'),
(10001, 1002, 'Charlize', 'Theron', '585 Frozen Wastes Terrace', 'Pluto', '32881-3201', 'XY', '888-732-1117', 'Manager', 'Full time job'),
(10002, 1003, 'Mark', 'Twain', '818 Deep Freeze Lane', 'Pluto', '48495-1347', 'XY', '888-787-1234', 'Tester', 'Full time job'),
(10003, 1004, 'Nancy', 'Pelosi', '32 Furnace Fort', 'Mercury', '11188-0249', 'LK', '888-546-5189', 'Engineer', 'Full time job'),
(10004, 1005, 'Vladimir', 'Putin', '1321 Inferno Circle', 'Mercury', '11189-0001', 'LK', '888-142-1236', 'PortfolioManager', 'Full time job'),
(10005, 1006, 'Luigi', 'Plumier', '8451 Immolation Isle', 'Mercury', '85285-1001', 'AN', '888-321-4561', 'BudgetManager', 'Contract Based'),
(10006, 1007, 'Mario', 'Plumier', '755 Nowhere Lane', 'Earth', '13152-1301', 'NY', '888-852-9513', 'Recruiter', 'Contract Based'),
(10007, 1008, 'Red', 'August', '6541 In a Box Sqr', 'Earth', '14445-5461', 'NY', '888-963-1547', 'RecruitmentManager', 'Full time job'),
(10008, 1009, 'Henrich', 'Himmelpuff', 'Unknown', '???', '00000-0000', '??', '000-000-0000', 'Intro Engineer', 'Summer Internship')

SET IDENTITY_INSERT Employee OFF;


SET IDENTITY_INSERT Recruiter ON;

INSERT INTO Recruiter(RecruiterID, EmployeeID, Department) VALUES
(0, 10006, 'Building 3')

SET IDENTITY_INSERT Recruiter OFF;


SET IDENTITY_INSERT Interview ON;

INSERT INTO Interview(InterviewID, ApplicantID, RecruiterID, InterviewDate, ApplicantReview, InterviewerReview, InterviewType) VALUES
(1, 1000, 0, '2020-05-24 11:00:00', '', '', 'Engineer'),
(2, 1001, 0, '2020-05-25 02:30:00', '', '', 'Engineer'),
(3, 1002, 0, '2020-05-26 03:30:00', 'Tough interview. Feeling uneasy.', 'Not sure, lacking skills in application', '2nd Interview: Engineer'),
(4, 1003, 0, '2020-05-24 11:00:00', 'Seemed reasonable', 'Shows skill', 'Engineer'),
(5, 1004, 0, '2020-04-12 10:30:00', 'Too, easy. Numbers are OP.', 'Skilled at Financial Review', 'Interview Complete: Budget Manager'),
(6, 1005, 0, '2020-04-14 11:30:00', 'The interviewer semed unsure.', 'Shows applicable skill in the field', 'Interview Complete: Portfolio Manager')
SET IDENTITY_INSERT Interview OFF;

