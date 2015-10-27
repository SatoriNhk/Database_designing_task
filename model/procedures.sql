use sevryukov_task;
DROP PROCEDURE IF EXISTS `test_views`;
DELIMITER ;;
CREATE PROCEDURE `test_views`()
Begin
DECLARE total int;
DECLARE i int;
DECLARE pass bool;
DECLARE temp varchar (64);
SET i=0;
SELECT count(*) INTO total FROM  information_schema.views where TABLE_SCHEMA='sevryukov_task';
WHILE (i<total) DO
	SELECT TABLE_NAME INTO temp FROM information_schema.views where TABLE_SCHEMA='sevryukov_task' limit i,1;
	SET i=i+1;
    SET @Query=CONCAT( "INSERT INTO test (view_name, test_type_id, passed) VALUES ('",temp,"' ,1 , (select if((select count(*) from ", temp,")>0, true, false)))" );
    PREPARE Query FROM @Query;
	EXECUTE Query;
	DEALLOCATE PREPARE Query;
END WHILE;
END ;;

call sevryukov_task.test_views();
