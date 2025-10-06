--liquibase formatted sql
--changeset amonopoli:202503241000_47 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_selezioni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_selezioni(
 parametro                       VARCHAR (20)        NOT NULL,
 voce_menu                       VARCHAR (8)         NOT NULL,
 sequenza                        NUMBER (2,0)     NOT NULL,
 descrizione                     VARCHAR (30)        NULL,
 descrizione_al1                 VARCHAR (30)        NULL,
 descrizione_al2                 VARCHAR (30)        NULL,
 lunghezza                       NUMBER (3,0)     NOT NULL,
 formato                         VARCHAR (1)         NOT NULL,
 obbligo                         VARCHAR (1)         NOT NULL,
 valore_default                  VARCHAR (80)        NULL,
 dominio                         VARCHAR (20)        NULL,
 alias                           VARCHAR (8)         NULL,
 gruppo_alias                    NUMBER (2,0)     NULL,
 numero_fk                       NUMBER (1,0)     NULL
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
     w_nome_ogg := 'SELE_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX SELE_PK ON A_SELEZIONI
(
      voce_menu ,
      parametro )';

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
COMMENT ON TABLE a_selezioni
    IS 'Created from Entity SELEZIONE by A00 on 25-FEB-92'
/
COMMENT ON COLUMN a_selezioni.parametro
    IS 'Codice del parametro'
/
COMMENT ON COLUMN a_selezioni.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_selezioni.descrizione
    IS 'Descrizione del parametro'
/
COMMENT ON COLUMN a_selezioni.descrizione_al1
    IS 'Descrizione del parametro'
/
COMMENT ON COLUMN a_selezioni.descrizione_al2
    IS 'Descrizione del parametro'
/
