--liquibase formatted sql
--changeset amonopoli:202503241000_26 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_guide_v';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_guide_v(
 guida_v                         VARCHAR (8)         NOT NULL,
 sequenza                        NUMBER (2,0)     NOT NULL,
 alias                           VARCHAR (6)         NULL,
 lettera                         VARCHAR (1)         NULL,
 lettera_al1                     VARCHAR (1)         NULL,
 lettera_al2                     VARCHAR (1)         NULL,
 titolo                          VARCHAR (20)        NULL,
 titolo_al1                      VARCHAR (20)        NULL,
 titolo_al2                      VARCHAR (20)        NULL,
 voce_menu                       VARCHAR (8)         NOT NULL,
 voce_rif                        VARCHAR (8)         NULL,
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
     w_nome_ogg := 'GUVE_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX GUVE_PK ON A_GUIDE_V
(
      guida_v ,
      sequenza )';

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
     w_nome_ogg := 'GUVE_PROC_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX GUVE_PROC_FK ON A_GUIDE_V
(
      voce_rif )';

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
     w_nome_ogg := 'GUVE_PROC_FK1';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX GUVE_PROC_FK1 ON A_GUIDE_V
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
COMMENT ON TABLE a_guide_v
    IS 'Created from Entity GUIDA VERTICALE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_guide_v.guida_v
    IS 'Identificativo della guida verticale'
/
COMMENT ON COLUMN a_guide_v.sequenza
    IS 'Progressivo di presentazione'
/
COMMENT ON COLUMN a_guide_v.lettera
    IS 'Lettera identificativa della scelta'
/
COMMENT ON COLUMN a_guide_v.lettera_al1
    IS 'Lettera identificativa della scelta in lingua tedesca'
/
COMMENT ON COLUMN a_guide_v.lettera_al2
    IS 'Lettera identificativa della scelta in lingua ladina'
/
COMMENT ON COLUMN a_guide_v.titolo
    IS 'Titolo della scelta'
/
COMMENT ON COLUMN a_guide_v.titolo_al1
    IS 'Titolo della scelta in lingua tedesca'
/
COMMENT ON COLUMN a_guide_v.titolo_al2
    IS 'Titolo della scelta in lingua ladina'
/
COMMENT ON COLUMN a_guide_v.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_guide_v.voce_rif
    IS 'Codice della voce di menu'''
/
