SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `sevrykov_task` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`objects` (
  `object_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `price` DECIMAL(12,2) NULL DEFAULT NULL COMMENT '',
  `cost` DECIMAL(12,2) NULL DEFAULT NULL COMMENT '',
  `start` DATETIME NULL DEFAULT NULL COMMENT '',
  `end_expected` DATETIME NULL DEFAULT NULL COMMENT '',
  `end_actually` DATETIME NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`object_id`)  COMMENT '',
  UNIQUE INDEX `object_id_UNIQUE` (`object_id` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`material_cost` (
  `material_cost_guid` BINARY(16) NOT NULL COMMENT '',
  `material_id` INT(11) NOT NULL COMMENT '',
  `price` DECIMAL(8,2) NOT NULL COMMENT '',
  `quantity` DECIMAL(8,3) NOT NULL COMMENT '',
  `date` DATETIME NOT NULL COMMENT '',
  `is_planned_costs` TINYINT(1) NOT NULL COMMENT '',
  PRIMARY KEY (`material_cost_guid`, `material_id`)  COMMENT '',
  UNIQUE INDEX `material_cost_guid_UNIQUE` (`material_cost_guid` ASC)  COMMENT '',
  INDEX `fk_material_cost_materials1_idx` (`material_id` ASC)  COMMENT '',
  CONSTRAINT `fk_material_cost_materials1`
    FOREIGN KEY (`material_id`)
    REFERENCES `sevrykov_task`.`materials` (`material_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_material_cost_tasks1`
    FOREIGN KEY (`material_cost_guid`)
    REFERENCES `sevrykov_task`.`tasks` (`task_guid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contacts` (
  `contact_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `data` VARCHAR(45) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`contact_id`)  COMMENT '',
  UNIQUE INDEX `contact_id_UNIQUE` (`contact_id` ASC)  COMMENT '',
  CONSTRAINT `fk_contacts_employees`
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
  `employee_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `contact_id` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`employee_id`, `contact_id`)  COMMENT '',
  UNIQUE INDEX `employee_id_UNIQUE` (`employee_id` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`clients` (
  `client_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `contact_id` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`client_id`, `contact_id`)  COMMENT '',
  UNIQUE INDEX `client_id_UNIQUE` (`client_id` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`materials` (
  `material_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `name` VARCHAR(100) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`material_id`)  COMMENT '',
  UNIQUE INDEX `material_id_UNIQUE` (`material_id` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`profession` (
  `profession_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `name` VARCHAR(100) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`profession_id`)  COMMENT '',
  UNIQUE INDEX `profession_id_UNIQUE` (`profession_id` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`tasks` (
  `task_guid` BINARY(16) NOT NULL COMMENT '',
  `start` DATETIME NULL DEFAULT NULL COMMENT '',
  `end_expected` DATETIME NULL DEFAULT NULL COMMENT '',
  `end_actually` DATETIME NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`task_guid`)  COMMENT '',
  UNIQUE INDEX `task_guid_UNIQUE` (`task_guid` ASC)  COMMENT '',
  CONSTRAINT `fk_tasks_objects_has_employees1`
    FOREIGN KEY (`task_guid`)
    REFERENCES `sevrykov_task`.`objects_has_employees` (`objects_has_employees_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`objects_has_employees` (
  `objects_has_employees_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `object_id` INT(11) NOT NULL COMMENT '',
  `employee_id` INT(11) NOT NULL COMMENT '',
  `profession_id` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`objects_has_employees_id`, `object_id`, `employee_id`, `profession_id`)  COMMENT '',
  INDEX `fk_objects_has_employees_employees1_idx` (`employee_id` ASC)  COMMENT '',
  INDEX `fk_objects_has_employees_objects1_idx` (`object_id` ASC)  COMMENT '',
  INDEX `fk_objects_has_employees_profession1_idx` (`profession_id` ASC)  COMMENT '',
  UNIQUE INDEX `objects_has_employees_id_UNIQUE` (`objects_has_employees_id` ASC)  COMMENT '',
  CONSTRAINT `fk_objects_has_employees_objects1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevrykov_task`.`objects` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_objects_has_employees_employees1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `sevrykov_task`.`employees` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_objects_has_employees_profession1`
    FOREIGN KEY (`profession_id`)
    REFERENCES `sevrykov_task`.`profession` (`profession_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevrykov_task`.`contract` (
  `contract_id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `object_id` INT(11) NOT NULL COMMENT '',
  `client_id` INT(11) NOT NULL COMMENT '',
  PRIMARY KEY (`contract_id`, `object_id`, `client_id`)  COMMENT '',
  UNIQUE INDEX `contract_id_UNIQUE` (`contract_id` ASC)  COMMENT '',
  INDEX `fk_contract_objects1_idx` (`object_id` ASC)  COMMENT '',
  INDEX `fk_contract_clients1_idx` (`client_id` ASC)  COMMENT '',
  CONSTRAINT `fk_contract_objects1`
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
