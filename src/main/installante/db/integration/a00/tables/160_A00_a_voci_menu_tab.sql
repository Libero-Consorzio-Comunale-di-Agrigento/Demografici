--liquibase formatted sql
--changeset amonopoli:202503241000_60 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_voci_menu';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_voci_menu(
 voce_menu                       VARCHAR (8)         NOT NULL,
 ambiente                        VARCHAR (8)         NULL,
 acronimo                        VARCHAR (5)         NULL,
 acronimo_al1                    VARCHAR (5)         NULL,
 acronimo_al2                    VARCHAR (5)         NULL,
 titolo                          VARCHAR (40)        NULL,
 titolo_al1                      VARCHAR (40)        NULL,
 titolo_al2                      VARCHAR (40)        NULL,
 tipo_voce                       VARCHAR (1)         NOT NULL,
 tipo                            VARCHAR (1)         NOT NULL,
 modulo                          VARCHAR (8)         NULL,
 stringa                         VARCHAR (200)        NULL,
 importanza                      NUMBER (2,0)     NULL,
 guida_o                         VARCHAR (8)         NULL,
 proprieta                       VARCHAR (1)         NULL
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
     w_nome_ogg := 'PROC_AMBI_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX PROC_AMBI_FK ON A_VOCI_MENU
(
      ambiente )';

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
     w_nome_ogg := 'PROC_GUOR_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX PROC_GUOR_FK ON A_VOCI_MENU
(
      guida_o )';

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
     w_nome_ogg := 'PROC_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX PROC_PK ON A_VOCI_MENU
(
      voce_menu )';

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
COMMENT ON TABLE a_voci_menu
    IS 'Created from Entity VOCE MENU by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_voci_menu.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_voci_menu.ambiente
    IS 'Codice dell''ambiente applicativo'
/
COMMENT ON COLUMN a_voci_menu.acronimo
    IS 'Codice dell''acronimo identificativo'
/
COMMENT ON COLUMN a_voci_menu.acronimo_al1
    IS 'Codice dell''acronimo identificativo in lingua tedesca'
/
COMMENT ON COLUMN a_voci_menu.acronimo_al2
    IS 'Codice dell''acronomo identificativo in lingua ladina'
/
COMMENT ON COLUMN a_voci_menu.titolo
    IS 'Descrizione della procedura'
/
COMMENT ON COLUMN a_voci_menu.titolo_al1
    IS 'Descrizione della procedura in lingua tedesca'
/
COMMENT ON COLUMN a_voci_menu.titolo_al2
    IS 'Descrizione della procedura in lingua ladina'
/
COMMENT ON COLUMN a_voci_menu.tipo_voce
    IS 'Tipo della voce di menu'''
/
COMMENT ON COLUMN a_voci_menu.tipo
    IS 'Tipo di interfaccia procedurale'
/
COMMENT ON COLUMN a_voci_menu.modulo
    IS 'Codice del modulo di elaborazione associato'
/
COMMENT ON COLUMN a_voci_menu.stringa
    IS 'Stringa di parametri'
/
COMMENT ON COLUMN a_voci_menu.importanza
    IS 'Importanza della procedura per il calcolo della priorita'''
/
COMMENT ON COLUMN a_voci_menu.guida_o
    IS 'Identificativo della guida orizzontale'
/
