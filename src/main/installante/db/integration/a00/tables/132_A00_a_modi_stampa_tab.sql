--liquibase formatted sql
--changeset amonopoli:202503241000_32 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_modi_stampa';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_modi_stampa(
 modo_stampa                     NUMBER (2,0)     NOT NULL,
 descrizione                     VARCHAR (40)        NULL,
 descrizione_al1                 VARCHAR (40)        NULL,
 descrizione_al2                 VARCHAR (40)        NULL,
 modo_reset                      NUMBER (2,0)     NULL
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
     w_nome_ogg := 'MOST_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX MOST_PK ON A_MODI_STAMPA
(
      modo_stampa )';

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
COMMENT ON TABLE a_modi_stampa
    IS 'Created from Entity MODO DI STAMPA by A00 on 24-SEP-92'
/
COMMENT ON COLUMN a_modi_stampa.modo_stampa
    IS 'Codice del modo di stampa'
/
COMMENT ON COLUMN a_modi_stampa.descrizione
    IS 'Descrizione del modi di stampa'
/
COMMENT ON COLUMN a_modi_stampa.descrizione_al1
    IS 'Descrizione del modi di stampa'
/
COMMENT ON COLUMN a_modi_stampa.descrizione_al2
    IS 'Descrizione del modi di stampa'
/
