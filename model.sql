-- MySQL Workbench Synchronization
-- Generated: 2015-09-28 18:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Роман

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `sevrykov_task` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`objects` (
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

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`costs` (
  `cost_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `material_id` INT(10) UNSIGNED NOT NULL ,
  `task_id` INT(10) UNSIGNED NOT NULL ,
  `price` DECIMAL(8,2) NOT NULL ,
  `quantity` DECIMAL(8,3) NOT NULL ,
  `date` DATETIME NOT NULL ,
  `is_planned_costs` TINYINT(1) NOT NULL ,
  PRIMARY KEY (`cost_id`)  ,
  INDEX `fk_costs_materials1_idx` (`material_id` ASC)  ,
  CONSTRAINT `fk_costs_materials1`
    FOREIGN KEY (`material_id`)
    REFERENCES `sevrykov_task`.`materials` (`material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contacts` (
  `contact_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_data_type_id` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `data` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`contact_id`)  ,
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  ,
  INDEX `fk_contacts_contact_data_types1_idx` (`contact_data_type_id` ASC)  ,
  CONSTRAINT `fk_contacts_objects1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`objects` (`contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contacts_contact_data_types1`
    FOREIGN KEY (`contact_data_type_id`)
    REFERENCES `sevrykov_task`.`contact_data_types` (`contact_data_types_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contacts_employees1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`employees` (`contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contacts_clients1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `sevrykov_task`.`clients` (`contact_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`employees` (
  `employee_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`employee_id`),  
  KEY (`contact_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`clients` (
  `client_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `contact_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`client_id`)  ,
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`materials` (
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

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`tasks` (
  `task_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_has_employees_id` INT(10) UNSIGNED NOT NULL ,
  `task_type` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `start` DATETIME NULL DEFAULT NULL ,
  `end_expected` DATETIME NULL DEFAULT NULL ,
  `end_actually` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`task_id`)  ,
  INDEX `fk_tasks_objects_has_employees1_idx` (`object_has_employees_id` ASC)  ,
  CONSTRAINT `fk_tasks_objects_has_employees1`
    FOREIGN KEY (`object_has_employees_id`)
    REFERENCES `sevrykov_task`.`objects_has_employees` (`objects_has_employees_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tasks_costs1`
    FOREIGN KEY (`task_id`)
    REFERENCES `sevrykov_task`.`costs` (`task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`objects_has_employees` (
  `objects_has_employees_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `employee_id` INT(10) UNSIGNED NOT NULL ,
  `profession_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`objects_has_employees_id`, `object_id`, `employee_id`, `profession_id`)  ,
  INDEX `fk_objects_has_employees_employees1_idx` (`employee_id` ASC)  ,
  INDEX `fk_objects_has_employees_profession1_idx` (`profession_id` ASC)  ,
  INDEX `fk_objects_has_employees_objects1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_objects_has_employees_employees1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `sevrykov_task`.`employees` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_objects_has_employees_profession1`
    FOREIGN KEY (`profession_id`)
    REFERENCES `sevrykov_task`.`profession` (`profession_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_objects_has_employees_objects1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevrykov_task`.`objects` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contract` (
  `contract_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `client_id` INT(10) UNSIGNED NOT NULL ,
  PRIMARY KEY (`contract_id`)  ,
  INDEX `fk_contract_objects_idx` (`object_id` ASC)  ,
  INDEX `fk_contract_clients1_idx` (`client_id` ASC)  ,
  CONSTRAINT `fk_contract_objects`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevrykov_task`.`objects` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contract_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `sevrykov_task`.`clients` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contact_data_types` (
  `contact_data_types_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `data_type` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`contact_data_types_id`)  ,
  UNIQUE INDEX `type_UNIQUE` (`data_type` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`task_type` (
  `task_type_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `task_type_name` VARCHAR(150) NULL DEFAULT NULL ,
  PRIMARY KEY (`task_type_id`)  ,
  UNIQUE INDEX `task_type_name_UNIQUE` (`task_type_name` ASC)  ,
  CONSTRAINT `fk_task_type_tasks1`
    FOREIGN KEY (`task_type_id`)
    REFERENCES `sevrykov_task`.`tasks` (`task_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
