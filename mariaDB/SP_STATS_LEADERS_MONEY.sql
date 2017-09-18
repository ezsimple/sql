CREATE PROCEDURE SP_STATS_LEADERS_MONEY (
    IN $YEAR CHAR(4)
  , IN $TOUR_CODE CHAR(2)
)
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DROP TEMPORARY TABLE IF EXISTS _TMP;

CREATE TEMPORARY TABLE _TMP (
  TPCODE VARCHAR(10) PRIMARY KEY,
  TPRIZRANK FLOAT, TPNAME VARCHAR(100),
  TPRIZ FLOAT, TAVGTAR FLOAT, TAVGDRIV FLOAT, TFAIR FLOAT,
  TGREEN FLOAT, TAVGPUTT FLOAT, TBUCK FLOAT, TSCRAM FLOAT, T10 FLOAT, TITLEIST VARCHAR(2)
  ,TAVGTAR_RANK FLOAT, TAVGDRIV_RANK FLOAT, TFAIR_RANK FLOAT,
  TGREEN_RANK FLOAT, TAVGPUTT_RANK FLOAT, TBUCK_RANK FLOAT, TSCRAM_RANK FLOAT, T10_RANK FLOAT,
  TAVGTAR_RANK_PRE FLOAT, TAVGDRIV_RANK_PRE FLOAT, TFAIR_RANK_PRE FLOAT,
  TGREEN_RANK_PRE FLOAT, TAVGPUTT_RANK_PRE FLOAT, TBUCK_RANK_PRE FLOAT, TSCRAM_RANK_PRE FLOAT, T10_RANK_PRE FLOAT
);

INSERT INTO _TMP (TPRIZRANK, TPCODE, TPNAME, TPRIZ, TITLEIST)
SELECT PR_RANK,
  PR_PCODE,
  (SELECT MM_NAME FROM CS_MEMB_MST WHERE MM_CODE = PR_PCODE),
  PR_PRIZE,
  IFNULL((SELECT CASE WHEN T_MAN_CODE<>NULL THEN 2 ELSE 1 END FROM T_H_TITLEIST WHERE T_MAN_CODE=PR_PCODE),0)
FROM CG_PRIZ_RANK
WHERE PR_YEAR=$YEAR AND PR_TCODE=$TOUR_CODE AND PR_RANK >0 ;

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TAVGTAR=RY_POINT, TAVGTAR_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='01';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TAVGDRIV=RY_POINT, TAVGDRIV_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='14';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TFAIR=RY_POINT, TFAIR_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='15';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TGREEN=RY_POINT, TGREEN_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='02';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TAVGPUTT=RY_POINT, TAVGPUTT_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='03';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TBUCK=RY_POINT , TBUCK_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='12';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET TSCRAM=RY_POINT, TSCRAM_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='63';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR ON RY_PCODE=TPCODE
SET T10=RY_POINT, T10_RANK=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='61';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TAVGTAR_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='01';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TAVGDRIV_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='14';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TFAIR_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='15';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TGREEN_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='02';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TBUCK_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='12';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TSCRAM_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='63';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET T10_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='61';

UPDATE _TMP INNER JOIN DR_RCOD_YEAR_BF ON RY_PCODE=TPCODE
SET TAVGPUTT_RANK_PRE=RY_RANK
WHERE RY_YEAR=$YEAR AND RY_TCODE=$TOUR_CODE AND RY_DIV='03';

SELECT TPRIZRANK, TPNAME
  ,ROUND(TPRIZ,0) TPRIZ
  ,ROUND(TAVGTAR,2) TAVGTAR
  ,ROUND(TAVGDRIV,2) TAVGDRIV
  ,ROUND(TFAIR,2) TFAIR
  ,ROUND(TGREEN,2) TGREEN
  ,ROUND(TAVGPUTT,2) TAVGPUTT
  ,ROUND(TBUCK,2) TBUCK
  ,ROUND(TSCRAM,2) TSCRAM
  ,ROUND(T10,2) T10
  ,TPCODE, TITLEIST ,TAVGTAR_RANK , TAVGDRIV_RANK , TFAIR_RANK , TGREEN_RANK , TAVGPUTT_RANK , TBUCK_RANK , TSCRAM_RANK , T10_RANK
  ,TAVGTAR_RANK_PRE , TAVGDRIV_RANK_PRE , TFAIR_RANK_PRE, TGREEN_RANK_PRE , TAVGPUTT_RANK_PRE , TBUCK_RANK_PRE , TSCRAM_RANK_PRE , T10_RANK_PRE
  ,CASE WHEN TAVGTAR_RANK_PRE ='0' AND TAVGTAR_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TAVGTAR_RANK - TAVGTAR_RANK_PRE,0) END AS TAVGTAR_RANK_PM
  ,CASE WHEN TAVGDRIV_RANK_PRE ='0' AND  TAVGDRIV_RANK_PRE <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TAVGDRIV_RANK- TAVGDRIV_RANK_PRE,0) END AS TAVGDRIV_RANK_PM
  ,CASE WHEN TFAIR_RANK_PRE ='0' AND TFAIR_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TFAIR_RANK -TFAIR_RANK_PRE,0) END AS TFAIR_RANK_PM
  ,CASE WHEN TGREEN_RANK_PRE ='0' AND TGREEN_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TGREEN_RANK - TGREEN_RANK_PRE,0) END AS TGREEN_RANK_PM
  ,CASE WHEN TAVGPUTT_RANK_PRE ='0' AND TAVGPUTT_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TAVGPUTT_RANK -TAVGPUTT_RANK_PRE,0) END AS TAVGPUTT_RANK_PM
  ,CASE WHEN TBUCK_RANK_PRE ='0' AND TBUCK_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TBUCK_RANK -TBUCK_RANK_PRE,0) END AS TBUCK_RANK_PM
  ,CASE WHEN TSCRAM_RANK_PRE ='0' AND TSCRAM_RANK <>'0' THEN 'RANK_ENTRY'  ELSE IFNULL(TSCRAM_RANK - TSCRAM_RANK_PRE,0) END AS TSCRAM_RANK_PM
  ,CASE WHEN T10_RANK_PRE ='0' AND T10_RANK <>'0' THEN 'RANK_ENTRY' ELSE IFNULL(T10_RANK -T10_RANK_PRE,0) END AS T10_RANK_PM
FROM _TMP WHERE TPRIZRANK IS NOT NULL ORDER BY TPRIZRANK;

END;
//

CALL SP_STATS_LEADERS_MONEY('2016', '11');

SELECT * FROM _TMP;


DROP TEMPORARY TABLE _TMP;
DROP PROCEDURE IF EXISTS SP_STATS_LEADERS_MONEY;


SELECT T1.GM_CODE, T1.GM_NAME, T2.MM_CODE
FROM
  (SELECT GM_CODE, GM_NAME
  FROM  CG_GAME_MST
  WHERE SUBSTRING(GM_SDATE,1,4) = 2016
  AND GM_TCODE = 11
  AND GM_MONEY <> 0
  AND GM_MENT <> "99" ) T1
  INNER JOIN (
    SELECT C.MM_CODE, B.GM_CODE
      FROM CG_PLAYER_PRIZ A, CG_GAME_MST B, CS_MEMB_MST C, CG_JOIN_PLYR_LST D
      WHERE SUBSTRING(A.PP_CODE,1,4)  = 2016
      AND SUBSTRING(A.PP_CODE,5,2)  = 11
      AND A.PP_CODE = B.GM_CODE
      AND A.PP_PCODE  = C.MM_CODE
      AND PP_CODE = PL_CODE AND PL_PCODE = PP_PCODE
      AND PL_CPRIZE = "0"
      GROUP BY A.PP_PCODE ,C.MM_NAME_DISPLAY,C.MM_DIV, C.MM_CLSS,C.MM_TOURNUM,C.MM_SEMINUM,C.MM_TECHNUM,C.MM_JUMIN,C.MM_NAT
  ) T2
  ON T1.GM_CODE = T2.GM_CODE
WHERE LEFT(T1.GM_CODE, 4) = 2016
GROUP BY T2.MM_CODE ;

EXPLAIN
INSERT INTO _TMP (TPRIZRANK, TPCODE, TPNAME, TPRIZ, PCODE, TITLEIST,PLAYERGAMENUM,PLAYERROUNDNUM)
SELECT PR_RANK,
  PR_PCODE,
  (SELECT MM_NAME FROM CS_MEMB_MST WHERE MM_CODE = PR_PCODE),
  PR_PRIZE,
  PR_PCODE,
  IFNULL((SELECT CASE WHEN T_MAN_CODE<>NULL THEN 2 ELSE 1 END FROM T_H_TITLEIST WHERE T_MAN_CODE=PR_PCODE),0) ,
  ( SELECT COUNT(*)
        FROM CG_GAME_MST M , CG_SCOR_MGT_MST SC ,CG_PRIZ_RANK RK
        WHERE M.GM_CODE = SC.GAME_CODE
        AND SC.MAN_CD= RK.PR_PCODE
        AND SUBSTRING(M.GM_CODE,1,4) = 2016
        AND M.GM_TCODE = 11
        AND SC.TOMT_RNDG="1"
        AND SC.RNDG_END="F"
        AND M.GM_SCODE <>"0034"
  ),
  ( SELECT SUM( CONVERT((REPLACE(SC.RNDG_END, "F", "1")),INT ))
        FROM CG_GAME_MST M ,CG_SCOR_MGT_MST SC, CG_PRIZ_RANK RK
        WHERE 1=1
        AND M.GM_CODE = SC.GAME_CODE
        AND SC.MAN_CD = RK.PR_PCODE
        AND SUBSTRING(M.GM_CODE,1,4) = 2016
        AND M.GM_TCODE = 11
        AND SC.RNDG_END="F" AND M.GM_SCODE <>"0034"
  )
FROM CG_PRIZ_RANK
WHERE PR_YEAR=2016 AND PR_TCODE=11 AND PR_RANK >0 ;

-- CREATE INDEX CG_PRIZ_RANK_IDX0 ON CG_PRIZ_RANK (PR_PCODE);
-- ALTER TABLE CG_PRIZ_RANK ADD INDEX CG_PRIZ_RANK_IDX1 (PR_PCODE,PR_YEAR,PR_TCODE,PR_RANK);
-- DROP INDEX CG_PRIZ_RANK_IDX0 ON CG_PRIZ_RANK;

SELECT COUNT(*)
    FROM CG_GAME_MST M , CG_SCOR_MGT_MST SC ,CG_PRIZ_RANK RK
    WHERE M.GM_CODE = SC.GAME_CODE
    AND SC.MAN_CD= RK.PR_PCODE
    AND SUBSTRING(M.GM_CODE,1,4) = 2016
    AND M.GM_TCODE = 11
    AND SC.TOMT_RNDG="1"
    AND SC.RNDG_END="F"
    AND M.GM_SCODE <>"0034";

SELECT SUM( CONVERT((REPLACE(SC.RNDG_END, "F", "1")),INT ))
    FROM CG_GAME_MST M ,CG_SCOR_MGT_MST SC, CG_PRIZ_RANK RK
    WHERE 1=1
    AND M.GM_CODE = SC.GAME_CODE
    AND SC.MAN_CD = RK.PR_PCODE
    AND SUBSTRING(M.GM_CODE,1,4) = 2016
    AND M.GM_TCODE = 11
    AND SC.RNDG_END="F" AND M.GM_SCODE <>"0034";
