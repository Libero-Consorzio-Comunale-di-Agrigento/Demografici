--liquibase formatted sql
--changeset amonopoli:202304061130_2 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table ISTMD3
(UFFICIO_MAT                                        NUMBER(2)
,ANNO_MAT                                           NUMBER(4)
,ATTO_MAT                                           NUMBER(4)
,PARTE_MAT                                          NUMBER(1)
,SERIE_MAT                                          VARCHAR2(1)
,UFFICIO_PUB                                        NUMBER(2)
,ANNO_PUB                                           NUMBER(4)
,ATTO_PUB                                           NUMBER(4)
,PARTE_PUB                                          NUMBER(1)
,SERIE_PUB                                          VARCHAR2(1)
,STATO_CIVILE_M                                     VARCHAR2(2)
,DATA_FINE_MAT_M                                    NUMBER(8)
,GRADO_ISTRUZIONE_M                                 NUMBER(1)
,CONDIZIONE_PROF_M                                  NUMBER(1)
,POSIZIONE_PROF_M                                   NUMBER(1)
,ATTIVITA_PROF_M                                    NUMBER(1)
,NAZIONALITA_ITA_M                                  NUMBER(1)
,COD_PRO_RES_POST_M                                 NUMBER(3)
,COD_COM_RES_POST_M                                 NUMBER(3)
,STATO_CIVILE_F                                     VARCHAR2(2)
,DATA_FINE_MAT_F                                    NUMBER(8)
,GRADO_ISTRUZIONE_F                                 NUMBER(1)
,CONDIZIONE_PROF_F                                  NUMBER(1)
,POSIZIONE_PROF_F                                   NUMBER(1)
,ATTIVITA_PROF_F                                    NUMBER(1)
,NAZIONALITA_ITA_F                                  NUMBER(1)
,COD_PRO_RES_POST_F                                 NUMBER(3)
,COD_COM_RES_POST_F                                 NUMBER(3)
,FLAG_COMPLETO                                      VARCHAR2(1)
,D_DATA_FINE_MAT_M                                  DATE
,D_DATA_FINE_MAT_F                                  DATE
,ID_ATTO_MAT                                        VARCHAR2(25)
,ID_ATTO_PUB                                        VARCHAR2(25)
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
w_nome_ogg	varchar2(255) := 'IDX1ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx1ISTMD3 on ISTMD3 (ufficio_mat, anno_mat, atto_mat, parte_mat, serie_mat)';

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
w_nome_ogg	varchar2(255) := 'IDX2ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx2ISTMD3 on ISTMD3 (ufficio_pub, anno_pub, atto_pub, parte_pub, serie_pub)';

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
w_nome_ogg	varchar2(255) := 'IDX3ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx3istmd3 on istmd3 (id_atto_pub)';

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
w_nome_ogg	varchar2(255) := 'IDX4ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx4istmd3 on istmd3 (id_atto_mat)';

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
w_nome_ogg	varchar2(255) := 'IDX5ISTMD3';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx5istmd3 on istmd3 (id)';

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
w_nome_ogg	varchar2(255) := 'ISTMD3_SQ';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create sequence istmd3_SQ nocache';

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
comment on table ISTMD3 is 'ISTAT - Dati per Compilazione Modello ISTAT D.3'
/
