--liquibase formatted sql
--changeset amonopoli:202503241000_14 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_consolati';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_consolati(
 consolato                       NUMBER (5,0)     NOT NULL,
 tipo_consolato                  NUMBER (2,0)     NOT NULL,
 stato                           NUMBER (3,0)     NOT NULL,
 indirizzo_1                     VARCHAR (50)        NULL,
 indirizzo_2                     VARCHAR (50)        NULL,
 indirizzo_3                     VARCHAR (50)        NULL,
 sede                            VARCHAR (40)        NULL
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
     w_nome_ogg := 'CONS_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX CONS_PK ON A_CONSOLATI
(
      consolato ,
      tipo_consolato,
      stato  )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'CONS_STES_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX CONS_STES_FK ON A_CONSOLATI
(
      stato )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'CONS_TCON_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX CONS_TCON_FK ON A_CONSOLATI
(
      tipo_consolato )';

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
COMMENT ON TABLE a_consolati
    IS 'Created from Entity CONSOLATO by A00 on 13-MAY-93'
/
COMMENT ON COLUMN a_consolati.consolato
    IS 'Codice del consolato'
/
COMMENT ON COLUMN a_consolati.tipo_consolato
    IS 'Codice del tipo consolato'
/
COMMENT ON COLUMN a_consolati.stato
    IS 'Codice dello stato/territorio estero'
/
COMMENT ON COLUMN a_consolati.indirizzo_1
    IS 'Primi 50 caratteri dell''indirizzo'
/
COMMENT ON COLUMN a_consolati.indirizzo_2
    IS 'Secondi 50 caratteri dell''indirizzo'
/
COMMENT ON COLUMN a_consolati.indirizzo_3
    IS 'Terzi 50 caratteri dell''indirizzo'
/
COMMENT ON COLUMN a_consolati.sede
    IS 'Denominazione della citta'' dove risiede l''ambasciata/il consolato'
/
