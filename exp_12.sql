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


ALTER TABLE `订单表` ADD CONSTRAINT `fk_订单表_客户表_1` FOREIGN KEY (`客户ID`) REFERENCES `客户表` (`客户ID`);
ALTER TABLE `订单详情表` ADD CONSTRAINT `fk_订单详情表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `订单详情表` ADD CONSTRAINT `fk_订单详情表_产品表_2` FOREIGN KEY (`商品ID`) REFERENCES `产品表` (`产品ID`);
ALTER TABLE `发货记录表` ADD CONSTRAINT `fk_发货记录表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `退货表` ADD CONSTRAINT `fk_退货表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);
ALTER TABLE `退货表` ADD CONSTRAINT `fk_退货表_产品表_2` FOREIGN KEY (`退货产品ID`) REFERENCES `产品表` (`产品ID`);
ALTER TABLE `物流状态表` ADD CONSTRAINT `fk_物流状态表_订单表_1` FOREIGN KEY (`关联订单ID`) REFERENCES `订单表` (`订单ID`);

