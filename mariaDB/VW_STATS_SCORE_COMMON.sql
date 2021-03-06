CREATE ALGORITHM=MERGE VIEW VW_STATS_SCORE_COMMON AS
SELECT
A.H01,A.H02,A.H03,A.H04,A.H05,A.H06,A.H07,A.H08,A.H09,
A.H10,A.H11,A.H12,A.H13,A.H14,A.H15,A.H16,A.H17,A.H18,
A.TOMT_RNGD, A.MAN_CD,
B.MM_NAME_DISPLAY, CONCAT(B.MM_MNAME,' ',B.MM_LNAME,' ',B.MM_FNAME) AS E_MM_NAME_DISPLAY
FROM CG_SCOR_MGT_MST A ,CS_MEMB_MST B, CG_PLYR_DTL C
WHERE A.GAME_CODE = B.GM_CODE
AND A.GAME_CODE = C.GAME_CODE
AND A.MAN_CD = B.MM_CODE
AND A.MAN_CD = C.MAN_CD
AND C.GIVE_UP_YN = "2";


CREATE ALGORITHM=MERGE VIEW VW_STATS_SCORE_COMMON AS
SELECT A.GM_CODE, B.TOMT_RNDG, B.MAN_CD,
C.CD_1P, C.CD_2P, C.CD_3P, C.CD_4P, C.CD_5P, C.CD_6P, C.CD_7P, C.CD_8P, C.CD_9P,
C.CD_10P, C.CD_11P, C.CD_12P, C.CD_13P, C.CD_14P, C.CD_15P, C.CD_16P, C.CD_17P, C.CD_18P,
B.H01, B.H02, B.H03, B.H04, B.H05, B.H06, B.H07, B.H08, B.H09,
B.H10, B.H11, B.H12, B.H13, B.H14, B.H15, B.H16, B.H17, B.H18,
B.ACCU_TOTAL, B.ACCU_UNDER, B.ACCU_HTOT, B.STD_HIT_NO,
E.MM_NAME_DISPLAY, CONCAT(E.MM_MNAME,' ',E.MM_LNAME,' ',E.MM_FNAME) AS E_MM_NAME_DISPLAY
FROM  CG_GAME_MST A,  CG_SCOR_MGT_MST B,  CG_COUR_DTL C ,  CG_PLYR_DTL D
LEFT JOIN CS_MEMB_MST E ON (MAN_CD = E.MM_CODE)
WHERE A.GM_CODE = B.GAME_CODE
AND A.GM_GCODE = C.CD_GCODE
AND A.GM_CCODE = C.CD_CODE
AND D.GAME_CODE = B.GAME_CODE
AND D.GIVE_UP_YN = "2"
AND D.MAN_CD = B.MAN_CD
AND B.RNDG_END = 'F';

VW_STATS_SCORE_COMMON GM_CODE TOMT_RNDG
