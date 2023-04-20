CREATE TRIGGER `add_product` AFTER INSERT ON `adds`
FOR EACH ROW
	UPDATE cart,Product
    SET Cart_Value = Cart_Value + Product.Product_Value * NEW.Quantity
    WHERE Cart_ID = NEW.Cart_ID AND Product.Product_ID = NEW.Product_ID;

CREATE TRIGGER `update_product` AFTER UPDATE ON `adds`
FOR EACH ROW 
	UPDATE cart,product
	SET Cart_Value = Cart_Value + Product.Product_Value*(NEW.Quantity-OLD.Quantity)
    WHERE Cart_ID = NEW.Cart_ID AND Product.Product_ID = NEW.Product_ID;
        
CREATE TRIGGER `delete_product` AFTER DELETE ON `adds`
FOR EACH ROW
	UPDATE cart,Product
    SET Cart_Value = Cart_Value - Product.Product_Value * OLD.Quantity
    WHERE Cart_ID = OLD.Cart_ID AND Product.Product_ID = OLD.Product_ID;

-- CREATE TRIGGER `update_avg_rating` AFTER INSERT ON `gives_product_feedback`
-- FOR EACH ROW 
-- 	UPDATE `Product`
--     SET Average_Rating = (
--         SELECT AVG(gives_product_feedback.Rating) 
--         FROM gives_product_feedback 
--         WHERE gives_product_feedback.Product_ID = NEW.Product_ID
--     ) 
--     WHERE `Product_ID` = NEW.Product_ID;
