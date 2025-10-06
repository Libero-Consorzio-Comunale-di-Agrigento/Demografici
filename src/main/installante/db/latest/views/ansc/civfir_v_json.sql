--liquibase formatted sql
--changeset snocca:202428020930 runAlways:true runOnChange:true stripComments:false
create or replace view civfir_v_json
AS
select fir.id
     , nas.id_atto_ansc idAnsc
     , nas.id_evento_ansc idEvento
     , fir.indirizzo_mail emailDichiarante
     , fir.cognome FIR_cognome
     , fir.nome FIR_nome
     , to_char(fir.d_data_nas,'yyyy-mm-dd') FIR_data_nascita
     , fir.id_presa_visione_ansc idPresaVisione
  from civnas nas, civfir fir
 where fir.id_atto = nas.id_atto
union
select fir.id
     , mor.id_atto_ansc idAnsc
     , mor.id_evento_ansc idEvento
     , fir.indirizzo_mail emailDichiarante
     , fir.cognome FIR_cognome
     , fir.nome FIR_nome
     , to_char(fir.d_data_nas,'yyyy-mm-dd') FIR_data_nascita
     , fir.id_presa_visione_ansc idPresaVisione
  from civmor mor, civfir fir
 where fir.id_atto = mor.id_atto
union
select fir.id
     , mat.id_atto_ansc idAnsc
     , mat.id_evento_ansc idEvento
     , fir.indirizzo_mail emailDichiarante
     , fir.cognome FIR_cognome
     , fir.nome FIR_nome
     , to_char(fir.d_data_nas,'yyyy-mm-dd') FIR_data_nascita
     , fir.id_presa_visione_ansc idPresaVisione
  from civmat mat, civfir fir
 where fir.id_atto = mat.id_atto
union
select fir.id
     , uci.id_atto_ansc idAnsc
     , uci.id_evento_ansc idEvento
     , fir.indirizzo_mail emailDichiarante
     , fir.cognome FIR_cognome
     , fir.nome FIR_nome
     , to_char(fir.d_data_nas,'yyyy-mm-dd') FIR_data_nascita
     , fir.id_presa_visione_ansc idPresaVisione
  from civuci uci, civfir fir
 where fir.id_atto = uci.id_atto
union
select fir.id
     , cit.id_atto_ansc idAnsc
     , cit.id_evento_ansc idEvento
     , fir.indirizzo_mail emailDichiarante
     , fir.cognome FIR_cognome
     , fir.nome FIR_nome
     , to_char(fir.d_data_nas,'yyyy-mm-dd') FIR_data_nascita
     , fir.id_presa_visione_ansc idPresaVisione
  from civcit cit, civfir fir
 where fir.id_atto = cit.id_atto 
/
comment on table civfir_v_json is 'ANSC - Dati Firma Elettronica per request JSON (view)'
/
