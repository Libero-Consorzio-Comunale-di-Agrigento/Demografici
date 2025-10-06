--liquibase formatted sql
--changeset amonopoli:202312221025_2 runOnChange:true stripComments:false
create or replace package body ISTED7A is
PROCEDURE MAIN   (prenotazione  IN number,
                  PASSO          IN number)

is

p_prenotazione number;
p_passo        number;
P_pagina       number :=1;
P_riga         number :=0;

w_tipo_rilevazione	varchar2(255);
w_anno			number;
w_da_data		number;
w_a_data		number;

codice_istat   varchar2(10);

cursor sel_dati_MM is
select 1,
       'MESE_RIF_RISPONDENTE'||';'||
       'ANNO_RIF_RISPONDENTE'||';'||
       'MM_NATI_VIVI_UFFCILE_M'||';'||
       'MM_NATI_VIVI_UFFCILE_F'||';'||
       'MM_NATI_VIVI_COMUNE_M'||';'||
       'MM_NATI_VIVI_COMUNE_F'||';'||
       'MM_NATI_ALTRO_COMUNE_M'||';'||
       'MM_NATI_ALTRO_COMUNE_F'||';'||
       'MM_NATI_USL_M'||';'||
       'MM_NATI_USL_F'||';'||
       'MM_NATI_VIVI_TOT_GSTR_M'||';'||
       'MM_NATI_VIVI_TOT_GSTR_F'||';'||
       'MM_NATI_MORTI_IN_M'||';'||
       'MM_NATI_MORTI_IN_F'||';'||
       'MM_NATI_MORTI_OUT_M'||';'||
       'MM_NATI_MORTI_OUT_F'||';'||
       'MM_NATI_MOR_TOT_GSTR_M'||';'||
       'MM_NATI_MOR_TOT_GSTR_F'||';'||
       'MM_NATI_VIVI_IN_M'||';'||
       'MM_NATI_VIVI_IN_F'||';'||
       'MM_NATI_VIVI_OUT_M'||';'||
       'MM_NATI_VIVI_OUT_F'||';'||
       'MM_NATI_INOUT_PLURIMI_M'||';'||
       'MM_NATI_INOUT_PLURIMI_F'||';'||
       'MM_MORTI_1ANNO_M'||';'||
       'MM_MORTI_1ANNO_F'||';'||
       'MM_MORTI_2ANNO_M'||';'||
       'MM_MORTI_2ANNO_F'||';'||
       'MM_MORTI_TOT_STR_M'||';'||
       'MM_MORTI_TOT_STR_F'||';'||
       'MM_MATRIM_REL_M'||';'||
       'MM_MATRIM_CIV_M'||';'||
       'MM_MATRIM_TOT_STR'||';'||
       'MM_ART6_SEPARAZIONI'||';'||
       'MM_ART6_DIVORZI'||';'||
       'MM_ART6_CAMBIO_COND'||';'||
       'MM_ART12_SEPARAZIONI'||';'||
       'MM_ART12_DIVORZI'||';'||
       'MM_ART12_CAMBIO_COND'||';'||
       'MM_UNIONI_CIV_MM'||';'||
       'MM_UNIONI_CIV_FF'
riga
  from dual
UNION
select 2,
       ltrim(to_char(to_date(substr(tabrep.parametri,1,7),'j'),'mm'),'0')||';'||
       to_char(to_date(substr(tabrep.parametri,1,7),'j'),'yyyy')||';'||
-- 1.1   - Nati Vivi - Dichiarati all'Ufficiale
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_f, 0))||';'||
-- 1.1.1 - Nati Vivi - Dichiarati all'Ufficiale - Nati nel Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_f, 0))||';'||
-- 1.1.2 - Nati Vivi - Dichiarati all'Ufficiale - Nati in altro Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_f, 0))||';'||
-- 1.2   - Dichiarati alla Direzione Sanitaria
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_f, 0))||';'||
-- 1.3.1 - Nati Vivi - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_f, 0))||';'||
-- 2.1   - Nati Morti - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_f, 0))||';'||
-- 2.2   - Nati Morti - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_f, 0))||';'||
-- 2.3.1 - Nati Morti - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_f, 0))||';'||
-- 3.1   - Nati Vivi - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_f, 0))||';'||
-- 3.2   - Nati Vivi - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_f, 0))||';'||
-- 3.3   - Nati Vivi - da Parti Plurimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_f, 0))||';'||
-- 4.1   - Morti - nel 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_f, 0))||';'||
-- 4.2   - Morti - oltre 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_f, 0))||';'||
-- 4.3.1 - Morti - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_f, 0))||';'||
-- 5.1   - Matrimoni - Rito Religioso
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.1', d7a.totale, 0))||';'||
-- 5.2   - Matrimoni - Rito Civile
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.2', d7a.totale, 0))||';'||
-- 5.3.1 - Matrimoni - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.3.1', d7a.totale, 0))||';'||
-- 6.1   - Accordi extragiudiziali ex art. 6 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.1', d7a.totale, 0))||';'||
-- 6.2   - Accordi extragiudiziali ex art. 6 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.2', d7a.totale, 0))||';'||
--       - Accordi extragiudiziali ex art. 6 - Cambio Condizioni
       '0'||';'||
-- 7.1   - Accordi extragiudiziali ex art. 12 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.1', d7a.totale, 0))||';'||
-- 7.2   - Accordi extragiudiziali ex art. 12 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.2', d7a.totale, 0))||';'||
--       - Accordi extragiudiziali ex art. 12 - Cambio Condizioni
       '0'||';'||
-- 8.1   - Unioni Civili - maschi
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_m, 0))||';'||
-- 8.1   - Unioni Civili - femmine
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_f, 0)) riga
  from istd7a_tot d7a, tabrep
 where d7a.data_eve     between to_char(last_day(add_months(to_date(substr(tabrep.parametri,1,7),'j'),-1))+1,'j')
                            and to_char(last_day(to_date(substr(tabrep.parametri,1,7),'j')),'j')
   and tabrep.chiave 	= 'ED7A'
   and tabrep.terminale = nvl(userenv('terminal'),'ISTED7A')
 group by tabrep.parametri
 order by 1
;
cursor sel_dati_AA is
select 1,
       'AA_NATI_VIVI_UFFCILE_M'||';'||
       'AA_NATI_VIVI_UFFCILE_F'||';'||
       'AA_NATI_VIVI_COMUNE_M'||';'||
       'AA_NATI_VIVI_COMUNE_F'||';'||
       'AA_NATI_ALTRO_COMUNE_M'||';'||
       'AA_NATI_ALTRO_COMUNE_F'||';'||
       'AA_NATI_USL_M'||';'||
       'AA_NATI_USL_F'||';'||
       'AA_NATI_VIVI_TOT_GSTR_M'||';'||
       'AA_NATI_VIVI_TOT_GSTR_F'||';'||
       'AA_NATI_MORTI_IN_M'||';'||
       'AA_NATI_MORTI_IN_F'||';'||
       'AA_NATI_MORTI_OUT_M'||';'||
       'AA_NATI_MORTI_OUT_F'||';'||
       'AA_NATI_MOR_TOT_GSTR_M'||';'||
       'AA_NATI_MOR_TOT_GSTR_F'||';'||
       'AA_NATI_VIVI_IN_M'||';'||
       'AA_NATI_VIVI_IN_F'||';'||
       'AA_NATI_VIVI_OUT_M'||';'||
       'AA_NATI_VIVI_OUT_F'||';'||
       'AA_NATI_INOUT_PLURIMI_M'||';'||
       'AA_NATI_INOUT_PLURIMI_F'||';'||
       'AA_MORTI_1ANNO_M'||';'||
       'AA_MORTI_1ANNO_F'||';'||
       'AA_MORTI_2ANNO_M'||';'||
       'AA_MORTI_2ANNO_F'||';'||
       'AA_MORTI_TOT_STR_M'||';'||
       'AA_MORTI_TOT_STR_F'||';'||
       'AA_MATRIM_REL_M'||';'||
       'AA_MATRIM_CIV_M'||';'||
       'AA_MATRIM_TOT_STR_M'||';'||
       'AA_ART6_SEPARAZIONI'||';'||
       'AA_ART6_DIVORZI'||';'||
       'AA_ART6_CAMBIO_COND'||';'||
       'AA_ART12_SEPARAZIONI'||';'||
       'AA_ART12_DIVORZI'||';'||
       'AA_ART12_CAMBIO_COND'||';'||
       'AA_UNIONI_CIV_MM'||';'||
       'AA_UNIONI_CIV_FF'||';'||
       'AA_SC_UNIONI_CIV_MM'||';'||
       'AA_SC_UNIONI_CIV_FF' riga
  from dual
UNION
select 2,
-- 1.1   - Nati Vivi - Dichiarati all'Ufficiale
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_f, 0))||';'||
-- 1.1.1 - Nati Vivi - Dichiarati all'Ufficiale - Nati nel Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_f, 0))||';'||
-- 1.1.2 - Nati Vivi - Dichiarati all'Ufficiale - Nati in altro Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_f, 0))||';'||
-- 1.2   - Dichiarati alla Direzione Sanitaria
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_f, 0))||';'||
-- 1.3.1 - Nati Vivi - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_f, 0))||';'||
-- 2.1   - Nati Morti - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_f, 0))||';'||
-- 2.2   - Nati Morti - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_f, 0))||';'||
-- 2.3.1 - Nati Morti - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_f, 0))||';'||
-- 3.1   - Nati Vivi - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_f, 0))||';'||
-- 3.2   - Nati Vivi - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_f, 0))||';'||
-- 3.3   - Nati Vivi - da Parti Plurimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_f, 0))||';'||
-- 4.1   - Morti - nel 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_f, 0))||';'||
-- 4.2   - Morti - oltre 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_f, 0))||';'||
-- 4.3.1 - Morti - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_f, 0))||';'||
-- 5.1   - Matrimoni - Rito Religioso
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.1', d7a.totale, 0))||';'||
-- 5.2   - Matrimoni - Rito Civile
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.2', d7a.totale, 0))||';'||
-- 5.3.1 - Matrimoni - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.3.1', d7a.totale, 0))||';'||
-- 6.1   - Accordi extragiudiziali ex art. 6 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.1', d7a.totale, 0))||';'||
-- 6.2   - Accordi extragiudiziali ex art. 6 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.2', d7a.totale, 0))||';'||
--       - Accordi extragiudiziali ex art. 6 - Cambio Condizioni
       '0'||';'||
-- 7.1   - Accordi extragiudiziali ex art. 12 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.1', d7a.totale, 0))||';'||
-- 7.2   - Accordi extragiudiziali ex art. 12 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.2', d7a.totale, 0))||';'||
--       - Accordi extragiudiziali ex art. 12 - Cambio Condizioni
       '0'||';'||
-- 8.1   - Unioni Civili - maschi
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_m, 0))||';'||
-- 8.1   - Unioni Civili - femmine
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_f, 0))||';'||
-- 8.2   - Cessazioni di Unione Civile - maschi
       sum(decode(d7a.archivio||d7a.punto, 'SCI_AN8.2', d7a.totale_m, 0))||';'||
-- 8.2   - Cessazioni di Unione Civile - femmine
       sum(decode(d7a.archivio||d7a.punto, 'SCI_AN8.2', d7a.totale_f, 0)) riga
  from istd7a_tot d7a, tabrep
 where d7a.data_eve     between w_da_data and w_a_data
   and tabrep.chiave 	= 'ED7A'
   and tabrep.terminale = nvl(userenv('terminal'),'ISTED7A')
 group by tabrep.parametri
 order by 1
;

cursor sel_dati_MM_2024 is
select 1,
       'MESE_RIF_RISPONDENTE'||';'||
       'ANNO_RIF_RISPONDENTE'||';'||
       'MM_NATI_VIVI_UFFCILE_M'||';'||
       'MM_NATI_VIVI_UFFCILE_F'||';'||
       'MM_NATI_VIVI_COMUNE_M'||';'||
       'MM_NATI_VIVI_COMUNE_F'||';'||
       'MM_NATI_ALTRO_COMUNE_M'||';'||
       'MM_NATI_ALTRO_COMUNE_F'||';'||
       'MM_NATI_USL_M'||';'||
       'MM_NATI_USL_F'||';'||
       'MM_NATI_VIVI_TOT_GSTR_M'||';'||
       'MM_NATI_VIVI_TOT_GSTR_F'||';'||
       'MM_NATI_MORTI_IN_M'||';'||
       'MM_NATI_MORTI_IN_F'||';'||
       'MM_NATI_MORTI_OUT_M'||';'||
       'MM_NATI_MORTI_OUT_F'||';'||
       'MM_NATI_MOR_TOT_GSTR_M'||';'||
       'MM_NATI_MOR_TOT_GSTR_F'||';'||
       'MM_NATI_VIVI_IN_M'||';'||
       'MM_NATI_VIVI_IN_F'||';'||
       'MM_NATI_VIVI_OUT_M'||';'||
       'MM_NATI_VIVI_OUT_F'||';'||
       'MM_NATI_INOUT_PLURIMI_M'||';'||
       'MM_NATI_INOUT_PLURIMI_F'||';'||
       'MM_MORTI_1ANNO_M'||';'||
       'MM_MORTI_1ANNO_F'||';'||
       'MM_MORTI_2ANNO_M'||';'||
       'MM_MORTI_2ANNO_F'||';'||
       'MM_MORTI_TOT_STR_M'||';'||
       'MM_MORTI_TOT_STR_F'||';'||
       'MM_MATRIM_REL_M'||';'||
       'MM_MATRIM_CIV_M'||';'||
       'MM_MATRIM_TOT_STR'||';'||
       'MM_ART6_SEPARAZIONI'||';'||
       'MM_ART6_DIVORZI'||';'||
       'MM_ART6_SCIOGLIMENTI'||';'||
       'MM_ART12_SEPARAZIONI'||';'||
       'MM_ART12_DIVORZI'||';'||
       'MM_ART12_SCIOGLIMENTI'||';'||
       'MM_UNIONI_CIV_MM'||';'||
       'MM_UNIONI_CIV_FF'||';'||
       'MM_PROVV_SEPARAZIONI'||';'||
       'MM_PROVV_DIVORZI'||';'||
       'MM_PROVV_SCIOGLIMENTI'
riga
  from dual
UNION
select 2,
       ltrim(to_char(to_date(substr(tabrep.parametri,1,7),'j'),'mm'),'0')||';'||
       to_char(to_date(substr(tabrep.parametri,1,7),'j'),'yyyy')||';'||
-- 1.1   - Nati Vivi - Dichiarati all'Ufficiale
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_f, 0))||';'||
-- 1.1.1 - Nati Vivi - Dichiarati all'Ufficiale - Nati nel Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_f, 0))||';'||
-- 1.1.2 - Nati Vivi - Dichiarati all'Ufficiale - Nati in altro Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_f, 0))||';'||
-- 1.2   - Dichiarati alla Direzione Sanitaria
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_f, 0))||';'||
-- 1.3.1 - Nati Vivi - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_f, 0))||';'||
-- 2.1   - Nati Morti - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_f, 0))||';'||
-- 2.2   - Nati Morti - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_f, 0))||';'||
-- 2.3.1 - Nati Morti - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_f, 0))||';'||
-- 3.1   - Nati Vivi - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_f, 0))||';'||
-- 3.2   - Nati Vivi - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_f, 0))||';'||
-- 3.3   - Nati Vivi - da Parti Plurimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_f, 0))||';'||
-- 4.1   - Morti - nel 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_f, 0))||';'||
-- 4.2   - Morti - oltre 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_f, 0))||';'||
-- 4.3.1 - Morti - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_f, 0))||';'||
-- 5.1   - Matrimoni - Rito Religioso
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.1', d7a.totale, 0))||';'||
-- 5.2   - Matrimoni - Rito Civile
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.2', d7a.totale, 0))||';'||
-- 5.3.1 - Matrimoni - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.3.1', d7a.totale, 0))||';'||
-- 6.1   - Accordi extragiudiziali ex art. 6 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.1', d7a.totale, 0))||';'||
-- 6.2   - Accordi extragiudiziali ex art. 6 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.2', d7a.totale, 0))||';'||
-- 6.3   - Accordi extragiudiziali ex art. 6 - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI6.3', d7a.totale, 0))||';'||
-- 7.1   - Accordi extragiudiziali ex art. 12 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.1', d7a.totale, 0))||';'||
-- 7.2   - Accordi extragiudiziali ex art. 12 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.2', d7a.totale, 0))||';'||
-- 7.3   - Accordi extragiudiziali ex art. 12 - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI7.3', d7a.totale, 0))||';'||
-- 8.1   - Unioni Civili - maschi
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_m, 0))||';'||
-- 8.1   - Unioni Civili - femmine
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_f, 0))||';'||
-- 9.1   - Provvedimenti Tribunale / Corte d'Appello - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV9.1', d7a.totale, 0))||';'||
-- 9.2   - Provvedimenti Tribunale / Corte d'Appello - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV9.2', d7a.totale, 0))||';'||
-- 9.3   - Provvedimenti Tribunale / Corte d'Appello - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI9.3', d7a.totale, 0)) riga
  from istd7a_tot d7a, tabrep
 where d7a.data_eve     between to_char(last_day(add_months(to_date(substr(tabrep.parametri,1,7),'j'),-1))+1,'j')
                            and to_char(last_day(to_date(substr(tabrep.parametri,1,7),'j')),'j')
   and tabrep.chiave 	= 'ED7A'
   and tabrep.terminale = nvl(userenv('terminal'),'ISTED7A')
 group by tabrep.parametri
 order by 1
;
cursor sel_dati_AA_2024 is
select 1,
       'AA_NATI_VIVI_UFFCILE_M'||';'||
       'AA_NATI_VIVI_UFFCILE_F'||';'||
       'AA_NATI_VIVI_COMUNE_M'||';'||
       'AA_NATI_VIVI_COMUNE_F'||';'||
       'AA_NATI_ALTRO_COMUNE_M'||';'||
       'AA_NATI_ALTRO_COMUNE_F'||';'||
       'AA_NATI_USL_M'||';'||
       'AA_NATI_USL_F'||';'||
       'AA_NATI_VIVI_TOT_GSTR_M'||';'||
       'AA_NATI_VIVI_TOT_GSTR_F'||';'||
       'AA_NATI_MORTI_IN_M'||';'||
       'AA_NATI_MORTI_IN_F'||';'||
       'AA_NATI_MORTI_OUT_M'||';'||
       'AA_NATI_MORTI_OUT_F'||';'||
       'AA_NATI_MOR_TOT_GSTR_M'||';'||
       'AA_NATI_MOR_TOT_GSTR_F'||';'||
       'AA_NATI_VIVI_IN_M'||';'||
       'AA_NATI_VIVI_IN_F'||';'||
       'AA_NATI_VIVI_OUT_M'||';'||
       'AA_NATI_VIVI_OUT_F'||';'||
       'AA_NATI_INOUT_PLURIMI_M'||';'||
       'AA_NATI_INOUT_PLURIMI_F'||';'||
       'AA_MORTI_1ANNO_M'||';'||
       'AA_MORTI_1ANNO_F'||';'||
       'AA_MORTI_2ANNO_M'||';'||
       'AA_MORTI_2ANNO_F'||';'||
       'AA_MORTI_TOT_STR_M'||';'||
       'AA_MORTI_TOT_STR_F'||';'||
       'AA_MATRIM_REL_M'||';'||
       'AA_MATRIM_CIV_M'||';'||
       'AA_MATRIM_TOT_STR_M'||';'||
       'AA_ART6_SEPARAZIONI'||';'||
       'AA_ART6_DIVORZI'||';'||
       'AA_ART6_SCIOGLIMENTI'||';'||
       'AA_ART12_SEPARAZIONI'||';'||
       'AA_ART12_DIVORZI'||';'||
       'AA_ART12_SCIOGLIMENTI'||';'||
       'AA_UNIONI_CIV_MM'||';'||
       'AA_UNIONI_CIV_FF'||';'||
       'AA_PROVV_SEPARAZIONI'||';'||
       'AA_PROVV_DIVORZI'||';'||
       'AA_PROVV_SCIOGLIMENTI' riga
  from dual
UNION
select 2,
-- 1.1   - Nati Vivi - Dichiarati all'Ufficiale
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1', d7a.totale_f, 0))||';'||
-- 1.1.1 - Nati Vivi - Dichiarati all'Ufficiale - Nati nel Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.1', d7a.totale_f, 0))||';'||
-- 1.1.2 - Nati Vivi - Dichiarati all'Ufficiale - Nati in altro Comune
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.1.2', d7a.totale_f, 0))||';'||
-- 1.2   - Dichiarati alla Direzione Sanitaria
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.2', d7a.totale_f, 0))||';'||
-- 1.3.1 - Nati Vivi - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS1.3.1', d7a.totale_f, 0))||';'||
-- 2.1   - Nati Morti - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.1', d7a.totale_f, 0))||';'||
-- 2.2   - Nati Morti - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.2', d7a.totale_f, 0))||';'||
-- 2.3.1 - Nati Morti - da Genitori Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS2.3.1', d7a.totale_f, 0))||';'||
-- 3.1   - Nati Vivi - Legittimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.1', d7a.totale_f, 0))||';'||
-- 3.2   - Nati Vivi - Naturali
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.2', d7a.totale_f, 0))||';'||
-- 3.3   - Nati Vivi - da Parti Plurimi
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'NAS3.3', d7a.totale_f, 0))||';'||
-- 4.1   - Morti - nel 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.1', d7a.totale_f, 0))||';'||
-- 4.2   - Morti - oltre 1 anno di vita
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.2', d7a.totale_f, 0))||';'||
-- 4.3.1 - Morti - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_m, 0))||';'||
       sum(decode(d7a.archivio||d7a.punto, 'MOR4.3.1', d7a.totale_f, 0))||';'||
-- 5.1   - Matrimoni - Rito Religioso
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.1', d7a.totale, 0))||';'||
-- 5.2   - Matrimoni - Rito Civile
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.2', d7a.totale, 0))||';'||
-- 5.3.1 - Matrimoni - Stranieri
       sum(decode(d7a.archivio||d7a.punto, 'MAT5.3.1', d7a.totale, 0))||';'||
-- 6.1   - Accordi extragiudiziali ex art. 6 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.1', d7a.totale, 0))||';'||
-- 6.2   - Accordi extragiudiziali ex art. 6 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV6.2', d7a.totale, 0))||';'||
-- 6.3   - Accordi extragiudiziali ex art. 6 - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI6.3', d7a.totale, 0))||';'||
-- 7.1   - Accordi extragiudiziali ex art. 12 - Separazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.1', d7a.totale, 0))||';'||
-- 7.2   - Accordi extragiudiziali ex art. 12 - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV7.2', d7a.totale, 0))||';'||
-- 7.3   - Accordi extragiudiziali ex art. 12 - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI7.3', d7a.totale, 0))||';'||
-- 8.1   - Unioni Civili - maschi
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_m, 0))||';'||
-- 8.1   - Unioni Civili - femmine
       sum(decode(d7a.archivio||d7a.punto, 'UCI8.1', d7a.totale_f, 0))||';'||
-- 9.1   - Provvedimenti Tribunale / Corte d'Appello - Seperazioni
       sum(decode(d7a.archivio||d7a.punto, 'DIV9.1', d7a.totale, 0))||';'||
-- 9.2   - Provvedimenti Tribunale / Corte d'Appello - Divorzi
       sum(decode(d7a.archivio||d7a.punto, 'DIV9.2', d7a.totale, 0))||';'||
-- 9.3   - Provvedimenti Tribunale / Corte d'Appello - Scioglimenti
       sum(decode(d7a.archivio||d7a.punto, 'SCI9.3', d7a.totale, 0)) riga
  from istd7a_tot d7a, tabrep
 where d7a.data_eve     between w_da_data and w_a_data
   and tabrep.chiave 	= 'ED7A'
   and tabrep.terminale = nvl(userenv('terminal'),'ISTED7A')
 group by tabrep.parametri
 order by 1
;

begin
  p_prenotazione := prenotazione;
  p_passo        := passo;

  begin
    select to_char(to_date(substr(parametri,1,7),'j'),'yyyy'),
           nvl(substr(parametri,28,1),'M')
      into w_anno, w_tipo_rilevazione
      from tabrep
     where chiave    = 'ED7A'
       and terminale = nvl(userenv('terminal'),'ISTED7A')
    ;
  exception
    when others then
         w_tipo_rilevazione := 'M';
  end;

  begin
    select lpad(pro_cliente,3,'0')||lpad(com_cliente,3,'0')
      into codice_istat
      from menuditta
    ;
   exception
     when others then
          codice_istat := '';
   end;

  if w_tipo_rilevazione = 'A' then
     w_da_data := to_char(to_date('01/01/'||w_anno,'dd/mm/yyyy'),'j');
     w_a_data  := to_char(to_date('31/12/'||w_anno,'dd/mm/yyyy'),'j');

     begin
       update a_selezioni
          set valore_default = 'istatel\'||codice_istat||'_D7A_'||w_anno||'.csv'
        where parametro 	= 'TXTFILE'
          and voce_menu	= 'ISTED7A'
       ;
     end;
  else
     w_da_data := '';
     w_a_data  := '';

     begin
       update a_selezioni
          set valore_default = 'istatel\'||codice_istat||'_D7A_'||to_char(sysdate,'yymmdd')||'.csv'
        where parametro 	= 'TXTFILE'
          and voce_menu	= 'ISTED7A'
       ;
     end;
  end if;
commit;

  if w_tipo_rilevazione = 'M' then
     if w_anno >= 2024 then
        for dati in sel_dati_MM_2024 loop
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
     else
        for dati in sel_dati_MM loop
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
     end if;

  elsif w_tipo_rilevazione = 'A' then
     if w_anno >= 2024 then
        for dati in sel_dati_AA_2024 loop
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
     else
        for dati in sel_dati_AA loop
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
     end if;
  end if;
commit;

END MAIN;

FUNCTION VERSIONE  RETURN varchar2 IS
BEGIN
--
--   RETURN 'V1.0 del 29/07/2003';        Prima emissione
--   RETRUN 'V2.0 del 21/09/2017';   AM   Adeguamenti 2017 - Nuovo tracciato
--   RETRUN 'V2.1 del 11/01/2018';   AM   Adeguamenti 2018 - Nuovo tracciato
--   RETRUN 'V2.2 del 21/12/2023';   AM   Adeguamenti 2024 - Aggiunta campi x Sep. / Div. / Sci.
--   RETRUN 'V2.3 del 03/12/2024';   AM   Adeguamenti 2024 - Corretto estrazione punti 9.1, 9.2, 9.3
--
   RETURN 'V2.3 del 03/12/2024';
END VERSIONE;

END ISTED7A;
/
