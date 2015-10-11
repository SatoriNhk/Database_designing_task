SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `sevryukov_task` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`object` (
  `object_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `client_id` INT(10) UNSIGNED NOT NULL ,
  `foreman_id` INT(10) UNSIGNED NOT NULL ,
  `price` DECIMAL(12,2) NULL DEFAULT NULL ,
  `cost` DECIMAL(12,2) NULL DEFAULT NULL ,
  `start` DATE NULL DEFAULT NULL ,
  `end_expected` DATE NULL DEFAULT NULL ,
  `end_actually` DATE NULL DEFAULT NULL ,
  PRIMARY KEY (`object_id`)  ,
  INDEX `fk_object_client1_idx` (`client_id` ASC)  ,
  CONSTRAINT `fk_object_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `sevryukov_task`.`client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`cost` (
  `cost_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `material_id` INT(10) UNSIGNED NOT NULL ,
  `work_task_id` INT(10) UNSIGNED NOT NULL ,
  `price` DECIMAL(8,2) UNSIGNED NOT NULL ,
  `quantity` DECIMAL(8,3) UNSIGNED NOT NULL ,
  `date` DATETIME NOT NULL ,
  `is_planned_costs` TINYINT(1) NOT NULL ,
  PRIMARY KEY (`cost_id`)  ,
  INDEX `fk_cost_material1_idx` (`material_id` ASC)  ,
  INDEX `fk_cost_work_task1_idx` (`work_task_id` ASC)  ,
  CONSTRAINT `fk_cost_material1`
    FOREIGN KEY (`material_id`)
    REFERENCES `sevryukov_task`.`material` (`material_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_cost_work_task1`
    FOREIGN KEY (`work_task_id`)
    REFERENCES `sevryukov_task`.`work_task` (`work_task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`client_contact` (
  `client_id` INT(10) UNSIGNED NOT NULL ,
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL ,
  `data` VARCHAR(100) NULL DEFAULT NULL ,
  INDEX `fk_contact_contact_data_type1_idx` (`contact_data_type_id` ASC)  ,
  INDEX `fk_client_contact_client1_idx` (`client_id` ASC)  ,
  CONSTRAINT `fk_contact_contact_data_type1`
    FOREIGN KEY (`contact_data_type_id`)
    REFERENCES `sevryukov_task`.`contact_data_type` (`contact_data_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_client_contact_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `sevryukov_task`.`client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`employee` (
  `employee_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY (`employee_id`)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`client` (
  `client_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  PRIMARY KEY (`client_id`)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`material` (
  `material_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `material_name` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`material_id`)  ,
  UNIQUE INDEX `name_UNIQUE` (`material_name` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`profession` (
  `profession_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `profession_name` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`profession_id`)  ,
  UNIQUE INDEX `name_UNIQUE` (`profession_name` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`work_task` (
  `work_task_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `employee_id` INT(10) UNSIGNED NOT NULL ,
  `profession_id` INT(10) UNSIGNED NOT NULL ,
  `piece_rate_pay` TINYINT(1) NOT NULL ,
  `price_per_meter` DECIMAL(5,2) UNSIGNED NOT NULL ,
  `number_of_metres` DECIMAL(6,2) UNSIGNED NOT NULL ,
  `progress_percent` INT(5) ZEROFILL UNSIGNED NOT NULL ,
  `description` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`work_task_id`)  ,
  INDEX `fk_object_has_employee_profession1_idx` (`profession_id` ASC)  ,
  INDEX `fk_object_has_employee_employee1_idx` (`employee_id` ASC)  ,
  INDEX `fk_object_has_employee_object1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_object_has_employee_profession1`
    FOREIGN KEY (`profession_id`)
    REFERENCES `sevryukov_task`.`profession` (`profession_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_has_employee_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `sevryukov_task`.`employee` (`employee_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_has_employee_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevryukov_task`.`object` (`object_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`contact_data_type` (
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `data_type` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`contact_data_type_id`)  ,
  UNIQUE INDEX `type_UNIQUE` (`data_type` ASC)  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`payment` (
  `payment_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `contract_id` INT(10) UNSIGNED NOT NULL ,
  `amount` DECIMAL(12,2) UNSIGNED NOT NULL ,
  `date` DATETIME NOT NULL ,
  PRIMARY KEY (`payment_id`)  ,
  INDEX `fk_payment_object1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_payment_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevryukov_task`.`object` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`salary` (
  `salary_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `work_task_id` INT(10) UNSIGNED NOT NULL ,
  `date` DATE NOT NULL ,
  `amount` DECIMAL(8,3) NOT NULL ,
  PRIMARY KEY (`salary_id`)  ,
  INDEX `fk_salary_work_task1_idx` (`work_task_id` ASC)  ,
  CONSTRAINT `fk_salary_work_task1`
    FOREIGN KEY (`work_task_id`)
    REFERENCES `sevryukov_task`.`work_task` (`work_task_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`object_contact` (
  `object_id` INT(10) UNSIGNED NOT NULL ,
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL ,
  `data` VARCHAR(100) NULL DEFAULT NULL ,
  INDEX `fk_contact_contact_data_type1_idx` (`contact_data_type_id` ASC)  ,
  INDEX `fk_object_contact_object1_idx` (`object_id` ASC)  ,
  CONSTRAINT `fk_contact_contact_data_type10`
    FOREIGN KEY (`contact_data_type_id`)
    REFERENCES `sevryukov_task`.`contact_data_type` (`contact_data_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_contact_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevryukov_task`.`object` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`employe_contact` (
  `employe_id` INT(10) UNSIGNED NOT NULL ,
  `contact_data_type_id` INT(10) UNSIGNED NOT NULL ,
  `data` VARCHAR(100) NULL DEFAULT NULL ,
  INDEX `fk_contact_contact_data_type1_idx` (`contact_data_type_id` ASC)  ,
  INDEX `fk_employe_contact_employee1_idx` (`employe_id` ASC)  ,
  CONSTRAINT `fk_contact_contact_data_type11`
    FOREIGN KEY (`contact_data_type_id`)
    REFERENCES `sevryukov_task`.`contact_data_type` (`contact_data_type_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employe_contact_employee1`
    FOREIGN KEY (`employe_id`)
    REFERENCES `sevryukov_task`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
