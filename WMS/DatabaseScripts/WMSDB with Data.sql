USE [master]
GO
/****** Object:  Database [WMSDB]    Script Date: 10/24/2020 11:24:36 PM ******/
CREATE DATABASE [WMSDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WMSDB', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\WMSDB.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'WMSDB_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\WMSDB_log.ldf' , SIZE = 1072KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [WMSDB] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WMSDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WMSDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WMSDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WMSDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WMSDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WMSDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [WMSDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WMSDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WMSDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WMSDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WMSDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WMSDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WMSDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WMSDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WMSDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WMSDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [WMSDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WMSDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WMSDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WMSDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WMSDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WMSDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WMSDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WMSDB] SET RECOVERY FULL 
GO
ALTER DATABASE [WMSDB] SET  MULTI_USER 
GO
ALTER DATABASE [WMSDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WMSDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WMSDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WMSDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [WMSDB] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'WMSDB', N'ON'
GO
USE [WMSDB]
GO
/****** Object:  User [AbdHsn-dbms]    Script Date: 10/24/2020 11:24:36 PM ******/
CREATE USER [AbdHsn-dbms] FOR LOGIN [AbdHsn-dbms] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Authorizations]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Authorizations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[AuthorizeTypeId] [int] NULL,
	[IsActive] [bit] NULL,
	[AuthorizedBy] [bigint] NULL,
	[AuthorizedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AuthorizeType]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthorizeType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK__Authoriz__3214EC07D16DE750] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Brand]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brand](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[SmallImage] [nvarchar](100) NULL,
	[BigImage] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentCategory] [nvarchar](15) NULL,
	[SubCategory] [nvarchar](15) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](30) NULL,
	[Branch] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Address] [nvarchar](250) NULL,
	[Telephone] [nvarchar](15) NULL,
	[Mobile] [nvarchar](20) NULL,
	[Fax] [nvarchar](20) NULL,
	[Website] [nvarchar](100) NULL,
	[SmallLogo] [nvarchar](100) NULL,
	[BigLogo] [nvarchar](100) NULL,
	[RegistrationNo] [nvarchar](20) NULL,
 CONSTRAINT [PK__Company__3214EC07BF66F468] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[ICNo] [nvarchar](20) NULL,
	[Phone] [nvarchar](15) NULL,
	[Email] [nvarchar](50) NULL,
	[Telephone] [nvarchar](15) NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NULL,
	[PostalCode] [int] NULL,
	[Address] [nvarchar](200) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Damage]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Damage](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DamageNo] [nvarchar](20) NULL,
	[ProductItemId] [bigint] NULL,
	[DamagedDate] [datetime] NULL,
	[Note] [nvarchar](100) NULL,
	[InsertedBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ItemSpace]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemSpace](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[ReckId] [bigint] NULL,
	[ReckLevel] [int] NULL,
	[ProductItemId] [bigint] NULL,
	[IsAllocated] [bit] NULL,
	[LastUpdate] [datetime] NULL,
	[ActionedBy] [bigint] NULL,
 CONSTRAINT [PK__ItemSpac__3214EC07BF3872E1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ManufacturerName] [nvarchar](100) NULL,
	[ContactInfo] [nvarchar](150) NULL,
	[SmallImage] [nvarchar](100) NULL,
	[BigImage] [nvarchar](100) NULL,
 CONSTRAINT [PK__Manufact__3214EC0773B0D4A8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderId] [bigint] NULL,
	[WarehouseId] [int] NULL,
	[ProductId] [bigint] NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[CollectionDate] [datetime] NULL,
	[VatId] [int] NULL,
	[VatRate] [decimal](18, 2) NULL,
	[VatAmount] [decimal](18, 2) NULL,
	[DiscountId] [int] NULL,
	[DiscountRate] [decimal](18, 2) NULL,
	[DiscountAmount] [decimal](18, 2) NULL,
	[Total] [decimal](18, 2) NULL,
	[ProductStatus] [nvarchar](15) NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK__OrderDet__3214EC0750AB980F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDispatch]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDispatch](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderId] [bigint] NULL,
	[DispatchNo] [nvarchar](20) NULL,
	[DispatchDate] [datetime] NULL,
	[Status] [nvarchar](25) NULL,
	[DispatchBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDispatchDetails]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDispatchDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DispatchId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[ProductItemId] [bigint] NULL,
	[ItemSpaceId] [bigint] NULL,
	[ProductStatus] [nvarchar](15) NULL,
	[LastUpdate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderReturn]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderReturn](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderId] [bigint] NULL,
	[ReturnNo] [nvarchar](20) NULL,
	[ReturnDate] [datetime] NULL,
	[Status] [nvarchar](25) NULL,
	[ReturnBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderReturnDetails]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderReturnDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ReturnId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[ProductItemId] [bigint] NULL,
	[ItemSpaceId] [bigint] NULL,
	[ProductStatus] [nvarchar](15) NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK__OrderRet__3214EC07337AB2CE] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](20) NULL,
	[UserId] [bigint] NULL,
	[VatId] [int] NULL,
	[VatRate] [decimal](18, 2) NULL,
	[VatAmount] [decimal](18, 2) NULL,
	[DiscountId] [int] NULL,
	[DiscountRate] [decimal](18, 2) NULL,
	[DiscountAmount] [decimal](18, 2) NULL,
	[GrandTotal] [decimal](18, 2) NULL,
	[BillingAddress] [nvarchar](250) NULL,
	[CollectionDate] [datetime] NULL,
	[OrderPlaceDate] [datetime] NULL,
	[UpdateBy] [bigint] NULL,
	[LastUpdate] [datetime] NULL,
	[OrderStatus] [nvarchar](15) NULL,
	[Note] [nvarchar](100) NULL,
 CONSTRAINT [PK__Orders__3214EC075E37C4E7] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payment]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionNo] [nvarchar](20) NULL,
	[TransactionDate] [datetime] NULL,
	[UserId] [bigint] NULL,
	[InstrumentNo] [nvarchar](25) NULL,
	[TableReference] [nvarchar](30) NULL,
	[PaidAmount] [decimal](18, 2) NULL,
	[PaymentMethodId] [int] NULL,
 CONSTRAINT [PK__Payment__3214EC0757C1D835] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PaymentMethods]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethods](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NULL,
	[LogoPath] [nvarchar](20) NULL,
	[Description] [nvarchar](100) NULL,
	[Url] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PersonalDetail]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonalDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[Gender] [nvarchar](10) NULL,
	[MobileNo] [nvarchar](30) NULL,
	[OtherPhone] [nvarchar](100) NULL,
	[DOB] [date] NULL,
	[Address] [nvarchar](200) NULL,
	[Language] [nvarchar](20) NULL,
	[MaritalStatus] [nvarchar](15) NULL,
 CONSTRAINT [PK__Personal__3214EC07BBEEA3FF] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductInsertion]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductInsertion](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductId] [bigint] NULL,
	[EntryNo] [nvarchar](20) NULL,
	[Quantity] [int] NULL,
	[EntryDate] [datetime] NULL,
	[Note] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductItems]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductItems](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductId] [bigint] NULL,
	[ItemSerial] [nvarchar](30) NULL,
	[PackSerial] [nvarchar](40) NULL,
	[ManualSerial] [nvarchar](40) NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [nvarchar](15) NULL,
 CONSTRAINT [PK__ProductI__3214EC0740F94A5F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductCode] [nvarchar](6) NULL,
	[Name] [nvarchar](50) NULL,
	[ProductTypeId] [int] NULL,
	[BrandId] [int] NULL,
	[ManufacturerId] [bigint] NULL,
	[Description] [nvarchar](max) NULL,
	[SmallImage] [nvarchar](100) NULL,
	[BigImage] [nvarchar](100) NULL,
	[CostPrice] [decimal](18, 2) NULL,
	[SellingPrice] [decimal](18, 2) NULL,
	[MetaTags] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK__Products__3214EC0709B71212] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductType]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](100) NULL,
 CONSTRAINT [PK_ProductType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reck]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reck](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[ReckName] [nvarchar](20) NULL,
	[SetupRow] [int] NULL,
	[SetupColumn] [int] NULL,
	[ReckLevel] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Reck__3214EC07891A7B7F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Refunds]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Refunds](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SalesReturnId] [bigint] NULL,
	[RefundNo] [nvarchar](20) NULL,
	[SalesReturnNo] [nvarchar](20) NULL,
	[RefundAmount] [decimal](18, 2) NULL,
	[RefundedDate] [datetime] NULL,
	[RefundedBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesReturn]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesReturn](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SalesReturnNo] [nvarchar](20) NULL,
	[OrderNo] [nvarchar](20) NULL,
	[ProductSerial] [nvarchar](20) NULL,
	[ProductId] [bigint] NULL,
	[CustomerId] [bigint] NULL,
	[Quantity] [int] NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[ReturnDate] [datetime] NULL,
	[Status] [nvarchar](15) NULL,
	[Reason] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesTransaction]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesTransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SaleTransactionNo] [nvarchar](20) NULL,
	[OrderId] [bigint] NULL,
	[CustomerId] [bigint] NULL,
	[PaymentMethodId] [int] NULL,
	[PaidAmount] [decimal](18, 2) NULL,
	[TransactionDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Stock]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[ProductId] [bigint] NULL,
	[AvailableQuantity] [int] NULL,
	[LastQuantity] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
 CONSTRAINT [PK_Stock] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockAdjustment]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockAdjustment](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AdjustmentNo] [nvarchar](20) NULL,
	[WarehouseId] [int] NULL,
	[ProductId] [bigint] NULL,
	[Quantity] [int] NULL,
	[TargetOnEffect] [nvarchar](15) NULL,
	[Note] [nvarchar](100) NULL,
	[CreatedBy] [bigint] NULL,
	[EntryDate] [datetime] NULL,
 CONSTRAINT [PK_StockAdjustment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockTrace]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockTrace](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[ProductId] [bigint] NULL,
	[CurrentQuantity] [int] NULL,
	[OpeningQuantity] [int] NULL,
	[ClosingQuantity] [int] NULL,
	[ReferenceId] [nvarchar](100) NULL,
	[TableReference] [nvarchar](30) NULL,
	[Note] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK__Stock__3214EC0753C75877] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](20) NULL,
	[SupplierName] [nvarchar](20) NULL,
	[Phone] [nvarchar](15) NULL,
	[Telephone] [nvarchar](15) NULL,
	[Fax] [nvarchar](15) NULL,
	[Email] [nvarchar](15) NULL,
	[Address] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](200) NULL,
	[UserTypeId] [int] NULL,
	[Email] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Password] [nvarchar](100) NULL,
	[TempField] [nvarchar](50) NULL,
	[SmallImage] [nvarchar](100) NULL,
	[BigImage] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK__Users__3214EC07D9707F2D] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserType]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](30) NULL,
 CONSTRAINT [PK__UserType__3214EC0728DF2775] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Vat]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vat](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](10) NULL,
	[VatRate] [decimal](18, 2) NULL,
	[Description] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VirtualSpace]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VirtualSpace](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductItemId] [bigint] NULL,
	[FromOrderId] [bigint] NULL,
	[Status] [nvarchar](15) NULL,
	[InsertedDate] [datetime] NULL,
	[InsertedBy] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](100) NULL,
	[Location] [nvarchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Warehous__3214EC07C97433E0] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WarehouseCapacityDefination]    Script Date: 10/24/2020 11:24:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WarehouseCapacityDefination](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WarehouseId] [int] NULL,
	[Row] [int] NULL,
	[Column] [int] NULL,
	[ReckQuantity] [int] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Warehous__3214EC072CA29D23] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Brand] ON 

INSERT [dbo].[Brand] ([Id], [Name], [SmallImage], [BigImage]) VALUES (1, N'Brand 01', NULL, NULL)
INSERT [dbo].[Brand] ([Id], [Name], [SmallImage], [BigImage]) VALUES (2, N'Brand 02', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Brand] OFF
SET IDENTITY_INSERT [dbo].[Company] ON 

INSERT [dbo].[Company] ([Id], [Name], [Branch], [Description], [Address], [Telephone], [Mobile], [Fax], [Website], [SmallLogo], [BigLogo], [RegistrationNo]) VALUES (1, N'Global Warehouse Manager', N'Uttara', NULL, N'4/13/Cha, West Vasantak', N'009992334', N'+8801767439445', NULL, N'www.abdullahbinhasan.xyz', N'StaticFiles/Company/SmallImage/7.bmp', N'StaticFiles/Company/BigImage/7.bmp', N'4344433')
SET IDENTITY_INSERT [dbo].[Company] OFF
SET IDENTITY_INSERT [dbo].[Damage] ON 

INSERT [dbo].[Damage] ([Id], [DamageNo], [ProductItemId], [DamagedDate], [Note], [InsertedBy]) VALUES (2, N'DMG-2020100000000001', 64, CAST(N'2020-10-20 11:41:16.620' AS DateTime), N'Generated from Virtual Store', NULL)
INSERT [dbo].[Damage] ([Id], [DamageNo], [ProductItemId], [DamagedDate], [Note], [InsertedBy]) VALUES (3, N'DMG-2020100000000002', 48, CAST(N'2020-10-20 16:18:27.563' AS DateTime), N'Manual damage test.......', NULL)
INSERT [dbo].[Damage] ([Id], [DamageNo], [ProductItemId], [DamagedDate], [Note], [InsertedBy]) VALUES (4, N'DMG-2020100000000003', 68, CAST(N'2020-10-21 05:51:19.937' AS DateTime), N'Damage test....', NULL)
SET IDENTITY_INSERT [dbo].[Damage] OFF
SET IDENTITY_INSERT [dbo].[ItemSpace] ON 

INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (1, 1, 3, 1, 49, 1, CAST(N'2020-10-12 12:52:00.273' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (2, 1, 3, 2, NULL, 0, CAST(N'2020-10-20 16:18:36.470' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (3, 1, 3, 3, NULL, 0, CAST(N'2020-10-20 05:43:09.360' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (4, 1, 3, 4, NULL, 0, CAST(N'2020-10-20 05:43:09.423' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (5, 1, 3, 5, NULL, 0, CAST(N'2020-10-20 16:23:05.687' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (6, 1, 4, 1, 58, 1, CAST(N'2020-10-12 14:32:22.877' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (7, 1, 4, 2, 59, 1, CAST(N'2020-10-12 14:32:22.893' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (8, 1, 4, 3, 60, 1, CAST(N'2020-10-12 14:32:22.907' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (9, 1, 4, 4, NULL, 0, CAST(N'2020-10-20 06:10:18.777' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (10, 1, 4, 5, 65, 1, CAST(N'2020-10-12 20:46:03.067' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (11, 7, 5, 1, 39, 1, CAST(N'2020-10-21 05:46:19.023' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (12, 7, 5, 2, 38, 1, CAST(N'2020-10-21 05:47:20.017' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (13, 7, 5, 3, 40, 1, CAST(N'2020-09-19 15:20:12.470' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (14, 7, 5, 4, 41, 1, CAST(N'2020-09-19 15:20:12.480' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (15, 7, 5, 5, 42, 1, CAST(N'2020-09-19 15:20:12.490' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (16, 7, 5, 6, 43, 1, CAST(N'2020-09-19 15:20:12.500' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (17, 7, 5, 7, 44, 1, CAST(N'2020-09-19 15:20:12.513' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (18, 7, 6, 1, 45, 1, CAST(N'2020-09-19 15:20:12.520' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (19, 7, 6, 2, 46, 1, CAST(N'2020-09-19 15:20:12.530' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (20, 7, 6, 3, 10067, 1, CAST(N'2020-10-21 06:42:40.970' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (21, 7, 6, 4, 70, 1, CAST(N'2020-10-15 16:16:19.847' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (22, 7, 6, 5, 67, 1, CAST(N'2020-10-15 15:31:11.510' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (23, 7, 6, 6, 37, 1, CAST(N'2020-10-17 02:23:52.260' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (24, 7, 6, 7, 69, 1, CAST(N'2020-10-15 15:41:35.087' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (25, 8, 7, 1, NULL, 0, CAST(N'2020-10-21 05:43:08.437' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (26, 8, 7, 2, 62, 1, CAST(N'2020-10-12 15:02:23.600' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (27, 8, 7, 3, 63, 1, CAST(N'2020-10-12 15:02:23.610' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (28, 8, 7, 4, 57, 1, CAST(N'2020-10-20 08:36:48.273' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (29, 8, 8, 1, NULL, 0, CAST(N'2020-10-20 05:43:09.460' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (30, 8, 8, 2, 52, 1, CAST(N'2020-09-19 15:25:54.087' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (31, 8, 8, 3, 53, 1, CAST(N'2020-09-19 15:27:19.350' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (32, 8, 8, 4, 55, 1, CAST(N'2020-09-19 15:30:19.407' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[ItemSpace] OFF
SET IDENTITY_INSERT [dbo].[Manufacturer] ON 

INSERT [dbo].[Manufacturer] ([Id], [ManufacturerName], [ContactInfo], [SmallImage], [BigImage]) VALUES (1, N'Manufacturer 01', NULL, NULL, NULL)
INSERT [dbo].[Manufacturer] ([Id], [ManufacturerName], [ContactInfo], [SmallImage], [BigImage]) VALUES (2, N'Manufacturer 02', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Manufacturer] OFF
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (1, 1, 8, 8, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 10:46:00.293' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (2, 1, 1, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 10:46:07.877' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (3, 2, 1, 5, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-21 05:42:20.540' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (4, 2, 1, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-21 05:42:20.563' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (5, 3, 8, 8, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 16:30:37.040' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (6, 3, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 16:30:37.077' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (7, 4, 8, 8, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:32:52.063' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (8, 4, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:32:52.093' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (9, 5, 1, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:35:48.707' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (10, 5, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:36:08.143' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (11, 6, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 13:25:42.207' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (12, 7, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-13 13:49:02.470' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (16, 11, 8, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-21 05:43:08.440' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (18, 14, 8, 9, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Submitted', NULL)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (19, 15, 1, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 19:33:29.500' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (20, 16, 1, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 19:30:50.613' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (21, 17, 1, 10, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 19:36:52.327' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (22, 18, 1, 10, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 20:08:02.543' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (23, 19, 1, 10, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 20:20:32.420' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (24, 20, 1, 10, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-12 20:30:18.523' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (25, 21, 1, 10, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-12 20:36:55.913' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (26, 22, 1, 10, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-20 06:10:18.797' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (27, 23, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-14 16:16:14.700' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (28, 23, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-14 16:16:14.710' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (10026, 10022, 1, 1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-20 05:43:09.430' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (10027, 10022, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-20 05:43:09.463' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (10028, 10023, 7, 7, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-21 04:59:32.070' AS DateTime))
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
SET IDENTITY_INSERT [dbo].[OrderDispatch] ON 

INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (1, 2, N'DIS-2020090000000001', CAST(N'2020-10-07 15:30:22.243' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (2, 4, N'DIS-2020100000000002', CAST(N'2020-10-07 16:32:50.133' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (4, 5, N'DIS-2020100000000003', CAST(N'2020-10-07 16:35:36.067' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (5, 21, N'DIS-2020100000000004', CAST(N'2020-10-12 20:34:36.743' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (6, 21, N'DIS-2020100000000005', CAST(N'2020-10-12 20:36:55.897' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (7, 7, N'DIS-2020100000000006', CAST(N'2020-10-13 13:49:02.207' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (8, 23, N'DIS-2020100000000007', CAST(N'2020-10-14 16:16:14.563' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (10007, 10022, N'DIS-2020100000000008', CAST(N'2020-10-20 05:43:09.020' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (10008, 22, N'DIS-2020100000000009', CAST(N'2020-10-20 06:10:18.613' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (10009, 10023, N'DIS-2020100000000010', CAST(N'2020-10-21 04:59:31.823' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (10010, 11, N'DIS-2020100000000011', CAST(N'2020-10-21 05:43:08.423' AS DateTime), N'FullDispatch', NULL)
SET IDENTITY_INSERT [dbo].[OrderDispatch] OFF
SET IDENTITY_INSERT [dbo].[OrderDispatchDetails] ON 

INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (1, 1, 5, 31, 3, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (2, 1, 5, 32, 4, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (3, 1, 2, 36, 6, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (4, 2, 8, 47, 25, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (5, 2, 8, 48, 26, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (6, 2, 1, 29, 1, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (7, 4, 2, 37, 7, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (8, 4, 8, 49, 27, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (9, 5, 10, 64, 9, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10, 5, 10, 65, 10, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (11, 7, 1, 30, 2, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (12, 8, 8, 50, 28, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (13, 8, 1, 33, 5, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10011, 10007, 1, 56, 3, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10012, 10007, 1, 57, 4, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10013, 10007, 8, 51, 29, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10014, 10008, 10, 64, 9, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10015, 10009, 7, 38, 11, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10016, 10009, 7, 39, 12, N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatchDetails] ([Id], [DispatchId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10017, 10010, 9, 61, 25, N'FullDispatch', NULL)
SET IDENTITY_INSERT [dbo].[OrderDispatchDetails] OFF
SET IDENTITY_INSERT [dbo].[OrderReturn] ON 

INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (2, 5, N'RTN-2020100000000001', CAST(N'2020-10-12 12:45:37.937' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (3, 5, N'RTN-2020100000000002', CAST(N'2020-10-12 12:51:40.203' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (4, 21, N'RTN-2020100000000003', CAST(N'2020-10-12 20:46:02.990' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (5, 4, N'RTN-2020100000000004', CAST(N'2020-10-14 14:02:06.020' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10005, 22, N'RTN-2020100000000005', CAST(N'2020-10-20 06:15:13.823' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10006, 22, N'RTN-2020100000000006', CAST(N'2020-10-20 06:18:00.600' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10007, 23, N'RTN-2020100000000007', CAST(N'2020-10-20 07:02:37.450' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10008, 10022, N'RTN-2020100000000008', CAST(N'2020-10-20 08:35:34.313' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10009, 10022, N'RTN-2020100000000009', CAST(N'2020-10-20 08:36:48.233' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10010, 10023, N'RTN-2020100000000010', CAST(N'2020-10-21 05:39:52.043' AS DateTime), NULL, NULL)
INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (10011, 10023, N'RTN-2020100000000011', CAST(N'2020-10-21 05:47:20.007' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[OrderReturn] OFF
SET IDENTITY_INSERT [dbo].[OrderReturnDetails] ON 

INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (2, 2, 2, 37, NULL, N'FullReturn', CAST(N'2020-10-12 12:45:44.077' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (3, 3, 8, 49, NULL, N'FullReturn', CAST(N'2020-10-12 12:51:53.800' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (4, 4, 10, 64, 2, N'FullReturn', CAST(N'2020-10-12 20:46:03.003' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (5, 4, 10, 65, 3, N'FullReturn', CAST(N'2020-10-12 20:46:03.063' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (6, 5, 8, 48, NULL, N'FullReturn', CAST(N'2020-10-14 14:02:06.100' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (7, 10005, 10, 64, NULL, N'FullReturn', CAST(N'2020-10-20 06:15:13.833' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (9, 10007, 8, 50, NULL, N'FullReturn', CAST(N'2020-10-20 07:02:37.513' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (10, 10008, 1, 56, NULL, N'FullReturn', CAST(N'2020-10-20 08:35:34.370' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (11, 10009, 1, 57, 28, N'FullReturn', CAST(N'2020-10-20 08:36:48.257' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (12, 10010, 7, 39, NULL, N'FullReturn', CAST(N'2020-10-21 05:39:52.087' AS DateTime))
INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ItemSpaceId], [ProductStatus], [LastUpdate]) VALUES (13, 10011, 7, 38, 12, N'FullReturn', CAST(N'2020-10-21 05:47:20.010' AS DateTime))
SET IDENTITY_INSERT [dbo].[OrderReturnDetails] OFF
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (1, N'ORD-2020090000000001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-09-30 13:10:42.733' AS DateTime), CAST(N'2020-09-30 19:10:42.540' AS DateTime), NULL, CAST(N'2020-10-07 10:46:10.803' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (2, N'ORD-2020100000000002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 10:52:09.247' AS DateTime), CAST(N'2020-10-07 16:52:09.247' AS DateTime), NULL, CAST(N'2020-10-21 05:42:20.567' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (3, N'ORD-2020100000000003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:17:07.443' AS DateTime), CAST(N'2020-10-07 22:17:07.443' AS DateTime), NULL, CAST(N'2020-10-07 16:30:37.083' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (4, N'ORD-2020100000000004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:31:55.610' AS DateTime), CAST(N'2020-10-07 22:31:55.610' AS DateTime), NULL, CAST(N'2020-10-07 16:32:52.100' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (5, N'ORD-2020100000000005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:34:39.457' AS DateTime), CAST(N'2020-10-07 22:34:39.457' AS DateTime), NULL, CAST(N'2020-10-07 16:36:13.597' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (6, N'ORD-2020100000000006', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 13:23:07.783' AS DateTime), CAST(N'2020-10-12 19:23:07.783' AS DateTime), NULL, CAST(N'2020-10-12 13:25:42.213' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (7, N'ORD-2020100000000007', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 13:28:14.440' AS DateTime), CAST(N'2020-10-12 19:28:14.440' AS DateTime), NULL, CAST(N'2020-10-13 13:49:02.483' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (11, N'ORD-2020100000000008', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 15:03:34.393' AS DateTime), CAST(N'2020-10-12 21:03:34.393' AS DateTime), NULL, CAST(N'2020-10-21 05:43:08.443' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (14, N'ORD-2020100000000009', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 18:17:32.443' AS DateTime), CAST(N'2020-10-13 00:17:32.443' AS DateTime), NULL, NULL, N'Submitted', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (15, N'ORD-2020100000000010', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 18:43:02.780' AS DateTime), CAST(N'2020-10-13 00:43:02.780' AS DateTime), NULL, CAST(N'2020-10-12 19:33:29.517' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (16, N'ORD-2020100000000011', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 18:44:20.810' AS DateTime), CAST(N'2020-10-13 00:44:20.810' AS DateTime), NULL, CAST(N'2020-10-12 19:30:50.630' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (17, N'ORD-2020100000000012', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 19:35:34.723' AS DateTime), CAST(N'2020-10-13 01:35:34.723' AS DateTime), NULL, CAST(N'2020-10-12 19:36:52.343' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (18, N'ORD-2020100000000013', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 20:07:40.020' AS DateTime), CAST(N'2020-10-13 02:07:40.020' AS DateTime), NULL, CAST(N'2020-10-12 20:08:02.657' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (19, N'ORD-2020100000000014', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 20:15:23.813' AS DateTime), CAST(N'2020-10-13 02:15:23.813' AS DateTime), NULL, CAST(N'2020-10-12 20:20:32.790' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (20, N'ORD-2020100000000015', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 20:25:29.607' AS DateTime), CAST(N'2020-10-13 02:25:29.607' AS DateTime), NULL, CAST(N'2020-10-12 20:30:18.530' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (21, N'ORD-2020100000000016', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-12 20:34:07.323' AS DateTime), CAST(N'2020-10-13 02:34:07.323' AS DateTime), NULL, CAST(N'2020-10-12 20:36:55.920' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (22, N'ORD-2020100000000017', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-14 12:23:14.967' AS DateTime), CAST(N'2020-10-14 18:23:14.967' AS DateTime), NULL, CAST(N'2020-10-20 06:10:18.807' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (23, N'ORD-2020100000000018', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-14 12:29:53.520' AS DateTime), CAST(N'2020-10-14 18:29:53.520' AS DateTime), NULL, CAST(N'2020-10-14 16:16:14.710' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (10022, N'ORD-2020100000000019', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-20 04:56:14.837' AS DateTime), CAST(N'2020-10-20 10:56:14.837' AS DateTime), NULL, CAST(N'2020-10-20 05:43:09.477' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (10023, N'ORD-2020100000000020', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-21 04:31:20.173' AS DateTime), CAST(N'2020-10-21 10:31:20.173' AS DateTime), NULL, CAST(N'2020-10-21 04:59:32.077' AS DateTime), N'FullDispatch', NULL)
SET IDENTITY_INSERT [dbo].[Orders] OFF
SET IDENTITY_INSERT [dbo].[PersonalDetail] ON 

INSERT [dbo].[PersonalDetail] ([Id], [UserId], [Gender], [MobileNo], [OtherPhone], [DOB], [Address], [Language], [MaritalStatus]) VALUES (1, 1, N'Male', N'01767439445', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[PersonalDetail] ([Id], [UserId], [Gender], [MobileNo], [OtherPhone], [DOB], [Address], [Language], [MaritalStatus]) VALUES (2, 2, N'Male', N'00234234', NULL, CAST(N'2001-08-28' AS Date), N'Test Addresss..', NULL, NULL)
SET IDENTITY_INSERT [dbo].[PersonalDetail] OFF
SET IDENTITY_INSERT [dbo].[ProductInsertion] ON 

INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (14, 1, N'ENT-2020090000000001', 2, CAST(N'2020-09-18 17:19:39.227' AS DateTime), N'ssss')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (15, 5, N'ENT-2020090000000002', 2, CAST(N'2020-09-18 17:33:59.957' AS DateTime), N'ss')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (16, 1, N'ENT-2020090000000003', 1, CAST(N'2020-09-18 17:36:34.983' AS DateTime), N'sss')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (17, 1, N'ADJ-2020090000000001', 2, NULL, N'Auto generated from stock adjustment.')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (18, 2, N'ENT-2020090000000004', 2, CAST(N'2020-09-19 13:47:51.750' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (19, 7, N'ENT-2020090000000005', 9, CAST(N'2020-09-19 15:20:12.397' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (20, 8, N'ENT-2020090000000006', 6, CAST(N'2020-09-19 15:25:53.977' AS DateTime), N'TEst')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (21, 1, N'ENT-2020090000000007', 2, CAST(N'2020-09-19 15:27:19.323' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (22, 5, N'ENT-2020090000000008', 1, CAST(N'2020-09-19 15:30:19.377' AS DateTime), N'sss')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (23, 1, N'ENT-2020100000000009', 5, CAST(N'2020-10-12 14:32:22.693' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (24, 9, N'ENT-2020100000000010', 3, CAST(N'2020-10-12 15:02:23.503' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (25, 10, N'ENT-2020100000000011', 2, CAST(N'2020-10-12 18:36:19.537' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (26, 9, N'ENT-2020100000000012', 1, CAST(N'2020-10-15 15:26:43.407' AS DateTime), N'Test Manual add product....')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (27, 10, N'ENT-2020100000000013', 1, CAST(N'2020-10-15 15:31:11.497' AS DateTime), N'2nd test for manual product entry...')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (28, 9, N'ENT-2020100000000014', 1, CAST(N'2020-10-15 15:34:41.740' AS DateTime), N'dfsdf')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (29, 8, N'ENT-2020100000000015', 1, CAST(N'2020-10-15 15:41:35.077' AS DateTime), N'3rd manual test')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (30, 10, N'ENT-2020100000000016', 1, CAST(N'2020-10-15 16:16:19.763' AS DateTime), NULL)
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (10026, 9, N'ADJ-2020100000000006', 1, CAST(N'2020-10-21 06:40:59.527' AS DateTime), N'Auto generated from stock adjustment.')
INSERT [dbo].[ProductInsertion] ([Id], [ProductId], [EntryNo], [Quantity], [EntryDate], [Note]) VALUES (10027, 9, N'ENT-2020100000000007', 1, CAST(N'2020-10-21 06:42:40.950' AS DateTime), N'Manual assign..')
SET IDENTITY_INSERT [dbo].[ProductInsertion] OFF
SET IDENTITY_INSERT [dbo].[ProductItems] ON 

INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (29, 1, N'000014 2009180000000001', NULL, NULL, CAST(N'2020-09-18 17:19:39.457' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (30, 1, N'000014 2009180000000002', NULL, NULL, CAST(N'2020-09-18 17:19:39.570' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (31, 5, N'000015 2009180000000001', NULL, NULL, CAST(N'2020-09-18 17:34:00.113' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (32, 5, N'000015 2009180000000002', NULL, NULL, CAST(N'2020-09-18 17:34:00.150' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (33, 1, N'000016 2009180000000003', NULL, NULL, CAST(N'2020-09-18 17:36:35.000' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (34, 1, N'000001 2009190000000004', NULL, NULL, CAST(N'2020-09-18 22:50:21.743' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (35, 1, N'000001 2009190000000005', NULL, NULL, CAST(N'2020-09-18 22:50:35.363' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (36, 2, N'000002 2009190000000001', NULL, NULL, CAST(N'2020-09-19 13:47:51.870' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (37, 2, N'000002 2009190000000002', NULL, NULL, CAST(N'2020-09-19 13:47:51.900' AS DateTime), N'ReturnProduct')
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (38, 7, N'000007 2009190000000001', NULL, NULL, CAST(N'2020-09-19 15:20:12.427' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (39, 7, N'000007 2009190000000002', NULL, NULL, CAST(N'2020-09-19 15:20:12.457' AS DateTime), N'ReturnProduct')
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (40, 7, N'000007 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:20:12.467' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (41, 7, N'000007 2009190000000004', NULL, NULL, CAST(N'2020-09-19 15:20:12.477' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (42, 7, N'000007 2009190000000005', NULL, NULL, CAST(N'2020-09-19 15:20:12.487' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (43, 7, N'000007 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:20:12.497' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (44, 7, N'000007 2009190000000007', NULL, NULL, CAST(N'2020-09-19 15:20:12.503' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (45, 7, N'000007 2009190000000008', NULL, NULL, CAST(N'2020-09-19 15:20:12.517' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (46, 7, N'000007 2009190000000009', NULL, NULL, CAST(N'2020-09-19 15:20:12.527' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (47, 8, N'000008 2009190000000001', NULL, NULL, CAST(N'2020-09-19 15:25:53.993' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (48, 8, N'000008 2009190000000002', NULL, NULL, CAST(N'2020-09-19 15:25:54.017' AS DateTime), N'Damage')
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (49, 8, N'000008 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:25:54.023' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (50, 8, N'000008 2009190000000004', NULL, NULL, CAST(N'2020-09-19 15:25:54.040' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (51, 8, N'000008 2009190000000005', NULL, NULL, CAST(N'2020-09-19 15:25:54.063' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (52, 8, N'000008 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:25:54.083' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (53, 1, N'000001 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:27:19.343' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (54, 1, N'000001 2009190000000007', NULL, NULL, CAST(N'2020-09-19 15:27:19.357' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (55, 5, N'000005 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:30:19.393' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (56, 1, N'000001 2010120000000008', NULL, NULL, CAST(N'2020-10-12 14:32:22.820' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (57, 1, N'000001 2010120000000009', NULL, NULL, CAST(N'2020-10-12 14:32:22.853' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (58, 1, N'000001 2010120000000010', NULL, NULL, CAST(N'2020-10-12 14:32:22.873' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (59, 1, N'000001 2010120000000011', NULL, NULL, CAST(N'2020-10-12 14:32:22.890' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (60, 1, N'000001 2010120000000012', NULL, NULL, CAST(N'2020-10-12 14:32:22.900' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (61, 9, N'000009 2010120000000001', NULL, NULL, CAST(N'2020-10-12 15:02:23.560' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (62, 9, N'000009 2010120000000002', NULL, NULL, CAST(N'2020-10-12 15:02:23.597' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (63, 9, N'000009 2010120000000003', NULL, NULL, CAST(N'2020-10-12 15:02:23.607' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (64, 10, N'000010 2010130000000001', NULL, NULL, CAST(N'2020-10-12 18:36:19.613' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (65, 10, N'000010 2010130000000002', NULL, NULL, CAST(N'2020-10-12 18:36:19.670' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (66, 9, N'000009 2010150000000004', NULL, NULL, CAST(N'2020-10-15 15:26:58.410' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (67, 10, N'000010 2010150000000003', NULL, NULL, CAST(N'2020-10-15 15:31:11.507' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (68, 9, N'000009 2010150000000005', NULL, NULL, CAST(N'2020-10-15 15:34:41.747' AS DateTime), N'Damage')
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (69, 8, N'000008 2010150000000007', NULL, NULL, CAST(N'2020-10-15 15:41:35.083' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (70, 10, N'000010 2010150000000004', NULL, NULL, CAST(N'2020-10-15 16:16:19.840' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (10066, 9, N'000009 2010210000000006', NULL, NULL, CAST(N'2020-10-21 06:40:59.577' AS DateTime), NULL)
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate], [Status]) VALUES (10067, 9, N'000009 2010210000000007', NULL, NULL, CAST(N'2020-10-21 06:42:40.967' AS DateTime), N'FreshProduct')
SET IDENTITY_INSERT [dbo].[ProductItems] OFF
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (1, N'0001', N'X-Phone', 1, 1, 1, N'xxx', NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, NULL, NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (2, N'0002', N'Hair Dry', 1, 2, 1, NULL, NULL, NULL, CAST(160.00 AS Decimal(18, 2)), CAST(220.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-13 03:16:25.477' AS DateTime), CAST(N'2020-09-13 03:46:41.677' AS DateTime))
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (5, N'0003', N'Drill Machine', 1, 1, 2, NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-13 03:24:06.883' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (7, N'500', N'Nokia 3310', 1, 1, 2, NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-19 15:19:28.640' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (8, N'240', N'Konka TV', 1, 1, 2, NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-19 15:25:24.990' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (9, N'8001', N'Scientific Calculator', 1, 1, 1, NULL, NULL, NULL, CAST(150.00 AS Decimal(18, 2)), CAST(200.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-10-12 14:59:08.357' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (10, N'9001', N'Iron', 1, 1, 2, NULL, NULL, NULL, CAST(180.00 AS Decimal(18, 2)), CAST(240.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-10-12 18:35:41.250' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Products] OFF
SET IDENTITY_INSERT [dbo].[ProductType] ON 

INSERT [dbo].[ProductType] ([Id], [TypeName]) VALUES (1, N'Electronics')
INSERT [dbo].[ProductType] ([Id], [TypeName]) VALUES (2, N'Foods')
SET IDENTITY_INSERT [dbo].[ProductType] OFF
SET IDENTITY_INSERT [dbo].[Reck] ON 

INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (3, 1, N'Reck01', 1, 1, 5, 1)
INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (4, 1, N'Reck02', 1, 1, 5, 1)
INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (5, 7, N'Reck X', 1, 1, 7, 1)
INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (6, 7, N'Reck Y', 1, 1, 7, 1)
INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (7, 8, N'Reck xy', 1, 1, 4, 1)
INSERT [dbo].[Reck] ([Id], [WarehouseId], [ReckName], [SetupRow], [SetupColumn], [ReckLevel], [IsActive]) VALUES (8, 8, N'Reck yz', 1, 1, 4, 1)
SET IDENTITY_INSERT [dbo].[Reck] OFF
SET IDENTITY_INSERT [dbo].[Stock] ON 

INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (3, 1, 1, 2, 3, CAST(N'2020-09-18 17:19:39.653' AS DateTime), CAST(N'2020-10-20 16:23:05.720' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (4, 1, 5, 2, 0, CAST(N'2020-09-18 17:34:00.190' AS DateTime), CAST(N'2020-10-21 05:42:20.443' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (5, 1, 2, 1, 0, CAST(N'2020-09-19 13:47:51.940' AS DateTime), CAST(N'2020-10-21 05:42:20.550' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (6, 7, 7, 9, 8, CAST(N'2020-09-19 15:20:12.553' AS DateTime), CAST(N'2020-10-21 05:47:20.033' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (7, 8, 8, 1, 2, CAST(N'2020-09-19 15:25:54.097' AS DateTime), CAST(N'2020-10-20 04:56:15.207' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (8, 8, 1, 2, 1, CAST(N'2020-09-19 15:27:19.367' AS DateTime), CAST(N'2020-10-20 08:36:48.420' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (9, 8, 5, 1, 0, CAST(N'2020-09-19 15:30:19.433' AS DateTime), NULL)
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (10, 1, 8, 1, 2, CAST(N'2020-10-12 12:52:51.643' AS DateTime), CAST(N'2020-10-20 16:18:49.020' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (11, 8, 9, 1, 2, CAST(N'2020-10-12 15:02:23.630' AS DateTime), CAST(N'2020-10-12 18:17:32.940' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (12, 1, 10, 2, 3, CAST(N'2020-10-12 18:36:19.730' AS DateTime), CAST(N'2020-10-14 12:23:15.407' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (13, 1, 9, 1, 0, CAST(N'2020-10-15 15:27:12.350' AS DateTime), NULL)
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (14, 7, 10, 2, 1, CAST(N'2020-10-15 15:31:11.517' AS DateTime), CAST(N'2020-10-15 16:16:19.867' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (15, 7, 9, 1, 0, CAST(N'2020-10-15 15:34:41.757' AS DateTime), CAST(N'2020-10-21 06:42:40.983' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (16, 7, 8, 1, 0, CAST(N'2020-10-15 15:41:35.093' AS DateTime), NULL)
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (10013, 7, 2, 1, 0, CAST(N'2020-10-17 02:23:58.943' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Stock] OFF
SET IDENTITY_INSERT [dbo].[StockAdjustment] ON 

INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (1, N'ADJ-2020090000000001', 1, 1, 2, NULL, N'add', NULL, CAST(N'2020-09-30 13:10:42.733' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (2, N'ADJ-2020090000000002', 1, 1, -2, NULL, N'Decrease...', NULL, CAST(N'2020-09-30 14:10:42.733' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (3, N'ADJ-2020090000000003', 8, 1, -1, NULL, N'Decrease one product of X-phone', NULL, CAST(N'2020-09-30 14:10:42.733' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (4, N'ADJ-2020100000000003', 1, 1, -1, NULL, N'test for minus...... stock adjustment...', NULL, CAST(N'2020-10-21 06:25:20.623' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (10, N'ADJ-2020100000000004', 7, 9, 1, N'Stock', NULL, NULL, CAST(N'2020-10-21 06:25:21.623' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (12, N'ADJ-2020100000000005', 7, 9, -1, N'Stock', NULL, NULL, CAST(N'2020-10-21 06:32:27.113' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (13, N'ADJ-2020100000000006', 7, 9, 1, N'StockAndReck', N'test for both stock and reck.. adjustment..', NULL, CAST(N'2020-10-21 06:40:59.527' AS DateTime))
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [TargetOnEffect], [Note], [CreatedBy], [EntryDate]) VALUES (14, N'ADJ-2020100000000007', 7, 9, -1, N'StockAndReck', N'Decrease test with reck and stock..', NULL, CAST(N'2020-10-21 06:42:08.653' AS DateTime))
SET IDENTITY_INSERT [dbo].[StockAdjustment] OFF
SET IDENTITY_INSERT [dbo].[StockTrace] ON 

INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (3, 1, 1, 2, 0, 2, N'ENT-2020090000000001', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-18 17:19:39.700' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (4, 1, 5, 2, 0, 2, N'ENT-2020090000000002', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-18 17:34:00.253' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (5, 1, 1, 3, 2, 3, N'ENT-2020090000000003', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-18 17:36:35.070' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (6, 1, 1, 5, 3, 5, N'ADJ-2020090000000001', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-09-18 22:50:50.670' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (7, 1, 1, 3, 5, 3, N'ADJ-2020090000000002', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-09-18 22:53:45.413' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (8, 1, 2, 2, 0, 2, N'ENT-2020090000000004', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-19 13:47:51.983' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (9, 7, 7, 9, 0, 9, N'ENT-2020090000000005', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-19 15:20:12.600' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10, 8, 8, 6, 0, 6, N'ENT-2020090000000006', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-19 15:25:54.107' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (11, 8, 1, 5, 3, 5, N'ENT-2020090000000007', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-19 15:27:19.387' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (12, 8, 1, 4, 5, 4, N'ADJ-2020090000000003', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-09-19 15:28:47.303' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (13, 8, 5, 3, 2, 3, N'ENT-2020090000000008', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-09-19 15:30:19.467' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (14, 0, 8, 2, 6, 2, N'ORD-2020090000000001', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-09-30 13:10:54.090' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (15, 0, 1, 2, 4, 2, N'ORD-2020090000000001', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-09-30 13:11:00.260' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (16, 8, 8, 6, 2, 6, N'ORD-2020090000000001', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-07 10:45:48.800' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (17, 1, 1, 4, 2, 4, N'ORD-2020090000000001', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-07 10:46:06.533' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (18, 0, 5, 1, 3, 1, N'ORD-2020100000000002', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 10:52:09.370' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (19, 0, 2, 1, 2, 1, N'ORD-2020100000000002', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 10:52:09.390' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20, 0, 8, 4, 6, 4, N'ORD-2020100000000003', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:17:07.903' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (21, 0, 8, 3, 4, 3, N'ORD-2020100000000003', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:17:07.943' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (22, 8, 8, 5, 3, 5, N'ORD-2020100000000003', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-07 16:30:36.990' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (23, 8, 8, 6, 5, 6, N'ORD-2020100000000003', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-07 16:30:37.067' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (24, 0, 8, 4, 6, 4, N'ORD-2020100000000004', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:31:55.743' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (25, 0, 1, 3, 4, 3, N'ORD-2020100000000004', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:31:55.783' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (26, 0, 2, 0, 1, 0, N'ORD-2020100000000005', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:34:39.523' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (27, 0, 8, 3, 4, 3, N'ORD-2020100000000005', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-07 16:34:39.553' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (28, 1, 8, 4, 3, 4, N'RTN-2020100000000002', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-12 12:53:01.107' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (29, 0, 1, 2, 3, 2, N'ORD-2020100000000006', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 13:23:08.110' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (30, 1, 1, 3, 2, 3, N'ORD-2020100000000006', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 13:25:42.200' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (31, 0, 1, 2, 3, 2, N'ORD-2020100000000007', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 13:28:14.470' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (32, 1, 1, 8, 3, 8, N'ENT-2020100000000009', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-10-12 14:32:23.010' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (33, 8, 9, 3, 0, 3, N'ENT-2020100000000010', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-10-12 15:02:23.660' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (34, 0, 9, -1, 0, -1, N'ORD-2020100000000008', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 15:03:34.483' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (36, 8, 9, 2, 3, 2, N'ORD-2020100000000009', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 18:17:33.027' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (37, 1, 10, 2, 0, 2, N'ENT-2020100000000011', N'ProductInsertion', N'Generated From Products/InsertProductItem', CAST(N'2020-10-12 18:36:19.753' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (38, 1, 10, 1, 2, 1, N'ORD-2020100000000010', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 18:43:02.830' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (39, 1, 10, 0, 1, 0, N'ORD-2020100000000011', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 18:44:20.850' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (40, 1, 10, 1, 0, 1, N'ORD-2020100000000011', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 19:30:50.543' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (41, 1, 10, 2, 1, 2, N'ORD-2020100000000010', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 19:33:29.240' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (42, 1, 10, 3, 2, 3, N'ORD-2020100000000010', N'OrderDetails', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 19:33:29.487' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (43, 1, 10, 1, 3, 1, N'ORD-2020100000000012', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 19:35:34.877' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (44, 1, 10, 3, 1, 3, N'ORD-2020100000000012', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 19:36:51.370' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (46, 1, 10, 1, 3, 1, N'ORD-2020100000000013', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 20:07:40.297' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (47, 1, 10, 3, 1, 3, N'ORD-2020100000000013', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 20:08:02.307' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (49, 1, 10, 1, 3, 1, N'ORD-2020100000000014', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 20:15:23.843' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (50, 1, 10, 3, 1, 3, N'ORD-2020100000000014', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 20:18:52.633' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (53, 1, 10, 1, 3, 1, N'ORD-2020100000000015', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 20:25:29.823' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (54, 1, 10, 3, 1, 3, N'ORD-2020100000000015', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-12 20:29:51.773' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (57, 1, 10, 1, 3, 1, N'ORD-2020100000000016', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-12 20:34:07.383' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (58, 1, 10, 2, 1, 2, N'RTN-2020100000000003', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-12 20:46:03.057' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (59, 1, 10, 3, 2, 3, N'RTN-2020100000000003', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-12 20:46:03.087' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (60, 1, 10, 2, 3, 2, N'ORD-2020100000000017', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-14 12:23:15.597' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (61, 8, 8, 5, 6, 5, N'ORD-2020100000000018', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-14 12:29:53.560' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (62, 1, 1, 7, 8, 7, N'ORD-2020100000000018', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-14 12:29:53.587' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (63, 1, 8, 5, 4, 5, N'RTN-2020100000000004', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-14 14:02:06.173' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10060, 1, 9, 1, 0, 1, N'ENT-2020100000000012', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-15 15:27:14.600' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10061, 7, 10, 1, 0, 1, N'ENT-2020100000000013', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-15 15:31:11.523' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10062, 7, 9, 1, 0, 1, N'ENT-2020100000000014', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-15 15:34:41.767' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10063, 7, 8, 1, 0, 1, N'ENT-2020100000000015', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-15 15:41:35.100' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (10064, 7, 10, 2, 1, 2, N'ENT-2020100000000016', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-15 16:16:19.897' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20060, 7, 2, 1, 0, 1, N'1', N'VirtualSpace', N'Generated From Products/ProductBackToStock', CAST(N'2020-10-17 02:24:03.037' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20061, 1, 1, 5, 7, 5, N'ORD-2020100000000019', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-20 04:56:15.163' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20062, 8, 8, 4, 5, 4, N'ORD-2020100000000019', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-20 04:56:15.220' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20063, 8, 1, 5, 4, 5, N'RTN-2020100000000009', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-20 08:36:48.473' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20064, 1, 8, 4, 5, 4, N'DMG-2020100000000002', N'Damage', N'Generated From Products/CreateDamage', CAST(N'2020-10-20 16:18:50.483' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20065, 1, 1, 4, 5, 4, N'ADJ-2020100000000003', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-10-20 16:23:05.740' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20066, 7, 7, 7, 9, 7, N'ORD-2020100000000020', N'Orders', N'Generated From Orders/CreateOrders', CAST(N'2020-10-21 04:31:20.547' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20067, 1, 5, 4, 2, 4, N'ORD-2020100000000002', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-21 05:42:20.513' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20068, 1, 2, 3, 2, 3, N'ORD-2020100000000002', N'Order Cancel', N'Generated From Order Cancellation Orders/OrderCancel', CAST(N'2020-10-21 05:42:20.557' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20069, 7, 7, 8, 7, 8, N'6', N'VirtualSpace', N'Generated From Products/ProductBackToStock', CAST(N'2020-10-21 05:46:19.060' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20070, 7, 7, 9, 8, 9, N'RTN-2020100000000011', N'OrderReturn', N'Generated From Orders/CreateOrderReturn', CAST(N'2020-10-21 05:47:20.040' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20071, 7, 9, 0, 1, 0, N'DMG-2020100000000003', N'Damage', N'Generated From Products/CreateDamage', CAST(N'2020-10-21 05:51:20.083' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20072, 7, 9, 1, 0, 1, N'ADJ-2020100000000004', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-10-21 06:25:57.763' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20073, 7, 9, 0, 1, 0, N'ADJ-2020100000000005', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-10-21 06:32:27.137' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20074, 7, 9, 1, 0, 1, N'ADJ-2020100000000006', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-10-21 06:40:59.607' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20075, 7, 9, 0, 1, 0, N'ADJ-2020100000000007', N'StockAdjustment', N'Generated From Stock/CreateStockAdjustment', CAST(N'2020-10-21 06:42:08.677' AS DateTime))
INSERT [dbo].[StockTrace] ([Id], [WarehouseId], [ProductId], [CurrentQuantity], [OpeningQuantity], [ClosingQuantity], [ReferenceId], [TableReference], [Note], [CreatedDate]) VALUES (20076, 7, 9, 1, 0, 1, N'ENT-2020100000000007', N'ProductInsertion', N'Generated From Products/InsertSingleProductItem', CAST(N'2020-10-21 06:42:40.990' AS DateTime))
SET IDENTITY_INSERT [dbo].[StockTrace] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [UserName], [UserTypeId], [Email], [FirstName], [LastName], [Password], [TempField], [SmallImage], [BigImage], [CreateDate]) VALUES (1, N'AbdHsn', 2, N'AbdHsn@gmail.com', N'Abdullah', N'Hasan', N'123123', NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [UserName], [UserTypeId], [Email], [FirstName], [LastName], [Password], [TempField], [SmallImage], [BigImage], [CreateDate]) VALUES (2, N'Dina@gmail.com', 4, N'Dina@gmail.com', N'Dinaaa', N'Begum', NULL, NULL, NULL, NULL, CAST(N'2020-09-07 13:09:12.193' AS DateTime))
SET IDENTITY_INSERT [dbo].[Users] OFF
SET IDENTITY_INSERT [dbo].[UserType] ON 

INSERT [dbo].[UserType] ([Id], [TypeName]) VALUES (2, N'Admin')
INSERT [dbo].[UserType] ([Id], [TypeName]) VALUES (4, N'Customer')
INSERT [dbo].[UserType] ([Id], [TypeName]) VALUES (3, N'Employee')
INSERT [dbo].[UserType] ([Id], [TypeName]) VALUES (1, N'SuperAdmin')
SET IDENTITY_INSERT [dbo].[UserType] OFF
SET IDENTITY_INSERT [dbo].[VirtualSpace] ON 

INSERT [dbo].[VirtualSpace] ([Id], [ProductItemId], [FromOrderId], [Status], [InsertedDate], [InsertedBy]) VALUES (1, 37, 5, N'StockRetrived', CAST(N'2020-10-12 12:45:47.050' AS DateTime), NULL)
INSERT [dbo].[VirtualSpace] ([Id], [ProductItemId], [FromOrderId], [Status], [InsertedDate], [InsertedBy]) VALUES (2, 64, 22, N'Damage', CAST(N'2020-10-20 06:15:13.857' AS DateTime), NULL)
INSERT [dbo].[VirtualSpace] ([Id], [ProductItemId], [FromOrderId], [Status], [InsertedDate], [InsertedBy]) VALUES (4, 50, 23, N'VirtualStored', CAST(N'2020-10-20 07:02:37.523' AS DateTime), NULL)
INSERT [dbo].[VirtualSpace] ([Id], [ProductItemId], [FromOrderId], [Status], [InsertedDate], [InsertedBy]) VALUES (5, 56, 10022, N'VirtualStored', CAST(N'2020-10-20 08:35:34.383' AS DateTime), NULL)
INSERT [dbo].[VirtualSpace] ([Id], [ProductItemId], [FromOrderId], [Status], [InsertedDate], [InsertedBy]) VALUES (6, 39, 10023, N'StockRetrived', CAST(N'2020-10-21 05:39:52.140' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[VirtualSpace] OFF
SET IDENTITY_INSERT [dbo].[Warehouse] ON 

INSERT [dbo].[Warehouse] ([Id], [Title], [Location], [IsActive]) VALUES (1, N'Primary Store House', N'Centre Dhaka', 1)
INSERT [dbo].[Warehouse] ([Id], [Title], [Location], [IsActive]) VALUES (2, N'Secondary Store House', N'Gazipur', 1)
INSERT [dbo].[Warehouse] ([Id], [Title], [Location], [IsActive]) VALUES (6, N'HomeOfDelivery', N'Chittagoan', 1)
INSERT [dbo].[Warehouse] ([Id], [Title], [Location], [IsActive]) VALUES (7, N'Demo Warehouse', N'4/13/Cha, West Vasantak', 1)
INSERT [dbo].[Warehouse] ([Id], [Title], [Location], [IsActive]) VALUES (8, N'Test Warehouse', N'TEst location', 1)
SET IDENTITY_INSERT [dbo].[Warehouse] OFF
SET IDENTITY_INSERT [dbo].[WarehouseCapacityDefination] ON 

INSERT [dbo].[WarehouseCapacityDefination] ([Id], [WarehouseId], [Row], [Column], [ReckQuantity], [IsActive]) VALUES (1, 1, 5, 4, 2, 1)
INSERT [dbo].[WarehouseCapacityDefination] ([Id], [WarehouseId], [Row], [Column], [ReckQuantity], [IsActive]) VALUES (2, 2, 2, 6, 1, 1)
INSERT [dbo].[WarehouseCapacityDefination] ([Id], [WarehouseId], [Row], [Column], [ReckQuantity], [IsActive]) VALUES (4, 6, 2, 4, 8, 1)
INSERT [dbo].[WarehouseCapacityDefination] ([Id], [WarehouseId], [Row], [Column], [ReckQuantity], [IsActive]) VALUES (5, 7, 2, 3, 2, 1)
INSERT [dbo].[WarehouseCapacityDefination] ([Id], [WarehouseId], [Row], [Column], [ReckQuantity], [IsActive]) VALUES (6, 8, 3, 2, 2, 1)
SET IDENTITY_INSERT [dbo].[WarehouseCapacityDefination] OFF
/****** Object:  Index [UQ__Authoriz__1788CC4D0FBC0E7D]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Authorizations] ADD UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Authoriz__D4E7DFA8C7F9AAF7]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[AuthorizeType] ADD  CONSTRAINT [UQ__Authoriz__D4E7DFA8C7F9AAF7] UNIQUE NONCLUSTERED 
(
	[TypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Brand__737584F6E51F9A50]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Brand] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Customer__5C7E359E545FCC7B]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Customer__A9D105342D6D1D37]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Damage__8A0F29487DFA2C8C]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Damage] ADD UNIQUE NONCLUSTERED 
(
	[DamageNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Manufact__3B9CDE2ED12CA066]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Manufacturer] ADD  CONSTRAINT [UQ__Manufact__3B9CDE2ED12CA066] UNIQUE NONCLUSTERED 
(
	[ManufacturerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__OrderDis__434D95C739A83EF7]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[OrderDispatch] ADD UNIQUE NONCLUSTERED 
(
	[DispatchNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__OrderRet__F445F15AE54AFF67]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[OrderReturn] ADD UNIQUE NONCLUSTERED 
(
	[ReturnNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Orders__C3907C75D1585BAD]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [UQ__Orders__C3907C75D1585BAD] UNIQUE NONCLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Payment__554342D9B731789B]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Payment] ADD  CONSTRAINT [UQ__Payment__554342D9B731789B] UNIQUE NONCLUSTERED 
(
	[TransactionNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__PaymentM__737584F62EB6018B]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[PaymentMethods] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Personal__1788CC4D4B2A1430]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[PersonalDetail] ADD  CONSTRAINT [UQ__Personal__1788CC4D4B2A1430] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__ProductI__F57A9DFC897AE8EA]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[ProductInsertion] ADD UNIQUE NONCLUSTERED 
(
	[EntryNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__ProductI__CA167712CADD7D4E]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[ProductItems] ADD  CONSTRAINT [UQ__ProductI__CA167712CADD7D4E] UNIQUE NONCLUSTERED 
(
	[ItemSerial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Products__2F4E024FA30573CB]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [UQ__Products__2F4E024FA30573CB] UNIQUE NONCLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Refunds__725A61B209FD4997]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Refunds] ADD UNIQUE NONCLUSTERED 
(
	[RefundNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__SalesRet__E0900466B0452FA9]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[SalesReturn] ADD UNIQUE NONCLUSTERED 
(
	[SalesReturnNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__StockAdj__E60D0EF1D06C6850]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[StockAdjustment] ADD  CONSTRAINT [UQ__StockAdj__E60D0EF1D06C6850] UNIQUE NONCLUSTERED 
(
	[AdjustmentNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Supplier__5C7E359EA5101B85]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Supplier] ADD UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Supplier__A9D10534EA803924]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Supplier] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Users__A9D10534D36E8D6C]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ__Users__A9D10534D36E8D6C] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Users__C9F28456F39F222E]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__UserType__D4E7DFA807F3DAE4]    Script Date: 10/24/2020 11:24:36 PM ******/
ALTER TABLE [dbo].[UserType] ADD  CONSTRAINT [UQ__UserType__D4E7DFA807F3DAE4] UNIQUE NONCLUSTERED 
(
	[TypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Authorizations]  WITH CHECK ADD  CONSTRAINT [FK__Authoriza__Autho__59063A47] FOREIGN KEY([AuthorizeTypeId])
REFERENCES [dbo].[AuthorizeType] ([Id])
GO
ALTER TABLE [dbo].[Authorizations] CHECK CONSTRAINT [FK__Authoriza__Autho__59063A47]
GO
ALTER TABLE [dbo].[PersonalDetail]  WITH CHECK ADD  CONSTRAINT [FK__PersonalD__UserI__403A8C7D] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[PersonalDetail] CHECK CONSTRAINT [FK__PersonalD__UserI__403A8C7D]
GO
ALTER TABLE [dbo].[Refunds]  WITH CHECK ADD FOREIGN KEY([SalesReturnId])
REFERENCES [dbo].[SalesReturn] ([Id])
GO
ALTER TABLE [dbo].[SalesReturn]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[SalesTransaction]  WITH CHECK ADD FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[SalesTransaction]  WITH CHECK ADD FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[PaymentMethods] ([Id])
GO
USE [master]
GO
ALTER DATABASE [WMSDB] SET  READ_WRITE 
GO
