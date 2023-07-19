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

