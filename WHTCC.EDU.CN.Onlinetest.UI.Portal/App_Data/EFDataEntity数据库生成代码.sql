
------------------------------------------------ 生成数据库部分 ------------------------------------------------


use master -- 设置当前数据库为master,以便访问sysdatabases表
declare @OnLineTest varchar(20);
  set @OnLineTest='OnLineTest_Ver2';
if exists(select * from sysdatabases where name=@OnLineTest) 
drop database OnLineTest_Ver2;      
CREATE DATABASE OnLineTest_Ver2 ON  PRIMARY 
(
	 NAME = N'OnLineTest_Ver2', 
	 FILENAME = N'D:\OnLineTest_Ver2.mdf' , 
	 SIZE = 10240KB , 
	 FILEGROWTH = 1024KB 
 )
 LOG ON 
( 
	NAME = N'OnLineTest_Ver2_log', 
	FILENAME = N'D:\OnLineTest_Ver2_log.ldf' , 
	SIZE = 1024KB , 
	FILEGROWTH = 10%
)
use OnLineTest_Ver2
------------------------------------------------生成数据表部分----------------------------------------------

------------------------------------------------ 生成用户组表（UserGroup） ------------------------------------------------

if exists (select * from sysobjects where name='UserGroup')
drop table UserGroup
	CREATE TABLE UserGroup --用户组
	(
		Id int identity(1,1) primary key,--用户组Id int identity primary key
		UserGroupName varchar(50) not null unique,--用户组名称 varchar(20) unique
		UserGroupRemark varchar(max),--用户组备注
	)
------------------------------------------------ 生成用户等级表（UserRank）,根据用户的得分（UserScore）计算用户的等级 ------------------------------------------------

if exists (select*from sysobjects where name='UserRank')
drop table UserRank
	create table UserRank-----用户等级表
	(
		Id int identity(1,1) primary key,-----等级ID
		UserRankName varchar(50) not null unique,-----等级对应的中文名称
		MinScore int not null check(MinScore>=0),-----等级所对应的最低分
		MaxScore int not null check(MaxScore>=0),-----等级所对应的最高分
	)


------------------------------------------------ 生成用户表（Users,user是关键字，所以用users） ------------------------------------------------

if exists (select*from sysobjects where name='Users')
drop table Users
	CREATE TABLE Users
	(
		Id int identity(1,1) primary key,-----用户ID号
		UserName varchar(50) not null unique,-----登录名
		UserPassword varchar(200) not null,----登录密码，要求使用MD5格式存储
		UserChineseName varchar(50) not null default '-',------用户名称
		UserImagePath varchar(200) not null default('default.jpg'),
		UserEmail varchar(50) not null unique,-----用户电子邮件
		IsValidate bit not null default 0,-----是否通过电子邮件验证
		Tel varchar(20) null,
		UserScore int not null default 0 ,-----用户的论坛分值
		UserRegisterDatetime datetime not null default getdate(),-----用户注册时间
		UserLoginStatus bit not null default 0,------用户是否登录标记0为未登录,1为登录
		UserGroupId int not null default(1) foreign key references UserGroup(Id),
	)
GO
------------------------------------------------ 生成权限表（Authority） ------------------------------------------------

if exists (select*from sysobjects where name='Authority')
drop table Authority
	create table Authority-----权限表
	(
		Id int identity(1,1) primary key,-----权限ID
		AuthorityName varchar(50) not null,-----此项权限的中文名称
		AuthorityScore int  not null,-----此项权限（动作）所对应的分值(可以为负值)
		AuthorityHandlerPage varchar(50) not null unique,-----此项权限的处理页面
		AuthorityOrderNum int default 0,-------此项权限的排序号
		AuthorityRemark varchar(max),-----此项权限所的备注
	)
GO
  
------------------------------------------------ 生成用户权限表（UserAuthority） ------------------------------------------------   
    
if exists (select*from sysobjects where name='UserAuthority')
drop table UserAuthority
	create table UserAuthority-----用户权限表
	(
		Id int identity(1,1) primary key,-----用户权限ID
		AuthorityId int  not null foreign key references Authority(Id),-----外键，用户权限
		UserGroupId int not null foreign key references UserGroup(Id),-----用户权限所对应的用户组
		UserRankId int not null foreign key references UserRank(Id), -----此权限所对应的用户等级（外键）
		UserAuthoriryRemark varchar(max),-----用户权限备注
	)
GO

------------------------------------------------ 生成得分明细表（UserScoreDetail） ------------------------------------------------

if exists (select*from sysobjects where name='UserScoreDetail')
drop table UserScoreDetail
create table UserScoreDetail-----用户得分的详细记录
	(
		Id int identity(1,1) primary key,-----ID
		UserId int not null foreign key references Users(Id),-----用户ID
		UserAuthorityId int not null foreign key references UserAuthority(Id),-----用户权限，可以理解为执行的操作，可以根据每个操作的得分值判断得分情况
		UserScoreDetailTime datetime not null default getdate()-----执行操作的时间
	)
GO

------------------------------------------------ 生成站内信表(StationMail) ------------------------------------------------

if exists (select*from sysobjects where name='StationMail')
drop table StationMail
create table StationMail-----站内信
	(
		Id int identity(1,1) primary key,-----ID
		StationMailParentId int,-----如果是回复的话,标明回复哪一条站内信
		StationMailTO int not null foreign key references Users(Id),-----收信人
		StationMailFrom int not null foreign key references Users(Id),-----发信人
		StationMailContent varchar(max) not null,-----站内信内容
		StationMailSendTime datetime default getdate(),-----发信时间
		StationMailIsReaded bit not null default 0,-----是否阅读
		StationMailReadTime datetime,-- check(if(MessageIsRead==1)MessageReadTime not null),-----阅读时间
	)
GO
------------------------------------------------ 生成层级表（Level） ------------------------------------------------

if exists (select*from sysobjects where name='Level')
drop table Level
	create table Level-----试卷代码层级表
	(
	Id int identity(1,1) primary key,
	LevelName varchar(50) not null,---层级说明，包括船长，大副，二副等
	LevelRemark varchar(max),
	)

GO

------------------------------------------------ 生成科目表 ------------------------------------------------
           
if exists (select*from sysobjects where name='Subject')
drop table Subject
	create table Subject-----设置科目表
	(
		Id int identity(1,1) primary key,-----科目ID
		SubjectName varchar(50) not null,-----科目名称
		SubjectRemark varchar(max),-----科目备注
	)
------------------------------------------------ 生成试卷代码表（PaperCode） ------------------------------------------------

if exists (select*from sysobjects where name='PaperCode')
drop table PaperCode
	create table PaperCode-----试卷代码表
	(
		Id int identity(1,1) primary key,-----试卷代码ID
		LevelId int not null foreign key references Level(Id),---层级
		SubjectId int not null foreign key references Subject(Id),-----试卷代码所对应的科目ID，外键
		Code int not null unique,-----试卷代码
		ChineseName varchar(200) not null,-----试卷代码所对应的中文名称
		PaperCodePassScore int not null check(PaperCodePassScore>0),-----试卷代码的及格分数线
		PaperCodeTotalScore int not null, ---check(PaperCodeTotalScore>PaperCodePassScore),-----试卷代码的总分
		TimeRange int not null check(TimeRange>0),-----试卷代码考试的时长
		PaperCodeRemark varchar(max) null,-----试卷代码的备注
		constraint PaperCodeTotalScore_PaperCodePassScore_check check(PaperCodeTotalScore>PaperCodePassScore)
	)
GO

------------------------------------------------ 生成章节表（Chapter） ------------------------------------------------

if exists (select*from sysobjects where name='Chapter')
drop table Chapter
create table Chapter------教材所对应的章节表
	(
		Id int identity(1,1) primary key,-----章节ID
		ChapterName varchar(200) not null,-----章节名称
		ChapterParentNo int,-----父节点编号
		ChapterOrder int not null,----章节排序
		ChapterRemark varchar(max),-----备注
	)
GO
------------------------------------------------ 生成教学大纲表（Syllabus） ------------------------------------------------

if exists (select*from sysobjects where name='Syllabus')
drop table Syllabus
create table Syllabus------教学大纲：各层级各科目对应的章节关系
	(
	Id int identity(1,1) primary key,
	PaperCodeId int not null foreign key references PaperCode(Id),
	ChapterId int not null foreign key references Chapter(Id),
	SyllabusRemark varchar(max)
	)
GO

------------------------------------------------ 生成考区信息表（ExamZone） ------------------------------------------------

if exists (select*from sysobjects where name='ExamZone')
drop table ExamZone
create table ExamZone-----考区信息
	(
		Id int identity(1,1) primary key,-----ID
		ExamZoneName nvarchar(20) not null,-----考区名称
		ExamZoneRemark varchar(max)
	)
GO

------------------------------------------------ 生成真题信息表（PastExamPaper） ------------------------------------------------

if exists (select*from sysobjects where name='PastExamPaper')
drop table PastExamPaper
create table PastExamPaper-----历年真题信息（这里不包括试题信息）
	(
		Id int identity(1,1) primary key,-----ID
		ExamZoneId int not null foreign key references ExamZone(Id),-----真题对应的考区信息
		PaperCodeId int not null foreign key references PaperCode(Id),-----真题对应的试卷代码
		PastExamPaperPeriodNo int not null,-----期数
		PastExamPaperDatetime datetime not null,-----考试的时间
	)
GO

------------------------------------------------ 生成搜索热词表（SuggestionKeyword） ------------------------------------------------

if exists (select*from sysobjects where name='SuggestionKeyword')
drop table SuggestionKeyword
create table SuggestionKeyword-----搜索的热词
	(
		Id int identity(1,1) primary key,-----ID
		Keyword varchar(200) not null,-----热词//这里要注意长度的问题,varchar100,只能存50个字符,nvarchar100可以存100个
		SuggestionKeywordCreateTime datetime not null default getdate(),-----创建时间
		SuggestionKeywordNum int not null-----搜索次数
	)
GO

------------------------------------------------ 生成试题类型表（QuestionType,程序中生成一个枚举类型） ------------------------------------------------

if exists (select*from sysobjects where name='QuestionType')
drop table QuestionType
create table QuestionType-----试题类型
	(
	Id int identity(1,1) primary key,
	QuestionTypeDescrip varchar(20) not null,
	QuestionTypeRemark varchar(max)
	)
GO

------------------------------------------------ 生成试题难度系数表（Difficulty） ------------------------------------------------

if exists (select*from sysobjects where name='Difficulty')
drop table Difficulty
create table Difficulty-----试题的难度系数
	(
		Id int identity(1,1) primary key,-----难度系数ID
		DifficultyRatio int not null default 0 check( DifficultyRatio>=0 and DifficultyRatio<=10),-----难度系数0-10
		DifficultyDescrip varchar(50) not null,-----难度系数对应的描述
		DifficultyRemark varchar(max)-----备注
	)
GO

------------------------------------------------ 生成英语中的passage试题对应的短文（Passage） ------------------------------------------------

if exists (select*from sysobjects where name='Passage')
drop table Passage
create table Passage-----passage试题对应的短文
	(
	Id int identity(1,1)  primary key,
	PassageContent varchar(max) not null,
	PassageRemark varchar(max)
	)
GO

------------------------------------------------ QuestionFORGeneral试题的共性（QuestionFORGeneral） ------------------------------------------------

if exists (select*from sysobjects where name='QuestionFORGeneral')
drop table QuestionFORGeneral
create table QuestionFORGeneral----- QuestionFORGeneral试题的共性
	(
		Id int identity(1,1) primary key,-----试题ID
		QuestionType int not null foreign key references QuestionType(Id),----试题的类型
		QuestionTitle varchar(max) not null,-----题目
		Explain varchar(max),-----解析
		ImagePath varchar(200),-----图形名称
		DifficultyId int not null references Difficulty(Id),-----难度系数
		UserId int not null references Users(Id),-----上传人ID
		UpLoadTime datetime not null default getdate(),-----上传时间
		VerifyTimes int not null default 0,-----被审核次数（三次以上有效）
		IsDelte bit not null default 0,-----软删除标记
		IsSupported int not null default 0,-----被赞次数
		IsDeSupported int not null default 0,-----被踩次数
		PaperCodeId int not null references PaperCode(Id),-----试题所对应的试卷代码
		ChapterId int not null references Chapter(Id),-----试题所对应的章节
		PastExamPaperId int references PastExamPaper(Id),-----试题是否是历年真题
		PastExamQuestionId int, -----如果是真题，则在真题中的题号
		Remark varchar(max) ---------备注
	)
GO

------------------------------------------------ QuestionFORPanduan判断题（QuestionFORPanduan） ------------------------------------------------

if exists (select*from sysobjects where name='QuestionFORPanduan')
drop table QuestionFORPanduan
create table QuestionFORPanduan----- QuestionFORPanduan判断题
	(
	QuestionFORPanduanId int identity(1,1) primary key,
	QuestionFORGeneralId int not null foreign key references QuestionFORGeneral(Id),
	CorrectAnswer bit  not null
	)
GO

------------------------------------------------ QuestionFORDanxuan单选题（QuestionFORDanxuan） ------------------------------------------------

if exists (select*from sysobjects where name='QuestionFORDanxuan')
drop table QuestionFORDanxuan
create table QuestionFORDanxuan----- QuestionFORDanxuan单选题
	(
	QuestionFORDanxuanId int identity(1,1) primary key,
	QuestionFORGeneralId int not null foreign key references QuestionFORGeneral(Id),
	AnswerA varchar(max)  not null,
	AnswerB varchar(max)  not null,
	AnswerC varchar(max)  not null,
	AnswerD varchar(max)  not null,
	CorrectAnswer int  not null check(CorrectAnswer in(1,2,3,4))
	)
GO

------------------------------------------------ QuestionFORPassage英语中的passage试题（QuestionFORPassage） ------------------------------------------------

if exists (select*from sysobjects where name='QuestionFORPassage')
drop table QuestionFORPassage
create table QuestionFORPassage----- QuestionFORPassage英语中的passage试题
	(
	QuestionFORPassageId int identity(1,1) primary key,
	QuestionFORPassageExtendDanxuanId int not null foreign key references QuestionFORDanxuan(QuestionFORDanxuanId),
	PassageId int references Passage(Id)
	)
------------------------------------------------ 生成试题审核状态表（VerifyStatus） ------------------------------------------------

if exists (select*from sysobjects where name='VerifyStatus')
drop table VerifyStatus
create table VerifyStatus-----审核过程中的各个状态
	(
		Id int identity(1,1) primary key,-----审核状态ID
		QuestionId int not null references QuestionFORGeneral(Id),-----与试题库中对应的试题ID（要审核通过以后才能更新到试题库）
		UserId int not null references Users(Id),-----审核人ID
		Stamp bit not null default 0,-----是否通过标记
		VerifyTime datetime not null default getdate(),-----审核时间
		NewQuestinId int foreign key references  QuestionFORGeneral(Id),
		Remark varchar(max)
	)
GO

------------------------------------------------ 生成试题评论表（Comment） ------------------------------------------------

if exists (select*from sysobjects where name='Comment')
drop table Comment
create table Comment-----保存用户对试题的评论
	(
		Id int identity(1,1) primary key,-----ID
		QuestionId int not null references QuestionFORGeneral(Id),-----外键 试题ID
		UserId int not null references Users(Id),-----外键 用户ID
		CommentContent text not null,-----评论的内容
		CommentTime datetime not null default getdate(),-----发表评论的时间
		QuoteCommentId int null references Comment(Id),-----引用的评论
		IsDeleted bit not null default 0,-----是否删除	
		DeleteUserId int null references Users(Id),-----外键 删除评论人
		DeleteCommentTime datetime null -----删除评论时间
	)
GO

------------------------------------------------ 生成UserCreatePaper用户创建的试卷 ------------------------------------------------

if exists (select*from sysobjects where name='UserCreatePaper')
drop table UserCreatePaper
create table UserCreatePaper-----用于保存用户生成试卷信息（不包含试题信息）
	(
		Id int identity(1,1) primary key,-----ID
		UserId int not null references Users(Id),-----用户ID
		PaperCodeId int not null references PaperCode(Id),-----试卷代码Id
		DifficultyId int not null references Difficulty(Id),-----难度系数
		UserCreatePaperTime datetime not null default getdate()-----生成时间
	)
GO

------------------------------------------------ 生成UserCreatePaperQuestion用户创建试卷内包含的试题 ------------------------------------------------

if exists (select*from sysobjects where name='UserCreatePaperQuestione')
drop table UserCreatePaperQuestione
create table UserCreatePaperQuestione-----保存用户生成试卷信息（包含试题信息）
	(
		Id int identity(1,1) primary key,-----ID
		UserCreatePaperId int not null references UserCreatePaper(Id),-----试卷信息ID
		QuestionId int not null references QuestionFORGeneral(Id)-----试题ID
	)
GO

------------------------------------------------ 生成练习记录表（LogPractice） ------------------------------------------------

if exists (select*from sysobjects where name='LogPractice')
drop table LogPractice
create table LogPractice-----保存练习的习题
	(
		Id int identity(1,1) primary key,-----ID
		UserId int not null references Users(Id),-----用户ID
		QuestionId int not null references QuestionFORGeneral(Id),-----试题ID
		LogPracticeTime datetime not null default getdate(),-----练习时间
		LogPracticeAnswer int,-----练习时给出的答案
		LogPracetimeRemark text null-----备注
	)
GO

------------------------------------------------ 生成测试记录表（LogTest） ------------------------------------------------

if exists (select*from sysobjects where name='LogTest')
drop table LogTest
create table LogTest-----保存平时测试信息（不包含测试试题）
	(
		Id int identity(1,1) primary key,-----ID
		UserId int not null references Users(Id),-----用户ID
		UserCreatePaperId int not null foreign key references UserCreatePaper(Id),---哪一套试卷
		LogTestStartTime datetime not null default getdate(),-----测试时间
        LogTestEndTime datetime null,		
		LogTestScore int not null default 0-----测试的得分，默认为0分
	)
GO

------------------------------------------------ 生成测试用户答案表 ------------------------------------------------

if exists (select*from sysobjects where name='LogTestUserAnswer')
drop table LogTestUserAnswer
create table LogTestUserAnswer-----保存平时测试信息（包含试题信息）
	(
		Id int identity(1,1) primary key,-----ID
		LogTestId int not null references LogTest(Id),-----外键 测试信息ID
		QuestionId int not null references QuestionFORGeneral(Id),-----外键 试题ID
		UserAnswer int,-----测试时给出的答案
		LogTestUserAnswerRemark varchar(max)-----备注
	)
GO

------------------------------------------------ 生成用户登录记录表 ------------------------------------------------

if exists (select*from sysobjects where name='LogLogin')
drop table LogLogin
create table LogLogin-----登录记录
	(
		Id int identity(1,1) primary key,-----ID
		UserId int not null references Users(Id),-----用户ID
		LogLoginTime datetime not null default getdate(),-----登录时间
		LogLogoutTime datetime,-----登出时间
		LogLoginIp varchar(20) not null default('127.0.0.1'),-----登录IP
		LogLoginOperatiionSystem nvarchar(200) null,-----登录时所用的操作系统
		LogLoginWebServerClient varchar(100) null,-----登录时所用的浏览器类型
		Remark varchar(100) null-----备注
	)