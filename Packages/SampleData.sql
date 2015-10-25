-- Create Databases
USE [master]

CREATE DATABASE [MSPetShop4];
CREATE DATABASE [MSPetShop4Orders]
CREATE DATABASE [MSPetShop4Profile]
CREATE DATABASE [MSPetShop4Services]

GO
-- Create Logins
USE [MSPetShop4]

if not exists (select * from master.dbo.syslogins where loginname = N'mspetshop')
BEGIN
	exec sp_addlogin 'mspetshop' ,'pass@word1', 'MSPetShop4'
END

exec sp_grantdbaccess 'mspetshop'

exec sp_addrolemember 'db_owner', 'mspetshop'

USE [MSPetShop4Orders]

if not exists (select * from master.dbo.syslogins where loginname = N'mspetshop')
BEGIN
	exec sp_addlogin 'mspetshop' ,'pass@word1', 'MSPetShop4Orders'
END

exec sp_grantdbaccess 'mspetshop'

exec sp_addrolemember 'db_owner', 'mspetshop'

USE [MSPetShop4Profile]

if not exists (select * from master.dbo.syslogins where loginname = N'mspetshop')
BEGIN
	exec sp_addlogin 'mspetshop' ,'pass@word1', 'MSPetShop4Profile'
END

exec sp_grantdbaccess 'mspetshop'

exec sp_addrolemember 'db_owner', 'mspetshop'

USE [MSPetShop4Services]

if not exists (select * from master.dbo.syslogins where loginname = N'mspetshop')
BEGIN
	exec sp_addlogin 'mspetshop' ,'pass@word1', 'MSPetShop4Services'
END

exec sp_grantdbaccess 'mspetshop'

exec sp_addrolemember 'db_owner', 'mspetshop'

-- Create Tables

USE [MSPetShop4]

CREATE TABLE [Category] (
	[CategoryId] varchar(10) PRIMARY KEY,
	[Name] varchar(80) NULL,
	[Descn] varchar(255) NULL
)

CREATE TABLE [Inventory] (
	[ItemId] varchar(10) PRIMARY KEY,
	[Qty] int NOT NULL
)

CREATE TABLE [Supplier] (
	[SuppId] int PRIMARY KEY,
	[Name] varchar(80) NULL,
	[Status] varchar(2) NOT NULL,
	[Addr1] varchar(80) NULL,
	[Addr2] varchar(80) NULL,
	[City] varchar(80) NULL,
	[State] varchar(80) NULL,
	[Zip] varchar(5) NULL,
	[Phone] varchar(40) NULL 
)

CREATE TABLE [Product] (
	[ProductId] varchar(10) PRIMARY KEY,
	[CategoryId] varchar(10) NOT NULL REFERENCES [Category]([CategoryId]),
	[Name] varchar(80) NULL,
	[Descn] varchar(255) NULL,
	[Image] varchar(80) NULL
)

CREATE TABLE [Item] (
	[ItemId] varchar(10) PRIMARY KEY,
	[ProductId] varchar(10) NOT NULL REFERENCES [Product]([ProductId]),
	[ListPrice] decimal(10, 2) NULL,
	[UnitCost] decimal(10, 2) NULL,
	[Supplier] int NULL REFERENCES [Supplier]([SuppId]),
	[Status] varchar(2) NULL,
	[Name] varchar(80) NULL,
	[Image] varchar(80) NULL
)

CREATE INDEX [IxItem] ON [Item]([ProductId], [ItemId], [ListPrice], [Name])

CREATE INDEX [IxProduct1] ON [Product]([Name])
CREATE INDEX [IxProduct2] ON [Product]([CategoryId])
CREATE INDEX [IxProduct3] ON [Product]([CategoryId], [Name])
CREATE INDEX [IxProduct4] ON [Product]([CategoryId], [ProductId], [Name])

USE [MSPetShop4Orders]

CREATE TABLE [Orders] (
	[OrderId] int IDENTITY PRIMARY KEY,
	[UserId] varchar(20) NOT NULL,
	[OrderDate] datetime NOT NULL,
	[ShipAddr1] varchar(80) NOT NULL,
	[ShipAddr2] varchar(80) NULL,
	[ShipCity] varchar(80) NOT NULL,
	[ShipState] varchar(80) NOT NULL,
	[ShipZip] varchar(20) NOT NULL,
	[ShipCountry] varchar(20) NOT NULL,
	[BillAddr1] varchar(80) NOT NULL,
	[BillAddr2] varchar(80) NULL,
	[BillCity] varchar(80) NOT NULL,
	[BillState] varchar(80) NOT NULL,
	[BillZip] varchar(20) NOT NULL,
	[BillCountry] varchar(20) NOT NULL,
	[Courier] varchar(80) NOT NULL,
	[TotalPrice] decimal(10, 2) NOT NULL,
	[BillToFirstName] varchar(80) NOT NULL,
	[BillToLastName] varchar(80) NOT NULL,
	[ShipToFirstName] varchar(80) NOT NULL,
	[ShipToLastName] varchar(80) NOT NULL,
	[AuthorizationNumber] int NOT NULL,
	[Locale] varchar(20) NOT NULL
)

CREATE TABLE [LineItem] (
	[OrderId] int NOT NULL REFERENCES [Orders]([OrderId]),
	[LineNum] int NOT NULL,
	[ItemId] varchar(10) NOT NULL,
	[Quantity] int NOT NULL,
	[UnitPrice] decimal(10, 2) NOT NULL,
	CONSTRAINT [PkLineItem] PRIMARY KEY ([OrderId], [LineNum])
)

CREATE TABLE [OrderStatus] (
	[OrderId] int NOT NULL REFERENCES [Orders]([OrderId]),
	[LineNum] int NOT NULL,
	[Timestamp] datetime NOT NULL,
	[Status] varchar(2) NOT NULL,
	CONSTRAINT [PkOrderStatus] PRIMARY KEY ([OrderId], [LineNum])
)

USE [MSPetShop4Profile]

CREATE TABLE [Profiles] (
    [UniqueID] [int] IDENTITY (1, 1) NOT NULL ,
    [Username] [varchar] (256)  NOT NULL ,
    [ApplicationName] [varchar] (256)  NOT NULL ,
    [IsAnonymous] [bit] NULL ,
    [LastActivityDate] [datetime] NULL ,
    [LastUpdatedDate] [datetime] NULL ,
    CONSTRAINT [PK_Profiles_1] PRIMARY KEY  NONCLUSTERED 
    (
        [UniqueID]
    )  ON [PRIMARY] ,
    CONSTRAINT [PK_Profiles] UNIQUE  CLUSTERED 
    (
        [Username],
        [ApplicationName]
    )  ON [PRIMARY] 
) ON [PRIMARY]

CREATE TABLE [Cart] (
    [UniqueID] [int] NOT NULL ,
    [ItemId] [varchar] (10)  NOT NULL ,
    [Name] [varchar] (80)  NOT NULL ,
    [Type] [varchar] (80)  NOT NULL ,
    [Price] [decimal](10, 2) NOT NULL ,
    [CategoryId] [varchar] (10)  NOT NULL ,
    [ProductId] [varchar] (10)  NOT NULL ,
    [IsShoppingCart] [bit]  NOT NULL ,
    [Quantity] [int] NOT NULL ,
    CONSTRAINT [FK_Cart_Profiles] FOREIGN KEY 
    (
        [UniqueID]
    ) REFERENCES [Profiles] (
        [UniqueID]
    ) ON DELETE CASCADE  ON UPDATE CASCADE 
) ON [PRIMARY]

CREATE TABLE [Account] (
    [UniqueID] [int] NOT NULL ,
    [Email] [varchar] (80)  NOT NULL ,
    [FirstName] [varchar] (80)  NOT NULL ,
    [LastName] [varchar] (80)  NOT NULL ,
    [Address1] [varchar] (80)  NOT NULL ,
    [Address2] [varchar] (80)  NULL ,
    [City] [varchar] (80)  NOT NULL ,
    [State] [varchar] (80)  NOT NULL ,
    [Zip] [varchar] (20)  NOT NULL ,
    [Country] [varchar] (20)  NOT NULL ,
    [Phone] [varchar] (20)  NULL ,
    CONSTRAINT [FK_Account_Profiles] FOREIGN KEY (
        [UniqueID]
    ) REFERENCES [Profiles] (
        [UniqueID]
    ) ON DELETE CASCADE  ON UPDATE CASCADE 
) ON [PRIMARY]

CREATE  CLUSTERED  INDEX [FK_Cart_UniqueID] ON [dbo].[Cart]([UniqueID]) ON [PRIMARY]

CREATE  CLUSTERED  INDEX [FK_Account_UniqueID] ON [dbo].[Account]([UniqueID]) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_SHOPPINGCART] ON [dbo].[Cart] (
	[IsShoppingCart] ASC
)


-- Create Demo users
USE [MSPetShop4Profile]

DECLARE @userid int

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'AdamBarr', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone@microsoft.com', 'Adam', 'Barr', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'KimAbercrombie', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone1@microsoft.com', 'Kim', 'Abercrombie', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')
           
INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'RobYoung', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone2@microsoft.com', 'Rob', 'Young', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'TomYoutsey', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone3@microsoft.com', 'Tom', 'Youtsey', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'GaryWYukish', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone4@microsoft.com', 'Gary W.', 'Yukish', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'RobCaron', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone5@microsoft.com', 'Rob', 'Caron', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'KarinZimprich', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone6@microsoft.com', 'Karin', 'Zimprich', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'RandallBoseman', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone7@microsoft.com', 'Randall', 'Boseman', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'KevinKennedy', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone8@microsoft.com', 'Kevin', 'Kennedy', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'DianeTibbott', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone9@microsoft.com', 'Diane', 'Tibbott', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'GarrettYoung', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone10@microsoft.com', 'Garrett', 'Young', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')           

INSERT INTO [Profiles] (
	[Username], [ApplicationName], [IsAnonymous], [LastActivityDate], [LastUpdatedDate]
)
VALUES (
     'demo', '.NET Pet Shop 4.0', 0, GETDATE(), GETDATE()
)
SET @userid = (SELECT @@IDENTITY)
INSERT INTO [Account] ([UniqueID], [Email], [FirstName], [LastName], [Address1], [Address2], [City], [State], [Zip], [Country], [Phone])
     VALUES
           (@userid, 'someone@microsoft.com', 'Adam', 'Barr', 'Vertigo Software, Inc.', '503A Canal Blvd.', 'Point Richmond', 'CA', '94804', 'USA', '(510) 307-8200')


-- Load tables with data

USE [MSPetShop4]

INSERT INTO [Category] VALUES ('FISH', 'Fish', 'Fish')
INSERT INTO [Category] VALUES ('BYARD', 'Backyard','Backyard')
INSERT INTO [Category] VALUES ('BIRDS', 'Birds', 'Birds')
INSERT INTO [Category] VALUES ('BUGS', 'Bugs', 'Bugs')
INSERT INTO [Category] VALUES ('EDANGER', 'Endangered', 'Endangered')

INSERT INTO [Supplier] VALUES (1, 'XYZ Pets', 'AC', '600 Avon Way', '', 'Los Angeles', 'CA', '94024', '212-947-0797')
INSERT INTO [Supplier] VALUES (2, 'ABC Pets', 'AC', '700 Abalone Way', '', 'San Francisco', 'CA', '94024', '415-947-0797')

INSERT INTO [Product] VALUES ('FI-01', 'FISH', 'Meno', 'Your worried tiny friend warns you about life''s dangers', '~/Prod_Images/Fish/icon-meno.gif')
INSERT INTO [Product] VALUES ('FI-02', 'FISH', 'Balloonfish', 'It''s your thermometer - the hotter it gets the bigger it gets', '~/Prod_Images/Fish/icon-ballonfish.gif')
INSERT INTO [Product] VALUES ('FI-03', 'FISH', 'Blindfish', 'Likes pressure - ideal for divorcing couples', '~/Prod_Images/Fish/icon-blindfish.gif')
INSERT INTO [Product] VALUES ('FI-04', 'FISH', 'Crabfish', 'Dances and sings every time you feed it!', '~/Prod_Images/Fish/icon-Crabfish.gif')
INSERT INTO [Product] VALUES ('FI-05', 'FISH', 'Eucalyptus', 'For the tickle on your hands: you''ll love the massage', '~/Prod_Images/Fish/icon-eucalyptus.gif')
INSERT INTO [Product] VALUES ('FI-06', 'FISH', 'Mister No', 'Need a companion for the dark times?', '~/Prod_Images/Fish/icon-misterno.gif')
INSERT INTO [Product] VALUES ('FI-07', 'FISH', 'Nosyfish', 'Don''t underestimate this one - it bites!', '~/Prod_Images/Fish/icon-nosyfish.gif')
INSERT INTO [Product] VALUES ('FI-08', 'FISH', 'Tooth Ferry', 'Very sensitive vegetarian, needs food every two months', '~/Prod_Images/Fish/icon-toothferry.gif')
INSERT INTO [Product] VALUES ('BY-01', 'BYARD', 'Sheep', 'Your soft hugging buddy', '~/Prod_Images/Backyard/icon-sheep.gif')
INSERT INTO [Product] VALUES ('BY-02', 'BYARD', 'Cat', 'The friend you will never see', '~/Prod_Images/Backyard/icon-cat.gif')
INSERT INTO [Product] VALUES ('BY-03', 'BYARD', 'Raccoon', 'Always keeps your dishes clean', '~/Prod_Images/Backyard/icon-raccoon.gif')
INSERT INTO [Product] VALUES ('BY-04', 'BYARD', 'Goose', 'For your protection delivered in our special safety-bag', '~/Prod_Images/Backyard/icon-goose.gif')
INSERT INTO [Product] VALUES ('BY-05', 'BYARD', 'Crab', 'The common house crab which lives in the refrigerator', '~/Prod_Images/Backyard/icon-crab.gif')
INSERT INTO [Product] VALUES ('BY-06', 'BYARD', 'Skunk', 'You will love it - especially when you have your in-laws visiting', '~/Prod_Images/Backyard/icon-skunk.gif')
INSERT INTO [Product] VALUES ('BY-07', 'BYARD', 'Zebra', 'The horse of the modern girl', '~/Prod_Images/Backyard/icon-zebra.gif')
INSERT INTO [Product] VALUES ('BD-01', 'BIRDS', 'Pelican', 'Will sit in your garden and admire nature', '~/Prod_Images/Birds/icon-pelican.gif')
INSERT INTO [Product] VALUES ('BD-02', 'BIRDS', 'Penguin', 'Guaranteed to stay by your side', '~/Prod_Images/Birds/icon-penguin.gif')
INSERT INTO [Product] VALUES ('BD-03', 'BIRDS', 'Pteranodon', 'Can''t let go of the past? This is your bird', '~/Prod_Images/Birds/icon-pteranodon.gif')
INSERT INTO [Product] VALUES ('BD-04', 'BIRDS', 'Owl', 'Your personal dictionary � night & day', '~/Prod_Images/Birds/icon-owl.gif')
INSERT INTO [Product] VALUES ('BD-05', 'BIRDS', 'Duck', 'Lisps but otherwise sings well', '~/Prod_Images/Birds/icon-duck.gif')
INSERT INTO [Product] VALUES ('BG-01', 'BUGS', 'Ant', 'Trash your vacuum cleaner', '~/Prod_Images/Bugs/icon-ant.gif')
INSERT INTO [Product] VALUES ('BG-02', 'BUGS', 'Butterfly', 'Increased beauty with age', '~/Prod_Images/Bugs/icon-butterfly.gif')
INSERT INTO [Product] VALUES ('BG-03', 'BUGS', 'Spider', 'Loves a good massage', '~/Prod_Images/Bugs/icon-spider.gif')
INSERT INTO [Product] VALUES ('BG-04', 'BUGS', 'Slug', 'Your soft hugging buddy', '~/Prod_Images/Bugs/icon-slug.gif')
INSERT INTO [Product] VALUES ('BG-05', 'BUGS', 'Frog', 'Want to get rid of an insect previously bought?', '~/Prod_Images/Bugs/icon-frog.gif')
INSERT INTO [Product] VALUES ('BG-06', 'BUGS', 'Dragonfly', 'Beware of the meat lover', '~/Prod_Images/Bugs/icon-dragonfly.gif')
INSERT INTO [Product] VALUES ('DR-01', 'EDANGER', 'Skeleton', 'Dumb but hollow', '~/Prod_Images/Endangered/icon-skeleton.gif')
INSERT INTO [Product] VALUES ('DR-02', 'EDANGER', 'Pet', 'The originals � honestly!', '~/Prod_Images/Endangered/icon-pet.gif')
INSERT INTO [Product] VALUES ('DR-03', 'EDANGER', 'Dino', 'Special offer: only for a limited time', '~/Prod_Images/Endangered/icon-dino.gif')
INSERT INTO [Product] VALUES ('DR-04', 'EDANGER', 'Panda', 'Last one � go for it!', '~/Prod_Images/Endangered/icon-panda.gif')
INSERT INTO [Product] VALUES ('DR-05', 'EDANGER', 'Fish', 'They are waiting for your help', '~/Prod_Images/Endangered/icon-fish.gif')

INSERT INTO [Item] VALUES ('EST-1', 'FI-01', 16.50, 10.00, 1, 'P', 'Happy', '~/Prod_Images/Fish/item-meno-happy.gif')
INSERT INTO [Item] VALUES ('EST-2', 'FI-01', 17.50, 10.00, 1, 'P', 'Camouflage', '~/Prod_Images/Fish/item-meno-camouflage.gif')
INSERT INTO [Item] VALUES ('EST-3', 'FI-01', 15.90, 10.00, 1, 'P', 'Worried', '~/Prod_Images/Fish/item-meno-worried.gif')
INSERT INTO [Item] VALUES ('EST-4', 'FI-02', 17.50, 12.00, 1, 'P', 'Extra Stretch', '~/Prod_Images/Fish/item-balloon-extra-stretch.gif')
INSERT INTO [Item] VALUES ('EST-5', 'FI-02', 18.90, 12.00, 1, 'P', 'Natural', '~/Prod_Images/Fish/item-balloon-natural.gif')
INSERT INTO [Item] VALUES ('EST-6', 'FI-02', 19.50, 12.00, 1, 'P', 'Flammable', '~/Prod_Images/Fish/item-balloon-flammable.gif')
INSERT INTO [Item] VALUES ('EST-7', 'FI-03', 21.50, 15.00, 1, 'P', 'Blind', '~/Prod_Images/Fish/item-blindfish-blind.gif')
INSERT INTO [Item] VALUES ('EST-8', 'FI-03', 22.50, 15.00, 1, 'P', 'Short Sighted', '~/Prod_Images/Fish/item-blindfish-shortsighted.gif')
INSERT INTO [Item] VALUES ('EST-9', 'FI-03', 24.50, 15.00, 1, 'P', 'Far Sighted', '~/Prod_Images/Fish/item-blindfish-farsighted.gif')
INSERT INTO [Item] VALUES ('EST-10', 'FI-04', 18.50, 12.00, 1, 'P', 'Tap Dance', '~/Prod_Images/Fish/item-Crabfish-tabdance.gif')
INSERT INTO [Item] VALUES ('EST-11', 'FI-04', 19.50, 12.00, 1, 'P', 'Ballet', '~/Prod_Images/Fish/item-Crabfish-ballet.gif')
INSERT INTO [Item] VALUES ('EST-12', 'FI-04', 18.90, 12.00, 1, 'P', 'Ballroom', '~/Prod_Images/Fish/item-Crabfish-ballroom.gif')
INSERT INTO [Item] VALUES ('EST-13', 'FI-05', 16.50, 10.00, 1, 'P', 'Long Arms', '~/Prod_Images/Fish/item-eucalyptus-longarms.gif')
INSERT INTO [Item] VALUES ('EST-14', 'FI-05', 16.90, 10.00, 1, 'P', 'Short Arms', '~/Prod_Images/Fish/item-eucalyptus-shortarms.gif')
INSERT INTO [Item] VALUES ('EST-15', 'FI-06', 13.90, 8.00, 1, 'P', 'Black', '~/Prod_Images/Fish/item-misterno-black.gif')
INSERT INTO [Item] VALUES ('EST-16', 'FI-06', 14.50, 8.00, 1, 'P', 'Sepia', '~/Prod_Images/Fish/item-misterno-sepia.gif')
INSERT INTO [Item] VALUES ('EST-17', 'FI-06', 15.50, 8.00, 1, 'P', 'Sable', '~/Prod_Images/Fish/item-misterno-sable.gif')
INSERT INTO [Item] VALUES ('EST-18', 'FI-07', 16.50, 10.00, 1, 'P', 'Invidious', '~/Prod_Images/Fish/item-nosyfish-invidious.gif')
INSERT INTO [Item] VALUES ('EST-19', 'FI-07', 17.50, 10.00, 1, 'P', 'Beastly', '~/Prod_Images/Fish/item-nosyfish-beastly.gif')
INSERT INTO [Item] VALUES ('EST-20', 'FI-07', 18.50, 10.00, 1, 'P', 'Mean', '~/Prod_Images/Fish/item-nosyfish-mean.gif')
INSERT INTO [Item] VALUES ('EST-21', 'FI-07', 19.50, 10.00, 1, 'P', 'Sneaky', '~/Prod_Images/Fish/item-nosyfish-sneaky.gif')
INSERT INTO [Item] VALUES ('EST-22', 'FI-08', 28.50, 20.00, 1, 'P', 'Toothless', '~/Prod_Images/Fish/item-toothferry-toothless.gif')
INSERT INTO [Item] VALUES ('EST-23', 'FI-08', 29.50, 20.00, 1, 'P', 'With Teeth', '~/Prod_Images/Fish/item-toothferry-withteeth.gif')
INSERT INTO [Item] VALUES ('EST-24', 'BY-01', 120.95, 99.00, 1, 'P', 'Fuzzy', '~/Prod_Images/Backyard/item-sheep-fuzzy.gif')
INSERT INTO [Item] VALUES ('EST-25', 'BY-01', 130.95, 99.00, 1, 'P', 'Ironed', '~/Prod_Images/Backyard/item-sheep-ironed.gif')
INSERT INTO [Item] VALUES ('EST-26', 'BY-02', 14.95, 2.00, 1, 'P', 'Transparent', '~/Prod_Images/Backyard/item-cat-transparent.gif')
INSERT INTO [Item] VALUES ('EST-27', 'BY-02', 15.95, 2.00, 1, 'P', 'Patterned', '~/Prod_Images/Backyard/item-cat-patterned.gif')
INSERT INTO [Item] VALUES ('EST-28', 'BY-02', 18.95, 2.00, 1, 'P', 'Uncolored', '~/Prod_Images/Backyard/item-cat-uncolored.gif')
INSERT INTO [Item] VALUES ('EST-29', 'BY-03', 42.95, 30.00, 1, 'P', 'Long Tongue', '~/Prod_Images/Backyard/item-raccoon-long-tongue.gif')
INSERT INTO [Item] VALUES ('EST-30', 'BY-03', 45.95, 30.00, 1, 'P', 'Rough Tongue', '~/Prod_Images/Backyard/item-raccoon-rough-tongue.gif')
INSERT INTO [Item] VALUES ('EST-31', 'BY-03', 48.95, 30.00, 1, 'P', 'Hairy Tongue', '~/Prod_Images/Backyard/item-raccoon-hairy-tongue.gif')
INSERT INTO [Item] VALUES ('EST-32', 'BY-04', 20.95, 12.00, 1, 'P', 'Feathered', '~/Prod_Images/Backyard/item-goose-feathered.gif')
INSERT INTO [Item] VALUES ('EST-33', 'BY-04', 22.95, 12.00, 1, 'P', 'Plucked', '~/Prod_Images/Backyard/item-goose-plucked.gif')
INSERT INTO [Item] VALUES ('EST-34', 'BY-05', 12.95, 10.00, 1, 'P', 'Red', '~/Prod_Images/Backyard/item-crab-red.gif')
INSERT INTO [Item] VALUES ('EST-35', 'BY-05', 13.95, 10.00, 1, 'P', 'Orange', '~/Prod_Images/Backyard/item-crab-orange.gif')
INSERT INTO [Item] VALUES ('EST-36', 'BY-05', 14.95, 10.00, 1, 'P', 'Dotted', '~/Prod_Images/Backyard/item-crab-dotted.gif')
INSERT INTO [Item] VALUES ('EST-37', 'BY-06', 18.95, 12.00, 1, 'P', 'Bad Smell', '~/Prod_Images/Backyard/item-skunk-bad-smell.gif')
INSERT INTO [Item] VALUES ('EST-38', 'BY-06', 20.95, 12.00, 1, 'P', 'Really Bad Smell', '~/Prod_Images/Backyard/item-skunk-really-bad-smell.gif')
INSERT INTO [Item] VALUES ('EST-39', 'BY-06', 22.95, 12.00, 1, 'P', 'Worst Smell', '~/Prod_Images/Backyard/item-skunk-worst-smell.gif')
INSERT INTO [Item] VALUES ('EST-40', 'BY-07', 859.95, 500.00, 1, 'P', 'Tiny', '~/Prod_Images/Backyard/item-zebra-tiny.gif')
INSERT INTO [Item] VALUES ('EST-41', 'BY-07', 879.95, 500.00, 1, 'P', 'Small', '~/Prod_Images/Backyard/item-zebra-small.gif')
INSERT INTO [Item] VALUES ('EST-42', 'BY-07', 899.95, 500.00, 1, 'P', 'Medium', '~/Prod_Images/Backyard/item-zebra-medium.gif')
INSERT INTO [Item] VALUES ('EST-43', 'BY-07', 949.95, 500.00, 1, 'P', 'Large', '~/Prod_Images/Backyard/item-zebra-large.gif')
INSERT INTO [Item] VALUES ('EST-44', 'BD-01', 41.95, 30.00, 1, 'P', 'Flower Loving', '~/Prod_Images/Birds/item-pelican-flowerloving.gif')
INSERT INTO [Item] VALUES ('EST-45', 'BD-01', 45.95, 30.00, 1, 'P', 'Grass Loving', '~/Prod_Images/Birds/item-pelican-grassloving.gif')
INSERT INTO [Item] VALUES ('EST-46', 'BD-02', 120.99, 99.00, 1, 'P', 'Adventurous', '~/Prod_Images/Birds/item-penguine-adventurous.gif')
INSERT INTO [Item] VALUES ('EST-47', 'BD-02', 130.99, 99.00, 1, 'P', 'Homey', '~/Prod_Images/Birds/item-penguine-homey.gif')
INSERT INTO [Item] VALUES ('EST-48', 'BD-03', 130.99, 99.00, 1, 'P', 'Old', '~/Prod_Images/Birds/item-pteranodon-old.gif')
INSERT INTO [Item] VALUES ('EST-49', 'BD-03', 130.99, 99.00, 1, 'P', 'Ancient', '~/Prod_Images/Birds/item-pteranodon-ancient.gif')
INSERT INTO [Item] VALUES ('EST-50', 'BD-04', 80.99, 50.00, 1, 'P', 'Day', '~/Prod_Images/Birds/item-owl-day.gif')
INSERT INTO [Item] VALUES ('EST-51', 'BD-04', 85.99, 50.00, 1, 'P', 'Night', '~/Prod_Images/Birds/item-owl-night.gif')
INSERT INTO [Item] VALUES ('EST-52', 'BD-05', 33.99, 20.00, 1, 'P', 'Domestic', '~/Prod_Images/Birds/item-duck-domestic.gif')
INSERT INTO [Item] VALUES ('EST-53', 'BD-05', 38.99, 20.00, 1, 'P', 'Wild', '~/Prod_Images/Birds/item-duck-wild.gif')
INSERT INTO [Item] VALUES ('EST-54', 'BG-01', 0.25, 0.02, 1, 'P', 'Worker', '~/Prod_Images/Bugs/item-ant-worker.gif')
INSERT INTO [Item] VALUES ('EST-55', 'BG-01', 0.30, 0.02, 1, 'P', 'Queen', '~/Prod_Images/Bugs/item-ant-queen.gif')
INSERT INTO [Item] VALUES ('EST-56', 'BG-01', 0.50, 0.02, 1, 'P', 'Soldier', '~/Prod_Images/Bugs/item-ant-soldier.gif')
INSERT INTO [Item] VALUES ('EST-57', 'BG-02', 0.70, 0.10, 1, 'P', 'Larva', '~/Prod_Images/Bugs/item-butterfly-larva.gif')
INSERT INTO [Item] VALUES ('EST-58', 'BG-02', 0.80, 0.10, 1, 'P', 'Pupa', '~/Prod_Images/Bugs/item-butterfly-pupa.gif')
INSERT INTO [Item] VALUES ('EST-59', 'BG-02', 0.90, 0.10, 1, 'P', 'Adult', '~/Prod_Images/Bugs/item-butterfly-adult.gif')
INSERT INTO [Item] VALUES ('EST-60', 'BG-03', 2.50, 1.00, 1, 'P', 'Arniladisplicata', '~/Prod_Images/Bugs/item-spider-aranielladisplicata.gif')
INSERT INTO [Item] VALUES ('EST-61', 'BG-03', 2.60, 1.00, 1, 'P', 'Dysdera Crocata', '~/Prod_Images/Bugs/item-spider-dysderacrocata.gif')
INSERT INTO [Item] VALUES ('EST-62', 'BG-04', 0.89, 0.15, 1, 'P', 'Naked', '~/Prod_Images/Bugs/item-slug-naked.gif')
INSERT INTO [Item] VALUES ('EST-63', 'BG-04', 0.99, 0.15, 1, 'P', 'Habitat', '~/Prod_Images/Bugs/item-slug-habitat.gif')
INSERT INTO [Item] VALUES ('EST-64', 'BG-05', 8.99, 2.50, 1, 'P', 'False', '~/Prod_Images/Bugs/item-frog-false.gif')
INSERT INTO [Item] VALUES ('EST-65', 'BG-05', 9.99, 2.50, 1, 'P', 'True', '~/Prod_Images/Bugs/item-frog-true.gif')
INSERT INTO [Item] VALUES ('EST-66', 'BG-06', 1.20, 0.80, 1, 'P', 'Omnivore', '~/Prod_Images/Bugs/item-dragonfly-omnivore.gif')
INSERT INTO [Item] VALUES ('EST-67', 'BG-06', 1.30, 0.80, 1, 'P', 'Vegetarian', '~/Prod_Images/Bugs/item-dragonfly-vegetarian.gif')
INSERT INTO [Item] VALUES ('EST-68', 'BG-06', 1.40, 0.80, 1, 'P', 'Vegan', '~/Prod_Images/Bugs/item-dragonfly-vegan.gif')
INSERT INTO [Item] VALUES ('EST-69', 'DR-01', 150.00, 100.00, 1, 'P', 'Male', '~/Prod_Images/Endangered/item-skeleton-male.gif')
INSERT INTO [Item] VALUES ('EST-70', 'DR-01', 160.00, 100.00, 1, 'P', 'Female', '~/Prod_Images/Endangered/item-skeleton-female.gif')
INSERT INTO [Item] VALUES ('EST-71', 'DR-01', 170.00, 100.00, 1, 'P', 'Aphrodite', '~/Prod_Images/Endangered/item-skeleton-aphrodite.gif')
INSERT INTO [Item] VALUES ('EST-72', 'DR-01', 180.00, 100.00, 1, 'P', 'Hermaphrodite', '~/Prod_Images/Endangered/item-skeleton-hermaphrodite.gif')
INSERT INTO [Item] VALUES ('EST-73', 'DR-02', 45.00, 22.00, 1, 'P', 'Rover', '~/Prod_Images/Endangered/item-pet-rover.gif')
INSERT INTO [Item] VALUES ('EST-74', 'DR-02', 48.00, 22.00, 1, 'P', 'Trumpet', '~/Prod_Images/Endangered/item-pet-thumper.gif')
INSERT INTO [Item] VALUES ('EST-75', 'DR-02', 49.00, 22.00, 1, 'P', 'Kitty', '~/Prod_Images/Endangered/item-pet-kitty.gif')
INSERT INTO [Item] VALUES ('EST-76', 'DR-03', 349.00, 220.00, 1, 'P', 'Spiky', '~/Prod_Images/Endangered/item-dino-spiky.gif')
INSERT INTO [Item] VALUES ('EST-77', 'DR-03', 379.00, 220.00, 1, 'P', 'Shaved', '~/Prod_Images/Endangered/item-dino-shaved.gif')
INSERT INTO [Item] VALUES ('EST-78', 'DR-03', 399.00, 220.00, 1, 'P', 'Pointy', '~/Prod_Images/Endangered/item-dino-pointy.gif')
INSERT INTO [Item] VALUES ('EST-79', 'DR-04', 1999.00, 1500.00, 1, 'P', 'Exclusive', '~/Prod_Images/Endangered/item-panda-exclusive.gif')
INSERT INTO [Item] VALUES ('EST-80', 'DR-05', 22.95, 16.00, 1, 'P', 'Lost', '~/Prod_Images/Endangered/item-fish-lost.gif')
INSERT INTO [Item] VALUES ('EST-81', 'DR-05', 22.95, 16.00, 1, 'P', 'Drunk', '~/Prod_Images/Endangered/item-fish-drunk.gif')
INSERT INTO [Item] VALUES ('EST-82', 'DR-05', 22.95, 16.00, 1, 'P', 'Caught', '~/Prod_Images/Endangered/item-fish-caught.gif')

INSERT INTO [Inventory] VALUES ('EST-1', 10000)
INSERT INTO [Inventory] VALUES ('EST-2', 10000)
INSERT INTO [Inventory] VALUES ('EST-3', 10000)
INSERT INTO [Inventory] VALUES ('EST-4', 10000)
INSERT INTO [Inventory] VALUES ('EST-5', 10000)
INSERT INTO [Inventory] VALUES ('EST-6', 10000)
INSERT INTO [Inventory] VALUES ('EST-7', 10000)
INSERT INTO [Inventory] VALUES ('EST-8', 10000)
INSERT INTO [Inventory] VALUES ('EST-9', 10000)
INSERT INTO [Inventory] VALUES ('EST-10', 10000)
INSERT INTO [Inventory] VALUES ('EST-11', 10000)
INSERT INTO [Inventory] VALUES ('EST-12', 10000)
INSERT INTO [Inventory] VALUES ('EST-13', 10000)
INSERT INTO [Inventory] VALUES ('EST-14', 10000)
INSERT INTO [Inventory] VALUES ('EST-15', 10000)
INSERT INTO [Inventory] VALUES ('EST-16', 10000)
INSERT INTO [Inventory] VALUES ('EST-17', 10000)
INSERT INTO [Inventory] VALUES ('EST-18', 10000)
INSERT INTO [Inventory] VALUES ('EST-19', 10000)
INSERT INTO [Inventory] VALUES ('EST-20', 10000)
INSERT INTO [Inventory] VALUES ('EST-21', 10000)
INSERT INTO [Inventory] VALUES ('EST-22', 10000)
INSERT INTO [Inventory] VALUES ('EST-23', 10000)
INSERT INTO [Inventory] VALUES ('EST-24', 10000)
INSERT INTO [Inventory] VALUES ('EST-25', 10000)
INSERT INTO [Inventory] VALUES ('EST-26', 10000)
INSERT INTO [Inventory] VALUES ('EST-27', 10000)
INSERT INTO [Inventory] VALUES ('EST-28', 10000)
INSERT INTO [Inventory] VALUES ('EST-29', 10000)
INSERT INTO [Inventory] VALUES ('EST-30', 10000)
INSERT INTO [Inventory] VALUES ('EST-31', 10000)
INSERT INTO [Inventory] VALUES ('EST-32', 10000)
INSERT INTO [Inventory] VALUES ('EST-33', 10000)
INSERT INTO [Inventory] VALUES ('EST-34', 10000)
INSERT INTO [Inventory] VALUES ('EST-35', 10000)
INSERT INTO [Inventory] VALUES ('EST-36', 10000)
INSERT INTO [Inventory] VALUES ('EST-37', 10000)
INSERT INTO [Inventory] VALUES ('EST-38', 10000)
INSERT INTO [Inventory] VALUES ('EST-39', 10000)
INSERT INTO [Inventory] VALUES ('EST-40', 10000)
INSERT INTO [Inventory] VALUES ('EST-41', 10000)
INSERT INTO [Inventory] VALUES ('EST-42', 10000)
INSERT INTO [Inventory] VALUES ('EST-43', 10000)
INSERT INTO [Inventory] VALUES ('EST-44', 10000)
INSERT INTO [Inventory] VALUES ('EST-45', 10000)
INSERT INTO [Inventory] VALUES ('EST-46', 10000)
INSERT INTO [Inventory] VALUES ('EST-47', 10000)
INSERT INTO [Inventory] VALUES ('EST-48', 10000)
INSERT INTO [Inventory] VALUES ('EST-49', 10000)
INSERT INTO [Inventory] VALUES ('EST-50', 10000)
INSERT INTO [Inventory] VALUES ('EST-51', 10000)
INSERT INTO [Inventory] VALUES ('EST-52', 10000)
INSERT INTO [Inventory] VALUES ('EST-53', 10000)
INSERT INTO [Inventory] VALUES ('EST-54', 10000)
INSERT INTO [Inventory] VALUES ('EST-55', 10000)
INSERT INTO [Inventory] VALUES ('EST-56', 10000)  
INSERT INTO [Inventory] VALUES ('EST-57', 10000)
INSERT INTO [Inventory] VALUES ('EST-58', 10000)
INSERT INTO [Inventory] VALUES ('EST-59', 10000)
INSERT INTO [Inventory] VALUES ('EST-60', 10000)
INSERT INTO [Inventory] VALUES ('EST-61', 10000)
INSERT INTO [Inventory] VALUES ('EST-62', 10000)
INSERT INTO [Inventory] VALUES ('EST-63', 10000)
INSERT INTO [Inventory] VALUES ('EST-64', 10000)
INSERT INTO [Inventory] VALUES ('EST-65', 10000)
INSERT INTO [Inventory] VALUES ('EST-66', 10000)
INSERT INTO [Inventory] VALUES ('EST-67', 10000)
INSERT INTO [Inventory] VALUES ('EST-68', 10000)
INSERT INTO [Inventory] VALUES ('EST-69', 10000)
INSERT INTO [Inventory] VALUES ('EST-70', 10000)
INSERT INTO [Inventory] VALUES ('EST-71', 10000)
INSERT INTO [Inventory] VALUES ('EST-72', 10000)
INSERT INTO [Inventory] VALUES ('EST-73', 10000)
INSERT INTO [Inventory] VALUES ('EST-74', 10000)
INSERT INTO [Inventory] VALUES ('EST-75', 10000)
INSERT INTO [Inventory] VALUES ('EST-76', 10000)
INSERT INTO [Inventory] VALUES ('EST-77', 10000)
INSERT INTO [Inventory] VALUES ('EST-78', 10000)   
INSERT INTO [Inventory] VALUES ('EST-79', 10000)
INSERT INTO [Inventory] VALUES ('EST-80', 10000)
INSERT INTO [Inventory] VALUES ('EST-81', 10000)
INSERT INTO [Inventory] VALUES ('EST-82', 10000)  

