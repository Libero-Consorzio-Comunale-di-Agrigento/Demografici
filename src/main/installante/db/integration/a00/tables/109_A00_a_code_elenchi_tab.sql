--liquibase formatted sql
--changeset amonopoli:202503241000_9 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_code_elenchi';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_code_elenchi(
 elen_elenco                     VARCHAR (5)         NOT NULL,
 progressivo                     NUMBER (2,0)     NOT NULL,
 posizione                       VARCHAR (1)         NULL,
 testo                           VARCHAR (240)       NULL,
 righe_skip                      NUMBER (1,0)     NOT NULL
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
     w_nome_ogg := 'COEL_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COEL_PK ON A_CODE_ELENCHI
(
      elen_elenco ,
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
COMMENT ON TABLE a_code_elenchi
    IS 'Created from Entity CODA ELENCO by A00 on 05-AUG-93'
/
COMMENT ON COLUMN a_code_elenchi.elen_elenco
    IS 'Codice elenco'
/
COMMENT ON COLUMN a_code_elenchi.progressivo
    IS 'Progressivo della riga'
/
COMMENT ON COLUMN a_code_elenchi.posizione
    IS 'Posizione del testo nella riga'
/
COMMENT ON COLUMN a_code_elenchi.testo
    IS 'Testo'
/
COMMENT ON COLUMN a_code_elenchi.righe_skip
    IS 'Numero righe da saltare prima della stampa della riga'
/