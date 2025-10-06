--liquibase formatted sql
--changeset amonopoli:202503211244_1 runOnChange:true stripComments:false
create or replace view istddv (cod_modello, data_mat, data_reg, riga)
AS
select msc.cod_modello,mat.data_mat,mat.data_reg,
-- PROGRESSIVO_QUEST
	NVL(msc.progr_questionario,rownum)||';'||
-- ART6_ART12
	decode(msc.cod_modello, '6SD','2','12SD','1')||';'||
-- DATA_STIP
	to_char(to_date(nvl(dpa.accordo_data,mat.data_mat),'j'),'dd/mm/yyyy')||';'||
-- DATA_REG
	to_char(to_date(mat.data_reg,'j'),'dd/mm/yyyy')||';'||
-- N_ATTO
	msc.atto||';'||
-- P_ATTO
--	decode(msc.parte,1,'I',2,'II')||';'||
        msc.parte||';'||
-- S_ATTO
--	msc.serie||';'||
       decode(msc.serie,'A','1','C','2','')||';'||
-- TIPO_ACCORDO
	msc.tipo_accordo||';'||
-- CAUSA_SCIOGLIMENTO
	msc.causa_scioglimento||';'||
-- DATA_SEPARAZIONE
	to_char(to_date(msc.data_sentenza,'j'),'dd/mm/yyyy')||';'||
-- PROV_MATRIM_COD -- COM_MATRIM 
        decode(com_mat0.descrizione,
          '', lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            702, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            703, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
                 ';'))||';'||
-- STATO_MATRIM
        decode(com_mat0.descrizione, '', '',
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            702, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            703, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
                 msc.cod_pro_mat))||';'||
-- RITO
        msc.rito_mat||';'||
-- REGIME_PATRIMONIALE
        msc.regime_patrimoniale_mat||';'||
-- DATA_MATRIM
	to_char(to_date(msc.data_mat,'j'),'dd/mm/yyyy')||';'||
-- NOME_MARITO
	substr(mat.cognome_nome_m,instr(mat.cognome_nome_m,'/')+1)||';'||
-- COGNOME_MARITO
	substr(mat.cognome_nome_m,1,instr(mat.cognome_nome_m,'/')-1)||';'||
-- DATA_NASC_MARITO
       	to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MARITO -- COMNASC_MARITO 
        decode(com_nas_m0.descrizione,
          '', lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0'),
          decode(mat.cod_pro_nas_m,
            701, decode(sign(mat.cod_com_nas_m-500),1,lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0'),';'),
            702, decode(sign(mat.cod_com_nas_m-500),1,lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0'),';'),
            703, decode(sign(mat.cod_com_nas_m-500),1,lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MARITO
        decode(com_nas_m0.descrizione,'','',
          decode(mat.cod_pro_nas_m,
            701, decode(sign(mat.cod_com_nas_m-500),1,'',mat.cod_pro_nas_m),
            702, decode(sign(mat.cod_com_nas_m-500),1,'',mat.cod_pro_nas_m),
            703, decode(sign(mat.cod_com_nas_m-500),1,'',mat.cod_pro_nas_m),
                 mat.cod_pro_nas_m))||';'||
-- CODFISC_MARITO
	msc.cod_fiscale_m||';'||
-- PROVRES_MARITO -- COMRES_MARITO 
	decode(com_res_m0.descrizione,
          '', lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),
          decode(mat.cod_pro_res_m,
            701, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
            702, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
            703, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MARITO
	decode(com_res_m0.descrizione, '', '',
          decode(mat.cod_pro_res_m,
            701, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
            702, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
            703, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
                 mat.cod_pro_res_m))||';'||
-- CITT_MARITO
     	msc.nazionalita_ita_m||';'||
-- DATA_CITT_MARITO
	to_char(to_date(msc.data_nazionalita_m,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MARITO
 	decode(mat.nazionalita_m,'I','',dci_m.ist_ci)||';'||
-- STATOCIV_MARITO
        msc.stato_civile_m||';'||
-- TITSTUD_MARITO
	msc.titolo_studio_m||';'||
-- CONDPROF_MARITO
	msc.condizione_prof_m||';'||
-- POSPROF_MARITO
	msc.posizione_prof_m||';'||
-- NOME_MOGLIE
	substr(mat.cognome_nome_f,instr(mat.cognome_nome_f,'/')+1)||';'||
-- COGNOME_MOGLIE
	substr(mat.cognome_nome_f,1,instr(mat.cognome_nome_f,'/')-1)||';'||
-- DATA_NASC_MOGLIE
       	to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MOGLIE -- COMNASC_MOGLIE 
        decode(com_nas_f0.descrizione,
          '', lpad(mat.cod_pro_nas_f,3,'0')||';'||lpad(mat.cod_com_nas_f,3,'0'),
          decode(mat.cod_pro_nas_f,
            701, decode(sign(mat.cod_com_nas_f-500),1,lpad(mat.cod_pro_nas_f,3,'0')||';'||lpad(mat.cod_com_nas_f,3,'0'),';'),
            702, decode(sign(mat.cod_com_nas_f-500),1,lpad(mat.cod_pro_nas_f,3,'0')||';'||lpad(mat.cod_com_nas_f,3,'0'),';'),
            703, decode(sign(mat.cod_com_nas_f-500),1,lpad(mat.cod_pro_nas_f,3,'0')||';'||lpad(mat.cod_com_nas_f,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MOGLIE
        decode(com_nas_f0.descrizione,'','',
          decode(mat.cod_pro_nas_f,
            701, decode(sign(mat.cod_com_nas_f-500),1,'',mat.cod_pro_nas_f),
            702, decode(sign(mat.cod_com_nas_f-500),1,'',mat.cod_pro_nas_f),
            703, decode(sign(mat.cod_com_nas_f-500),1,'',mat.cod_pro_nas_f),
                 mat.cod_pro_nas_f))||';'||
-- CODFISC_MOGLIE
	msc.cod_fiscale_f||';'||
-- PROVRES_MOGLIE -- COMRES_MOGLIE 
	decode(com_res_f0.descrizione,
          '', lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),
          decode(mat.cod_pro_res_f,
            701, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
            702, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
            703, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MOGLIE
	decode(com_res_f0.descrizione, '', '',
          decode(mat.cod_pro_res_f,
            701, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
            702, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
            703, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
                 mat.cod_pro_res_f))||';'||
-- CITT_MOGLIE
	msc.nazionalita_ita_f||';'||
-- DATA_CITT_MOGLIE
	to_char(to_date(msc.data_nazionalita_f,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MOGLIE
 	decode(mat.nazionalita_f,'I','',dci_f.ist_ci)||';'||
-- STATOCIV_MOGLIE
	msc.stato_civile_f||';'||
-- TITSTUD_MOGLIE
	msc.titolo_studio_f||';'||
-- CONDPROF_MOGLIE
	msc.condizione_prof_f||';'||
-- POSPROF_MOGLIE
	msc.posizione_prof_f||';'||
-- NOME_AVV_MAR -- COGNOME_AVV_MAR -- CODFISC_AVV_MAR
	msc.nome_avv_m||';'||msc.cognome_avv_m||';'||msc.cod_fiscale_avv_m||';'||
-- ALBO_MAR
	nvl(lpad(avv_m.cod_tribunale,6,'0'),lpad(msc.cod_pro_albo_avv_m,3,'0')||lpad(msc.cod_com_albo_avv_m,3,'0'))||';'||
-- NOME_AVV_MOG -- COGNOME_AVV_MOG -- CODFISC_AVV_MOG
	msc.nome_avv_f||';'||msc.cognome_avv_f||';'||msc.cod_fiscale_avv_f||';'||
-- ALBO_MOG
	nvl(lpad(avv_f.cod_tribunale,6,'0'),lpad(msc.cod_pro_albo_avv_f,3,'0')||lpad(msc.cod_com_albo_avv_f,3,'0'))||';'||
-- SOSTCON
	msc.sostentamento_cn||';'||
-- FLAG_IMPCON
	decode(msc.cod_modello, '6SD',
          decode(msc.importo_mensile_cn,'',
            decode(msc.importo_unico_cn, '', '',
              '2'), '1'))||';'||
-- IMPCON_MENS
	msc.importo_mensile_cn||';'||
-- IMPCON_UNICO
	decode(msc.cod_modello, '6SD', msc.importo_unico_cn)||';'||
-- CHI_SOSTCON
	msc.chi_sostentamento_cn||';'||
-- ASS_ABITAZ
	msc.abitazione_assegnata||';'||
-- FIGLI
	msc.presenza_fg||';'||
-- NR_FIGLI
	msc.numero_fg||';'||
-- FIGLI_MIN
	decode(msc.cod_modello, '6SD', msc.presenza_fg_min)||';'||
-- NFIGLI_MIN
	decode(msc.cod_modello, '6SD', msc.numero_fg_min)||';'||
-- FIGLI_A_CARICO
	decode(msc.cod_modello, '6SD', msc.presenza_fg_mag)||';'||
-- NFIGLI_A_CARICO
	decode(msc.cod_modello, '6SD', msc.numero_fg_mag)||';'||
-- SESSO1 -- DATANAS1 -- CODFISC1 -- AFFID1
	decode(msc.cod_modello, '6SD', msc.nome_fg_1)||';'||
	decode(msc.cod_modello, '6SD', msc.cognome_fg_1)||';'||
	decode(msc.cod_modello, '6SD', msc.sesso_fg_1)||';'||
        decode(msc.cod_modello, '6SD', to_char(to_date(msc.data_nas_fg_1,'j'),'dd/mm/yyyy'))||';'||
	decode(msc.cod_modello, '6SD', msc.eta_fg_1)||';'||
        decode(msc.cod_modello, '6SD', msc.cod_fiscale_fg_1)||';'||
        decode(msc.cod_modello, '6SD', msc.affidamento_fg_1)||';'||
        decode(msc.cod_modello, '6SD', msc.pernottamenti_fg_1)||';'||
-- SESSO2 -- DATANAS2 -- CODFISC2 -- AFFID2
	decode(msc.cod_modello, '6SD', msc.nome_fg_2)||';'||
	decode(msc.cod_modello, '6SD', msc.cognome_fg_2)||';'||
	decode(msc.cod_modello, '6SD', msc.sesso_fg_2)||';'||
        decode(msc.cod_modello, '6SD', to_char(to_date(msc.data_nas_fg_2,'j'),'dd/mm/yyyy'))||';'||
	decode(msc.cod_modello, '6SD', msc.eta_fg_2)||';'||
        decode(msc.cod_modello, '6SD', msc.cod_fiscale_fg_2)||';'||
        decode(msc.cod_modello, '6SD', msc.affidamento_fg_2)||';'||
        decode(msc.cod_modello, '6SD', msc.pernottamenti_fg_2)||';'||
-- SESSO3 -- DATANAS3 -- CODFISC3 -- AFFID3
	decode(msc.cod_modello, '6SD', msc.nome_fg_3)||';'||
	decode(msc.cod_modello, '6SD', msc.cognome_fg_3)||';'||
	decode(msc.cod_modello, '6SD', msc.sesso_fg_3)||';'||
        decode(msc.cod_modello, '6SD', to_char(to_date(msc.data_nas_fg_3,'j'),'dd/mm/yyyy'))||';'||
	decode(msc.cod_modello, '6SD', msc.eta_fg_3)||';'||
        decode(msc.cod_modello, '6SD', msc.cod_fiscale_fg_3)||';'||
        decode(msc.cod_modello, '6SD', msc.affidamento_fg_3)||';'||
        decode(msc.cod_modello, '6SD', msc.pernottamenti_fg_3)||';'||
-- SESSO4 -- DATANAS4 -- CODFISC4 -- AFFID4
	decode(msc.cod_modello, '6SD', msc.nome_fg_4)||';'||
	decode(msc.cod_modello, '6SD', msc.cognome_fg_4)||';'||
	decode(msc.cod_modello, '6SD', msc.sesso_fg_4)||';'||
        decode(msc.cod_modello, '6SD', to_char(to_date(msc.data_nas_fg_4,'j'),'dd/mm/yyyy'))||';'||
	decode(msc.cod_modello, '6SD', msc.eta_fg_3)||';'||
        decode(msc.cod_modello, '6SD', msc.cod_fiscale_fg_4)||';'||
        decode(msc.cod_modello, '6SD', msc.affidamento_fg_4)||';'||
        decode(msc.cod_modello, '6SD', msc.pernottamenti_fg_4)||';'||
-- SOSTFIG
	decode(msc.cod_modello, '6SD', msc.mantenimento_fg)||';'||
-- CAPITOLI_SPESA_1
	decode(msc.cod_modello, '6SD', msc.capitolo_spesa_1)||';'||
-- CAPITOLI_SPESA_2
	decode(msc.cod_modello, '6SD', msc.capitolo_spesa_2)||';'||
-- CAPITOLI_SPESA_3
	decode(msc.cod_modello, '6SD', msc.capitolo_spesa_3)||';'||
-- CAPITOLI_SPESA_4
	decode(msc.cod_modello, '6SD', msc.capitolo_spesa_4)||';'||
-- CAPITOLI_SPESA_5
	decode(msc.cod_modello, '6SD', msc.capitolo_spesa_5)||';'||
-- CHI_SOSTFIG
	decode(msc.cod_modello, '6SD', msc.chi_sostentamento_fg)||';'||
-- IMPFIG
	decode(msc.cod_modello, '6SD', msc.importo_mensile_fg)||';'||
-- SOSTFIG
	decode(msc.cod_modello, '6SD', msc.mantenimento_fg_mag)
  from arctri tri, arctri avv_f, arctri avv_m
     , arccom com_mat, arccom com_mat0
     , arccom com_nas_m, arccom com_nas_m0 
     , arccom com_res_m, arccom com_res_m0
     , arccom com_nas_f, arccom com_nas_f0
     , arccom com_res_f, arccom com_res_f0
     , anadci dci_m
     , anadci dci_f
     , civdpa dpa
     , civmat mat
     , istmsc msc
 where tri.cod_pro_trib         (+) = msc.cod_pro_trib
   and tri.cod_com_trib         (+) = msc.cod_com_trib
   and avv_f.cod_pro_trib       (+) = msc.cod_pro_albo_avv_f
   and avv_f.cod_com_trib       (+) = msc.cod_com_albo_avv_f
   and avv_m.cod_pro_trib       (+) = msc.cod_pro_albo_avv_m
   and avv_m.cod_com_trib       (+) = msc.cod_com_albo_avv_m
   and com_mat.cod_provincia    (+) = msc.cod_pro_mat
   and com_mat.cod_comune       (+) = msc.cod_Com_mat
   and com_mat0.cod_provincia   (+) = msc.cod_pro_mat
   and com_mat0.cod_comune      (+) = 0
   and com_nas_m.cod_provincia  (+) = mat.cod_pro_nas_m
   and com_nas_m.cod_comune     (+) = mat.cod_Com_nas_m
   and com_nas_m0.cod_provincia (+) = mat.cod_pro_nas_m
   and com_nas_m0.cod_comune    (+) = 0
   and com_nas_f.cod_provincia  (+) = mat.cod_pro_nas_f
   and com_nas_f.cod_comune     (+) = mat.cod_Com_nas_f
   and com_nas_f0.cod_provincia (+) = mat.cod_pro_nas_f
   and com_nas_f0.cod_comune    (+) = 0
   and com_res_m.cod_provincia  (+) = mat.cod_pro_res_m
   and com_res_m.cod_comune     (+) = mat.cod_Com_res_m
   and com_res_m0.cod_provincia (+) = mat.cod_pro_res_m
   and com_res_m0.cod_comune    (+) = 0
   and com_res_f.cod_provincia  (+) = mat.cod_pro_res_f
   and com_res_f.cod_comune     (+) = mat.cod_Com_res_f
   and com_res_f0.cod_provincia (+) = mat.cod_pro_res_f
   and com_res_f0.cod_comune    (+) = 0
   and dci_m.cod_ci             (+) = mat.nazionalita_m
   and dci_f.cod_ci             (+) = mat.nazionalita_f
   and dpa.tipo_atto            (+) = 4
   and dpa.ufficio              (+) = mat.ufficio
   and dpa.anno                 (+) = mat.anno
   and dpa.atto                 (+) = mat.atto
   and dpa.parte                (+) = mat.parte
   and dpa.serie                (+) = mat.serie
   and mat.cod_rec                  in (0,3)
   and mat.ufficio                  = msc.ufficio
   and mat.anno                     = msc.anno
   and mat.atto                     = msc.atto
   and mat.parte                    = msc.parte
   and mat.serie                    = msc.serie
--   and msc.flag_completo            is not null
--   and msc.cod_modello              in ('6SC','12SC')
/
comment on table ISTDDV is 'ISTAT - Dati per Compilazione Modello SC (view)'
/
