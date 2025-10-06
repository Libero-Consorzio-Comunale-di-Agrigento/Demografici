--liquibase formatted sql
--changeset amonopoli:202310201850 runAlways:true runOnChange:true stripComments:false
create or replace view ansnot_v
as
select n.ID
     , n.ID_SOGGETTO_ANSC
     , n.ID_ANSC
     , n.STATO
     , n.GENERE
     , n.VALIDO_DAL
     , n.VALIDO_AL
     , n.ID_COMUNE_COMPETENTE
     , n.ID_COMUNE_FORMAZIONE
     , n.ID_OPERAZIONE
     , n.DESCRIZIONE
     , decode(n.cognome_soggetto_ansc||n.nome_soggetto_ansc,'',
         f_ANSC_get_cognome_sog(n.id_soggetto_ansc),
         n.COGNOME_SOGGETTO_ANSC) cognome_soggetto_ansc
     , decode(n.cognome_soggetto_ansc||n.nome_soggetto_ansc,'',
         f_ANSC_get_nome_sog(n.id_soggetto_ansc),
         n.NOME_SOGGETTO_ANSC) nome_soggetto_ansc
     , f_ANSC_get_comune_x_id(n.id_comune_formazione) des_comune_formazione
     , n.canale_comunicazione_ansc
  from ansnot n
/
comment on table ansnot_v is 'ANSC - Notifiche (view)'
/
