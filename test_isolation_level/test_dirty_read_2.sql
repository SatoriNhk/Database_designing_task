use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_dirty_read_2`;
DELIMITER ;;
CREATE PROCEDURE `test_dirty_read_2`()
Begin
START TRANSACTION;
	select sleep(2);
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SELECT payment.amount FROM payment WHERE payment.payment_id = 1;
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_dirty_read_2();
