--liquibase formatted sql
--changeset amonopoli:202412060935_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'prc';
w_nome_ogg	varchar2(255) := 'ANADOC_NR';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
     w_sql := 'drop procedure ANADOC_NR';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' droppato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non droppato ('||SQLERRM||')');
     end;

  end if;
end;
/
