CREATE PROCEDURE  `SP_STATS_GAME_COUNT`(
IN $YEAR CHAR(4),
IN $TOUR_CODE CHAR(2)
)
BEGIN
    SET @SQL_QUERY := CONCAT('SELECT COUNT(GM_CODE) AS CNT 
                        FROM CG_GAME_MST 
                        WHERE GM_CODE IN (SELECT DISTINCT(GAME_CODE) FROM SC_TOMT_CLSG WHERE AREA_CODE = "00" AND BEND_CODE = "00" AND TOT_CLSG = "1")
                        AND SUBSTRING(GM_CODE,1,4) = "',$YEAR,'" 
                        AND GM_TCODE = "',$TOUR_CODE,'" 
                        AND GM_MONEY <> 0
                        AND GM_MENT <> "99"
                        AND GM_RULE = "1"
                        AND GM_CLASS = "main"');

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF (@SQL_QUERY IS NOT NULL) THEN
        PREPARE $QUERY FROM @SQL_QUERY;
        EXECUTE $QUERY;
        DEALLOCATE PREPARE $QUERY;
    END IF;
END;
