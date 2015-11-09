use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_phantom_read_2`;
DELIMITER ;;
CREATE PROCEDURE `test_phantom_read_2`()
Begin
START TRANSACTION;
	SHOW VARIABLES LIKE '%tx_isolation%';
	SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SHOW VARIABLES LIKE '%tx_isolation%';
	SELECT sum(client.client_id) FROM client;
    select sleep(5);
	SELECT sum(client.client_id) FROM client;
COMMIT;
END ;;
DELIMITER ;
call sevryukov_task.test_phantom_read_2();
