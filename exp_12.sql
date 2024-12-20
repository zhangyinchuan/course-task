DROP TABLE IF EXISTS `产品表`;
CREATE TABLE `产品表`  (
  `产品ID` int NOT NULL,
  `产品名称` varchar(255) NOT NULL,
  `库存数量` varchar(255) NOT NULL,
  PRIMARY KEY (`产品ID`)
);

DROP TABLE IF EXISTS `订单表`;
CREATE TABLE `订单表`  (
  `订单ID` int NOT NULL,
  `客户ID` int NOT NULL,
  `订单状态` varchar(255) NOT NULL,
  `配送方式` varchar(255) NOT NULL,
  PRIMARY KEY (`订单ID`)
);

DROP TABLE IF EXISTS `订单详情表`;
CREATE TABLE `订单详情表`  (
  `订单详情ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `商品ID` int NOT NULL,
  `购买数量` int NOT NULL,
  `单价` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`订单详情ID`)
);

DROP TABLE IF EXISTS `发货记录表`;
CREATE TABLE `发货记录表`  (
  `发货ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `发货日期` datetime NOT NULL,
  `发货状态` varchar(255) NOT NULL,
  PRIMARY KEY (`发货ID`)
);

DROP TABLE IF EXISTS `客户表`;
CREATE TABLE `客户表`  (
  `客户ID` int NOT NULL,
  `客户名称` varchar(255) NOT NULL,
  `联系方式` varchar(255) NOT NULL,
  PRIMARY KEY (`客户ID`)
);

DROP TABLE IF EXISTS `退货表`;
CREATE TABLE `退货表`  (
  `退货ID` int NOT NULL,
  `关联订单ID` int NOT NULL,
  `退货产品ID` int NOT NULL,
  `退货数量` varchar(255) NOT NULL,
  `退货原因` varchar(255) NOT NULL,
  `退货状态` varchar(255) NOT NULL,
  PRIMARY KEY (`退货ID`)
);

DROP TABLE IF EXISTS `物流状态表`;
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

-- Assuming there is a notification table to insert records into
CREATE TABLE IF NOT EXISTS `通知表` (
  `通知ID` int NOT NULL AUTO_INCREMENT,
  `订单ID` int NOT NULL,
  `通知内容` varchar(255) NOT NULL,
  `通知时间` datetime NOT NULL,
  PRIMARY KEY (`通知ID`)
);

DROP TRIGGER IF EXISTS `物流状态更新触发器`;
DELIMITER //
CREATE TRIGGER `物流状态更新触发器`
AFTER UPDATE ON `物流状态表`
FOR EACH ROW
BEGIN
  IF NEW.`当前物流状态` = '已到驿站' THEN
    INSERT INTO `通知表` (`订单ID`, `通知内容`, `通知时间`)
    VALUES (NEW.`关联订单ID`, '您的订单已到驿站', NOW());
  END IF;
END;
//
DELIMITER ;

-- Assuming there is a table to store the pickup times
CREATE TABLE IF NOT EXISTS `取件记录表` (
  `取件ID` int NOT NULL AUTO_INCREMENT,
  `订单ID` int NOT NULL,
  `取件时间` datetime NOT NULL,
  PRIMARY KEY (`取件ID`)
);

DROP TRIGGER IF EXISTS `订单状态更新触发器`;
DELIMITER //
CREATE TRIGGER `订单状态更新触发器`
AFTER UPDATE ON `订单表`
FOR EACH ROW
BEGIN
  IF NEW.`订单状态` = '已取件' THEN
    INSERT INTO `取件记录表` (`订单ID`, `取件时间`)
    VALUES (NEW.`订单ID`, NOW());
  END IF;
END;
//
DELIMITER ;

-- Assuming there is a table to store the inventory change logs
CREATE TABLE IF NOT EXISTS `库存变动日志` (
  `日志ID` int NOT NULL AUTO_INCREMENT,
  `产品ID` int NOT NULL,
  `变动前库存` varchar(255) NOT NULL,
  `变动后库存` varchar(255) NOT NULL,
  `变动时间` datetime NOT NULL,
  PRIMARY KEY (`日志ID`)
);

DROP TRIGGER IF EXISTS `库存更新触发器`;
DELIMITER //
CREATE TRIGGER `库存更新触发器`
AFTER UPDATE ON `产品表`
FOR EACH ROW
BEGIN
  IF NEW.`库存数量` <> OLD.`库存数量` THEN
    INSERT INTO `库存变动日志` (`产品ID`, `变动前库存`, `变动后库存`, `变动时间`)
    VALUES (NEW.`产品ID`, OLD.`库存数量`, NEW.`库存数量`, NOW());
  END IF;
END;
//
DELIMITER ;

--获取每个客户的总购买金额
CREATE VIEW `客户总购买金额视图` AS
SELECT `客户表`.`客户ID`, `客户表`.`客户名称`, SUM(`订单详情表`.`购买数量` * `订单详情表`.`单价`) AS `总购买金额`
FROM `客户表`
JOIN `订单表` ON `客户表`.`客户ID` = `订单表`.`客户ID`
JOIN `订单详情表` ON `订单表`.`订单ID` = `订单详情表`.`关联订单ID`
GROUP BY `客户表`.`客户ID`, `客户表`.`客户名称`;

--获取每个产品的总销售数量和总销售额
CREATE VIEW `产品总销售视图` AS
SELECT `产品表`.`产品ID`, `产品表`.`产品名称`, SUM(`订单详情表`.`购买数量`) AS `总销售数量`, SUM(`订单详情表`.`购买数量` * `订单详情表`.`单价`) AS `总销售额`
FROM `产品表`
JOIN `订单详情表` ON `产品表`.`产品ID` = `订单详情表`.`商品ID`
GROUP BY `产品表`.`产品ID`, `产品表`.`产品名称`;

 --获取每个订单的详细信息，包括客户信息和发货信息
CREATE VIEW `订单详细信息视图` AS
SELECT `订单表`.`订单ID`, `客户表`.`客户名称`, `客户表`.`联系方式`, `订单详情表`.`商品ID`, `订单详情表`.`购买数量`, `订单详情表`.`单价`, `发货记录表`.`发货日期`, `发货记录表`.`发货状态`
FROM `订单表`
JOIN `客户表` ON `订单表`.`客户ID` = `客户表`.`客户ID`
JOIN `订单详情表` ON `订单表`.`订单ID` = `订单详情表`.`关联订单ID`
LEFT JOIN `发货记录表` ON `订单表`.`订单ID` = `发货记录表`.`关联订单ID`;

--获取每个客户的退货记录
CREATE VIEW `客户退货记录视图` AS
SELECT `客户表`.`客户ID`, `客户表`.`客户名称`, `退货表`.`退货ID`, `退货表`.`退货产品ID`, `退货表`.`退货数量`, `退货表`.`退货原因`, `退货表`.`退货状态`
FROM `客户表`
JOIN `订单表` ON `客户表`.`客户ID` = `订单表`.`客户ID`
JOIN `退货表` ON `订单表`.`订单ID` = `退货表`.`关联订单ID`;

--获取每个订单的物流状态变更历史
CREATE VIEW `订单物流状态历史视图` AS
SELECT `订单表`.`订单ID`, `物流状态表`.`状态ID`, `物流状态表`.`当前物流状态`, `物流状态表`.`更新时间`, `物流状态表`.`当前所在地`
FROM `订单表`
JOIN `物流状态表` ON `订单表`.`订单ID` = `物流状态表`.`关联订单ID`
ORDER BY `订单表`.`订单ID`, `物流状态表`.`更新时间`;
