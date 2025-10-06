--liquibase formatted sql
--changeset amonopoli:202503241000_4 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_applicazioni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_applicazioni(
 applicazione                    VARCHAR (8)         NOT NULL,
 titolo                          VARCHAR (40)        NULL,
 titolo_al1                      VARCHAR (40)        NULL,
 titolo_al2                      VARCHAR (40)        NULL,
 voce_menu                       VARCHAR (8)         NULL,
 ambiente                        VARCHAR (8)         NULL,
 voce_menu_fine                  VARCHAR (8)         NULL
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
     w_nome_ogg := 'APPL_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX APPL_PK ON A_APPLICAZIONI
(
      applicazione )';

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
COMMENT ON TABLE a_applicazioni
    IS 'Created from Entity APPLICAZIONE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_applicazioni.applicazione
    IS 'Codice dell''applicazione'
/
COMMENT ON COLUMN a_applicazioni.titolo
    IS 'Descrizione dell''applicazione'
/
COMMENT ON COLUMN a_applicazioni.titolo_al1
    IS 'Descrizione dell''applicazione in lingua tedesca'
/
COMMENT ON COLUMN a_applicazioni.titolo_al2
    IS 'Descrizione dell''applicazione in lingua ladina'
/
COMMENT ON COLUMN a_applicazioni.voce_menu
    IS 'Modulo per l''inizializzazione dell''applicazione'
/
