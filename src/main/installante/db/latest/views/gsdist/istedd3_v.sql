--liquibase formatted sql
--changeset amonopoli:202312211005_3 runOnChange:true stripComments:false
create or replace view istedd3_v
       (data_reg, data_mat, d_data_reg, d_data_mat, riga)
AS
select mat.data_REG,
       mat.data_MAT,
       mat.d_data_REG,
       mat.d_data_MAT,
-- PROGRESSIVO_QUEST
--       rownum||';'||
-- MESE_RIFERIMENTO_RISPONDENTE
       ltrim(to_char(to_date(mat.data_mat,'j'),'mm'),'0')||';'||
-- ANNO_RIFERIMENTO_RISPONDENTE
       nvl(to_char(to_date(mat.data_mat,'j'),'yyyy'),'0000')||';'||
-- N_ATTO
       md3.atto_mat||';'||
-- P_ATTO_MATRIMONIO
       md3.parte_mat||';'||
-- S_ATTO_MATRIMONIO
       decode(md3.serie_mat,'A','1','C','2','')||';'||
-- DATA_CELEBRAZIONE
       to_char(to_date(mat.data_mat,'j'),'dd/mm/yyyy')||';'||
-- RITO
       decode(to_char(md3.parte_mat)||md3.serie_mat,'2A','1','2')||';'||
-- NOME_SPOSO
       substr(mat.cognome_nome_m,instr(mat.cognome_nome_m,'/')+1)||';'||
-- COGNOME_SPOSO
       substr(mat.cognome_nome_m,1,instr(mat.cognome_nome_m,'/')-1)||';'||
-- FLAG_LUOGO_RESIDENZA_SPOSO
-- PROV_RESIDENZA_SPOSO
-- COMUNE_RESIDENZA_SPOSO
-- STATO_ESTERO_RES_SPOSO
       decode(lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_res_m,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_res_m,0),3,'0')||';'||lpad(nvl(mat.cod_com_res_m,0),3,'0')||';',
                   '3;'||';'||';'||nvl(mat.cod_pro_res_m,0)))||';'||
-- FLAG_LUOGO_NASCITA_SPOSO
-- PROV_NASC_SPOSO
-- COM_NASC_SPOSO
-- STATO_ESTERO_NASC_SPOSO
       decode(lpad(nvl(mat.cod_pro_nas_m,0),3,'0')||lpad(nvl(mat.cod_com_nas_m,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_nas_m,0)-199),
                -1,'2;'||lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0')||';',
                   '3;'||';'||';'||lpad(mat.cod_pro_nas_m,3,'0')))||';'||
-- DATA_NASC_SPOSO
       to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- STATOCIV_SPOSO
       decode(md3.stato_civile_m,'CE','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9')||';'||
-- DATA_CESS_MATR_PREC_SPOSO
       decode(md3.stato_civile_m,'CE','',to_char(to_date(md3.data_fine_mat_m,'j'),'dd/mm/yyyy'))||';'||
-- GRADO_ISTRUZIONE_SPOSO
       to_char(md3.grado_istruzione_m)||';'||
-- COND_PROF_SPOSO
       to_char(md3.condizione_prof_m)||';'||
-- POS_PROF_SPOSO
       decode(md3.condizione_prof_m,1,to_char(md3.posizione_prof_m),'')||';'||
-- RAMO_ATT_ECON_SPOSO
       decode(md3.condizione_prof_m,1,to_char(md3.attivita_prof_m),'')||';'||
-- FLAG_CITT_SPOSO
-- STATO_CITT_SPOSO
       decode(nazionalita_ita_m,1,'1;',2,'2;',3,'3;'||to_char(nvl(dci_m.ist_ci,0)),';')||';'||
-- CODFISC_SPOSO
       mat.cod_fiscale_m||';'||
-- RES_DOPO_MATR_SPOSO
-- PROVRES_SPOSO_DOPO_MATR
-- COMRES_SPOSO_DOPO_MATR
-- STATORES_SPOSO_DOPO_MATR
       decode(lpad(nvl(md3.cod_pro_res_post_m,0),3,'0')||lpad(nvl(md3.cod_com_res_post_m,0),3,'0'),
                lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
              '1;'||';'||';',
                lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
              '2;'||';'||';',
              decode(sign(nvl(md3.cod_pro_res_post_m,0)-199),
                -1,'3;'||lpad(nvl(md3.cod_pro_res_post_m,0),3,'0')||';'||lpad(nvl(md3.cod_com_res_post_m,0),3,'0')||';',
                   '4;'||';'||';'||nvl(md3.cod_pro_res_post_m,0)))||';'||
-- NOME_SPOSA
       substr(mat.cognome_nome_f,instr(mat.cognome_nome_f,'/')+1)||';'||
-- COGNOME_SPOSA
       substr(mat.cognome_nome_f,1,instr(mat.cognome_nome_f,'/')-1)||';'||
-- FLAG_LUOGO_RES_SPOSA
-- PROV_RESIDENZA_SPOSA
-- COM_RESIDENZA_SPOSA
-- STATO_ESTERO_RES_SPOSA
       decode(lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_res_f,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_res_f,0),3,'0')||';'||lpad(nvl(mat.cod_com_res_f,0),3,'0')||';',
                   '3;'||';'||';'||nvl(mat.cod_pro_res_f,0)))||';'||
-- FLAG_LUOGO_NASCITA_SPOSA
-- PROV_NASC_SPOSA
-- COM_NASC_SPOSA
-- STATO_ESTERO_NASC_SPOSA
       decode(lpad(nvl(mat.cod_pro_nas_f,0),3,'0')||lpad(nvl(mat.cod_com_nas_f,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_pro_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_nas_f,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_nas_f,0),3,'0')||';'||lpad(nvl(mat.cod_com_nas_f,0),3,'0')||';',
                   '3;'||';'||';'||lpad(mat.cod_pro_nas_f,3,'0')))||';'||
-- DATA_NASC_SPOSA
       to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- STATOCIV_SPOSA
       decode(md3.stato_civile_f,'NU','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9')||';'||
-- DATA_CESS_MATR_PREC_SPOSA
       decode(md3.stato_civile_f,'NU','',to_char(to_date(md3.data_fine_mat_f,'j'),'dd/mm/yyyy'))||';'||
-- GRADO_ISTRUZIONE_SPOSA
       to_char(md3.grado_istruzione_f)||';'||
-- COND_PROF_SPOSA
       to_char(md3.condizione_prof_f)||';'||
-- POS_PROF_SPOSA
       decode(md3.condizione_prof_f,1,to_char(md3.posizione_prof_f),'')||';'||
-- RAMO_ATT_ECON_SPOSA
       decode(md3.condizione_prof_f,1,to_char(md3.attivita_prof_f),'')||';'||
-- FLAG_CITT_SPOSA
-- STATO_CITT_SPOSA
       decode(nazionalita_ita_f,1,'1;',2,'2;',3,'3;'||to_char(nvl(dci_f.ist_ci,0)),';')||';'||
-- CODFISC_SPOSA
       mat.cod_fiscale_f||';'||
-- RES_DOPO_MATR_SPOSA
-- PROVRES_SPOSA_DOPO_MATR
-- COMRES_SPOSA_DOPO_MATR
-- STATORES_SPOSA_DOPO_MATR
       decode(lpad(nvl(md3.cod_pro_res_post_f,0),3,'0')||lpad(nvl(md3.cod_com_res_post_f,0),3,'0'),
                lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
              '1;'||';'||';',
                lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
              '2;'||';'||';',
              decode(sign(nvl(md3.cod_pro_res_post_f,0)-199),
                -1,'3;'||lpad(nvl(md3.cod_pro_res_post_f,0),3,'0')||';'||lpad(nvl(md3.cod_com_res_post_f,0),3,'0')||';',
                   '4;'||';'||';'||nvl(md3.cod_pro_res_post_f,0)))||';'||
-- U_REGIME_PATR
       decode(mat.convenzioni,'SI','2','1')||';' RIGA
  from anadci dci_m, anadci dci_f, istmd3 md3, civmat mat
 where dci_m.cod_ci  (+) = mat.nazionalita_m 
   and dci_f.cod_ci  (+) = mat.nazionalita_f 
   and nvl(md3.serie_mat,' ') = nvl(mat.serie,' ') 
   and md3.parte_mat      = mat.parte 
   and md3.atto_mat       = mat.atto 
   and md3.anno_mat       = mat.anno 
   and md3.ufficio_mat    = mat.ufficio 
   and md3.flag_completo is not null
   and mat.cod_rec	 in (0,3)
/
comment on table ISTEDD3_V is 'ISTAT - Modello D.3 - Dati'
/
