CREATE PROCEDURE  `SP_STATS_GAME_CONT_STROKE_SCORE`(
IN $GM_CODE CHAR(13),
IN $MODE VARCHAR(20)
)
BEGIN

  IF $MODE = 'CONT_BIRDIE' THEN
    BEGIN
      DECLARE $MAX_COUNT INT;
      SELECT MAX(CNT) INTO $MAX_COUNT
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_BIRDIE';

      SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT AS CONT_STROKE
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_BIRDIE'
      AND CNT = $MAX_COUNT;
    END;

  ELSEIF $MODE = 'CONT_PAR' THEN
    BEGIN
      DECLARE $MAX_COUNT INT;
      SELECT MAX(CNT) INTO $MAX_COUNT
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_PAR';

      SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT AS CONT_STROKE
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_PAR'
      AND CNT = $MAX_COUNT;
    END;

  ELSEIF $MODE = 'CONT_NOBOGEY' THEN
    BEGIN
      DECLARE $MAX_COUNT INT;
      SELECT MAX(CNT) INTO $MAX_COUNT
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_NOBOGEY';

      SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT AS CONT_STROKE
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_NOBOGEY'
      AND CNT = $MAX_COUNT;
    END;

  ELSEIF $MODE = 'CONT_BOGEY' THEN
    BEGIN
      DECLARE $MAX_COUNT INT;
      SELECT MAX(CNT) INTO $MAX_COUNT
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_BOGEY';

      SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT AS CONT_STROKE
      FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV = 'CONT_BOGEY'
      AND CNT = $MAX_COUNT;
    END;

  ELSEIF $MODE = 'GEN' THEN
    BEGIN

      DECLARE $MM_CODE VARCHAR(10);
      DECLARE $TOMT_RNDG INT;
      DECLARE $MAX_RNDG INT;

      DECLARE $ST01 INT;
      DECLARE $ST02 INT;
      DECLARE $ST03 INT;
      DECLARE $ST04 INT;
      DECLARE $ST05 INT;
      DECLARE $ST06 INT;
      DECLARE $ST07 INT;
      DECLARE $ST08 INT;
      DECLARE $ST09 INT;
      DECLARE $ST10 INT;
      DECLARE $ST11 INT;
      DECLARE $ST12 INT;
      DECLARE $ST13 INT;
      DECLARE $ST14 INT;
      DECLARE $ST15 INT;
      DECLARE $ST16 INT;
      DECLARE $ST17 INT;
      DECLARE $ST18 INT;

      DECLARE $STROKE_CURSOR CURSOR FOR
      SELECT ST01, ST02, ST03, ST04, ST05, ST06, ST07, ST08, ST09,
        ST10, ST11, ST12, ST13, ST14, ST15, ST16, ST17, ST18,
        MM_CODE, TOMT_RNDG
      FROM _TMP;

      DECLARE $STROKE_CURSOR2 CURSOR FOR
      SELECT MM_CODE
      FROM _TMP
      GROUP BY MM_CODE;

      DECLARE CONTINUE HANDLER FOR NOT FOUND SET @FETCH_STATUS := TRUE;

      START TRANSACTION;

      DROP TEMPORARY TABLE IF EXISTS _TMP;
      CREATE TEMPORARY TABLE IF NOT EXISTS _TMP (
        ST01 INT DEFAULT '0' COMMENT '1홀 기준타 대비 타수',
        ST02 INT DEFAULT '0' COMMENT '2홀 기준타 대비 타수',
        ST03 INT DEFAULT '0' COMMENT '3홀 기준타 대비 타수',
        ST04 INT DEFAULT '0' COMMENT '4홀 기준타 대비 타수',
        ST05 INT DEFAULT '0' COMMENT '5홀 기준타 대비 타수',
        ST06 INT DEFAULT '0' COMMENT '6홀 기준타 대비 타수',
        ST07 INT DEFAULT '0' COMMENT '7홀 기준타 대비 타수',
        ST08 INT DEFAULT '0' COMMENT '8홀 기준타 대비 타수',
        ST09 INT DEFAULT '0' COMMENT '9홀 기준타 대비 타수',
        ST10 INT DEFAULT '0' COMMENT '10홀 기준타 대비 타수',
        ST11 INT DEFAULT '0' COMMENT '11홀 기준타 대비 타수',
        ST12 INT DEFAULT '0' COMMENT '12홀 기준타 대비 타수',
        ST13 INT DEFAULT '0' COMMENT '13홀 기준타 대비 타수',
        ST14 INT DEFAULT '0' COMMENT '14홀 기준타 대비 타수',
        ST15 INT DEFAULT '0' COMMENT '15홀 기준타 대비 타수',
        ST16 INT DEFAULT '0' COMMENT '16홀 기준타 대비 타수',
        ST17 INT DEFAULT '0' COMMENT '17홀 기준타 대비 타수',
        ST18 INT DEFAULT '0' COMMENT '18홀 기준타 대비 타수',
      	CONT_BIRDIE INT DEFAULT '0' COMMENT '연속 버디 집계',
      	CONT_PAR INT DEFAULT '0' COMMENT '연속 파 집계',
      	CONT_NOBOGEY INT DEFAULT '0' COMMENT '연속 노보기 집계',
      	CONT_BOGEY INT DEFAULT '0' COMMENT '연속 보기 집계',
        TOMT_RNDG INT DEFAULT '0' COMMENT '라운드번호',
      	MM_CODE VARCHAR(8) COMMENT '회원코드',
      	MM_NAME_DISPLAY VARCHAR(60) COMMENT '이름',
      	E_MM_NAME_DISPLAY VARCHAR(60) COMMENT '영문이름'
      ) COMMENT='연속타 집계 임시 테이블';
      CREATE INDEX _TMP_IDX0 ON _TMP(MM_CODE);
      CREATE INDEX _TMP_IDX1 ON _TMP(MM_CODE, TOMT_RNDG);
      CREATE INDEX _TMP_IDX2 ON _TMP(CONT_BIRDIE);
      CREATE INDEX _TMP_IDX3 ON _TMP(CONT_PAR);
      CREATE INDEX _TMP_IDX4 ON _TMP(CONT_NOBOGEY);
      CREATE INDEX _TMP_IDX5 ON _TMP(CONT_BOGEY);
      CREATE INDEX _TMP_IDX6 ON _TMP(TOMT_RNDG);

      -- TOMT_RNDG 없음
      DROP TEMPORARY TABLE IF EXISTS _TMP2;
      CREATE TEMPORARY TABLE IF NOT EXISTS _TMP2 (
      	CONT_BIRDIE INT DEFAULT '0' COMMENT '연속 버디 집계',
      	CONT_PAR INT DEFAULT '0' COMMENT '연속 파 집계',
      	CONT_NOBOGEY INT DEFAULT '0' COMMENT '연속 노보기 집계',
      	CONT_BOGEY INT DEFAULT '0' COMMENT '연속 보기 집계',
      	MM_CODE VARCHAR(8) COMMENT '회원코드',
      	MM_NAME_DISPLAY VARCHAR(60) COMMENT '이름',
      	E_MM_NAME_DISPLAY VARCHAR(60) COMMENT '영문이름'
      ) COMMENT='연속타 집계 임시 테이블';
      CREATE INDEX _TMP2_IDX0 ON _TMP(MM_CODE);
      CREATE INDEX _TMP2_IDX1 ON _TMP(CONT_BIRDIE);
      CREATE INDEX _TMP2_IDX2 ON _TMP(CONT_PAR);
      CREATE INDEX _TMP2_IDX3 ON _TMP(CONT_NOBOGEY);
      CREATE INDEX _TMP2_IDX4 ON _TMP(CONT_BOGEY);

      SELECT MAX(TOMT_RNDG) INTO $MAX_RNDG
      FROM VW_STATS_SCORE_COMMON
      WHERE GM_CODE = $GM_CODE;

      INSERT INTO _TMP (
        ST01, ST02, ST03, ST04, ST05, ST06, ST07, ST08, ST09,
        ST10, ST11, ST12, ST13, ST14, ST15, ST16, ST17, ST18,
        TOMT_RNDG, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
      ) SELECT
      CD_1P - H01, CD_2P - H02, CD_3P - H03, CD_4P - H04, CD_5P - H05, CD_6P - H06, CD_7P - H07, CD_8P - H08, CD_9P - H09,
      CD_10P - H10, CD_11P - H11, CD_12P - H12, CD_13P - H13, CD_14P - H14, CD_15P - H15, CD_16P - H16, CD_17P - H17, CD_18P - H18,
      TOMT_RNDG, MAN_CD, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
      FROM VW_STATS_SCORE_COMMON
      WHERE GM_CODE = $GM_CODE;

      DELETE FROM _TMP
      WHERE MM_CODE NOT IN (
          SELECT MAN_CD FROM VW_STATS_SCORE_COMMON WHERE GM_CODE = $GM_CODE AND TOMT_RNDG = $MAX_RNDG
      )
      OR TRIM(MM_NAME_DISPLAY) = "";

      SET @FETCH_STATUS := FALSE;
      OPEN $STROKE_CURSOR;
      stroke_loop: LOOP
        FETCH NEXT FROM $STROKE_CURSOR INTO
        $ST01, $ST02, $ST03, $ST04, $ST05, $ST06, $ST07, $ST08, $ST09,
        $ST10, $ST11, $ST12, $ST13, $ST14, $ST15, $ST16, $ST17, $ST18,
        $MM_CODE, $TOMT_RNDG;
        IF @FETCH_STATUS THEN
            LEAVE stroke_loop;
        END IF;

        SET @CONT_BIRDIE := 0;
        SET @CONT_PAR := 0;
        SET @CONT_NOBOGEY := 0;
        SET @CONT_BOGEY := 0;
        SET @MAX_BIRDIE := 0;
        SET @MAX_PAR := 0;
        SET @MAX_NOBOGEY := 0;
        SET @MAX_BOGEY := 0;

        IF $ST01 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST02 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST03 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST04 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST05 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST06 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST07 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST08 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST09 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST10 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST11 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST12 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST13 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST14 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST15 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST16 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST17 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST18 = -1 THEN
          SET @CONT_BIRDIE := @CONT_BIRDIE + 1;
        ELSE
          SET @CONT_BIRDIE := 0;
        END IF;
        IF @CONT_BIRDIE > @MAX_BIRDIE THEN
          SET @MAX_BIRDIE := @CONT_BIRDIE;
        END IF;

        IF $ST01 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST02 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST03 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST04 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST05 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST06 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST07 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST08 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST09 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST10 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST11 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST12 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST13 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST14 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST15 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST16 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST17 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST18 < 1 THEN
          SET @CONT_NOBOGEY := @CONT_NOBOGEY + 1;
        ELSE
          SET @CONT_NOBOGEY := 0;
        END IF;
        IF @CONT_NOBOGEY > @MAX_NOBOGEY THEN
          SET @MAX_NOBOGEY := @CONT_NOBOGEY;
        END IF;

        IF $ST01 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST02 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST03 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST04 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST05 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST06 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST07 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST08 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST09 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST10 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST11 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST12 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST13 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST14 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST15 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST16 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST17 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST18 = 1 THEN
          SET @CONT_BOGEY := @CONT_BOGEY + 1;
        ELSE
          SET @CONT_BOGEY := 0;
        END IF;
        IF @CONT_BOGEY > @MAX_BOGEY THEN
          SET @MAX_BOGEY := @CONT_BOGEY;
        END IF;

        IF $ST01 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST02 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST03 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST04 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST05 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST06 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST07 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST08 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST09 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST10 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST11 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST12 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST13 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST14 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST15 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST16 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST17 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        IF $ST18 = 0 THEN
          SET @CONT_PAR := @CONT_PAR + 1;
        ELSE
          SET @CONT_PAR := 0;
        END IF;
        IF @CONT_PAR > @MAX_PAR THEN
          SET @MAX_PAR := @CONT_PAR;
        END IF;

        UPDATE _TMP
          SET CONT_BIRDIE = @MAX_BIRDIE,
          CONT_NOBOGEY = @MAX_NOBOGEY,
          CONT_BOGEY = @MAX_BOGEY,
          CONT_PAR = @MAX_PAR
        WHERE MM_CODE = $MM_CODE
        AND TOMT_RNDG = $TOMT_RNDG;

      END LOOP;

      SET @MAX_BIRDIE := 0;
      SET @MAX_PAR := 0;
      SET @MAX_NOBOGEY := 0;
      SET @MAX_BOGEY := 0;

      SET @FETCH_STATUS := FALSE;
      OPEN $STROKE_CURSOR2;
      this_loop: LOOP
        FETCH NEXT FROM $STROKE_CURSOR2 INTO $MM_CODE;
        IF @FETCH_STATUS THEN
            LEAVE this_loop;
        END IF;

        SELECT MAX(CONT_BIRDIE),MAX(CONT_PAR),MAX(CONT_NOBOGEY),MAX(CONT_BOGEY)
        INTO @MAX_BIRDIE, @MAX_PAR, @MAX_NOBOGEY, @MAX_BOGEY
        FROM _TMP
        WHERE MM_CODE = $MM_CODE;

        INSERT INTO _TMP2 (
          MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          CONT_BIRDIE, CONT_PAR, CONT_NOBOGEY, CONT_BOGEY
        )
        SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          CONT_BIRDIE, 0, 0, 0
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        AND CONT_BIRDIE = @MAX_BIRDIE
        LIMIT 1;

        INSERT INTO _TMP2 (
          MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          CONT_BIRDIE, CONT_PAR, CONT_NOBOGEY, CONT_BOGEY
        )
        SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          0, CONT_PAR, 0, 0
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        AND CONT_PAR = @MAX_PAR
        LIMIT 1;

        INSERT INTO _TMP2 (
          MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          CONT_BIRDIE, CONT_PAR, CONT_NOBOGEY, CONT_BOGEY
        )
        SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          0, 0, CONT_NOBOGEY, 0
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        AND CONT_NOBOGEY = @MAX_NOBOGEY
        LIMIT 1;

        INSERT INTO _TMP2 (
          MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          CONT_BIRDIE, CONT_PAR, CONT_NOBOGEY, CONT_BOGEY
        )
        SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
          0, 0, 0, CONT_BOGEY
        FROM _TMP
        WHERE MM_CODE = $MM_CODE
        AND CONT_BOGEY = @MAX_BOGEY
        LIMIT 1;

      END LOOP;

      DELETE FROM STATS_SCORE_RANK
      WHERE GM_CODE = $GM_CODE
      AND STATS_DIV IN ('CONT_BIRDIE','CONT_PAR','CONT_NOBOGEY','CONT_BOGEY');

      INSERT INTO STATS_SCORE_RANK (GM_CODE, MM_CODE, STATS_DIV, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT)
      SELECT $GM_CODE, MM_CODE, 'CONT_BIRDIE', MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CONT_BIRDIE
      FROM _TMP
      WHERE CONT_BIRDIE > 0
      GROUP BY MM_CODE;

      INSERT INTO STATS_SCORE_RANK (GM_CODE, MM_CODE, STATS_DIV, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT)
      SELECT $GM_CODE, MM_CODE, 'CONT_PAR', MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CONT_PAR
      FROM _TMP
      WHERE CONT_PAR > 0
      GROUP BY MM_CODE;

      INSERT INTO STATS_SCORE_RANK (GM_CODE, MM_CODE, STATS_DIV, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT)
      SELECT $GM_CODE, MM_CODE, 'CONT_NOBOGEY', MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CONT_NOBOGEY
      FROM _TMP
      WHERE CONT_NOBOGEY > 0
      GROUP BY MM_CODE;

      INSERT INTO STATS_SCORE_RANK (GM_CODE, MM_CODE, STATS_DIV, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CNT)
      SELECT $GM_CODE, MM_CODE, 'CONT_BOGEY', MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, CONT_BOGEY
      FROM _TMP
      WHERE CONT_BOGEY > 0
      GROUP BY MM_CODE;

      COMMIT;

    END;

  END IF;

END;
