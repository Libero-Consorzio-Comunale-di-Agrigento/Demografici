--liquibase formatted sql
--changeset amonopoli:202503241000_58 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_utenti';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_utenti(
 utente                          VARCHAR (8)         NOT NULL,
 nominativo                      VARCHAR (40)        NOT NULL,
 password                        VARCHAR (20)        NULL,
 gruppo_ling                     VARCHAR (1)         NOT NULL,
 gruppo                          VARCHAR (5)         NOT NULL,
 data_password                   DATE             NOT NULL,
 giorni_password                 NUMBER (4,0)     NULL,
 abil_password                   VARCHAR (1)         NULL,
 importanza                      NUMBER (2,0)     NULL,
 data_accesso                    DATE             NULL,
 tentativi                       NUMBER (2,0)     NULL,
 terminale                       VARCHAR (20)        NULL,
 accessi                         NUMBER (5,0)     NULL,
 stat_accessi                    VARCHAR (1)         NULL,
 stampante                       VARCHAR (100)        NULL,
 tentativi_max                   NUMBER (2,0)     NULL,
 accesso                         VARCHAR2(1)      
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
     w_nome_ogg := 'UTEN_GLAV_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX UTEN_GLAV_FK ON A_UTENTI
(
      gruppo )';

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

     w_tipo_ogg := 'idx';
     w_nome_ogg := 'UTEN_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX UTEN_PK ON A_UTENTI
(
      utente )';

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

     w_tipo_ogg := 'idx';
     w_nome_ogg := 'UTEN_UK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX UTEN_UK ON A_UTENTI
(
      nominativo )';

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
COMMENT ON TABLE a_utenti
    IS 'Created from Entity UTENTE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_utenti.utente
    IS 'Codice dell''utente'
/
COMMENT ON COLUMN a_utenti.nominativo
    IS 'Nominativo dell''utente (cogmone e nome)'
/
COMMENT ON COLUMN a_utenti.password
    IS 'Password dell''utente'
/
COMMENT ON COLUMN a_utenti.gruppo_ling
    IS 'Gruppo linguistico di appartenenza'
/
COMMENT ON COLUMN a_utenti.gruppo
    IS 'Codice del gruppo di lavoro'
/
COMMENT ON COLUMN a_utenti.data_password
    IS 'Data di registrazione della password'
/
COMMENT ON COLUMN a_utenti.giorni_password
    IS 'Giorni di validita'' della password'
/
COMMENT ON COLUMN a_utenti.importanza
    IS 'Importanza dell''utente per il calcolo della priorita'''
/
COMMENT ON COLUMN a_utenti.data_accesso
    IS 'Data dell''ultimo accesso'
/
COMMENT ON COLUMN a_utenti.tentativi
    IS 'Numero di insuccessi consecutivi'
/
COMMENT ON COLUMN a_utenti.terminale
    IS 'Terminale da cui e'' stato effettuato l''ultimo accesso'
/
COMMENT ON COLUMN a_utenti.accessi
    IS 'Numeo di eccessi effettuati'
/
COMMENT ON COLUMN a_utenti.stat_accessi
    IS 'Indicatore di registrazione di tutti gli accessi alle procedure'
/
