--liquibase formatted sql
--changeset amonopoli:202503211245_1 runOnChange:true stripComments:false
create or replace view isteddu_v
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
-- P_ATTO_UNIONE
       md3.parte_mat||';'||
-- S_ATTO_UNIONE
       decode(md3.serie_mat,'A','1','C','2','')||';'||
-- DATA_COSTITUZIONE
       to_char(to_date(mat.data_mat,'j'),'dd/mm/yyyy')||';'||
-- U_REGIME_PATR
       decode(mat.convenzioni,'SI','2','1')||';'||
-- NOME_PARTNER1
       substr(mat.cognome_nome_m,instr(mat.cognome_nome_m,'/')+1)||';'||
-- COGNOME_PARTNER1
       substr(mat.cognome_nome_m,1,instr(mat.cognome_nome_m,'/')-1)||';'||
-- U_SESSO_PARTNER1
       decode(mat.sesso_m,'M','1','2')||';'||
-- FLAG_LUOGO_RESIDENZA_PARTNER1
-- PROV_RESIDENZA_PARTNER1
-- COMUNE_RESIDENZA_PARTNER1
-- STATO_ESTERO_RES_PARTNER1
       decode(lpad(nvl(mat.cod_pro_res_m,0),3,'0')||lpad(nvl(mat.cod_com_res_m,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_res_m,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_res_m,0),3,'0')||';'||lpad(nvl(mat.cod_com_res_m,0),3,'0')||';',
                   '3;'||';'||';'||nvl(mat.cod_pro_res_m,0)))||';'||
-- FLAG_LUOGO_NASCITA_PARTNER1
-- PROV_NASC_PARTNER1
-- COM_NASC_PARTNER1
-- STATO_ESTERO_NASC_PARTNER1
       decode(lpad(nvl(mat.cod_pro_nas_m,0),3,'0')||lpad(nvl(mat.cod_com_nas_m,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_nas_m,0)-199),
                -1,'2;'||lpad(mat.cod_pro_nas_m,3,'0')||';'||lpad(mat.cod_com_nas_m,3,'0')||';',
                   '3;'||';'||';'||lpad(mat.cod_pro_nas_m,3,'0')))||';'||
-- DATA_NASC_PARTNER1
       to_char(to_date(mat.data_nas_m,'j'),'dd/mm/yyyy')||';'||
-- STATOCIV_PARTNER1
       decode(md3.stato_civile_m,'CE','1','NU','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9')||';'||
-- TITOLO_STUDIO_PARTNER1
       to_char(md3.grado_istruzione_m)||';'||
-- POS_PROF_PARTNER1
       decode(md3.condizione_prof_m,1,to_char(md3.posizione_prof_m),'')||';'||
-- COND_PROF_PARTNER1
       to_char(md3.condizione_prof_m)||';'||
-- FLAG_CITT_PARTNER1
       decode(nazionalita_ita_m,1,'1',2,'2','3')||';'||
-- DATA_CITT_PARTNER1
       decode(nazionalita_ita_m,2,to_char(to_date(data_nazionalita_m,'j'),'dd/mm/yyyy'))||';'||
-- STATO_CITT_PARTNER1
       decode(nazionalita_ita_m,1,'',2,'',to_char(nvl(dci_m.ist_ci,0)))||';'||
-- CODFISC_PARTNER1
       mat.cod_fiscale_m||';'||
-- NOME_PARTNER2
       substr(mat.cognome_nome_f,instr(mat.cognome_nome_f,'/')+1)||';'||
-- COGNOME_PARTNER2
       substr(mat.cognome_nome_f,1,instr(mat.cognome_nome_f,'/')-1)||';'||
-- U_SESSO_PARTNER2
       decode(mat.sesso_f,'M','1','2')||';'||
-- FLAG_LUOGO_RES_PARTNER2
-- PROV_RESIDENZA_PARTNER2
-- COM_RESIDENZA_PARTNER2
-- STATO_ESTERO_RES_PARTNER2
       decode(lpad(nvl(mat.cod_pro_res_f,0),3,'0')||lpad(nvl(mat.cod_com_res_f,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_com_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_res_f,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_res_f,0),3,'0')||';'||lpad(nvl(mat.cod_com_res_f,0),3,'0')||';',
                   '3;'||';'||';'||nvl(mat.cod_pro_res_f,0)))||';'||
-- FLAG_LUOGO_NASCITA_PARTNER2
-- PROV_NASC_PARTNER2
-- COM_NASC_PARTNER2
-- STATO_ESTERO_NASC_PARTNER2
       decode(lpad(nvl(mat.cod_pro_nas_f,0),3,'0')||lpad(nvl(mat.cod_com_nas_f,0),3,'0'),
                lpad(nvl(mat.cod_pro_mat,0),3,'0')||lpad(nvl(mat.cod_pro_mat,0),3,'0'),
              '1;'||';'||';',
              decode(sign(nvl(mat.cod_pro_nas_f,0)-199),
                -1,'2;'||lpad(nvl(mat.cod_pro_nas_f,0),3,'0')||';'||lpad(nvl(mat.cod_com_nas_f,0),3,'0')||';',
                   '3;'||';'||';'||lpad(mat.cod_pro_nas_f,3,'0')))||';'||
-- DATA_NASC_PARTNER2
       to_char(to_date(mat.data_nas_f,'j'),'dd/mm/yyyy')||';'||
-- STATOCIV_PARTNER2
       decode(md3.stato_civile_f,'CE','1','NU','1','CN','2','VE','3','GC','4','DV','4','UC','6','VU','7','GU','8','9')||';'||
-- TITOLO_STUDIO_PARTNER2
       to_char(md3.grado_istruzione_f)||';'||
-- POS_PROF_PARTNER2
       decode(md3.condizione_prof_f,1,to_char(md3.posizione_prof_f),'')||';'||
-- COND_PROF_PARTNER2
       to_char(md3.condizione_prof_f)||';'||
-- FLAG_CITT_PARTNER2
       decode(nazionalita_ita_f,1,'1',2,'2','3')||';'||
-- DATA_CITT_PARTNER2
       decode(nazionalita_ita_f,2,to_char(to_date(data_nazionalita_f,'j'),'dd/mm/yyyy'))||';'||
-- STATO_CITT_PARTNER2
       decode(nazionalita_ita_f,1,'',2,'',to_char(nvl(dci_f.ist_ci,0)))||';'||
-- CODFISC_PARTNER2
       mat.cod_fiscale_f RIGA
  from anadci dci_m, anadci dci_f, istmdu md3, civuci mat
 where dci_m.cod_ci  (+) = mat.nazionalita_m 
   and dci_f.cod_ci  (+) = mat.nazionalita_f 
   and nvl(md3.serie_mat,' ') = nvl(mat.serie,' ') 
   and nvl(md3.parte_mat,0)   = nvl(mat.parte,0) 
   and md3.atto_mat       = mat.atto 
   and md3.anno_mat       = mat.anno 
   and md3.ufficio_mat    = mat.ufficio 
   and md3.flag_completo is not null
   and mat.cod_rec	 in (0,3)
/
comment on table isteddu_v is 'ISTAT - Modello D.3.U - Dati'
/
