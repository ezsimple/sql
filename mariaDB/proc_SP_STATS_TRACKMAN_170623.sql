CREATE PROCEDURE  SP_STATS_TRACKMAN(
    IN $YEAR CHAR(4)
  , IN $TOUR_CODE CHAR(2)
  , IN $ITEM CHAR(2)
)
MAIN_ROUTINE : BEGIN
    SET @SQL_QUERY := NULL;

    CASE $ITEM
        WHEN '01' THEN -- 클럽헤드 스피드
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_CLUB_SPEED AS RANK, AVG_CLUB_SPEED AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_CLUB_SPEED ASC');

        WHEN '02' THEN  -- 볼스피드
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_BALL_SPEED AS RANK, AVG_BALL_SPEED AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_BALL_SPEED ASC');

        WHEN '03' THEN -- 스매시팩터
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_SMASH_FACTOR AS RANK, AVG_SMASH_FACTOR AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_SMASH_FACTOR ASC');

        WHEN '04' THEN -- 런치앵글
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_VERT_ANGLE AS RANK, AVG_VERT_ANGLE AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_VERT_ANGLE ASC');

        WHEN '05' THEN -- 스핀량
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_SPIN_RATE AS RANK, AVG_SPIN_RATE AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_SPIN_RATE ASC');

        WHEN '06' THEN -- 정점거리
            SET @SQL_QUERY := NULL;

        WHEN '07' THEN -- 정점높이
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_MAX_HEIGHT AS RANK, AVG_MAX_HEIGHT AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_MAX_HEIGHT ASC');

        WHEN '08' THEN -- 체공시간
            SET @SQL_QUERY := CONCAT('SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
                    RANK_FLIGHT_TIME AS RANK, AVG_FLIGHT_TIME AS AVERAGE, PC_GMCNT
                    FROM TRACKMAN_RANK
                    WHERE
                    GM_YEAR = "',$YEAR,'" AND GM_TCODE = "',$TOUR_CODE,'"
                    ORDER BY RANK_FLIGHT_TIME ASC');

        WHEN '09' THEN -- 캐리거리
            SET @SQL_QUERY := NULL;
        WHEN '10' THEN -- 캐리효율성
            SET @SQL_QUERY := NULL;
        WHEN '11' THEN -- 거리효율성
            SET @SQL_QUERY := NULL;
        WHEN '12' THEN -- total driving efficiency
            SET @SQL_QUERY := NULL;

    END CASE;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF (@SQL_QUERY IS NOT NULL) THEN
        PREPARE $QUERY FROM @SQL_QUERY;
        EXECUTE $QUERY;
        DEALLOCATE PREPARE $QUERY;
    END IF;
END;
