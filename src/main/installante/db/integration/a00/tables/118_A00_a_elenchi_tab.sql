--liquibase formatted sql
--changeset amonopoli:202503241000_18 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_elenchi';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_elenchi(
 elenco                          VARCHAR (5)         NOT NULL,
 prov_voce_menu                  VARCHAR (8)         NOT NULL,
 descrizione                     VARCHAR (30)        NULL,
 descrizione_al1                 VARCHAR (30)        NULL,
 descrizione_al2                 VARCHAR (30)        NULL,
 righe                           NUMBER (3,0)     NOT NULL,
 len_riga                        NUMBER (3,0)     NOT NULL,
 vele_vista                      VARCHAR (30)        NOT NULL,
 note                            VARCHAR (254)       NULL,
 text_sql                        LONG             NULL,
 text_order                      VARCHAR (254)       NULL,
 text_group                      VARCHAR (254)       NULL,
 tipo				 VARCHAR (1)	  NOT NULL,
 utente				 VARCHAR (8),
 tipo_proprieta			 VARCHAR (1),
 tipo_visura			 VARCHAR (1),
 formato_file			 VARCHAR (1)
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
     w_nome_ogg := 'ELEN_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX ELEN_PK ON A_ELENCHI
(
      elenco )';

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
     w_nome_ogg := 'ELEN_PROC_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX ELEN_PROC_FK ON A_ELENCHI
(
      prov_voce_menu )';

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
     w_nome_ogg := 'ELEN_VELE_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX ELEN_VELE_FK ON A_ELENCHI
(
      vele_vista )';

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
COMMENT ON TABLE a_elenchi
    IS 'Created from Entity ELENCO by A00 on 05-AUG-93'
/
COMMENT ON COLUMN a_elenchi.elenco
    IS 'Codice elenco'
/
COMMENT ON COLUMN a_elenchi.righe
    IS 'Numero di righe per pagina'
/
COMMENT ON COLUMN a_elenchi.len_riga
    IS 'Ampiezza in caratteri delle righe dell''elenco'
/
COMMENT ON COLUMN a_elenchi.vele_vista
    IS 'Nome della vista nel database'
/
COMMENT ON COLUMN a_elenchi.note
    IS 'Note descrittive dell''elenco'
/
COMMENT ON COLUMN a_elenchi.text_sql
    IS 'Parte del testo SQLPlus relativo all''elenco'
/
COMMENT ON COLUMN a_elenchi.text_order
    IS 'Order by della select di estrazione'
/
