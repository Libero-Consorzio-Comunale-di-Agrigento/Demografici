--liquibase formatted sql
--changeset amonopoli:202503241000_39 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_passi_proc';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_passi_proc(
 voce_menu                       VARCHAR (8)         NOT NULL,
 passo                           NUMBER (2,0)     NOT NULL,
 titolo                          VARCHAR (40)        NULL,
 titolo_al1                      VARCHAR (40)        NULL,
 titolo_al2                      VARCHAR (40)        NULL,
 tipo                            VARCHAR (1)         NOT NULL,
 modulo                          VARCHAR (8)         NULL,
 stringa                         VARCHAR (40)        NULL,
 stampa                          VARCHAR (8)         NULL,
 gruppo_ling                     VARCHAR (1)         NULL
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
     w_nome_ogg := 'PASS_CATS_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX PASS_CATS_FK ON A_PASSI_PROC
(
      stampa )';

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
     w_nome_ogg := 'PASS_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX PASS_PK ON A_PASSI_PROC
(
      voce_menu ,
      passo )';

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
COMMENT ON TABLE a_passi_proc
    IS 'Created from Entity PASSO PROCEDURALE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_passi_proc.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_passi_proc.passo
    IS 'Progressivo del passo procedurale'
/
COMMENT ON COLUMN a_passi_proc.titolo
    IS 'Descrizione del passo procedurale'
/
COMMENT ON COLUMN a_passi_proc.titolo_al1
    IS 'Descrizione del passo procedurale'
/
COMMENT ON COLUMN a_passi_proc.titolo_al2
    IS 'Descrizione del passo procedurale'
/
COMMENT ON COLUMN a_passi_proc.tipo
    IS 'Tipo di interfaccia procedurale differita'
/
COMMENT ON COLUMN a_passi_proc.modulo
    IS 'Codice del modulo da elaborare nel passo'
/
COMMENT ON COLUMN a_passi_proc.stringa
    IS 'Stringa di parametri'
/
COMMENT ON COLUMN a_passi_proc.stampa
    IS 'Codice della stampa'
/

