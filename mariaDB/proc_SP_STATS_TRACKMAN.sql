CREATE PROCEDURE SP_STATS_TRACKMAN(
    IN $YEAR CHAR(4)
  , IN $TOUR_CODE CHAR(2)
)
BEGIN

DECLARE $MM_CODE VARCHAR(10);
DECLARE $MM_CODE_CURSOR CURSOR FOR
SELECT DISTINCT MAN_CD FROM TRACKMAN
WHERE MAN_CD IS NOT NULL
  AND SUBSTRING(GAME_CODE,1,4) = $YEAR
  AND SUBSTRING(GAME_CODE,5,2) = $TOUR_CODE;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET @FETCH_STATUS := TRUE;

DROP TEMPORARY TABLE IF EXISTS _STATS_TRACKMAN_TMP;
CREATE TEMPORARY TABLE _STATS_TRACKMAN_TMP (
  MM_CODE VARCHAR(10) PRIMARY KEY,
  MM_NAME_DISPLAY VARCHAR(60),
  E_MM_NAME_DISPLAY VARCHAR(60),
  RANK_CLUB_SPEED INT DEFAULT 0, AVG_CLUB_SPEED FLOAT DEFAULT 0,
  RANK_BALL_SPEED INT DEFAULT 0, AVG_BALL_SPEED FLOAT DEFAULT 0,
  RANK_SMASH_FACTOR INT DEFAULT 0, AVG_SMASH_FACTOR FLOAT DEFAULT 0,
  RANK_VERT_ANGLE INT DEFAULT 0, AVG_VERT_ANGLE FLOAT DEFAULT 0,
  RANK_SPIN_RATE INT DEFAULT 0, AVG_SPIN_RATE FLOAT DEFAULT 0,
  RANK_MAX_HEIGHT INT DEFAULT 0, AVG_MAX_HEIGHT FLOAT DEFAULT 0,
  RANK_FLIGHT_TIME INT DEFAULT 0, AVG_FLIGHT_TIME FLOAT DEFAULT 0,
  PC_GMCNT INT DEFAULT 0
);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET @FETCH_STATUS := FALSE;

OPEN $MM_CODE_CURSOR;
read_loop: LOOP
    FETCH NEXT FROM $MM_CODE_CURSOR INTO $MM_CODE;
    IF @FETCH_STATUS THEN
      LEAVE read_loop;
    END IF;
    INSERT INTO _STATS_TRACKMAN_TMP (MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
      AVG_CLUB_SPEED, AVG_BALL_SPEED, AVG_SMASH_FACTOR, AVG_VERT_ANGLE,
      AVG_SPIN_RATE, AVG_MAX_HEIGHT, AVG_FLIGHT_TIME, PC_GMCNT
    )
    SELECT MAN_CD AS MM_CODE,
      MM_NAME_DISPLAY,
      CONCAT(B.MM_MNAME," ",B.MM_LNAME," ",B.MM_FNAME) AS E_MM_NAME_DISPLAY,
      AVG(TR_CLUB_SPEED) AS AVG_CLUB_SPEED,
      AVG(TR_BALL_SPEED) AS AVG_BALL_SPEED,
      AVG(TR_SMASH_FACTOR) AS AVG_SMASH_FACTOR,
      AVG(TR_VERT_ANGLE) AS AVG_VERT_ANGLE,
      AVG(TR_SPIN_RATE) AS AVG_SPIN_RATE,
      AVG(TR_MAX_HEIGHT) AS AVG_MAX_HEIGHT,
      AVG(TR_CF_FLIGHT_TIME) AS AVG_FLIGHT_TIME,
      CAST(C.PC_GMCNT AS SIGNED) AS PC_GMCNT
    FROM
      TRACKMAN A
      LEFT JOIN CS_MEMB_MST B ON (MAN_CD = MM_CODE)
      LEFT JOIN CG_PRIZ_RANK_GMCNT C ON (MAN_CD = C.PC_PCODE AND SUBSTRING(A.GAME_CODE,1,4) = C.PC_YEAR AND SUBSTRING(A.GAME_CODE,5,2) = C.PC_TCODE)
    WHERE 1=1
      AND A.MAN_CD = $MM_CODE
      AND SUBSTRING(A.GAME_CODE,1,4) = $YEAR
      AND SUBSTRING(A.GAME_CODE,5,2) = $TOUR_CODE;
END LOOP;
CLOSE $MM_CODE_CURSOR;

UPDATE _STATS_TRACKMAN_TMP A
  INNER JOIN (SELECT MM_CODE,
  RANK() OVER (ORDER BY AVG_CLUB_SPEED DESC) AS RANK_CLUB_SPEED,
  RANK() OVER (ORDER BY AVG_BALL_SPEED DESC) AS RANK_BALL_SPEED,
  RANK() OVER (ORDER BY AVG_SMASH_FACTOR DESC) AS RANK_SMASH_FACTOR,
  RANK() OVER (ORDER BY AVG_VERT_ANGLE DESC) AS RANK_VERT_ANGLE,
  RANK() OVER (ORDER BY AVG_SPIN_RATE DESC) AS RANK_SPIN_RATE,
  RANK() OVER (ORDER BY AVG_MAX_HEIGHT DESC) AS RANK_MAX_HEIGHT,
  RANK() OVER (ORDER BY AVG_FLIGHT_TIME DESC) AS RANK_FLIGHT_TIME
  FROM _STATS_TRACKMAN_TMP) B
  ON (A.MM_CODE = B.MM_CODE)
SET A.RANK_CLUB_SPEED = B.RANK_CLUB_SPEED,
  A.RANK_BALL_SPEED = B.RANK_BALL_SPEED,
  A.RANK_SMASH_FACTOR = B.RANK_SMASH_FACTOR,
  A.RANK_VERT_ANGLE = B.RANK_VERT_ANGLE,
  A.RANK_SPIN_RATE = B.RANK_SPIN_RATE,
  A.RANK_MAX_HEIGHT = B.RANK_MAX_HEIGHT,
  A.RANK_FLIGHT_TIME = B.RANK_FLIGHT_TIME ;

SELECT MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY,
  RANK_CLUB_SPEED, AVG_CLUB_SPEED,
  RANK_BALL_SPEED, AVG_BALL_SPEED,
  RANK_SMASH_FACTOR, AVG_SMASH_FACTOR,
  RANK_VERT_ANGLE, AVG_VERT_ANGLE,
  RANK_SPIN_RATE , AVG_SPIN_RATE,
  RANK_MAX_HEIGHT, AVG_MAX_HEIGHT,
  RANK_FLIGHT_TIME, AVG_FLIGHT_TIME,
  PC_GMCNT
FROM _STATS_TRACKMAN_TMP;

END;