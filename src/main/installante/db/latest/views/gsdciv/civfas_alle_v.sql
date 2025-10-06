--liquibase formatted sql
--changeset amonopoli:202507220945 runAlways:true runOnChange:true stripComments:false
create or replace view civfas_alle_v
AS
select fas_a.*,
-- flag_firmato_att_ansc
       f_ANSC_flag_firmato_x_fas(fas_a.id_civfas) flag_firmato_att_ansc
  FROM civfas_alle fas_a
/
comment on table civfas_alle_v is 'Stato Civile - Allegati per Fascicolo dell''Atto per Acquisizione Documenti (view)'
/
