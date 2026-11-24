--liquibase formatted sql
--changeset amonopoli:202608041125_1 runOnChange:true stripComments:false
create or replace view tabrep_AGEV
       (terminale,
        p_evento,p_data_eve,p_pratica,p_anno_pratica,
        p_pratica_new,p_anno_pratica_new,p_cod_pro_eve_new,
        p_cod_com_eve_new,p_data_reg_new,
        p_cod_pro_iscr_aire_new,p_cod_com_iscr_aire_new,
        w_terminalista, w_note_par)
AS
select terminale, substr(parametri,1,2),substr(parametri,3,7),
       to_number(substr(parametri,10,4)),to_number(substr(parametri,14,4)),
       to_number(ltrim(substr(parametri,18,4),'0')),
       to_number(ltrim(substr(parametri,22,4),'0')),
       to_number(ltrim(substr(parametri,26,3),'0')),
       to_number(ltrim(substr(parametri,29,3),'0')),
       to_number(ltrim(substr(parametri,32,7),'0')),
       to_number(ltrim(substr(parametri,39,3),'0')),
       to_number(ltrim(substr(parametri,42,3),'0')),
       rtrim(substr(parametri,45,8)),
       rtrim(substr(parametri,53))
  from tabrep
 where chiave    = 'AGEV'
/
comment on table tabrep_AGEV is 'Anagrafe - Parametri per elaborazione Aggiornamento Eventi (view)'
/
