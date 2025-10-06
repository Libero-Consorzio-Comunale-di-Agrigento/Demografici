--liquibase formatted sql
--changeset amonopoli:202503241000_56 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_testi_help';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_testi_help(
 tipo_oggetto                    VARCHAR (1)         NOT NULL,
 modulo                          VARCHAR (8)         NOT NULL,
 blocco                          VARCHAR (30)        NOT NULL,
 oggetto                         VARCHAR (30)        NOT NULL,
 gruppo_ling                     VARCHAR (1)         NOT NULL,
 no_riga                         NUMBER (3,0)     NOT NULL,
 testo                           VARCHAR (70)        NULL,
 cr                              VARCHAR (1)         NULL,
 lunghezza                       NUMBER (3,0)     NULL,
 ambiente                        VARCHAR (8)         NOT NULL
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
     w_nome_ogg := 'TEHL_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX TEHL_PK ON A_TESTI_HELP
(
      ambiente ,
      tipo_oggetto ,
      modulo ,
      blocco ,
      oggetto ,
      gruppo_ling ,
      no_riga )';

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
COMMENT ON TABLE a_testi_help
    IS 'Created from Entity TESTO DI HELP by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_testi_help.tipo_oggetto
    IS 'Tipo di oggetto documentato'
/
COMMENT ON COLUMN a_testi_help.modulo
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_testi_help.blocco
    IS 'Nome del blocco in cui si trova il campo documentato'
/
COMMENT ON COLUMN a_testi_help.oggetto
    IS 'Nome dell''oggetto documentato se campo o voce di menu'''
/
COMMENT ON COLUMN a_testi_help.gruppo_ling
    IS 'Codice del gruppo linguistico di lavoro'
/
COMMENT ON COLUMN a_testi_help.testo
    IS 'Riga di documentazione'
/
COMMENT ON COLUMN a_testi_help.cr
    IS 'Presenza o assenza del carattere di ritorno a capo'
/
COMMENT ON COLUMN a_testi_help.lunghezza
    IS 'Lunghezza dei caratteri utili della riga'
/