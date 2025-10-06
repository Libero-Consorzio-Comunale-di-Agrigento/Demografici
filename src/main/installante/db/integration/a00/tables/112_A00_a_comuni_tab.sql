--liquibase formatted sql
--changeset amonopoli:202503241000_12 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_comuni(
 provincia_stato                 NUMBER (3,0)     NOT NULL,
 comune                          NUMBER (3,0)     NOT NULL,
 denominazione                   VARCHAR (40)        NULL,
 denominazione_al1               VARCHAR (40)        NULL,
 denominazione_al2               VARCHAR (40)        NULL,
 denominazione_breve             VARCHAR (16)        NULL,
 denominazione_breve_al1         VARCHAR (16)        NULL,
 denominazione_breve_al2         VARCHAR (16)        NULL,
 capoluogo_provincia             VARCHAR (1)         NULL,
 cap                             NUMBER (5,0)     NULL,
 provincia_tribunale             NUMBER (3,0)     NULL,
 comune_tribunale                NUMBER (3,0)     NULL,
 provincia_distretto             NUMBER (3,0)     NULL,
 comune_distretto                NUMBER (3,0)     NULL,
 data_soppressione               DATE             NULL,
 provincia_fusione               NUMBER (3,0)     NULL,
 comune_fusione                  NUMBER (3,0)     NULL,
 sigla_cfis                      VARCHAR (4)         NULL,
 consolato                       NUMBER (5,0)     NULL,
 tipo_consolato                  NUMBER (2,0)     NULL
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
     w_nome_ogg := 'COMU_CONS_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COMU_CONS_FK ON A_COMUNI
(
      consolato )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'COMU_DISTR_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COMU_DISTR_FK ON A_COMUNI
(
      provincia_distretto ,
      comune_distretto )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'COMU_FUS_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COMU_FUS_FK ON A_COMUNI
(
      provincia_fusione ,
      comune_fusione )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'COMU_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX COMU_PK ON A_COMUNI
(
      provincia_stato ,
      comune )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'COMU_TRIB_FK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COMU_TRIB_FK ON A_COMUNI
(
      provincia_tribunale ,
      comune_tribunale )';

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

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'COMU_DENO';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE INDEX COMU_DENO ON A_COMUNI
(
      denominazione )';

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
COMMENT ON TABLE a_comuni
    IS 'Created from Entity COMUNE by A00 on 13-MAY-93'
/
COMMENT ON COLUMN a_comuni.provincia_stato
    IS 'Codice provincia per i comuni italiani dello stato per gli esteri'
/
COMMENT ON COLUMN a_comuni.comune
    IS 'Codice comune'
/
COMMENT ON COLUMN a_comuni.denominazione
    IS 'Descrizione ufficiale del comune'
/
COMMENT ON COLUMN a_comuni.denominazione_al1
    IS 'Descrizione ufficiale del comune'
/
COMMENT ON COLUMN a_comuni.denominazione_al2
    IS 'Descrizione ufficiale del comune'
/
COMMENT ON COLUMN a_comuni.denominazione_breve
    IS 'Descrizione breve del comune'
/
COMMENT ON COLUMN a_comuni.denominazione_breve_al1
    IS 'Descrizione breve del comune'
/
COMMENT ON COLUMN a_comuni.denominazione_breve_al2
    IS 'Descrizione breve del comune'
/
COMMENT ON COLUMN a_comuni.capoluogo_provincia
    IS 'Indicatore di capoluogo di provincia per i comuni italiani'
/
COMMENT ON COLUMN a_comuni.cap
    IS 'codice avviamento postale per i comuni italiani'
/
COMMENT ON COLUMN a_comuni.provincia_tribunale
    IS 'Codice della provincia'
/
COMMENT ON COLUMN a_comuni.comune_tribunale
    IS 'Codice comune'
/
COMMENT ON COLUMN a_comuni.provincia_distretto
    IS 'Codice provincia per i comuni italiani dello stato per gli esteri'
/
COMMENT ON COLUMN a_comuni.comune_distretto
    IS 'Codice comune'
/
COMMENT ON COLUMN a_comuni.data_soppressione
    IS 'Data nella quale il comune e'' stato fuso con altri o soppresso'
/
COMMENT ON COLUMN a_comuni.provincia_fusione
    IS 'Codice provincia per i comuni italiani dello stato per gli esteri'
/
COMMENT ON COLUMN a_comuni.comune_fusione
    IS 'Codice comune'
/
COMMENT ON COLUMN a_comuni.sigla_cfis
    IS 'Sigla relativa ai comuni italiani per composizione codice fiscale'
/
COMMENT ON COLUMN a_comuni.consolato
    IS 'Codice del consolato'
/
