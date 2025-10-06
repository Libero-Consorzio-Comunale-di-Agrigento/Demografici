--liquibase formatted sql
--changeset amonopoli:202503241000_50 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_stampanti';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_stampanti(
 stampante                       VARCHAR (100)        NOT NULL,
 descrizione                     VARCHAR (20)        NULL,
 terminale                       VARCHAR (20)        NULL,
 ubicazione                      VARCHAR (30)        NULL,
 ubicazione_al1                  VARCHAR (30)        NULL,
 ubicazione_al2                  VARCHAR (30)        NULL,
 tipo_utilizzo                   VARCHAR (1)         NOT NULL,
 emulazione                      VARCHAR (10)        NOT NULL,
 righe_def                       NUMBER (3)       NOT NULL,
 salto_pagina_finale             VARCHAR (1)         NULL
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
     w_nome_ogg := 'PRIN_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX PRIN_PK ON A_STAMPANTI
(
      stampante )';

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
COMMENT ON TABLE a_stampanti
    IS 'Created from Entity STAMPANTE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_stampanti.stampante
    IS 'Codice della stampante'
/
COMMENT ON COLUMN a_stampanti.descrizione
    IS 'Descrizione della stampante'
/
COMMENT ON COLUMN a_stampanti.terminale
    IS 'Terminale di appartenenza'
/
COMMENT ON COLUMN a_stampanti.ubicazione
    IS 'Ubicazione della stampante'
/
