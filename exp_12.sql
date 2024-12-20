CREATE TABLE `after_sale`  (
  `product_id` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `returnorexchange_goods` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `shop_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`product_id`, `shop_phone`) USING BTREE,
  UNIQUE INDEX `unique_returnorexchange_goods`(`returnorexchange_goods` ASC) USING BTREE,
  UNIQUE INDEX `unique_product_name`(`product_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `courier`  (
  `courier_id` int NOT NULL,
  `courier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `courier_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`courier_id`) USING BTREE,
  UNIQUE INDEX `unique_courier_name`(`courier_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `customer`  (
  `customer_id` int NOT NULL,
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `customer_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `customer_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` int NOT NULL,
  PRIMARY KEY (`customer_id`) USING BTREE,
  INDEX `evaluate`(`customer_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `product`  (
  `product_id` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`product_id`) USING BTREE,
  UNIQUE INDEX `product_name`(`product_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `shop`  (
  `shop_id` int NOT NULL,
  `shop_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `shop_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `shop_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`shop_id`) USING BTREE,
  INDEX `has`(`shop_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `产品表`  (
  `产品ID` int NOT NULL,
  `产品名称` varchar(255) NOT NULL,
  `库存数量` varchar(255) NOT NULL,
  PRIMARY KEY (`产品ID`)
);

CREATE TABLE `订单表`  (
  `订单ID` int NOT NULL,
  `客户ID` int NOT NULL,
  `订单状态` varchar(255) NOT NULL,
  `配送方式` varchar(255) NOT NULL,
  PRIMARY KEY (`订单ID`)
);

CREATE TABLE `订单详情表`  (
  `订单详情ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `商品ID` int NOT NULL,
  `购买数量` int NOT NULL,
  `单价` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`订单详情ID`)
);

CREATE TABLE `发货记录表`  (
  `发货ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `发货日期` datetime NOT NULL,
  `发货状态` varchar(255) NOT NULL,
  PRIMARY KEY (`发货ID`)
);

CREATE TABLE `客户表`  (
  `客户ID` int NOT NULL,
  `客户名称` varchar(255) NOT NULL,
  `联系方式` varchar(255) NOT NULL,
  PRIMARY KEY (`客户ID`)
);

CREATE TABLE `退货表`  (
  `退货ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `退货产品ID` int NOT NULL,
  `退货数量` varchar(255) NOT NULL,
  `退货原因` varchar(255) NOT NULL,
  `退货状态` varchar(255) NOT NULL,
  PRIMARY KEY (`退货ID`)
);

CREATE TABLE `物流状态表`  (
  `状态ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `当前物流状态` varchar(255) NOT NULL,
  `更新时间` datetime NOT NULL,
  `当前所在地` varchar(255) NOT NULL,
  PRIMARY KEY (`状态ID`)
);

ALTER TABLE `courier` ADD CONSTRAINT `deal` FOREIGN KEY (`courier_name`) REFERENCES `after_sale` (`returnorexchange_goods`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `customer` ADD CONSTRAINT `evaluate` FOREIGN KEY (`customer_name`) REFERENCES `after_sale` (`product_name`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `customer` ADD CONSTRAINT `purchase` FOREIGN KEY (`customer_name`) REFERENCES `product` (`product_name`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `product` ADD CONSTRAINT `deliver` FOREIGN KEY (`product_name`) REFERENCES `courier` (`courier_name`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `shop` ADD CONSTRAINT `has` FOREIGN KEY (`shop_name`) REFERENCES `product` (`product_name`) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE `订单表` ADD CONSTRAINT `fk_订单表_客户表_1` FOREIGN KEY (`客户ID`) REFERENCES `客户表` (`客户ID`);
ALTER TABLE `订单详情表` ADD CONSTRAINT `fk_订单详情表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `订单详情表` ADD CONSTRAINT `fk_订单详情表_产品表_2` FOREIGN KEY (`商品ID`) REFERENCES `产品表` (`产品ID`);
ALTER TABLE `发货记录表` ADD CONSTRAINT `fk_发货记录表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `退货表` ADD CONSTRAINT `fk_退货表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `退货表` ADD CONSTRAINT `fk_退货表_产品表_2` FOREIGN KEY (`退货产品ID`) REFERENCES `产品表` (`产品ID`);
ALTER TABLE `物流状态表` ADD CONSTRAINT `fk_物流状态表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);

