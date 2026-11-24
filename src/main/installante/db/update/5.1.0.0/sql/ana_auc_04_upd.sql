--liquibase formatted sql
--changeset amonopoli:202511111450_2 runOnChange:true stripComments:false
alter table anaauc disable all triggers
/
update anaauc
   set cognome_mor        = f_cognome(cognome_nome_mor),
       nome_mor           = f_nome(cognome_nome_mor),
       d_data_nas_mor     = to_date(data_nas_mor,'j'),
       d_data_mor         = to_date(data_mor,'j'),
       d_data_cremazione  = to_date(data_cremazione,'j'),
       d_data_affidamento = to_date(data_affidamento,'j'),
       id                 = anaauc_sq.nextval,
       version            = 0
 where id is null
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'ANAAUC_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index anaauc_pk on anaauc (id)';

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

