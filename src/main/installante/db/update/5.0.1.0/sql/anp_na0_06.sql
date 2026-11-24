--liquibase formatted sql
--changeset amonopoli:202512111140 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANPNA0';
w_nome_col      varchar2(255) := 'SEP_idAnsc_ACCSEP';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table anpna0
add
(SEP_idAnsc_ACCSEP		varchar2(255)
,SEP_nomeComune_ACCSEP		varchar2(255)
,SEP_codiceIstat_ACCSEP		varchar2(255)
,SEP_siglaProvinciaIstat_ACCSEP	varchar2(255)
,SEP_anno_ACCSEP		varchar2(255)
,SEP_numeroComunale_ACCSEP	varchar2(255)
,SEP_idTipoContenuto_ACCSEP	varchar2(255)
,SEP_numeroAtto_ACCSEP		varchar2(255)
,SEP_tipologia_ACCSEP		varchar2(255)
)';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
