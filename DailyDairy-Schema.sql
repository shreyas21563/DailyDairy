SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;
DROP SCHEMA IF EXISTS DailyDairy;
CREATE SCHEMA DailyDairy;
USE DailyDairy;
CREATE TABLE `Cart` (
    `Cart_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Cart_Value` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Cart_ID`)
);
CREATE TABLE `Customer` (
    `Customer_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `First_Name` VARCHAR(50) NOT NULL,
    `Last_Name` VARCHAR(50) NOT NULL,
    `Apartment_Number` INT UNSIGNED NOT NULL,
    `Locality` VARCHAR(100) NOT NULL,
    `City` VARCHAR(50) NOT NULL,
    `State` VARCHAR(50) NOT NULL,
    `Pincode` INT UNSIGNED NOT NULL CHECK (`Pincode` <= 99999),
    `Password` VARCHAR(50) NOT NULL,
    `Email_ID` VARCHAR(50) NOT NULL UNIQUE,
    `Cart_ID` INT UNSIGNED NOT NULL UNIQUE,
    `Money In Wallet` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`Customer_ID`),
    CONSTRAINT `Customer_fk_Cart_ID` FOREIGN KEY (`Cart_ID`) REFERENCES `Cart` (`Cart_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Admin` (
    `Admin_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Password` VARCHAR(20) NOT NULL,
    `Money` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`Admin_ID`)
);
CREATE TABLE `Product` (
    `Product_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Product_Name` VARCHAR(45) NOT NULL,
    `Description` VARCHAR(100) NOT NULL,
    `Product_Value` INT NOT NULL,
    `Admin_ID` INT UNSIGNED NOT NULL,
    `Average_Rating` DECIMAL(4, 2) NOT NULL DEFAULT 0,
    `Product_Availibility` VARCHAR(20) NOT NULL DEFAULT 'Out Of Stock' CHECK (`Product_Availibility` = 'Out Of Stock' OR `Product_Availibility` = 'In Stock'),
    `Quantity_Available` INT NOT NULL DEFAULT 0, 
    PRIMARY KEY (`Product_ID`),
    CONSTRAINT `Product_fk_Admin_ID` FOREIGN KEY (`Admin_ID`) REFERENCES `Admin` (`Admin_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Order` (
    `Order_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Order_Status` VARCHAR(30) NOT NULL DEFAULT 'Order Confirmed' CHECK (
        `Order_Status` = 'Order Delivered'
        OR `Order_Status` = 'Order Confirmed'
    ),
    `Delivery_Man_ID` INT UNSIGNED NOT NULL,
    `Warehouse_ID` INT UNSIGNED NOT NULL,
    `Customer_ID` INT UNSIGNED NOT NULL,
    `Order_Value` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Order_ID`),
    CONSTRAINT `Order_fk_Customer_ID` FOREIGN KEY (`Customer_ID`) REFERENCES `Customer` (`Customer_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Order_fk_Delivery_man_ID` FOREIGN KEY (`Delivery_Man_ID`) REFERENCES `Delivery_Man` (`Delivery_Man_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Order_fk_Warehouse_ID` FOREIGN KEY (`Warehouse_ID`) REFERENCES `Warehouse` (`Warehouse_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Warehouse` (
    `Warehouse_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Locality` VARCHAR(45) NOT NULL,
    `Pincode` INT UNSIGNED NOT NULL,
    `Unit_ID` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Warehouse_ID`),
    CONSTRAINT `Warehouse_fk_Unit_ID` FOREIGN KEY (`Unit_ID`) REFERENCES `Processing_Unit` (`Unit_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Warehouse_Worker`(
	`Warehouse_Worker_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Salary` INT UNSIGNED NOT NULL,
	`Warehouse_ID` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`Warehouse_Worker_ID`),
    CONSTRAINT `Warehouse_Worker_fk_Warehouse_ID` FOREIGN KEY (`Warehouse_ID`) REFERENCES `Warehouse` (`Warehouse_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Processing_Unit` (
    `Unit_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Locality` VARCHAR(100) NOT NULL,
    `Warehouse_ID` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Unit_ID`),
    CONSTRAINT `Processing_Unit_fk_Warehouse_ID` FOREIGN KEY (`Warehouse_ID`) REFERENCES `Warehouse` (`Warehouse_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Unit_Worker` (
     `Unit_Worker_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
     `Salary` INT UNSIGNED NOT NULL,
     `Unit_ID` INT UNSIGNED NOT NULL,
     PRIMARY KEY (`Unit_Worker_ID`),
     CONSTRAINT `Unit_Worker_fk_Unit_ID` FOREIGN KEY (`Unit_ID`) REFERENCES `Processing_Unit` (`Unit_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Farmer` (
    `Supplier_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Email_ID` VARCHAR(50) NOT NULL UNIQUE,
    `Password` VARCHAR(20) NOT NULL,
    `Average Price` DECIMAL(4, 2) NOT NULL DEFAULT 0,
    `Money In Wallet` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`Supplier_ID`)
);
CREATE TABLE `Delivery_Man` (
    `Delivery_Man_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `First_Name` VARCHAR(45) NOT NULL,
    `Last_Name` VARCHAR(45) NOT NULL,
    `City` VARCHAR(45) NOT NULL,
    `State` VARCHAR(45) NOT NULL,
    `Email_ID` VARCHAR(45) NOT NULL UNIQUE,
    `Password` VARCHAR(45) NOT NULL,
    `Number_Of_Order_Delivered` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`Delivery_Man_ID`)
);
CREATE TABLE `gives_product_feedback` (
    `Customer_ID` INT UNSIGNED NOT NULL,
    `Order_ID` INT UNSIGNED NOT NULL,
    `Product_id` INT UNSIGNED NOT NULL,
    `Rating` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Customer_ID`, `Order_ID`, `Product_id`)
);
CREATE TABLE `Adds` (
    `Customer_ID` INT UNSIGNED NOT NULL,
    `Product_ID` INT UNSIGNED NOT NULL,
    `Cart_ID` INT UNSIGNED NOT NULL,
    `Quantity` INT NOT NULL,
    PRIMARY KEY (`Customer_ID`, `Product_ID`, `Cart_ID`),
    CONSTRAINT `Adds_fk_Customer_ID` FOREIGN KEY (`Customer_ID`) REFERENCES `Customer` (`Customer_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Adds_fk_Product_ID` FOREIGN KEY (`Product_ID`) REFERENCES `Product` (`Product_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Adds_fk_Cart_ID` FOREIGN KEY (`Cart_ID`) REFERENCES `Cart` (`Cart_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Payment` (
    `Customer_ID` INT UNSIGNED NOT NULL,
    `Order_ID` INT UNSIGNED NOT NULL,
    `Date_Time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Amount` INT UNSIGNED NOT NULL CHECK(`Amount` > 0),
    `Transaction_Number` INT UNSIGNED NOT NULL UNIQUE,
    PRIMARY KEY (`Customer_ID`, `Order_ID`),
    CONSTRAINT `Payment_fk_Customer_ID` FOREIGN KEY (`Customer_ID`) REFERENCES `Customer` (`Customer_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Payment_fk_Order_ID` FOREIGN KEY (`Order_ID`) REFERENCES `Order` (`Order_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `Order_Placing` (
    `Product_ID` INT UNSIGNED NOT NULL,
    `Order_ID` INT UNSIGNED NOT NULL,
    `Cart_ID` INT UNSIGNED NOT NULL,
    `Quantity` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`Product_ID`, `Order_ID`),
    CONSTRAINT `OrderPlacing_fk_Product_ID` FOREIGN KEY (`Product_ID`) REFERENCES `Product` (`Product_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `OrderPlacing_fk_Order_ID` FOREIGN KEY (`Order_ID`) REFERENCES `Order` (`Order_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `OrderPlacing_fk_Cart_ID` FOREIGN KEY (`Cart_ID`) REFERENCES `Cart` (`Cart_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- CREATE TABLE `Delivery_and_Packing` (
--     `Order_ID` INT UNSIGNED NOT NULL,
--     `Delivery_Man_ID` INT UNSIGNED NOT NULL,
--     `status` VARCHAR(30) NOT NULL CHECK (
--         `status` = 'Order Delivered'
--         OR `status` = 'Order Packed'
--         OR `status` = 'Out For Delivery'
--     ),
--     `Warehouse_ID` INT UNSIGNED NOT NULL,
--     PRIMARY KEY (`Order_ID`, `Delivery_Man_ID`, `Warehouse_ID`),
--     CONSTRAINT `Delivery_and_Packing_fk_Delivery_Man_ID` FOREIGN KEY (`Delivery_Man_ID`) REFERENCES `Delivery_Man` (`Delivery_Man_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
--     CONSTRAINT `Delivery_and_Packing_fk_Warehouse_ID` FOREIGN KEY (`Warehouse_ID`) REFERENCES `Warehouse` (`Warehouse_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
--     CONSTRAINT `Delivery_and_Packing_fk_Order_ID` FOREIGN KEY (`Order_ID`) REFERENCES `Order` (`Order_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
-- );
-- CREATE TABLE `gives_discount` (
--     `Product_ID` INT UNSIGNED NOT NULL,
--     `Admin_ID` INT UNSIGNED NOT NULL,
--     `Discount` INT NOT NULL CHECK(`Discount` > 0),
--     PRIMARY KEY (`Product_ID`, `Admin_ID`),
--     CONSTRAINT `gives_discount_fk_Product_ID` FOREIGN KEY (`Product_ID`) REFERENCES `Product` (`Product_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
--     CONSTRAINT `gives_discount_fk_Admin_ID` FOREIGN KEY (`Admin_ID`) REFERENCES `Admin` (`Admin_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
-- );
CREATE TABLE `Produces` (
    `Product_ID` INT UNSIGNED NOT NULL,
    `Unit_ID` INT UNSIGNED NOT NULL,
    `Quantity` INT UNSIGNED NOT NULL CHECK(`Quantity` > 0),
    PRIMARY KEY (`Product_ID`, `Unit_ID`),
    CONSTRAINT `Produces_fk_Product_ID` FOREIGN KEY (`Product_ID`) REFERENCES `Product` (`Product_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `Produces_fk_Unit_ID` FOREIGN KEY (`Unit_ID`) REFERENCES `Processing_Unit` (`Unit_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE `gives_raw_milk_to` (
    `Unit_ID` INT UNSIGNED NOT NULL,
    `Supplier_ID` INT UNSIGNED NOT NULL,
    `Quantity` INT UNSIGNED NOT NULL,
    `Price` INT UNSIGNED NOT NULL,
    `Time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Unit_ID`, `Supplier_ID`, `Time`),
    CONSTRAINT `gives_raw_milk_to_fk_Unit_ID` FOREIGN KEY (`Unit_ID`) REFERENCES `Processing_Unit` (`Unit_ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `gives_raw_milk_to_fk_Supplier_ID` FOREIGN KEY (`Supplier_ID`) REFERENCES `Farmer` (`Supplier_ID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;