--liquibase formatted sql
--changeset amonopoli:202503241000_54 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_storico_comuni';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_storico_comuni(
 provincia                       NUMBER (3,0)     NOT NULL,
 comune                          NUMBER (3,0)     NOT NULL,
 denominazione                   VARCHAR (40)        NULL,
 denominazione_al1               VARCHAR (40)        NULL,
 denominazione_al2               VARCHAR (40)        NULL,
 denominazione_breve             VARCHAR (16)        NULL,
 denominazione_breve_al1         VARCHAR (16)        NULL,
 denominazione_breve_al2         VARCHAR (16)        NULL,
 data_inizio_validita            DATE             NOT NULL,
 data_fine_validita              DATE             NULL
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
     w_nome_ogg := 'SDCI_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX SDCI_PK ON A_STORICO_COMUNI
(
      provincia ,
      comune ,
      data_inizio_validita )';

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
COMMENT ON TABLE a_storico_comuni
    IS 'Created from Entity STORICO DENOMINAZIONE COMUNI ITALIANI by A00 on 02-JUN-93'
/
COMMENT ON COLUMN a_storico_comuni.provincia
    IS 'Codice della provincia'
/
COMMENT ON COLUMN a_storico_comuni.comune
    IS 'Codice del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione
    IS 'Denominazione del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione_al1
    IS 'Denominazione del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione_al2
    IS 'Denominazione del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione_breve
    IS 'Denominazione breve del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione_breve_al1
    IS 'Denominazione breve del comune'
/
COMMENT ON COLUMN a_storico_comuni.denominazione_breve_al2
    IS 'Denominazione breve del comune'
/
COMMENT ON COLUMN a_storico_comuni.data_inizio_validita
    IS 'Data di inizio validita'' della denominazione'
/
COMMENT ON COLUMN a_storico_comuni.data_fine_validita
    IS 'Data di fine validita'' della denominazione'
/
