--liquibase formatted sql
--changeset amonopoli:202503241000_53 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_stati_territori';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_stati_territori(
 stato_territorio                NUMBER (3,0)     NOT NULL,
 denominazione                   VARCHAR (40)        NULL,
 denominazione_al1               VARCHAR (40)        NULL,
 denominazione_al2               VARCHAR (40)        NULL,
 sigla                           VARCHAR (5)         NULL,
 desc_cittadinanza               VARCHAR (40)        NULL,
 desc_cittadinanza_al1           VARCHAR (40)        NULL,
 desc_cittadinanza_al2           VARCHAR (40)        NULL,
 raggruppamento                  NUMBER (2,0)     NULL,
 stato_appartenenza              NUMBER (3,0)     NULL
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
     w_nome_ogg := 'STES_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX STES_PK ON A_STATI_TERRITORI
(
      stato_territorio )';

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
     w_nome_ogg := 'STES_RSTA_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX STES_RSTA_FK ON A_STATI_TERRITORI
(
      raggruppamento )';

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
     w_nome_ogg := 'STES_STES_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX STES_STES_FK ON A_STATI_TERRITORI
(
      stato_appartenenza )';

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
COMMENT ON TABLE a_stati_territori
    IS 'Created from Entity STATO ESTERO by A00 on 13-MAY-93'
/
COMMENT ON COLUMN a_stati_territori.stato_territorio
    IS 'Codice dello stato/territorio estero'
/
COMMENT ON COLUMN a_stati_territori.denominazione
    IS 'Denominazione dello stato/territorio estero'
/
COMMENT ON COLUMN a_stati_territori.denominazione_al1
    IS 'Denominazione dello stato/territorio estero'
/
COMMENT ON COLUMN a_stati_territori.denominazione_al2
    IS 'Denominazione dello stato/territorio estero'
/
COMMENT ON COLUMN a_stati_territori.sigla
    IS 'Sigla automobilistica'
/
COMMENT ON COLUMN a_stati_territori.desc_cittadinanza
    IS 'Descrizione della cittadinanza'
/
COMMENT ON COLUMN a_stati_territori.desc_cittadinanza_al1
    IS 'Descrizione della cittadinanza'
/
COMMENT ON COLUMN a_stati_territori.desc_cittadinanza_al2
    IS 'Descrizione della cittadinanza'
/
COMMENT ON COLUMN a_stati_territori.raggruppamento
    IS 'Codice del raggruppamento'
/
COMMENT ON COLUMN a_stati_territori.stato_appartenenza
    IS 'Codice dello stato/territorio estero'
/
