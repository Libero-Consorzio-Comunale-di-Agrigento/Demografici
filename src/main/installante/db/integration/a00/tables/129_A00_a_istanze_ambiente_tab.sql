--liquibase formatted sql
--changeset amonopoli:202503241000_29 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_istanze_ambiente';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_istanze_ambiente(
 ambiente                        VARCHAR (8)         NOT NULL,
 ente                            VARCHAR (4)         NOT NULL,
 gruppo_ling                     VARCHAR (1)         NOT NULL,
 descrizione                     VARCHAR (40)        NULL,
 user_oracle                     VARCHAR (20)        NOT NULL,
 password                        VARCHAR (20)        NULL,
 link_oracle                     VARCHAR (20)        NULL,
 dislocazione                    VARCHAR (80)        NOT NULL,
 stampante                       VARCHAR (100)       NULL,
 versione                        VARCHAR (10)        NULL,
 dislocazione_client             VARCHAR (80)        NULL,
 ALIAS_STA                       VARCHAR2(20)
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
     w_nome_ogg := 'ISAM_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX ISAM_PK ON A_ISTANZE_AMBIENTE
(
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
COMMENT ON TABLE a_istanze_ambiente
    IS 'Created from Entity ISTANZA DI AMBIENTE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_istanze_ambiente.ambiente
    IS 'Codice dell''ambiente applicativo'
/
COMMENT ON COLUMN a_istanze_ambiente.ente
    IS 'Identificativo del proprietario dell''istanza'
/
COMMENT ON COLUMN a_istanze_ambiente.gruppo_ling
    IS 'Codice del gruppo linguistico di lavoro'
/
COMMENT ON COLUMN a_istanze_ambiente.descrizione
    IS 'Descrizione dell''istanza in lingua italiana'
/
COMMENT ON COLUMN a_istanze_ambiente.user_oracle
    IS 'User di Oracle'
/
COMMENT ON COLUMN a_istanze_ambiente.password
    IS 'Password di Oracle'
/
COMMENT ON COLUMN a_istanze_ambiente.link_oracle
    IS 'Link con altri database'
/
COMMENT ON COLUMN a_istanze_ambiente.dislocazione
    IS 'Directory di lavoro'
/
COMMENT ON COLUMN a_istanze_ambiente.stampante
    IS 'Codice della stampante'
/
