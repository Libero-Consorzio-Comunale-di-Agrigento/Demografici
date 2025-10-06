--liquibase formatted sql
--changeset snocca:202312071435 runAlways:true runOnChange:true stripComments:false
create or replace view civann_v_json as
select ann.id
     , ann.id_atto
-- evento
     , f_ANSC_valore_inp('ID_VERSION',1,10,'9','') idVersion
     , DECODE (ann.tipo_atto, 1, '5',
                              2, '1',
                              4, '3',
                             -4, '4',
                              5, '2') idTipoEvento -- (anst01) 1 - NASCITA / 2 - MORTE / 3 - MATRIMONIO / 4 - UNIONE CIVILE / 5 - CITTADINANZA
     , '2' idTipoContenuto  			-- (anst02) 1 - ATTO / 2 - ANNOTAZIONE / 3 - TRASCRIZIONE / 4 - ANNOTAZIONE AUTO
     , ann.id_usecase_ansc idUseCase    	-- (anst03)
     , t03.descrizione  descrizioneCasoUso  	-- (anst03)
     , 'CONFERMATO' stato   			-- (anpt02) BOZZA / CONFERMATO / ANNULLATO / FIRMATO DAL DICHIARANTE / FIRMATO DA USC
     , to_char(ann.d_data_reg,'yyyy-mm-dd') dataFormazione
     , to_char(ann.d_data_reg,'hh24') ora
     , to_char(ann.d_data_reg,'mi') minuto
     , to_char(ann.d_data_reg,'yyyy') annoAtto
     , ann.numero_unico numeroatto
     , f_ANSC_id_comune_al(m.cod_provincia,m.cod_comune,'') idComuneReg
     , f_ANSC_comune_al(m.cod_provincia,m.cod_comune,'') nomeComuneReg
     , f_ANSC_id_provincia_al(m.cod_provincia,m.cod_comune,'') idProvinciaReg
     , f_ANSC_provincia_al(m.cod_provincia,m.cod_comune,'') siglaProvinciaReg
     , f_ANSC_id_operatore(ann.terminalista) operatore
     , f_ANSC_nome_operatore(ann.terminalista) operatoreNome
     , f_ANSC_cognome_operatore(ann.terminalista) operatoreCognome
     , 'true' redattoNellaCasaComunale
     , decode(ann.flag_secretato, 'S', '1', '0') flagSecretato
     , decode(ann.stampa,'S','false','true') flagAnnNonCertificabile
     , to_char(sysdate,'yyyy-mm-dd')||'T'||to_char(sysdate,'hh24:mi:ss') dataOggi
     , to_char(sysdate,'hh24') oraOggi
     , to_char(sysdate,'mi') minutoOggi
-- composizioneCompleta
     , ann.testo_annotazione composizioneCompleta
  -- enteDichiarante
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then ann.estremi_doc_prov else '' end  DIC_estremidocumento
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_provincia_al(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_siglaProvinciaEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_id_provincia_al(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_idProvinciaEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_comune_italiano(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_nomeComuneEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_id_comune_al(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_idComuneEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_id_stato_al(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_nazioneEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_stato_al(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_nomeNazioneEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_comune_estero(ann.cod_pro_prov,ann.cod_com_prov,ann.d_data_prov) else '' end DIC_comuneEsteroEnte
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_id_consolato(ann.cod_pro_prov,ann.cod_com_prov,'') else '' end DIC_idAnagraficaConsolato
     , case when ann.genere in ('AMM', 'AMD', 'AMX', 'AMS', 'AMA', 'RET') then f_ANSC_consolato(ann.cod_pro_prov,ann.cod_com_prov,'') else '' end DIC_nomeAnagraficaConsolato
  -- datiRettifica
     , ann.testo_annotazione dettaglioRettifica
     , case when ann.genere in ('RET','EMA') then '1' end idTipoRettifica
-- ANSC
     , ann.id_atto_ansc idAttoAnsc
     , ann.id_evento_ansc idEventoAnsc
  from arccom m
     , anst03 t03
     , civann ann
 where (m.cod_provincia,m.cod_comune) = (select pro_cliente, com_cliente from menuditta) 
   and t03.id = ann.id_usecase_ansc
/
comment on table civann_v_json is 'ANSC - Annotazioni su Atti per request JSON (view)'
/

