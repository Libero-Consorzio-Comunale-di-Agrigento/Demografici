--liquibase formatted sql
--changeset amonopoli:202305291155_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANPANA';
w_nome_col      varchar2(255) := 'ATTNAS_IDANSC';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table anpana
add
(ATTNAS_idANSC				varchar2(255)
,ATTNAS_numeroComunale			varchar2(255)
,ATTMAT_idANSC				varchar2(255)
,ATTMAT_numeroComunale			varchar2(255)
,ATTDIV_idANSC				varchar2(255)
,ATTDIV_numeroComunale			varchar2(255)
,ATTUCI_idANSC				varchar2(255)
,ATTUCI_numeroComunale			varchar2(255)
,ATTSCI_idANSC				varchar2(255)
,ATTSCI_numeroComunale			varchar2(255)
,ATTVED_idANSC				varchar2(255)
,ATTVED_numeroComunale			varchar2(255)
,ATTMOR_idANSC				varchar2(255)
,ATTMOR_numeroComunale			varchar2(255)
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
