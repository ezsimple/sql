CREATE PROCEDURE  `SP_STATS_GAME_MIN09_STROKE_SCORE`(
IN $GM_CODE CHAR(13)
)
BEGIN

    DECLARE $MIN_STROKE INT;
    DECLARE $MAX_RNDG INT;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    DROP TEMPORARY TABLE IF EXISTS _TMP;
    CREATE TEMPORARY TABLE IF NOT EXISTS _TMP (
    	SUM_STROKE INT DEFAULT '0' COMMENT '타수합계',
    	MM_CODE VARCHAR(8) COMMENT '회원코드',
    	MM_NAME_DISPLAY VARCHAR(60) COMMENT '이름',
    	E_MM_NAME_DISPLAY VARCHAR(60) COMMENT '영문이름'
    ) COMMENT='최저타 집계 임시 테이블';
    CREATE INDEX _TMP_IDX0 ON _TMP (SUM_STROKE);
    CREATE INDEX _TMP_IDX1 ON _TMP (MM_CODE);

    SELECT MAX(TOMT_RNDG) INTO $MAX_RNDG
    FROM VW_STATS_SCORE_COMMON
    WHERE GM_CODE = $GM_CODE;

    INSERT INTO _TMP
    SELECT (H01+H02+H03+H04+H05+H06+H07+H08+H09), MAN_CD, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
    FROM VW_STATS_SCORE_COMMON
    WHERE GM_CODE = $GM_CODE;

    INSERT INTO _TMP
    SELECT (H10+H11+H12+H13+H14+H15+H16+H17+H18), MAN_CD, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
    FROM VW_STATS_SCORE_COMMON
    WHERE GM_CODE = $GM_CODE;

    DELETE FROM _TMP
    WHERE MM_CODE NOT IN (
        SELECT MAN_CD FROM VW_STATS_SCORE_COMMON WHERE GM_CODE = $GM_CODE AND TOMT_RNDG = $MAX_RNDG
    );

    SELECT MIN(SUM_STROKE) INTO $MIN_STROKE FROM _TMP WHERE SUM_STROKE > 0;

    SELECT (SUM_STROKE) AS MIN_STROKE, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY
    FROM _TMP WHERE SUM_STROKE = $MIN_STROKE
    GROUP BY MM_CODE;

END;
