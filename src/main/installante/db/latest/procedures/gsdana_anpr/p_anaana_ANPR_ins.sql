--liquibase formatted sql
--changeset amonopoli:202305201030 runOnChange:true stripComments:false
create or replace procedure anaana_ANPR_ins
(a_id_soggetto_anpr		IN	varchar2
,a_id_operazione_comune		IN	varchar2
,a_matricola_ads		OUT	number
,a_filtro			IN      varchar2   default null
,a_num_componenti_anpr		IN      number   default null
)

is

w_matricola	         number;
w_fascia                 number;
w_stato                  number;
w_cod_fam	         number;

w_stato_civile           varchar2(255);

w_codice_comune_NAS      varchar2(255);
w_cod_pro_NAS            number;
w_cod_com_NAS            number;
w_codice_comune_ATTNAS   varchar2(255);
w_cod_pro_ATTNAS         number;
w_cod_com_ATTNAS         number;
w_codice_comune_MAT      varchar2(255);
w_cod_pro_MAT            number;
w_cod_com_MAT            number;
w_codice_comune_ATTMAT   varchar2(255);
w_cod_pro_ATTMAT         number;
w_cod_com_ATTMAT         number;
w_codice_comune_VED      varchar2(255);
w_cod_pro_VED            number;
w_cod_com_VED            number;
w_codice_comune_ATTVED   varchar2(255);
w_cod_pro_ATTVED         number;
w_cod_com_ATTVED         number;
w_codice_comune_ATTDIV   varchar2(255);
w_cod_pro_ATTDIV         number;
w_cod_com_ATTDIV         number;
w_codice_comune_UCI      varchar2(255);
w_cod_pro_UCI            number;
w_cod_com_UCI            number;
w_codice_comune_ATTUCI   varchar2(255);
w_cod_pro_ATTUCI         number;
w_cod_com_ATTUCI         number;
w_codice_comune_SCI      varchar2(255);
w_cod_pro_SCI            number;
w_cod_com_SCI            number;
w_codice_comune_ATTSCI   varchar2(255);
w_cod_pro_ATTSCI         number;
w_cod_com_ATTSCI         number;
w_codice_comune_DI       varchar2(255);
w_cod_pro_DI             number;
w_cod_com_DI             number;
w_codice_comune_DS       varchar2(255);
w_cod_pro_DS             number;
w_cod_com_DS             number;
w_codice_comune_CDFSTI   varchar2(255);
w_cod_pro_CDFSTI         number;
w_cod_com_CDFSTI         number;
w_codice_comune_CDFRIS   varchar2(255);
w_cod_pro_CDFRIF         number;
w_cod_com_CDFRIF         number;

w_atto_nas               number;
w_parte_nas              number;
w_serie_nas              varchar2(255);
w_anno_atto_nas          number;
w_ufficio_nas            number;
w_atto_mat               number;
w_parte_mat              number;
w_serie_mat              varchar2(255);
w_anno_atto_mat          number;
w_ufficio_mat            number;
w_atto_uci               number;
w_parte_uci              number;
w_serie_uci              varchar2(255);
w_anno_atto_uci          number;
w_ufficio_uci            number;
w_atto_ved               number;
w_parte_ved              number;
w_serie_ved              varchar2(255);
w_anno_atto_ved          number;
w_ufficio_ved            number;
w_atto_sci               number;
w_parte_sci              number;
w_serie_sci              varchar2(255);
w_anno_atto_sci          number;
w_ufficio_sci            number;
w_atto_div               number;
w_parte_div              number;
w_serie_div              varchar2(255);
w_anno_atto_div          number;
w_ufficio_div            number;

w_codice_comune_RES      varchar2(255);
w_cod_pro_RES            number;
w_cod_com_RES            number;
w_via_res                varchar2(255);

w_data_rif               varchar2(255);

w_tipo_DI	         varchar2(255);
w_espatrio_DI	         varchar2(255);
w_tipo_DS	         varchar2(255);
w_ente_DS                varchar2(255);

w_tipo_sentenza_SEN      number;
w_tipo_provvedimento_SEN number;
w_ente_provvedimento_SEN number;

w_note_ana               varchar2(4000);
w_des_comune_ANPR        varchar2(255);

w_errore	varchar2(4000);
errore		exception;

cursor sel_anp is
select * from anpana
 where id_operazione  = a_id_operazione_comune
   and idsoggettoanpr = a_id_soggetto_anpr
;

begin
  begin
    select nvl(max(numero),0) + 1
      into w_matricola
      from anan01
     where cod_num = 'MAT'
    ;
    update anan01
       set numero = w_matricola
     where cod_num = 'MAT'
    ;
  exception
    when others then
         w_matricola := '';
  end;

  if nvl(a_filtro,'AIS') in ('NRE','ANP') then
     w_fascia  := 6;
     if nvl(a_filtro,'AIS') = 'NRE' then
        w_stato   := 80;
     elsif nvl(a_filtro,'AIS') = 'ANP' then
        w_stato   := 81;
     end if;
     begin
       select nvl(max(numero),0) + 1
         into w_cod_fam
         from anan01
        where cod_num = 'FNR'
       ;
       update anan01
          set numero = w_cod_fam
        where cod_num = 'FNR'
       ;
     exception
       when others then
            w_matricola := '';
     end;

  elsif nvl(a_filtro,'AIS') = 'AIS' then
     w_fascia  := 5;
     w_stato   := 70;
     w_cod_fam := '';

  elsif nvl(a_filtro,'AIS') = 'AIA' then
     w_fascia  := 5;
     w_stato   := 72;
     w_cod_fam := '';

  end if;

  if w_matricola is not null then
     for rec in sel_anp loop
         if nvl(a_filtro,'AIS') in ('NRE','ANP') then
            w_codice_comune_RES    := f_ADS_codice_comune(rec.RES_CODICEISTAT,rec.RES_NOMECOMUNE,rec.RES_SIGLAPROVINCIAISTAT,rec.RES_CODICESTATO,rec.RES_DESCRIZIONELOCALITA,'');
            if w_codice_comune_RES is not null then
               w_cod_pro_RES    := substr(lpad(w_codice_comune_RES,6,'0'),1,3);
               w_cod_com_RES    := substr(lpad(w_codice_comune_RES,6,'0'),4,3);
            end if;

            if nvl(rec.soggettoaire,'N') = 'S' then
               begin
                 select rec.res_toponimoEstero||decode(rec.res_capEstero,'','',' - '||rec.res_capEstero)
                   into w_via_res
                   from dual
                 ;
               exception
                 when others then
                      w_via_res := '';
               end;
            else
               begin
                 select rec.res_specie||' '||rec.res_denominazionetoponimo||', '||rec.res_numero||decode(rec.res_lettera,'','','/'||rec.res_lettera)
                   into w_via_res
                   from dual
                 ;
               exception
                 when others then
                      w_via_res := '';
               end;
            end if;

            begin
              insert into anafam
                     ( FASCIA, COD_FAM, COD_PRO_RES, COD_COM_RES, VIA_RES
                     )
              values (
-- FASCIA
                       w_fascia
-- COD_FAM
                     , w_cod_fam
-- COD_PRO_RES
                     , w_cod_pro_RES
-- COD_COM_RES
                     , w_cod_com_RES
-- VIA_RES
                     , w_via_res
                     )
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anafam '||w_fascia||'-'||w_stato||' ('||SQLERRM||')';
                   raise errore;
            end;
         end if;

         w_stato_civile         := f_ADS_stato_civile(rec.STATOCIVILE,rec.SESSO,rec.SCI_MOTIVOSCIOGLIMENTO);
         ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'stato_civile '||w_stato_civile);

         w_data_rif             := rec.DATANASCITA;
         w_codice_comune_NAS    := f_ADS_codice_comune(rec.NAS_CODICEISTAT,rec.NAS_NOMECOMUNE,rec.NAS_SIGLAPROVINCIAISTAT,rec.NAS_CODICESTATO,rec.NAS_DESCRIZIONELOCALITA,w_data_rif);
         if w_codice_comune_NAS is not null then
            w_cod_pro_NAS    := substr(lpad(w_codice_comune_NAS,6,'0'),1,3);
            w_cod_com_NAS    := substr(lpad(w_codice_comune_NAS,6,'0'),4,3);
         end if;
--         ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'comune_nas '||rec.NAS_CODICEISTAT||' - '||rec.NAS_NOMECOMUNE||' - '||rec.NAS_SIGLAPROVINCIAISTAT||': '||w_cod_pro_nas||'-'||w_cod_com_nas);

         w_data_rif             := nvl(rec.ATTNAS_DATAFORMAZIONEATTO,rec.DATANASCITA);
         w_codice_comune_ATTNAS := f_ADS_codice_comune(rec.ATTNAS_CODICEISTAT,rec.ATTNAS_NOMECOMUNE,rec.ATTNAS_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTNAS is not null then
            w_cod_pro_ATTNAS := substr(lpad(w_codice_comune_ATTNAS,6,'0'),1,3);
            w_cod_com_ATTNAS := substr(lpad(w_codice_comune_ATTNAS,6,'0'),4,3);
         end if;
--         ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'comune_attnas '||rec.ATTNAS_CODICEISTAT||' - '||rec.ATTNAS_NOMECOMUNE||' - '||rec.ATTNAS_SIGLAPROVINCIAISTAT||': '||w_cod_pro_attnas||'-'||w_cod_com_attnas);

         w_data_rif             := rec.MAT_DATAEVENTO;
         w_codice_comune_MAT    := f_ADS_codice_comune(rec.MAT_CODICEISTAT,rec.MAT_NOMECOMUNE,rec.MAT_SIGLAPROVINCIAISTAT,rec.MAT_CODICESTATO,rec.MAT_DESCRIZIONELOCALITA,w_data_rif);
         if w_codice_comune_MAT is not null then
            w_cod_pro_MAT    := substr(lpad(w_codice_comune_MAT,6,'0'),1,3);
            w_cod_com_MAT    := substr(lpad(w_codice_comune_MAT,6,'0'),4,3);
         end if;

         w_data_rif             := nvl(rec.ATTMAT_DATAFORMAZIONEATTO,rec.MAT_DATAEVENTO);
         w_codice_comune_ATTMAT := f_ADS_codice_comune(rec.ATTMAT_CODICEISTAT,rec.ATTMAT_NOMECOMUNE,rec.ATTMAT_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTMAT is not null then
            w_cod_pro_ATTMAT := substr(lpad(w_codice_comune_ATTMAT,6,'0'),1,3);
            w_cod_com_ATTMAT := substr(lpad(w_codice_comune_ATTMAT,6,'0'),4,3);
         end if;

         w_data_rif             := rec.VED_DATAEVENTO;
         w_codice_comune_VED    := f_ADS_codice_comune(rec.VED_CODICEISTAT,rec.VED_NOMECOMUNE,rec.VED_SIGLAPROVINCIAISTAT,rec.VED_CODICESTATO,rec.VED_DESCRIZIONELOCALITA,w_data_rif);
         if w_codice_comune_VED is not null then
            w_cod_pro_VED    := substr(lpad(w_codice_comune_VED,6,'0'),1,3);
            w_cod_com_VED    := substr(lpad(w_codice_comune_VED,6,'0'),4,3);
         end if;

         w_data_rif             := nvl(rec.ATTVED_DATAFORMAZIONEATTO,rec.VED_DATAEVENTO);
         w_codice_comune_ATTVED := f_ADS_codice_comune(rec.ATTVED_CODICEISTAT,rec.ATTVED_NOMECOMUNE,rec.ATTVED_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTVED is not null then
            w_cod_pro_ATTVED := substr(lpad(w_codice_comune_ATTVED,6,'0'),1,3);
            w_cod_com_ATTVED := substr(lpad(w_codice_comune_ATTVED,6,'0'),4,3);
         end if;

         w_data_rif             := rec.ATTDIV_DATAFORMAZIONEATTO;
         w_codice_comune_ATTDIV := f_ADS_codice_comune(rec.ATTDIV_CODICEISTAT,rec.ATTDIV_NOMECOMUNE,rec.ATTDIV_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTDIV is not null then
            w_cod_pro_ATTDIV := substr(lpad(w_codice_comune_ATTDIV,6,'0'),1,3);
            w_cod_com_ATTDIV := substr(lpad(w_codice_comune_ATTDIV,6,'0'),4,3);
         end if;

         w_data_rif             := rec.UCI_DATAEVENTO;
         w_codice_comune_UCI    := f_ADS_codice_comune(rec.UCI_CODICEISTAT,rec.UCI_NOMECOMUNE,rec.UCI_SIGLAPROVINCIAISTAT,rec.UCI_CODICESTATO,rec.UCI_DESCRIZIONELOCALITA,w_data_rif);
         if w_codice_comune_UCI is not null then
            w_cod_pro_UCI    := substr(lpad(w_codice_comune_UCI,6,'0'),1,3);
            w_cod_com_UCI    := substr(lpad(w_codice_comune_UCI,6,'0'),4,3);
         end if;

         w_data_rif             := nvl(rec.ATTUCI_DATAFORMAZIONEATTO,rec.UCI_DATAEVENTO);
         w_codice_comune_ATTUCI := f_ADS_codice_comune(rec.ATTUCI_CODICEISTAT,rec.ATTUCI_NOMECOMUNE,rec.ATTUCI_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTUCI is not null then
            w_cod_pro_ATTUCI := substr(lpad(w_codice_comune_ATTUCI,6,'0'),1,3);
            w_cod_com_ATTUCI := substr(lpad(w_codice_comune_ATTUCI,6,'0'),4,3);
         end if;

         w_data_rif             := rec.SCI_DATAEVENTO;
         w_codice_comune_SCI    := f_ADS_codice_comune(rec.SCI_CODICEISTAT,rec.SCI_NOMECOMUNE,rec.SCI_SIGLAPROVINCIAISTAT,rec.SCI_CODICESTATO,rec.SCI_DESCRIZIONELOCALITA,w_data_rif);
         if w_codice_comune_SCI is not null then
            w_cod_pro_SCI    := substr(lpad(w_codice_comune_SCI,6,'0'),1,3);
            w_cod_com_SCI    := substr(lpad(w_codice_comune_SCI,6,'0'),4,3);
         end if;

         w_data_rif             := nvl(rec.ATTSCI_DATAFORMAZIONEATTO,rec.SCI_DATAEVENTO);
         w_codice_comune_ATTSCI := f_ADS_codice_comune(rec.ATTSCI_CODICEISTAT,rec.ATTSCI_NOMECOMUNE,rec.ATTSCI_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_ATTSCI is not null then
            w_cod_pro_ATTSCI := substr(lpad(w_codice_comune_ATTSCI,6,'0'),1,3);
            w_cod_com_ATTSCI := substr(lpad(w_codice_comune_ATTSCI,6,'0'),4,3);
         end if;

         w_data_rif             := rec.DI_DATARILASCIO;
         w_codice_comune_DI     := f_ADS_codice_comune(rec.DI_CODICEISTAT,rec.DI_NOMECOMUNE,rec.DI_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_DI is not null then
            w_cod_pro_DI     := substr(lpad(w_codice_comune_DI,6,'0'),1,3);
            w_cod_com_DI     := substr(lpad(w_codice_comune_DI,6,'0'),4,3);
         end if;

         w_data_rif             := rec.DS_DATARILASCIO;
         w_codice_comune_DS     := f_ADS_codice_comune(rec.DS_CODICEISTAT,rec.DS_NOMECOMUNE,rec.DS_SIGLAPROVINCIAISTAT,'','',w_data_rif);
         if w_codice_comune_DS is not null then
            w_cod_pro_DS     := substr(lpad(w_codice_comune_DS,6,'0'),1,3);
            w_cod_com_DS     := substr(lpad(w_codice_comune_DS,6,'0'),4,3);
         end if;

--         w_data_rif             := rec.CDFSTI_DATA;
--         w_codice_comune_CDFSTI := f_ADS_codice_comune(rec.CDFSTI_CODICEISTAT,rec.CDFSTI_NOMECOMUNE,rec.CDFSTI_SIGLAPROVINCIAISTAT,'','',w_data_rif);
--         if w_codice_comune_CDFSTI is not null then
--            w_cod_pro_CDFSTI := substr(lpad(w_codice_comune_CDFSTI,6,'0'),1,3);
--            w_cod_com_CDFSTI := substr(lpad(w_codice_comune_CDFSTI,6,'0'),4,3);
--         end if;

--         w_data_rif             := rec.CDFRIS_DATA;
--         if w_codice_comune_CDFRIS is not null then
--            w_codice_comune_CDFRIS := f_ADS_codice_comune(rec.CDFRIS_CODICEISTAT,rec.CDFRIS_NOMECOMUNE,rec.CDFRIS_SIGLAPROVINCIAISTAT,'','',w_data_rif);
--            w_cod_pro_CDFRIS := substr(lpad(w_codice_comune_CDFRIS,6,'0'),1,3);
--            w_cod_com_CDFRIS := substr(lpad(w_codice_comune_CDFRIS,6,'0'),4,3);
--         end if;

         if nvl(a_filtro,'AIS') in ('NRE','ANP') then
            w_note_ana := to_char(sysdate,'dd/mm/yyyy')||': dati acquisiti da ANPR';
            begin
              select decode(rec.soggettoAire,'S','AIRE di ','')||c.descrizione||' - '||c.sigla_provincia
                into w_des_comune_ANPR
                from arccom c
               where cod_provincia = substr(lpad(rec.idSoggettoComuneIstat,6,'0'),1,3)
                 AND cod_comune    = substr(lpad(rec.idSoggettoComuneIstat,6,'0'),4,3)
              ;
            exception
              when others then
--                   w_des_comune_ANPR := sqlerrm;
                   if rec.idSoggettoComuneIstat is not null then
                      w_des_comune_ANPR := 'ComuneIstat: '||rec.idSoggettoComuneIstat;
                   else
                      w_des_comune_ANPR := '';
                   end if;
            end;
            if w_des_comune_ANPR is not null then
               w_note_ana := w_note_ana||' ('||w_des_comune_ANPR||')';
            end if;
         end if;

         begin
           select
-- PARTE_NAS -- PARTE_MAT -- PARTE_UCI -- PARTE_VED -- PARTE_SCI -- PARTE_DIV
                  decode(rec.ATTNAS_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTNAS_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTNAS_PARTE,1,1)))
                , decode(rec.ATTMAT_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTMAT_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTMAT_PARTE,1,1)))
                , decode(rec.ATTUCI_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTUCI_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTUCI_PARTE,1,1)))
                , decode(rec.ATTVED_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTVED_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTVED_PARTE,1,1)))
                , decode(rec.ATTSCI_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTSCI_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTSCI_PARTE,1,1)))
                , decode(rec.ATTDIV_PARTE, '', '', 'I', 1, 'II', 2,
                    decode(translate(substr(rec.ATTDIV_PARTE,1,1),'1234567890','9999999999'),'9',substr(rec.ATTDIV_PARTE,1,1)))
-- UFFICIO_NAS -- UFFICIO_MAT -- UFFICIO_UCI -- UFFICIO_VED -- UFFICIO_SCI -- UFFICIO_DIV
                , decode(translate(substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2))
                , decode(translate(substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTMAT_UFFICIOMUNICIPIO,1,2))
                , decode(translate(substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTUCI_UFFICIOMUNICIPIO,1,2))
                , decode(translate(substr(rec.ATTVED_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTVED_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTVED_UFFICIOMUNICIPIO,1,2))
                , decode(translate(substr(rec.ATTNAS_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTSCI_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTSCI_UFFICIOMUNICIPIO,1,2))
                , decode(translate(substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,2),'1234567890','9999999999'),
                    '9', substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,1), '99', substr(rec.ATTDIV_UFFICIOMUNICIPIO,1,2))
             into w_parte_nas
                , w_parte_mat
                , w_parte_uci
                , w_parte_ved
                , w_parte_sci
                , w_parte_div
                , w_ufficio_nas
                , w_ufficio_mat
                , w_ufficio_uci
                , w_ufficio_ved
                , w_ufficio_sci
                , w_ufficio_div
             from dual
           ;


           select
-- ANNO_ATTO_NAS -- ATTO_NAS -- PARTE_NAS -- SERIE_NAS -- UFFICIO_NAS
                  decode(rec.ATTNAS_TRASCRITTO,'S','',rec.ATTNAS_ANNO)
                , decode(rec.ATTNAS_TRASCRITTO,'S','',
                    decode(rec.ATTNAS_IDANSC,'',
                      substr(ltrim(rec.ATTNAS_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTNAS_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTNAS_TRASCRITTO,'S','',
                    decode(rec.ATTNAS_IDANSC,'',w_parte_nas))
                , decode(rec.ATTNAS_TRASCRITTO,'S','',
                    decode(rec.ATTNAS_IDANSC,'',substr(rec.ATTNAS_SERIE,1,1)))
                , decode(rec.ATTNAS_TRASCRITTO,'S','',w_ufficio_nas)
-- ANNO_ATTO_MAT -- ATTO_MAT -- PARTE_MAT -- SERIE_MAT -- UFFICIO_MAT
                , decode(rec.ATTMAT_TRASCRITTO,'S','',rec.ATTMAT_ANNO)
                , decode(rec.ATTMAT_TRASCRITTO,'S','',
                    decode(rec.ATTMAT_IDANSC,'',
                      substr(ltrim(rec.ATTMAT_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTMAT_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTMAT_TRASCRITTO,'S','',
                    decode(rec.ATTMAT_IDANSC,'',w_parte_mat))
                , decode(rec.ATTMAT_TRASCRITTO,'S','',
                    decode(rec.ATTMAT_IDANSC,'',substr(rec.ATTMAT_SERIE,1,1)))
                , decode(rec.ATTMAT_TRASCRITTO,'S','',w_ufficio_mat)
-- ANNO_ATTO_UCI -- ATTO_UCI -- PARTE_UCI -- SERIE_UCI -- UFFICIO_UCI
                , decode(rec.ATTUCI_TRASCRITTO,'S','',rec.ATTUCI_ANNO)
                , decode(rec.ATTUCI_TRASCRITTO,'S','',
                    decode(rec.ATTUCI_IDANSC,'',
                      substr(ltrim(rec.ATTUCI_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTUCI_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTUCI_TRASCRITTO,'S','',
                    decode(rec.ATTUCI_IDANSC,'',w_parte_uci))
                , decode(rec.ATTUCI_TRASCRITTO,'S','',
                    decode(rec.ATTUCI_IDANSC,'',substr(rec.ATTUCI_SERIE,1,1)))
                , decode(rec.ATTUCI_TRASCRITTO,'S','',w_ufficio_uci)
-- ANNO_ATTO_VED -- ATTO_VED -- PARTE_VED -- SERIE_VED -- UFFICIO_VED
                , decode(rec.ATTVED_TRASCRITTO,'S','',rec.ATTVED_ANNO)
                , decode(rec.ATTVED_TRASCRITTO,'S','',
                    decode(rec.ATTVED_IDANSC,'',
                      substr(ltrim(rec.ATTVED_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTVED_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTVED_TRASCRITTO,'S','',
                    decode(rec.ATTVED_IDANSC,'',w_parte_ved))
                , decode(rec.ATTVED_TRASCRITTO,'S','',
                    decode(rec.ATTVED_IDANSC,'',substr(rec.ATTVED_SERIE,1,1)))
                , decode(rec.ATTVED_TRASCRITTO,'S','',w_ufficio_ved)
-- ANNO_ATTO_SCI -- ATTO_SCI -- PARTE_SCI -- SERIE_SCI -- UFFICIO_SCI
                , decode(rec.ATTSCI_TRASCRITTO,'S','',rec.ATTSCI_ANNO)
                , decode(rec.ATTSCI_TRASCRITTO,'S','',
                    decode(rec.ATTSCI_IDANSC,'',
                      substr(ltrim(rec.ATTSCI_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTSCI_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTSCI_TRASCRITTO,'S','',
                    decode(rec.ATTSCI_IDANSC,'',w_parte_sci))
                , decode(rec.ATTSCI_TRASCRITTO,'S','',
                    decode(rec.ATTSCI_IDANSC,'',substr(rec.ATTSCI_SERIE,1,1)))
                , decode(rec.ATTSCI_TRASCRITTO,'S','',w_ufficio_sci)
-- ANNO_ATTO_DIV -- ATTO_DIV -- PARTE_DIV -- SERIE_DIV -- UFFICIO_DIV
                , decode(rec.ATTDIV_TRASCRITTO,'S','',rec.ATTDIV_ANNO)
                , decode(rec.ATTDIV_TRASCRITTO,'S','',
                    decode(rec.ATTDIV_IDANSC,'',
                      substr(ltrim(rec.ATTDIV_NUMEROATTO,'0'),1,4),
                      substr(ltrim(rec.ATTDIV_NUMEROCOMUNALE,'0'),1,4)))
                , decode(rec.ATTDIV_TRASCRITTO,'S','',
                    decode(rec.ATTDIV_IDANSC,'',w_parte_div))
                , decode(rec.ATTDIV_TRASCRITTO,'S','',
                    decode(rec.ATTDIV_IDANSC,'',substr(rec.ATTDIV_SERIE,1,1)))
                , decode(rec.ATTDIV_TRASCRITTO,'S','',w_ufficio_div)
             into w_ANNO_ATTO_NAS, w_ATTO_NAS, w_PARTE_NAS, w_SERIE_NAS, w_UFFICIO_NAS,
                  w_ANNO_ATTO_MAT, w_ATTO_MAT, w_PARTE_MAT, w_SERIE_MAT, w_UFFICIO_MAT,
                  w_ANNO_ATTO_UCI, w_ATTO_UCI, w_PARTE_UCI, w_SERIE_UCI, w_UFFICIO_UCI,
                  w_ANNO_ATTO_VED, w_ATTO_VED, w_PARTE_VED, w_SERIE_VED, w_UFFICIO_VED,
                  w_ANNO_ATTO_SCI, w_ATTO_SCI, w_PARTE_SCI, w_SERIE_SCI, w_UFFICIO_SCI,
                  w_ANNO_ATTO_DIV, w_ATTO_DIV, w_PARTE_DIV, w_SERIE_DIV, w_UFFICIO_DIV
             from dual
           ;
         exception
           when others then
                w_errore := 'errore in decodifica parte atto ('||SQLERRM||')';
                raise errore;
         end;

         begin
           insert into anaana
                 ( MATRICOLA, COGNOME_NOME, FASCIA, STATO, DATA_ULT_EVE, COD_FAM
                 , STATO_CIVILE, SESSO, NAZIONALITA, DATA_INIZIO_NAZ
                 , PATERNITA, MATRICOLA_PD, MATERNITA, MATRICOLA_MD
                 , TITOLO_STUDIO, COD_PROF, ATTIVITA_PROF, POSIZIONE_PROF
                 , COD_PRO_NAS, COD_COM_NAS, DATA_NAS, ANNO_NAS
                 , COD_PRO_ATTO_NAS, COD_COM_ATTO_NAS
                 , ANNO_ATTO_NAS, ATTO_NAS, PARTE_NAS, SERIE_NAS, UFFICIO_NAS
                 , ANNO_ATTO_NAS_TR, ATTO_NAS_TR, PARTE_NAS_TR, SERIE_NAS_TR, UFFICIO_NAS_TR
                 , COD_FISCALE, CF_CALCOLATO, DATA_REG
                 , COGNOME_NOME_CN, MATRICOLA_CN
                 , COD_PRO_MAT, COD_COM_MAT, DATA_MAT, ANNO_MAT
                 , COD_PRO_ATTO_MAT, COD_COM_ATTO_MAT
                 , ANNO_ATTO_MAT, ATTO_MAT, PARTE_MAT, SERIE_MAT, UFFICIO_MAT
                 , ANNO_ATTO_MAT_TR, ATTO_MAT_TR, PARTE_MAT_TR, SERIE_MAT_TR, UFFICIO_MAT_TR
                 , COD_PRO_VED, COD_COM_VED, DATA_VED
                 , COD_PRO_ATTO_VED, COD_COM_ATTO_VED
                 , ANNO_ATTO_VED, ATTO_VED, PARTE_VED, SERIE_VED, UFFICIO_VED
                 , COD_PRO_DIV, COD_COM_DIV, DATA_DIV
                 , COD_PRO_ATTO_DIV, COD_COM_ATTO_DIV
                 , ANNO_ATTO_DIV, ATTO_DIV, PARTE_DIV, SERIE_DIV, UFFICIO_DIV
                 , NOTE
                 , ATTO_NAS_DIGITALE, ATTO_MAT_DIGITALE, ATTO_VED_DIGITALE, ATTO_DIV_DIGITALE, ATTO_MOR_DIGITALE
                 )
          values (
-- MATRICOLA
                   w_matricola
-- COGNOME_NOME
                 , rec.COGNOME||'/'||rec.NOME
-- FASCIA
                 , w_fascia
-- STATO
                 , w_stato
-- DATA_ULT_EVE
                 , to_char(sysdate,'j')
-- COD_FAM
                 , w_cod_fam
-- STATO_CIVILE
                 , w_stato_civile
-- SESSO
                 , rec.SESSO
-- NAZIONALITA
                 , f_ADS_nazionalita(rec.CIT_CODICESTATO)
-- DATA_INIZIO_NAZ
                 , f_ADS_data(rec.CIT_DATAVALIDITA)
-- PATERNITA
		 , decode(rec.COGNOME_PD,'','',rec.COGNOME_PD||'/')||rec.NOME_PD
-- MATRICOLA_PD
                 , to_number(null)
-- MATERNITA
		 , decode(rec.COGNOME_MD,'','',rec.COGNOME_MD||'/')||rec.NOME_MD
-- MATRICOLA_MD
                 , to_number(null)
-- TITOLO_STUDIO
                 , f_ADS_titolo_studio(rec.TITOLOSTUDIO)
-- COD_PROF
                 , to_number(null)
-- ATTIVITA_PROF
                 , to_number(null)
-- POSIZIONE_PROF
                 , f_ADS_posizione_prof(rec.POSIZIONEPROFESSIONALE)
-- COD_PRO_NAS
                 , w_cod_pro_NAS
-- COD_COM_NAS
                 , w_cod_com_NAS
-- DATA_NAS
                 , f_ADS_data(rec.DATANASCITA)
-- ANNO_NAS
                 , decode(rec.SENZAGIORNOMESE,'','','S')
-- COD_PRO_ATTO_NAS
                 , w_cod_pro_ATTNAS
-- COD_COM_ATTO_NAS
                 , w_cod_com_ATTNAS
-- ANNO_ATTO_NAS
                 , w_anno_atto_nas
-- ATTO_NAS
                 , w_atto_nas
-- PARTE_NAS
                 , w_parte_nas
-- SERIE_NAS
                 , w_serie_nas
-- UFFICIO_NAS
                 , w_ufficio_nas
-- ANNO_ATTO_NAS_TR
                 , to_number(null)
-- ATTO_NAS_TR
                 , to_number(null)
-- PARTE_NAS_TR
                 , to_number(null)
-- SERIE_NAS_TR
                 , to_char(null)
-- UFFICIO_NAS_TR
                 , to_number(null)
-- COD_FISCALE
                 , rec.CODFISCALE
-- CF_CALCOLATO
                 , decode(rec.CODFISCALE,'','',
                     decode(rec.VALIDITACF,'1',to_char(null),'S'))
-- DATA_REG
                 , to_char(sysdate,'j')
-- COGNOME_NOME_CN
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then
                            decode(rec.COGNOME_CN,'','',rec.COGNOME_CN||'/')||rec.NOME_CN
                       when w_stato_civile in ('UC','VU','GU') then
                            decode(rec.COGNOME_UC,'','',rec.COGNOME_UC||'/')||rec.NOME_UC
                   end
-- MATRICOLA_CN
                 , to_number(null)
-- COD_PRO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_cod_pro_MAT
                       when w_stato_civile in ('UC','VU','GU')           then w_cod_pro_UCI
                   end
-- COD_COM_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_cod_com_MAT
                       when w_stato_civile in ('UC','VU','GU')           then w_cod_com_UCI
                   end
-- DATA_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then f_ADS_data(rec.MAT_DATAEVENTO)
                       when w_stato_civile in ('UC','VU','GU')           then f_ADS_data(rec.UCI_DATAEVENTO)
                   end
-- ANNO_MAT
                 , to_char(null)
-- COD_PRO_ATTO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_cod_pro_ATTMAT
                       when w_stato_civile in ('UC','VU','GU')           then w_cod_pro_ATTUCI
                   end
-- COD_COM_ATTO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_cod_com_ATTMAT
                       when w_stato_civile in ('UC','VU','GU')           then w_cod_com_ATTUCI
                   end
-- ANNO_ATTO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_anno_atto_mat
                       when w_stato_civile in ('UC','VU','GU')           then w_anno_atto_uci
                   end
-- ATTO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_atto_mat
                       when w_stato_civile in ('UC','VU','GU')           then w_atto_uci
                   end
-- PARTE_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_parte_mat
                       when w_stato_civile in ('UC','VU','GU')           then w_parte_uci
                   end
-- SERIE_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_serie_mat
                       when w_stato_civile in ('UC','VU','GU')           then w_serie_uci
                   end
-- UFFICIO_MAT
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then w_ufficio_mat
                       when w_stato_civile in ('UC','VU','GU')           then w_ufficio_uci
                   end
-- ANNO_ATTO_MAT_TR
                 , to_number(null)
-- ATTO_MAT_TR
                 , to_number(null)
-- PARTE_MAT_TR
                 , to_number(null)
-- SERIE_MAT_TR
                 , to_char(null)
-- UFFICIO_MAT_TR
                 , to_number(null)
-- COD_PRO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_cod_pro_VED
                       when w_stato_civile in ('VU')      then w_cod_pro_SCI
                   end
-- COD_COM_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_cod_com_VED
                       when w_stato_civile in ('VU')      then w_cod_com_SCI
                   end
-- DATA_VED
                 , case
                       when w_stato_civile in ('VE','NC') then f_ADS_data(rec.VED_DATAEVENTO)
                       when w_stato_civile in ('VU')      then f_ADS_data(rec.SCI_DATAEVENTO)
                   end
-- COD_PRO_ATTO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_cod_pro_ATTVED
                       when w_stato_civile in ('VU')      then w_cod_pro_ATTSCI
                   end
-- COD_COM_ATTO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_cod_com_ATTVED
                       when w_stato_civile in ('VU')      then w_cod_com_ATTSCI
                   end
-- ANNO_ATTO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_anno_atto_ved
                       when w_stato_civile in ('VU')      then w_anno_atto_sci
                   end
-- ATTO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_atto_ved
                       when w_stato_civile in ('VU')      then w_atto_sci
                   end
-- PARTE_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_parte_ved
                       when w_stato_civile in ('VU')      then w_parte_sci
                   end
-- SERIE_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_serie_ved
                       when w_stato_civile in ('VU')      then w_serie_sci
                   end
-- UFFICIO_VED
                 , case
                       when w_stato_civile in ('VE','NC') then w_ufficio_ved
                       when w_stato_civile in ('VU')      then w_ufficio_sci
                   end
-- COD_PRO_DIV
                 , to_number(null)
-- COD_COM_DIV
                 , to_number(null)
-- DATA_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then f_ADS_data(rec.DIV_DATAVALIDITASENTENZA)
                       when w_stato_civile in ('GU')           then f_ADS_data(rec.SCI_DATAEVENTO)
                   end
-- COD_PRO_ATTO_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_cod_pro_ATTDIV
                       when w_stato_civile in ('GU')           then w_cod_pro_ATTSCI
                   end
-- COD_COM_ATTO_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_cod_com_ATTDIV
                       when w_stato_civile in ('GU')           then w_cod_com_ATTSCI
                   end
-- ANNO_ATTO_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_anno_atto_div
                       when w_stato_civile in ('GU')           then w_anno_atto_sci
                   end
-- ATTO_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_atto_div
                       when w_stato_civile in ('GU')           then w_atto_sci
                   end
-- PARTE_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_parte_div
                       when w_stato_civile in ('GU')           then w_parte_sci
                   end
-- SERIE_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_serie_div
                       when w_stato_civile in ('GU')           then w_serie_sci
                   end
-- UFFICIO_DIV
                 , case
                       when w_stato_civile in ('DV','GC','NC') then w_ufficio_div
                       when w_stato_civile in ('GU')           then w_ufficio_sci
                   end
-- NOTE
                 , w_note_ana
-- ATTO_NAS_DIGITALE
                 , rec.attnas_idansc
-- ATTO_MAT_DIGITALE
                 , case
                       when w_stato_civile in ('CN','VE','DV','GC','NC') then rec.attmat_idansc
                       when w_stato_civile in ('UC','VU','GU')           then rec.attuci_idansc
                   end
-- ATTO_VED_DIGITALE
                 , case
                       when w_stato_civile in ('VE','NC') then rec.attved_idansc
                       when w_stato_civile in ('VU')      then rec.attsci_idansc
                   end
-- ATTO_DIV_DIGITALE
                 , case
                       when w_stato_civile in ('DV','GC','NC') then rec.attdiv_idansc
                       when w_stato_civile in ('GU')           then rec.attsci_idansc
                   end
-- ATTO_MOR_DIGITALE
                 , rec.attmor_idansc
                 )
           ;
           ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'inserito matricola '||w_matricola);
         exception
           when others then
                w_errore := 'Errore in ins_anaana '||w_fascia||'-'||w_stato||' ('||SQLERRM||')';
                raise errore;
         end;

         begin
           anpr_pkg.ins_anpads('VANP',w_matricola,null,null,null,null,'Individuale','','');
         exception
           when others then
                w_errore := 'Errore in anpr_pkg.ins_anpads - Individuale ('||SQLERRM||')';
                raise errore;
         end;

         begin
           anpr_pkg.upd_anpads('VANP',w_matricola,rec.idSoggettoANPR,null,null,null,null,null);
         exception
           when others then
                w_errore := 'Errore in anpr_pkg.upd_anpads - Individuale ('||SQLERRM||')';
                raise errore;
         end;

         begin
           anpr_pkg.ins_anpads('VANP',w_matricola,null,null,null,rec.fam_idfamigliaanpr,'Famiglia ANPR','','',a_num_componenti_anpr,rec.fam_codiceLegame);
         exception
           when others then
                w_errore := 'Errore in anpr_pkg.ins_anpads - Famiglia ANPR ('||SQLERRM||')';
                raise errore;
         end;

         if rtrim(ltrim(rec.DI_NUMERO)) is not null then
            if nvl(rtrim(rec.DI_CARTACEAELETTRONICA),'0') = '1' then
               w_tipo_DI := 'CE';
            else
               w_tipo_DI := 'CI';
            end if;

            if rtrim(rec.DI_INTERDIZIONEESPATRIO) = 'N' then
               w_espatrio_DI := 'S';
            else
               w_espatrio_DI := '';
            end if;

            begin
              insert into anadoc
                     ( MATRICOLA
                     , TIPO_DOCUMENTO
                     , PROGR_DOCUMENTO
                     , NATURA_DOCUMENTO
                     , ENTE_EMISSIONE
                     , DATA_EMISSIONE
                     , COD_PRO_ENTE
                     , COD_COM_ENTE
                     , NUMERO
                     , ESPATRIO
                     , DATA_SCADENZA
                     )
              values ( w_matricola
                     , w_tipo_DI
                     , 1
                     , 'O'
                     , 1
                     , f_ADS_data(rec.DI_DATARILASCIO)
                     , w_cod_pro_DI
                     , w_cod_com_DI
                     , rec.DI_NUMERO
                     , w_espatrio_DI
                     , f_ADS_data(rec.DI_DATASCADENZA)
                     )
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anadoc ('||SQLERRM||')';
                   ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
             end;

         else
            ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'DI_NUMERO null');
         end if;

         if rtrim(ltrim(rec.DS_NUMERO)) is not null then
            w_tipo_DS := f_ADS_tipo_soggiorno(rec.DS_TIPOSOGGIORNO);
            if rtrim(ltrim(rec.DS_CODICEISTAT,'0')) is null then
               w_ente_DS := 7;
            else
               w_ente_DS := 1;
            end if;

            begin
              insert into anadoc
                     ( MATRICOLA
                     , TIPO_DOCUMENTO
                     , PROGR_DOCUMENTO
                     , NATURA_DOCUMENTO
                     , ENTE_EMISSIONE
                     , DATA_EMISSIONE
                     , DATA_SCADENZA
                     , COD_PRO_ENTE
                     , COD_COM_ENTE
                     , NUMERO
                     , NOTE
                     )
              values ( w_matricola
                     , w_tipo_DS
                     , 1
                     , 'O'
                     , w_ente_DS
                     , f_ADS_data(rec.DS_DATARILASCIO)
                     , f_ADS_data(rec.DS_DATASCADENZA)
                     , w_cod_pro_DS
                     , w_cod_com_DS
                     , rec.DS_NUMERO
                     , 'Questura rilascio: '||rec.DS_QUESTURARILASCIOSOGGIORNO
                     )
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anadoc ('||SQLERRM||')';
                   ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
            end;
         else
            ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', 'DS_NUMERO null');
         end if;

         if rec.DIV_NUMEROSENTENZA is not null or rec.SCI_NUMEROSENTENZA is not null then
            begin
              delete anasen
               where matricola        = w_matricola
                 and anagrafe_tpr     = 'ANP'
                 and tipo_evento_tpr  = 'I'
                 and anno_pratica_tpr = 0
                 and pratica_tpr      = 0
              ;
            exception
              when others then
                   w_errore := 'Errore in del_anasen ('||SQLERRM||')';
                   ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
            end;

            if rec.DIV_NUMEROSENTENZA is not null then
               w_tipo_sentenza_SEN      := f_ADS_tipo_sentenza(rec.DIV_TIPOCESSAZIONE, rec.DIV_TIPOTRIBUNALESENTENZA);
               w_tipo_provvedimento_SEN := f_ADS_tipo_provvedimento(rec.DIV_TIPOTRIBUNALESENTENZA);
               w_ente_provvedimento_SEN := f_ADS_ente_provvedimento(rec.DIV_TIPOTRIBUNALESENTENZA, rec.DIV_TIPOCESSAZIONE);
            elsif rec.SCI_NUMEROSENTENZA is not null then
               w_tipo_sentenza_SEN      := f_ADS_tipo_sentenza(rec.SCI_MOTIVOSCIOGLIMENTO, rec.SCI_TIPOTRIBUNALESENTENZA);
               w_tipo_provvedimento_SEN := f_ADS_tipo_provvedimento(rec.SCI_TIPOTRIBUNALESENTENZA);
               w_ente_provvedimento_SEN := f_ADS_ente_provvedimento(rec.SCI_TIPOTRIBUNALESENTENZA, rec.SCI_MOTIVOSCIOGLIMENTO);
            end if;

            begin
              insert into anasen
                     ( MATRICOLA
                     , TIPO_SENTENZA
                     , COD_PRO_TRIB
                     , COD_COM_TRIB
                     , DATA_DECRETO
                     , NUMERO_DECRETO
                     , COD_PRO_ATTO_TR
                     , COD_COM_ATTO_TR
                     , DATA_ATTO_TR
                     , ANNO_ATTO_TR
                     , ATTO_TR
                     , PARTE_ATTO_TR
                     , SERIE_ATTO_TR
                     , UFFICIO_ATTO_TR
                     , ATTO_TR_DIGITALE
                     , TIPO_PROVVEDIMENTO
                     , ENTE_PROVVEDIMENTO
                     , AUTORE_PROVVEDIMENTO
                     , ANAGRAFE_TPR
                     , TIPO_EVENTO_TPR
                     , ANNO_PRATICA_TPR
                     , PRATICA_TPR
                     )
              values ( w_matricola
-- TIPO_SENTENZA
                     , w_tipo_sentenza_SEN
-- COD_PRO_TRIB
                     , to_number(null)
-- COD_COM_TRIB
                     , to_number(null)
-- DATA_DECRETO
                     , case
                           when rec.DIV_NUMEROSENTENZA is not null then f_ADS_data(rec.DIV_DATASENTENZA)
                           when rec.SCI_NUMEROSENTENZA is not null then f_ADS_data(rec.SCI_DATASENTENZA)
                       end
-- NUMERO_DECRETO
                     , case
                           when rec.DIV_NUMEROSENTENZA is not null then rec.DIV_NUMEROSENTENZA
                           when rec.SCI_NUMEROSENTENZA is not null then rec.SCI_NUMEROSENTENZA
                       end
-- COD_PRO_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_cod_pro_ATTDIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_cod_pro_ATTSCI
                       end
-- COD_COM_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_cod_com_ATTDIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_cod_com_ATTSCI
                       end
-- DATA_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then f_ADS_data(rec.ATTDIV_DATAFORMAZIONEATTO)
                           when rec.SCI_NUMEROSENTENZA is not null then f_ADS_data(rec.ATTSCI_DATAFORMAZIONEATTO)
                       end
-- ANNO_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_ANNO_ATTO_DIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_ANNO_ATTO_SCI
                       end
-- ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_ATTO_DIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_ATTO_SCI
                       end
-- PARTE_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_PARTE_DIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_PARTE_SCI
                       end
-- SERIE_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_SERIE_DIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_SERIE_SCI
                       end
-- UFFICIO_ATTO_TR
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then w_UFFICIO_DIV
                           when rec.SCI_NUMEROSENTENZA is not null then w_UFFICIO_SCI
                       end
-- ATTO_TR_DIGITALE
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then rec.ATTDIV_idansc
                           when rec.SCI_NUMEROSENTENZA is not null then rec.ATTSCI_idansc
                       end
-- TIPO_PROVVEDIMENTO
                     , w_tipo_provvedimento_SEN
-- ENTE_PROVVEDIMENTO
                     , w_ente_provvedimento_SEN
-- AUTORE_PROVVEDIMENTO
                     ,  case
                           when rec.DIV_NUMEROSENTENZA is not null then rec.DIV_AUTORITASENTENZA
                           when rec.SCI_NUMEROSENTENZA is not null then rec.SCI_AUTORITASENTENZA
                       end
-- ANAGRAFE_TPR
                     , 'ANP'
-- TIPO_EVENTO_TPR
                     , 'I'
-- ANNO_PRATICA_TPR
                     , 0
-- PRATICA_TPR
                     , 0
                     )
              ;
            exception
              when others then
                   w_errore := 'Errore in ins_anasen ('||SQLERRM||')';
                   ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
            end;
         end if;
     end loop;
     a_matricola_ads := w_matricola;
  end if;
exception
  when errore then
       ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
  when others then
       w_errore := 'errore anaana_ANPR_ins ('||SQLERRM||')';
       ANPR_pkg.ins_log('VANP', 'anaana_ANPR_ins', w_errore);
end;
/
