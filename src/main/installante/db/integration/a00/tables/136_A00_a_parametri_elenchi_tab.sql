--liquibase formatted sql
--changeset amonopoli:202503241000_36 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_parametri_elenchi';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_parametri_elenchi(
 id                              NUMBER (7,0)     NOT NULL,
 progressivo                     NUMBER (5,0)     NOT NULL,
 parametro                       VARCHAR (30)        NULL,
 valore                          VARCHAR (240)       NULL,
 operatore                       VARCHAR (11)        NULL,
 tipo_valore                     VARCHAR (1)         NULL,
 operatore_logico                VARCHAR (3)         NULL,
 gruppo                          NUMBER (2,0)     NULL
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
     w_nome_ogg := 'PAUT_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX PAUT_PK ON A_PARAMETRI_ELENCHI
(
      id ,
      progressivo )';

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
COMMENT ON TABLE a_parametri_elenchi
    IS 'Created from Entity PARAMETRO DEFINITO DA UTENTE by A00 on 21-OCT-93'
/
COMMENT ON COLUMN a_parametri_elenchi.id
    IS 'Numero identificativo della condizione parametrica'
/
COMMENT ON COLUMN a_parametri_elenchi.progressivo
    IS 'Numero di sequenza del parametro'
/
COMMENT ON COLUMN a_parametri_elenchi.parametro
    IS 'Nome del parametro'
/
COMMENT ON COLUMN a_parametri_elenchi.valore
    IS 'Valore fornito al parametro'
/
COMMENT ON COLUMN a_parametri_elenchi.operatore
    IS 'Operatore di confronto in una condizione'
/
COMMENT ON COLUMN a_parametri_elenchi.tipo_valore
    IS 'Significato del valore'
/
COMMENT ON COLUMN a_parametri_elenchi.operatore_logico
    IS 'Operatore logico fra due condizioni'
/
COMMENT ON COLUMN a_parametri_elenchi.gruppo
    IS 'COLUMN DEFINITION DERIVED FROM ATTRIBUTE GRUPPO'
/
