--liquibase formatted sql
--changeset amonopoli:202608041125_2 runOnChange:true stripComments:false
create or replace view tabrep_ELEV
       (terminale,
        p_evento, p_data_eve, p_pratica, p_anno_pratica,
        w_flag_ripristino,
        w_terminalista, w_note_par)
as
select terminale,
       to_number(substr(parametri,1,2)),to_number(substr(parametri,3,7)),
       to_number(substr(parametri,10,4)),to_number(substr(parametri,14,4)),
       nvl(substr(parametri,18,1),'N'),
       rtrim(substr(parametri,19,8)),
       rtrim(substr(parametri,27))
      from tabrep
     where chiave    = 'ELEV'
/
comment on table tabrep_ELEV is 'Anagrafe - Parametri per elaborazione Eliminazione Eventi (view)'
/
