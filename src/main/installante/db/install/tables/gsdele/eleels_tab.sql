--liquibase formatted sql
--changeset amonopoli:202602130855 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ELEELS';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE ELEELS (
                   MATRICOLA                        NUMBER(7) ,
                   COGNOME_NOME                     VARCHAR2(100) ,
                   SESSO                            VARCHAR2(1) ,
                   STATO                            VARCHAR2(1) ,
                   MOTIVO                           NUMBER(2) ,
                   COD_VIA_ELE                      NUMBER(4) ,
                   NUM_CIV_ELE                      NUMBER(4) ,
                   SUFFISSO_ELE                     VARCHAR2(10) ,
                   INTERNO_ELE                      NUMBER(4) ,
                   VIA_AIRE_ELE                     VARCHAR2(100) ,
                   COD_PRO_AIRE_ELE                 NUMBER(3) ,
                   COD_COM_AIRE_ELE                 NUMBER(3) ,
                   FASCICOLO                        NUMBER(7) ,
                   ANNO                             NUMBER(4) ,
                   SEZIONE                          NUMBER(4) ,
                   PROGR_LISTA_SEZ                  NUMBER(4) ,
                   PROGR_LISTA_GEN                  NUMBER(6) ,
                   REVISIONE                        VARCHAR2(2) ,
                   PROGR_REVISIONE                  NUMBER(2) ,
                   ANNO_E                           NUMBER(4) ,
                   REVISIONE_E                      VARCHAR2(2) ,
                   PROGR_REVISIONE_E                NUMBER(2) ,
                   MOTIVO_E                         NUMBER(2),
		   SCALA_ELE                        VARCHAR2(3),
		   PIANO_ELE                        VARCHAR2(3),
		   SUB_INTERNO_ELE                  VARCHAR2(3),
		   CIVICO_ESTERNO_ELE               VARCHAR2(40),
		   CIVICO_INTERNO_ELE               VARCHAR2(40),
                   TIPO_LISTA                       VARCHAR2(1) 
)
';

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
w_nome_ogg	varchar2(255) := 'IDX1ELEELS';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE INDEX IDX1ELEELS ON ELEELS (
                   MATRICOLA
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
w_nome_ogg	varchar2(255) := 'IDX2ELEELS';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE INDEX IDX2ELEELS ON ELEELS (
                   ANNO_E ,
                   REVISIONE_E ,
                   PROGR_REVISIONE_E
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'idx';
w_nome_ogg	varchar2(255) := 'IDX3ELEELS';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE INDEX IDX3ELEELS ON ELEELS (
                   SEZIONE ,
                   SESSO ,
                   PROGR_LISTA_SEZ
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
w_nome_ogg	varchar2(255) := 'IDX4ELEELS';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE INDEX IDX4ELEELS ON ELEELS (
                   TIPO_LISTA ,
                   MATRICOLA
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
comment on table ELEELS is 'Elettorale - Anagrafe Liste Aggiunte Storica - per Stampa Liste Sezionali'
/
