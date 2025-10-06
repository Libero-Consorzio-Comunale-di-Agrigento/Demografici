--liquibase formatted sql
--changeset amonopoli:202503241000_22 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_funzioni_chiamate';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_funzioni_chiamate(
 voce_chiamante                  VARCHAR (8)         NOT NULL,
 tasto_funz                      NUMBER (2,0)     NOT NULL,
 voce_menu                       VARCHAR (8)         NULL,
 voce_rif                        VARCHAR (8)         NULL
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
     w_nome_ogg := 'FUCH_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX FUCH_PK ON A_FUNZIONI_CHIAMATE
(
      tasto_funz ,
      voce_chiamante )';

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
COMMENT ON TABLE a_funzioni_chiamate
    IS 'Created from Entity FUNZIONE CHIAMATA by A00 on 22-DEC-92'
/
COMMENT ON COLUMN a_funzioni_chiamate.voce_chiamante
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_funzioni_chiamate.tasto_funz
    IS 'Numero identificativo del tasto di chiamata'
/
COMMENT ON COLUMN a_funzioni_chiamate.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_funzioni_chiamate.voce_rif
    IS 'Codice della voce di menu'''
/

