--liquibase formatted sql
--changeset amonopoli:202503241000_10 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_colonne_elenco';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_colonne_elenco(
 elen_elenco                     VARCHAR (5)         NOT NULL,
 progressivo                     NUMBER (2,0)     NOT NULL,
 vele_vista                      VARCHAR (30)        NOT NULL,
 cvel_campo                      VARCHAR (30)        NOT NULL,
 intestazione                    VARCHAR (50)        NOT NULL,
 len                             NUMBER (3,0)     NOT NULL,
 posizione                       VARCHAR (1)         NULL,
 valore_nullo                    VARCHAR (50)        NULL,
 break                           VARCHAR (1)         NULL,
 subtotale                       VARCHAR (1)         NULL,
 ordine                          VARCHAR (1)         NULL,
 calcolo                         VARCHAR (8)         NULL,
 len_decimali                    NUMBER(2)           NULL,
 formato_importo                 VARCHAR (1)         NULL
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
     w_nome_ogg := 'CELE_CVEL_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX CELE_CVEL_FK ON A_COLONNE_ELENCO
(
      vele_vista ,
      cvel_campo )';

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
     w_nome_ogg := 'CELE_ELEN_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX CELE_ELEN_FK ON A_COLONNE_ELENCO
(
      elen_elenco )';

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
     w_nome_ogg := 'CELE_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX CELE_PK ON A_COLONNE_ELENCO
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
COMMENT ON TABLE a_colonne_elenco
    IS 'Created from Entity COLONNA ELENCO by A00 on 05-AUG-93'
/
COMMENT ON COLUMN a_colonne_elenco.elen_elenco
    IS 'Codice elenco'
/
COMMENT ON COLUMN a_colonne_elenco.progressivo
    IS 'Progressivo della colonna'
/
COMMENT ON COLUMN a_colonne_elenco.vele_vista
    IS 'Nome della vista nel database'
/
COMMENT ON COLUMN a_colonne_elenco.cvel_campo
    IS 'Nome del campo della vista sul database'
/
COMMENT ON COLUMN a_colonne_elenco.intestazione
    IS 'Intestazione della colonna'
/
COMMENT ON COLUMN a_colonne_elenco.len
    IS 'Lunghezza in caratteri del campo'
/
COMMENT ON COLUMN a_colonne_elenco.posizione
    IS 'Posizione del testo nella colonna'
/
COMMENT ON COLUMN a_colonne_elenco.valore_nullo
    IS 'Stringa da stampare in corrispondenza di un valore nullo'
/
COMMENT ON COLUMN a_colonne_elenco.break
    IS 'Rottura con indicazione salto pagina o numero righe da saltare'
/
COMMENT ON COLUMN a_colonne_elenco.ordine
    IS 'Indicatore di colonna su cui ordinare e del tipo di ordinamento'
/