--Script para SQL Server
--Cracion de la base de datos dbAdminTecInfo
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'dbAdminTecInfo')
    DROP DATABASE dbAdminTecInfo;
GO

--Cracion de base de datos
CREATE DATABASE dbAdminTecInfo;
GO

USE dbAdminTecInfo;
GO

-- Creación del esquema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'proyAdmin')
    EXEC('CREATE SCHEMA proyAdmin');
GO

-- 1. Tabla de Usuarios (Encargados, Empleados, etc.)
CREATE TABLE proyAdmin.Usuarios (
    IdUsuario INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100),
    Rol NVARCHAR(50),
    FechaCreacion DATETIME DEFAULT GETDATE()
);
GO

-- 2. Proveedores
CREATE TABLE proyAdmin.Proveedores (
    IdProveedor INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200)
);
GO

-- 3. Clientes	
CREATE TABLE proyAdmin.Clientes (
    IdCliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200)
);
GO

-- 4. Categorías de Productos
CREATE TABLE proyAdmin.Categorias (
    IdCategoria INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200)
);
GO

-- 5. Productos
CREATE TABLE proyAdmin.Productos (
    IdProducto INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200),
    IdCategoria INT,
    Precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT CHK_Precio CHECK (Precio > 0),
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (IdCategoria) 
        REFERENCES proyAdmin.Categorias(IdCategoria) ON DELETE SET NULL ON UPDATE CASCADE
);
GO

-- 6. Bodegas
CREATE TABLE proyAdmin.Bodegas (
    IdBodega INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Ubicacion NVARCHAR(200),
    CapacidadMax INT,
    Encargado INT,
    CONSTRAINT FK_Bodegas_Usuarios FOREIGN KEY (Encargado) 
        REFERENCES proyAdmin.Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE
);
GO

-- 7. Inventario (Stock actual por producto y por bodega)
CREATE TABLE proyAdmin.Inventario (
    IdInventario INT PRIMARY KEY IDENTITY(1,1),
    IdProducto INT,
    IdBodega INT,
    StockActual INT NOT NULL,
    CONSTRAINT CHK_StockActual CHECK (StockActual >= 0),
    CONSTRAINT FK_Inventario_Productos FOREIGN KEY (IdProducto) 
        REFERENCES proyAdmin.Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Inventario_Bodegas FOREIGN KEY (IdBodega) 
        REFERENCES proyAdmin.Bodegas(IdBodega) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_Producto_Bodega UNIQUE (IdProducto, IdBodega)
);
GO

-- 8. Entradas (Ingreso de productos a bodegas)
CREATE TABLE proyAdmin.Entradas (
    IdEntrada INT PRIMARY KEY IDENTITY(1,1),
    FechaEntrada DATETIME DEFAULT GETDATE(),
    IdUsuario INT,
    IdProveedor INT,
    IdBodega INT,
	[Fecha]  AS (CONVERT([date],[FechaEntrada])) PERSISTED,
    CONSTRAINT FK_Entradas_Usuarios FOREIGN KEY (IdUsuario) 
        REFERENCES proyAdmin.Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Entradas_Proveedores FOREIGN KEY (IdProveedor) 
        REFERENCES proyAdmin.Proveedores(IdProveedor) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Entradas_Bodegas FOREIGN KEY (IdBodega) 
        REFERENCES proyAdmin.Bodegas(IdBodega) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 9. Detalle de Entradas
CREATE TABLE proyAdmin.DetalleEntradas (
    IdDetalleEntrada INT PRIMARY KEY IDENTITY(1,1),
    IdEntrada INT,
    IdProducto INT,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT CHK_Cantidad_Entrada CHECK (Cantidad > 0),
    CONSTRAINT CHK_PrecioUnitario CHECK (PrecioUnitario > 0),
    CONSTRAINT FK_DetalleEntradas_Entradas FOREIGN KEY (IdEntrada) 
        REFERENCES proyAdmin.Entradas(IdEntrada) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_DetalleEntradas_Productos FOREIGN KEY (IdProducto) 
        REFERENCES proyAdmin.Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- 10. Salidas (Egreso de productos de bodegas)
CREATE TABLE proyAdmin.Salidas (
    IdSalida INT PRIMARY KEY IDENTITY(1,1),
    FechaSalida DATETIME DEFAULT GETDATE(),
    IdUsuario INT,
    IdBodega INT,
    Destino NVARCHAR(200),
	[Fecha]  AS (CONVERT([date],[FechaSalida])) PERSISTED,
    CONSTRAINT FK_Salidas_Usuarios FOREIGN KEY (IdUsuario) 
        REFERENCES proyAdmin.Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Salidas_Bodegas FOREIGN KEY (IdBodega) 
        REFERENCES proyAdmin.Bodegas(IdBodega) ON DELETE SET NULL ON UPDATE NO ACTION
);
GO

-- 11. Detalle de Salidas
CREATE TABLE proyAdmin.DetalleSalidas (
    IdDetalleSalida INT PRIMARY KEY IDENTITY(1,1),
    IdSalida INT,
    IdProducto INT,
    Cantidad INT NOT NULL,
    CONSTRAINT CHK_Cantidad_Salida CHECK (Cantidad > 0),
    CONSTRAINT FK_DetalleSalidas_Salidas FOREIGN KEY (IdSalida) 
	REFERENCES proyAdmin.Salidas(IdSalida) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_DetalleSalidas_Productos FOREIGN KEY (IdProducto) 
        REFERENCES proyAdmin.Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- TRIGGER PARA AUMENTAR STOCK
CREATE TRIGGER proyAdmin.trg_actualizar_inventario_entrada
ON proyAdmin.DetalleEntradas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdProducto INT, @Cantidad INT, @IdEntrada INT, @IdBodega INT;

    SELECT @IdProducto = i.IdProducto, @Cantidad = i.Cantidad, @IdEntrada = i.IdEntrada
    FROM inserted i;

    SELECT @IdBodega = IdBodega 
    FROM proyAdmin.Entradas 
    WHERE IdEntrada = @IdEntrada;

    IF EXISTS (
        SELECT 1 
        FROM proyAdmin.Inventario 
        WHERE IdProducto = @IdProducto AND IdBodega = @IdBodega
    )
    BEGIN
        UPDATE proyAdmin.Inventario
        SET StockActual = StockActual + @Cantidad
        WHERE IdProducto = @IdProducto AND IdBodega = @IdBodega;
    END
    ELSE
    BEGIN
        INSERT INTO proyAdmin.Inventario (IdProducto, IdBodega, StockActual)
        VALUES (@IdProducto, @IdBodega, @Cantidad);
    END
END;
GO

-- TRIGGER PARA DISMINUIR STOCK
CREATE TRIGGER proyAdmin.trg_actualizar_inventario_salida
ON proyAdmin.DetalleSalidas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdProducto INT, @Cantidad INT, @IdSalida INT, @IdBodega INT, @StockActual INT;

    SELECT @IdProducto = i.IdProducto, @Cantidad = i.Cantidad, @IdSalida = i.IdSalida
    FROM inserted i;

    SELECT @IdBodega = IdBodega 
    FROM proyAdmin.Salidas 
    WHERE IdSalida = @IdSalida;

    SELECT @StockActual = StockActual
    FROM proyAdmin.Inventario 
    WHERE IdProducto = @IdProducto AND IdBodega = @IdBodega;

    IF @StockActual IS NULL OR @StockActual < @Cantidad
    BEGIN
        THROW 50001, 'Error: Stock insuficiente o producto no existe en la bodega', 1;
        RETURN;
    END

    UPDATE proyAdmin.Inventario
    SET StockActual = StockActual - @Cantidad
    WHERE IdProducto = @IdProducto AND IdBodega = @IdBodega;

    INSERT INTO proyAdmin.DetalleSalidas (IdSalida, IdProducto, Cantidad)
    SELECT IdSalida, IdProducto, Cantidad
    FROM inserted;
END;
GO

-- PROCEDIMIENTOS ALMACENADOS CON MANEJO DE ERRORES

-- Insertar producto
CREATE PROCEDURE proyAdmin.sp_insertar_producto
    @p_nombre NVARCHAR(100),
    @p_descripcion NVARCHAR(200),
    @p_id_categoria INT,
    @p_precio DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO proyAdmin.Productos (Nombre, Descripcion, IdCategoria, Precio)
        VALUES (@p_nombre, @p_descripcion, @p_id_categoria, @p_precio);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Insertar entrada con detalle
CREATE PROCEDURE proyAdmin.sp_insertar_entrada
    @p_id_usuario INT,
    @p_id_proveedor INT,
    @p_id_bodega INT,
    @p_id_producto INT,
    @p_cantidad INT,
    @p_precio DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_nueva_entrada INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Usuarios WHERE IdUsuario = @p_id_usuario)
            THROW 50001, 'Usuario no existe', 1;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Proveedores WHERE IdProveedor = @p_id_proveedor)
            THROW 50001, 'Proveedor no existe', 1;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Bodegas WHERE IdBodega = @p_id_bodega)
            THROW 50001, 'Bodega no existe', 1;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Productos WHERE IdProducto = @p_id_producto)
            THROW 50001, 'Producto no existe', 1;
        
        INSERT INTO proyAdmin.Entradas (IdUsuario, IdProveedor, IdBodega)
        VALUES (@p_id_usuario, @p_id_proveedor, @p_id_bodega);
        
        SET @v_nueva_entrada = SCOPE_IDENTITY();

        INSERT INTO proyAdmin.DetalleEntradas (IdEntrada, IdProducto, Cantidad, PrecioUnitario)
        VALUES (@v_nueva_entrada, @p_id_producto, @p_cantidad, @p_precio);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Insertar salida con detalle
CREATE PROCEDURE proyAdmin.sp_insertar_salida
    @p_id_usuario INT,
    @p_id_bodega INT,
    @p_destino NVARCHAR(200),
    @p_id_producto INT,
    @p_cantidad INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @v_nueva_salida INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Usuarios WHERE IdUsuario = @p_id_usuario)
            THROW 50001, 'Usuario no existe', 1;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Bodegas WHERE IdBodega = @p_id_bodega)
            THROW 50001, 'Bodega no existe', 1;
        
        IF NOT EXISTS (SELECT 1 FROM proyAdmin.Productos WHERE IdProducto = @p_id_producto)
            THROW 50001, 'Producto no existe', 1;
        
        INSERT INTO proyAdmin.Salidas (IdUsuario, IdBodega, Destino)
        VALUES (@p_id_usuario, @p_id_bodega, @p_destino);

        SET @v_nueva_salida = SCOPE_IDENTITY();

        INSERT INTO proyAdmin.DetalleSalidas (IdSalida, IdProducto, Cantidad)
        VALUES (@v_nueva_salida, @p_id_producto, @p_cantidad);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

--Dimension de Fechas
CREATE TABLE [proyAdmin].[Fechas](
	[Fecha] [date] NOT NULL,
	[año] [int] NOT NULL,
	[trimestre] [int] NOT NULL,
	[mes] [int] NOT NULL,
	[mes_nombre] [nvarchar](20) NOT NULL,
	[mes_corto] [nvarchar](3) NOT NULL,
	[semana_año] [int] NOT NULL,
	[dia_mes] [int] NOT NULL,
	[dia_año] [int] NOT NULL,
	[dia_semana] [int] NOT NULL,
	[dia_semana_nombre] [nvarchar](20) NOT NULL,
	[dia_semana_corto] [nvarchar](3) NOT NULL,
	[es_fin_de_semana] [bit] NOT NULL,
	[es_dia_festivo] [bit] NOT NULL,
	[numero_semana] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Fecha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Clear the table if it has data
TRUNCATE TABLE proyAdmin.Fechas;
GO

-- Set language to Spanish for month and day names
SET LANGUAGE Spanish;
GO

-- Generate date range using a recursive CTE
WITH DateRange AS (
    SELECT CAST('2024-01-01' AS DATE) AS Fecha
    UNION ALL
    SELECT DATEADD(DAY, 1, Fecha)
    FROM DateRange
    WHERE Fecha < '2025-12-31'
),
-- Define holidays
Holidays AS (
    SELECT CAST(HolidayDate AS DATE) AS HolidayDate
    FROM (VALUES 
        ('2024-01-01'), ('2024-03-27'), ('2024-03-28'), ('2024-03-29'),
        ('2024-05-01'), ('2024-06-30'), ('2024-08-15'), ('2024-09-15'),
        ('2024-10-20'), ('2024-11-01'), ('2024-12-24'), ('2024-12-25'),
        ('2024-12-31'), ('2025-01-01'), ('2025-04-16'), ('2025-04-17'),
        ('2025-04-18'), ('2025-05-01'), ('2025-06-30'), ('2025-08-15'),
        ('2025-09-15'), ('2025-10-20'), ('2025-11-01'), ('2025-12-24'),
        ('2025-12-25')
    ) AS H(HolidayDate)
),
-- Compute date attributes
DateAttributes AS (
    SELECT 
        Fecha,
        YEAR(Fecha) AS año,
        DATEPART(QUARTER, Fecha) AS trimestre,
        MONTH(Fecha) AS mes,
        DATENAME(MONTH, Fecha) AS mes_nombre,
        LEFT(DATENAME(MONTH, Fecha), 3) AS mes_corto,
        DATEPART(ISO_WEEK, Fecha) AS semana_año,
        DAY(Fecha) AS dia_mes,
        DATEPART(DAYOFYEAR, Fecha) AS dia_año,
        -- Day of week: Monday = 1, Sunday = 7
        (DATEPART(WEEKDAY, Fecha) + 5) % 7 + 1 AS dia_semana,
        DATENAME(WEEKDAY, Fecha) AS dia_semana_nombre,
        LEFT(DATENAME(WEEKDAY, Fecha), 3) AS dia_semana_corto,
        CASE WHEN (DATEPART(WEEKDAY, Fecha) + 5) % 7 + 1 >= 6 THEN 1 ELSE 0 END AS es_fin_de_semana,
        CASE WHEN EXISTS (SELECT 1 FROM Holidays WHERE HolidayDate = Fecha) THEN 1 ELSE 0 END AS es_dia_festivo,
        DATEPART(ISO_WEEK, Fecha) AS numero_semana
    FROM DateRange
)
-- Insert into Fechas table
INSERT INTO proyAdmin.Fechas (
    Fecha, año, trimestre, mes, mes_nombre, mes_corto, semana_año, 
    dia_mes, dia_año, dia_semana, dia_semana_nombre, dia_semana_corto, 
    es_fin_de_semana, es_dia_festivo, numero_semana
)
SELECT 
    Fecha,
    año,
    trimestre,
    mes,
    mes_nombre,
    mes_corto,
    semana_año,
    dia_mes,
    dia_año,
    dia_semana,
    dia_semana_nombre,
    dia_semana_corto,
    es_fin_de_semana,
    es_dia_festivo,
    numero_semana
FROM DateAttributes
OPTION (MAXRECURSION 0);
GO

-- Reset language to default (optional, depending on your environment)
SET LANGUAGE us_english;
GO


--Vista fact table
-- Drop the view if it already exists
IF OBJECT_ID('proyAdmin.Movimientos', 'V') IS NOT NULL
    DROP VIEW proyAdmin.Movimientos;
GO

-- Create the Movimientos view
CREATE VIEW proyAdmin.Movimientos AS
SELECT 
    e.IdEntrada AS IdMovimiento,
    'Entrada' AS TipoMovimiento,
    e.FechaEntrada,
    e.Fecha,
    e.IdBodega,
    e.IdUsuario,
    de.IdProducto,
    de.Cantidad,
    de.PrecioUnitario,
	de.Cantidad * de.PrecioUnitario as PrecioTotal
FROM proyAdmin.Entradas e
JOIN proyAdmin.DetalleEntradas de ON e.IdEntrada = de.IdEntrada
UNION ALL
SELECT 
    s.IdSalida AS IdMovimiento,
    'Salida' AS TipoMovimiento,
    s.FechaSalida AS FechaEntrada,
    s.Fecha,
    s.IdBodega,
    s.IdUsuario,
    ds.IdProducto,
    ds.Cantidad,
    pr.Precio,
	ds.Cantidad * pr.Precio
FROM proyAdmin.Salidas s
JOIN proyAdmin.DetalleSalidas ds ON s.IdSalida = ds.IdSalida
JOIN proyadmin.Productos pr on ds.IdProducto = pr.IdProducto
GO
