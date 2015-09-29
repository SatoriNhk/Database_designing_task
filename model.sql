-- MySQL Workbench Synchronization
-- Generated: 2015-09-29 04:28
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Роман

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`object` (
  `object_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_id` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `price` DECIMAL(12,2) NULL DEFAULT NULL ,
  `cost` DECIMAL(12,2) NULL DEFAULT NULL ,
  `start` DATE NULL DEFAULT NULL ,
  `end_expected` DATE NULL DEFAULT NULL ,
  `end_actually` DATE NULL DEFAULT NULL ,
  PRIMARY KEY (`object_id`)  ,
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`cost` (
  `cost_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `material_id` INT(10) UNSIGNED NOT NULL ,
  `task_id` INT(10) UNSIGNED NOT NULL ,
  `price` DECIMAL(8,2) NOT NULL ,
  `quantity` DECIMAL(8,3) NOT NULL ,
  `date` DATETIME NOT NULL ,
  `is_planned_costs` TINYINT(1) NOT NULL ,
  PRIMARY KEY (`cost_id`)  ,
  INDEX `fk_cost_material1_idx` (`material_id` ASC)  ,
  INDEX `fk_cost_task1_idx` (`task_id` ASC)  ,
  CONSTRAINT `fk_cost_material1`
    FOREIGN KEY (`material_id`)
    REFERENCES `sevrykov_task`.`material` (`material_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cost_task1`
    FOREIGN KEY (`task_id`)
    REFERENCES `sevrykov_task`.`task` (`task_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contact` (
  `contact_id` INT(10) UNSIGNED NOT NULL ,
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL ,
  `data` VARCHAR(100) NULL DEFAULT NULL ,
  INDEX `fk_contact_contact_data_type1_idx` (`contact_data_type_id` ASC)  ,
  CONSTRAINT `fk_contact_employee1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`employee` (`contact_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_contact_data_type1`
    FOREIGN KEY (`contact_data_type_id`)
    REFERENCES `sevrykov_task`.`contact_data_type` (`contact_data_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_client1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`client` (`contact_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contact_object1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`object` (`contact_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`employee` (
  `employee_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`employee_id`)  ,
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`client` (
  `client_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`client_id`)  ,
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`material` (
  `material_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `material_name` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`material_id`)  ,
  UNIQUE INDEX `name_UNIQUE` (`material_name` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`profession` (
  `profession_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `profession_name` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`profession_id`)  ,
  UNIQUE INDEX `name_UNIQUE` (`profession_name` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`task` (
  `task_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_has_employees_id` INT(10) UNSIGNED NOT NULL ,
  `task_type_id` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `start` DATETIME NULL DEFAULT NULL ,
  `end_expected` DATETIME NULL DEFAULT NULL ,
  `end_actually` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`task_id`)  ,
  INDEX `fk_task_task_type1_idx` (`task_type_id` ASC)  ,
  CONSTRAINT `fk_task_task_type1`
    FOREIGN KEY (`task_type_id`)
    REFERENCES `sevrykov_task`.`task_type` (`task_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`object_has_employee` (
  `objects_has_employees_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `employee_id` INT(10) UNSIGNED NOT NULL ,
  `profession_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`objects_has_employees_id`, `object_id`, `employee_id`, `profession_id`)  ,
  INDEX `fk_object_has_employee_profession1_idx` (`profession_id` ASC)  ,
  INDEX `fk_object_has_employee_employee1_idx` (`employee_id` ASC)  ,
  INDEX `fk_object_has_employee_object1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_object_has_employee_profession1`
    FOREIGN KEY (`profession_id`)
    REFERENCES `sevrykov_task`.`profession` (`profession_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_has_employee_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `sevrykov_task`.`employee` (`employee_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_has_employee_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevrykov_task`.`object` (`object_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contract` (
  `contract_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `client_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`contract_id`)  ,
  INDEX `fk_contract_client1_idx` (`client_id` ASC)  ,
  INDEX `fk_contract_object1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_contract_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `sevrykov_task`.`client` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_contract_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevrykov_task`.`object` (`object_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contact_data_type` (
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `data_type` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`contact_data_type_id`)  ,
  UNIQUE INDEX `type_UNIQUE` (`data_type` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`task_type` (
  `task_type_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `task_type_name` VARCHAR(150) NULL DEFAULT NULL ,
  PRIMARY KEY (`task_type_id`)  ,
  UNIQUE INDEX `task_type_name_UNIQUE` (`task_type_name` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
