CREATE PROCEDURE  `SP_STATS_GAME_MIN54_STROKE_SCORE`(
IN $GM_CODE CHAR(13),
IN $MODE VARCHAR(20)
)
BEGIN

  DECLARE $STATS_DIV VARCHAR(20) DEFAULT '54HOLE_MIN_STROKE';

  IF $MODE is NULL THEN
    BEGIN
      DECLARE $MIN_COUNT INT;
      SELECT MIN(CNT) INTO $MIN_COUNT
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = $STATS_DIV;

      SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT AS MIN_STROKE
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = $STATS_DIV
      AND CNT = $MIN_COUNT;
    END;

  ELSEIF $MODE = 'GEN' THEN
    BEGIN

      DECLARE $MM_CODE VARCHAR(10);
      DECLARE $MIN_STROKE INT;
      DECLARE $MAX_RNDG INT;

      DECLARE $STROKE_CURSOR2 CURSOR FOR
      SELECT MM_CODE
      FROM _TMP
      GROUP BY MM_CODE;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET @FETCH_STATUS := TRUE;

      START TRANSACTION;

      DROP TEMPORARY TABLE IF EXISTS _TMP;
      CREATE TEMPORARY TABLE IF NOT EXISTS _TMP (
      	SUM_STROKE INT DEFAULT '0' COMMENT '타수 집계',
      	MM_CODE VARCHAR(8) COMMENT '회원코드',
      	MM_NAME_DISPLAY VARCHAR(60) COMMENT '이름',
      	E_MM_NAME_DISPLAY VARCHAR(60) COMMENT '영문이름'
      ) COMMENT='최저타 집계 임시 테이블';

      SELECT MAX(TOMT_RNDG) INTO $MAX_RNDG
      FROM VW_STATS_SCORE_COMMON
      WHERE GM_CODE = $GM_CODE;

      INSERT INTO _TMP
      SELECT (H01+H02+H03+H04+H05+H06+H07+H08+H09+H10+H11+H12+H13+H14+H15+H16+H17+H18), MAN_CD, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
      FROM VW_STATS_SCORE_COMMON
      WHERE GM_CODE = $GM_CODE
      AND TOMT_RNDG = "1";

      UPDATE _TMP A, (
        SELECT (H01+H02+H03+H04+H05+H06+H07+H08+H09+H10+H11+H12+H13+H14+H15+H16+H17+H18) AS SUM_STROKE, MAN_CD
        FROM VW_STATS_SCORE_COMMON
        WHERE GM_CODE = $GM_CODE
        AND TOMT_RNDG = "2" ) B
      SET A.SUM_STROKE = A.SUM_STROKE + B.SUM_STROKE
      WHERE A.MM_CODE = B.MAN_CD;

      UPDATE _TMP A, (
        SELECT (H01+H02+H03+H04+H05+H06+H07+H08+H09+H10+H11+H12+H13+H14+H15+H16+H17+H18) AS SUM_STROKE, MAN_CD
        FROM VW_STATS_SCORE_COMMON
        WHERE GM_CODE = $GM_CODE
        AND TOMT_RNDG = "3" ) B
      SET A.SUM_STROKE = A.SUM_STROKE + B.SUM_STROKE
      WHERE A.MM_CODE = B.MAN_CD;

      DELETE FROM _TMP
      WHERE MM_CODE NOT IN (
          SELECT MAN_CD FROM VW_STATS_SCORE_COMMON WHERE GM_CODE = $GM_CODE AND TOMT_RNDG = $MAX_RNDG
      );

      -- SELECT MIN(SUM_STROKE) INTO $MIN_STROKE FROM _TMP WHERE SUM_STROKE > 0;

      DELETE FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = $STATS_DIV;

      SET @FETCH_STATUS := FALSE;
      OPEN $STROKE_CURSOR2;
      this_loop: LOOP
        FETCH NEXT FROM $STROKE_CURSOR2 INTO $MM_CODE;
        IF @FETCH_STATUS THEN
            LEAVE this_loop;
        END IF;
        SELECT MIN(SUM_STROKE) INTO $MIN_STROKE
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        LIMIT 1;

        INSERT INTO STATS_SCORE_RANK (GM_CODE, MM_CODE, STATS_DIV, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT)
        SELECT $GM_CODE, MM_CODE, $STATS_DIV ,MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, SUM_STROKE
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        AND SUM_STROKE = $MIN_STROKE
        LIMIT 1;

      END LOOP;

      COMMIT;

    END;
  END IF;

END;