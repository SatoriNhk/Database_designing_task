use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_nonrepeatable_read_2`;
DELIMITER ;;
CREATE PROCEDURE `test_nonrepeatable_read_2`()
Begin
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    select sleep(1);
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
	select sleep(5);
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_nonrepeatable_read_2();
