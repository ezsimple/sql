CREATE PROCEDURE  `SP_STATS_GAME_BP_AVG`(
	IN `$YEAR` CHAR(4)
  ,
	IN `$TOUR_CODE` CHAR(2)
  ,
	IN `$ORDER` VARCHAR(30)
  ,
	IN `$ALIGN` VARCHAR(5)

)
BEGIN

    SET @GAME_CODE := (SELECT GM_CODE
                          FROM CG_GAME_MST
                         WHERE GM_TCODE = $TOUR_CODE
                           AND LEFT(GM_CODE, 4) = $YEAR
                         ORDER BY GM_SDATE ASC LIMIT 1);

    IF (@GAME_CODE IS NULL) THEN
        SET @GAME_CODE := '00000000';
    END IF;

    IF ($ORDER IS NULL) THEN
        SET $ORDER := 'A.BP_RANK';
    END IF;

    IF ($ALIGN IS NULL) THEN
        SET $ALIGN := 'ASC';
    END IF;


    SET @SQL_SELECT := N'
        SELECT A.MAN_CODE
                 , B.MM_NAME AS MM_NAME_DISPLAY
                 , A.RY_POINT
                 , A.BP_RANK
                 , RANK() OVER(ORDER BY CAST(A.BP_RANK AS INT) DESC) AS RANK
                 , ROUND(C.POINT_01, 2) AS POINT_AVG_STROKE
                 , ROUND(C.POINT_02, 2) AS POINT_GREEN
                 , ROUND(C.POINT_03, 2) AS POINT_AVG_PUTT
                 , ROUND(C.POINT_14, 2) AS POINT_DRIVE
                 , ROUND(C.POINT_15, 2) AS POINT_FAIRWAY ';


    SET @SQL_FROM = CONCAT('
              FROM (
                    SELECT B.MAN_CODE, SUM(B.STA_POINT) AS RY_POINT
                         , CAST(SUM(B.STA_POINT_TEMP) AS INT) AS BP_RANK
                      FROM CG_GAME_MST A INNER JOIN TB_STA_GAME B
                                                 ON A.GM_CODE = B.GAME_CODE
                     WHERE LEFT(B.GAME_CODE, 4) = ',$YEAR,'
                       GROUP BY B.MAN_CODE
                    ) A INNER JOIN CS_MEMB_MST B
                                ON A.MAN_CODE = B.MM_CODE
                         LEFT JOIN (
                                    SELECT A.GM_TCODE, MAN_CODE

                                         , AVG(B.POINT_01) AS POINT_01
                                         , AVG(B.POINT_02) AS POINT_02
                                         , AVG(B.POINT_03) AS POINT_03
                                         , AVG(B.POINT_14) AS POINT_14
                                         , AVG(B.POINT_15) AS POINT_15
                                         , (SELECT RG_RANK FROM TB_STA_GAME_DIV WHERE GAME_CODE = ',@GAME_CODE,' AND MAN_CODE = B.MAN_CODE AND RG_DIV = "01") AS POINT_01_RANK
                                         , (SELECT RG_RANK FROM TB_STA_GAME_DIV WHERE GAME_CODE = ',@GAME_CODE,' AND MAN_CODE = B.MAN_CODE AND RG_DIV = "02") AS POINT_02_RANK
                                         , (SELECT RG_RANK FROM TB_STA_GAME_DIV WHERE GAME_CODE = ',@GAME_CODE,' AND MAN_CODE = B.MAN_CODE AND RG_DIV = "03") AS POINT_03_RANK
                                         , (SELECT RG_RANK FROM TB_STA_GAME_DIV WHERE GAME_CODE = ',@GAME_CODE,' AND MAN_CODE = B.MAN_CODE AND RG_DIV = "14") AS POINT_14_RANK
                                         , (SELECT RG_RANK FROM TB_STA_GAME_DIV WHERE GAME_CODE = ',@GAME_CODE,' AND MAN_CODE = B.MAN_CODE AND RG_DIV = "15") AS POINT_15_RANK
                                      FROM CG_GAME_MST A INNER JOIN TB_STA_GAME B
                                                                 ON A.GM_CODE = B.GAME_CODE
                                    WHERE A.GM_TCODE = ',$TOUR_CODE,'
                                      GROUP BY A.GM_TCODE, MAN_CODE
                                    ) C
                                ON A.MAN_CODE = C.MAN_CODE ');


    SET @SQL_WHERE = N'
                 WHERE 1 = 1 ';


    SET @SQL_ORDER := CONCAT('ORDER BY ',$ORDER,' ',$ALIGN);

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET @SQL_QUERY = CONCAT(@SQL_SELECT,@SQL_FROM,@SQL_WHERE,@SQL_ORDER);

    PREPARE $QUERY FROM @SQL_QUERY;
    EXECUTE $QUERY;
    DEALLOCATE PREPARE $QUERY;

END;
