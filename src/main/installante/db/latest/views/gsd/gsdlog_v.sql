--liquibase formatted sql
--changeset amonopoli:202506111115_2 runOnChange:true stripComments:false
create or replace view GSDLOG_V
AS
select t.log_id id
     , t.d_data_reg data_ora
     , t.operazione
     , t.note
     , t.parametri||decode(t.note,'','',' - '||t.note) note_vis
     , t.campo_clob
     , decode(t.terminalista, '', t.campo_clob,
         'Terminalista: '||f_get_nome_terminalista(t.terminalista)||' ('||t.terminalista||')') info_vis
     , t.fase
     , t.parametri
  from gsdlog t
/
comment on table GSDLOG_V is 'Servizi Demografici - Log Applicativi (view)'
/
