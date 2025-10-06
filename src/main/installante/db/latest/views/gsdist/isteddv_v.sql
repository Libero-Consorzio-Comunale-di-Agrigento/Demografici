--liquibase formatted sql
--changeset amonopoli:202312211005_1 runOnChange:true stripComments:false
create or replace view isteddv_v 
       (cod_modello, data_mat, data_reg, d_data_mat, d_data_reg, riga)
AS
-- modelli 6SD / 12SD (tracciato 2018)
select msc.cod_modello,
       mat.data_mat,
       mat.data_reg,
       mat.d_data_mat,
       mat.d_data_reg,
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
  from arctri avv_f, arctri avv_m
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
 where avv_f.cod_pro_trib       (+) = msc.cod_pro_albo_avv_f
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
   and msc.anno                     < 2024
   and msc.flag_completo            is not null
   and msc.cod_modello              in ('6SD','12SD')
   and msc.atto                     > 0
UNION
-- modelli 6SD / 12SD - matrimoni (tracciato 2024)
select msc.cod_modello,
       mat.data_mat,
       mat.data_reg,
       mat.d_data_mat,
       mat.d_data_reg,
-- PROGRESSIVO_QUEST
	NVL(msc.progr_questionario,1000+rownum)||';'||
-- TIPO_PROCEDURA
	msc.tipo_procedura||';'||
-- N_ATTO
	msc.atto||';'||
-- P_ATTO
        msc.parte||';'||
-- S_ATTO
       decode(msc.serie,'A','1','C','2','')||';'||
-- DATA_STIP
	to_char(to_date(dpa.accordo_data,'j'),'dd/mm/yyyy')||';'||
-- DATA_REG
	to_char(to_date(mat.data_mat,'j'),'dd/mm/yyyy')||';'||
-- TIPO_ACCORDO_EXTRA
        msc.tipo_accordo||';'||
-- COD_TRIBUNALE
        to_char(null)||';'||
-- COD_CORTE
        to_char(null)||';'||
-- DATA_PROC
        to_char(null)||';'||
-- DATA_PROVV
        to_char(null)||';'||
-- DATA_TRASCR
        to_char(null)||';'||
-- TIPO_PROVV_TRIB
        to_char(null)||';'||
-- CAUSA_SCIOGLIMENTO
	msc.causa_scioglimento||';'||
-- DATA_SEPARAZIONE
	to_char(to_date(msc.data_sentenza,'j'),'dd/mm/yyyy')||';'||
-- DATA_MATRIM_U
	to_char(to_date(msc.data_mat,'j'),'dd/mm/yyyy')||';'||
-- PROV_MATRIM_U 
-- COM_MATRIM_U
        decode(com_mat0.descrizione,
          '', lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            702, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            703, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
                 ';'))||';'||
-- STATO_MATRIM_U
        decode(com_mat0.descrizione, '', '',
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            702, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            703, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
                 msc.cod_pro_mat))||';'||
-- REGIME_PATRIMONIALE
        msc.regime_patrimoniale_mat||';'||
-- RITO
        msc.rito_mat||';'||
-- NOME_MARITO_P1
	mat.nome_m||';'||
-- COGNOME_MARITO_P1
	mat.cognome_m||';'||
-- SESSO_P1
	to_char(null)||';'||
-- DATA_NASC_MARITO_P1
       	to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MARITO_P1 
-- COMNASC_MARITO_P1
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
-- CODFISC_MARITO_P1
	msc.cod_fiscale_m||';'||
-- PROVRES_MARITO_P1 
-- COMRES_MARITO_P1
	decode(com_res_m0.descrizione,
          '', lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),
          decode(mat.cod_pro_res_m,
            701, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
            702, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
            703, decode(sign(mat.cod_com_res_m-500), 1, lpad(mat.cod_pro_res_m,3,'0')||';'||lpad(mat.cod_com_res_m,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MARITO_P1
	decode(com_res_m0.descrizione, '', '',
          decode(mat.cod_pro_res_m,
            701, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
            702, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
            703, decode(sign(mat.cod_com_res_m-500), 1, '', mat.cod_pro_res_m),
                 mat.cod_pro_res_m))||';'||
-- CITT_MARITO_P1
     	msc.nazionalita_ita_m||';'||
-- DATA_CITT_MARITO_P1
	to_char(to_date(msc.data_nazionalita_m,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MARITO_P1
 	decode(mat.nazionalita_m,'I','',dci_m.ist_ci)||';'||
-- STATOCIV_MARITO_P1
        msc.stato_civile_m||';'||
-- NOME_MOGLIE_P2
	mat.nome_f||';'||
-- COGNOME_MOGLIE_P2
	mat.cognome_f||';'||
-- SESSO_P2
	to_char(null)||';'||
-- DATA_NASC_MOGLIE_P2
       	to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MOGLIE_P2
-- COMNASC_MOGLIE_P2
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
-- CODFISC_MOGLIE_P2
	msc.cod_fiscale_f||';'||
-- PROVRES_MOGLIE_P2 
-- COMRES_MOGLIE_P2
	decode(com_res_f0.descrizione,
          '', lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),
          decode(mat.cod_pro_res_f,
            701, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
            702, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
            703, decode(sign(mat.cod_com_res_f-500), 1, lpad(mat.cod_pro_res_f,3,'0')||';'||lpad(mat.cod_com_res_f,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MOGLIE_P2
	decode(com_res_f0.descrizione, '', '',
          decode(mat.cod_pro_res_f,
            701, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
            702, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
            703, decode(sign(mat.cod_com_res_f-500), 1, '', mat.cod_pro_res_f),
                 mat.cod_pro_res_f))||';'||
-- CITT_MOGLIE_P2
	msc.nazionalita_ita_f||';'||
-- DATA_CITT_MOGLIE_P2
	to_char(to_date(msc.data_nazionalita_f,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MOGLIE_P2
 	decode(mat.nazionalita_f,'I','',dci_f.ist_ci)||';'||
-- STATOCIV_MOGLIE_P2
	msc.stato_civile_f
  from arccom com_mat, arccom com_mat0
     , arccom com_nas_m, arccom com_nas_m0 
     , arccom com_res_m, arccom com_res_m0
     , arccom com_nas_f, arccom com_nas_f0
     , arccom com_res_f, arccom com_res_f0
     , anadci dci_m
     , anadci dci_f
     , civdpa dpa
     , civmat mat
     , istmsc msc
 where com_mat.cod_provincia    (+) = msc.cod_pro_mat
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
   and dpa.id_atto              (+) = mat.id_atto
   and mat.cod_rec                  in (0,3)
   and mat.id_atto                  = msc.id_atto
   and msc.anno                     >= 2024
   and msc.flag_completo            is not null
   and msc.cod_modello              in ('6SD','12SD')
   and msc.atto                     > 0
UNION
-- modelli PROVV - matrimoni (tracciato 2024)
select msc.cod_modello,
       ann.data_reg,
       ann.data_reg,
       ann.d_data_reg,
       ann.d_data_reg,
-- PROGRESSIVO_QUEST
	NVL(msc.progr_questionario,2000+rownum)||';'||
-- TIPO_PROCEDURA
	msc.tipo_procedura||';'||
-- N_ATTO
	to_char(null)||';'||
-- P_ATTO
        to_char(null)||';'||
-- S_ATTO
        to_char(null)||';'||
-- DATA_STIP
	to_char(null)||';'||
-- DATA_REG
	to_char(null)||';'||
-- TIPO_ACCORDO_EXTRA
        to_char(null)||';'||
-- COD_TRIBUNALE
        decode(msc.tipo_procedura, 3, nvl(lpad(tri.cod_tribunale,6,'0'),lpad(msc.cod_pro_trib,3,'0')||lpad(msc.cod_com_trib,3,'0')))||';'||
-- COD_CORTE
        decode(msc.tipo_procedura, 4, nvl(lpad(cda.cod_tribunale,6,'0'),lpad(msc.cod_pro_trib,3,'0')||lpad(msc.cod_com_trib,3,'0')))||';'||
-- DATA_PROC
        to_char(to_date(msc.data_iscr_ruolo_trib,'j'),'dd/mm/yyyy')||';'||
-- DATA_PROVV
        to_char(to_date(msc.data_provvedimento_trib,'j'),'dd/mm/yyyy')||';'||
-- DATA_TRASCR
        to_char(to_date(msc.data_trascr_provv_trib,'j'),'dd/mm/yyyy')||';'||
-- TIPO_PROVV_TRIB
        msc.tipo_provvedimento_trib||';'||
-- CAUSA_SCIOGLIMENTO
	msc.causa_scioglimento||';'||
-- DATA_SEPARAZIONE
	to_char(to_date(msc.data_sentenza,'j'),'dd/mm/yyyy')||';'||
-- DATA_MATRIM_U
	to_char(to_date(msc.data_mat,'j'),'dd/mm/yyyy')||';'||
-- PROV_MATRIM_U 
-- COM_MATRIM_U
        decode(com_mat0.descrizione,
          '', lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            702, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
            703, decode(sign(msc.cod_com_mat-500),1,lpad(msc.cod_pro_mat,3,'0')||';'||lpad(msc.cod_com_mat,3,'0'),';'),
                 ';'))||';'||
-- STATO_MATRIM_U
        decode(com_mat0.descrizione, '', '',
          decode(msc.cod_pro_mat,
            701, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            702, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
            703, decode(sign(msc.cod_com_mat-500),1,'',msc.cod_pro_mat),
                 msc.cod_pro_mat))||';'||
-- REGIME_PATRIMONIALE
        msc.regime_patrimoniale_mat||';'||
-- RITO
        msc.rito_mat||';'||
-- NOME_MARITO_P1
	mat.nome_m||';'||
-- COGNOME_MARITO_P1
	mat.cognome_m||';'||
-- SESSO_P1
	to_char(null)||';'||
-- DATA_NASC_MARITO_P1
       	to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MARITO_P1 
-- COMNASC_MARITO_P1
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
-- CODFISC_MARITO_P1
	msc.cod_fiscale_m||';'||
-- PROVRES_MARITO_P1 
-- COMRES_MARITO_P1
	decode(com_res_m0.descrizione,
          '', lpad(msc.cod_pro_res_m,3,'0')||';'||lpad(msc.cod_com_res_m,3,'0'),
          decode(msc.cod_pro_res_m,
            701, decode(sign(msc.cod_com_res_m-500), 1, lpad(msc.cod_pro_res_m,3,'0')||';'||lpad(msc.cod_com_res_m,3,'0'),';'),
            702, decode(sign(msc.cod_com_res_m-500), 1, lpad(msc.cod_pro_res_m,3,'0')||';'||lpad(msc.cod_com_res_m,3,'0'),';'),
            703, decode(sign(msc.cod_com_res_m-500), 1, lpad(msc.cod_pro_res_m,3,'0')||';'||lpad(msc.cod_com_res_m,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MARITO_P1
	decode(com_res_m0.descrizione, '', '',
          decode(msc.cod_pro_res_m,
            701, decode(sign(msc.cod_com_res_m-500), 1, '', msc.cod_pro_res_m),
            702, decode(sign(msc.cod_com_res_m-500), 1, '', msc.cod_pro_res_m),
            703, decode(sign(msc.cod_com_res_m-500), 1, '', msc.cod_pro_res_m),
                 msc.cod_pro_res_m))||';'||
-- CITT_MARITO_P1
     	msc.nazionalita_ita_m||';'||
-- DATA_CITT_MARITO_P1
	to_char(to_date(msc.data_nazionalita_m,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MARITO_P1
 	decode(mat.nazionalita_m,'I','',dci_m.ist_ci)||';'||
-- STATOCIV_MARITO_P1
        msc.stato_civile_m||';'||
-- NOME_MOGLIE_P2
	mat.nome_f||';'||
-- COGNOME_MOGLIE_P2
	mat.cognome_f||';'||
-- SESSO_P2
	to_char(null)||';'||
-- DATA_NASC_MOGLIE_P2
       	to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MOGLIE_P2
-- COMNASC_MOGLIE_P2
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
-- CODFISC_MOGLIE_P2
	msc.cod_fiscale_f||';'||
-- PROVRES_MOGLIE_P2 
-- COMRES_MOGLIE_P2
	decode(com_res_f0.descrizione,
          '', lpad(msc.cod_pro_res_f,3,'0')||';'||lpad(msc.cod_com_res_f,3,'0'),
          decode(msc.cod_pro_res_f,
            701, decode(sign(msc.cod_com_res_f-500), 1, lpad(msc.cod_pro_res_f,3,'0')||';'||lpad(msc.cod_com_res_f,3,'0'),';'),
            702, decode(sign(msc.cod_com_res_f-500), 1, lpad(msc.cod_pro_res_f,3,'0')||';'||lpad(msc.cod_com_res_f,3,'0'),';'),
            703, decode(sign(msc.cod_com_res_f-500), 1, lpad(msc.cod_pro_res_f,3,'0')||';'||lpad(msc.cod_com_res_f,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MOGLIE_P2
	decode(com_res_f0.descrizione, '', '',
          decode(msc.cod_pro_res_f,
            701, decode(sign(msc.cod_com_res_f-500), 1, '', msc.cod_pro_res_f),
            702, decode(sign(msc.cod_com_res_f-500), 1, '', msc.cod_pro_res_f),
            703, decode(sign(msc.cod_com_res_f-500), 1, '', msc.cod_pro_res_f),
                 msc.cod_pro_res_f))||';'||
-- CITT_MOGLIE_P2
	msc.nazionalita_ita_f||';'||
-- DATA_CITT_MOGLIE_P2
	to_char(to_date(msc.data_nazionalita_f,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MOGLIE_P2
 	decode(mat.nazionalita_f,'I','',dci_f.ist_ci)||';'||
-- STATOCIV_MOGLIE_P2
	msc.stato_civile_f
  from arctri tri
     , arccda cda
     , arccom com_mat, arccom com_mat0
     , arccom com_nas_m, arccom com_nas_m0 
     , arccom com_res_m, arccom com_res_m0
     , arccom com_nas_f, arccom com_nas_f0
     , arccom com_res_f, arccom com_res_f0
     , anadci dci_m
     , anadci dci_f
     , civmat mat
     , civann ann
     , istmsc msc
 where tri.cod_pro_trib         (+) = msc.cod_pro_trib
   and tri.cod_com_trib         (+) = msc.cod_com_trib
   and cda.cod_pro_trib         (+) = msc.cod_pro_trib
   and cda.cod_com_trib         (+) = msc.cod_com_trib
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
   and com_res_m.cod_provincia  (+) = msc.cod_pro_res_m
   and com_res_m.cod_comune     (+) = msc.cod_Com_res_m
   and com_res_m0.cod_provincia (+) = msc.cod_pro_res_m
   and com_res_m0.cod_comune    (+) = 0
   and com_res_f.cod_provincia  (+) = msc.cod_pro_res_f
   and com_res_f.cod_comune     (+) = msc.cod_Com_res_f
   and com_res_f0.cod_provincia (+) = msc.cod_pro_res_f
   and com_res_f0.cod_comune    (+) = 0
   and dci_m.cod_ci             (+) = mat.nazionalita_m
   and dci_f.cod_ci             (+) = mat.nazionalita_f
   and mat.cod_rec                  in (0,3)
   and mat.id_atto                  = ann.id_atto
   and ann.id                       = msc.id_civann
   and msc.flag_completo            is not null
   and msc.cod_modello              in ('PROVV')
UNION
-- modelli 6SU / 12SU - unioni civili (tracciato 2024)
select msu.cod_modello,
       uci.data_mat,
       uci.data_reg,
       uci.d_data_mat,
       uci.d_data_reg,
-- PROGRESSIVO_QUEST
	NVL(msu.progr_questionario,3000+rownum)||';'||
-- TIPO_PROCEDURA
	msu.tipo_procedura||';'||
-- N_ATTO
	msu.atto||';'||
-- P_ATTO
        msu.parte||';'||
-- S_ATTO
       decode(msu.serie,'A','1','C','2','')||';'||
-- DATA_STIP
	to_char(to_date(dpa.accordo_data,'j'),'dd/mm/yyyy')||';'||
-- DATA_REG
	to_char(to_date(uci.data_mat,'j'),'dd/mm/yyyy')||';'||
-- TIPO_ACCORDO_EXTRA
        msu.tipo_accordo||';'||
-- COD_TRIBUNALE
        to_char(null)||';'||
-- COD_CORTE
        to_char(null)||';'||
-- DATA_PROC
        to_char(null)||';'||
-- DATA_PROVV
        to_char(null)||';'||
-- DATA_TRASCR
        to_char(null)||';'||
-- TIPO_PROVV_TRIB
        to_char(null)||';'||
-- CAUSA_SCIOGLIMENTO
	to_char(null)||';'||
-- DATA_SEPARAZIONE
	to_char(null)||';'||
-- DATA_MATRIM_U
	to_char(to_date(msu.data_uci,'j'),'dd/mm/yyyy')||';'||
-- PROV_MATRIM_U 
-- COM_MATRIM_U
        decode(com_uci0.descrizione,
          '', lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),
          decode(msu.cod_pro_uci,
            701, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
            702, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
            703, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
                 ';'))||';'||
-- STATO_MATRIM_U
        decode(com_uci0.descrizione, '', '',
          decode(msu.cod_pro_uci,
            701, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
            702, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
            703, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
                 msu.cod_pro_uci))||';'||
-- REGIME_PATRIMONIALE
        msu.regime_patrimoniale_uci||';'||
-- RITO
        to_char(null)||';'||
-- NOME_MARITO_P1
	uci.nome_m||';'||
-- COGNOME_MARITO_P1
	uci.cognome_m||';'||
-- SESSO_P1
	decode(uci.sesso_m,'M','1','F','2')||';'||
-- DATA_NASC_MARITO_P1
       	to_char(to_date(uci.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MARITO_P1 
-- COMNASC_MARITO_P1
        decode(com_nas_m0.descrizione,
          '', lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),
          decode(uci.cod_pro_nas_m,
            701, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
            702, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
            703, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MARITO
        decode(com_nas_m0.descrizione,'','',
          decode(uci.cod_pro_nas_m,
            701, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
            702, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
            703, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
                 uci.cod_pro_nas_m))||';'||
-- CODFISC_MARITO_P1
	msu.cod_fiscale_1||';'||
-- PROVRES_MARITO_P1 
-- COMRES_MARITO_P1
	decode(com_res_m0.descrizione,
          '', lpad(uci.cod_pro_res_m,3,'0')||';'||lpad(uci.cod_com_res_m,3,'0'),
          decode(uci.cod_pro_res_m,
            701, decode(sign(uci.cod_com_res_m-500), 1, lpad(uci.cod_pro_res_m,3,'0')||';'||lpad(uci.cod_com_res_m,3,'0'),';'),
            702, decode(sign(uci.cod_com_res_m-500), 1, lpad(uci.cod_pro_res_m,3,'0')||';'||lpad(uci.cod_com_res_m,3,'0'),';'),
            703, decode(sign(uci.cod_com_res_m-500), 1, lpad(uci.cod_pro_res_m,3,'0')||';'||lpad(uci.cod_com_res_m,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MARITO_P1
	decode(com_res_m0.descrizione, '', '',
          decode(uci.cod_pro_res_m,
            701, decode(sign(uci.cod_com_res_m-500), 1, '', uci.cod_pro_res_m),
            702, decode(sign(uci.cod_com_res_m-500), 1, '', uci.cod_pro_res_m),
            703, decode(sign(uci.cod_com_res_m-500), 1, '', uci.cod_pro_res_m),
                 uci.cod_pro_res_m))||';'||
-- CITT_MARITO_P1
     	msu.nazionalita_ita_1||';'||
-- DATA_CITT_MARITO_P1
	to_char(to_date(msu.data_nazionalita_1,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MARITO_P1
 	decode(uci.nazionalita_m,'I','',dci_m.ist_ci)||';'||
-- STATOCIV_MARITO_P1
        msu.stato_civile_1||';'||
-- NOME_MOGLIE_P2
	uci.nome_f||';'||
-- COGNOME_MOGLIE_P2
	uci.cognome_f||';'||
-- SESSO_P2
	decode(uci.sesso_f,'M','1','F','2')||';'||
-- DATA_NASC_MOGLIE_P2
       	to_char(to_date(uci.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MOGLIE_P2
-- COMNASC_MOGLIE_P2
        decode(com_nas_f0.descrizione,
          '', lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),
          decode(uci.cod_pro_nas_f,
            701, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
            702, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
            703, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MOGLIE
        decode(com_nas_f0.descrizione,'','',
          decode(uci.cod_pro_nas_f,
            701, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
            702, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
            703, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
                 uci.cod_pro_nas_f))||';'||
-- CODFISC_MOGLIE_P2
	msu.cod_fiscale_2||';'||
-- PROVRES_MOGLIE_P2 
-- COMRES_MOGLIE_P2
	decode(com_res_f0.descrizione,
          '', lpad(uci.cod_pro_res_f,3,'0')||';'||lpad(uci.cod_com_res_f,3,'0'),
          decode(uci.cod_pro_res_f,
            701, decode(sign(uci.cod_com_res_f-500), 1, lpad(uci.cod_pro_res_f,3,'0')||';'||lpad(uci.cod_com_res_f,3,'0'),';'),
            702, decode(sign(uci.cod_com_res_f-500), 1, lpad(uci.cod_pro_res_f,3,'0')||';'||lpad(uci.cod_com_res_f,3,'0'),';'),
            703, decode(sign(uci.cod_com_res_f-500), 1, lpad(uci.cod_pro_res_f,3,'0')||';'||lpad(uci.cod_com_res_f,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MOGLIE_P2
	decode(com_res_f0.descrizione, '', '',
          decode(uci.cod_pro_res_f,
            701, decode(sign(uci.cod_com_res_f-500), 1, '', uci.cod_pro_res_f),
            702, decode(sign(uci.cod_com_res_f-500), 1, '', uci.cod_pro_res_f),
            703, decode(sign(uci.cod_com_res_f-500), 1, '', uci.cod_pro_res_f),
                 uci.cod_pro_res_f))||';'||
-- CITT_MOGLIE_P2
	msu.nazionalita_ita_2||';'||
-- DATA_CITT_MOGLIE_P2
	to_char(to_date(msu.data_nazionalita_2,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MOGLIE_P2
 	decode(uci.nazionalita_f,'I','',dci_f.ist_ci)||';'||
-- STATOCIV_MOGLIE_P2
	msu.stato_civile_2
  from arccom com_uci, arccom com_uci0
     , arccom com_nas_m, arccom com_nas_m0 
     , arccom com_res_m, arccom com_res_m0
     , arccom com_nas_f, arccom com_nas_f0
     , arccom com_res_f, arccom com_res_f0
     , anadci dci_m
     , anadci dci_f
     , civdpa dpa
     , civuci uci
     , istmsu msu
 where com_uci.cod_provincia    (+) = msu.cod_pro_uci
   and com_uci.cod_comune       (+) = msu.cod_Com_uci
   and com_uci0.cod_provincia   (+) = msu.cod_pro_uci
   and com_uci0.cod_comune      (+) = 0
   and com_nas_m.cod_provincia  (+) = uci.cod_pro_nas_m
   and com_nas_m.cod_comune     (+) = uci.cod_Com_nas_m
   and com_nas_m0.cod_provincia (+) = uci.cod_pro_nas_m
   and com_nas_m0.cod_comune    (+) = 0
   and com_nas_f.cod_provincia  (+) = uci.cod_pro_nas_f
   and com_nas_f.cod_comune     (+) = uci.cod_Com_nas_f
   and com_nas_f0.cod_provincia (+) = uci.cod_pro_nas_f
   and com_nas_f0.cod_comune    (+) = 0
   and com_res_m.cod_provincia  (+) = uci.cod_pro_res_m
   and com_res_m.cod_comune     (+) = uci.cod_Com_res_m
   and com_res_m0.cod_provincia (+) = uci.cod_pro_res_m
   and com_res_m0.cod_comune    (+) = 0
   and com_res_f.cod_provincia  (+) = uci.cod_pro_res_f
   and com_res_f.cod_comune     (+) = uci.cod_Com_res_f
   and com_res_f0.cod_provincia (+) = uci.cod_pro_res_f
   and com_res_f0.cod_comune    (+) = 0
   and dci_m.cod_ci             (+) = uci.nazionalita_m
   and dci_f.cod_ci             (+) = uci.nazionalita_f
   and dpa.id_atto              (+) = uci.id_atto
   and uci.cod_rec                  in (0,3)
   and uci.id_atto                  = msu.id_atto
   and msu.anno                     >= 2024
   and msu.flag_completo            is not null
   and msu.cod_modello              in ('6SU','12SU')
   and msu.atto                     > 0
UNION
-- modelli PROVV - unioni civili (tracciato 2024)
select msu.cod_modello,
       ann.data_reg,
       ann.data_reg,
       ann.d_data_reg,
       ann.d_data_reg,
-- PROGRESSIVO_QUEST
	NVL(msu.progr_questionario,4000+rownum)||';'||
-- TIPO_PROCEDURA
	msu.tipo_procedura||';'||
-- N_ATTO
	to_char(null)||';'||
-- P_ATTO
        to_char(null)||';'||
-- S_ATTO
        to_char(null)||';'||
-- DATA_STIP
	to_char(null)||';'||
-- DATA_REG
	to_char(null)||';'||
-- TIPO_ACCORDO_EXTRA
        to_char(null)||';'||
-- COD_TRIBUNALE
        decode(msu.tipo_procedura, 3, nvl(lpad(tri.cod_tribunale,6,'0'),lpad(msu.cod_pro_trib,3,'0')||lpad(msu.cod_com_trib,3,'0')))||';'||
-- COD_CORTE
        decode(msu.tipo_procedura, 4, nvl(lpad(cda.cod_tribunale,6,'0'),lpad(msu.cod_pro_trib,3,'0')||lpad(msu.cod_com_trib,3,'0')))||';'||
-- DATA_PROC
        to_char(to_date(msu.data_iscr_ruolo_trib,'j'),'dd/mm/yyyy')||';'||
-- DATA_PROVV
        to_char(to_date(msu.data_provvedimento_trib,'j'),'dd/mm/yyyy')||';'||
-- DATA_TRASCR
        to_char(to_date(msu.data_trascr_provv_trib,'j'),'dd/mm/yyyy')||';'||
-- TIPO_PROVV_TRIB
        msu.tipo_provvedimento_trib||';'||
-- CAUSA_SCIOGLIMENTO
	to_char(null)||';'||
-- DATA_SEPARAZIONE
	to_char(null)||';'||
-- DATA_MATRIM_U
	to_char(to_date(msu.data_uci,'j'),'dd/mm/yyyy')||';'||
-- PROV_MATRIM_U 
-- COM_MATRIM_U
        decode(com_uci0.descrizione,
          '', lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),
          decode(msu.cod_pro_uci,
            701, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
            702, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
            703, decode(sign(msu.cod_com_uci-500),1,lpad(msu.cod_pro_uci,3,'0')||';'||lpad(msu.cod_com_uci,3,'0'),';'),
                 ';'))||';'||
-- STATO_MATRIM_U
        decode(com_uci0.descrizione, '', '',
          decode(msu.cod_pro_uci,
            701, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
            702, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
            703, decode(sign(msu.cod_com_uci-500),1,'',msu.cod_pro_uci),
                 msu.cod_pro_uci))||';'||
-- REGIME_PATRIMONIALE
        msu.regime_patrimoniale_uci||';'||
-- RITO
        to_char(null)||';'||
-- NOME_MARITO_P1
	uci.nome_m||';'||
-- COGNOME_MARITO_P1
	uci.cognome_m||';'||
-- SESSO_P1
	decode(uci.sesso_m,'M','1','F','2')||';'||
-- DATA_NASC_MARITO_P1
       	to_char(to_date(uci.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MARITO_P1 
-- COMNASC_MARITO_P1
        decode(com_nas_m0.descrizione,
          '', lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),
          decode(uci.cod_pro_nas_m,
            701, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
            702, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
            703, decode(sign(uci.cod_com_nas_m-500),1,lpad(uci.cod_pro_nas_m,3,'0')||';'||lpad(uci.cod_com_nas_m,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MARITO
        decode(com_nas_m0.descrizione,'','',
          decode(uci.cod_pro_nas_m,
            701, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
            702, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
            703, decode(sign(uci.cod_com_nas_m-500),1,'',uci.cod_pro_nas_m),
                 uci.cod_pro_nas_m))||';'||
-- CODFISC_MARITO_P1
	msu.cod_fiscale_1||';'||
-- PROVRES_MARITO_P1 
-- COMRES_MARITO_P1
	decode(com_res_m0.descrizione,
          '', lpad(msu.cod_pro_res_1,3,'0')||';'||lpad(msu.cod_com_res_1,3,'0'),
          decode(msu.cod_pro_res_1,
            701, decode(sign(msu.cod_com_res_1-500), 1, lpad(msu.cod_pro_res_1,3,'0')||';'||lpad(msu.cod_com_res_1,3,'0'),';'),
            702, decode(sign(msu.cod_com_res_1-500), 1, lpad(msu.cod_pro_res_1,3,'0')||';'||lpad(msu.cod_com_res_1,3,'0'),';'),
            703, decode(sign(msu.cod_com_res_1-500), 1, lpad(msu.cod_pro_res_1,3,'0')||';'||lpad(msu.cod_com_res_1,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MARITO_P1
	decode(com_res_m0.descrizione, '', '',
          decode(msu.cod_pro_res_1,
            701, decode(sign(msu.cod_com_res_1-500), 1, '', msu.cod_pro_res_1),
            702, decode(sign(msu.cod_com_res_1-500), 1, '', msu.cod_pro_res_1),
            703, decode(sign(msu.cod_com_res_1-500), 1, '', msu.cod_pro_res_1),
                 msu.cod_pro_res_1))||';'||
-- CITT_MARITO_P1
     	msu.nazionalita_ita_1||';'||
-- DATA_CITT_MARITO_P1
	to_char(to_date(msu.data_nazionalita_1,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MARITO_P1
 	decode(uci.nazionalita_m,'I','',dci_m.ist_ci)||';'||
-- STATOCIV_MARITO_P1
        msu.stato_civile_1||';'||
-- NOME_MOGLIE_P2
	uci.nome_f||';'||
-- COGNOME_MOGLIE_P2
	uci.cognome_f||';'||
-- SESSO_P2
	decode(uci.sesso_f,'M','1','F','2')||';'||
-- DATA_NASC_MOGLIE_P2
       	to_char(to_date(uci.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- PROVNASC_MOGLIE_P2
-- COMNASC_MOGLIE_P2
        decode(com_nas_f0.descrizione,
          '', lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),
          decode(uci.cod_pro_nas_f,
            701, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
            702, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
            703, decode(sign(uci.cod_com_nas_f-500),1,lpad(uci.cod_pro_nas_f,3,'0')||';'||lpad(uci.cod_com_nas_f,3,'0'),';'),
                 ';'))||';'||
-- STATONASC_MOGLIE
        decode(com_nas_f0.descrizione,'','',
          decode(uci.cod_pro_nas_f,
            701, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
            702, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
            703, decode(sign(uci.cod_com_nas_f-500),1,'',uci.cod_pro_nas_f),
                 uci.cod_pro_nas_f))||';'||
-- CODFISC_MOGLIE_P2
	msu.cod_fiscale_2||';'||
-- PROVRES_MOGLIE_P2 
-- COMRES_MOGLIE_P2
	decode(com_res_f0.descrizione,
          '', lpad(msu.cod_pro_res_2,3,'0')||';'||lpad(msu.cod_com_res_2,3,'0'),
          decode(msu.cod_pro_res_2,
            701, decode(sign(msu.cod_com_res_2-500), 1, lpad(msu.cod_pro_res_2,3,'0')||';'||lpad(msu.cod_com_res_2,3,'0'),';'),
            702, decode(sign(msu.cod_com_res_2-500), 1, lpad(msu.cod_pro_res_2,3,'0')||';'||lpad(msu.cod_com_res_2,3,'0'),';'),
            703, decode(sign(msu.cod_com_res_2-500), 1, lpad(msu.cod_pro_res_2,3,'0')||';'||lpad(msu.cod_com_res_2,3,'0'),';'),
                 ';'))||';'||
-- STATORES_MOGLIE_P2
	decode(com_res_f0.descrizione, '', '',
          decode(msu.cod_pro_res_2,
            701, decode(sign(msu.cod_com_res_2-500), 1, '', msu.cod_pro_res_2),
            702, decode(sign(msu.cod_com_res_2-500), 1, '', msu.cod_pro_res_2),
            703, decode(sign(msu.cod_com_res_2-500), 1, '', msu.cod_pro_res_2),
                 msu.cod_pro_res_2))||';'||
-- CITT_MOGLIE_P2
	msu.nazionalita_ita_2||';'||
-- DATA_CITT_MOGLIE_P2
	to_char(to_date(msu.data_nazionalita_2,'j'),'dd/mm/yyyy')||';'||
-- STATOCITT_MOGLIE_P2
 	decode(uci.nazionalita_f,'I','',dci_f.ist_ci)||';'||
-- STATOCIV_MOGLIE_P2
	msu.stato_civile_2
  from arctri tri
     , arccda cda
     , arccom com_uci, arccom com_uci0
     , arccom com_nas_m, arccom com_nas_m0 
     , arccom com_res_m, arccom com_res_m0
     , arccom com_nas_f, arccom com_nas_f0
     , arccom com_res_f, arccom com_res_f0
     , anadci dci_m
     , anadci dci_f
     , civuci uci
     , civann ann
     , istmsu msu
 where tri.cod_pro_trib         (+) = msu.cod_pro_trib
   and tri.cod_com_trib         (+) = msu.cod_com_trib
   and cda.cod_pro_trib         (+) = msu.cod_pro_trib
   and cda.cod_com_trib         (+) = msu.cod_com_trib
   and com_uci.cod_provincia    (+) = msu.cod_pro_uci
   and com_uci.cod_comune       (+) = msu.cod_Com_uci
   and com_uci0.cod_provincia   (+) = msu.cod_pro_uci
   and com_uci0.cod_comune      (+) = 0
   and com_nas_m.cod_provincia  (+) = uci.cod_pro_nas_m
   and com_nas_m.cod_comune     (+) = uci.cod_Com_nas_m
   and com_nas_m0.cod_provincia (+) = uci.cod_pro_nas_m
   and com_nas_m0.cod_comune    (+) = 0
   and com_nas_f.cod_provincia  (+) = uci.cod_pro_nas_f
   and com_nas_f.cod_comune     (+) = uci.cod_Com_nas_f
   and com_nas_f0.cod_provincia (+) = uci.cod_pro_nas_f
   and com_nas_f0.cod_comune    (+) = 0
   and com_res_m.cod_provincia  (+) = msu.cod_pro_res_1
   and com_res_m.cod_comune     (+) = msu.cod_Com_res_1
   and com_res_m0.cod_provincia (+) = msu.cod_pro_res_1
   and com_res_m0.cod_comune    (+) = 0
   and com_res_f.cod_provincia  (+) = msu.cod_pro_res_2
   and com_res_f.cod_comune     (+) = msu.cod_Com_res_2
   and com_res_f0.cod_provincia (+) = msu.cod_pro_res_2
   and com_res_f0.cod_comune    (+) = 0
   and dci_m.cod_ci             (+) = uci.nazionalita_m
   and dci_f.cod_ci             (+) = uci.nazionalita_f
   and uci.cod_rec                  in (0,3)
   and uci.id_atto                  = ann.id_atto
   and ann.id                       = msu.id_civann
   and msu.flag_completo            is not null
   and msu.cod_modello              in ('PROVV')
/
comment on table isteddv_v is 'ISTAT - Modello SC - Dati'
/
