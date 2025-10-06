--liquibase formatted sql
--changeset amonopoli:202312151105 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ISTMSU';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table istmsu
(UFFICIO                                            NUMBER(2)
,ANNO                                               NUMBER(4)
,ATTO                                               NUMBER(4)
,PARTE                                              NUMBER(1)
,SERIE                                              VARCHAR2(1)
,COD_MODELLO                                        VARCHAR2(5)	
,PROGR_QUESTIONARIO                                 NUMBER(8)
,TIPO_ACCORDO                                       NUMBER(1)
,SENTENZA                                           NUMBER(6)
,DATA_SENTENZA                                      NUMBER(8)
,COD_PRO_TRIB                                       NUMBER(3)
,COD_COM_TRIB                                       NUMBER(3)
,UFFICIO_UCI                                        NUMBER(2)
,ANNO_UCI                                           NUMBER(4)
,ATTO_UCI                                           NUMBER(4)
,PARTE_UCI                                          NUMBER(1)
,SERIE_UCI                                          VARCHAR2(1)
,COD_PRO_UCI                                        NUMBER(3)
,COD_COM_UCI                                        NUMBER(3)
,DATA_UCI                                           NUMBER(8)
,COD_FISCALE_1                                      VARCHAR2(16)
,INDIRIZZO_RES_1                                    VARCHAR2(100)
,CIVICO_RES_1                                       VARCHAR2(5)
,CAP_RES_1                                          VARCHAR2(5)
,NAZIONALITA_ITA_1                                  NUMBER(1)
,DATA_NAZIONALITA_1                                 NUMBER(8)
,STATO_CIVILE_1                                     NUMBER(1)
,COD_FISCALE_2                                      VARCHAR2(16)
,INDIRIZZO_RES_2                                    VARCHAR2(100)
,CIVICO_RES_2                                       VARCHAR2(5)
,CAP_RES_2                                          VARCHAR2(5)
,NAZIONALITA_ITA_2                                  NUMBER(1)
,DATA_NAZIONALITA_2                                 NUMBER(8)
,STATO_CIVILE_2                                     NUMBER(1)
,FLAG_COMPLETO                                      VARCHAR2(1)
,CAUSA_SCIOGLIMENTO                                 NUMBER(1)
,REGIME_PATRIMONIALE_UCI                            NUMBER(1)
,D_DATA_SENTENZA                                    DATE
,D_DATA_UCI                                         DATE
,D_DATA_NAZIONALITA_1                               DATE
,D_DATA_NAZIONALITA_2                               DATE
,ID_ATTO                                            VARCHAR2(25)
,ID                                                 NUMBER(10)
,VERSION                                            NUMBER(20)
,data_iscr_ruolo_trib                               NUMBER(8)
,data_provvedimento_trib                            NUMBER(8)
,data_trascr_provv_trib                             NUMBER(8)
,d_data_iscr_ruolo_trib                             DATE
,d_data_provvedimento_trib                          DATE
,d_data_trascr_provv_trib                           DATE
,ID_CIVANN                                          NUMBER(10)
,COD_PRO_RES_1                                      NUMBER(3)
,COD_COM_RES_1                                      NUMBER(3)
,COD_PRO_RES_2                                      NUMBER(3)
,COD_COM_RES_2                                      NUMBER(3)
,TIPO_PROCEDURA                                     NUMBER(1)
,TIPO_PROVVEDIMENTO_TRIB                            NUMBER(1)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'ISTMSU';
w_nome_col      varchar2(255) := 'ID_CIVANN';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table istmsu
add
(ID_CIVANN                                          NUMBER(10)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'ISTMSU';
w_nome_col      varchar2(255) := 'COD_PRO_RES_1';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table istmsu
add
(COD_PRO_RES_1                                      NUMBER(3)
,COD_COM_RES_1                                      NUMBER(3)
,COD_PRO_RES_2                                      NUMBER(3)
,COD_COM_RES_2                                      NUMBER(3)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'istmsu';
w_nome_col      varchar2(255) := 'TIPO_PROCEDURA';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsu
add 
(TIPO_PROCEDURA                                      NUMBER(1)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'istmsu';
w_nome_col      varchar2(255) := 'TIPO_PROVVEDIMENTO_TRIB';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsu
add 
(TIPO_PROVVEDIMENTO_TRIB                               NUMBER(1)
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

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'IDX1ISTMSU';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx1istmsu on istmsu (ufficio, anno, atto, parte, serie)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'drop index idx1istmsu';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' droppato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non droppato ('||SQLERRM||')');
     end;

     w_sql := 'create index idx1istmsu on istmsu (ufficio, anno, atto, parte, serie)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'IDX2ISTMSU';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx2istmsu on istmsu (id_atto)';

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

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'IDX3ISTMSU';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx3istmsu on istmsu (id)';

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

w_tipo_ogg	varchar2(255) := 'IDX';
w_nome_ogg	varchar2(255) := 'IDX4ISTMSU';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx4istmsu on istmsu (id_civann)';

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
w_nome_ogg	varchar2(255) := 'ISTMSU_SQ';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create sequence istmsu_SQ nocache';

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
comment on table istmsu is 'ISTAT - Dati per Compilazione Modello ISTAT SDSU - Scioglimenti Unioni Civili'
/
comment on column istmsu.COD_MODELLO is 'Valori consentiti: 12SD , 6SD, PROVV'
/
