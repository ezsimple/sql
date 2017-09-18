CREATE VIEW  vw_stats_leaders_point AS
select cast(a.pp_rank as signed) AS pp_rank,
a.pp_index AS pp_index,
a.pp_tcode AS pp_tcode,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.pp_year AS pp_year,
b.mm_code AS mm_code,
cast(round(a.pp_point,0) as signed) AS point,
a.pp_season AS pp_season,
cast(c.pc_gmcnt as signed) AS pc_gmcnt
from (
  (cg_pltr_point a join cs_memb_mst b on(a.pp_pcode = b.mm_code)) 
  left join cg_priz_rank_gmcnt c on(a.pp_pcode = c.pc_pcode and a.pp_year = c.pc_year and a.pp_tcode = c.pc_tcode)
)
order by cast(a.pp_rank as signed),c.pc_gmcnt,b.mm_name_display;


CREATE VIEW  vw_stats_leaders_prize AS
select cast(a.pr_rank as signed) AS pr_rank,
b.mm_code AS mm_code,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.pr_prize AS pr_prize,
cast(c.pc_gmcnt as signed) AS pc_gmcnt,
a.pr_year AS pr_year,
a.pr_tcode AS pr_tcode,
b.mm_div AS mm_div
from (
  (cg_priz_rank a join cs_memb_mst b on(a.pr_pcode = b.mm_code))
  left join cg_priz_rank_gmcnt c on(a.pr_pcode = c.pc_pcode and a.pr_year = c.pc_year and a.pr_tcode = c.pc_tcode)
)
order by cast(a.pr_rank as signed),cast(c.pc_gmcnt as signed),b.mm_name_display;


CREATE VIEW  vw_stats_leaders_common AS
select cast(a.ry_rank as signed) AS ry_rank,
b.mm_code AS mm_code,
b.mm_name_display AS mm_name_display,
concat(b.mm_mname,' ',b.mm_lname,' ',b.mm_fname) AS e_mm_name_display,
a.ry_point AS ry_point,
cast(c.pc_gmcnt as signed) AS pc_gmcnt,
a.ry_year AS ry_year,
a.ry_tcode AS ry_tcode,
a.ry_div AS ry_div,
a.ry_pcode AS ry_pcode from (
  (dr_rcod_year a join cs_memb_mst b on(a.ry_pcode = b.mm_code))
  left join cg_priz_rank_gmcnt c on(a.ry_pcode = c.pc_pcode and a.ry_year = c.pc_year and a.ry_tcode = c.pc_tcode)
) where a.ry_rank > 0 order by a.ry_rank,a.ry_hole,b.mm_name_display;
