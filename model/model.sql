-- MySQL Workbench Synchronization
-- Generated: 2015-10-19 23:59
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Роман

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `sevryukov_task` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`object` (
  `object_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `client_id` INT(10) UNSIGNED NOT NULL COMMENT '',
  `finished` TINYINT(1) NOT NULL COMMENT '',
  PRIMARY KEY (`object_id`)  COMMENT '',
  INDEX `fk_object_client1_idx` (`client_id` ASC)  COMMENT '',
  CONSTRAINT `fk_object_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `sevryukov_task`.`client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`foreman` (
  `foreman_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `name` VARCHAR(45) NULL DEFAULT NULL COMMENT '',
  PRIMARY KEY (`foreman_id`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`client` (
  `client_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  PRIMARY KEY (`client_id`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`payment` (
  `payment_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `payment_type_id` INT(10) UNSIGNED NOT NULL COMMENT '',
  `object_id` INT(10) UNSIGNED NOT NULL COMMENT '',
  `amount` DECIMAL(12,2) UNSIGNED NOT NULL COMMENT '',
  `date` DATETIME NOT NULL COMMENT '',
  PRIMARY KEY (`payment_id`)  COMMENT '',
  INDEX `fk_payment_object1_idx` (`object_id` ASC)  COMMENT '',
  INDEX `fk_payment_payment_type1_idx` (`payment_type_id` ASC)  COMMENT '',
  CONSTRAINT `fk_payment_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevryukov_task`.`object` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_payment_type1`
    FOREIGN KEY (`payment_type_id`)
    REFERENCES `sevryukov_task`.`payment_type` (`payment_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`payment_type` (
  `payment_type_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `payment_name` VARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`payment_type_id`)  COMMENT '',
  UNIQUE INDEX `payment_name_UNIQUE` (`payment_name` ASC)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`foreman_object` (
  `foreman_id` INT(10) UNSIGNED NOT NULL COMMENT '',
  `object_id` INT(10) UNSIGNED NOT NULL COMMENT '',
  `date_start` DATETIME NULL DEFAULT NULL COMMENT '',
  `date_end` DATETIME NULL DEFAULT NULL COMMENT '',
  INDEX `fk_foreman_object_foreman1_idx` (`foreman_id` ASC)  COMMENT '',
  INDEX `fk_foreman_object_object1_idx` (`object_id` ASC)  COMMENT '',
  CONSTRAINT `fk_foreman_object_foreman1`
    FOREIGN KEY (`foreman_id`)
    REFERENCES `sevryukov_task`.`foreman` (`foreman_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_foreman_object_object1`
    FOREIGN KEY (`object_id`)
    REFERENCES `sevryukov_task`.`object` (`object_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `sevryukov_task`.`generate` (
  `generate_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '',
  `generate_type_id` INT(11) NOT NULL COMMENT '',
  `date_start` DATETIME NOT NULL COMMENT '',
  `date_end` DATETIME NOT NULL COMMENT '',
  `margin` INT(11) NOT NULL COMMENT '',
  `amount` DECIMAL(12,2) NOT NULL COMMENT '',
  PRIMARY KEY (`generate_id`)  COMMENT '')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


DELIMITER $$

USE `sevryukov_task`$$
CREATE DEFINER = CURRENT_USER TRIGGER `sevryukov_task`.`payment_BEFORE_INSERT` BEFORE INSERT ON `payment` FOR EACH ROW
BEGIN
DECLARE income decimal(12,2);
DECLARE outcome decimal(12,2);
DECLARE balance decimal(12,2);
DECLARE amount decimal(12,2);
DECLARE marg int(3);
DECLARE start_date datetime;
DECLARE end_date datetime;
DECLARE generate_type int(2);

select generate_type_id from generate  ORDER BY generate_id DESC limit 1 into generate_type;
select date_start from generate ORDER BY generate_id DESC limit 1 into start_date;
select date_end from generate ORDER BY generate_id DESC limit 1 into end_date;
select amount from generate ORDER BY generate_id DESC limit 1 into amount;
select margin from generate ORDER BY generate_id DESC limit 1 into marg;

if(generate_type = 1)  then
	begin
		select 	sum(amount) 
		from payment 
		where payment_type_id = 3
		into income;

		select sum(amount)
		from payment 
		where payment_type_id !=3 
		into outcome;

		select income - outcome into balance;

		if( (balance - NEW.amount)/(outcome) < marg/100 - 0.009 AND NEW.payment_type_id != 3) then
			set NEW.payment_type_id = 3;
			if( (balance + NEW.amount)/outcome > marg/100 + 0.009) then
				set NEW.amount = outcome/100*(marg+0.09)-balance;
			end if;
		end if;

		if((balance + NEW.amount)/(outcome) > marg/100 + 0.009 AND NEW.payment_type_id = 3) then
			set NEW.payment_type_id = 1;
			if( (balance - NEW.amount)/outcome < marg/100 - 0.009) then
				set NEW.amount = balance - outcome/100*(marg-0.09);
			end if;
		end if;
    end;
end if;
if (generate_type = 2) then
    begin
		select 	sum(amount) 
		from payment 
		where payment_type_id = 3 and payment.date between start_date and end_date
		into income;

		select sum(amount)
		from payment 
		where payment_type_id !=3 and payment.date between start_date and end_date
		into outcome;

		select income - outcome into balance;

		if( (balance - NEW.amount)/(outcome) < marg/100 - 0.009 AND NEW.payment_type_id != 3) then
			set NEW.payment_type_id = 3;
			if( (balance + NEW.amount)/outcome > marg/100 + 0.009) then
				set NEW.amount = outcome/100*(marg+0.09)-balance;
			end if;
		end if;

		if((balance + NEW.amount)/(outcome) > marg/100 + 0.009 AND NEW.payment_type_id = 3) then
			set NEW.payment_type_id = 1;
			if( (balance - NEW.amount)/outcome < marg/100 - 0.009) then
				set NEW.amount = balance - outcome/100*(marg-0.09);
			end if;
		end if;
	end;
end if;
if (generate_type = 3) then
    begin
		select 	sum(amount) 
		from payment 
		where payment_type_id = 3 
		into income;

		select sum(amount)
		from payment 
		where payment_type_id !=3 
		into outcome;

		select income - outcome into balance;

		if( balance - NEW.amount < amount*0.99 AND NEW.payment_type_id != 3) then
			set NEW.payment_type_id = 3;
			if( balance + NEW.amount > amount*1.01) then
				set NEW.amount = amount*1.0085 - balance;
			end if;
		end if;

		if( balance + NEW.amount > amount*1.01 AND NEW.payment_type_id = 3) then
			set NEW.payment_type_id = 1;
			if( balance - NEW.amount < amount*0.99) then
				set NEW.amount = balance - amount*0.995;
			end if;
		end if;
    end;
end if;
END$$


DELIMITER ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
