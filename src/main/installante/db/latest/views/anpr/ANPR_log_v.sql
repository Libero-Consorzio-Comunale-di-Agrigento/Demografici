--liquibase formatted sql
--changeset amonopoli:202305260925_3 runAlways:true runOnChange:true stripComments:false
create or replace view ANPR_LOG_v
AS
select v.*
     , '('||v.servizio||') '||v.note||
         decode(v.flag_errore,'','',' [errore]') note_vis
     , v.campo_clob info_vis
  from (select t.ID
             , t.DATA_ORA
             , t.SERVIZIO
             , t.OPERAZIONE
             , t.NOTE
             , t.CAMPO_CLOB
             , f_ANPR_flag_errore_log(t.servizio, t.operazione, t.note, t.campo_clob) flag_errore
             , f_ANPR_info_errore_log(t.servizio, t.operazione, t.note, 'MATRICOLA', t.campo_clob) matricola_errore
             , f_ANPR_info_errore_log(t.servizio, t.operazione, t.note, 'INFO', t.campo_clob) info_errore
          from anpr_log t) v
/
comment on table ANPR_LOG_v is 'ANPR - Tabella di Log (view)'
/
