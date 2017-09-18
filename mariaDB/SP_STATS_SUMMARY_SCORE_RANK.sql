[GM_CODE별 집계 방법]

-- 이상한 통계 내역
-- 해당 대회에 홀인원이 존재하지 않으나, 라운드 스코어 테이블에는 존재함.
-- http://www.kgt.co.kr/tournaments/sch_holediff.aspx?game_code=2016110081000
SELECT
  MM_NAME_DISPLAY, MM_CODE
FROM  CG_GAME_MST A, CG_SCOR_MGT_MST B, CG_COUR_DTL C, CS_MEMB_MST D
WHERE A.GM_CODE   = '2016110081000'
  AND A.GM_CODE    = B.GAME_CODE
  AND B.TOMT_RNDG  <=  4
  AND A.GM_GCODE   =   C.CD_GCODE
  AND A.GM_CCODE   =   C.CD_CODE
  AND B.MAN_CD = D.MM_CODE
  -- 타수가 0일때 알바트로스로집계되는것 방지 2010.12.10 -대진
  AND RNDG_END = 'F'
  AND HOLE_IN_ONE = 1
;

-- 평균타수
-- 파 수

SELECT
  SUM(B.HOLE_IN_ONE) AS SUM_HOLE_IN_ONE, -- 홀인원 수
  SUM(B.ALBATRO) AS SUM_ALBATRO, -- 알바트로스 수
  SUM(B.EAGLE) AS SUM_EAGLE, -- 이글수
  SUM(B.BIRDY) AS SUM_BIRDY, -- 버디수
  AVG(B.BIRDY) AS AVG_BIRDY, -- 평균버디수
  SUM(B.EVEN) AS SUM_EVEN, -- 이븐수
  SUM(B.BOGGY) AS SUM_BOGGY, -- 보기수
  SUM(B.D_BOGGY) AS SUM_D_BOGGY, -- 더블 보기수
  SUM(B.T_BOGGY) AS SUM_T_BOGGY -- 트리플 보기수
FROM  CG_GAME_MST A, CG_SCOR_MGT_MST B, CG_COUR_DTL C
WHERE A.GM_CODE = '2016110081000'
  AND A.GM_CODE = B.GAME_CODE
  AND B.TOMT_RNDG <= 4
  AND A.GM_GCODE = C.CD_GCODE
  AND A.GM_CCODE = C.CD_CODE
  -- 타수가 0일때 알바트로스로집계되는것 방지 2010.12.10 -대진
  AND B.RNDG_END = 'F'
;

-- 연속 버디 수
-- 연속 파수
-- 연속 노보기 수

-- 9홀 최저타수
-- 18홀 최저타수
-- 36홀 최저타수
-- 54홀 최저타수
-- 72홀 최저타수
-- 72홀 최저언더파

-- 연속 2개 라운드 최저타수
-- 연속 3개 라운드 최저타수

-- 역대 컷오프 최저타수
