CALL sp_insertar_producto('Aspirina', 'Tabletas 500mg, caja de 20', 4, 3.25);

CALL sp_insertar_entrada(6, 6, 5, (SELECT IdProducto FROM Productos WHERE Nombre = 'Aspirina'), 50, 2.80);

CALL sp_insertar_salida(10, 5, 'Clínica Central', (SELECT IdProducto FROM Productos WHERE Nombre = 'Aspirina'), 15);