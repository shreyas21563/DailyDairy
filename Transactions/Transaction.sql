USE dailydairy;

-- Conflicting Transactions
-- Done
START TRANSACTION;
SET @order_id = 1;
SET @Transaction_number = 682618392;
SET @Customer_ID = 1;
SET @Delivery_Man_ID = 1;
SET @Warehouse_ID = 1;
SET @order_value = 100;
INSERT INTO `payment`(`Customer_ID`, `Order_ID`, `Amount`, `Transaction_Number`) VALUES (@Customer_ID, @order_id, @order_value, @Transaction_number);
UPDATE `customer` SET `Money In Wallet` = `Money In Wallet` - @order_value WHERE `Customer_ID` = @Customer_ID;
UPDATE `admin` SET `Money` = `Money` + @order_value;
COMMIT;

START TRANSACTION;
SET @Quantity = 200;
SET @Price = 17;
SET @Unit_ID = 1;
SET @Supplier_ID = 1;
INSERT INTO `gives_raw_milk_to`(Unit_ID, Supplier_ID, Quantity, Price) VALUES (@Unit_ID, @Supplier_ID, @Quantity, @Price);
UPDATE `admin` SET `Money` = `Money` - @Price * @Quantity;
UPDATE `farmer` SET `Money In Wallet` = `Money In Wallet` + @Price * @Quantity WHERE `farmer`.`Supplier_ID` = @Supplier_ID;
UPDATE `farmer` SET `Average Price` = (SELECT SUM(Quantity*Price) FROM `gives_raw_milk_to` WHERE `gives_raw_milk_to`.`Supplier_ID`=@Supplier_ID)/(SELECT SUM(Quantity) FROM `gives_raw_milk_to` WHERE `gives_raw_milk_to`.`Supplier_ID`=@Supplier_ID) WHERE `farmer`.`Supplier_ID`=@Supplier_ID;
COMMIT;


-- Non conflicting transactions
START TRANSACTION;
SET @delivery_man_id = 7;
SET @order_id = 1;
UPDATE `order` SET `order_status` = 'Order Delivered' WHERE `order_id` = @order_id;
UPDATE `delivery_man` SET `Number_Of_Order_Delivered` = `Number_Of_Order_Delivered` + 1 WHERE Delivery_Man_ID = @delivery_man_id;
COMMIT;

-- Done
START TRANSACTION;
SET @Customer_ID = 1;
SET @Order_ID=1;
SET @Product_ID = 1;
SET @Rating = 7;
INSERT INTO `gives_product_feedback` VALUES (@Customer_ID, @Order_ID, @Product_ID, @Rating);
UPDATE `Product` SET Average_Rating = (SELECT AVG(gives_product_feedback.Rating) FROM gives_product_feedback WHERE gives_product_feedback.Product_ID = @Product_ID) WHERE `Product_ID` = @Product_ID;
COMMIT;

START TRANSACTION;
SET @Increment = 1.1;
UPDATE `unit_worker` SET `Salary` = @Increment*`Salary`;
UPDATE `warehouse_worker` SET `Salary` = @Increment*`Salary`;
CREATE OR REPLACE VIEW `unit workers` AS
SELECT Processing_Unit.Unit_ID, SUM(unit_worker.salary) AS Unit_Worker_Salary 
FROM Processing_Unit 
INNER JOIN Unit_Worker ON Unit_Worker.Unit_ID=Processing_Unit.Unit_ID 
GROUP BY Unit_ID 
ORDER BY Unit_ID;
CREATE OR REPLACE VIEW `warehouse worker` AS
SELECT Warehouse.Warehouse_ID, Warehouse.Unit_ID, SUM(warehouse_worker.salary) AS Warehouse_Worker_Salaries
FROM Warehouse
INNER JOIN warehouse_worker ON Warehouse_worker.Warehouse_ID = Warehouse.Warehouse_ID
GROUP BY Warehouse_ID
ORDER BY Warehouse_ID;
COMMIT;

-- Done
START TRANSACTION;
SET @product_id = 1;
SET @old_value = (SELECT Product_Value FROM product WHERE product_id=@product_id);
SET @new_value = 36;
UPDATE cart, adds SET cart.cart_value = cart_value + adds.Quantity*(@new_value - @old_value) WHERE cart.Cart_ID = adds.Cart_ID AND adds.Product_ID=@product_id;
UPDATE product SET product_value = @new_value WHERE product_id=@product_id;
COMMIT;
