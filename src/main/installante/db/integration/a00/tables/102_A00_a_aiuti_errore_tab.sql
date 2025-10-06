--liquibase formatted sql
--changeset amonopoli:202503241000_2 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_aiuti_errore';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_aiuti_errore(
 errore                          VARCHAR (6)         NOT NULL,
 gruppo_ling                     VARCHAR (1)         NOT NULL,
 no_riga                         NUMBER (3,0)     NOT NULL,
 testo                           VARCHAR (70)        NULL,
 cr                              VARCHAR (1)         NULL,
 lunghezza                       NUMBER (3,0)     NULL
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
     w_nome_ogg := 'HEER_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX HEER_PK ON A_AIUTI_ERRORE
(
      errore ,
      no_riga ,
      gruppo_ling )';

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
COMMENT ON TABLE a_aiuti_errore
    IS 'Created from Entity AIUTO SU ERRORE by A00 on 20-FEB-92'
/
COMMENT ON COLUMN a_aiuti_errore.errore
    IS 'Codice dell''errore'
/
COMMENT ON COLUMN a_aiuti_errore.gruppo_ling
    IS 'Codice del gruppo linguistico di lavoro'
/
COMMENT ON COLUMN a_aiuti_errore.no_riga
    IS 'Numero di riga di testo'
/
COMMENT ON COLUMN a_aiuti_errore.testo
    IS 'COLUMN DEFINITION DERIVED FROM ATTRIBUTE TESTO'
/
COMMENT ON COLUMN a_aiuti_errore.cr
    IS 'Presenza o assenza del carattere di ritorno a capo'
/
COMMENT ON COLUMN a_aiuti_errore.lunghezza
    IS 'Lunghezza dei caratteri utili della riga'
/
