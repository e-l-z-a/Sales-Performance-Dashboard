CREATE DATABASE TrendMartDW;
GO

USE TrendMartDW;
GO

------------------------------------------------------------
CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    Segment VARCHAR(50), -- Consumer / Corporate / Small Business
    City VARCHAR(100),
    State VARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(150),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    UnitCost DECIMAL(10,2),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimRegion (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100), -- East, West, Central, South
    State VARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY, -- Format: 20260115
    FullDate DATE,
    Day INT,
    Month INT,
    MonthName VARCHAR(20),
    Quarter INT,
    Year INT
);
ALTER TABLE DimDate
ADD DayName VARCHAR(20),
    WeekNumber INT,
    IsWeekend BIT;

CREATE TABLE FactSales (
    SalesID INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber VARCHAR(50),
    DateKey INT,
    CustomerID INT,
    ProductID INT,
    RegionID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalRevenue DECIMAL(12,2),
    TotalCost DECIMAL(12,2),
    Profit DECIMAL(12,2),

    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (RegionID) REFERENCES DimRegion(RegionID)
);

CREATE TABLE ETL_Error_Log (
    ErrorID INT IDENTITY(1,1),
    TableName VARCHAR(50),
    ErrorDescription VARCHAR(255),
    RecordData VARCHAR(MAX),
    LoadDate DATETIME DEFAULT GETDATE()
);

------------------------------------------------------------------------------------------------
CREATE INDEX IX_FactSales_DateKey ON FactSales(DateKey);
CREATE INDEX IX_FactSales_ProductID ON FactSales(ProductID);
CREATE INDEX IX_FactSales_RegionID ON FactSales(RegionID);
