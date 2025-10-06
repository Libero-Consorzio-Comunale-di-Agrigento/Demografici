--liquibase formatted sql
--changeset amonopoli:202503241000_8 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_classi_stampa';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_classi_stampa(
 classe                          VARCHAR (4)         NOT NULL,
 descrizione                     VARCHAR (20)        NULL,
 descrizione_al1                 VARCHAR (20)        NULL,
 descrizione_al2                 VARCHAR (20)        NULL,
 driver                          VARCHAR (10)        NULL,
 righe                           NUMBER (3,0)     NULL,
 normcomp                        VARCHAR (1)         NOT NULL
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
     w_nome_ogg := 'CLAS_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX CLAS_PK ON A_CLASSI_STAMPA
(
      classe )';

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
COMMENT ON TABLE a_classi_stampa
    IS 'Created from Entity CLASSE DI STAMPA by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_classi_stampa.classe
    IS 'Classe di stampa'
/
COMMENT ON COLUMN a_classi_stampa.descrizione
    IS 'Descrizione della classe di stampa in lingua italiana'
/
COMMENT ON COLUMN a_classi_stampa.descrizione_al1
    IS 'Descrizione della classe di stampa in lingua tedesca'
/
COMMENT ON COLUMN a_classi_stampa.descrizione_al2
    IS 'Descrizione della classe di stampa in lingua ladina'
/