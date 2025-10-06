--liquibase formatted sql
--changeset amonopoli:202407301545_2 runOnChange:true stripComments:false
create or replace view GTE_LOG_V
AS
select log.*
     , '['||log.modulo_rif||'] '||
         decode(log.note, '', '', log.note||' ')||
         '('||log.id_rif||')' note_vis
  from gte_log log
/
comment on table GTE_LOG is 'Gestione Testi - Tabella di Log (view)'
/
