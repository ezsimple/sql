CREATE PROCEDURE  `SP_STATS_GAME_SCORE_RANK_YEAR`(
IN $YEAR CHAR(4)
)
BEGIN

  DECLARE $GM_CODE VARCHAR(13);
  DECLARE $GM_NAME VARCHAR(100);

  DECLARE $GM_CURSOR CURSOR FOR
  SELECT GM_CODE, GM_NAME
  FROM  CG_GAME_MST
  WHERE SUBSTRING(GM_CODE,1,4) = $YEAR
    AND GM_MONEY <> 0
    AND GM_MENT <> '99'
    AND GM_RULE = '1'
  GROUP BY GM_CODE;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET @FETCH_STATUS := TRUE;

  delete from debug_info
  where title = 'SP_STATS_GAME_SCORE_RANK';

  SET @FETCH_STATUS := FALSE;
  SET @SQL_QUERY := NULL;
  OPEN $GM_CURSOR;
  this_loop: LOOP
    FETCH NEXT FROM $GM_CURSOR INTO $GM_CODE, $GM_NAME;
    IF @FETCH_STATUS THEN
      LEAVE this_loop;
    END IF;
    call debug_message('SP_STATS_GAME_SCORE_RANK',$GM_CODE);
    SET @SQL_QUERY = CONCAT(@SQL_QUERY,'CALL SP_STATS_GAME_SCORE_RANK("',$GM_CODE,'");')
  END LOOP;

  START TRANSACTION;
  PREPARE $QUERY FROM @SQL_QUERY;
  EXECUTE $QUERY;
  EALLOCATE PREPARE $QUERY;
  COMMIT;

  select * from debug_info
  where title = 'SP_STATS_GAME_SCORE_RANK';

END;