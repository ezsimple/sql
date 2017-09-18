CREATE VIEW  vw_stats_leaders_prize AS
select cast(a.pr_rank as signed) AS pr_rank,
b.mm_code AS mm_code,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.pr_prize AS pr_prize,
cast(c.pc_gmcnt as signed) AS pc_gmcnt,
a.pr_year AS pr_year,
a.pr_tcode AS pr_tcode ,
b.mm_div
from ((cg_priz_rank a join cs_memb_mst b on(a.pr_pcode = b.mm_code))
left join cg_priz_rank_gmcnt c on(a.pr_pcode = c.pc_pcode and a.pr_year = c.pc_year and a.pr_tcode = c.pc_tcode))
order by cast(a.pr_rank as signed),cast(c.pc_gmcnt as signed),b.mm_name_display;

CREATE VIEW  vw_stats_leaders_point AS
select cast(a.pp_rank as signed) AS pp_rank,
a.pp_index AS pp_index,
a.pp_tcode AS pp_tcode,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.pp_year AS pp_year,
b.mm_code AS mm_code,
cast(round(a.pp_point,0) as signed) AS point,
a.pp_season AS pp_season,cast(c.pc_gmcnt as signed) AS pc_gmcnt
from ((cg_pltr_point a join cs_memb_mst b on(a.pp_pcode = b.mm_code))
left join cg_priz_rank_gmcnt c on(a.pp_pcode = c.pc_pcode and a.pp_year = c.pc_year and a.pp_tcode = c.pc_tcode))
order by cast(a.pp_rank as signed),c.pc_gmcnt,b.mm_name_display;

CREATE VIEW  vw_stats_leaders_common AS
select cast(a.ry_rank as signed) AS ry_rank,
b.mm_code AS mm_code,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.ry_point AS ry_point,
cast(c.pc_gmcnt as signed) AS pc_gmcnt,
a.ry_year AS ry_year,a.ry_tcode AS ry_tcode,
a.ry_div AS ry_div,a.ry_pcode AS ry_pcode
from ((dr_rcod_year a join cs_memb_mst b on(a.ry_pcode = b.mm_code))
left join cg_priz_rank_gmcnt c on(a.ry_pcode = c.pc_pcode and a.ry_year = c.pc_year and a.ry_tcode = c.pc_tcode))
where a.ry_rank > 0 order by a.ry_rank,a.ry_hole,b.mm_name_display;

-- 비회원 상금랭킹
SELECT RANK() OVER (ORDER BY PR_PRIZE DESC) RANK,
MM_CODE, MM_NAME_DISPLAY, E_MM_NAME_DISPLAY, PR_PRIZE, PC_GMCNT
FROM VW_STATS_LEADERS_PRIZE
WHERE 1=1 AND MM_DIV = '1' AND PR_YEAR = '2016' AND PR_TCODE = '11'


-- 비공식 대회 참석 인원
SELECT DISTINCT MAN_CD AS MM_CODE
FROM CG_GAME_MST A1, CG_PLYR_DTL B1
WHERE 1=1
AND GM_MENT IN ('21','22')
AND A1.GM_CODE = B1.GAME_CODE;


-- 비공식 대회 참석자의 상금내역
SELECT * FROM
CG_PRIZ_RANK AA1,
(SELECT DISTINCT MAN_CD AS MM_CODE
FROM CG_GAME_MST A1, CG_PLYR_DTL B1
WHERE 1=1
AND GM_MENT IN ('21','22')
AND A1.GM_CODE = B1.GAME_CODE) BB1
WHERE 1=1
AND AA1.PR_PCODE = BB1.MM_CODE
AND AA1.PR_TCODE = '11'
AND AA1.PR_YEAR = '2016'


-- 비공식 대회 상금내역
-- cg_priz_rank_gmcnt 의 데이터는 공식대회 집계만 존재합니다.
SELECT RANK() OVER (ORDER BY T2.PP_PRIZE DESC) AS RANK,
T1.GM_CODE, T1.MM_CODE, T1.MM_NAME_DISPLAY, T1.E_MM_NAME_DISPLAY, T2.PP_PRIZE
FROM
(SELECT
    A1.GM_CODE,
    B1.MAN_CD AS MM_CODE,
    C1.MM_NAME_DISPLAY,
    CONCAT(C1.MM_MNAME,' ',C1.MM_LNAME,' ',C1.MM_FNAME) AS E_MM_NAME_DISPLAY
    FROM CG_GAME_MST A1, CG_PLYR_DTL B1
    LEFT JOIN CS_MEMB_MST C1 ON B1.MAN_CD = C1.MM_CODE
    WHERE 1=1
    AND A1.GM_MENT IN ('21','22')
    AND A1.GM_CODE = B1.GAME_CODE
    AND SUBSTRING(A1.GM_CODE,1,4) = '2009'
    AND SUBSTRING(A1.GM_CODE,5,2) = '11'
) T1
LEFT JOIN CG_PLAYER_PRIZ T2 ON (T1.MM_CODE = T2.PP_PCODE AND T1.GM_CODE = T2.PP_CODE)
WHERE T2.PP_PRIZE != ''
ORDER BY T2.PP_PRIZE DESC
