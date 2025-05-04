CREATE TABLE `Ubicación` (
  `ubicacionID` integer PRIMARY KEY,
  `ubicacionRegion` varchar(255),
  `ubicacionDetalle` varchar(255),
  `estatus` bit
);

CREATE TABLE `Stock` (
  `stockProdID` integer PRIMARY KEY,
  `productoID` integer,
  `cantidad` integer,
  `estatus` bit
);

CREATE TABLE `Bodegas` (
  `bodegaID` integer PRIMARY KEY,
  `ubicacionID` integer,
  `stockProdID` integer,
  `capacidadMax` integer,
  `encargado` varchar(255),
  `totalEmpleados` integer,
  `estatus` bit
);

CREATE TABLE `MovimientosProd` (
  `movimientosID` integer
);

ALTER TABLE `Bodegas` ADD FOREIGN KEY (`ubicacionID`) REFERENCES `Ubicación` (`ubicacionID`);

ALTER TABLE `Bodegas` ADD FOREIGN KEY (`stockProdID`) REFERENCES `Stock` (`stockProdID`);
