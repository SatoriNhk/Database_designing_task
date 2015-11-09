use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_phantom_read_1`;
DELIMITER ;;
CREATE PROCEDURE `test_phantom_read_1`()
Begin
	select sleep(2);
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SHOW VARIABLES LIKE '%tx_isolation%';
	insert into client values();
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_phantom_read_1();
