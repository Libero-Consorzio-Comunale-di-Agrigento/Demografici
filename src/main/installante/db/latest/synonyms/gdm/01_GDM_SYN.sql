--liquibase formatted sql
--changeset snocca:202305031800 runOnChange:true
create or replace synonym GDM_DOCUMENTI for ${global.db.gdm.username}.DOCUMENTI
/
create or replace synonym GDM_OGGETTI_FILE for ${global.db.gdm.username}.OGGETTI_FILE
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := '';
w_nome_ogg	varchar2(255) := 'F_ELIMINA_DOCUMENTO';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
--
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create or replace synonym F_ELIMINA_DOCUMENTO for ${global.db.gdm.username}.F_ELIMINA_DOCUMENTO';

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
