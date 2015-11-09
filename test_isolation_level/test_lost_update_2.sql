use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_lost_update_2`;
DELIMITER ;;
CREATE PROCEDURE `test_lost_update_2`()
Begin
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	select sleep(2);
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
    select sleep(5);
    UPDATE payment SET payment.amount=payment.amount+25 WHERE payment.payment_id=1;
COMMIT;
END ;;
DELIMITER ;
DROP PROCEDURE IF EXISTS `test_lost_update_3`;
DELIMITER ;;
CREATE PROCEDURE `test_lost_update_3`()
Begin
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
	
END ;;
DELIMITER ;
call sevryukov_task.test_lost_update_2();
call sevryukov_task.test_lost_update_3();
