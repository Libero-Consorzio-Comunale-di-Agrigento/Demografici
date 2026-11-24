--liquibase formatted sql
--changeset amonopoli:202510080945 runOnChange:true stripComments:false
create or replace view anamsg_zk
  (matricola, sequenza, messaggio, dettaglio,
         flag_avviso, flag_cer, flag_sfa, flag_cdi, flag_ana, flag_ele)
AS
select v.MATRICOLA
     , v.SEQUENZA
     , v.MESSAGGIO
     , f_varchar2nvarchar(v.DETTAGLIO) dettaglio
     , v.FLAG_AVVISO
     , v.FLAG_CER
     , v.FLAG_SFA
     , v.FLAG_CDI
     , v.FLAG_ANA
     , v.FLAG_ELE
  from anamsg v 
 where v.messaggio is not null
UNION
select ana.matricola
     , diz.id
     , 'Soggetto con caratteri speciali' messaggio
     , diz.descrizione||': '||uni.cognome_nome dettaglio
     , 'S'
     , 'S'
     , ''
     , ''
     , 'S'
     , 'S'
  from gsdana_unicode_diz diz
     , anaana ana
     , gsdana_unicode uni
 where diz.codice       = uni.campo_rif
   and diz.modulo_rif   in ('ANA','GSD')
   and ana.matricola    = to_number(uni.id_rif)
   and uni.tabella_rif  = 'ANAANA'
/
comment on table anamsg_zk is 'Anagrafe - Messaggi Individuo - ZK (view)'
/
