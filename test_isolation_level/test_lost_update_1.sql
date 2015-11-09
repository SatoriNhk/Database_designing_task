use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_lost_update_1`;
DELIMITER ;;
CREATE PROCEDURE `test_lost_update_1`()
Begin
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
    select sleep(5);
    UPDATE payment SET payment.amount=payment.amount+20 WHERE payment.payment_id=1;
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_lost_update_1();
