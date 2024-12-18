CREATE TABLE `after_sale`  (
  `product_id` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `returnorexchange_goods` int NOT NULL DEFAULT 0,
  `seller_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `evaluation` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`product_id`, `seller_phone`) USING BTREE,
  UNIQUE KEY `unique_product_id` (`product_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

CREATE TABLE `buyer`  (
  `buyer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `buyer_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `buyer_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_id` int NOT NULL,
  `confirm_receipt` varchar(255) NOT NULL,
  PRIMARY KEY (`buyer_phone` DESC, `product_id` DESC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

CREATE TABLE `express_station`  (
  `courier_id` int NOT NULL,
  `courier_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `courier_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `package_name` varchar(255) NOT NULL,
  PRIMARY KEY (`courier_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

CREATE TABLE `product`  (
  `product_id` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `discount` float NOT NULL,
  `type` varchar(255) NOT NULL,
  PRIMARY KEY (`product_id`, `product_name`) USING BTREE,
  UNIQUE KEY `unique_product_id` (`product_id`) USING BTREE,
  UNIQUE KEY `unique_product_name` (`product_name`) USING BTREE,
  INDEX `product_name`(`product_name` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

CREATE TABLE `seller`  (
  `seller_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `seller_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `seller_phone` varchar(255) NOT NULL,
  PRIMARY KEY (`seller_name` DESC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

ALTER TABLE `buyer` ADD CONSTRAINT `purchase` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);
ALTER TABLE `buyer` ADD CONSTRAINT `evaluate` FOREIGN KEY (`product_id`) REFERENCES `after_sale` (`product_id`);
ALTER TABLE `express_station` ADD CONSTRAINT `deliver` FOREIGN KEY (`package_name`) REFERENCES `product` (`product_name`);
ALTER TABLE `express_station` ADD CONSTRAINT `deal` FOREIGN KEY (`courier_id`) REFERENCES `after_sale` (`product_id`);
ALTER TABLE `seller` ADD CONSTRAINT `has` FOREIGN KEY (`seller_name`) REFERENCES `product` (`product_name`);

