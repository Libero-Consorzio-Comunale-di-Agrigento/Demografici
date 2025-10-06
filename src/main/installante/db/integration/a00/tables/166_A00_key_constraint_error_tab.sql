--liquibase formatted sql
--changeset amonopoli:202503241000_66 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
<< tab >>
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'KEY_CONSTRAINT_ERROR';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE KEY_CONSTRAINT_ERROR ( 
  NOME         VARCHAR2(30)  NOT NULL, 
  TIPO_ERRORE  VARCHAR2(2)   NOT NULL, 
  ERRORE       VARCHAR2(6)   NOT NULL
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

CREATE UNIQUE INDEX KCER_PK ON 
  KEY_CONSTRAINT_ERROR(NOME, TIPO_ERRORE) 
/ 

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
