--liquibase formatted sql
--changeset snocca:202211141531 runOnChange:true
create or replace function f_ANPR_ricerca_soggetto
(a_archivio_rif  	IN	varchar2
,a_cod_fiscale   	IN	varchar2
,a_cognome       	IN	varchar2
,a_nome          	IN	varchar2
,a_data_nas      	IN	varchar2
,a_data_rif      	IN	varchar2
,a_terminalista  	IN	varchar2
,a_id_soggetto_anpr	IN	varchar2	default null
,a_flag_anaana_ins	IN	varchar2	default null
)

return number

IS

w_flag_anaana_ins	varchar2(255) := upper(a_flag_anaana_ins);

w_id_operazione 	varchar2(255) := '';
w_id_operazione_cn 	varchar2(255) := '';

w_archivio_rif  	varchar2(255) := nvl(a_archivio_rif,'ANPR');
w_cod_fiscale   	varchar2(255) := a_cod_fiscale; --nvl(a_cod_fiscale,'RGGGLD66E59D548H');
w_cognome       	varchar2(255) := a_cognome;
w_nome          	varchar2(255) := a_nome;
w_data_nas      	varchar2(255) := to_char(to_date(a_data_nas,'dd/mm/yyyy'),'j');
w_data_rif      	varchar2(255) := to_char(nvl(to_date(a_data_rif,'dd/mm/yyyy'),sysdate),'j');
w_terminalista  	varchar2(255) := a_terminalista; --nvl(a_terminalista,'GSDWIN11');

w_flag_ws       	varchar2(255);
w_cod_errore_ws     	varchar2(255);
w_des_errore_ws     	varchar2(32000);

w_idSoggetto		number;
w_idSoggetto_CN		number;
w_idSoggetto_UC		number;
w_idSoggetto_CV		number;
w_idSoggetto_PD		number;
w_idSoggetto_MD		number;

w_matricola_ads		number;
w_matricola_ctr		number;
w_matricola_1		number := '';
w_matricola_2		number := '';

w_integrazione_ansc	varchar2(255) := f_valore_inp('ANSC',1,1,'X','S');
w_ambiente_ansc		varchar2(255);
w_ambiente_anpr		varchar2(255);

w_comune_cliente	varchar2(255);

errore			exception;
w_errore		varchar2(4000);

begin

  w_id_operazione := '';
  ANPCIU_NR(w_id_operazione,'3002');

  if a_id_soggetto_anpr is not null then
     w_cod_fiscale := '';
     w_cognome     := '';
     w_nome        := '';
     w_data_nas    := '';
  end if;

  begin
    insert into anpciu_par (id_operazione, cod_fiscale, cognome, nome, data_nas, data_Rif, id_scheda_anpr)
    values (w_id_operazione, w_cod_fiscale, w_cognome, w_nome, w_data_nas, w_data_rif, a_id_soggetto_anpr)
    ;
    insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, matricola, terminalista)
    values (w_id_operazione, '3002', 'C', w_archivio_rif, to_number(null), w_terminalista)
    ;
  end;
  commit;

  begin
    select ciu.flag_INVIO_ws, err.codice_errore, ERR.testo_errore
      into w_flag_ws, w_cod_errore_ws, w_des_errore_ws
      from anperr err, anpciu CIU
     where err.id_operazione (+) = ciu.id_operazione
       and err.sequenza      (+) is null
       and ciu.id_operazione = w_id_operazione
    ;
    if w_cod_errore_ws = 'EN122' then
       return -1;
    end if;
  exception
    when others then
         w_flag_ws := '';
  end;

  if w_flag_ws is not null then
     begin
       select a.idSoggettoANPR, a.idSoggettoANPR_CN, a.idSoggettoANPR_UC, a.idSoggettoANPR_CV, a.idSoggettoANPR_PD, a.idSoggettoANPR_MD
         into w_idSoggetto, w_idSoggetto_CN, w_idSoggetto_UC, w_idSoggetto_CV, w_idSoggetto_PD, w_idSoggetto_MD
         from anpana a
        where tra_cognome||tra_nome||tra_denominazioneToponimo||tra_denominazioneComune is not null
          and id_operazione = w_id_operazione
       ;
       delete anpana_id
        where idSoggettoANPR = w_idSoggetto
       ;
       insert into anpana_id
              (id_operazione, idSoggettoANPR, idSoggettoANPR_CN, idSoggettoANPR_UC, idSoggettoANPR_CV, idSoggettoANPR_PD, idSoggettoANPR_MD)
       values (w_id_operazione, w_idSoggetto, w_idSoggetto_CN, w_idSoggetto_UC, w_idSoggetto_CV, w_idSoggetto_PD, w_idSoggetto_MD)
       ;
       if nvl(w_flag_anaana_ins,'N') = 'S' then
          w_matricola_ctr := f_ADS_matricola(w_idSoggetto,'','','','','');
          if w_matricola_ctr is null then
             anaana_anpr_ins(w_idSoggetto, w_id_operazione, w_matricola_ads, 'ANP', '');
             commit;
          end if;
          w_matricola_1 := w_matricola_ads;

       elsif nvl(w_integrazione_ansc,'N') = 'S' then
          w_ambiente_ansc := rtrim(f_ANSC_valore_inp('AMBIENTE',1,10,'X','S'));
          w_matricola_ctr := '';
          w_matricola_ctr := f_ADS_matricola(w_idSoggetto,'','','','','');
          if w_matricola_ctr is null then
             if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
                w_comune_cliente := f_get_comune_cliente('COD_COMUNE');
                w_ambiente_anpr  := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S');
                if w_ambiente_anpr = 'TEST' then
                   anaana_anpr_ins(w_idSoggetto, w_id_operazione, w_matricola_ads, 'ANP', '');
                   commit;
                end if;
             else
                anaana_anpr_ins(w_idSoggetto, w_id_operazione, w_matricola_ads, 'ANP', '');
                commit;
             end if; --if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
             w_matricola_1 := w_matricola_ads;
          end if;
       end if; --if nvl(w_integrazione_ansc,'N') = 'S' then
     exception
       when others then
            null;
     end;

     if w_idSoggetto_CN is not null then
        w_id_operazione_cn := '';
        ANPCIU_NR(w_id_operazione_cn,'3002');
        begin
          insert into anpciu_par (id_operazione, cod_fiscale, cognome, nome, data_nas, data_Rif, id_scheda_anpr)
          values (w_id_operazione_cn, '', '', '', '', '', w_idSoggetto_CN)
          ;
          insert into anpciu (id_operazione, servizio, tipo_operazione, archivio_rif, matricola, terminalista)
          values (w_id_operazione_cn, '3002', 'C', w_archivio_rif, to_number(null), w_terminalista)
          ;
        end;
        commit;

        begin
          select a.idSoggettoANPR, a.idSoggettoANPR_CN, a.idSoggettoANPR_UC, a.idSoggettoANPR_CV, a.idSoggettoANPR_PD, a.idSoggettoANPR_MD
            into w_idSoggetto, w_idSoggetto_CN, w_idSoggetto_UC, w_idSoggetto_CV, w_idSoggetto_PD, w_idSoggetto_MD
            from anpana a
           where tra_cognome||tra_nome||tra_denominazioneToponimo||tra_denominazioneComune is not null
             and id_operazione  = w_id_operazione_cn
             and idSoggettoANPR = w_idSoggetto_cn
          ;
          delete anpana_id
           where idSoggettoANPR = w_idSoggetto
          ;
          insert into anpana_id
                 (id_operazione, idSoggettoANPR, idSoggettoANPR_CN, idSoggettoANPR_UC, idSoggettoANPR_CV, idSoggettoANPR_PD, idSoggettoANPR_MD)
          values (w_id_operazione_cn, w_idSoggetto, w_idSoggetto_CN, w_idSoggetto_UC, w_idSoggetto_CV, w_idSoggetto_PD, w_idSoggetto_MD)
          ;

--          if nvl(w_flag_anaana_ins,'N') = 'S' then
--             w_matricola_ctr := f_ADS_matricola(w_idSoggetto,'','','','','');
--             if w_matricola_ctr is null then
--                anaana_anpr_ins(w_idSoggetto, w_id_operazione_cn, w_matricola_ads, 'ANP', '');
--                commit;
--             end if;
--             w_matricola_2 := w_matricola_ads;
--          elsif nvl(w_integrazione_ansc,'N') = 'S' then
          if nvl(w_integrazione_ansc,'N') = 'S' then
             w_ambiente_ansc := rtrim(f_ANSC_valore_inp('AMBIENTE',1,10,'X','S'));
             w_matricola_ctr := '';
             w_matricola_ctr := f_ADS_matricola(w_idSoggetto,'','','','','');
             if w_matricola_ctr is null then
                if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
                   w_comune_cliente := f_get_comune_cliente('COD_COMUNE');
                   w_ambiente_anpr  := f_ANPR_valore_inp('TIPO_INVIO',1,10,'X','S');
                   if w_ambiente_anpr = 'TEST' then
                      anaana_anpr_ins(w_idSoggetto, w_id_operazione_cn, w_matricola_ads, 'ANP', '');
                      commit;
                   end if;
                else
                   anaana_anpr_ins(w_idSoggetto, w_id_operazione_cn, w_matricola_ads, 'ANP', '');
                   commit;
                end if; --if nvl(w_ambiente_ansc,'PROD') = 'PRE' then
                w_matricola_2 := w_matricola_ads;
             end if;
          end if;
        exception
          when others then
               null;
        end;
     end if;

     if w_matricola_1 is not null and w_matricola_2 is not null then
        begin
          update anaana
             set matricola_cn = w_matricola_2
           where matricola_cn is null
             and stato_civile = 'CN'
             and fascia       = 6
             and matricola    = w_matricola_1
          ;
          update anaana
             set matricola_cn = w_matricola_1
           where matricola_cn is null
             and stato_civile = 'CN'
             and fascia       = 6
             and matricola    = w_matricola_2
          ;
          commit;
        exception
          when others then
--               w_errore := 'Errore in aggiornamento anaana_cn ('||sqlerrm||')';
--               raise errore;
               null;
        end;
     end if;

     return w_id_operazione;
  else
--     return null;
     w_errore := nvl(w_des_errore_ws,'Nessuna risposta dal web-service');
     raise errore;
  end if;
exception
  when errore then
       w_errore := 'Messaggio da ANPR: '||w_errore;
       raise_application_error(-20999, w_errore);
  when others then
       w_errore := 'Errore in fase di ricerca ANPR';
       raise_application_error(-20999, w_errore);
end;
/
