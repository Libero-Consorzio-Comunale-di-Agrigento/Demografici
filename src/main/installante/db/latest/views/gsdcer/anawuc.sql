--liquibase formatted sql
--changeset amonopoli:202507011605 runAlways:true runOnChange:true stripComments:false
create or replace view anawuc
	(MATRICOLA,
	 COGNOME_NOME_MOR, SESSO_MOR, DATA_NAS_MOR, COMUNE_NASCITA_MOR,
	 DATA_MOR, COMUNE_MOR, COMUNE_ATTO_MOR, ATTO_MOR_EDIT, 
	 DATA_CREMAZIONE, DATA_AFFIDAMENTO, DATI_AFFIDAMENTO, DATI_REGISTRO, 
         NOTE)
as
select 
-- MATRICOLA
    auc.matricola,
-- COGNOME_NOME_MOR
     decode(auc.cognome_nome_mor,'','','Defunto: '||replace(auc.COGNOME_NOME_MOR,'/','   ')),
-- SESSO_MOR   
       decode(auc.sesso_mor,'','','Sesso: '||auc.SESSO_MOR),
-- DATA_NAS_MOR       
       decode(auc.data_nas_mor||auc.cod_pro_nas_mor||auc.cod_com_nas_mor,'','',
     'Dati di Nascita: '||to_char(to_date(auc.DATA_NAS_MOR,'j'),'dd/mm/yyyy')),
-- COMUNE_NASCITA_MOR       
      f_comune_al(auc.cod_pro_nas_mor,auc.cod_com_nas_mor,auc.data_nas_mor)||' '||
     f_provincia_stato_al(auc.cod_pro_nas_mor,auc.cod_com_nas_mor,null,'S','S',data_nas_mor),
-- DATA_MOR       
       decode(auc.data_mor||auc.cod_pro_mor||auc.cod_com_mor||auc.atto_mor,'','',
     'Dati di Morte: '||to_char(to_date(auc.DATA_MOR,'j'),'dd/mm/yyyy')),
-- COMUNE_MOR       
       f_comune_al(auc.cod_pro_mor,auc.cod_com_mor,auc.data_mor)||' '||
     f_provincia_stato_al(auc.cod_pro_mor,auc.cod_com_mor,null,'S','S',data_mor),
-- COMUNE_ATTO_MOR       
       decode(f_comune_al(auc.cod_pro_atto_mor,auc.cod_com_atto_mor,auc.data_mor),'','',
     '- '||f_comune_al(auc.cod_pro_atto_mor,auc.cod_com_atto_mor,auc.data_mor)||' '||
      f_provincia_stato_al(auc.cod_pro_atto_mor,auc.cod_com_atto_mor,null,'S','S',data_mor)),
-- ATTO_MOR_EDIT       
       decode(auc.atto_mor_digitale,'',
         decode(auc.atto_mor,'','',
           'Atto N. '||auc.ATTO_MOR||
           'p. '||auc.PARTE_MOR||
           decode(auc.serie_mor,'','',' s. '||auc.serie_mor)||
           decode(auc.ufficio_mor,'','',' uff. '||auc.ufficio_mor)||
           decode(auc.anno_atto_mor,'','',' / '||auc.anno_atto_mor)),
         'Atto N. '||auc.ATTO_MOR_DIGITALE),
-- DATA_CREMAZIONE         
       decode(auc.data_cremazione,'','', 
         'Data Cremazione: '||to_char(to_date(auc.DATA_CREMAZIONE,'j'),'dd/mm/yyyy')),
-- DATA_AFFIDAMENTO
       decode(auc.data_affidamento,'','', 
         'Data Affidamento: '||to_char(to_date(auc.DATA_AFFIDAMENTO,'j'),'dd/mm/yyyy')),
-- DATI_AFFIDAMENTO       
       decode(auc.verbale_affidamento||auc.data_affidamento,'','', 
         'Dati Affidamento: '||
           decode(auc.verbale_affidamento,'','', 'Verbale N. '||auc.verbale_affidamento||' del ')||
           decode(auc.data_affidamento,'','', to_char(to_date(auc.DATA_AFFIDAMENTO,'j'),'dd/mm/yyyy'))),
-- DATI_REGISTRO
       decode(auc.numero_reg||auc.anno_reg,'','', 
         'Dati Registro: '||'N. '||auc.numero_reg||'/'||auc.anno_reg),
-- NOTE       
       decode(auc.NOTE, '', '', 'Note: '||translate(auc.note,chr(10),' ')) 
  from anaauc auc
/
comment on table anawuc is 'Anagrafe - Dati Affidamento Urne Cinerarie per Stampa Comunicazioni (view)'
/
