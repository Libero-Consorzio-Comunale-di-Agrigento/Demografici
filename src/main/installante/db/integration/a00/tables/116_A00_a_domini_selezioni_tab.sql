--liquibase formatted sql
--changeset amonopoli:202503241000_16 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_domini_selezioni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_domini_selezioni(
 dominio                         VARCHAR (20)        NOT NULL,
 valore_low                      VARCHAR (80)        NULL,
 valore_high                     VARCHAR (80)        NULL,
 descrizione                     VARCHAR (40)        NULL,
 descrizione_al1                 VARCHAR (40)        NULL,
 descrizione_al2                 VARCHAR (40)        NULL
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
     w_nome_ogg := 'DOSE_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX DOSE_PK ON A_DOMINI_SELEZIONI
(
      dominio ,
      valore_low )';

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
COMMENT ON TABLE a_domini_selezioni
    IS 'Created from Entity DOMINIO SELEZIONE by A00 on 17-DEC-92'
/
COMMENT ON COLUMN a_domini_selezioni.dominio
    IS 'Codice del dominio di valori'
/
COMMENT ON COLUMN a_domini_selezioni.valore_low
    IS 'Valore minimo o possibile occorrenza del valore'
/
COMMENT ON COLUMN a_domini_selezioni.valore_high
    IS 'Valore massimo'
/
COMMENT ON COLUMN a_domini_selezioni.descrizione
    IS 'Descrizione del dominio'
/
COMMENT ON COLUMN a_domini_selezioni.descrizione_al1
    IS 'Descrizione del dominio'
/
COMMENT ON COLUMN a_domini_selezioni.descrizione_al2
    IS 'Descrizione del dominio'
/
