USE proyAdmin;

-- Usuarios con fechas de creación específicas
INSERT INTO Usuarios (Nombre, Correo, Rol, FechaCreacion) VALUES
('Juan Pérez', 'juan.perez@empresa.com', 'Administrador', '2023-03-15 08:30:00'),
('María González', 'maria.gonzalez@empresa.com', 'Encargado de Bodega', '2023-04-02 09:15:00'),
('Carlos López', 'carlos.lopez@empresa.com', 'Encargado de Bodega', '2023-05-10 10:00:00'),
('Ana Martínez', 'ana.martinez@empresa.com', 'Empleado', '2023-06-22 14:20:00'),
('Pedro Sánchez', 'pedro.sanchez@empresa.com', 'Empleado', '2023-07-18 11:45:00'),
('Laura Ramírez', 'laura.ramirez@empresa.com', 'Encargado de Compras', '2023-08-05 13:10:00'),
('Roberto Jiménez', 'roberto.jimenez@empresa.com', 'Empleado', '2023-09-12 16:30:00'),
('Sofía Herrera', 'sofia.herrera@empresa.com', 'Empleado', '2023-10-19 10:20:00'),
('Miguel Ángel Díaz', 'miguel.diaz@empresa.com', 'Encargado de Bodega', '2023-11-25 09:00:00'),
('Elena Castro', 'elena.castro@empresa.com', 'Empleado', '2023-12-14 15:45:00'),
('Jorge Ruiz', 'jorge.ruiz@empresa.com', 'Empleado', '2024-01-08 08:15:00'),
('Patricia Vargas', 'patricia.vargas@empresa.com', 'Encargado de Compras', '2024-02-20 12:30:00'),
('Fernando Mora', 'fernando.mora@empresa.com', 'Empleado', '2024-03-01 14:00:00'),
('Lucía Rojas', 'lucia.rojas@empresa.com', 'Empleado', '2024-04-10 11:10:00'),
('Ricardo Méndez', 'ricardo.mendez@empresa.com', 'Administrador', '2024-05-05 09:30:00');

-- Proveedores (sin cambios necesarios en estructura)
INSERT INTO Proveedores (Nombre, Telefono, Email, Direccion) VALUES
('Distribuidora Alimentos S.A.', '2234-5678', 'ventas@dalimentos.com', 'Zona Industrial, Calle 12, San José'),
('Suministros Industriales Ltda.', '2255-4321', 'contacto@sumindustriales.com', 'Avenida Central, Edificio 45, San José'),
('ElectroParts Costa Rica', '2456-7890', 'info@electroparts.cr', 'Zona Franca, Alajuela'),
('Ferretería El Clavo', '2278-9012', 'ventas@ferreteriaclavo.com', 'Calle 5, Avenida 8, Heredia'),
('Papelería La Económica', '2233-4455', 'pedidos@papeleconomica.com', 'Barrio Escalante, San José'),
('Suministros Médicos CR', '2245-6789', 'ventas@sumimedicocr.com', 'Calle de la Salud, San José'),
('TecnoEquipos', '2290-1234', 'servicio@tecnocorp.com', 'Paseo Colón, San José'),
('Materiales de Construcción Hermanos Pérez', '2267-8901', 'construperez@constru.com', 'Carretera a Cartago, Tres Ríos'),
('Distribuidora de Bebidas Tropicales', '2243-2198', 'distribuidora@bebidastropical.com', 'Zona Industrial, Cartago'),
('Productos de Limpieza Brillante', '2276-5432', 'ventas@brillantecr.com', 'Calle 10, San Francisco, Heredia'),
('Importadora Textil Centroamericana', '2265-4321', 'textiles@importadoratextil.com', 'Zona Franca, Coyol, Alajuela'),
('Suministros de Oficina Moderna', '2287-6543', 'clientes@oficinamoderna.com', 'Paseo Colón, San José');

-- Categorías (sin cambios necesarios)
INSERT INTO Categorias (Nombre, Descripcion) VALUES
('Material de Oficina', 'Artículos para uso en oficina'),
('Electrónicos', 'Dispositivos y componentes electrónicos'),
('Material de Construcción', 'Materiales para construcción y obra'),
('Suministros Médicos', 'Equipo y suministros para el área médica'),
('Alimentos', 'Productos alimenticios y bebidas'),
('Limpieza', 'Productos de limpieza y aseo'),
('Ferretería', 'Herramientas y artículos de ferretería'),
('Textiles', 'Telas y productos textiles');

-- Productos con precios actualizados
INSERT INTO Productos (Nombre, Descripcion, IdCategoria, Precio) VALUES
('Resma de papel carta', 'Resma de papel bond 75g, 500 hojas', 1, 13.20),
('Bolígrafos azules', 'Paquete de 10 bolígrafos azules', 1, 4.50),
('Grapadora metálica', 'Grapadora tamaño estándar', 1, 9.25),
('Monitor LED 24"', 'Monitor Full HD 1920x1080', 2, 175.99),
('Teclado inalámbrico', 'Teclado ergonómico con conexión Bluetooth', 2, 35.75),
('Cemento gris', 'Bolsa de cemento 50kg', 3, 11.25),
('Ladrillo estándar', 'Ladrillo de arcilla 10x20x40cm', 3, 0.88),
('Mascarillas quirúrgicas', 'Caja de 50 mascarillas', 4, 12.99),
('Termómetro digital', 'Termómetro clínico digital', 4, 8.50),
('Agua mineral 600ml', 'Botella de agua mineral', 5, 1.30),
('Café molido 500g', 'Café molido de grano arábica', 5, 8.25),
('Detergente líquido', 'Botella de 2 litros', 6, 6.20),
('Jabón de manos', 'Jabón líquido para manos 500ml', 6, 3.45),
('Martillo de carpintero', 'Martillo con mango de madera', 7, 13.75),
('Destornillador plano', 'Destornillador tamaño mediano', 7, 5.25),
('Tela de algodón', 'Tela de algodón crudo por metro', 8, 4.25),
('Silla ergonómica', 'Silla de oficina ajustable', 1, 95.50),
('Disco duro externo 1TB', 'Disco duro portátil USB 3.0', 2, 62.99),
('Pintura blanca mate', 'Galón de pintura blanca para interiores', 3, 24.75),
('Guantes de látex', 'Caja de 100 guantes de látex', 4, 9.99),
('Refresco cola 2L', 'Botella de refresco de cola', 5, 2.65),
('Desinfectante multiusos', 'Spray desinfectante 750ml', 6, 4.85),
('Alicate universal', 'Alicate de 8 pulgadas', 7, 10.50),
('Tela poliéster', 'Tela de poliéster por metro', 8, 3.15),
('Calculadora científica', 'Calculadora con funciones avanzadas', 1, 27.50);

-- Bodegas con encargados actualizados
INSERT INTO Bodegas (Nombre, Ubicacion, CapacidadMax, Encargado) VALUES
('Bodega Central', 'Edificio principal, primer piso', 15000, 2),
('Bodega Norte', 'Zona industrial, Heredia', 10000, 3),
('Bodega Sur', 'Zona industrial, Cartago', 9000, 9),
('Bodega de Electrónicos', 'Edificio principal, sótano', 8000, 2),
('Bodega de Material Médico', 'Edificio anexo, primer piso', 7000, 3);

-- Inventario con stock actualizado
INSERT INTO Inventario (IdProducto, IdBodega, StockActual) VALUES
-- Bodega Central
(1, 1, 750), (2, 1, 1500), (3, 1, 200), (12, 1, 450), (13, 1, 300), 
(17, 1, 35), (25, 1, 120), (22, 1, 500),
-- Bodega Norte
(6, 2, 450), (7, 2, 6500), (14, 2, 220), (15, 2, 300), (19, 2, 180), 
(23, 2, 150), (4, 2, 25), (5, 2, 75),
-- Bodega Sur
(10, 3, 950), (11, 3, 550), (16, 3, 700), (21, 3, 700), (24, 3, 500),
(1, 3, 300), (2, 3, 600), (3, 3, 80),
-- Bodega de Electrónicos
(4, 4, 100), (5, 4, 250), (18, 4, 150), (25, 4, 60), (17, 4, 20),
-- Bodega de Material Médico
(8, 5, 1200), (9, 5, 300), (20, 5, 900), (4, 5, 15), (18, 5, 30);

-- Entradas con fechas variadas (2023-2024)
INSERT INTO Entradas (IdUsuario, IdProveedor, IdBodega, FechaEntrada) VALUES
-- Enero 2023
(6, 1, 1, '2023-01-10 09:30:00'), (12, 2, 4, '2023-01-12 11:15:00'),
-- Febrero 2023
(6, 3, 4, '2023-02-05 14:20:00'), (12, 4, 2, '2023-02-18 10:45:00'),
-- Marzo 2023
(6, 5, 1, '2023-03-08 08:00:00'), (12, 6, 5, '2023-03-22 16:30:00'),
-- Abril 2023
(6, 7, 4, '2023-04-03 13:10:00'), (12, 8, 2, '2023-04-19 09:25:00'),
-- Mayo 2023
(6, 9, 3, '2023-05-11 10:40:00'), (12, 10, 1, '2023-05-29 15:20:00'),
-- Junio 2023
(6, 11, 3, '2023-06-07 11:50:00'), (12, 12, 1, '2023-06-15 14:15:00'),
-- Julio 2023
(6, 1, 1, '2023-07-04 08:30:00'), (12, 2, 4, '2023-07-20 12:45:00'),
-- Agosto 2023
(6, 3, 4, '2023-08-09 10:10:00'), (12, 4, 2, '2023-08-24 16:00:00'),
-- Septiembre 2023
(6, 5, 1, '2023-09-05 09:20:00'), (12, 6, 5, '2023-09-18 13:35:00'),
-- Octubre 2023
(6, 7, 4, '2023-10-12 11:25:00'), (12, 8, 2, '2023-10-30 15:50:00'),
-- Noviembre 2023
(6, 9, 3, '2023-11-08 10:15:00'), (12, 10, 1, '2023-11-22 14:40:00'),
-- Diciembre 2023
(6, 11, 3, '2023-12-04 09:45:00'), (12, 12, 1, '2023-12-19 12:30:00'),
-- Enero 2024
(6, 1, 1, '2024-01-10 08:20:00'), (12, 2, 4, '2024-01-25 11:55:00'),
-- Febrero 2024
(6, 3, 4, '2024-02-07 14:10:00'), (12, 4, 2, '2024-02-21 10:25:00'),
-- Marzo 2024
(6, 5, 1, '2024-03-05 09:40:00'), (12, 6, 5, '2024-03-18 16:15:00'),
-- Abril 2024
(6, 7, 4, '2024-04-02 13:30:00'), (12, 8, 2, '2024-04-17 15:45:00'),
-- Mayo 2024
(6, 9, 3, '2024-05-08 10:50:00'), (12, 10, 1, '2024-05-24 14:05:00'),
-- Junio 2024
(6, 11, 3, '2024-06-11 11:20:00'), (12, 12, 1, '2024-06-27 16:40:00');

-- DetalleEntradas con cantidades variadas
INSERT INTO DetalleEntradas (IdEntrada, IdProducto, Cantidad, PrecioUnitario) VALUES
-- Entradas 2023
(1, 1, 150, 12.00), (1, 2, 300, 4.00), (1, 3, 50, 8.00),
(2, 4, 20, 170.00), (2, 5, 30, 32.00), (2, 18, 25, 58.00),
(3, 18, 15, 60.00), (3, 25, 30, 25.00), (4, 6, 100, 10.00),
(4, 7, 1500, 0.80), (5, 12, 100, 5.50), (5, 13, 80, 3.00),
(6, 8, 300, 12.00), (6, 9, 100, 8.00), (7, 4, 10, 175.00),
(7, 5, 20, 33.00), (8, 14, 50, 12.00), (8, 15, 60, 4.50),
(9, 10, 300, 1.20), (9, 11, 150, 7.50), (10, 22, 200, 4.50),
(11, 16, 250, 3.80), (11, 24, 300, 2.80), (12, 1, 100, 12.50),
(12, 17, 15, 90.00), (13, 2, 200, 4.20), (14, 18, 30, 60.00),
(15, 19, 50, 23.00), (16, 20, 300, 9.00), (17, 21, 200, 2.50),
(18, 22, 150, 4.75), (19, 23, 80, 9.50), (20, 24, 200, 3.00),
-- Entradas 2024
(21, 1, 200, 12.80), (21, 2, 400, 4.30), (22, 4, 15, 178.00),
(22, 5, 25, 34.00), (23, 6, 80, 10.50), (23, 7, 1200, 0.85),
(24, 8, 250, 12.50), (24, 9, 80, 8.25), (25, 10, 350, 1.25),
(25, 11, 180, 7.80), (26, 12, 120, 5.75), (26, 13, 90, 3.25),
(27, 14, 60, 13.00), (27, 15, 70, 5.00), (28, 16, 300, 4.00),
(28, 17, 20, 92.00), (29, 18, 35, 62.00), (29, 19, 60, 24.00),
(30, 20, 350, 9.50), (30, 21, 250, 2.60);

-- Salidas con fechas variadas (2023-2024)
INSERT INTO Salidas (IdUsuario, IdBodega, Destino, FechaSalida) VALUES
-- Primer semestre 2023
(4, 1, 'Departamento de Contabilidad', '2023-01-20 10:30:00'),
(5, 1, 'Departamento de Ventas', '2023-02-15 14:15:00'),
(7, 4, 'Departamento de TI', '2023-03-10 09:45:00'),
(8, 2, 'Obra en San José Centro', '2023-04-05 11:20:00'),
(10, 5, 'Clínica interna', '2023-05-18 15:30:00'),
(11, 3, 'Cafetería principal', '2023-06-22 08:45:00'),
-- Segundo semestre 2023
(13, 1, 'Departamento de Marketing', '2023-07-14 13:10:00'),
(14, 4, 'Soporte técnico', '2023-08-09 10:25:00'),
(4, 2, 'Obra en Heredia', '2023-09-12 16:40:00'),
(5, 3, 'Evento corporativo', '2023-10-25 12:15:00'),
(7, 5, 'Hospital asociado', '2023-11-08 09:30:00'),
(8, 1, 'Departamento de Recursos Humanos', '2023-12-15 14:50:00'),
-- Primer semestre 2024
(10, 4, 'Nuevos empleados', '2024-01-18 11:40:00'),
(11, 2, 'Taller de mantenimiento', '2024-02-22 08:15:00'),
(13, 3, 'Reunión de directores', '2024-03-07 15:20:00'),
(14, 1, 'Capacitación interna', '2024-04-11 10:35:00'),
(4, 3, 'Evento de clientes', '2024-05-16 13:45:00'),
(5, 4, 'Actualización de equipos', '2024-06-20 09:10:00');

-- DetalleSalidas con cantidades realistas
INSERT INTO DetalleSalidas (IdSalida, IdProducto, Cantidad) VALUES
-- Salidas 2023
(1, 1, 20), (1, 2, 40), (1, 3, 5),
(2, 12, 10), (2, 13, 8), (2, 17, 2),
(3, 4, 5), (3, 5, 8), (3, 18, 3),
(4, 6, 25), (4, 7, 500), (4, 14, 10),
(5, 8, 100), (5, 9, 25), (5, 20, 150),
(6, 10, 50), (6, 11, 30), (6, 21, 40),
(7, 1, 15), (7, 2, 30), (7, 25, 5),
(8, 4, 3), (8, 5, 6), (8, 18, 2),
(9, 6, 20), (9, 7, 300), (9, 19, 15),
(10, 10, 30), (10, 11, 20), (10, 16, 25),
(11, 8, 80), (11, 9, 20), (11, 20, 120),
(12, 12, 15), (12, 13, 10), (12, 22, 20),
-- Salidas 2024
(13, 4, 8), (13, 5, 12), (13, 25, 3),
(14, 6, 30), (14, 7, 400), (14, 23, 15),
(15, 10, 40), (15, 11, 25), (15, 24, 30),
(16, 1, 25), (16, 2, 50), (16, 3, 8),
(17, 12, 12), (17, 13, 8), (17, 17, 3),
(18, 4, 6), (18, 5, 10), (18, 18, 4);