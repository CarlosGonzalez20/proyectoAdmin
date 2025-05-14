-- Creación del esquema
CREATE SCHEMA IF NOT EXISTS proyAdmin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE proyAdmin;

-- 1. Tabla de Usuarios (Encargados, Empleados, etc.)
CREATE TABLE Usuarios (
    IdUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100),
    Rol VARCHAR(50),
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Proveedores
CREATE TABLE Proveedores (
    IdProveedor INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100),
    Direccion VARCHAR(200)
) ENGINE=InnoDB;

-- 3. Categorías de Productos
CREATE TABLE Categorias (
    IdCategoria INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(200)
) ENGINE=InnoDB;

-- 4. Productos
CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(200),
    IdCategoria INT,
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio > 0),
    FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Bodegas
CREATE TABLE Bodegas (
    IdBodega INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(100),
    Ubicacion VARCHAR(200),
    CapacidadMax INT,
    Encargado INT,
    FOREIGN KEY (Encargado) REFERENCES Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Inventario (Stock actual por producto y por bodega)
CREATE TABLE Inventario (
    IdInventario INT PRIMARY KEY AUTO_INCREMENT,
    IdProducto INT,
    IdBodega INT,
    StockActual INT NOT NULL CHECK (StockActual >= 0),
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IdBodega) REFERENCES Bodegas(IdBodega) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY (IdProducto, IdBodega) -- Evita duplicados de producto-bodega
) ENGINE=InnoDB;

-- 7. Entradas (Ingreso de productos a bodegas)
CREATE TABLE Entradas (
    IdEntrada INT PRIMARY KEY AUTO_INCREMENT,
    FechaEntrada DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuario INT,
    IdProveedor INT,
    IdBodega INT,
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IdProveedor) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (IdBodega) REFERENCES Bodegas(IdBodega) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Detalle de Entradas
CREATE TABLE DetalleEntradas (
    IdDetalleEntrada INT PRIMARY KEY AUTO_INCREMENT,
    IdEntrada INT,
    IdProducto INT,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario > 0),
    FOREIGN KEY (IdEntrada) REFERENCES Entradas(IdEntrada) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Salidas (Egreso de productos de bodegas)
CREATE TABLE Salidas (
    IdSalida INT PRIMARY KEY AUTO_INCREMENT,
    FechaSalida DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuario INT,
    IdBodega INT,
    Destino VARCHAR(200),
    FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (IdBodega) REFERENCES Bodegas(IdBodega) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. Detalle de Salidas
CREATE TABLE DetalleSalidas (
    IdDetalleSalida INT PRIMARY KEY AUTO_INCREMENT,
    IdSalida INT,
    IdProducto INT,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    FOREIGN KEY (IdSalida) REFERENCES Salidas(IdSalida) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- TRIGGER PARA AUMENTAR STOCK
DELIMITER //
CREATE TRIGGER trg_actualizar_inventario_entrada
AFTER INSERT ON DetalleEntradas
FOR EACH ROW
BEGIN
    DECLARE bodega_id INT;
    
    -- Obtener la bodega de la entrada
    SELECT IdBodega INTO bodega_id FROM Entradas WHERE IdEntrada = NEW.IdEntrada;
    
    -- Verificar si ya existe registro en inventario
    IF EXISTS (SELECT 1 FROM Inventario WHERE IdProducto = NEW.IdProducto AND IdBodega = bodega_id) THEN
        UPDATE Inventario
        SET StockActual = StockActual + NEW.Cantidad
        WHERE IdProducto = NEW.IdProducto AND IdBodega = bodega_id;
    ELSE
        INSERT INTO Inventario (IdProducto, IdBodega, StockActual)
        VALUES (NEW.IdProducto, bodega_id, NEW.Cantidad);
    END IF;
END//
DELIMITER ;

-- TRIGGER PARA DISMINUIR STOCK
DELIMITER //
CREATE TRIGGER trg_actualizar_inventario_salida
BEFORE INSERT ON DetalleSalidas
FOR EACH ROW
BEGIN
    DECLARE bodega_id INT;
    DECLARE stock_actual INT;
    
    -- Obtener la bodega de la salida
    SELECT IdBodega INTO bodega_id FROM Salidas WHERE IdSalida = NEW.IdSalida;
    
    -- Obtener stock actual
    SELECT StockActual INTO stock_actual 
    FROM Inventario 
    WHERE IdProducto = NEW.IdProducto AND IdBodega = bodega_id;
    
    -- Validar stock suficiente
    IF stock_actual IS NULL OR stock_actual < NEW.Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stock insuficiente o producto no existe en la bodega';
    END IF;
    
    -- Actualizar inventario
    UPDATE Inventario
    SET StockActual = StockActual - NEW.Cantidad
    WHERE IdProducto = NEW.IdProducto AND IdBodega = bodega_id;
END//
DELIMITER ;

-- PROCEDIMIENTOS ALMACENADOS CON MANEJO DE ERRORES
DELIMITER //

-- Insertar producto
CREATE PROCEDURE sp_insertar_producto(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(200),
    IN p_id_categoria INT,
    IN p_precio DECIMAL(10,2)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO Productos(Nombre, Descripcion, IdCategoria, Precio)
    VALUES(p_nombre, p_descripcion, p_id_categoria, p_precio);
    
    COMMIT;
END//

-- Insertar entrada con detalle
CREATE PROCEDURE sp_insertar_entrada(
    IN p_id_usuario INT,
    IN p_id_proveedor INT,
    IN p_id_bodega INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_precio DECIMAL(10,2)
)
BEGIN
    DECLARE v_nueva_entrada INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Validar que existan las referencias
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE IdUsuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Proveedores WHERE IdProveedor = p_id_proveedor) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Proveedor no existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Bodegas WHERE IdBodega = p_id_bodega) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bodega no existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE IdProducto = p_id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;
    
    -- Insertar entrada
    INSERT INTO Entradas(IdUsuario, IdProveedor, IdBodega) 
    VALUES(p_id_usuario, p_id_proveedor, p_id_bodega);
    
    SET v_nueva_entrada = LAST_INSERT_ID();

    -- Insertar detalle
    INSERT INTO DetalleEntradas(IdEntrada, IdProducto, Cantidad, PrecioUnitario) 
    VALUES(v_nueva_entrada, p_id_producto, p_cantidad, p_precio);
    
    COMMIT;
END//

-- Insertar salida con detalle
CREATE PROCEDURE sp_insertar_salida(
    IN p_id_usuario INT,
    IN p_id_bodega INT,
    IN p_destino VARCHAR(200),
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_nueva_salida INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Validar que existan las referencias
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE IdUsuario = p_id_usuario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Bodegas WHERE IdBodega = p_id_bodega) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bodega no existe';
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE IdProducto = p_id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Producto no existe';
    END IF;
    
    -- Insertar salida
    INSERT INTO Salidas(IdUsuario, IdBodega, Destino)
    VALUES(p_id_usuario, p_id_bodega, p_destino);

    SET v_nueva_salida = LAST_INSERT_ID();

    -- Insertar detalle (el trigger validará el stock)
    INSERT INTO DetalleSalidas(IdSalida, IdProducto, Cantidad)
    VALUES(v_nueva_salida, p_id_producto, p_cantidad);
    
    COMMIT;
END//

DELIMITER ;