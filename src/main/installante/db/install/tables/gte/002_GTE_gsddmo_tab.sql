--liquibase formatted sql
--changeset snocca:202209261145_2 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'GTE_GSDDMO';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table GTE_GSDDMO
(
  ID            NUMBER(19) not null,
  VERSION       NUMBER(19) not null,
  DATA_INS      DATE not null,
  CODICE        VARCHAR2(255) not null,
  DESCRIZIONE   VARCHAR2(255),
  AMBITO        VARCHAR2(255) not null,
  GRUPPO        VARCHAR2(255) not null,
  FILE_TEMPLATE BLOB not null,
  DATA_UPD      DATE not null,
  NOME          VARCHAR2(255) not null,
  TIPO          VARCHAR2(255) not null,
  TIPO_MODELLO  VARCHAR2(255),
  FORMATO_TESTO VARCHAR2(255),
  UTENTE_INS    VARCHAR2(255) not null,
  UTENTE_UPD    VARCHAR2(255) not null,
  VALIDO        CHAR(1) not null,
  VALIDO_AL     DATE,
  VALIDO_DAL    DATE not null
)';

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
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'idx';
w_nome_ogg	varchar2(255) := 'GTE_GSDDMO_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table GTE_GSDDMO
  add constraint GTE_GSDDMO_PK primary key (ID)
  using index';

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
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'idx';
w_nome_ogg	varchar2(255) := 'GTEGSDDMO_GTETIPMOD_FK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table GTE_GSDDMO
  add constraint GTEGSDDMO_GTETIPMOD_FK foreign key (TIPO_MODELLO)
  references GTE_TIPI_MODELLO (CODICE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) non creato ('||SQLERRM||')');
     end;

     w_sql := 'create index GTEGSDDMO_GTETIPMOD_FK on GTE_GSDDMO (TIPO_MODELLO)';

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
end;
/
comment on table GTE_GSDDMO is 'Gestione Testi - Dizionario Modelli'
/
