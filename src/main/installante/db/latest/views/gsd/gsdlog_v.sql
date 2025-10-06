--liquibase formatted sql
--changeset amonopoli:202506111115_2 runAlways:true runOnChange:true stripComments:false
create or replace view GSDLOG_V
AS
select t.log_id id
     , t.d_data_reg data_ora
     , t.operazione
     , t.note
     , t.parametri||decode(t.note,'','',' - '||t.note) note_vis
     , t.campo_clob
     , t.fase
     , t.parametri
  from gsdlog t
/
comment on table GSDLOG_V is 'Servizi Demografici - Log Applicativi (view)'
/
