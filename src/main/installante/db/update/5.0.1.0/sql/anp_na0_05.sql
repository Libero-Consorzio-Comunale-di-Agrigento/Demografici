--liquibase formatted sql
--changeset amonopoli:202512101015 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANPNA0';
w_nome_col      varchar2(255) := 'TRA_tipoModifica';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table anpna0
add
(TRA_tipoModifica		varchar2(255)
,TRA_dataComunicazione		varchar2(255)
,TRA_nomeEnte			varchar2(255)
,TRA_dataTrascrizione		varchar2(255)
,TRA_estremiDocumento		varchar2(255)
,TRA_nomeComune			varchar2(255)
,TRA_codiceIstat		varchar2(255)
,TRA_siglaProvinciaIstat	varchar2(255)
,TRA_descrizioneLocalita	varchar2(255)
,TRA_descrizioneStato		varchar2(255)
,TRA_codiceStato		varchar2(255)
,TRA_dataPubblicazioneSentenza	varchar2(255)
,TRA_dataDecorrenzaSentenza	varchar2(255)
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
