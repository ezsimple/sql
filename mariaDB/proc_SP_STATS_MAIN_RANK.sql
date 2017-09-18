CREATE PROCEDURE  `SP_STATS_MAIN_RANK`(
  IN $YEAR CHAR(4)
)
BEGIN

  DECLARE $MAX_PP_SEASON VARCHAR(2) DEFAULT '';

  DELETE FROM STATS_MAIN_RANK;

  IF ($YEAR IS NULL) THEN
    SELECT YEAR(CURDATE()) INTO $YEAR;
  END IF;

  SET @GENESIS_POINT := "GENESIS_POINT";
  SET @GENESIS_MONEY := "GENESIS_MONEY";
  SET @ROOKIE_POINT  := "ROOKIE_POINT";
  SET @MONEY_RANKING := "MONEY_RANKING";
  SET @AVERAGE_STROKE := "AVERAGE_STROKE";
  SET @GREEN_HIT_RATIO := "GREEN_HIT_RATIO";
  SET @TOTAL_POINT := "TOTAL_POINT";

  SET @TOUR_CODE := 11; -- KOREAN
  SET @STATS_DIV := @GENESIS_POINT;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, @TOUR_CODE, @STATS_DIV
                    FROM VW_STATS_LEADERS_POINT
                    WHERE PP_TCODE = 11
                    AND PP_YEAR = $YEAR
                    AND PP_INDEX = 0
                    AND PP_SEASON = ""
                    AND PP_CLSS = ""
                    ORDER BY PP_RANK ASC
                    LIMIT 5;

  SET @STATS_DIV := @GENESIS_MONEY;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, @TOUR_CODE, @STATS_DIV
          FROM VW_STATS_LEADERS_PRIZE
          WHERE PR_TCODE = 11
          AND PR_YEAR = $YEAR
          GROUP BY MM_CODE
          ORDER BY PR_RANK ASC
          LIMIT 5;

  SET @STATS_DIV := @ROOKIE_POINT;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PP_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, @TOUR_CODE, @STATS_DIV
          FROM VW_STATS_LEADERS_POINT
          WHERE PP_INDEX = 1
          AND PP_YEAR = $YEAR
          AND PP_TCODE = 11
          AND PP_SEASON = ""
          AND PP_CLSS = ""
          ORDER BY PP_RANK ASC
          LIMIT 5;


  SET @TOUR_CODE := 13; -- CHAMPIONS
  SET @STATS_DIV := @MONEY_RANKING;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, @TOUR_CODE, @STATS_DIV
          FROM VW_STATS_LEADERS_PRIZE
          WHERE PR_TCODE = @TOUR_CODE
          AND PR_YEAR = $YEAR
          GROUP BY MM_CODE
          ORDER BY PR_RANK ASC
          LIMIT 5;

  SET @STATS_DIV := @AVERAGE_STROKE;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RY_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, RY_POINT, @TOUR_CODE, @STATS_DIV
      FROM VW_STATS_LEADERS_COMMON
      WHERE RY_DIV = "01"
      AND RY_YEAR = $YEAR
      AND RY_TCODE = @TOUR_CODE
      GROUP BY MM_CODE
      ORDER BY RY_RANK ASC
      LIMIT 5;

  SET @STATS_DIV := @GREEN_HIT_RATIO;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RY_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, RY_POINT, @TOUR_CODE, @STATS_DIV
      FROM VW_STATS_LEADERS_COMMON
      WHERE RY_DIV = "02"
      AND RY_YEAR = $YEAR
      AND RY_TCODE = @TOUR_CODE
      GROUP BY MM_CODE
      ORDER BY RY_RANK
      LIMIT 5;

  SET @TOUR_CODE := 12; -- CHALLENGE
  SET @STATS_DIV := @TOTAL_POINT;
  SELECT MAX(PP_SEASON) INTO $MAX_PP_SEASON FROM CG_PLTR_POINT WHERE PP_YEAR = $YEAR AND PP_TCODE = @TOUR_CODE;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RANK() OVER (ORDER BY CAST(PP_RANK AS INT), CAST(PC_GMCNT AS INT),MM_NAME_DISPLAY) AS RANK,
        MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, @TOUR_CODE, @STATS_DIV
        FROM VW_STATS_LEADERS_POINT
        WHERE
        PP_SEASON = IFNULL(PC_SEASON,PP_SEASON)
        AND PP_SEASON = $MAX_PP_SEASON
        AND PP_YEAR = $YEAR
        AND PP_TCODE = @TOUR_CODE
        AND PP_INDEX = "0"
        AND PP_CLSS IN ("","1")
        ORDER BY RANK ASC
        LIMIT 5;

  SET @STATS_DIV := @MONEY_RANKING;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, @TOUR_CODE, @STATS_DIV
          FROM VW_STATS_LEADERS_PRIZE
          WHERE PR_TCODE = 11
          AND PR_YEAR = $YEAR
          GROUP BY MM_CODE
          ORDER BY PR_RANK ASC
          LIMIT 5;

  SET @STATS_DIV := @AVERAGE_STROKE;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RY_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, RY_POINT, @TOUR_CODE, @STATS_DIV
      FROM VW_STATS_LEADERS_COMMON
      WHERE RY_DIV = "01"
      AND RY_YEAR = $YEAR
      AND RY_TCODE = @TOUR_CODE
      GROUP BY MM_CODE
      ORDER BY RY_RANK ASC
      LIMIT 5;

  SET @TOUR_CODE := 17; -- FRONTIER
  SET @STATS_DIV := @TOTAL_POINT;
  SELECT MAX(PP_SEASON) INTO $MAX_PP_SEASON FROM CG_PLTR_POINT WHERE PP_YEAR = $YEAR AND PP_TCODE = @TOUR_CODE;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RANK() OVER (ORDER BY CAST(PP_RANK AS INT), CAST(PC_GMCNT AS INT),MM_NAME_DISPLAY) AS RANK,
        MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, @TOUR_CODE, @STATS_DIV
        FROM VW_STATS_LEADERS_POINT
        WHERE
        PP_SEASON = IFNULL(PC_SEASON,PP_SEASON)
        AND PP_SEASON = $MAX_PP_SEASON
        AND PP_YEAR = $YEAR
        AND PP_TCODE = @TOUR_CODE
        AND PP_INDEX = "0"
        AND PP_CLSS IN ("","1")
        ORDER BY RANK ASC
        LIMIT 5;

  SET @STATS_DIV := @MONEY_RANKING;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT PR_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, @TOUR_CODE, @STATS_DIV
          FROM VW_STATS_LEADERS_PRIZE
          WHERE PR_TCODE = @TOUR_CODE
          AND PR_YEAR = $YEAR
          GROUP BY MM_CODE
          ORDER BY PR_RANK ASC
          LIMIT 5;

  SET @STATS_DIV := @AVERAGE_STROKE;
  INSERT INTO STATS_MAIN_RANK (RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, POINT, TOUR_CODE, STATS_DIV)
  SELECT RY_RANK, MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, RY_POINT, @TOUR_CODE, @STATS_DIV
      FROM VW_STATS_LEADERS_COMMON
      WHERE RY_DIV = "01"
      AND RY_YEAR = $YEAR
      AND RY_TCODE = @TOUR_CODE
      GROUP BY MM_CODE
      ORDER BY RY_RANK ASC
      LIMIT 5;

END;
