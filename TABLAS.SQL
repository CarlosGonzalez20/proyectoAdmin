-- 1. Usuarios
    CREATE TABLE Usuarios (
    IdUsuario INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100),
    Rol NVARCHAR(50),
    FechaCreacion DATETIME DEFAULT GETDATE()
);

-- 2. Proveedores
    CREATE TABLE Proveedores (
    IdProveedor INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200)
);

-- 3. Categorías
    CREATE TABLE Categorias (
    IdCategoria INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200)
);

-- 4. Productos
    CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200),
    IdCategoria INT,
    Precio DECIMAL(10,2),
    FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria)
);

-- 5. Entradas (registro de compras o ingresos a bodega)
    CREATE TABLE Entradas (
    IdEntrada INT PRIMARY KEY IDENTITY,
    FechaEntrada DATETIME DEFAULT GETDATE(),
    IdUsuario INT,
    IdProveedor INT,
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario),
    FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor)
);

-- 6. Detalles de Entrada
    CREATE TABLE DetalleEntradas (
    IdDetalleEntrada INT PRIMARY KEY IDENTITY,
    IdEntrada INT,
    IdProducto INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(10,2),
    FOREIGN KEY (IdEntrada) REFERENCES Entradas(IdEntrada),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

-- 7. Salidas (registro de productos que salen de la bodega)
    CREATE TABLE Salidas (
    IdSalida INT PRIMARY KEY IDENTITY,
    FechaSalida DATETIME DEFAULT GETDATE(),
    IdUsuario INT,
    Destino NVARCHAR(100),
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario)
);

-- 8. Detalles de Salida
    CREATE TABLE DetalleSalidas (
    IdDetalleSalida INT PRIMARY KEY IDENTITY,
    IdSalida INT,
    IdProducto INT,
    Cantidad INT,
    FOREIGN KEY (IdSalida) REFERENCES Salidas(IdSalida),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

-- 9. Inventario (stock actual por producto)
    CREATE TABLE Inventario (
    IdInventario INT PRIMARY KEY IDENTITY,
    IdProducto INT,
    StockActual INT,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);
