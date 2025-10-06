--liquibase formatted sql
--changeset amonopoli:202503241000_15 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_diritti_accesso';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_diritti_accesso(
 utente                          VARCHAR (8)         NOT NULL,
 ambiente                        VARCHAR (8)         NOT NULL,
 ente                            VARCHAR (4)         NOT NULL,
 gruppo_ling                     VARCHAR (1)         NOT NULL,
 applicazione                    VARCHAR (8)         NOT NULL,
 ruolo                           VARCHAR (4)         NOT NULL,
 sequenza                        NUMBER (2,0)     NULL
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
     w_nome_ogg := 'DIRI_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX DIRI_PK ON A_DIRITTI_ACCESSO
(
      utente ,
      ambiente ,
      ente ,
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
COMMENT ON TABLE a_diritti_accesso
    IS 'Created from Entity DIRITTO DI ACCESSO by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_diritti_accesso.utente
    IS 'Codice dell''utente'
/
COMMENT ON COLUMN a_diritti_accesso.ente
    IS 'Identificativo del proprietario dell''istanza'
/
COMMENT ON COLUMN a_diritti_accesso.gruppo_ling
    IS 'Codice del gruppo linguistico di lavoro'
/
COMMENT ON COLUMN a_diritti_accesso.applicazione
    IS 'Codice dell''applicazione'
/
COMMENT ON COLUMN a_diritti_accesso.ruolo
    IS 'Codice del ruolo'
/
