-- 최적화 필요
SELECT
			BR_TOURNAMENT,
			BR_NETWORKS,
			BR_DATE,
			BR_TIME,
			BR_NAME,
			BR_PART
		FROM
			T_H_BROADCASTING
		WHERE
			BR_TOURNAMENT = '2016110059010'
		ORDER BY 
			BR_DATE,	 BR_ROUND,	 BR_TIME;

-- 최적화 필요
SELECT
			g.gm_scode,
			g.gm_name,
			DATE_FORMAT(g.gm_sdate,'%Y-%m-%d') as gm_sdate,
			SUBSTRING(DATE_FORMAT(g.gm_fdate, '%Y-%m-%d'),6,5) as gm_fdate,
			c.cm_name,
			c.cm_nx,
  			c.cm_ny,
  			a.FILE_PATH,
  			a.SAVE_FILE_NM
		FROM
			cg_game_mst g
		LEFT JOIN
			cg_cour_mst c
		ON
			g.gm_gcode = c.cm_code
		LEFT JOIN
			game_mng_att a
		ON
			g.gm_code = a.gm_code AND loc_gbn = 'gameMain' AND att_no = '1'
		WHERE
		 	g.gm_code= '2016110059010';


      SELECT
      			man_cd,rank,
      			m.mm_name_display,
      		 	IFNULL(m.mm_hght,'') AS mm_hght,
      	        IFNULL(m.mm_weig,'') AS mm_weig ,
      	        TRIM(CONCAT(m.mm_mname, m.mm_lname, ' ', m.mm_fname)) AS eng_name,
      	        CONCAT(SUBSTRING(m.mm_bdate,1,4) ,'년 ', SUBSTRING(m.mm_bdate,5,2), '월 ', SUBSTRING(m.mm_bdate,7,2), '일') AS mm_bdate,
                  m.mm_posname,
                  m.mm_poscon,
                  IFNULL(
       (select save_file_nm
       from kg_player_img p
       where t.man_cd = p.mm_code
       and img_type='01'),'') AS save_file_nm,

      			IFNULL(
       (select rg_point
       from dr_rcod_game
      			where rg_code=t.game_code
       and rg_pcode = t.man_cd
       and rg_div = '01'),'0') as avgPar,

      			IFNULL(
       (select sum(birdy)
       from cg_scor_mgt_mst
      			where game_code=t.game_code
       and man_cd = t.man_cd),0) as birdy,

      			IFNULL(
       (select rg_point
       from dr_rcod_game
       where rg_code=t.game_code
      			and rg_pcode = t.man_cd
       and rg_div ='03'),'0') as avgPutting,

      			IFNULL(
       (select rg_point
       from dr_rcod_game
       where rg_code=t.game_code
      			and rg_pcode = t.man_cd
       and rg_div='15'),'0') as fairway,

      			IFNULL(
       (select rg_point
       from dr_rcod_game
       where rg_code=t.game_code
      			and rg_pcode = t.man_cd
       and rg_div='14'),'0') as driveDistance,

      			IFNULL(
       (select rg_point
       from dr_rcod_game
       where rg_code=t.game_code
      			and rg_pcode = t.man_cd
       and rg_div='02'),'0')  as greenMark
      		FROM
      			CG_TOMT_RCOD_DTL t
      		LEFT JOIN
      			cs_memb_mst m
      		ON t.man_cd = m.mm_code
              WHERE
              	game_code = '2016110059010'
              GROUP BY
              	man_cd
      		ORDER BY
      			CAST(rank as int)
      		LIMIT 3;

-- 최적화 필요 (심각)
SELECT
				gm_code,
				gm_name,
				gm_sdate,
				gm_fdate
			FROM
				cg_game_mst

			WHERE
				DATE_FORMAT(gm_sdate,'%Y%m%d') <= DATE_FORMAT(now(),'%Y%m%d')
			AND
				DATE_FORMAT(now(),'%Y%m%d') <= DATE_FORMAT(gm_fdate,'%Y%m%d')


			AND
				gm_tcode ='11'
			AND
				gm_class = 'main'
			ORDER BY
				gm_sdate
			LIMIT 1;

-- 최적화 필요
SELECT gm_code, gm_scode, gm_tcode, null as trank,null as accu_rank,gm_name, null, null as tcode
		,gm_round as trnd, 0 as tunder,cd_tin+cd_tout as tpar,
		cd_1p, cd_2p,cd_3p, cd_4p, cd_5p, cd_6p, cd_7p, cd_8p, cd_9p, cd_tout,
		cd_10p, cd_11p, cd_12p, cd_13p, cd_14p, cd_15p, cd_16p, cd_17p, cd_18p,
		cd_tin , cd_tin+cd_tout as htot, null as tna,null as tnaname,
		null, null, null,null,null,null,null ,'''','''','''', 0, ''''
		FROM
		CG_COUR_DTL, CG_GAME_MST
		WHERE cd_code=gm_ccode
 and cd_gcode=gm_gcode
 and gm_code='2017110001040';


 -- 최적화 필요 (심각)
 SELECT
			t.CreatedDate, t.PostId, t.BoardCategoryId, t.Title, t.VirtualName, t.filePath
		FROM
			(SELECT
				b.CreatedDate, b.PostId, b.BoardCategoryId,
				 substring_index(b.Title,'/','1') as Title, f.VirtualName, f.filePath
				FROM
					boardbase b
				LEFT JOIN
				 	boardfile f
				ON
					b.thumId = f.BoardFileId AND f.IsDeleted = 0
			WHERE
				b.BoardCategoryId='1848AFD5-3961-4E16-AC4C-A559D1B5ABF6'
		UNION
			SELECT
				b.CreatedDate, b.PostId, b.BoardCategoryId, b.Title, f.VirtualName, f.filePath
			FROM
				boardbase b
			LEFT JOIN
			 	boardfile f
			ON
				b.thumId = f.BoardFileId AND f.IsDeleted = 0
			WHERE
				b.BoardCategoryId='F4B178E2-018A-4FE3-B1C6-C10FBEDB64A4'
		UNION
			SELECT
			P_CRAT_DATE AS CreatedDate, P_SEQR as PostId, '' AS BoardCategoryId, P_title AS Title,
			 P_SMALL_IMG AS VirtualName, 'photo' AS filePath
		FROM
			t_h_photo
		) t
		ORDER BY
			CreatedDate DESC
		LIMIT 6;


 -- 최적화 필요 (심각)
    SELECT SQL_CALC_FOUND_ROWS
    			P_SEQR,
    			P_YEAR,
    			P_SEQ,
    			P_TITLE,
    			P_CONTENT,
    			P_SMALL_IMG,
    			P_BIG_IMG,
    			P_SMALL_WIDTH,
    			P_SMALL_HEIGHT,
    			P_BIG_WIDTH,
    			P_BIG_HEIGHT,
    			DATE_FORMAT(P_CRAT_DATE, '%Y-%m-%d') AS P_CRAT_DATE,
    			file_path
    		FROM
    			t_h_photo
    		WHERE
    			P_ISDEL =0
    		ORDER BY
    			P_CRAT_DATE DESC
    		LIMIT
  			7 OFFSET 0;

-- 최적화 필요 (심각)
SELECT
			(SELECT COUNT(*) FROM CG_GAME_MST WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN gm_sdate AND gm_fdate AND gm_tcode = '11'
				AND gm_class='main') AS now_cnt
			, (SELECT COUNT(*) FROM CG_GAME_MST WHERE DATE_FORMAT(NOW(), '%Y%m%d')  <  gm_sdate AND gm_tcode = '11'
				AND gm_class='main') AS aft_cnt
		FROM DUAL;


-- 최적화 필요
    SELECT
    			gm_scode,
    			gm_code,
    			gm_name,
    			gm_sdate,
    			gm_fdate,

    				'THIS WEEK' AS game_state


    		FROM
    			CG_GAME_MST
    		WHERE
    			gm_tcode = '11'
    		AND
    			gm_class = 'main'
    		AND


    				DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN gm_sdate AND gm_fdate
    				ORDER BY gm_fdate


    		LIMIT 1

-- 추출할 데이타 없음 : Impossible WHERE noticed after reading const tables
SELECT
			CAST(hole_num AS int) AS hole_num
			, org_file_nm
			, save_file_nm
				FROM
					CG_GAME_MST GM
				LEFT JOIN
					CG_COUR_IMG CI
				ON
					CI.cd_gcode = GM.gm_gcode
				AND
					CI.cd_code = GM.gm_ccode
				WHERE
					GM.gm_code = '2017110001040'


		AND
			hole_num != '00'
		ORDER BY
			CI.hole_num;


-- 최적화 필요
SELECT
			'1'		AS hole_no
			, B.yards
			, B.par
			, (
				CASE
					WHEN B.par - A.hole  <=  -2 THEN 'eagles'
					WHEN B.par - A.hole = -1 THEN 'birdies'
					WHEN B.par - A.hole = 0 THEN 'par'
					WHEN B.par - A.hole = 1  THEN 'bogeys'
					ELSE 'dbogeys'
				END
			) total
			, ROUND((COUNT(*) * 100 / mm_cnt), 2) AS tot_cnt
			, ROUND((
				SELECT

					AVG(q.h01)


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
										LEFT JOIN CG_COUR_DTL CD
										ON GM.gm_ccode = CD.cd_code
										AND GM.gm_gcode = CD.cd_gcode

									WHERE SUBSTRING(gm_code, 1, 4) = '2015'
										AND gm_gcode =

				(SELECT gm_gcode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


										AND gm_ccode =

				(SELECT gm_ccode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


							    )
		ORDER BY mm_name

			), 3) AS scoring_avg
		FROM
			(
				SELECT
					Q.GAME_CODE
					, mm_code

					, q.h01			AS hole

					, (
						SELECT
							COUNT(*)
						FROM CG_SCOR_MGT_MST SMM
							LEFT JOIN CG_JOIN_PLYR_LST JPL
						ON JPL.pl_code = SMM.game_code
						AND JPL.pl_pcode = SMM.man_cd
						WHERE  SMM.GAME_CODE IN (
													SELECT
														gm_code
													FROM CG_GAME_MST GM
														LEFT JOIN CG_COUR_DTL CD
														ON GM.gm_ccode = CD.cd_code
														AND GM.gm_gcode = CD.cd_gcode

													WHERE SUBSTRING(gm_code, 1, 4) = '2015'
														AND gm_gcode =

				(SELECT gm_gcode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


														AND gm_ccode =

				(SELECT gm_ccode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


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
										LEFT JOIN CG_COUR_DTL CD
										ON GM.gm_ccode = CD.cd_code
										AND GM.gm_gcode = CD.cd_gcode

									WHERE SUBSTRING(gm_code, 1, 4) = '2015'
										AND gm_gcode =

				(SELECT gm_gcode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


										AND gm_ccode =

				(SELECT gm_ccode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


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
										LEFT JOIN CG_COUR_DTL CD
										ON GM.gm_ccode = CD.cd_code
										AND GM.gm_gcode = CD.cd_gcode

									WHERE SUBSTRING(gm_code, 1, 4) = '2015'
										AND gm_gcode =

				(SELECT gm_gcode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


										AND gm_ccode =

				(SELECT gm_ccode FROM CG_GAME_MST WHERE gm_code = '2017110001040')


							    )
			) B ON A.GAME_CODE = B.gm_code
		GROUP BY total;


--최적화 필요
SELECT
			g.gm_scode,
			g.gm_name,
			DATE_FORMAT(g.gm_sdate,'%Y-%m-%d') as gm_sdate,
			SUBSTRING(DATE_FORMAT(g.gm_fdate, '%Y-%m-%d'),6,5) as gm_fdate,
			c.cm_name,
			c.cm_nx,
  			c.cm_ny,
  			a.FILE_PATH,
  			a.SAVE_FILE_NM
		FROM
			cg_game_mst g
		LEFT JOIN
			cg_cour_mst c
		ON
			g.gm_gcode = c.cm_code
		LEFT JOIN
			game_mng_att a
		ON
			g.gm_code = a.gm_code AND loc_gbn = 'gameMain' AND att_no = '1'
		WHERE
		 	g.gm_code= '2017110001040';


-- 최적화 필요
SELECT
			'평균타수' avgStrokeTitle,
			pp_year,
			pp_tcode,
			pp_pcode,
			mm_name_display,
			mm_sns_naverblog,
			mm_sns_facebook,
			mm_sns_instagram,
			mm_sns_band,
			pp_rank,
			ry_rank,
			pp_point,
			ry_div,
			round(max(fairway),2) fairway, max(fairwayRank) fairwayRank, round(max(green),2) green, max(greenRank) greenRank,
			round(max(avgPutting),2) avgPutting, max(avgPuttingRank) avgPuttingRank,
			round(max(driveDistance),2) driveDistance, max(driveDistanceRank) driveDistanceRank,
			round(max(avgStroke),2) avgStroke, max(avgStrokeRank) avgStrokeRank,

 (select save_file_nm
 from kg_player_img
 where pp_pcode = mm_code
 and img_type='00') AS save_file_nm

		 FROM (
			SELECT
				pp_year, pp_tcode, pp_pcode, pp_rank, ry_rank, pp_point, ry_div,mm_name_display,
				mm_sns_naverblog, mm_sns_facebook, mm_sns_instagram, mm_sns_band,

				if(ry_div=15,ry_point,0) fairway, if(ry_div=02,ry_point,0) green, if(ry_div=03,ry_point,0) avgPutting,
				if(ry_div=14,ry_point,0) driveDistance, if(ry_div=01,ry_point,0) avgStroke,

				if(ry_div=15,ry_rank,0) fairwayRank, if(ry_div=02,ry_rank,0) greenRank, if(ry_div=03,ry_rank,0) avgPuttingRank,
				if(ry_div=14,ry_rank,0) driveDistanceRank, if(ry_div=01,ry_rank,0) avgStrokeRank

			FROM
				cg_pltr_point p INNER JOIN DR_RCOD_YEAR y
			ON
				pp_pcode = ry_pcode
			INNER JOIN
				cs_memb_mst ON pp_pcode=mm_code
			AND
				ry_year = '2016'
			AND
				ry_tcode = '11'
		) t

		WHERE
			pp_year = '2016'
		AND
			pp_tcode = '11'
		GROUP BY
			pp_pcode
		ORDER BY
			pp_point DESC
		limit 5;

-- 최적화 필요
SELECT
			count(*) AS cnt
 		FROM
 			cg_research_mng
		WHERE
			RESEARCH_GBN = '0002'
		AND

		DATE_FORMAT(CONCAT(research_strdate, research_strtime,'00'),'%Y%m%d%H%i%s') <= DATE_FORMAT(now(),'%Y%m%d%H%i%s')
		AND DATE_FORMAT(CONCAT(research_enddate,research_endtime,'00'),'%Y%m%d%H%i%s') >= DATE_FORMAT(now(),'%Y%m%d%H%i%s');


-- 최적화 필요 (심각)
SELECT  va.*
		FROM    (
		        SELECT code_group,code_id,code_name,code_value,use_yn,order_no,uid
		        FROM sys_code c

		        UNION
		        SELECT 'root' code_group, 'roles' role_id, '권한정보' role_nm,'' note,'Y' use_yn, 1, 'roles_groups' uid
		        UNION
		        SELECT 'roles' code_group, role_id,role_nm,note,use_yn, 1, role_id uid
		        FROM sys_roles

		        UNION
		        SELECT 'root' code_group, 'cont_types' code_id, '콘텐츠유형' code_name, '' note, 'Y' use_yn, 1, 'cont_types' uid
		        UNION
		        SELECT 'cont_types' code_group, cont_type,cont_type_name,cont_type_name,'Y' use_yn, 1, cont_type uid
		        FROM sys_content_def

		        UNION
		        SELECT 'root' code_group, 'cont_type' code_id, '콘텐츠유형' code_name, '' note, 'Y' use_yn, 1, 'cont_type' uid
		        UNION
		        SELECT 'cont_type' code_group, cont_type,cont_type_name,cont_type_name,'Y' use_yn, 1, cont_type uid
		        FROM sys_content_def

		        UNION
		        SELECT 'root' code_group, 'net_interface_id' code_id, '연동모듈' code_name, '' note, 'Y' use_yn, 1, 'cont_type' uid
		        UNION
		        SELECT 'net_interface_id' code_group, net_interface_id,net_interface_name,net_interface_name,'Y' use_yn, 1, net_interface_id uid
		        FROM sys_net_interface

		        UNION
		        SELECT 'root' code_group, 'gl_code' code_id, '투어' code_name, '' note, 'Y' use_yn, 1, 'gl_code' uid
		        UNION
		        SELECT 'gl_code' code_group, gl_code,gl_name,gl_code,'Y' use_yn, gl_code, gl_code uid
		        FROM cg_game_lst

		        UNION
		        SELECT 'root' code_group, 'year' code_id, '연도' code_name, '' note, 'Y' use_yn, 1, 'year' uid
		        UNION
		        SELECT 'year' yea , year(now()) code_id, year(now()) code_name, '1','Y' use_yn, 9999 - year(now()), '1' uid
		        UNION
		        SELECT 'year' code_group, substr(gm_sdate, 1, 4) code_id, substr(gm_sdate, 1, 4) code_name, '1','Y' use_yn, 9999 - substr(gm_sdate, 1, 4), '1' uid
		        FROM cg_game_mst
		        WHERE gm_sdate is not null
		        GROUP BY substr(gm_sdate, 1, 4)

		        UNION
		        SELECT 'root' code_group, 'country' code_id, '국가' code_name, '' note, 'Y' use_yn, 1, 'gl_code' uid
		        UNION
		        SELECT 'country' code_group, nm_code, nm_fname, nm_sname ,'Y' use_yn, nm_code, nm_code uid
		        FROM sc_natl_mst

		        UNION
		        SELECT 'root' code_group, 'sm_code' code_id, '지역' code_name, '' note, 'Y' use_yn, 1, 'gl_code' uid
		        UNION
		        SELECT 'sm_code' code_group, sm_code, sm_name, '' ,'Y' use_yn, sm_code, sm_code uid
		        FROM sc_sub_mst

		        UNION
		        SELECT 'root' code_group, 'cm_code' code_id, '업종' code_name, '' note, 'Y' use_yn, 1, 'gl_code' uid
		        UNION
		        SELECT 'cm_code' code_group, cm_code, cm_name, '' ,'Y' use_yn, cm_name, cm_name uid
		        FROM sc_copny_mst

		        ORDER BY code_group, order_no
		        ) va
		WHERE   va.code_group =	'region'
		AND     va.use_yn = 'Y';
