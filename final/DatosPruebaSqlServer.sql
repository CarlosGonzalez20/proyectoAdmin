USE dbAdminTecInfo;
GO

-- Disable triggers to prevent automatic stock updates during initial population
ALTER TABLE proyAdmin.DetalleEntradas DISABLE TRIGGER trg_actualizar_inventario_entrada;
ALTER TABLE proyAdmin.DetalleSalidas DISABLE TRIGGER trg_actualizar_inventario_salida;
GO

-- 1. Insert Usuarios (10 users: managers, warehouse staff)
INSERT INTO proyAdmin.Usuarios (Nombre, Correo, Rol, FechaCreacion)
VALUES 
    ('Juan Perez', 'juan.perez@tecinf.com', 'Manager', '2024-03-01'),
    ('Maria Gomez', 'maria.gomez@tecinf.com', 'Warehouse Staff', '2024-03-01'),
    ('Carlos Lopez', 'carlos.lopez@tecinf.com', 'Warehouse Staff', '2024-03-01'),
    ('Ana Martinez', 'ana.martinez@tecinf.com', 'Supervisor', '2024-03-01'),
    ('Luis Rodriguez', 'luis.rodriguez@tecinf.com', 'Warehouse Staff', '2024-03-01'),
    ('Sofia Hernandez', 'sofia.hernandez@tecinf.com', 'Manager', '2024-03-01'),
    ('Diego Torres', 'diego.torres@tecinf.com', 'Warehouse Staff', '2024-03-01'),
    ('Laura Diaz', 'laura.diaz@tecinf.com', 'Supervisor', '2024-03-01'),
    ('Pedro Sanchez', 'pedro.sanchez@tecinf.com', 'Warehouse Staff', '2024-03-01'),
    ('Clara Ruiz', 'clara.ruiz@tecinf.com', 'Manager', '2024-03-01');
GO

-- 2. Insert Proveedores (5 suppliers)
INSERT INTO proyAdmin.Proveedores (Nombre, Telefono, Email, Direccion)
VALUES 
    ('TechSupply SA', '555-0101', 'contact@techsupply.com', '123 Industrial Ave, City'),
    ('ElectroDist', '555-0102', 'sales@electrodist.com', '456 Tech Park, City'),
    ('GlobalParts', '555-0103', 'info@globalparts.com', '789 Commerce St, City'),
    ('InfoTech', '555-0104', 'support@infotech.com', '101 Supply Rd, City'),
    ('CompuTrend', '555-0105', 'orders@computrend.com', '202 Circuit Dr, City');
GO

 --   Insert Clientes (5 suppliers)
INSERT INTO proyAdmin.Clientes (Nombre, Telefono, Email, Direccion)
VALUES 
    ('Coca-Cola Distribuciones', '555-1001', 'ventas@cocacola.com', 'Avenida Central 123, Ciudad'),
    ('Distribuidora La Moderna', '555-1002', 'contacto@lamoderna.com', 'Calle 45, Zona Industrial'),
    ('Ferretería El Tornillo', '555-1003', 'eltornillo@correo.com', 'Boulevard Norte 500, Ciudad'),
    ('Grupo Logístico Norte', '555-1004', 'info@lognorte.com', 'Ruta Nacional 7, Km 15'),
    ('Supermercado Central', '555-1005', 'compras@supercentral.com', 'Av. Las Américas 1200');
GO

-- 3. Insert Categorias (5 categories)
INSERT INTO proyAdmin.Categorias (Nombre, Descripcion)
VALUES 
    ('Electronics', 'Electronic components and devices'),
    ('Tools', 'Hand and power tools'),
    ('Accessories', 'Peripheral accessories'),
    ('Cables', 'Wiring and connectivity cables'),
    ('Storage', 'Storage devices and media');
GO

-- 4. Insert Productos (20 products across categories)
INSERT INTO proyAdmin.Productos (Nombre, Descripcion, IdCategoria, Precio)
VALUES 
    ('Microchip X1', 'High-performance microcontroller', 1, 15.50),
    ('Resistor Pack', 'Assorted resistors', 1, 5.00),
    ('LED Array', 'Multi-color LED set', 1, 8.75),
    ('Circuit Board', 'Prototyping PCB', 1, 12.00),
    ('Screwdriver Set', 'Precision screwdrivers', 2, 20.00),
    ('Power Drill', 'Cordless power drill', 2, 65.00),
    ('Wrench Kit', 'Adjustable wrench set', 2, 30.00),
    ('Hammer', 'Standard claw hammer', 2, 15.00),
    ('USB Hub', '4-port USB 3.0 hub', 3, 25.00),
    ('Mouse Pad', 'Ergonomic mouse pad', 3, 7.50),
    ('Keyboard Cover', 'Silicone keyboard protector', 3, 10.00),
    ('Webcam', 'HD webcam with mic', 3, 45.00),
    ('HDMI Cable', '2m HDMI 2.0 cable', 4, 12.00),
    ('Ethernet Cable', '5m Cat6 Ethernet cable', 4, 8.00),
    ('USB-C Cable', '1m USB-C charging cable', 4, 10.00),
    ('Power Strip', '6-outlet power strip', 4, 20.00),
    ('SSD 1TB', '1TB solid-state drive', 5, 90.00),
    ('USB Drive 64GB', '64GB USB 3.0 flash drive', 5, 15.00),
    ('SD Card 128GB', '128GB microSD card', 5, 25.00),
    ('External HDD', '2TB external hard drive', 5, 80.00);
GO

-- 5. Insert Bodegas (3 warehouses)
INSERT INTO proyAdmin.Bodegas (Nombre, Ubicacion, CapacidadMax, Encargado)
VALUES 
    ('Central Warehouse', '100 Main St, City', 10000, 1), -- Managed by Juan Perez
    ('North Warehouse', '200 North Rd, City', 5000, 6), -- Managed by Sofia Hernandez
    ('South Warehouse', '300 South Ave, City', 7000, 10); -- Managed by Clara Ruiz
GO

-- 6. Insert Entradas (50 product entries from April 2024 to April 2025)
INSERT INTO proyAdmin.Entradas (FechaEntrada, IdUsuario, IdProveedor, IdBodega)
VALUES 
    ('2024-04-05 08:00:00', 2, 1, 1), ('2024-04-10 09:00:00', 3, 2, 2), ('2024-04-15 10:00:00', 5, 3, 3),
    ('2024-05-02 08:30:00', 7, 4, 1), ('2024-05-12 09:30:00', 9, 5, 2), ('2024-05-20 10:30:00', 2, 1, 3),
    ('2024-06-03 08:00:00', 3, 2, 1), ('2024-06-15 09:00:00', 5, 3, 2), ('2024-06-25 10:00:00', 7, 4, 3),
    ('2024-07-01 08:30:00', 9, 5, 1), ('2024-07-10 09:30:00', 2, 1, 2), ('2024-07-20 10:30:00', 3, 2, 3),
    ('2024-08-05 08:00:00', 5, 3, 1), ('2024-08-15 09:00:00', 7, 4, 2), ('2024-08-25 10:00:00', 9, 5, 3),
    ('2024-09-02 08:30:00', 2, 1, 1), ('2024-09-12 09:30:00', 3, 2, 2), ('2024-09-22 10:30:00', 5, 3, 3),
    ('2024-10-01 08:00:00', 7, 4, 1), ('2024-10-10 09:00:00', 9, 5, 2), ('2024-10-20 10:00:00', 2, 1, 3),
    ('2024-11-03 08:30:00', 3, 2, 1), ('2024-11-15 09:30:00', 5, 3, 2), ('2024-11-25 10:30:00', 7, 4, 3),
    ('2024-12-02 08:00:00', 9, 5, 1), ('2024-12-12 09:00:00', 2, 1, 2), ('2024-12-22 10:00:00', 3, 2, 3),
    ('2025-01-05 08:30:00', 5, 3, 1), ('2025-01-15 09:30:00', 7, 4, 2), ('2025-01-25 10:30:00', 9, 5, 3),
    ('2025-02-03 08:00:00', 2, 1, 1), ('2025-02-12 09:00:00', 3, 2, 2), ('2025-02-22 10:00:00', 5, 3, 3),
    ('2025-03-02 08:30:00', 7, 4, 1), ('2025-03-12 09:30:00', 9, 5, 2), ('2025-03-22 10:30:00', 2, 1, 3),
    ('2025-04-01 08:00:00', 3, 2, 1), ('2025-04-05 09:00:00', 5, 3, 2), ('2025-04-10 10:00:00', 7, 4, 3),
    ('2024-04-20 08:30:00', 9, 5, 1), ('2024-05-25 09:30:00', 2, 1, 2), ('2024-06-30 10:30:00', 3, 2, 3),
    ('2024-07-25 08:00:00', 5, 3, 1), ('2024-08-30 09:00:00', 7, 4, 2), ('2024-09-30 10:00:00', 9, 5, 3),
    ('2024-10-25 08:30:00', 2, 1, 1), ('2024-11-30 09:30:00', 3, 2, 2), ('2024-12-30 10:30:00', 5, 3, 3),
    ('2025-01-30 08:00:00', 7, 4, 1), ('2025-02-28 09:00:00', 9, 5, 2);
GO

-- 7. Insert DetalleEntradas (details for the 50 entries)
INSERT INTO proyAdmin.DetalleEntradas (IdEntrada, IdProducto, Cantidad, PrecioUnitario)
VALUES 
    (1, 1, 100, 15.00), (1, 2, 200, 4.80), (2, 3, 150, 8.50), (2, 4, 80, 11.50),
    (3, 5, 50, 19.00), (3, 6, 30, 60.00), (4, 7, 60, 28.00), (4, 8, 70, 14.00),
    (5, 9, 40, 24.00), (5, 10, 100, 7.00), (6, 11, 90, 9.50), (6, 12, 20, 42.00),
    (7, 13, 120, 11.00), (7, 14, 150, 7.50), (8, 15, 130, 9.00), (8, 16, 60, 18.00),
    (9, 17, 25, 85.00), (9, 18, 80, 14.00), (10, 19, 70, 23.00), (10, 20, 30, 75.00),
    (11, 1, 110, 15.20), (12, 2, 180, 4.90), (13, 3, 140, 8.60), (14, 4, 90, 11.70),
    (15, 5, 55, 19.50), (16, 6, 35, 61.00), (17, 7, 65, 28.50), (18, 8, 75, 14.20),
    (19, 9, 45, 24.50), (20, 10, 110, 7.20), (21, 11, 95, 9.70), (22, 12, 25, 43.00),
    (23, 13, 125, 11.20), (24, 14, 160, 7.60), (25, 15, 135, 9.20), (26, 16, 65, 18.50),
    (27, 17, 30, 86.00), (28, 18, 85, 14.20), (29, 19, 75, 23.50), (30, 20, 35, 76.00),
    (31, 1, 120, 15.30), (32, 2, 190, 5.00), (33, 3, 145, 8.70), (34, 4, 95, 11.80),
    (35, 5, 60, 19.70), (36, 6, 40, 62.00), (37, 7, 70, 29.00), (38, 8, 80, 14.30),
    (39, 9, 50, 25.00), (40, 10, 120, 7.30), (41, 11, 100, 9.80), (42, 12, 30, 44.00),
    (43, 13, 130, 11.30), (44, 14, 170, 7.70), (45, 15, 140, 9.30), (46, 16, 70, 19.00),
    (47, 17, 35, 87.00), (48, 18, 90, 14.30), (49, 19, 80, 24.00), (50, 20, 40, 77.00);
GO

-- 8. Insert Salidas (40 product exits from April 2024 to April 2025)
INSERT INTO proyAdmin.Salidas (FechaSalida, IdUsuario, IdBodega, Destino, IdCliente)
VALUES 
    ('2024-04-08 08:00:00', 2, 1, 'Client A', 1), ('2024-04-12 09:00:00', 3, 2, 'Store B', 1),
    ('2024-04-18 10:00:00', 5, 3, 'Distribution C', 2), ('2024-05-05 08:30:00', 7, 1, 'Client D', 1),
    ('2024-05-15 09:30:00', 9, 2, 'Store E', 3), ('2024-05-25 10:30:00', 2, 3, 'Client F', 1),
    ('2024-06-05 08:00:00', 3, 1, 'Store G', 4), ('2024-06-18 09:00:00', 5, 2, 'Client H', 2),
    ('2024-06-28 10:00:00', 7, 3, 'Distribution I', 1), ('2024-07-05 08:30:00', 9, 1, 'Client J', 2),
    ('2024-07-15 09:30:00', 2, 2, 'Store K', 2), ('2024-07-25 10:30:00', 3, 3, 'Client L', 3),
    ('2024-08-08 08:00:00', 5, 1, 'Store M', 3), ('2024-08-18 09:00:00', 7, 2, 'Client N', 4),
    ('2024-08-28 10:00:00', 9, 3, 'Distribution O', 4), ('2024-09-05 08:30:00', 2, 1, 'Client P', 4),
    ('2024-09-15 09:30:00', 3, 2, 'Store Q', 5), ('2024-09-25 10:30:00', 5, 3, 'Client R', 4),
    ('2024-10-05 08:00:00', 7, 1, 'Store S', 1), ('2024-10-15 09:00:00', 9, 2, 'Client T', 4),
    ('2024-11-05 08:30:00', 2, 3, 'Distribution U', 2), ('2024-11-18 09:30:00', 3, 1, 'Client V', 5),
    ('2024-11-28 10:30:00', 5, 2, 'Store W', 3), ('2024-12-05 08:00:00', 7, 3, 'Client X', 5),
    ('2024-12-15 09:00:00', 9, 1, 'Distribution Y', 4), ('2025-01-08 08:30:00', 2, 2, 'Client Z', 5),
    ('2025-01-18 09:30:00', 3, 3, 'Store AA', 5), ('2025-01-28 10:30:00', 5, 1, 'Client BB', 1),
    ('2025-02-05 08:00:00', 7, 2, 'Distribution CC', 1), ('2025-02-15 09:00:00', 9, 3, 'Client DD', 1),
    ('2025-02-25 10:00:00', 2, 1, 'Store EE', 2), ('2025-03-05 08:30:00', 3, 2, 'Client FF', 2),
    ('2025-03-15 09:30:00', 5, 3, 'Distribution GG', 3), ('2025-03-25 10:30:00', 7, 1, 'Client HH', 3),
    ('2025-04-03 08:00:00', 9, 2, 'Store II', 4), ('2025-04-08 09:00:00', 2, 3, 'Client JJ', 4),
    ('2024-04-25 08:30:00', 3, 1, 'Distribution KK', 5), ('2024-05-30 09:30:00', 5, 2, 'Client LL', 5),
    ('2024-06-30 10:30:00', 7, 3, 'Store MM', 1), ('2024-07-30 08:00:00', 9, 1, 'Client NN', 2);
GO

-- 9. Insert DetalleSalidas (details for the 40 exits)
INSERT INTO proyAdmin.DetalleSalidas (IdSalida, IdProducto, Cantidad)
VALUES 
    (1, 1, 50), (1, 2, 100), (2, 3, 80), (2, 4, 40),
    (3, 5, 25), (3, 6, 15), (4, 7, 30), (4, 8, 35),
    (5, 9, 20), (5, 10, 50), (6, 11, 45), (6, 12, 10),
    (7, 13, 60), (7, 14, 75), (8, 15, 65), (8, 16, 30),
    (9, 17, 10), (9, 18, 40), (10, 19, 35), (10, 20, 15),
    (11, 1, 55), (12, 2, 90), (13, 3, 70), (14, 4, 45),
    (15, 5, 30), (16, 6, 20), (17, 7, 35), (18, 8, 40),
    (19, 9, 25), (20, 10, 55), (21, 11, 50), (22, 12, 15),
    (23, 13, 65), (24, 14, 80), (25, 15, 70), (26, 16, 35),
    (27, 17, 15), (28, 18, 45), (29, 19, 40), (30, 20, 20),
    (31, 1, 60), (32, 2, 95), (33, 3, 75), (34, 4, 50),
    (35, 5, 35), (36, 6, 25), (37, 7, 40), (38, 8, 45),
    (39, 9, 30), (40, 10, 60);
GO

-- 10. Insert Inventario (initial stock after entries and exits)
-- Calculated as: Total entries per product per warehouse - Total exits per product per warehouse
INSERT INTO proyAdmin.Inventario (IdProducto, IdBodega, StockActual)
VALUES 
    (1, 1, 110), (1, 2, 0), (1, 3, 0), -- Microchip X1: 230 entered, 120 exited in Bodega 1
    (2, 1, 195), (2, 2, 0), (2, 3, 0), -- Resistor Pack: 470 entered, 275 exited in Bodega 1
    (3, 2, 155), (3, 1, 0), (3, 3, 0), -- LED Array: 305 entered, 150 exited in Bodega 2
    (4, 2, 90), (4, 1, 0), (4, 3, 0), -- Circuit Board: 225 entered, 135 exited in Bodega 2
    (5, 3, 65), (5, 1, 0), (5, 2, 0), -- Screwdriver Set: 140 entered, 75 exited in Bodega 3
    (6, 3, 50), (6, 1, 0), (6, 2, 0), -- Power Drill: 90 entered, 40 exited in Bodega 3
    (7, 1, 95), (7, 2, 0), (7, 3, 0), -- Wrench Kit: 195 entered, 100 exited in Bodega 1
    (8, 1, 110), (8, 2, 0), (8, 3, 0), -- Hammer: 230 entered, 120 exited in Bodega 1
    (9, 2, 65), (9, 1, 0), (9, 3, 0), -- USB Hub: 115 entered, 50 exited in Bodega 2
    (10, 2, 175), (10, 1, 0), (10, 3, 0), -- Mouse Pad: 340 entered, 165 exited in Bodega 2
    (11, 3, 135), (11, 1, 0), (11, 2, 0), -- Keyboard Cover: 235 entered, 100 exited in Bodega 3
    (12, 3, 30), (12, 1, 0), (12, 2, 0), -- Webcam: 75 entered, 45 exited in Bodega 3
    (13, 1, 195), (13, 2, 0), (13, 3, 0), -- HDMI Cable: 315 entered, 120 exited in Bodega 1
    (14, 1, 325), (14, 2, 0), (14, 3, 0), -- Ethernet Cable: 480 entered, 155 exited in Bodega 1
    (15, 2, 275), (15, 1, 0), (15, 3, 0), -- USB-C Cable: 405 entered, 130 exited in Bodega 2
    (16, 2, 130), (16, 1, 0), (16, 3, 0), -- Power Strip: 230 entered, 100 exited in Bodega 2
    (17, 3, 60), (17, 1, 0), (17, 2, 0), -- SSD 1TB: 90 entered, 30 exited in Bodega 3
    (18, 3, 160), (18, 1, 0), (18, 2, 0), -- USB Drive 64GB: 250 entered, 90 exited in Bodega 3
    (19, 1, 155), (19, 2, 0), (19, 3, 0), -- SD Card 128GB: 235 entered, 80 exited in Bodega 1
    (20, 1, 90), (20, 2, 0), (20, 3, 0); -- External HDD: 140 entered, 50 exited in Bodega 1
GO

-- Re-enable triggers after population
ALTER TABLE proyAdmin.DetalleEntradas ENABLE TRIGGER trg_actualizar_inventario_entrada;
ALTER TABLE proyAdmin.DetalleSalidas ENABLE TRIGGER trg_actualizar_inventario_salida;
GO





--Ajuste inventario para evitar stock negativo
update proyAdmin.DetalleEntradas set cantidad = cantidad + 150
where IdProducto in (
1
,3
,5
,6
,7
,8
,9
,10
,11
,12
,14
,15
,16
,17
,18
,19
)