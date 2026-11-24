--liquibase formatted sql
--changeset amonopoli:202601230855_2 runOnChange:true stripComments:false
create or replace view anawpm_SAP4_zk
       (anagrafe, tipo_evento, anno_dic, numero_dic, matricola,
        p1_1, p1_2, p1_3, p1_4,
        p2_0, p2_1, p2_2, p2_3, p2_4, p2_5,
        p3_1, p3_2, p3_3, p3_4, p3_5, p3_6, p3_7, p3_8, 
        p4_1, p4_2, p4_3, p4_4,
        p5_1, p5_2, p5_3, 
        p6_1, p6_2, p6_3, p6_4, p6_5, p6_6, p6_7, p6_8,
        p7_1, p7_2, p7_3, p7_4, p7_5,
        p8_1, p8_2, p8_3, p8_4, p8_5,
        p9_1, p9_2, p9_3, p9_4, p9_5, p9_6, p9_7, p9_8,
        ID, ID_DICHIARAZIONE,
        anno_pratica, pratica, id_anatpr)
AS
select 'RES', ISCR_CANC, ANNO_DIC, NUMERO_DIC, MATRICOLA, 
       NUMERO_ORDINE, COGNOME, NOME,
       f_espandi_stringa(COD_FISCALE,1,' '),
--       f_espandi_stringa(IST_RP,3,' '),
       nuovo_rapporto_par,
       ist_rp,
       f_espandi_stringa(DATA_NAS,1,' '),
       DES_COM_NAS, 
       f_espandi_stringa(COD_PRO_NAS,5,' '),
       f_espandi_stringa(COD_COM_NAS,3,' '),
       DES_ATTO_NAS, DES_COM_ATTO_NAS, SESSO_1, SESSO_2, 
       STATO_CIVILE_1, STATO_CIVILE_2, STATO_CIVILE_3, STATO_CIVILE_4, 
       COGNOME_NOME_CN, DES_COM_MAT, DES_ATTO_MAT, 
       f_espandi_stringa(DATA_MAT,1,' '),
       DES_COM_VED, 
       f_espandi_stringa(DATA_VED_DIV,1,' '),
       DES_ATTO_TR,
       CITTADINANZA_1, CITTADINANZA_2, DES_NAZIONALITA, 
       f_espandi_stringa(NAZIONALITA,1,' '),
       NUMERO_CI, 
       f_espandi_stringa(DATA_RILASCIO_CI,1,' '),
       ESPATRIO_1, ESPATRIO_2, 
       POSIZIONE_PROF_1, POSIZIONE_PROF_2, POSIZIONE_PROF_3, POSIZIONE_PROF_4, POSIZIONE_PROF_5, 
       CONDIZIONE_NP_1, CONDIZIONE_NP_2, CONDIZIONE_NP_3, CONDIZIONE_NP_4, CONDIZIONE_NP_5, 
       TITOLO_STUDIO_1, TITOLO_STUDIO_2, TITOLO_STUDIO_3, TITOLO_STUDIO_4, TITOLO_STUDIO_5, TITOLO_STUDIO_6, 
       PATERNITA, MATERNITA,
       v.id, 
       f_ANA_get_id_pratica('RES',iscr_canc,anno_dic,numero_dic) id_dichiarazione,
       tpr.anno_pratica, tpr.pratica, tpr.id id_anatpr
from anatpr tpr,
(
select 'I' iscr_canc, apm.anno_dic, apm.numero_dic, apm.matricola, ap4.anno_pratica, ap4.pratica,
-- p1
       apm.numero_ordine,
       substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1) cognome,
       substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1) nome,
       nvl(ana.cod_fiscale,' ') cod_fiscale,
-- p2       
       apm.nuovo_rapporto_par,
       apm.ist_rp,
       decode(ana.anno_nas,'S',
         '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
         to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy')) data_nas,
       nvl(a_sto.descrizione,nvl(a.descrizione,' ')) des_com_nas,
       nvl(lpad(a_sto.cod_provincia,3,0),lpad(a.cod_provincia,3,0)) cod_pro_nas,
       nvl(lpad(a_sto.cod_comune,3,0),lpad(a.cod_comune,3,0)) cod_com_nas,
-- p3
       decode(ana.atto_nas_digitale,'',
         rpad(ana.atto_nas,5,' ')||
           decode(ana.parte_nas,'',' ',to_char(ana.parte_nas))||
           nvl(ana.serie_nas,' ')||'  '||
           decode(ana.ufficio_nas,'',' ',to_char(ana.ufficio_nas))||'  '||
           nvl(ana.anno_atto_nas,''),
         ana.atto_nas_digitale) des_atto_nas,
--       nvl(b_sto.descrizione,nvl(b.descrizione,' ')) des_com_atto_nas,
       nvl(b.descrizione,' ') des_com_atto_nas,
       decode(ana.sesso,'M','X') sesso_1,
       decode(ana.sesso,'F','X') sesso_2,
       decode(ana.stato_civile,'CE','X','NU','X') stato_civile_1,
       decode(ana.stato_civile,'CN','X') stato_civile_2,
       decode(ana.stato_civile,'VE','X') stato_civile_3,
       decode(ana.stato_civile,'DV','X','GC','X') stato_civile_4,
-- p4       
       nvl(translate(ana.cognome_nome_cn,'/',' '),' ') cognome_nome_cn,
       nvl(c_sto.descrizione,nvl(c.descrizione,' ')) des_com_mat,
       decode(ana.atto_mat_digitale,'',
         rpad(ana.atto_mat,5,' ')||
           decode(ana.parte_mat,'',' ',to_char(ana.parte_mat))||
           nvl(ana.serie_mat,' ')||' '||nvl(ana.ufficio_mat,''),
         ana.atto_mat_digitale) des_atto_mat,
       decode(ana.anno_mat,'S',
         '00/00/'||to_char(to_date(ana.data_mat,'j'),'yyyy'),
         to_char(to_date(ana.data_mat,'j'),'dd/mm/yyyy')) data_mat,
-- p5
       decode(ana.stato_civile,'VE',nvl(d_sto.descrizione,nvl(d.descrizione,' ')),' ') des_com_ved,
       decode(ana.stato_civile,
         'VE',to_char(to_date(ana.data_ved,'j'),'dd/mm/yyyy'),
         'DV',to_char(to_date(nvl(ana.data_div_ann,ana.data_div),'j'),'dd/mm/yyyy'),
         'GC',to_char(to_date(nvl(ana.data_div_ann,ana.data_div),'j'),'dd/mm/yyyy')) data_ved_div,
       decode(ana.stato_civile,
         'CN',decode(ana.atto_mat_tr_digitale,'',
                rpad(ana.atto_mat_tr,5,' ')||' '||
                  decode(ana.parte_mat_tr,'',' ',to_Char(ana.parte_mat_tr))||
                  nvl(ana.serie_mat_tr,' ')||' '||
                  decode(ana.ufficio_mat_tr,'',' ',to_char(ana.ufficio_mat_tr))||' '||
                  lpad(ana.anno_atto_mat_tr,4,' '),
                ana.atto_mat_tr_digitale),
         'VE',decode(ana.atto_ved_digitale,'',
                rpad(ana.atto_ved,5,' ')||' '||
                  decode(ana.parte_ved,'',' ',to_char(ana.parte_ved))||
                  nvl(ana.serie_ved,' ')||' '||
                  decode(ana.ufficio_ved,'',' ',to_char(ana.ufficio_ved))||' '||
                  lpad(ana.anno_atto_ved,4,' '),
                ana.atto_ved_digitale),
         'DV',decode(ana.atto_div_digitale,'',
                rpad(ana.atto_div,5,' ')||' '||
                  decode(ana.parte_div,'',' ',to_char(ana.parte_div))||
                  nvl(ana.serie_div,' ')||' '||
                  decode(ana.ufficio_div,'',' ',to_char(ana.ufficio_div))||' '||
                  lpad(ana.anno_atto_div,4,' ')||'-'||
                  nvl(nvl(e_sto.descrizione,nvl(e.descrizione,' ')),
                    nvl(f_sto.descrizione,nvl(f.descrizione,' '))),
                ana.atto_div_digitale),
         'GC',decode(ana.atto_div_digitale,'',
                rpad(ana.atto_div,5,' ')||' '||
                  decode(ana.parte_div,'',' ',to_char(ana.parte_div))||
                  nvl(ana.serie_div,' ')||' '||
                  decode(ana.ufficio_div,'',' ',to_char(ana.ufficio_div))||' '||
                  lpad(ana.anno_atto_div,4,' ')||'-'||
                  nvl(nvl(e_sto.descrizione,nvl(e.descrizione,' ')),
                    nvl(f_sto.descrizione,nvl(f.descrizione,' '))),
                ana.atto_div_digitale)) des_atto_tr,
-- p6
       decode(ana.nazionalita,'I','X') cittadinanza_1,
       decode(ana.nazionalita,'I','','X') cittadinanza_2,
       decode(ana.nazionalita,'I','', dci.descrizione) des_nazionalita,
       decode(dci.ist_ci,'',ana.nazionalita,to_char(dci.ist_ci)) nazionalita,
       wdi.numero_di numero_ci,
       to_char(to_date(wdi.data_emissione_di,'j'),'dd/mm/yyyy') data_rilascio_ci,
       decode(wdi.numero_di,'','', decode(wdi.val_espatrio_di,'S','X')) espatrio_1,
       decode(wdi.numero_di,'','', decode(wdi.val_espatrio_di,'S','','X')) espatrio_2,
-- p7
       decode(ana.posizione_prof,'1','X') posizione_prof_1,
       decode(ana.posizione_prof,'2','X') posizione_prof_2,
       decode(ana.posizione_prof,'3','X') posizione_prof_3,
       decode(ana.posizione_prof,'4','X') posizione_prof_4,
       decode(ana.posizione_prof,'5','X') posizione_prof_5,
-- p8
       decode(apm.ist_np,1,'X') condizione_np_1,
       decode(apm.ist_np,2,'X') condizione_np_2,
       decode(apm.ist_np,3,'X') condizione_np_3,
       decode(apm.ist_np,4,'X') condizione_np_4,
       decode(apm.ist_np,5,'X') condizione_np_5,
-- p9
       decode(apm.ist_ts,1,'X') titolo_studio_1,
       decode(apm.ist_ts,2,'X') titolo_studio_2,
       decode(apm.ist_ts,3,'X') titolo_studio_3,
       decode(apm.ist_ts,4,'X') titolo_studio_4,
       decode(apm.ist_ts,5,'X') titolo_studio_5,
       decode(apm.ist_ts,6,'X') titolo_studio_6,
       replace(substr(nvl(ana.paternita,' '),1,27),'/',' ') paternita,
       replace(substr(ana.maternita,1,27),'/',' ') maternita,
       'APM'||lpad(apm.id,10,'0') id
  from arccom a, arccom b, arccom c, arccom d, arccom e, arccom f,
       arccom_storico a_sto, 
--       arccom_storico b_sto, 
       arccom_storico c_sto,
       arccom_storico d_sto, arccom_storico e_sto, arccom_storico f_sto,
       anadci dci, anawdi wdi, anaana ana, anaapm apm, anaap4 ap4
 where a.cod_provincia (+)      = ana.cod_pro_nas
   and a.cod_comune    (+)      = ana.cod_com_nas
   and b.cod_provincia (+)      = ana.cod_pro_atto_nas
   and b.cod_comune    (+)      = ana.cod_com_atto_nas
   and c.cod_provincia (+)      = ana.cod_pro_mat
   and c.cod_comune    (+)      = ana.cod_com_mat
   and d.cod_provincia (+)      = ana.cod_pro_ved
   and d.cod_comune    (+)      = ana.cod_com_ved
   and e.cod_provincia (+)      = ana.cod_pro_atto_div
   and e.cod_comune    (+)      = ana.cod_com_atto_div
   and f.cod_provincia (+)      = ana.cod_pro_div
   and f.cod_comune    (+)      = ana.cod_com_div
   and a_sto.cod_provincia (+)      = ana.cod_pro_nas
   and a_sto.cod_comune    (+)      = ana.cod_com_nas
   and ana.data_nas  between nvl(a_sto.data_inizio_validita,1111111)
                         and nvl(a_sto.data_fine_validita,9999999)
--   and b_sto.cod_provincia (+)      = ana.cod_pro_atto_nas
--   and b_sto.cod_comune    (+)      = ana.cod_com_atto_nas
--   and ana.data_nas  between nvl(b_sto.data_inizio_validita,1111111)
--                         and nvl(b_sto.data_fine_validita,9999999)
   and c_sto.cod_provincia (+)      = ana.cod_pro_mat
   and c_sto.cod_comune    (+)      = ana.cod_com_mat
   and ((ana.data_mat  between nvl(c_sto.data_inizio_validita,1111111) and nvl(c_sto.data_fine_validita,9999999) 
         and ana.data_mat is not null) 
        or ana.data_mat is null)
   and d_sto.cod_provincia (+)      = ana.cod_pro_ved
   and d_sto.cod_comune    (+)      = ana.cod_com_ved
   and ((ana.data_ved  between nvl(d_sto.data_inizio_validita,1111111) and nvl(d_sto.data_fine_validita,9999999) 
         and ana.data_ved is not null) 
        or ana.data_ved is null)
   and e_sto.cod_provincia (+)      = ana.cod_pro_atto_div
   and e_sto.cod_comune    (+)      = ana.cod_com_atto_div
   and ((ana.data_div  between nvl(e_sto.data_inizio_validita,1111111) and nvl(e_sto.data_fine_validita,9999999) 
         and ana.data_div is not null) 
        or ana.data_div is null)
   and f_sto.cod_provincia (+)      = ana.cod_pro_div
   and f_sto.cod_comune    (+)      = ana.cod_com_div
   and ((ana.data_div  between nvl(f_sto.data_inizio_validita,1111111) and nvl(f_sto.data_fine_validita,9999999) 
         and ana.data_div is not null) 
        or ana.data_div is null)                           
   and dci.cod_ci         (+)   = ana.nazionalita
   and wdi.matricola      (+)   = ana.matricola
   and ana.matricola            = apm.matricola
   and apm.annullamento         is null
   and apm.numero_ordine is not null
   and apm.anno_dic             = ap4.anno_dic
   and apm.numero_dic		= ap4.numero_dic
UNION        
select 'C', cpm.anno_dic, cpm.numero_dic, cpm.matricola, cp4.anno_pratica, cp4.pratica,
-- p1
       cpm.numero_ordine,
--       decode(cp4.provvedimento,5,to_char(null),
--         substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1)) cognome,
	substr(ana.cognome_nome,1,instr(ana.cognome_nome,'/')-1) cognome,
--       decode(cp4.provvedimento,5,to_char(null),
--         substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1)) nome,
	substr(ana.cognome_nome,instr(ana.cognome_nome,'/')+1) nome,
       nvl(ana.cod_fiscale,' ') cod_fiscale,
-- p2       
       decode(cp4.provvedimento,5,to_char(null),ana.rapporto_par) rapporto_par,
       cpm.ist_rp,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.anno_nas,'S',
           '00/00/'||to_char(to_date(ana.data_nas,'j'),'yyyy'),
           to_char(to_date(ana.data_nas,'j'),'dd/mm/yyyy'))) data_nas,
       decode(cp4.provvedimento,5,to_char(null),
         nvl(a_sto.descrizione,nvl(a.descrizione,' '))) des_com_nas,
       decode(cp4.provvedimento,5,to_char(null),
         nvl(lpad(a_sto.cod_provincia,3,0),lpad(a.cod_provincia,3,0))) cod_pro_nas,
       decode(cp4.provvedimento,5,to_char(null),
         nvl(lpad(a_sto.cod_comune,3,0),lpad(a.cod_comune,3,0))) cod_com_nas,
-- p3
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.atto_nas_digitale,'',
           rpad(ana.atto_nas,5,' ')||
             decode(ana.parte_nas,'',' ',to_char(ana.parte_nas))||
             nvl(ana.serie_nas,' ')||'  '||
             decode(ana.ufficio_nas,'',' ',to_char(ana.ufficio_nas))||'  '||
             nvl(ana.anno_atto_nas,''),
           ana.atto_nas_digitale)) des_atto_nas,
       decode(cp4.provvedimento,5,to_char(null),
--         nvl(b_sto.descrizione,nvl(b.descrizione,' '))) des_com_atto_nas,
         nvl(b.descrizione,' ')) des_com_atto_nas,
--       decode(cp4.provvedimento,5,to_char(null),decode(ana.sesso,'M','X')) sesso_1,
       decode(ana.sesso,'M','X') sesso_1,
--       decode(cp4.provvedimento,5,to_char(null),decode(ana.sesso,'F','X')) sesso_2,
       decode(ana.sesso,'F','X') sesso_2,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.stato_civile,'CE','X','NU','X')) stato_civile_1,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.stato_civile,'CN','X')) stato_civile_2,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.stato_civile,'VE','X')) stato_civile_3,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.stato_civile,'DV','X','GC','X')) stato_civile_4,
-- p4       
       decode(cp4.provvedimento,5,to_char(null),
         nvl(translate(ana.cognome_nome_cn,'/',' '),' ')) cognome_nome_cn,
       decode(cp4.provvedimento,5,to_char(null),
         nvl(c_sto.descrizione,nvl(c.descrizione,' '))) des_com_mat,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.atto_mat_digitale,'',
           rpad(ana.atto_mat,5,' ')||
             decode(ana.parte_mat,'',' ',to_char(ana.parte_mat))||
             nvl(ana.serie_mat,' ')||' '||nvl(ana.ufficio_mat,''),
           ana.atto_mat_digitale)) des_atto_mat,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.anno_mat,'S',
           '00/00/'||to_char(to_date(ana.data_mat,'j'),'yyyy'),
           to_char(to_date(ana.data_mat,'j'),'dd/mm/yyyy'))) data_mat,
-- p5
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.stato_civile,'VE',nvl(d_sto.descrizione,nvl(d.descrizione,' ')),' ')) des_com_ved,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.stato_civile,
           'VE',to_char(to_date(ana.data_ved,'j'),'dd/mm/yyyy'),
           'DV',to_char(to_date(nvl(ana.data_div_ann,ana.data_div),'j'),'dd/mm/yyyy'),
           'GC',to_char(to_date(nvl(ana.data_div_ann,ana.data_div),'j'),'dd/mm/yyyy'))) data_ved_div,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.stato_civile,
          'CN',decode(ana.atto_mat_tr_digitale,'',
                 rpad(ana.atto_mat_tr,5,' ')||' '||
                   decode(ana.parte_mat_tr,'',' ',to_Char(ana.parte_mat_tr))||
                   nvl(ana.serie_mat_tr,' ')||' '||
                   decode(ana.ufficio_mat_tr,'',' ',to_char(ana.ufficio_mat_tr))||' '||
                   lpad(ana.anno_atto_mat_tr,4,' '),
                 ana.atto_mat_tr_digitale),
          'VE',decode(ana.atto_ved_digitale,'',
                 rpad(ana.atto_ved,5,' ')||' '||
                   decode(ana.parte_ved,'',' ',to_char(ana.parte_ved))||
                   nvl(ana.serie_ved,' ')||' '||
                   decode(ana.ufficio_ved,'',' ',to_char(ana.ufficio_ved))||' '||
                   lpad(ana.anno_atto_ved,4,' '),
                 ana.atto_ved_digitale),
          'DV',decode(ana.atto_div_digitale,'',
                 rpad(ana.atto_div,5,' ')||' '||
                   decode(ana.parte_div,'',' ',to_char(ana.parte_div))||
                   nvl(ana.serie_div,' ')||' '||
                   decode(ana.ufficio_div,'',' ',to_char(ana.ufficio_div))||' '||
                   lpad(ana.anno_atto_div,4,' ')||'-'||
                   nvl(nvl(e_sto.descrizione,nvl(e.descrizione,' ')),
                     nvl(f_sto.descrizione,nvl(f.descrizione,' '))),
                 ana.atto_div_digitale),
          'GC',decode(ana.atto_div_digitale,'',
                 rpad(ana.atto_div,5,' ')||' '||
                   decode(ana.parte_div,'',' ',to_char(ana.parte_div))||
                   nvl(ana.serie_div,' ')||' '||
                   decode(ana.ufficio_div,'',' ',to_char(ana.ufficio_div))||' '||
                   lpad(ana.anno_atto_div,4,' ')||'-'||
                   nvl(nvl(e_sto.descrizione,nvl(e.descrizione,' ')),
                     nvl(f_sto.descrizione,nvl(f.descrizione,' '))),
                ana.atto_div_digitale))) des_atto_tr,
-- p6
       decode(ana.nazionalita,'I','X') cittadinanza_1,
       decode(ana.nazionalita,'I','','X') cittadinanza_2,
       decode(cp4.provvedimento,5,to_char(null),
         decode(ana.nazionalita,'I','', dci.descrizione)) des_nazionalita,
       decode(dci.ist_ci,'',ana.nazionalita,to_char(dci.ist_ci)) nazionalita,
       decode(cp4.provvedimento,5,to_char(null),wdi.numero_di) numero_ci,
       decode(cp4.provvedimento,5,to_char(null),
         to_char(to_date(wdi.data_emissione_di,'j'),'dd/mm/yyyy')) data_rilascio_ci,
       decode(cp4.provvedimento,5,to_char(null),
         decode(wdi.numero_di,'','', decode(wdi.val_espatrio_di,'S','X'))) espatrio_1,
       decode(cp4.provvedimento,5,to_char(null),
         decode(wdi.numero_di,'','', decode(wdi.val_espatrio_di,'S','','X'))) espatrio_2,
-- p7
       decode(cp4.provvedimento,5,to_char(null),decode(ana.posizione_prof,'1','X')) posizione_prof_1,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.posizione_prof,'2','X')) posizione_prof_2,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.posizione_prof,'3','X')) posizione_prof_3,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.posizione_prof,'4','X')) posizione_prof_4,
       decode(cp4.provvedimento,5,to_char(null),decode(ana.posizione_prof,'5','X')) posizione_prof_5,
-- p8
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_np,1,'X')) condizione_np_1,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_np,2,'X')) condizione_np_2,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_np,3,'X')) condizione_np_3,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_np,4,'X')) condizione_np_4,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_np,5,'X')) condizione_np_5,
-- p9
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,1,'X')) titolo_studio_1,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,2,'X')) titolo_studio_2,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,3,'X')) titolo_studio_3,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,4,'X')) titolo_studio_4,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,5,'X')) titolo_studio_5,
       decode(cp4.provvedimento,5,to_char(null),decode(cpm.ist_ts,6,'X')) titolo_studio_6,
       decode(cp4.provvedimento,5,to_char(null),replace(substr(nvl(ana.paternita,' '),1,27),'/',' ')) paternita,
       decode(cp4.provvedimento,5,to_char(null),replace(substr(ana.maternita,1,27),'/',' ')) maternita,
       'CPM'||lpad(rownum,10,'0') id
  from arccom a, arccom b, arccom c, arccom d, arccom e, arccom f,
       arccom_storico a_sto, 
--       arccom_storico b_sto, 
       arccom_storico c_sto,
       arccom_storico d_sto, arccom_storico e_sto, arccom_storico f_sto,
       anadci dci, anawdi wdi, anaana ana, anacpm cpm, anacp4 cp4
 where a.cod_provincia (+)      = ana.cod_pro_nas
   and a.cod_comune    (+)      = ana.cod_com_nas
   and b.cod_provincia (+)      = ana.cod_pro_atto_nas
   and b.cod_comune    (+)      = ana.cod_com_atto_nas
   and c.cod_provincia (+)      = ana.cod_pro_mat
   and c.cod_comune    (+)      = ana.cod_com_mat
   and d.cod_provincia (+)      = ana.cod_pro_ved
   and d.cod_comune    (+)      = ana.cod_com_ved
   and e.cod_provincia (+)      = ana.cod_pro_atto_div
   and e.cod_comune    (+)      = ana.cod_com_atto_div
   and f.cod_provincia (+)      = ana.cod_pro_div
   and f.cod_comune    (+)      = ana.cod_com_div
   and a_sto.cod_provincia (+)      = ana.cod_pro_nas
   and a_sto.cod_comune    (+)      = ana.cod_com_nas
   and ana.data_nas  between nvl(a_sto.data_inizio_validita,1111111)
                         and nvl(a_sto.data_fine_validita,9999999)
--   and b_sto.cod_provincia (+)      = ana.cod_pro_atto_nas
--   and b_sto.cod_comune    (+)      = ana.cod_com_atto_nas
--   and ana.data_nas  between nvl(b_sto.data_inizio_validita,1111111)
--                         and nvl(b_sto.data_fine_validita,9999999)
   and c_sto.cod_provincia (+)      = ana.cod_pro_mat
   and c_sto.cod_comune    (+)      = ana.cod_com_mat
   and ((ana.data_mat  between nvl(c_sto.data_inizio_validita,1111111) and nvl(c_sto.data_fine_validita,9999999) 
         and ana.data_mat is not null) 
        or ana.data_mat is null)
   and d_sto.cod_provincia (+)      = ana.cod_pro_ved
   and d_sto.cod_comune    (+)      = ana.cod_com_ved
   and ((ana.data_ved  between nvl(d_sto.data_inizio_validita,1111111) and nvl(d_sto.data_fine_validita,9999999) 
         and ana.data_ved is not null) 
        or ana.data_ved is null)
   and e_sto.cod_provincia (+)      = ana.cod_pro_atto_div
   and e_sto.cod_comune    (+)      = ana.cod_com_atto_div
   and ((ana.data_div  between nvl(e_sto.data_inizio_validita,1111111) and nvl(e_sto.data_fine_validita,9999999) 
         and ana.data_div is not null) 
        or ana.data_div is null)
   and f_sto.cod_provincia (+)      = ana.cod_pro_div
   and f_sto.cod_comune    (+)      = ana.cod_com_div
   and ((ana.data_div  between nvl(f_sto.data_inizio_validita,1111111) and nvl(f_sto.data_fine_validita,9999999) 
         and ana.data_div is not null) 
        or ana.data_div is null)                           
   and dci.cod_ci         (+)   = ana.nazionalita
   and wdi.matricola      (+)   = ana.matricola
   and ana.matricola            = cpm.matricola
   and ((nvl(cp4.provvedimento,0) != 5 and cpm.flag_soggetto = 'S' and cpm.annullamento is null)
        or (cp4.provvedimento = 5 and cpm.flag_ripristino = 'S'))
   and cpm.numero_ordine is not null
   and cpm.anno_dic             = cp4.anno_dic
   and cpm.numero_dic		= cp4.numero_dic
) v
 where tpr.anno_pratica = v.anno_pratica
   and tpr.pratica      = v.pratica
   and tpr.tipo_evento  = v.iscr_canc
   and tpr.anagrafe     = 'RES'
/
comment on table anawpm_SAP4_zk is 'Anagrafe - Dati Modello APR/4 (soggetti) per Stampa - ZK (view)'
/
