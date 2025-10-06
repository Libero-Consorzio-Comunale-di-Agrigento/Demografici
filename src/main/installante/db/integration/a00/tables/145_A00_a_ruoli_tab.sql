--liquibase formatted sql
--changeset amonopoli:202503241000_45 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'a_ruoli';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_ruoli(
 ruolo                           VARCHAR (4)         NOT NULL,
 descrizione                     VARCHAR (40)        NULL,
 descrizione_al1                 VARCHAR (40)        NULL,
 descrizione_al2                 VARCHAR (40)        NULL
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'RUOL_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX RUOL_PK ON A_RUOLI
(
      ruolo )';

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

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
COMMENT ON TABLE a_ruoli
    IS 'Created from Entity RUOLO by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_ruoli.ruolo
    IS 'Codice del ruolo'
/
COMMENT ON COLUMN a_ruoli.descrizione
    IS 'Descrizione del ruolo in lingua italiana'
/
COMMENT ON COLUMN a_ruoli.descrizione_al1
    IS 'Descrizione del ruolo in lingua tedesca'
/
COMMENT ON COLUMN a_ruoli.descrizione_al2
    IS 'Descrizione del ruolo in lingua ladina'
/
