CREATE PROCEDURE  `SP_STATS_LEADERS`(
    IN $YEAR CHAR(4)
  , IN $TOUR_CODE CHAR(2)
  , IN $ITEM CHAR(2)
  , IN $DIV CHAR(2)
  , IN $ROWS CHAR(4)
)
MAIN_ROUTINE : BEGIN
    DECLARE $MAX_PP_SEASON VARCHAR(2) DEFAULT '';
    SET @SQL_QUERY := NULL;
    SET @SQL_LIMIT := '';

    IF ($ROWS IS NOT NULL) THEN
      SET @SQL_LIMIT := CONCAT(" LIMIT ",$ROWS);
    END IF;

    CASE $ITEM
        WHEN '01' THEN
            SET @SQL_QUERY := CONCAT('SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, POINT, PC_GMCNT
                    FROM VW_STATS_LEADERS_POINT
                    WHERE PP_TCODE = 11
                    AND PP_YEAR = "',$YEAR,'"
                    AND PP_INDEX = 0
                    AND PP_SEASON = ""
                    AND PP_CLSS = ""');

        WHEN '02' THEN
            SET @SQL_QUERY := CONCAT('SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, PR_PRIZE, PC_GMCNT
                    FROM VW_STATS_LEADERS_PRIZE
                    WHERE PR_TCODE = "',$TOUR_CODE,'"
                    AND PR_YEAR = "',$YEAR,'"
                    GROUP BY MM_CODE');

        WHEN '03' THEN
            SET @SQL_QUERY := CONCAT('SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, POINT, PC_GMCNT
                    FROM VW_STATS_LEADERS_POINT
                    WHERE PP_INDEX = 1
                    AND PP_YEAR = "',$YEAR,'"
                    AND PP_TCODE = "',$TOUR_CODE,'"
                    AND PP_SEASON = ""
                    AND PP_CLSS = ""');

        WHEN '04' THEN
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, RY_RANK, MM_NAME_DISPLAY, RY_POINT, PC_GMCNT
                    FROM VW_STATS_LEADERS_COMMON
                    WHERE RY_DIV = 61
                    AND RY_YEAR = "',$YEAR,'"
                    AND RY_TCODE = "',$TOUR_CODE,'"
                    AND RY_PCODE IN (SELECT SP_CODE FROM CG_SEED_PLYR WHERE SP_TCODE="11"
                    AND SP_INDEX = 1 AND SP_YEAR = "',$YEAR,'")
                    AND ((SELECT MM_CLSS FROM CS_MEMB_MST WHERE MM_CODE = RY_PCODE) < 3 )');

        WHEN '05' THEN
            SET @SQL_QUERY := CONCAT('SELECT RANK() OVER (ORDER BY PR_PRIZE DESC) RANK,
                    MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, PC_GMCNT
                    FROM VW_STATS_LEADERS_PRIZE
                    WHERE 1=1 AND MM_DIV = "1"
                    AND PR_YEAR = "',$YEAR,'"
                    AND PR_TCODE = "',$TOUR_CODE,'"');

        WHEN '06' THEN
            SET @SQL_QUERY := CONCAT('SELECT RANK() OVER (ORDER BY T2.PP_PRIZE DESC) AS RANK,
                    T1.GM_CODE, T1.MM_CODE, T1.MM_NAME_DISPLAY, T1.E_MM_NAME_DISPLAY, T2.PP_PRIZE
                    FROM
                    (SELECT
                        A1.GM_CODE,
                        B1.MAN_CD AS MM_CODE,
                        C1.MM_NAME_DISPLAY,
                        CONCAT(C1.MM_MNAME," ",C1.MM_LNAME," ",C1.MM_FNAME) AS E_MM_NAME_DISPLAY
                        FROM (SELECT GM_CODE FROM CG_GAME_MST WHERE GM_MENT IN ("21","22")) A1, CG_PLYR_DTL B1
                        LEFT JOIN CS_MEMB_MST C1 ON B1.MAN_CD = C1.MM_CODE
                        WHERE 1=1
                        AND A1.GM_CODE = B1.GAME_CODE
                        AND SUBSTRING(A1.GM_CODE,1,4) = "',$YEAR,'"
                        AND SUBSTRING(A1.GM_CODE,5,2) = "',$TOUR_CODE,'"
                    ) T1
                    LEFT JOIN CG_PLAYER_PRIZ T2 ON (T1.MM_CODE = T2.PP_PCODE AND T1.GM_CODE = T2.PP_CODE)
                    WHERE T2.PP_PRIZE != ""
                    ORDER BY T2.PP_PRIZE DESC');

        WHEN '07' THEN
            SELECT MAX(PP_SEASON) INTO $MAX_PP_SEASON FROM CG_PLTR_POINT WHERE PP_YEAR = $YEAR AND PP_TCODE = $TOUR_CODE;
            SET @SQL_QUERY := CONCAT('SELECT
                  RANK() OVER (ORDER BY CAST(PP_RANK AS INT), CAST(PC_GMCNT AS INT),MM_NAME_DISPLAY) AS RANK,
                  POINT, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PC_GMCNT
                  FROM VW_STATS_LEADERS_POINT
                  WHERE 1=1
                  AND PP_SEASON = IFNULL(PC_SEASON,PP_SEASON)
                  AND PP_SEASON = "',$MAX_PP_SEASON,'"
                  AND PP_YEAR = "',$YEAR,'"
                  AND PP_TCODE = "',$TOUR_CODE,'"
                  AND PP_INDEX = "0"
                  AND PP_CLSS IN ("","1")');

        ELSE
          BEGIN
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, RY_RANK, MM_NAME_DISPLAY, RY_POINT, PC_GMCNT
                FROM VW_STATS_LEADERS_COMMON
                WHERE RY_DIV = "',$DIV,'"
                AND RY_YEAR = "',$YEAR,'"
                AND RY_TCODE = "',$TOUR_CODE,'"
                GROUP BY MM_CODE');
          END;
    END CASE;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF (@SQL_QUERY IS NOT NULL) THEN
        SET @SQL_QUERY = CONCAT(@SQL_QUERY, @SQL_LIMIT);
        PREPARE $QUERY FROM @SQL_QUERY;
        EXECUTE $QUERY;
        DEALLOCATE PREPARE $QUERY;
    END IF;

END;
