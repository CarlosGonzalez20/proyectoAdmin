-- Tabla de Clientes
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    CustomerGroupID INT
);

-- Tabla de Grupos de Clientes
CREATE TABLE CustomerGroup (
    CustomerGroupID INT PRIMARY KEY,
    GroupName NVARCHAR(100),
    Description NVARCHAR(255)
);

-- Tabla de Empleados
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Position NVARCHAR(100)
);

-- Tabla de Categorías de Ítems
CREATE TABLE ItemCategory (
    ItemCategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(255)
);

-- Tabla de Ítems
CREATE TABLE Items (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    SKU NVARCHAR(50),
    ItemCategoryID INT,
    UnitPrice DECIMAL(18,2),
    FOREIGN KEY (ItemCategoryID) REFERENCES ItemCategory(ItemCategoryID)
);

-- Tabla de Bodegas
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName NVARCHAR(100),
    Location NVARCHAR(200)
);

-- Encabezado de Orden de Venta
CREATE TABLE SalesOrderHeader (
    SalesOrderID INT PRIMARY KEY,
    OrderDate DATETIME,
    CustomerID INT,
    WarehouseID INT,
    PickingStart DATETIME,
    PickingEnd DATETIME,
    PackingStart DATETIME,
    PackingEnd DATETIME,
    EmployPicking INT,
    EmployPacking INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (EmployPicking) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (EmployPacking) REFERENCES Employees(EmployeeID)
);

-- Detalle de Orden de Venta
CREATE TABLE SalesOrderDetail (
    SalesOrderDetailID INT PRIMARY KEY,
    SalesOrderID INT,
    ItemID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    FOREIGN KEY (SalesOrderID) REFERENCES SalesOrderHeader(SalesOrderID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);
