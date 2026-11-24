--liquibase formatted sql
--changeset amonopoli:202503250850_1 runOnChange:true stripComments:false
create or replace function f_SCAW_tessera_ele
(a_matricola		IN	number
,a_tessera		IN	number
,a_data_tessera		IN	number
)
return varchar2

IS

w_flag_giacenza		varchar2(255);
w_tessera		varchar2(255);

begin
  w_tessera := a_tessera;

  if a_matricola    is not null and
     a_tessera      is not null and
     a_data_tessera is not null
  then
     begin
       select flag_giacenza
         into w_flag_giacenza
         from eletee
        where matricola    = a_matricola
          and tessera      = a_tessera
          and data_tessera = a_data_tessera
          and rownum = 1
       ;
       if nvl(w_flag_giacenza,'N') = 'S' then
          w_tessera := w_tessera||' (in giacenza)';
       end if;
     exception
       when others then
            null;
     end;
  end if;

  return w_tessera;

end;
/
create or replace view anawmo
        (ANNO_PROGR_MOV, NUMERO_PROGR_MOV,
	 MATRICOLA, COD_MOV, COD_EVE,
	 NUCLEO_PARTENZA, NUCLEO_ARRIVO, COGNOME_NOME_PREC,
	 COD_VIA_PREC, DES_COD_VIA_PREC,
	 TIT_STUDIO_PREC, TITOLO_STUDIO_PREC, COD_PROF_PREC, DES_COD_PROF_PREC,
	 NAZIONALITA, NAZIONALITA_PREC, STATO_CIV, STATO_CIV_PREC,
	 PATERNITA, PATERNITA_PREC, MATERNITA, MATERNITA_PREC,
	 DATA_NAS_PREC, DATA_NAS_PREC_EDIT, DES_COM_NAS_PREC, SESSO_PREC,
 	 VIA_AIRE_PREC, DES_VIA_AIRE_PREC, DES_COM_AIRE_PREC,
         ZIPCODE_PREC, PROVINCIA_CONTEA_PREC, PRESSO_PREC,
	 DES_CONSOLATO_1_PREC, DES_CONSOLATO_2_PREC, DES_CONSOLATO_3_PREC,
	 COGNOME_NOME, SESSO, DI_SESSO, DATA_NAS, DATA_NAS_EDIT, DES_COM_NAS,
	 ATTO_NAS, RAPPORTO_PAR, STATO_CIVILE, COGNOME_NOME_CN, COGNOME_NOME_CN_PREC,
	 DATA_MAT_VED, ATTO_MAT_VED,
	 COD_VIA, DES_COD_VIA_CHIUSURA, DES_COD_VIA, INDIRIZZO_EMI,
 	 TIT_STUDIO, TITOLO_STUDIO, COD_PROF, DES_COD_PROF,
	 DES_NAZIONALITA, DATA_INIZIO_NAZ,
         DES_NAZIONALITA_PREC,  DATA_INIZIO_NAZ_PREC,
         DES_STATO_CIV, DES_STATO_CIV_PREC,
	 DATA_EVE, CAP_COM_EVE, DES_COM_EVE, PRATICA_EVE, ANNO_PRATICA_EVE, PRATICA_EDIT,
	 DATA_REG,
	 STATO_ELE, LISTA_GEN, SEZIONE, LISTA_SEZ, FASCICOLO, ANNO,
	 TESSERA_ELE, VECCHIA_SEZIONE, NUOVO_COD_VIA, NUOVO_NUM_CIV, NUOVO_SUFFISSO,
	 NUOVO_INTERNO, NUOVO_SUB_INTERNO, NUOVO_SCALA, NUOVO_PIANO, DATA_REG_EDIT,
	 COD_FISCALE_PREC, COD_FISCALE, DES_COD_FISCALE, DES_COD_FISCALE_PREC,
	 DES_TIPO_LISTA,
	 LISTA_AGG_C, LISTA_GEN_C, SEZIONE_C, LISTA_SEZ_C, FASCICOLO_C, ANNO_C, TESSERA_ELE_C,
	 LISTA_AGG_E, LISTA_GEN_E, SEZIONE_E, LISTA_SEZ_E, FASCICOLO_E, ANNO_E, TESSERA_ELE_E,
	 LISTA_AGG_T, LISTA_GEN_T, SEZIONE_T, LISTA_SEZ_T, FASCICOLO_T, ANNO_T, TESSERA_ELE_T,
	 LISTA_AGG_V, LISTA_GEN_V, SEZIONE_V, LISTA_SEZ_V, FASCICOLO_V, ANNO_V, TESSERA_ELE_V,
	 LISTA_AGG_B, LISTA_GEN_B, SEZIONE_B, LISTA_SEZ_B, FASCICOLO_B, ANNO_B, TESSERA_ELE_B,
	 INTESTATARIO, COD_VARIAZIONE, DES_COD_VARIAZIONE, VARIAZIONE,
	 ISCRITTO_ASC_V, ISCRITTO_ASC_R, ISCRITTO_AGP_S, ISCRITTO_AGP_P, ISCRITTO_APS,
	 ZIPCODE_IAI, DES_CONSOLATO_1_MOV, DES_CONSOLATO_2_MOV, DES_CONSOLATO_3_MOV,
	 DES_COM_ISCR_AIRE, VIA_AIRE, DES_VIA_AIRE, DES_COM_AIRE_IAI, DES_COM_AIRE,
         PROVINCIA_CONTEA, PRESSO,
         TERMINALISTA_MOV, MATRICOLA_AIRE, COD_FAM_AIRE,
	 MATRICOLA_MILITARE, CLASSE_LEVA, NUMERO_LISTA, DES_ESITO, DES_COM_LEVA, DES_COM_DISTRETTO,
	 DATA_ARRUOLAMENTO, DATA_CHIAMATA, DATA_CONGEDO, DES_ARMA, DES_CORPO, FORZA, DES_GRADO,
	 ANNO_NAS_PREC, ANNO_NAS)
as
SELECT
-- ANNO_PROGR_MOV
    mov.anno_progr,
-- NUMERO_PROGR_MOV
    mov.numero_progr,
-- MATRICOLA
    mov.matricola,
-- COD_MOV
           mov.cod_mov,
-- COD_EVE
           mov.cod_eve,
-- NUCLEO_PARTENZA
           mov.nucleo_partenza,
-- NUCLEO_ARRIVO
           mov.nucleo_arrivo,
-- COGNOME_NOME_PREC
           decode(mov.cognome_nome_prec,null,null,mov.cognome_nome,null,
               'Cognome nome precedente: '||TRANSLATE(cognome_nome_prec,'/',' ')),
-- COD_VIA_PREC
           mov.cod_via_prec||mov.num_civ_prec||mov.suffisso_prec||mov.interno_prec||mov.sub_interno_prec||mov.scala_prec||mov.piano_prec,
-- DES_COD_VIA_PREC
           DECODE(vie_p.denom_uff,'','','proviene da '||
              vie_p.denom_uff||mov.civico_esterno_prec||' '||mov.civico_interno_prec),
-- TIT_STUDIO_PREC
          mov.titolo_studio_prec,
-- TITOLO_STUDIO_PREC
           decode(mov.titolo_studio_prec,null,null,mov.titolo_studio,null,
               'Titolo di Studio precedente: '||NVL(dts_p.descrizione,'NESSUNO')),
-- COD_PROF_PREC
           mov.cod_prof_prec,
-- DES_COD_PROF_PREC
           decode(mov.cod_prof_prec,null,'',
      DECODE(mov.pensionato,1,'Professione precedente: '||
            NVL(dpr_p.descrizione,DECODE(mov.sesso,'M','PENSIONATO','PENSIONATA')),
          'Professione precedente: '||NVL(dpr_p.descrizione,'NESSUNA'))),
-- NAZIONALITA
           mov.nazionalita,
-- NAZIONALITA_PREC
           mov.nazionalita_prec,
-- STATO_CIV
          mov.stato_civile,
-- STATO_CIV_PREC
          mov.stato_civile_prec,
-- PATERNITA
           'pt. '||mov.paternita,
-- PATERNITA_PREC
           decode(mov.paternita_prec,null,null,mov.paternita,null,
               'Pt. precedente: '||mov.paternita_PREC),
-- MATERNITA
           'mt. '||TRANSLATE(mov.maternita,'/',' '),
-- MATERNITA_PREC
           decode(mov.maternita_prec,null,null,mov.maternita,null,
               'mt. precedente:  '||TRANSLATE(mov.maternita_PREC,'/',' ')),
-- DATA_NAS_PREC
           mov.data_nas_prec,
-- DATA_NAS_PREC_EDIT
           decode(mov.data_nas_prec,null,null, mov.data_nas,null,
               'Data di nascita precedente: '||
            decode(mov.anno_nas_prec,'S',
              '00/00/'||TO_CHAR(TO_DATE(mov.data_nas_prec,'j'),'yyyy'),
              TO_CHAR(TO_DATE(mov.data_nas_prec,'j'),'dd/mm/yyyy'))),
-- DES_COM_NAS_prec
           decode(lpad(cod_pro_nas_prec,3,0)||lpad(cod_com_nas_prec,3,0),null,null,
                  lpad(cod_pro_nas,3,0)||lpad(cod_com_nas,3,0),null,
               'Comune di Nascita precedente: '||
            f_comune_al(cod_pro_nas_prec,cod_com_nas_prec,data_nas_prec)||' '||
            f_provincia_stato_al(cod_pro_nas_prec,cod_com_nas_prec,null, 'S', 'S',mov.data_nas_prec)),
-- SESSO_PREC
           decode(mov.sesso_prec,null,null,mov.sesso,null,
               'Sesso precedente: '||mov.sesso_prec),
-- VIA_AIRE_PREC
           mov.via_aire_prec,
-- DES_VIA_AIRE_PREC
           DECODE(mov.via_aire_prec,null,null,mov.via_aire,null,
               'Ind. A.I.R.E. prec.: '||mov.via_aire_prec),
-- DES_COM_AIRE_PREC
           DECODE(g.descrizione,null,null,i.descrizione,null,
      'Comune A.I.R.E. precedente: '||
      g.descrizione||' '||f_provincia_stato(g.cod_provincia, g.cod_comune, g.sigla_provincia, 'S', 'S')),
-- ZIPCODE_PREC
       decode(mov.zipcode_prec,null,null,mov.zipcode,null,
      'Zipcode: '||mov.zipcode_prec),
-- PROVINCIA_CONTEA_PREC
       decode(mov.provincia_contea_prec,'','',
      'Provincia/Contea: '||mov.provincia_contea_prec),
-- PRESSO_PREC
       decode(mov.presso_prec,'','','Presso: '||mov.presso_prec),
-- DES_CONSOLATO_1_PREC
     decode(con.cod_consolato||lpad(con.tipo_consolato,2,'0'),con_p.cod_consolato||lpad(con_p.tipo_consolato,2,'0'),
       null, DECODE(dco_p.tipo_consolato,'','',0,'All''','Al ')||dco_p.descrizione),
-- DES_CONSOLATO_2_PREC
         decode(con.cod_consolato||lpad(con.tipo_consolato,2,'0'),con_p.cod_consolato||lpad(con_p.tipo_consolato,2,'0'),
       null, con_p.indirizzo),
-- DES_CONSOLATO_3_PREC
         decode(con.cod_consolato||lpad(con.tipo_consolato,2,'0'),con_p.cod_consolato||lpad(con_p.tipo_consolato,2,'0'),
       null, con_p.sede),
/*da mov_1 */
-- COGNOME_NOME
           TRANSLATE(mov.cognome_nome,'/',' '),
-- SESSO
           mov.sesso,
-- DI_SESSO
           DECODE(mov.sesso,'F','di sesso femminile','M','di sesso maschile'),
-- DATA_NAS
           mov.data_nas,
-- DATA_NAS_EDIT
           DECODE(mov.sesso,'F','nata il ','nato il ')||
      decode(mov.anno_nas,'S',
        '00/00/'||TO_CHAR(TO_DATE(mov.data_nas,'j'),'yyyy'),
        TO_CHAR(TO_DATE(mov.data_nas,'j'),'dd/mm/yyyy')),
-- DES_COM_NAS
           f_comune_al(cod_pro_nas,cod_com_nas,data_nas)||' '||
           f_provincia_stato_al(cod_pro_nas,cod_com_nas,null, 'S', 'S',mov.data_nas),
-- ATTO_NAS
       decode(mov.atto_nas_digitale,'',
           'atto N. '||mov.atto_nas||' p. '||DECODE(mov.parte_nas,1,'I',2,'II')||
                DECODE(mov.serie_nas,'','',' s. '||mov.serie_nas)||
                  DECODE(mov.ufficio_nas,0,'','','',' - '||mov.ufficio_nas)||
                  '  /  '||mov.anno_atto_nas,
           'atto digitale N. '||mov.atto_nas_digitale)||
                   DECODE(f_comune_al(cod_pro_atto_nas,cod_com_atto_nas,data_nas),'','',
              ' - '||f_comune_al(cod_pro_atto_nas,cod_com_atto_nas,data_nas)||' '||
                     f_provincia_stato_al(cod_pro_atto_nas,cod_com_atto_nas,null,'S','S',mov.data_nas)),
-- RAPPORTO_PAR
           mov.rapporto_par,
-- STATO_CIVILE
           DECODE(mov.cod_eve,
             93, decode(mov.stato_civile,'UC', 'Unita civilmente con ','Coniugata con'),
             94,'Vedova di', dsc.descrizione),
-- COGNOME_NOME_CN
           TRANSLATE(mov.cognome_nome_cn,'/',' '),
-- COGNOME_NOME_CN_PREC
           DECODE(mov.cod_eve,94,TRANSLATE(mov.cognome_nome_cn,'/',' '),
          decode(mov.cognome_nome_cn_prec,null,null,
        mov.cognome_nome_cn,null,
        TRANSLATE(mov.cognome_nome_cn_prec,'/',' '))),
-- DATA_MAT_VED
	case
            when mov.stato_civile in ('CN','UC') then
                 'il '||decode(mov.anno_mat,'S',
                      '00/00/'||TO_CHAR(TO_DATE(mov.data_mat,'j'),'yyyy'),
                      TO_CHAR(TO_DATE(mov.data_mat,'j'),'dd/mm/yyyy'))||
                 ' a '||f_comune_al(cod_pro_mat,cod_com_mat,data_mat)||' '||
                      f_provincia_stato_al(cod_pro_mat,cod_com_mat,null,'S','S',data_mat)
            when mov.stato_civile in ('VE','VU') then
                 'dal '||TO_CHAR(TO_DATE(mov.data_ved,'j'),'dd/mm/yyyy')||
                 ' a '||f_comune_al(cod_pro_ved,cod_com_ved,data_ved)||' '||
                      f_provincia_stato_al(cod_pro_ved,cod_com_ved,null,'S','S',data_ved)
            when mov.stato_civile in ('DV','GC','GU') then
                 'dal '||TO_CHAR(TO_DATE(mov.data_div,'j'),'dd/mm/yyyy')||
                 ' a '||f_comune_al(cod_pro_div,cod_com_div,data_div)||' '||
                      f_provincia_stato_al(cod_pro_div,cod_com_div,null,'S','S',data_div)
         end,
-- ATTO_MAT_VED
	case
            when mov.stato_civile in ('CN','UC') then
                 decode(mov.atto_mat_digitale,'',
                    'atto N. '||mov.atto_mat||
                           DECODE(mov.parte_mat,1,' p. I',2,' p. II')||
                           DECODE(mov.serie_mat,'','',' s. '||mov.serie_mat)||
                           DECODE(mov.ufficio_mat,0,'','','',' - '||mov.ufficio_mat)||'  /  '||mov.anno_atto_mat,
                    'atto digitale N. '||mov.atto_mat_digitale)||
                           DECODE(f_comune_al(cod_pro_atto_mat,cod_com_atto_mat,data_mat),'','',
                                  f_comune_al(cod_pro_mat,cod_com_mat,data_mat),'',
                 ' - '||f_comune_al(cod_pro_atto_mat,cod_com_atto_mat,data_mat)||' '||
                      f_provincia_stato_al(cod_pro_atto_mat,cod_com_atto_mat,null,'S','S',data_mat))
            when mov.stato_civile in ('VE','VU') then
                 decode(mov.atto_ved_digitale,'',
                   'atto N. '||mov.atto_ved||
                           DECODE(mov.parte_ved,1,' p. I',2,' p. II')||
                           DECODE(mov.serie_ved,'','',' s. '||mov.serie_ved)||
                           DECODE(mov.ufficio_ved,0,'','','',' - '||mov.ufficio_ved)||
                           '  /  '||mov.anno_atto_ved,
                   'atto digitale N. '||mov.atto_ved_digitale)||
                           DECODE(f_comune_al(cod_pro_atto_ved,cod_com_atto_ved,data_ved),'','',
                                  f_comune_al(cod_pro_ved,cod_com_ved,data_ved),'',
                 ' - '||f_comune_al(cod_pro_atto_ved,cod_com_atto_ved,data_ved)||' '||
                      f_provincia_stato_al(cod_pro_atto_ved,cod_com_atto_ved,null,'S','S',data_ved))
            when mov.stato_civile in ('DV','GC','GU') then
                 decode(nvl(mov.atto_div_digitale,mov.atto_div),'','',
                   decode(mov.atto_div_digitale,'',
                     'atto N. '||mov.atto_div||
                           DECODE(mov.parte_div,1,' p. I',2,' p. II')||
                           DECODE(mov.serie_div,'','',' s. '||mov.serie_div)||
                           DECODE(mov.ufficio_div,0,'','','',' - '||mov.ufficio_div)||
                           '  /  '||mov.anno_atto_div,
                     'atto digitale N. '||mov.atto_div_digitale)||' '||
                   f_comune_al(cod_pro_atto_div,cod_com_atto_div,data_div)||' '||
                   f_provincia_stato_al(cod_pro_atto_div,cod_com_atto_div,null,'S','S',data_div))
        end,
/*sel mov 2 */
-- COD_VIA
           mov.cod_via||mov.num_civ||mov.suffisso||mov.interno||mov.sub_interno||mov.scala||mov.piano,
-- DES_COD_VIA_CHIUSURA
           vie.denom_uff||mov.civico_esterno||' '||mov.civico_interno,
-- DES_COD_VIA
           DECODE(vie.denom_uff,'','','abitante in '||
          vie.denom_uff||mov.civico_esterno||' '||mov.civico_interno),
-- INDIRIZZO_EMI
    f_indirizzo_emi(mov.matricola, mov.anno_pratica, mov.pratica),
-- TIT_STUDIO
           mov.titolo_studio,
-- TITOLO_STUDIO
           DECODE(dts.descrizione,'','','Titolo di Studio: '||dts.descrizione),
-- COD_PROF
           mov.cod_prof,
-- DES_COD_PROF
           DECODE(mov.pensionato,1,'Professione: '||
                  NVL(dpr.descrizione,DECODE(mov.sesso,'M','PENSIONATO','PENSIONATA')),
                 DECODE(dpr.descrizione,'','',
                   'Professione: '||dpr.descrizione)),
-- DES_NAZIONALITA
        DECODE(nazionalita,'I','Cittadinanza: Italiana','','',
                    'Cittadinanza: '||dci.descrizione),
-- DATA_INIZIO_NAZ
        TO_CHAR(TO_DATE(mov.data_inizio_naz,'j'),'dd/mm/yyyy'),
-- DES_NAZIONALITA_PREC
           DECODE(mov.nazionalita_prec,'','',mov.nazionalita,'',
                      'I','Cittadinanza precedente: Italiana','','',
                          'Cittadinanza precedente: '||dci_p.descrizione),
-- DATA_INIZIO_NAZ_PREC
        TO_CHAR(TO_DATE(mov.data_inizio_naz_prec,'j'),'dd/mm/yyyy'),
-- DES_STATO_CIV
           DECODE(mov.stato_civile,'','','Stato civile: '||dsc.descrizione),
-- DES_STATO_CIV_PREC
           DECODE(mov.stato_civile_prec,'','',mov.stato_civile,'',
            'Stato civile precedente: '||dsc_p.descrizione),
-- DATA_EVE
           TO_CHAR(TO_DATE(mov.data_eve,'j'),'dd/mm/yyyy'),
-- CAP_COM_EVE
           decode(h.descrizione,'',
             lpad(com_ric.cap,5,'0'),
             lpad(h.cap,5,'0')),
-- DES_COM_EVE
           DECODE(h.descrizione,'',
             decode(com_ric.descrizione,'','',com_ric.descrizione||' '||f_provincia_stato(com_ric.cod_provincia, com_ric.cod_comune, com_ric.sigla_provincia, 'S', 'S')),
             h.descrizione||' '||f_provincia_stato(h.cod_provincia, h.cod_comune, h.sigla_provincia, 'S', 'S')),
-- PRATICA_EVE
      mov.pratica,
-- ANNO_PRATICA_EVE
           mov.anno_pratica,
-- PRATICA_EDIT
           DECODE(mov.pratica,'','','pratica '||mov.pratica||'/'||mov.anno_pratica),
-- DATA_REG
           mov.data_reg,
-- STATO_ELE
           ele.stato,
-- LISTA_GEN
           DECODE(ele.stato,'E',ele.progr_lista_gen,''),
-- SEZIONE
           DECODE(ele.stato,'E',ele.sezione,''),
-- LISTA_SEZ
           DECODE(ele.stato,'E',ele.progr_lista_sez,''),
-- FASCICOLO
           DECODE(ele.stato,'E',ele.fascicolo,''),
-- ANNO
           DECODE(ele.stato,'E',ele.anno,''),
-- TESSERA_ELE
           DECODE(ele.stato,'E',f_SCAW_tessera_ele(ele.matricola,ele.tessera_ele,ele.data_tessera_ele),''),
-- VECCHIA_SEZIONE
           DECODE(ele.stato,'E',ele.sezione,''),
-- NUOVO_COD_VIA
           mov.cod_via,
-- NUOVO_NUM_CIV
           mov.num_civ,
-- NUOVO_SUFFISSO
           mov.suffisso,
-- NUOVO_INTERNO
           to_char(mov.interno)||mov.sub_interno,
-- nuovo sub_interno
        mov.sub_interno,
-- NUOVO_SCALA
          mov.scala,
-- NUOVO_PIANO
          mov.piano,
-- DATA_REG_EDIT
           TO_CHAR(TO_DATE(mov.data_reg,'j'),'dd/mm/yyyy'),
-- COD_FISCALE_PREC
           mov.cod_fiscale_prec||
          decode(mov.cod_fiscale_prec,'','',
            decode(mov.cf_calcolato_prec,'',' (validato)',' (non validato)')),
-- COD_FISCALE
    mov.cod_fiscale||
          decode(mov.cod_fiscale,'','',
            decode(mov.cf_calcolato,'',' (validato)',' (non validato)')),
-- DES_COD_FISCALE
      DECODE(mov.cod_fiscale,'','',
          'Cod. Fiscale: '||mov.cod_fiscale||
           decode(mov.cf_calcolato,'',' (validato)',' (non validato)')),
-- DES_COD_FISCALE_PREC
      DECODE(mov.cod_fiscale_prec,'','',mov.cod_fiscale,
          decode(mov.cf_calcolato_prec,cf_calcolato,'',
            'Cod. Fiscale prec.:'||cod_fiscale_prec||
            decode(mov.cf_calcolato_prec,'',' (validato)',' (non validato)') ),
          'Cod. Fiscale prec.:'||cod_fiscale_prec||
          decode(mov.cf_calcolato_prec,'',' (validato)',' (non validato)')),
-- DES_TIPO_LISTA
           decode(ela_C.stato,'E','+ '||dtl_C.descrizione||' ')||
            decode(ela_E.stato,'E','+ '||dtl_E.descrizione||' ')||
            decode(ela_T.stato,'E','+ '||dtl_T.descrizione||' ')||
            decode(ela_V.stato,'E','+ '||dtl_V.descrizione||' ')||
            decode(ela_B.stato,'E','+ '||dtl_B.descrizione||' ') des_tipo_lista,
-- LISTA_AGG_C
      decode(ela_C.stato,'E',ela_C.tipo_lista),
-- LISTA_GEN_C
           decode(ela_C.stato,'E',ela_C.progr_lista_gen),
-- SEZIONE_C
           decode(ela_C.stato,'E',ela_C.sezione),
-- LISTA_SEZ_C
           decode(ela_C.stato,'E',ela_C.progr_lista_sez),
-- FASCICOLO_C
           decode(ela_C.stato,'E',ela_C.fascicolo),
-- ANNO_C
           decode(ela_C.stato,'E',ela_C.anno),
-- TESSERA_ELE_C
           decode(ela_C.stato,'E',f_SCAW_tessera_ele(ela_C.matricola,ela_C.tessera_ele,ela_C.data_tessera_ele)),
-- LISTA_AGG_E
      decode(ela_E.stato,'E',ela_E.tipo_lista),
-- LISTA_GEN_E
           decode(ela_E.stato,'E',ela_E.progr_lista_gen),
-- SEZIONE_E
           decode(ela_E.stato,'E',ela_E.sezione),
-- LISTA_SEZ_E
           decode(ela_E.stato,'E',ela_E.progr_lista_sez),
-- FASCICOLO_E
           decode(ela_E.stato,'E',ela_E.fascicolo),
-- ANNO_E
           decode(ela_E.stato,'E',ela_E.anno),
-- TESSERA_ELE_E
           decode(ela_E.stato,'E',f_SCAW_tessera_ele(ela_E.matricola,ela_E.tessera_ele,ela_E.data_tessera_ele)),
-- LISTA_AGG_T
      decode(ela_T.stato,'E',ela_T.tipo_lista),
-- LISTA_GEN_T
           decode(ela_T.stato,'E',ela_T.progr_lista_gen),
-- SEZIONE_T
           decode(ela_T.stato,'E',ela_T.sezione),
-- LISTA_SEZ_T
           decode(ela_T.stato,'E',ela_T.progr_lista_sez),
-- FASCICOLO_T
           decode(ela_T.stato,'E',ela_T.fascicolo),
-- ANNO_T
           decode(ela_T.stato,'E',ela_T.anno),
-- TESSERA_ELE_T
           decode(ela_T.stato,'E',f_SCAW_tessera_ele(ela_T.matricola,ela_T.tessera_ele,ela_T.data_tessera_ele)),
-- LISTA_AGG_V
      decode(ela_V.stato,'E',ela_V.tipo_lista),
-- LISTA_GEN_V
           decode(ela_V.stato,'E',ela_V.progr_lista_gen),
-- SEZIONE_V
    decode(ela_V.stato,'E',ela_V.sezione),
-- LISTA_SEZ_V
           decode(ela_V.stato,'E',ela_V.progr_lista_sez),
-- FASCICOLO_V
           decode(ela_V.stato,'E',ela_V.fascicolo),
-- ANNO_V
           decode(ela_V.stato,'E',ela_V.anno),
-- TESSERA_ELE_V
           decode(ela_V.stato,'E',f_SCAW_tessera_ele(ela_V.matricola,ela_V.tessera_ele,ela_V.data_tessera_ele)),
-- LISTA_AGG_B
      decode(ela_B.stato,'E',ela_B.tipo_lista),
-- LISTA_GEN_B
           decode(ela_B.stato,'E',ela_B.progr_lista_gen),
-- SEZIONE_B
           decode(ela_B.stato,'E',ela_B.sezione),
-- LISTA_SEZ_B
           decode(ela_B.stato,'E',ela_B.progr_lista_sez),
-- FASCICOLO_B
           decode(ela_B.stato,'E',ela_B.fascicolo),
-- ANNO_B
           decode(ela_B.stato,'E',ela_B.anno),
-- TESSERA_ELE_B
           decode(ela_B.stato,'E',f_SCAW_tessera_ele(ela_B.matricola,ela_B.tessera_ele,ela_B.data_tessera_ele)),
-- INTESTATARIO
           DECODE(NVL(mov.rapporto_par_prec,mov.rapporto_par),'CF',
                  DECODE(mov.intestatario,'','',mov.intestatario_prec,'',
                   TRANSLATE(mov.intestatario,'/',' '))),
-- COD_VARIAZIONE
      mov.cod_variazione,
-- DES_COD_VARIAZIONE
           decode(mov.cod_mov,11,decode(mov.cod_variazione,'',to_char(null),
                                      'U','Variazione effettuata d''ufficio',
                                      'O','Variazione effettuata d''ufficio '||
                                        'a seguito di revisione onomastica',
                                      'C','Variazione effettuata d''ufficio '||
                                        'a seguito di rinumerazione civica'),''),
-- VARIAZIONE
    decode(mov.cod_variazione,'',to_char(null) ,
                 'U','VARIAZIONE D''UFFICIO',
                 'O','REVISIONE ONOMASTICA',
                 'C','RINUMERAZIONE CIVICA'),
-- ISCRITTO_ASC_V
    decode(asc_v.matricola,'','','Albo Scrutatori: Unico'),
-- ISCRITTO_ASC_R
    decode(asc_r.matricola,'','','Albo Scrutatori: Regionale'),
-- ISCRITTO_AGP_S
    decode(agp_s.matricola,'','','Albo Giudici Popolari: Assise'),
-- ISCRITTO_AGP_P
    decode(agp_p.matricola,'','','Albo Giudici Popolari: Appello'),
-- ISCRITTO_APS
    decode(aps.matricola,'','','Albo Presidenti di Seggio'),
-- ZIPCODE_IAI
    mov.zipcode,
-- DES_CONSOLATO_1_MOV
         DECODE(dco.tipo_consolato,'','',0,'All''','Al ')||dco.descrizione,
-- DES_CONSOLATO_2_MOV
         con.indirizzo,
-- DES_CONSOLATO_3_MOV
           con.sede,
-- DES_COM_ISCR_AIRE
           DECODE(l.descrizione,'','',l.descrizione||' '||f_provincia_stato(l.cod_provincia, l.cod_comune, l.sigla_provincia, 'S', 'S')),
-- VIA_AIRE
           mov.via_aire,
-- DES_VIA_AIRE
           DECODE(mov.via_aire,'','','Ind. A.I.R.E.:  '||mov.via_aire),
-- DES_COM_AIRE_IAI
           DECODE(i.descrizione,'','',i.descrizione||' '||f_provincia_stato(i.cod_provincia, i.cod_comune, i.sigla_provincia, 'S', 'S')),
-- DES_COM_AIRE
    DECODE(i.descrizione,'','','Comune: '||
          i.descrizione||' '||f_provincia_stato(i.cod_provincia, i.cod_comune, i.sigla_provincia, 'S', 'S')),
-- PROVINCIA_CONTEA
    decode(mov.provincia_contea,'','',
          'Provincia/Contea '||mov.provincia_contea),
-- PRESSO
    decode(mov.presso,'','','Presso: '||mov.presso),
-- TERMINALISTA_MOV
           mov.terminalista,
-- MATRICOLA_AIRE
    decode(mov.cod_mov,3,mov.matricola_aire,4,mov.matricola_aire,12,mov.matricola_aire,13,mov.matricola_aire,
          decode(mov.cod_eve,4,mov.matricola_aire_prec)),
-- COD_FAM_AIRE
    decode(mov.cod_mov,3,'FE'||lpad(mov.cod_fam,7,'0'),4,'FE'||lpad(mov.cod_fam,7,'0'),
                  12,'FE'||lpad(mov.cod_fam,7,'0'),13,'FE'||lpad(mov.cod_fam,7,'0'),
          decode(mov.cod_eve,4,'FE'||lpad(mov.cod_fam_prec,7,'0'))),
-- MATRICOLA_MILITARE
    lev.matricola_mil,
-- CLASSE_LEVA
    lev.classe,
-- NUMERO_LISTA
    lev.numero_lista,
-- DES_ESITO
    des.descrizione,
-- DES_COM_LEVA
    decode(n.descrizione,'','',
          n.descrizione||' ('||n.sigla_provincia||')'),
-- DES_COM_DISTRETTO
    decode(o.descrizione,'','',
          o.descrizione||' ('||o.sigla_provincia||')'),
-- DATA_ARRUOLAMENTO
    to_char(to_date(lev.data_arr,'j'),'dd/mm/yyyy'),
-- DATA_CHIAMATA
    to_char(to_date(lev.data_chi,'j'),'dd/mm/yyyy'),
-- DATA_CONGEDO
    to_char(to_date(lev.data_con,'j'),'dd/mm/yyyy'),
-- DES_ARMA
    dar.descrizione,
-- DES_CORPO
    dcr.descrizione,
-- FORZA
    translate(lev.forza,';"','  '),
-- DES_GRADO
    dgr.descrizione,
-- anno_nas_prec
    mov.anno_nas_prec,
-- anno_nas
    mov.anno_nas
       from arccom com_ric,
            arccom g, arccom h, arccom i, arccom l,
            arccom n, arccom o,
            arccon con, arcdco dco, arccon con_p, arcdco dco_p,
            ARCVIE vie, ARCVIE vie_p,
            ANADTS dts, ANADTS dts_p,
            ANADPR dpr, ANADPR dpr_p,
            ANADSC dsc, ANADSC dsc_p,
            ANADCI dci, ANADCI dci_p,
            levdes des, levdar dar, levdco dcr, levdgr dgr, levruo lev,
            ELEAGP agp_s, ELEAGP agp_p, ELEAPS aps, ELEASC asc_v, ELEASC asc_r,
            eledtl dtl_C, eleela ela_C,
            eledtl dtl_E, eleela ela_E,
            eledtl dtl_T, eleela ela_T,
            eledtl dtl_V, eleela ela_V,
            eledtl dtl_B, eleela ela_B,
            eleana ele, anaeve eve_ric,
            ANAMOV mov
      where com_ric.cod_provincia (+)    = eve_ric.cod_pro_ric
        and com_ric.cod_comune    (+)    = eve_ric.cod_com_ric
        and eve_ric.matricola     (+)    = mov.matricola
        and eve_ric.cod_mov       (+)    = mov.cod_mov
        and eve_ric.cod_eve       (+)    = mov.cod_eve
        and eve_ric.data_eve      (+)    = mov.data_eve
        and eve_ric.pratica       (+)    = mov.pratica
        and eve_ric.anno_pratica  (+)    = mov.anno_pratica
        and eve_ric.data_reg      (+)    = mov.data_reg
        and dco_p.tipo_consolato (+)     = con_p.tipo_consolato
        AND con_p.tipo_consolato (+)     = g.tipo_consolato
        AND con_p.cod_consolato  (+)     = g.cod_consolato
        AND con_p.stato          (+)     = nvl(g.cod_territorio,g.cod_provincia)
        and g.cod_provincia     (+)    = mov.cod_pro_aire_prec
        and g.cod_comune     (+)    = mov.cod_com_aire_prec
        AND h.cod_provincia     (+)    = mov.cod_pro_eve
        AND h.cod_comune     (+)    = mov.cod_com_eve
        and dco.tipo_consolato      (+)     = con.tipo_consolato
        AND con.tipo_consolato      (+)     = i.tipo_consolato
        AND con.cod_consolato       (+)     = i.cod_consolato
        AND con.stato               (+)     = nvl(i.cod_territorio,i.cod_provincia)
        AND i.cod_provincia     (+)    = decode(mov.cod_mov,1,mov.cod_pro_aire,nvl(mov.cod_pro_aire,mov.cod_pro_aire_prec))
        AND i.cod_comune     (+)    = decode(mov.cod_mov,1,mov.cod_com_aire,nvl(mov.cod_com_aire,mov.cod_com_aire_prec))
        AND l.cod_provincia     (+)    = mov.cod_pro_iscr_aire
        AND l.cod_comune     (+)    = mov.cod_com_iscr_aire
        and n.cod_provincia    (+)    = lev.cod_pro_lev
        and n.cod_comune    (+)    = lev.cod_com_lev
        and o.cod_provincia    (+)    = lev.cod_pro_dis
        and o.cod_comune    (+)    = lev.cod_com_dis
        and dgr.cod_gr        (+)    = lev.grado
        and dcr.cod_co        (+)    = lev.corpo
        and dar.cod_ar        (+)    = lev.arma
        and des.cod_es        (+)    = lev.esito
        and lev.matricola    (+)    = mov.matricola
        and mov.cod_via_prec           = vie_p.cod_via (+)
        AND mov.cod_via              = vie.cod_via (+)
        and mov.titolo_studio_prec      = dts_p.cod_ts (+)
        AND mov.titolo_studio        = dts.cod_ts (+)
        and mov.cod_prof_prec           = dpr_p.cod_pr (+)
        and mov.sesso               = dpr_p.sesso (+)
        AND mov.cod_prof             = dpr.cod_pr (+)
        AND mov.sesso                = dpr.sesso (+)
        AND mov.nazionalita          = dci.cod_ci (+)
        AND mov.nazionalita_prec      = dci_p.cod_ci (+)
        AND mov.stato_civile         = dsc.cod_sc (+)
        AND mov.sesso                = dsc.sesso (+)
        AND mov.stato_civile_prec     = dsc_p.cod_sc (+)
        AND mov.sesso_prec           = dsc_p.sesso (+)
        AND dtl_C.cod_tl    (+)    = ela_C.tipo_lista
        AND ela_C.matricola    (+)    = mov.matricola
        AND ela_C.tipo_lista    (+)    = 'C'
        AND dtl_E.cod_tl    (+)    = ela_E.tipo_lista
        AND ela_E.matricola    (+)    = mov.matricola
        AND ela_E.tipo_lista    (+)    = 'E'
        AND dtl_T.cod_tl    (+)    = ela_T.tipo_lista
        AND ela_T.matricola    (+)    = mov.matricola
        AND ela_T.tipo_lista    (+)    = 'T'
        AND dtl_V.cod_tl    (+)    = ela_V.tipo_lista
        AND ela_V.matricola    (+)    = mov.matricola
        AND ela_V.tipo_lista    (+)    = 'V'
        AND dtl_B.cod_tl    (+)    = ela_B.tipo_lista
        AND ela_B.matricola    (+)    = mov.matricola
        AND ela_B.tipo_lista    (+)    = 'B'
        AND asc_v.matricola     (+)    = mov.matricola
        AND asc_v.albo         (+)    = 'V'
        AND asc_v.stato         (+)     = 'I'
        AND asc_r.matricola     (+)     = mov.matricola
        AND asc_r.albo         (+)     = 'R'
        AND asc_r.stato         (+)     = 'I'
        AND agp_s.matricola     (+)     = mov.matricola
        AND agp_s.albo         (+)     = 'S'
        AND agp_s.stato         (+)     = 'I'
        AND agp_p.matricola     (+)     = mov.matricola
        AND agp_p.albo         (+)     = 'P'
        AND agp_p.stato         (+)     = 'I'
        AND aps.matricola       (+)     = mov.matricola
        AND aps.stato         (+)     = 'I'
        AND ele.matricola       (+)     = mov.matricola
/
comment on table anawmo is 'Anagrafe - Dati Movimenti per Comunicazioni di Anagrafe (view)'
/
