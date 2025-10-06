--liquibase formatted sql
--changeset amonopoli:202503241000_25 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_guide_o';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_guide_o(
 guida_o                         VARCHAR (8)         NOT NULL,
 sequenza                        NUMBER (2,0)     NOT NULL,
 alias                           VARCHAR (6)         NOT NULL,
 lettera                         VARCHAR (1)         NULL,
 lettera_al1                     VARCHAR (1)         NULL,
 lettera_al2                     VARCHAR (1)         NULL,
 titolo                          VARCHAR (9)         NULL,
 titolo_al1                      VARCHAR (9)         NULL,
 titolo_al2                      VARCHAR (9)         NULL,
 guida_v                         VARCHAR (8)         NULL,
 voce_menu                       VARCHAR (8)         NULL,
 voce_rif                        VARCHAR (8)         NULL,
 proprieta                       VARCHAR (1)         NULL,
 TITOLO_ESTESO                   VARCHAR2(20)        NULL,
 TITOLO_ESTESO_AL1               VARCHAR2(20)        NULL,
 TITOLO_ESTESO_AL2               VARCHAR2(20)        NULL
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
     w_nome_ogg := 'GUOR_GUVE_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX GUOR_GUVE_FK ON A_GUIDE_O
(
      guida_v )';

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
     w_nome_ogg := 'GUOR_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX GUOR_PK ON A_GUIDE_O
(
      guida_o ,
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
     w_nome_ogg := 'GUOR_PROC_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX GUOR_PROC_FK ON A_GUIDE_O
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
     w_nome_ogg := 'GUOR_PROC_FK1';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX GUOR_PROC_FK1 ON A_GUIDE_O
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
COMMENT ON TABLE a_guide_o
    IS 'Created from Entity GUIDA ORIZZONTALE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_guide_o.guida_o
    IS 'Identificativo della guida orizzontale'
/
COMMENT ON COLUMN a_guide_o.sequenza
    IS 'Progressivo di presentazione'
/
COMMENT ON COLUMN a_guide_o.alias
    IS 'Identificativo del contesto relativo alla chiamata'
/
COMMENT ON COLUMN a_guide_o.lettera
    IS 'Lettera identificativa della scelta'
/
COMMENT ON COLUMN a_guide_o.lettera_al1
    IS 'Lettera identificativa della scelta in lingua tedesca'
/
COMMENT ON COLUMN a_guide_o.lettera_al2
    IS 'Lettera identificativa della scelta in lingua ladina'
/
COMMENT ON COLUMN a_guide_o.titolo
    IS 'Titolo della scelta in lingua italiana'
/
COMMENT ON COLUMN a_guide_o.titolo_al1
    IS 'Titolo della scelta in lingua tedesca'
/
COMMENT ON COLUMN a_guide_o.titolo_al2
    IS 'Titolo della scelta in lingua ladina'
/
COMMENT ON COLUMN a_guide_o.guida_v
    IS 'Identificativo della guida verticale'
/
COMMENT ON COLUMN a_guide_o.voce_menu
    IS 'Codice della voce di menu'''
/
COMMENT ON COLUMN a_guide_o.voce_rif
    IS 'Codice della voce di menu'''
/
