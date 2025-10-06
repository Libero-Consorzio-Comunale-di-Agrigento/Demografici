--liquibase formatted sql
--changeset amonopoli:202304061130_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ISTM4B';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table ISTM4B
(UFFICIO                                            NUMBER(2)
,ANNO                                               NUMBER(4)
,ATTO                                               NUMBER(4)
,PARTE                                              NUMBER(2)
,SERIE                                              VARCHAR2(1)
,INDICAZIONE_ETA                                    NUMBER(1)
,ETA_COMPIUTA                                       NUMBER(2)
,GENERE_PARTO                                       NUMBER(1)
,DURATA_GESTAZIONE                                  NUMBER(2)
,FILIAZIONE                                         NUMBER(1)
,ORDINE_NASCITA                                     NUMBER(2)
,MORTALITA_PREC                                     NUMBER(1)
,NUMERO_MORTI_1ANNO                                 NUMBER(2)
,NUMERO_VIVI_PREC                                   NUMBER(2)
,NUMERO_MORTI_PREC                                  NUMBER(2)
,NUMERO_ABORTI_PREC                                 NUMBER(2)
,DATA_NAS_NATO_PREC                                 NUMBER(8)
,TIPO_PARTO                                         NUMBER(1)
,PRESENTAZIONE                                      NUMBER(1)
,PESO_NEONATO                                       NUMBER(4)
,LUOGO_PARTO                                        NUMBER(1)
,LUOGO_DECESSO                                      NUMBER(1)
,CONSANGUINEO                                       NUMBER(1)
,GRADO_ISTRUZIONE_PAT                               NUMBER(1)
,CONDIZIONE_PROF_PAT                                NUMBER(1)
,POSIZIONE_PROF_PAT                                 NUMBER(1)
,ATTIVITA_PROF_PAT                                  NUMBER(1)
,NAZIONALITA_PAT                                    VARCHAR2(3)
,NAZIONALITA_ITA_PAT                                NUMBER(1)
,NAZIONALITA_STR_PAT                                NUMBER(1)
,COD_FISCALE_PAT                                    VARCHAR2(16)
,DATA_NAS_MAT                                       NUMBER(8)
,COD_PRO_RES_MAT                                    NUMBER(3)
,COD_COM_RES_MAT                                    NUMBER(3)
,GRADO_ISTRUZIONE_MAT                               NUMBER(1)
,CONDIZIONE_PROF_MAT                                NUMBER(1)
,POSIZIONE_PROF_MAT                                 NUMBER(1)
,ATTIVITA_PROF_MAT                                  NUMBER(1)
,NAZIONALITA_MAT                                    VARCHAR2(3)
,NAZIONALITA_ITA_MAT                                NUMBER(1)
,NAZIONALITA_STR_MAT                                NUMBER(1)
,COD_FISCALE_MAT                                    VARCHAR2(16)
,FLAG_COMPLETO                                      VARCHAR2(1)
,NUMERO_SCHEDA                                      NUMBER(4)
,D_DATA_NAS_NATO_PREC                               DATE
,D_DATA_NAS_MAT                                     DATE
,ID_ATTO                                            VARCHAR2(25)
,ID                                                 NUMBER(10)
,VERSION                                            NUMBER(20)
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
w_nome_ogg	varchar2(255) := 'IDX1ISTM4B';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx1ISTM4B on ISTM4B (ufficio, anno, atto, parte, serie)';

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
w_nome_ogg	varchar2(255) := 'IDX2ISTM4B';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx2istm4b on istm4b (id_atto)';

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
w_nome_ogg	varchar2(255) := 'IDX3ISTM4B';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx3istm4b on istm4b (id)';

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

w_tipo_ogg	varchar2(255) := 'SEQ';
w_nome_ogg	varchar2(255) := 'ISTM4B_SQ';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create sequence ISTM4B_SQ nocache';

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
comment on table ISTM4B is 'ISTAT - Dati per Compilazione Modello ISTAT D.4 / D.5 BIS'
/
