--liquibase formatted sql
--changeset amonopoli:202504021440 runAlways:true runOnChange:true stripComments:false
create or replace view anamov_x_anasen
AS
select mov_v.*
     , sen.id      id_anasen
     , sen.privacy sen_privacy
  from anasen sen, anamov_v mov_v
 where sen.anno_progr_mov   = mov_v.anno_progr
   and sen.numero_progr_mov = mov_v.numero_progr
/
comment on table anamov_x_anasen is 'Anagrafe - Archivio Movimenti con Provvedimento / Sentenza associato (view)'
/
