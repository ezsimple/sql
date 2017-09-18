
DROP TABLE MAIN_TMPL_INFO;
CREATE TABLE MAIN_TMPL_INFO (
  STYLE CHAR(1) NOT NULL DEFAULT '' COMMENT '템플릿 스타일(A~M)',
  CONTENTS VARCHAR(200) NOT NULL DEFAULT '' COMMENT 'CSV포맷의 내용',
  PRIMARY KEY (STYLE)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='메인페이지템플릿정보(ADMIN/대회관리/투어관리 저장시 자동생성)';

CREATE PROCEDURE  SP_MAIN_TMPL_K_INFO(
IN $GM_GCODE CHAR(4),
IN $GM_CCODE CHAR(2)
)
BEGIN

SET @HOLE_NO := '1';
SET @YARDS := '';
SET @PAR := '';
SET @TOTAL := '';
SET @TOT_CNT := '';
SET @SCORING_AVG := '';
SET @BEF_YEAR := '';

DELETE FROM MAIN_TMPL_INFO WHERE STYLE='K';

SELECT YEAR(now()) - 1 INTO @BEF_YEAR;

SELECT
YARDS, PAR ,TOTAL, TOT_CNT ,SCORING_AVG
INTO @YARDS, @PAR, @TOTAL, @TOT_CNT, @SCORING_AVG
FROM (
SELECT
	'1'	AS hole_no
	,B.yards
	,B.par
	, (
		CASE
			WHEN B.par - A.hole <= -2 THEN 'eagles'
			WHEN B.par - A.hole = -1 THEN 'birdies'
			WHEN B.par - A.hole = 0 THEN 'par'
			WHEN B.par - A.hole = 1  THEN 'bogeys'
			ELSE 'dbogeys'
		END
	) total
	, ROUND((COUNT(*) * 100 / mm_cnt), 2) AS tot_cnt
	, ROUND((SELECT AVG(q.h01)
 		FROM CG_SCOR_MGT_MST Q
			JOIN CG_GRP_MST G
				ON Q.GAME_CODE = G.gm_code
				AND Q.MAN_CD = G.gm_pcode
				AND Q.TOMT_RNDG = G.gm_round
			JOIN CS_MEMB_MST MM
				ON Q.MAN_CD = MM.mm_code
			JOIN SC_NATL_MST NM
				ON MM.mm_nat = NM.nm_code
			LEFT OUTER JOIN CG_PLYR_DTL D
				ON Q.GAME_CODE = D.GAME_CODE
				AND Q.MAN_CD =D.MAN_CD
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R1T
					,GAME_CODE AS R1GCODE
					,MAN_CD AS R1MCD
					,TOMT_RNDG AS RND1
				FROM CG_SCOR_MGT_MST
			) AS Q1
				ON Q1.R1GCODE = Q.GAME_CODE
				AND Q1.R1MCD = Q.MAN_CD
				AND Q1.RND1='1'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R2T
					,GAME_CODE AS R2GCODE
					,MAN_CD AS R2MCD
					,TOMT_RNDG AS RND2
				FROM CG_SCOR_MGT_MST
			) AS Q2
				ON Q2.R2GCODE = Q.GAME_CODE
				AND Q2.R2MCD = Q.MAN_CD
				AND Q2.RND2='2'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R3T
					,GAME_CODE AS R3GCODE
					,MAN_CD AS R3MCD
					,TOMT_RNDG AS RND3
				FROM CG_SCOR_MGT_MST
			) AS Q3
				ON Q3.R3GCODE = Q.GAME_CODE
				AND Q3.R3MCD = Q.MAN_CD
				AND Q3.RND3='3'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R4T
					,GAME_CODE AS R4GCODE
					,MAN_CD AS R4MCD
					,TOMT_RNDG AS RND4
				FROM CG_SCOR_MGT_MST
			) AS Q4
				ON Q4.R4GCODE = Q.GAME_CODE
				AND Q4.R4MCD = Q.MAN_CD
				AND Q4.RND4='4'
			JOIN CG_JOIN_PLYR_LST P
				ON P.pl_code = Q.GAME_CODE
				AND Q.MAN_CD = P.pl_pcode
				AND p.pl_index = 1
		WHERE (D.GIVE_UP_YN ='2' OR D.GIVE_UP_YN  <>  '6' OR D.GIVE_UP_YN  <>  '5' OR D.GIVE_UP_YN is NULL)
			AND Q.GAME_CODE IN (
									SELECT
										gm_code
									FROM CG_GAME_MST GM
										LEFT JOIN CG_GAME_RND RND
										ON GM.gm_code = RND.gr_code
										AND gr_round = 1
										LEFT JOIN CG_COUR_DTL CD
										ON RND.cd_code = CD.cd_code
										AND RND.cd_gcode = CD.cd_gcode
									WHERE SUBSTRING(gm_code, 1, 4) = @BEF_YEAR
										AND gm_gcode = $GM_GCODE
										AND gm_ccode = $GM_CCODE
							    )
		ORDER BY mm_name
			), 3) AS scoring_avg
		FROM
			(
				SELECT
					Q.GAME_CODE
					, mm_code
					, q.h01			AS hole
					, ( SELECT
							COUNT(*)
						FROM CG_SCOR_MGT_MST SMM
							LEFT JOIN CG_JOIN_PLYR_LST JPL
						ON JPL.pl_code = SMM.game_code
						AND JPL.pl_pcode = SMM.man_cd
						WHERE  SMM.GAME_CODE IN (
													SELECT
														gm_code
													FROM CG_GAME_MST GM
														LEFT JOIN CG_GAME_RND RND
														ON GM.gm_code = RND.gr_code
														AND gr_round = 1
														LEFT JOIN CG_COUR_DTL CD
														ON GM.gm_ccode = CD.cd_code
														AND GM.gm_gcode = CD.cd_gcode

													WHERE SUBSTRING(gm_code, 1, 4) = @BEF_YEAR
														AND gm_gcode = $GM_GCODE
														AND gm_ccode = $GM_CCODE
											    )
		          ) AS mm_cnt
 		FROM CG_SCOR_MGT_MST Q
			JOIN CG_GRP_MST G
				ON Q.GAME_CODE = G.gm_code
				AND Q.MAN_CD = G.gm_pcode
				AND Q.TOMT_RNDG = G.gm_round
			JOIN CS_MEMB_MST MM
				ON Q.MAN_CD = MM.mm_code
			JOIN SC_NATL_MST NM
				ON MM.mm_nat = NM.nm_code
			LEFT OUTER JOIN CG_PLYR_DTL D
				ON Q.GAME_CODE = D.GAME_CODE
				AND Q.MAN_CD =D.MAN_CD
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R1T
					,GAME_CODE AS R1GCODE
					,MAN_CD AS R1MCD
					,TOMT_RNDG AS RND1
				FROM CG_SCOR_MGT_MST
			) AS Q1
				ON Q1.R1GCODE = Q.GAME_CODE
				AND Q1.R1MCD = Q.MAN_CD
				AND Q1.RND1='1'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R2T
					,GAME_CODE AS R2GCODE
					,MAN_CD AS R2MCD
					,TOMT_RNDG AS RND2
				FROM CG_SCOR_MGT_MST
			) AS Q2
				ON Q2.R2GCODE = Q.GAME_CODE
				AND Q2.R2MCD = Q.MAN_CD
				AND Q2.RND2='2'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R3T
					,GAME_CODE AS R3GCODE
					,MAN_CD AS R3MCD
					,TOMT_RNDG AS RND3
				FROM CG_SCOR_MGT_MST
			) AS Q3
				ON Q3.R3GCODE = Q.GAME_CODE
				AND Q3.R3MCD = Q.MAN_CD
				AND Q3.RND3='3'
			LEFT OUTER JOIN
			(
				SELECT
					TOTAL AS R4T
					,GAME_CODE AS R4GCODE
					,MAN_CD AS R4MCD
					,TOMT_RNDG AS RND4
				FROM CG_SCOR_MGT_MST
			) AS Q4
				ON Q4.R4GCODE = Q.GAME_CODE
				AND Q4.R4MCD = Q.MAN_CD
				AND Q4.RND4='4'
			JOIN CG_JOIN_PLYR_LST P
				ON P.pl_code = Q.GAME_CODE
				AND Q.MAN_CD = P.pl_pcode
				AND p.pl_index = 1
		WHERE (D.GIVE_UP_YN ='2' OR D.GIVE_UP_YN  <>  '6' OR D.GIVE_UP_YN  <>  '5' OR D.GIVE_UP_YN is NULL)
			AND Q.GAME_CODE IN (
									SELECT
										gm_code
									FROM CG_GAME_MST GM
										LEFT JOIN CG_GAME_RND RND
										ON GM.gm_code = RND.gr_code
										AND gr_round = 1
										LEFT JOIN CG_COUR_DTL CD
										ON RND.cd_code = CD.cd_code
										AND RND.cd_gcode = CD.cd_gcode
									WHERE SUBSTRING(gm_code, 1, 4) = @BEF_YEAR
										AND gm_gcode = $GM_GCODE
										AND gm_ccode = $GM_CCODE
							    )
		ORDER BY mm_name
			) A LEFT JOIN
			(
				SELECT
					gm_code
					, cd_1p			AS par
					, cd_1y			AS yards
				FROM CG_COUR_DTL
					, CG_GAME_MST
				WHERE cd_code = gm_ccode
				AND cd_gcode = gm_gcode
				AND gm_code IN (
									SELECT
										gm_code
									FROM CG_GAME_MST GM
										LEFT JOIN CG_GAME_RND RND
										ON GM.gm_code = RND.gr_code
										AND gr_round = 1
										LEFT JOIN CG_COUR_DTL CD
										ON GM.gm_ccode = CD.cd_code
										AND GM.gm_gcode = CD.cd_gcode
									WHERE SUBSTRING(gm_code, 1, 4) = @BEF_YEAR
										AND gm_gcode = $GM_GCODE
										AND gm_ccode = $GM_CCODE
							    )
			) B ON A.GAME_CODE = B.gm_code
		GROUP BY total
) T ;

INSERT INTO MAIN_TMPL_INFO (STYLE, CONTENTS)
SELECT 'K', CONCAT(@HOLE_NO,",",@YARDS,",",@PAR,",",@TOTAL,",",@TOT_CNT,",",@SCORING_AVG) AS CONTENTS;

END;
