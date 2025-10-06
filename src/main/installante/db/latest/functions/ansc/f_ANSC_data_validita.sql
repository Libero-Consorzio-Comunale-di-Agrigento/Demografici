--liquibase formatted sql
--changeset amonopoli:202405281355 runOnChange:true stripComments:false
create or replace function f_ANSC_data_validita
(a_tipo_atto		IN 	number
,a_sigla_categoria	IN	varchar2
,a_natura		IN	varchar2
,a_data_evento		IN 	date
,a_data_atto_utente	IN 	date
)

return date

IS

w_data_validita		date;

begin
-- 21/05/2024 (CO)
-- in generale sarebbe utile (quasi indispensabile) implementare con una gestione similare a quella di ANSC 
-- che lascia l'onere all'ufficiale di decidere se notificare o meno, e con che data.
-- Questo ci metterebbe al riparo da contestazioni su eventuali automatismi non corretti.
-- Soprattutto, ad es., sulle Trascrizioni e gli atti a testo libero diventa infatti difficile 
-- riuscire a stabilire una regola valida per tutte le casistiche che possono essere trattate.
-- Rifacendo poi l'anagrafe sarà utile modificare la gestione anche da questo punto di vista, 
-- dando sempre e comunque la possibilità all'ufficiale di anagrafe di modificare la data proposta.

  if a_tipo_atto = 1 then
	-- OK DATA DECORRENZA CIVCIT:
	-- DAQ - DECRETO ACQUISTO
	-- ASM - ATTESTAZIONE SINDACO MINORE
	-- AS1 - ATTESTAZIONE SINDACO 18ENNE
	-- ASA - ATTESTAZIONE SINDACO ATTRIBUZIONE
	-- DPE - DECRETO PERDITA
	-- R18 - RICHIESTA 18ENNE
     if a_sigla_categoria in ('DAQ','ASM','AS1','ASA','DPE','R18') then
        w_data_validita := a_data_evento;	-- cit.data_decorrenza

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI:
	-- ATL - ATTO A TESTO LIBERO
     elsif a_sigla_categoria in ('ATL') and a_natura in ('A','P') then
        w_data_validita := a_data_evento;	-- cit.data_decorrenza

     else
        w_data_validita := a_data_atto_utente;
     end if;

  elsif a_tipo_atto = 2 then
	-- OK DATA EVENTO
	-- O1A - PARTE 1 SERIE A
	-- O1B - PARTE 1 SERIE B
	-- T2A - PARTE 2 SERIE A
	-- CNA - CENTRO NASCITA
     if a_sigla_categoria in ('O1A','O1B','T2A','CNA') then
        w_data_validita := a_data_evento;	-- nas.data_nas

	-- IN QUESTI CASI E' PIU' PROBABILE CHE SIA LA DATA TRASCRIZIONE DELL'ATTO. 
	-- RICADONO IN QUESTA CASISTICA ANCHE ATTI CHE NON COMPORTANO EVENTO DI ISCRIZIONE ANAGRAFICA 
	-- (es. straniero che acquista la citt e quindi viene trascritto l'atto di nascita) MA SOLO DI RETTIFICA.
	-- TEA - TRASCRIZIONE ESTERO (AUTORITA')
	-- TEP - TRASCRIZIONE ESTERO (PRIVATO)
     elsif a_sigla_categoria in ('TEA','TEP') then
        w_data_validita := a_data_atto_utente;

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- ATL - ATTO A TESTO LIBERO
	-- CGE - CAMBIO GENERALITA'
	-- ADO - ADOZIONE NAZIONALE / INTERNAZIONALE
     elsif a_sigla_categoria in ('ATL','CGE','ADO') then
        w_data_validita := a_data_atto_utente;

     else
        w_data_validita := a_data_atto_utente;
     end if;

  elsif a_tipo_atto = 4 then
	-- OK DATA EVENTO
	-- O1 - PARTE 1
	-- O2A - PARTE 2 SERIE A
	-- T2B - PARTE 2 SERIE B
	-- CPD - CIVILE PER DELEGA
	-- TMC - TRASCRIZIONE MATRIMONIO CIVILE
	-- TMD - TRASCRIZIONE MATRIMONIO CIVILE SU DELEGA
	-- FCC - FUORI DALLA CASA COMUNALE
	-- PDV - PERICOLO DI VITA
     if a_sigla_categoria in ('O1','O2A','T2B','CPD','TMC','TMD','FCC','PDV') then
        w_data_validita := a_data_evento;	-- mat.data_mat

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- ATL - ATTO A TESTO LIBERO
	-- TEP - TRASCRIZIONE ESTERO (PRIVATO)
	-- TEA - TRASCRIZIONE ESTERO (AUTORITA')
     elsif a_sigla_categoria in ('ATL','TEA','TEP') then
        w_data_validita := a_data_atto_utente;

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- IN ALCUNI CASI SAREBBE INFATTI LA DATA ACCORDO, 
	-- IN ALTRI OCCORREREBBE VERIFICARE IL DETTAGLIO DEL PROVVEDIMENTO
	-- UCO - UFFICIALE DI STATO CIVILE - CONFERMA (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)
	-- AVV - AVVOCATI (CESSAZIONE / SCIOGLIMENTO / SEPARAZIONE)
	-- TRI - TRIBUNALE (CESSAZIONE / SCIOGLIMENTO)
	-- EST - DIVORZIO ESTERO
     elsif a_sigla_categoria in ('UCO','AVV','TRI','EST') then
        w_data_validita := a_data_atto_utente;

     else
        w_data_validita := a_data_atto_utente;
     end if;

  elsif a_tipo_atto = -4 then
	-- OK DATA EVENTO
	-- O1 - UNIONE CIVILE
	-- UCN - UNIONE CIVILE - CONIUGI
	-- FCC - UNIONE CIVILE - FUORI DALLA CASA COMUNALE
	-- PDV - UNIONE CIVILE - PERICOLO DI VITA
	-- UPD - UNIONE CIVILE PER DELEGA
	-- T2 - TRASCRIZIONE UNIONE CIVILE
	-- TPD - TRASCRIZIONE UNIONE CIVILE - PER DELEGA
     if a_sigla_categoria in ('O1','UCN','FCC','PDV','UPD','T2','TPD') then
        w_data_validita := a_data_evento;	-- uci.data_mat

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- TEP - TRASCRIZIONE ESTERO (PRIVATO)
	-- TEA - TRASCRIZIONE ESTERO (AUTORITA)
	-- ATL - ATTO A TESTO LIBERO
     elsif a_sigla_categoria in ('ATL','TEA','TEP') then
        w_data_validita := a_data_atto_utente;

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- IN ALCUNI CASI SAREBBE INFATTI LA DATA ACCORDO, IN ALTRI OCCORREREBBE VERIFICARE IL DETTAGLIO DEL PROVVEDIMENTO
	-- UCO - SCIOGLIMENTO UNIONE CIVILE - UFFICIALE (CONFERMA)
	-- AVV - SCIOGLIMENTO UNIONE CIVILE - AVVOCATI
	-- TRI - SCIOGLIMENTO UNIONE CIVILE - TRIBUNALE ITALIANO
	-- EST - SCIOGLIMENTO UNIONE CIVILE - TRIBUNALE ESTERO
	-- ANN - NULLITA' UNIONE CIVILE
     elsif a_sigla_categoria in ('UCO','AVV','TRI','EST','ANN') then
        w_data_validita := a_data_atto_utente;

     else
        w_data_validita := a_data_atto_utente;
     end if;

  elsif a_tipo_atto = 5 then
	-- OK DATA EVENTO
	-- O1 - PARTE 1
	-- T2A - PARTE 2 SERIE A
	-- O2B - PARTE 2 SERIE B
	-- T2B - PARTE 2 SERIE B BIS
	-- BIS - DECEDUTO IN OSPEDALE DI ALTRO COMUNE
     if a_sigla_categoria in ('O1','T2A','O2B','T2B','BIS') then
        w_data_validita := a_data_evento;	-- mor.data_mor

	-- QUESTO E' UNO DI QUEI CASI DI CUI ALLA MIA PREMESSA; EVITEREI AUTOMATISMI
	-- ATL - ATTO A TESTO LIBERO
	-- TEP - TRASCRIZIONE ESTERO (PRIVATO)
	-- TEA - TRASCRIZIONE ESTERO (AUTORITA')
	-- CIG - CADUTO IN GUERRA
	-- MPR - MORTE PRESUNTA
    elsif a_sigla_categoria in ('ATL','TEP','TEA','CIG','MPR') then
        w_data_validita := a_data_atto_utente;

     else
        w_data_validita := a_data_atto_utente;
     end if;
  end if;

  if w_data_validita is null and a_data_atto_utente is not null then
     w_data_validita := a_data_atto_utente;
  end if;

  return w_data_validita;

end;
/
