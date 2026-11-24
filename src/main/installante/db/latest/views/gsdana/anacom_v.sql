--liquibase formatted sql
--changeset amonopoli:202606171100 runAlways:true runOnChange:true stripComments:false
create or replace view anacom_v
as
select com.*,
       'S' flag_dettagli,
       f_ANA_flag_protocollo(com.id,com.codice_co,com.anagrafe,com.tipo_evento) flag_protocollo,
       f_ANA_flag_albo_pretorio(com.id,com.codice_co,com.anagrafe,com.tipo_evento) flag_albo_pretorio,
       f_ANA_des_comunicazione(com.codice_co,com.matricola,'S',com.id) des_nome_file_comunicazione,
       f_ANA_des_comunicazione(com.codice_co,com.matricola) des_comunicazione,
       (select id_anadep from anadct where anagrafe = com.anagrafe and tipo_evento = com.tipo_evento and codice_co = com.codice_co) id_anadep
  from anacom com
/
comment on table anacom_v is 'Anagrafe - Comunicazioni da stampare (view)'
/
