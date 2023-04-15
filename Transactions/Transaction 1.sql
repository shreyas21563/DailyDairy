USE dailydairy;
START TRANSACTION;
SET @order_id = (SELECT MAX(order_id) FROM `order`) + 1;
SET @order_value = (SELECT cart_value FROM Cart WHERE cart.cart_id=1);
INSERT INTO `order` VALUES (@order_id, 'Order Confirmed', 1, 1, 1, @order_value);
INSERT INTO `order_placing`(`product_id`, `order_id`, `cart_id`, `quantity`) SELECT `product_id`, @order_id, 1, quantity FROM Adds where Customer_ID=1;
DELETE FROM adds where customer_id=1;
COMMIT;		
