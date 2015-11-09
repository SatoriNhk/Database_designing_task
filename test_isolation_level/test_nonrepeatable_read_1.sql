use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_nonrepeatable_read_1`;
DELIMITER ;;
CREATE PROCEDURE `test_nonrepeatable_read_1`()
Begin
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
	select sleep(2);
    UPDATE payment SET payment.amount=payment.amount+1 WHERE payment.payment_id=1;
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_nonrepeatable_read_1();
