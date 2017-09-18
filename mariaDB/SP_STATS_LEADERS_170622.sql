CREATE PROCEDURE  `SP_STATS_LEADERS`(
    IN $YEAR CHAR(4)
  , IN $TOUR_CODE CHAR(2)
  , IN $ITEM CHAR(2)
  , IN $DIV CHAR(2)
)
MAIN_ROUTINE : BEGIN
    SET @SQL_QUERY := NULL;

    CASE $ITEM
        WHEN '01' THEN
            SET @SQL_QUERY := CONCAT('SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, POINT, PC_GMCNT
                    FROM VW_STATS_LEADERS_POINT
                    WHERE PP_TCODE = 11
                    AND PP_YEAR = "',$YEAR,'"
                    AND PP_INDEX = 0
                    AND PP_SEASON = ""');

        WHEN '02' THEN
            SET @SQL_QUERY := CONCAT('SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, PR_PRIZE, PC_GMCNT
                    FROM VW_STATS_LEADERS_PRIZE
                    WHERE PR_TCODE = 11
                    AND PR_YEAR = "',$YEAR,'"');

        WHEN '03' THEN
            SET @SQL_QUERY := CONCAT('SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, POINT, PC_GMCNT
                    FROM VW_STATS_LEADERS_POINT
                    WHERE PP_INDEX = 1
                    AND PP_YEAR = "',$YEAR,'"
                    AND PP_TCODE = "',$TOUR_CODE,'"');

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
                        FROM CG_GAME_MST A1, CG_PLYR_DTL B1
                        LEFT JOIN CS_MEMB_MST C1 ON B1.MAN_CD = C1.MM_CODE
                        WHERE 1=1
                        AND A1.GM_MENT IN ("21","22")
                        AND A1.GM_CODE = B1.GAME_CODE
                        AND SUBSTRING(A1.GM_CODE,1,4) = "',$YEAR,'"
                        AND SUBSTRING(A1.GM_CODE,5,2) = "',$TOUR_CODE,'"
                    ) T1
                    LEFT JOIN CG_PLAYER_PRIZ T2 ON (T1.MM_CODE = T2.PP_PCODE AND T1.GM_CODE = T2.PP_CODE)
                    WHERE T2.PP_PRIZE != ""
                    ORDER BY T2.PP_PRIZE DESC');
        ELSE
          BEGIN








            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, RY_RANK, MM_NAME_DISPLAY, RY_POINT, PC_GMCNT
                FROM VW_STATS_LEADERS_COMMON
                WHERE RY_DIV = "',$DIV,'"
                AND RY_YEAR = "',$YEAR,'"
                AND RY_TCODE = "',$TOUR_CODE,'"');
          END;
    END CASE;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF (@SQL_QUERY IS NOT NULL) THEN
        PREPARE $QUERY FROM @SQL_QUERY;
        EXECUTE $QUERY;
        DEALLOCATE PREPARE $QUERY;
    END IF;

END;
