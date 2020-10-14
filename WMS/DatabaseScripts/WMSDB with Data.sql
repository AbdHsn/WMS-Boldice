USE [WMSDB]
GO
/****** Object:  Table [dbo].[Authorizations]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[AuthorizeType]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Brand]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Category]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Company]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Customers]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Damage]    Script Date: 10/12/2020 10:14:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Damage](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DamageNo] [nvarchar](20) NULL,
	[ProductSerial] [nvarchar](20) NULL,
	[ProductId] [bigint] NULL,
	[TotalAmount] [decimal](18, 2) NULL,
	[EntryDate] [datetime] NULL,
	[Note] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ItemSpace]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[OrderDispatch]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[OrderDispatchDetails]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[OrderReturn]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[OrderReturnDetails]    Script Date: 10/12/2020 10:14:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderReturnDetails](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ReturnId] [bigint] NULL,
	[ProductId] [bigint] NULL,
	[ProductItemId] [bigint] NULL,
	[ProductStatus] [nvarchar](15) NULL,
	[LastUpdate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Payment]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[PaymentMethods]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[PersonalDetail]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[ProductInsertion]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[ProductItems]    Script Date: 10/12/2020 10:14:05 AM ******/
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
 CONSTRAINT [PK__ProductI__3214EC0740F94A5F] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[ProductType]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Reck]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Refunds]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[SalesReturn]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[SalesTransaction]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Stock]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[StockAdjustment]    Script Date: 10/12/2020 10:14:05 AM ******/
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
	[Note] [nvarchar](100) NULL,
	[CreatedBy] [bigint] NULL,
	[EntryDate] [datetime] NULL,
 CONSTRAINT [PK_StockAdjustment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockTrace]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Supplier]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[UserType]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Vat]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[VirtualSpace]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[Warehouse]    Script Date: 10/12/2020 10:14:05 AM ******/
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
/****** Object:  Table [dbo].[WarehouseCapacityDefination]    Script Date: 10/12/2020 10:14:05 AM ******/
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
SET IDENTITY_INSERT [dbo].[ItemSpace] ON 

INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (1, 1, 3, 1, NULL, 0, CAST(N'2020-10-07 16:32:52.083' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (2, 1, 3, 2, 30, 1, CAST(N'2020-09-18 17:19:39.587' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (3, 1, 3, 3, NULL, 0, CAST(N'2020-10-07 15:31:02.957' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (4, 1, 3, 4, NULL, 0, CAST(N'2020-10-07 15:31:14.313' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (5, 1, 3, 5, 33, 1, CAST(N'2020-09-18 17:36:35.007' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (6, 1, 4, 1, NULL, 0, CAST(N'2020-10-07 15:31:28.800' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (7, 1, 4, 2, NULL, 0, CAST(N'2020-10-07 16:35:44.600' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (8, 1, 4, 3, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (9, 1, 4, 4, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (10, 1, 4, 5, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (11, 7, 5, 1, 38, 1, CAST(N'2020-09-19 15:20:12.447' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (12, 7, 5, 2, 39, 1, CAST(N'2020-09-19 15:20:12.460' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (13, 7, 5, 3, 40, 1, CAST(N'2020-09-19 15:20:12.470' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (14, 7, 5, 4, 41, 1, CAST(N'2020-09-19 15:20:12.480' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (15, 7, 5, 5, 42, 1, CAST(N'2020-09-19 15:20:12.490' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (16, 7, 5, 6, 43, 1, CAST(N'2020-09-19 15:20:12.500' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (17, 7, 5, 7, 44, 1, CAST(N'2020-09-19 15:20:12.513' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (18, 7, 6, 1, 45, 1, CAST(N'2020-09-19 15:20:12.520' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (19, 7, 6, 2, 46, 1, CAST(N'2020-09-19 15:20:12.530' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (20, 7, 6, 3, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (21, 7, 6, 4, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (22, 7, 6, 5, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (23, 7, 6, 6, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (24, 7, 6, 7, NULL, 0, NULL, 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (25, 8, 7, 1, NULL, 0, CAST(N'2020-10-07 16:32:51.903' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (26, 8, 7, 2, NULL, 0, CAST(N'2020-10-07 16:32:52.057' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (27, 8, 7, 3, NULL, 0, CAST(N'2020-10-07 16:35:58.640' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (28, 8, 7, 4, 50, 1, CAST(N'2020-09-19 15:25:54.050' AS DateTime), 0)
INSERT [dbo].[ItemSpace] ([Id], [WarehouseId], [ReckId], [ReckLevel], [ProductItemId], [IsAllocated], [LastUpdate], [ActionedBy]) VALUES (29, 8, 8, 1, 51, 1, CAST(N'2020-09-19 15:25:54.070' AS DateTime), 0)
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
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (3, 2, 1, 5, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Submitted', NULL)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (4, 2, 1, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Submitted', NULL)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (5, 3, 8, 8, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 16:30:37.040' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (6, 3, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Cancelled', CAST(N'2020-10-07 16:30:37.077' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (7, 4, 8, 8, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:32:52.063' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (8, 4, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:32:52.093' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (9, 5, 1, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:35:48.707' AS DateTime))
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [WarehouseId], [ProductId], [Quantity], [Price], [CollectionDate], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [Total], [ProductStatus], [LastUpdate]) VALUES (10, 5, 8, 8, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'FullDispatch', CAST(N'2020-10-07 16:36:08.143' AS DateTime))
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
SET IDENTITY_INSERT [dbo].[OrderDispatch] ON 

INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (1, 2, N'DIS-2020090000000001', CAST(N'2020-10-07 15:30:22.243' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (2, 4, N'DIS-2020100000000002', CAST(N'2020-10-07 16:32:50.133' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[OrderDispatch] ([Id], [OrderId], [DispatchNo], [DispatchDate], [Status], [DispatchBy]) VALUES (4, 5, N'DIS-2020100000000003', CAST(N'2020-10-07 16:35:36.067' AS DateTime), N'FullDispatch', NULL)
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
SET IDENTITY_INSERT [dbo].[OrderDispatchDetails] OFF
SET IDENTITY_INSERT [dbo].[OrderReturn] ON 

INSERT [dbo].[OrderReturn] ([Id], [OrderId], [ReturnNo], [ReturnDate], [Status], [ReturnBy]) VALUES (1, 5, N'RTN-2020090000000001', CAST(N'2020-10-07 15:30:22.243' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[OrderReturn] OFF
SET IDENTITY_INSERT [dbo].[OrderReturnDetails] ON 

INSERT [dbo].[OrderReturnDetails] ([Id], [ReturnId], [ProductId], [ProductItemId], [ProductStatus], [LastUpdate]) VALUES (1, 1, 8, 49, NULL, NULL)
SET IDENTITY_INSERT [dbo].[OrderReturnDetails] OFF
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (1, N'ORD-2020090000000001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-09-30 13:10:42.733' AS DateTime), CAST(N'2020-09-30 19:10:42.540' AS DateTime), NULL, CAST(N'2020-10-07 10:46:10.803' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (2, N'ORD-2020100000000002', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 10:52:09.247' AS DateTime), CAST(N'2020-10-07 16:52:09.247' AS DateTime), NULL, NULL, N'Submitted', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (3, N'ORD-2020100000000003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:17:07.443' AS DateTime), CAST(N'2020-10-07 22:17:07.443' AS DateTime), NULL, CAST(N'2020-10-07 16:30:37.083' AS DateTime), N'Cancelled', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (4, N'ORD-2020100000000004', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:31:55.610' AS DateTime), CAST(N'2020-10-07 22:31:55.610' AS DateTime), NULL, CAST(N'2020-10-07 16:32:52.100' AS DateTime), N'FullDispatch', NULL)
INSERT [dbo].[Orders] ([Id], [OrderNo], [UserId], [VatId], [VatRate], [VatAmount], [DiscountId], [DiscountRate], [DiscountAmount], [GrandTotal], [BillingAddress], [CollectionDate], [OrderPlaceDate], [UpdateBy], [LastUpdate], [OrderStatus], [Note]) VALUES (5, N'ORD-2020100000000005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, CAST(0.00 AS Decimal(18, 2)), NULL, CAST(N'2020-10-07 16:34:39.457' AS DateTime), CAST(N'2020-10-07 22:34:39.457' AS DateTime), NULL, CAST(N'2020-10-07 16:36:13.597' AS DateTime), N'FullDispatch', NULL)
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
SET IDENTITY_INSERT [dbo].[ProductInsertion] OFF
SET IDENTITY_INSERT [dbo].[ProductItems] ON 

INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (29, 1, N'000014 2009180000000001', NULL, NULL, CAST(N'2020-09-18 17:19:39.457' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (30, 1, N'000014 2009180000000002', NULL, NULL, CAST(N'2020-09-18 17:19:39.570' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (31, 5, N'000015 2009180000000001', NULL, NULL, CAST(N'2020-09-18 17:34:00.113' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (32, 5, N'000015 2009180000000002', NULL, NULL, CAST(N'2020-09-18 17:34:00.150' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (33, 1, N'000016 2009180000000003', NULL, NULL, CAST(N'2020-09-18 17:36:35.000' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (34, 1, N'000001 2009190000000004', NULL, NULL, CAST(N'2020-09-18 22:50:21.743' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (35, 1, N'000001 2009190000000005', NULL, NULL, CAST(N'2020-09-18 22:50:35.363' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (36, 2, N'000002 2009190000000001', NULL, NULL, CAST(N'2020-09-19 13:47:51.870' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (37, 2, N'000002 2009190000000002', NULL, NULL, CAST(N'2020-09-19 13:47:51.900' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (38, 7, N'000007 2009190000000001', NULL, NULL, CAST(N'2020-09-19 15:20:12.427' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (39, 7, N'000007 2009190000000002', NULL, NULL, CAST(N'2020-09-19 15:20:12.457' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (40, 7, N'000007 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:20:12.467' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (41, 7, N'000007 2009190000000004', NULL, NULL, CAST(N'2020-09-19 15:20:12.477' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (42, 7, N'000007 2009190000000005', NULL, NULL, CAST(N'2020-09-19 15:20:12.487' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (43, 7, N'000007 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:20:12.497' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (44, 7, N'000007 2009190000000007', NULL, NULL, CAST(N'2020-09-19 15:20:12.503' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (45, 7, N'000007 2009190000000008', NULL, NULL, CAST(N'2020-09-19 15:20:12.517' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (46, 7, N'000007 2009190000000009', NULL, NULL, CAST(N'2020-09-19 15:20:12.527' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (47, 8, N'000008 2009190000000001', NULL, NULL, CAST(N'2020-09-19 15:25:53.993' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (48, 8, N'000008 2009190000000002', NULL, NULL, CAST(N'2020-09-19 15:25:54.017' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (49, 8, N'000008 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:25:54.023' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (50, 8, N'000008 2009190000000004', NULL, NULL, CAST(N'2020-09-19 15:25:54.040' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (51, 8, N'000008 2009190000000005', NULL, NULL, CAST(N'2020-09-19 15:25:54.063' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (52, 8, N'000008 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:25:54.083' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (53, 1, N'000001 2009190000000006', NULL, NULL, CAST(N'2020-09-19 15:27:19.343' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (54, 1, N'000001 2009190000000007', NULL, NULL, CAST(N'2020-09-19 15:27:19.357' AS DateTime))
INSERT [dbo].[ProductItems] ([Id], [ProductId], [ItemSerial], [PackSerial], [ManualSerial], [CreatedDate]) VALUES (55, 5, N'000005 2009190000000003', NULL, NULL, CAST(N'2020-09-19 15:30:19.393' AS DateTime))
SET IDENTITY_INSERT [dbo].[ProductItems] OFF
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (1, N'0001', N'X-Phone', 1, 1, 1, N'xxx', NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, NULL, NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (2, N'0002', N'Hair Dry', 1, 2, 1, NULL, NULL, NULL, CAST(160.00 AS Decimal(18, 2)), CAST(220.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-13 03:16:25.477' AS DateTime), CAST(N'2020-09-13 03:46:41.677' AS DateTime))
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (5, N'0003', N'Drill Machine', 1, 1, 2, NULL, NULL, NULL, CAST(300.00 AS Decimal(18, 2)), CAST(350.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-13 03:24:06.883' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (7, N'500', N'Nokia 3310', 1, 1, 2, NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-19 15:19:28.640' AS DateTime), NULL)
INSERT [dbo].[Products] ([Id], [ProductCode], [Name], [ProductTypeId], [BrandId], [ManufacturerId], [Description], [SmallImage], [BigImage], [CostPrice], [SellingPrice], [MetaTags], [IsActive], [CreatedDate], [UpdateDate]) VALUES (8, N'240', N'Konka TV', 1, 1, 2, NULL, NULL, NULL, CAST(200.00 AS Decimal(18, 2)), CAST(250.00 AS Decimal(18, 2)), NULL, 1, CAST(N'2020-09-19 15:25:24.990' AS DateTime), NULL)
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

INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (3, 1, 1, 2, 3, CAST(N'2020-09-18 17:19:39.653' AS DateTime), CAST(N'2020-10-07 16:31:55.770' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (4, 1, 5, 0, 2, CAST(N'2020-09-18 17:34:00.190' AS DateTime), CAST(N'2020-10-07 10:52:09.357' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (5, 1, 2, 0, 1, CAST(N'2020-09-19 13:47:51.940' AS DateTime), CAST(N'2020-10-07 16:34:39.493' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (6, 7, 7, 9, 0, CAST(N'2020-09-19 15:20:12.553' AS DateTime), NULL)
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (7, 8, 8, 3, 4, CAST(N'2020-09-19 15:25:54.097' AS DateTime), CAST(N'2020-10-07 16:34:39.543' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (8, 8, 1, 1, 2, CAST(N'2020-09-19 15:27:19.367' AS DateTime), CAST(N'2020-09-19 15:28:47.290' AS DateTime))
INSERT [dbo].[Stock] ([Id], [WarehouseId], [ProductId], [AvailableQuantity], [LastQuantity], [CreatedDate], [LastUpdate]) VALUES (9, 8, 5, 1, 0, CAST(N'2020-09-19 15:30:19.433' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Stock] OFF
SET IDENTITY_INSERT [dbo].[StockAdjustment] ON 

INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [Note], [CreatedBy], [EntryDate]) VALUES (1, N'ADJ-2020090000000001', 1, 1, 2, N'add', NULL, NULL)
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [Note], [CreatedBy], [EntryDate]) VALUES (2, N'ADJ-2020090000000002', 1, 1, -2, N'Decrease...', NULL, NULL)
INSERT [dbo].[StockAdjustment] ([Id], [AdjustmentNo], [WarehouseId], [ProductId], [Quantity], [Note], [CreatedBy], [EntryDate]) VALUES (3, N'ADJ-2020090000000003', 8, 1, -1, N'Decrease one product of X-phone', NULL, NULL)
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
/****** Object:  Index [UQ__Authoriz__1788CC4D0FBC0E7D]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Authorizations] ADD UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Authoriz__D4E7DFA8C7F9AAF7]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[AuthorizeType] ADD  CONSTRAINT [UQ__Authoriz__D4E7DFA8C7F9AAF7] UNIQUE NONCLUSTERED 
(
	[TypeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Brand__737584F6E51F9A50]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Brand] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Customer__5C7E359E545FCC7B]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Customer__A9D105342D6D1D37]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Damage__8A0F29487DFA2C8C]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Damage] ADD UNIQUE NONCLUSTERED 
(
	[DamageNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Manufact__3B9CDE2ED12CA066]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Manufacturer] ADD  CONSTRAINT [UQ__Manufact__3B9CDE2ED12CA066] UNIQUE NONCLUSTERED 
(
	[ManufacturerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__OrderDis__434D95C739A83EF7]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[OrderDispatch] ADD UNIQUE NONCLUSTERED 
(
	[DispatchNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__OrderRet__F445F15AE54AFF67]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[OrderReturn] ADD UNIQUE NONCLUSTERED 
(
	[ReturnNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Orders__C3907C75D1585BAD]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [UQ__Orders__C3907C75D1585BAD] UNIQUE NONCLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Payment__554342D9B731789B]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Payment] ADD  CONSTRAINT [UQ__Payment__554342D9B731789B] UNIQUE NONCLUSTERED 
(
	[TransactionNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__PaymentM__737584F62EB6018B]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[PaymentMethods] ADD UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Personal__1788CC4D4B2A1430]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[PersonalDetail] ADD  CONSTRAINT [UQ__Personal__1788CC4D4B2A1430] UNIQUE NONCLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__ProductI__F57A9DFC897AE8EA]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[ProductInsertion] ADD UNIQUE NONCLUSTERED 
(
	[EntryNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__ProductI__CA167712CADD7D4E]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[ProductItems] ADD  CONSTRAINT [UQ__ProductI__CA167712CADD7D4E] UNIQUE NONCLUSTERED 
(
	[ItemSerial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Products__2F4E024FA30573CB]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Products] ADD  CONSTRAINT [UQ__Products__2F4E024FA30573CB] UNIQUE NONCLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Refunds__725A61B209FD4997]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Refunds] ADD UNIQUE NONCLUSTERED 
(
	[RefundNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__SalesRet__E0900466B0452FA9]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[SalesReturn] ADD UNIQUE NONCLUSTERED 
(
	[SalesReturnNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__StockAdj__E60D0EF1D06C6850]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[StockAdjustment] ADD  CONSTRAINT [UQ__StockAdj__E60D0EF1D06C6850] UNIQUE NONCLUSTERED 
(
	[AdjustmentNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Supplier__5C7E359EA5101B85]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Supplier] ADD UNIQUE NONCLUSTERED 
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Supplier__A9D10534EA803924]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Supplier] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Users__A9D10534D36E8D6C]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UQ__Users__A9D10534D36E8D6C] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Users__C9F28456F39F222E]    Script Date: 10/12/2020 10:14:05 AM ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__UserType__D4E7DFA807F3DAE4]    Script Date: 10/12/2020 10:14:05 AM ******/
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
