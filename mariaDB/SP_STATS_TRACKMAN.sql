-- 클럽헤드 스피드 Club Speed    tr_club_speed
-- 볼스피드      Ball Speed    tr_ball_speen
-- 스매시팩터     Smash Factor  tr_smash_factor
-- 런치앵글      Vert Angle    tr_vert_angle
-- 스핀량       Spin Rate     tr_spin_rate
-- 정점거리    -
-- 정점높이  Max Height tr_max_height
-- 체공시간  Flight Time tr_cf_flight_time
-- 캐리거리  Length
-- 캐리효율성 -
-- 거리효율성 -
-- total driving efficiency -

-- 1. 선수코드용 CURSOR를 구한다.
select distinct man_cd from trackman where man_cd is not null

-- 2. 집계용 임시 테이블을 생성한다.
create temporary table _tmp_trackman();


-- 3. 선수별 평균 집계값을 구하여, 임시테이블에 입력한다.
while :
  insert into _tmp (mm_code, mm_name_display, e_mm_name_display,
    avg_club_speed, avg_ball_speed, avg_smash_factor, avg_vert_angle,
    avg_spin_rate, avg_max_height, avg_flight_time, pc_gmcnt
  )
  select man_cd as mm_code,
    mm_name_display,
    concat(b.mm_mname," ",b.mm_lname," ",b.mm_fname) as e_mm_name_display,
    avg(tr_club_speed) as avg_club_speed,
    avg(tr_ball_speed) as avg_ball_speed,
    avg(tr_smash_factor) as avg_smash_factor,
    avg(tr_vert_angle) as avg_vert_angle,
    avg(tr_spin_rate) as avg_spin_rate,
    avg(tr_max_height) as avg_max_height,
    avg(tr_cf_flight_time) as avg_flight_time,
    cast(c.pc_gmcnt as signed) as pc_gmcnt
  from
  trackman a
  left join cs_memb_mst b on (man_cd = mm_code)
  left join cg_priz_rank_gmcnt c on (man_cd = c.pc_pcode and substring(a.game_code,1,4) = c.pc_year and substring(a.game_code,5,2) = c.pc_tcode)
  where
  man_cd = '00000138';

-- 4. 입시 테이블의 각 평균항목에 대한 랭킹값을 임시테이블에 다시 저장한다.
update
select mm_code, rank() over(order by avg_tr_club_speed) as rank_club_speed
from _tmp_trackman; -- _tmp 테이블의 mm_code 는 PK 이어야 한다.

-- 5. 전체 테이블의 내용을 반환한다.
select * from _tmp_trackman;
