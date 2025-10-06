--liquibase formatted sql
--changeset amonopoli:202503211216_2 runOnChange:true stripComments:false
create or replace package body ISTED7B is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number) is
/******************************************************************************
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    29/07/2003 __     Prima emissione. Da conversione
******************************************************************************/
p_prenotazione number;
p_passo        number;
P_pagina       number :=1;
P_riga         number :=0;
cursor sel_dati is
select 1,
       'MESE_DI_RIFERIMENTO'||';'||
       'ANNO_DI_RIFERIMENTO'||';'||
       'POP_RESIDENTE_INIZIO_MESE_M'||';'||
       'POP_RESIDENTE_INIZIO_MESE_F'||';'||
       'NATI_VIVI_NEL_COMUNE_M'||';'||
       'NATI_VIVI_NEL_COMUNE_F'||';'||
       'NATI_VIVI_ALTRO_COMUNE_M'||';'||
       'NATI_VIVI_ALTRO_COMUNE_F'||';'||
       'NATI_VIVI_ESTERO_M'||';'||
       'NATI_VIVI_ESTERO_F'||';'||
       'MORTI_NEL_COMUNE_M'||';'||
       'MORTI_NEL_COMUNE_F'||';'||
       'MORTI_IN_ALTRO_COMUNE_M'||';'||
       'MORTI_IN_ALTRO_COMUNE_F'||';'||
       'MORTI_ESTERO_M'||';'||
       'MORTI_ESTERO_F'||';'||
       'ISCRITTI_DA_ALTRO_COMUNE_M'||';'||
       'ISCRITTI_DA_ALTRO_COMUNE_F'||';'||
       'ISCRITTI_DA_ESTERO_M'||';'||
       'ISCRITTI_DA_ESTERO_F'||';'||
       'ISCRITTI_PER_ALTRO_MOTIVO_M'||';'||
       'ISCRITTI_PER_ALTRO_MOTIVO_F'||';'||
       'CANCELLATI_PER_ALTRO_COMUNE_M'||';'||
       'CANCELLATI_PER_ALTRO_COMUNE_F'||';'||
       'CANCELLATI_PER_ESTERO_M'||';'||
       'CANCELLATI_PER_ESTERO_F'||';'||
       'CANCELLATI_PER_ALTRO_MOTIVO_M'||';'||
       'CANCELLATI_PER_ALTRO_MOTIVO_F'||';'||
       'UNITA_VARIAZ_TERR_M'||';'||
       'UNITA_VARIAZ_TERR_F'||';'||
       'RES_IN_FAMIGLIA_FINE_MESE_M'||';'||
       'RES_IN_FAMIGLIA_FINE_MESE_F'||';'||
       'RES_IN_CONVIVENZA_FINE_MESE_M'||';'||
       'RES_IN_CONVIVENZA_FINE_MESE_F'||';'||
       'NR_MODELLI_TRASMESSI_MESE'||';'||
       'NR_PERSONE_TRASMESSI_MESE'||';'||
       'NR_MODELLI_AP6_FAMIGLIE_ANAG'||';'||
       'NR_MODELLI_AP6_CONVIVENZE' riga
  from dual
UNION
select 2,
--  3 - numero mese
       ltrim(to_char(to_date(substr(parametri,1,7),'j'),'mm'),'0')||';'|| --   n3,
--  2 - anno di riferimento
       to_char(to_date(substr(parametri,1,7),'j'),'yyyy')||';'|| --  n2,
--  6 - residenti maschi inizio mese
       to_char((decode(nvl(substr(parametri,8,6),0),0,
      resid_m-nvl(mov_1_m,0)+nvl(mov_2_3_m,0),
                 nvl(substr(parametri,8,6),0))))||';'|| -- n6,
--  7 - residenti femmine inizio mese
       to_char((decode(nvl(substr(parametri,14,6),0),0,
      resid_f-nvl(mov_1_f,0)+nvl(mov_2_3_f,0),
                 nvl(substr(parametri,14,6),0))))||';'|| --   n7,
--  8 - nati nel comune maschi
       to_char(nvl(nati_or_m,0))||';'|| --  n8,
--  9 - nati nel comune femmine
       to_char(nvl(nati_or_f,0))||';'|| --  n9,
-- 10 - nati in altro comune maschi
       to_char(nvl(nati_tr_m,0))||';'|| --  n10,
-- 11 - nati in altro comune femmine
       to_char(nvl(nati_tr_f,0))||';'|| --   n11,
-- 12 - nati all'estero maschi
       to_char(nvl(nati_est_m,0))||';'|| --  n12,
-- 13 - nati all'estero femmine
       to_char(nvl(nati_est_f,0))||';'|| --   n13,
-- 14 - morti nel comune maschi
       to_char(nvl(morti_or_m,0))||';'|| --   n14,
-- 15 - morti nel comune femmine
       to_char(nvl(morti_or_f,0))||';'|| --  n15,
-- 16 - morti in altro comune maschi
       to_char(nvl(morti_tr_m,0))||';'|| --   n16,
-- 17 - morti in altro comune femmine
       to_char(nvl(morti_tr_f,0))||';'|| --   n17,
-- 18 - morti all'estero maschi
       to_char(nvl(morti_est_m,0))||';'|| --   n18,
-- 19 - morti all'estero femmine
       to_char(nvl(morti_est_f,0))||';'|| --  n19,
-- 22 - iscritti da altro comune maschi
       to_char(nvl(iscr_m,0))||';'|| --   n22,
-- 23 - iscritti da altro comune femmine
       to_char(nvl(iscr_f,0))||';'|| --   n23,
-- 24 - iscritti dall'estero maschi
       to_char(nvl(iscr_est_m,0))||';'|| --   n24,
-- 25 - iscritti dall'estero femmine
       to_char(nvl(iscr_est_f,0))||';'|| --   n25,
-- 26 - iscritti per altri motivi maschi
       to_char(nvl(iscr_altri_m,0)+nvl(to_number(ltrim(substr(parametri,57,6),'0')),0))||';'|| --   n26,
-- 27 - iscritti per altri motivi femmine
       to_char(nvl(iscr_altri_f,0)+nvl(to_number(ltrim(substr(parametri,63,6),'0')),0))||';'|| --   n27,
-- 28 - cancellati da altro comune maschi
       to_char(nvl(canc_m,0))||';'|| --   n28,
-- 29 - cancellati da altro comune femmine
       to_char(nvl(canc_f,0))||';'|| --   n29,
-- 30 - cancellati dall'estero maschi
       to_char(nvl(canc_est_m,0))||';'|| --  n30,
-- 31 - cancellati dall'estero femmine
       to_char(nvl(canc_est_f,0))||';'|| --  n31,
-- 32 - cancellati per altri motivi maschi
       to_char(nvl(canc_altri_m,0)+nvl(to_number(ltrim(substr(parametri,69,6),'0')),0))||';'|| --   n32,
-- 33 - cancellati per altri motivi femmine
       to_char(nvl(canc_altri_f,0)+nvl(to_number(ltrim(substr(parametri,75,6),'0')),0))||';'|| --  n33,
-- 38 - variazione territoriale maschi
       to_char('0')||';'|| --  n38,
-- 39 - variazione territoriale femmine
       to_char('0')||';'|| -- n39,
-- 42 - residenti in famiglia maschi fine mese
      to_char((decode(nvl(substr(parametri,33,6),0),0,
      resid_m_fam-nvl(mov_1_m_bis_fam,0)+nvl(mov_2_3_m_bis_fam,0),
                 nvl(substr(parametri,33,6),0)
        +nvl(mov_1_m_fam,0)-nvl(mov_2_3_m_fam,0)
        -nvl(mov_1_m_bis_fam,0)+nvl(mov_2_3_m_bis_fam,0))) + -- n42
        decode(nvl(to_number(ltrim(substr(parametri,57,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,69,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,63,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,75,6),'0')),0),0,0,
        ((decode(nvl(substr(parametri,8,6),0),0,resid_m,
              nvl(substr(parametri,8,6),0) + nvl(mov_1_m,0) - nvl(mov_2_3_m,0))
             -nvl(mov_1_m,0)+nvl(mov_2_3_m,0)) +
       ((nvl(nati_or_m,0) + nvl(nati_tr_m,0) + nvl(nati_est_m,0)) -
         (nvl(morti_or_m,0) + nvl(morti_tr_m,0) + nvl(morti_est_m,0)) +
        (nvl(iscr_m,0) + nvl(iscr_est_m,0) + nvl(iscr_altri_m,0) +
         nvl(to_number(ltrim(substr(parametri,57,6),'0')),0)) -
         (nvl(canc_m,0) + nvl(canc_est_m,0) + nvl(canc_altri_m,0) +
          nvl(to_number(ltrim(substr(parametri,69,6),'0')),0))) -
          ( (decode(nvl(substr(parametri,33,6),0),0,
      resid_m_fam-nvl(mov_1_m_bis_fam,0)+nvl(mov_2_3_m_bis_fam,0),
                 nvl(substr(parametri,33,6),0)
        +nvl(mov_1_m_fam,0)-nvl(mov_2_3_m_fam,0)
        -nvl(mov_1_m_bis_fam,0)+nvl(mov_2_3_m_bis_fam,0))) +
         (decode(nvl(substr(parametri,45,6),0),0,
      resid_m_conv-nvl(mov_1_m_bis_conv,0)+nvl(mov_2_3_m_bis_conv,0),
                 nvl(substr(parametri,45,6),0)
        +nvl(mov_1_m_conv,0)-nvl(mov_2_3_m_conv,0)
        -nvl(mov_1_m_bis_conv,0)+nvl(mov_2_3_m_bis_conv,0))))))) ||';'|| --n42,
-- 43 - residenti in famiglie femmine fine mese
      to_char((decode(nvl(substr(parametri,39,6),0),0,
      resid_f_fam-nvl(mov_1_f_bis_fam,0)+nvl(mov_2_3_f_bis_fam,0),
                 nvl(substr(parametri,39,6),0)
        +nvl(mov_1_f_fam,0)-nvl(mov_2_3_f_fam,0)
        -nvl(mov_1_f_bis_fam,0)+nvl(mov_2_3_f_bis_fam,0))) + --n43 
       decode(nvl(to_number(ltrim(substr(parametri,57,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,69,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,63,6),'0')),0)+
               nvl(to_number(ltrim(substr(parametri,75,6),'0')),0),0,0,
              ( (decode(nvl(substr(parametri,14,6),0),0,resid_f,
              nvl(substr(parametri,14,6),0) + nvl(mov_1_f,0) - nvl(mov_2_3_f,0))
             -nvl(mov_1_f,0)+nvl(mov_2_3_f,0)) +
       ((nvl(nati_or_f,0) + nvl(nati_tr_f,0) + nvl(nati_est_f,0)) -
         (nvl(morti_or_f,0) + nvl(morti_tr_f,0) + nvl(morti_est_f,0)) +
        (nvl(iscr_f,0) + nvl(iscr_est_f,0) + nvl(iscr_altri_f,0) +
         nvl(to_number(ltrim(substr(parametri,63,6),'0')),0)) -
         (nvl(canc_f,0) + nvl(canc_est_f,0) + nvl(canc_altri_f,0)+
          nvl(to_number(ltrim(substr(parametri,75,6),'0')),0))) -
         ((decode(nvl(substr(parametri,39,6),0),0,
      resid_f_fam-nvl(mov_1_f_bis_fam,0)+nvl(mov_2_3_f_bis_fam,0),
                 nvl(substr(parametri,39,6),0)
        +nvl(mov_1_f_fam,0)-nvl(mov_2_3_f_fam,0)
        -nvl(mov_1_f_bis_fam,0)+nvl(mov_2_3_f_bis_fam,0)))+
         (decode(nvl(substr(parametri,51,6),0),0,
      resid_f_conv-nvl(mov_1_f_bis_conv,0)+nvl(mov_2_3_f_bis_conv,0),
                 nvl(substr(parametri,51,6),0)
        +nvl(mov_1_f_conv,0)-nvl(mov_2_3_f_conv,0)
        -nvl(mov_1_f_bis_conv,0)+nvl(mov_2_3_f_bis_conv,0))) ))))||';'|| -- n43,
-- 44 - residenti in convivenza maschi fine mese
       to_char((decode(nvl(substr(parametri,45,6),0),0,
      resid_m_conv-nvl(mov_1_m_bis_conv,0)+nvl(mov_2_3_m_bis_conv,0),
                 nvl(substr(parametri,45,6),0)
        +nvl(mov_1_m_conv,0)-nvl(mov_2_3_m_conv,0)
        -nvl(mov_1_m_bis_conv,0)+nvl(mov_2_3_m_bis_conv,0))))||';'|| --n44,
-- 45 - residenti in convivenza femmine fine mese
       to_char((decode(nvl(substr(parametri,51,6),0),0,
      resid_f_conv-nvl(mov_1_f_bis_conv,0)+nvl(mov_2_3_f_bis_conv,0),
                 nvl(substr(parametri,51,6),0)
        +nvl(mov_1_f_conv,0)-nvl(mov_2_3_f_conv,0)
        -nvl(mov_1_f_bis_conv,0)+nvl(mov_2_3_f_bis_conv,0))))||';'|| -- n45,
-- 46 - modelli apr4 trasmessi: numero modelli
       to_char(nvl(tot_modelli_I,0) + nvl(tot_modelli_C,0) + nvl(tot_modelli_C_ripr,0))||';'|| --  n46,
-- 47 - modelli apr4 trasmessi: numero persone
       to_char(nvl(tot_persone_I,0) + nvl(tot_persone_C,0) + nvl(tot_persone_C_ripr,0))||';'|| --  n47,
-- 48 - numero famiglie
      to_char(decode(substr(parametri,20,6),
    0,(nvl(famiglie,0) - nvl(nuove_fam,0) + nvl(fam_chiuse,0)),
          (substr(parametri,20,6) + nvl(nuove_fam_1,0) - nvl(fam_chiuse_1,0))))||';'|| --   n48,
-- 49 - numero convivenze
      to_char(decode(substr(parametri,20,6),
    0,(nvl(convivenze,0) - nvl(nuove_conv,0) + nvl(conv_chiuse,0)),
          (substr(parametri,26,6) + nvl(nuove_conv_1,0) - nvl(conv_chiuse_1,0))))
  from arccom a, tabrep,
-- SEL_RESID 
      (select count(decode(sesso,'M','M','')) resid_m,
               count(decode(sesso,'F','F','')) resid_f
         from anaana, tabrep
        where fascia + 0       		= 1
          and stato                       != 17
          and substr(parametri,32,1)    	!= 'S'
          and chiave	= 'ED7B'
          and terminale	= nvl(userenv('terminal'),'ISTED7B')
      ) SEL_RESID,
-- SEL_RESID_FAM 
      (select count(decode(sesso,'M','M','')) resid_m_fam,
               count(decode(sesso,'F','F','')) resid_f_fam
         from anaana, tabrep
        where fascia + 0       		= 1
          and stato                       != 17
          and nvl(rapporto_par,' ')    	not in ('IC','CC')
          and substr(parametri,32,1)    	!= 'S'
          and chiave	= 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) SEL_RESID_FAM,
-- SEL_RESID_CONV 
      (select count(decode(sesso,'M','M','')) resid_m_conv,
               count(decode(sesso,'F','F','')) resid_f_conv
         from anaana, tabrep
        where fascia + 0      		= 1
          and stato                       != 17
          and nvl(rapporto_par,' ')   	in ('IC','CC')
          and substr(parametri,32,1)	!= 'S'
          and chiave          = 'ED7B'
          and terminale       = nvl(userenv('terminal'),'ISTED7B')
      ) SEL_RESID_CONV,
-- SEL_MOV_1 
      (select count(decode(sesso,'M','M','')) mov_1_m,
               count(decode(sesso,'F','F','')) mov_1_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov        		= dce.cod_mov
  	    and mov.cod_eve 	  		= dce.cod_eve
	    and nvl(mov.cod_variazione,' ')	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento			= 'I'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) SEL_MOV_1,
-- SEL_MOV_1_FAM 
      (select count(decode(sesso,'M','M','')) mov_1_m_fam,
               count(decode(sesso,'F','F','')) mov_1_f_fam
         from anamov, tabrep
        where ((cod_mov = 1 and nvl(rapporto_par,' ')   not in ('IC','CC'))
      	   OR
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') not in ('IC','CC') and nvl(rapporto_par_prec,' ') in ('IC','CC')))
          and no_conteggio is null
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) SEL_MOV_1_FAM,
-- SEL_MOV_1_CONV 
      (select count(decode(sesso,'M','M','')) mov_1_m_conv,
               count(decode(sesso,'F','F','')) mov_1_f_conv
         from anamov, tabrep
        where ((cod_mov = 1 and nvl(rapporto_par,' ')    in ('IC','CC'))
      	   or
          	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') in ('IC','CC') and nvl(rapporto_par_prec,' ') not in ('IC','CC')))
          and no_conteggio is null
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) SEL_MOV_1_FAM,
-- SEL_MOV_2_3 
      (select count(decode(sesso,'M','M','')) mov_2_3_m,
               count(decode(sesso,'F','F','')) mov_2_3_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
          and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento 			= 'C'
	    and dce.flag_istat				= 'S'
          and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) SEL_MOV_2_3,
-- SEL_MOV_2_3_FAM 
      (select count(decode(sesso,'M','M','')) mov_2_3_m_fam,
               count(decode(sesso,'F','F','')) mov_2_3_f_fam
         from anamov, tabrep
        where (((cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)) and nvl(nvl(rapporto_par_prec,rapporto_par),' ') not in ('CC','IC'))
               OR
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') in ('IC','CC') and nvl(rapporto_par_prec,' ') not in ('IC','CC')))
          and no_conteggio is null
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_2_3_FAM,
-- SEL_MOV_2_3_CONV 
      (select count(decode(sesso,'M','M','')) mov_2_3_m_conv,
               count(decode(sesso,'F','F','')) mov_2_3_f_conv
         from anamov, tabrep
        where (((cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)) and nvl(nvl(rapporto_par_prec,rapporto_par),' ') in ('CC','IC'))
       	   OR
       	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') not in ('IC','CC') and nvl(rapporto_par_prec,' ') in ('IC','CC')))
          and no_conteggio is null
          and data_reg between substr(parametri,1,7) and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_2_3_CONV,
-- SEL_MOV_1_BIS 
      (select count(decode(sesso,'M','M','')) mov_1_m_bis,
               count(decode(sesso,'F','F','')) mov_1_f_bis
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio 			is null
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_1_BIS,
-- SEL_MOV_1_BIS_FAM 
      (select count(decode(sesso,'M','M','')) mov_1_m_bis_fam,
               count(decode(sesso,'F','F','')) mov_1_f_bis_fam
         from anamov,tabrep
        where ((cod_mov = 1 and nvl(rapporto_par,' ')   not in ('IC','CC'))
               OR
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') not in ('IC','CC') and nvl(rapporto_par_prec,' ') in ('IC','CC')))
          and no_conteggio is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_1_BIS_FAM,
-- SEL_MOV_1_BIS_CONV 
      (select count(decode(sesso,'M','M','')) mov_1_m_bis_conv,
               count(decode(sesso,'F','F','')) mov_1_f_bis_conv
         from anamov,tabrep
        where ((cod_mov = 1 and nvl(rapporto_par,' ')    in ('IC','CC'))
               or
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') in ('IC','CC') and nvl(rapporto_par_prec,' ') not in ('IC','CC')))
          and no_conteggio is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_1_BIS_CONV,
-- SEL_MOV_2_3_BIS 
      (select count(decode(sesso,'M','M','')) mov_2_3_m_bis,
               count(decode(sesso,'F','F','')) mov_2_3_f_bis
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
   	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento 			= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_2_3_BIS,
-- SEL_MOV_2_3_BIS_FAM 
      (select count(decode(sesso,'M','M','')) mov_2_3_m_bis_fam,
               count(decode(sesso,'F','F','')) mov_2_3_f_bis_fam
         from anamov, tabrep
        where (((cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)) and nvl(nvl(rapporto_par_prec,rapporto_par),' ') not in ('CC','IC'))
               OR
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') in ('IC','CC') and nvl(rapporto_par_prec,' ') not in ('IC','CC')))
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and no_conteggio is null
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_2_3_BIS_FAM,
-- SEL_MOV_2_3_BIS_CONV 
      (select count(decode(sesso,'M','M','')) mov_2_3_m_bis_conv,
               count(decode(sesso,'F','F','')) mov_2_3_f_bis_conv
         from anamov, tabrep
        where (((cod_mov = 2 or (cod_mov = 3 and cod_eve = 52)) and nvl(nvl(rapporto_par_prec,rapporto_par),' ') in ('CC','IC'))
               OR
      	   (cod_mov = 10 and cod_eve = 92 and nvl(rapporto_par,' ') not in ('IC','CC') and nvl(rapporto_par_prec,' ') in ('IC','CC')))
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')+1
                           and to_char(sysdate,'j')
          and no_conteggio is null
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) SEL_MOV_2_3_BIS_CONV,
--sel_nati_or 			
      (select count(decode(sesso,'M','M','')) nati_or_m,
               count(decode(sesso,'F','F','')) nati_or_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
          and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and (cod_pro_nas,cod_com_nas) in (select pro_cliente,com_cliente
                                              from menuditta)
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_nati_or,
--sel_nati_tr 
      (select count(decode(sesso,'M','M','')) nati_tr_m,
               count(decode(sesso,'F','F','')) nati_tr_f
         from anamov mov, anadce dce, tabrep,menuditta
        where mov.cod_mov 	   		= dce.cod_mov
	    and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio  		is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and cod_pro_nas  < 199
          and (cod_pro_nas != pro_cliente or cod_com_nas != com_cliente)
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_nati_tr,
--  sel_nati_est		  
      (select count(decode(sesso,'M','M','')) nati_est_m,
               count(decode(sesso,'F','F','')) nati_est_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and cod_pro_nas  >= 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_nati_est,
--sel_morti_or 		  
      (select count(decode(sesso,'M','M','')) morti_or_m,
               count(decode(sesso,'F','F','')) morti_or_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   		= dce.cod_mov
          and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 		= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and (cod_pro_mor,cod_com_mor) = (select pro_cliente,com_cliente
                                              from menuditta)
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_morti_or,
--sel_morti_tr 		  
      (select count(decode(sesso,'M','M','')) morti_tr_m,
               count(decode(sesso,'F','F','')) morti_tr_f
         from anamov mov, anadce dce, tabrep, menuditta
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 			= 'C'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and cod_pro_mor  < 199
          and (cod_pro_mor != pro_cliente or cod_com_mor != com_cliente)
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_morti_tr,
-- sel_morti_est 		  
      (select count(decode(sesso,'M','M','')) morti_est_m,
               count(decode(sesso,'F','F','')) morti_est_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 			= 'C'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and cod_pro_mor  >= 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_morti_est,
--sel_iscr 		  
      (select count(decode(sesso,'M','M','')) iscr_m,
               count(decode(sesso,'F','F','')) iscr_f
         from anamov mov, anadce dce, tabrep
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ')   	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'M'
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7)
                           and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and nvl(cod_pro_eve,0) < 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_iscr,
-- sel_iscr_est 		  
      (select count(decode(sesso,'M','M','')) iscr_est_m,
               count(decode(sesso,'F','F','')) iscr_est_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		 	= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'M'
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and nvl(cod_pro_eve,0) >= 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_iscr_est,
-- sel_iscr_altri 		  
      (select count(decode(sesso,'M','M','')) iscr_altri_m,
               count(decode(sesso,'F','F','')) iscr_altri_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   			= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		in ('I','A')
	    and dce.tipo_evento 			= 'I'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
	    and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_iscr_altri,
--sel_canc 		  
      (select count(decode(sesso,'M','M','')) canc_m,
               count(decode(sesso,'F','F','')) canc_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   			= dce.cod_mov
 	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') 	= nvl(dce.cod_variazione,' ')
          and mov.no_conteggio			is null
	    and dce.tipo_evento_istat		= 'M'
	    and dce.tipo_evento 			= 'C'
	    and dce.flag_istat				= 'S'
	    and dce.anagrafe 				= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and nvl(mov.cod_pro_eve,0) < 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_canc,
-- sel_canc_est 		  
      (select count(decode(sesso,'M','M','')) canc_est_m,
               count(decode(sesso,'F','F','')) canc_est_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
	    and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat		= 'M'
	    and dce.tipo_evento 		= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and nvl(cod_pro_eve,0) >= 199
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_canc_est,
--sel_canc_altri 		  
      (select count(decode(sesso,'M','M','')) canc_altri_m,
               count(decode(sesso,'F','F','')) canc_altri_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
	    and mov.cod_eve				= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat	in ('I','A')
	    and dce.tipo_evento 		= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_canc_altri,
-- sel_famiglie 		  
      (select count(*) famiglie
         from anafam,tabrep
        where tipo_fam is null
          and fascia + 0 = 1
          and exists (select 'x'
                        from anaana
                       where anafam.fascia  = anaana.fascia
                         and anafam.cod_fam = anaana.cod_fam
                         and rapporto_par   = 'CF'
                         and stato          != 17)
          and substr(parametri,32,1) != 'S'
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_famiglie,
--sel_convivenze 		   
      (select count(*) convivenze
         from anafam,tabrep
        where tipo_fam = 1
          and fascia + 0 = 1
          and substr(parametri,32,1) != 'S'
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_convivenze,
-- sel_nuove_fam 		  
      (select count(*) nuove_fam
         from anamov, tabrep
        where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))
          and nucleo_arrivo = 1
          and rapporto_par  = 'CF'
          and no_conteggio is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') + 1 and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_nuove_fam,
-- sel_nuove_conv 		  
      (select count(*) nuove_conv
         from anamov, tabrep
        where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))
          and nucleo_arrivo = 1
          and rapporto_par  in ('IC','CC')
          and no_conteggio is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') + 1 and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_nuove_conv,
--sel_fam_chiuse 		  
      (select count(*) fam_chiuse
         from anamov, tabrep
        where (cod_mov = 2 
               or (cod_mov = 3 and cod_eve = 52)
               or (cod_mov = 10 and cod_eve = 92))
          and nucleo_partenza = 1
          and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec,rapporto_par) = 'CF'
          and no_conteggio	is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') + 1 and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_fam_chiuse,
-- sel_conv_chiuse 		  
      (select count(*) conv_chiuse
         from anamov, tabrep
        where (cod_mov = 2 
               or (cod_mov = 3 and cod_eve = 52)
               or (cod_mov = 10 and cod_eve = 92))
          and nucleo_partenza = 1
          and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec, rapporto_par) in ('IC','CC')
          and no_conteggio 	is null
          and data_reg between to_char(last_day(to_date(substr(parametri,1,7),'j')),'j') and to_char(sysdate,'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_conv_chiuse,
-- sel_nuove_fam_1 		  
      (select count(*) nuove_fam_1
         from anamov, tabrep
        where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))
          and nucleo_arrivo = 1
          and rapporto_par  = 'CF'
          and no_conteggio 	is null
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_nuove_fam_1,
-- sel_nuove_conv_1 		  
      (select count(*) nuove_conv_1
         from anamov, tabrep
        where (cod_mov = 1 or (cod_mov = 10 and cod_eve = 92))
          and nucleo_arrivo = 1
          and rapporto_par  = 'CC'
          and no_conteggio	is null
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_nuove_conv_1,
-- sel_fam_chiuse_1 		  
      (select count(*) fam_chiuse_1
         from anamov, tabrep
        where (cod_mov = 2 
               or (cod_mov = 3 and cod_eve = 52)
               or (cod_mov = 10 and cod_eve = 92))
          and nucleo_partenza = 1
          and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec, rapporto_par) = 'CF'
          and no_conteggio	is null
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_fam_chiuse_1,
-- sel_conv_chiuse_1 		  
      (select count(*) conv_chiuse_1
         from anamov, tabrep
        where (cod_mov = 2 
               or (cod_mov = 3 and cod_eve = 52)
               or (cod_mov = 10 and cod_eve = 92))
          and nucleo_partenza = 1
          and decode(cod_eve,52,rapporto_par_prec,92,rapporto_par_prec, rapporto_par) = 'CC'
          and no_conteggio is null
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_conv_chiuse_1,
-- sel_verifica_nati 		  
      (select count(decode(sesso,'M','M','')) nati_ver_m,
               count(decode(sesso,'F','F','')) nati_ver_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
          and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 		= 'I'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
	    and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_verifica_nati,
-- sel_verifica_morti 		  
      (select count(decode(sesso,'M','M','')) morti_ver_m,
               count(decode(sesso,'F','F','')) morti_ver_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
          and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat		= 'N'
	    and dce.tipo_evento 		= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_verifica_morti,
--sel_verifica_iscr 		  
      (select count(decode(sesso,'M','M','')) iscr_ver_m,
               count(decode(sesso,'F','F','')) iscr_ver_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
	    and mov.cod_eve			= dce.cod_eve
  	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat	in ('I','A','M')
	    and dce.tipo_evento 		= 'I'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
      ) sel_verifica_iscr,
-- sel_verifica_canc 		  
      (select count(decode(sesso,'M','M','')) canc_ver_m,
               count(decode(sesso,'F','F','')) canc_ver_f
         from anamov mov, anadce dce, tabrep 
        where mov.cod_mov 	   		= dce.cod_mov
          and mov.cod_eve			= dce.cod_eve
	    and nvl(mov.cod_variazione,' ') = nvl(dce.cod_variazione,' ')
          and mov.no_conteggio		is null
	    and dce.tipo_evento_istat	in ('I','A','M')
	    and dce.tipo_evento 		= 'C'
	    and dce.flag_istat			= 'S'
	    and dce.anagrafe 			= 'RES'
          and data_reg between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
          and chiave = 'ED7B'
          and terminale = nvl(userenv('terminal'),'ISTED7B')
       ) sel_verifica_canc,
-- SEL_MODELLI_I 
      (select count(*) tot_modelli_i
         from anaap4 ap4, tabrep
        where exists (select 1
                        from anatpr
                       where anno_pratica       = ap4.anno_pratica
                         and pratica            = ap4.pratica
                         and flag_perfezionamento    = 'S'
                         and anagrafe              = 'RES'
                         and tipo_evento         = 'I')
         and ap4.data_definizione    between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
         and ap4.anno_dic       is not null
         and ap4.numero_dic       is not null
         and ap4.anno_pratica       is not null
         and ap4.pratica       is not null
         and chiave = 'ED7B'
         and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_modelli_I,
-- SEL_MODELLI_C
     (select count(*) tot_modelli_c
        from anacp4 cp4, tabrep
       where exists (select 1
                       from anatpr
                      where anno_pratica       = cp4.anno_pratica
                        and pratica            = cp4.pratica
                        and flag_perfezionamento    = 'S'
                        and anagrafe         = 'RES'
                        and tipo_evento         = 'C')
        and cp4.data_definizione    between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
        and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) or
             (cp4.provvedimento in (2,3,4)))
        and cp4.anno_dic       is not null
        and cp4.numero_dic       is not null 
        and cp4.anno_pratica       is not null
        and cp4.pratica       is not null
        and chiave = 'ED7B'
        and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_modelli_C,
-- SEL_MODELLI_C_RIPR
     (select count(*) tot_modelli_c_ripr
        from anacp4 cp4, tabrep
       where exists (select 1
                       from anatpr
                      where anno_pratica       = cp4.anno_pratica
                        and pratica            = cp4.pratica
                        and flag_perfezionamento||flag_annullamento = 'S'
                        and anagrafe           = 'RES'
                        and tipo_evento        = 'C')
        and cp4.data_ripristino    between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
        and cp4.provvedimento = 5
        and cp4.anno_dic       is not null
        and cp4.numero_dic       is not null 
        and cp4.anno_pratica       is not null
        and cp4.pratica       is not null
        and chiave = 'ED7B'
        and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_modelli_C_ripr,
-- SEL_PERSONE_I
    (select COUNT(*) tot_persone_i
       from anaapm apm, anaap4 ap4, tabrep
      where exists (select 1
                      from anatpr
                     where anno_pratica       = ap4.anno_pratica
                       and pratica            = ap4.pratica
                       and flag_perfezionamento    = 'S'
                       and anagrafe              = 'RES'
                       and tipo_evento         = 'I')
        and apm.anno_dic      = ap4.anno_dic
        and apm.numero_dic      = ap4.numero_dic
        and apm.annullamento      is null
        and apm.numero_ordine      is not null 
        and ap4.data_definizione    between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
        and ap4.anno_dic       is not null
        and ap4.numero_dic       is not null
        and ap4.anno_pratica       is not null
        and ap4.pratica       is not null
        and chiave = 'ED7B'
        and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_persone_I,
-- SEL_PERSONE_C
    (select COUNT(*) tot_persone_c
       from anacpm cpm, anacp4 cp4, tabrep
      where exists (select 1
                      from anatpr
                     where anno_pratica       = cp4.anno_pratica
                       and pratica            = cp4.pratica
                       and flag_perfezionamento    = 'S'
                       and anagrafe         = 'RES'
                       and tipo_evento         = 'C')
        and cpm.anno_dic      = cp4.anno_dic
        and cpm.numero_dic      = cp4.numero_dic
        and cpm.flag_soggetto      = 'S'
        and cpm.annullamento      is null
        and cp4.data_definizione   between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
        and ((cp4.provvedimento = 1 and cp4.cod_stato is not null) or
             (cp4.provvedimento in (2,3,4)))
        and cp4.anno_dic       is not null
        and cp4.numero_dic       is not null
        and cp4.anno_pratica       is not null
        and cp4.pratica       is not null
        and chiave = 'ED7B'
        and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_persone_C,
-- SEL_PERSONE_C_RIPR
    (select COUNT(*) tot_persone_c_ripr
       from anacpm cpm, anacp4 cp4, tabrep
      where exists (select 1
                      from anatpr
                     where anno_pratica       = cp4.anno_pratica
                       and pratica            = cp4.pratica
                       and flag_perfezionamento||flag_annullamento    = 'S'
                       and anagrafe         = 'RES'
                       and tipo_evento         = 'C')
        and cpm.anno_dic      = cp4.anno_dic
        and cpm.numero_dic      = cp4.numero_dic
        and cpm.flag_ripristino      = 'S'
        and cp4.data_ripristino   between substr(parametri,1,7) and to_char(last_day(to_date(substr(parametri,1,7),'j')),'j')
        and cp4.provvedimento = 5
        and cp4.anno_dic       is not null
        and cp4.numero_dic       is not null
        and cp4.anno_pratica       is not null
        and cp4.pratica       is not null
        and chiave = 'ED7B'
        and terminale = nvl(userenv('terminal'),'ISTED7B')
     ) sel_persone_C_ripr
 where (a.cod_provincia,a.cod_comune) = (select pro_cliente, com_cliente from menuditta)
   and chiave = 'ED7B'
   and terminale = nvl(userenv('terminal'),'ISTED7B')
 order by 1
;
BEGIN
p_prenotazione := prenotazione;
p_passo        := passo;
declare
codice_istat varchar2(10);
begin
  begin
   select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
     into codice_istat
     from menuditta;
  exception
    when others then
      codice_istat := '';
  end;
begin
  update a_selezioni
     set valore_default = 'istatel\'||codice_istat||'_D7B_'||to_char(sysdate,'yymmdd')||'.csv'
   where parametro    = 'TXTFILE'
     and voce_menu   = 'ISTED7B'
  ;
end;
commit;
end;
for dati in sel_dati loop
  begin
           P_riga   := P_riga   + 1;
           insert into a_appoggio_stampe
           values ( p_prenotazione
                  , p_passo
                  , P_pagina
                  , P_riga
                  , dati.riga
                  )
           ;
   end;
end loop;
commit;
END MAIN;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
--
--   RETURN 'V1.0 del 29/07/2003';        Prima emissione
--   RETURN 'V2.0 del 21/09/2017';   AM   Adeguamenti 2017 - Nuovo tracciato
--   RETURN 'V2.1 del 20/10/2017';   AM   tracciato modificato nelle intestazioni dei campi
--   RETURN 'V2.2 del 08/11/2017';   AM   .sistemato intestazione INZIO 
--                                        .eliminato zeri non significativi
--
   RETURN 'V2.2 del 08/11/2017';
END VERSIONE;
END ISTED7B;
/
