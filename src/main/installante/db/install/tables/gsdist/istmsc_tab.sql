--liquibase formatted sql
--changeset amonopoli:202304061130_6 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ISTMSC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table istmsc
(UFFICIO                                            NUMBER(2)
,ANNO                                               NUMBER(4)
,ATTO                                               NUMBER(4)
,PARTE                                              NUMBER(1)
,SERIE                                              VARCHAR2(1)
,COD_MODELLO                                        VARCHAR2(5)
,PROGR_QUESTIONARIO                                 NUMBER(8)
,TIPO_ACCORDO                                       NUMBER(1)
,TIPO_SEPARAZIONE                                   NUMBER(1)
,SENTENZA                                           NUMBER(6)
,DATA_SENTENZA                                      NUMBER(8)
,COD_PRO_TRIB                                       NUMBER(3)
,COD_COM_TRIB                                       NUMBER(3)
,DATA_STIPULA_SEP                                   NUMBER(8)
,DATA_REG_SEP                                       NUMBER(8)
,SEP_NEL_COMUNE                                     NUMBER(1)
,COD_PRO_SEP                                        NUMBER(3)
,COD_COM_SEP                                        NUMBER(3)
,UFFICIO_MAT                                        NUMBER(2)
,ANNO_MAT                                           NUMBER(4)
,ATTO_MAT                                           NUMBER(4)
,PARTE_MAT                                          NUMBER(1)
,SERIE_MAT                                          VARCHAR2(1)
,COD_PRO_MAT                                        NUMBER(3)
,COD_COM_MAT                                        NUMBER(3)
,DATA_MAT                                           NUMBER(8)
,RITO_MAT                                           NUMBER(1)
,COD_FISCALE_M                                      VARCHAR2(16)
,INDIRIZZO_RES_M                                    VARCHAR2(100)
,CIVICO_RES_M                                       VARCHAR2(5)
,CAP_RES_M                                          VARCHAR2(5)
,NAZIONALITA_ITA_M                                  NUMBER(1)
,DATA_NAZIONALITA_M                                 NUMBER(8)
,STATO_CIVILE_M                                     NUMBER(1)
,TITOLO_STUDIO_M                                    NUMBER(1)
,CONDIZIONE_PROF_M                                  NUMBER(1)
,POSIZIONE_PROF_M                                   NUMBER(2)
,COD_FISCALE_F                                      VARCHAR2(16)
,INDIRIZZO_RES_F                                    VARCHAR2(100)
,CIVICO_RES_F                                       VARCHAR2(5)
,CAP_RES_F                                          VARCHAR2(5)
,NAZIONALITA_ITA_F                                  NUMBER(1)
,DATA_NAZIONALITA_F                                 NUMBER(8)
,STATO_CIVILE_F                                     NUMBER(1)
,TITOLO_STUDIO_F                                    NUMBER(1)
,CONDIZIONE_PROF_F                                  NUMBER(1)
,POSIZIONE_PROF_F                                   NUMBER(2)
,COGNOME_AVV_M                                      VARCHAR2(100)
,NOME_AVV_M                                         VARCHAR2(100)
,COD_FISCALE_AVV_M                                  VARCHAR2(16)
,COD_PRO_ALBO_AVV_M                                 NUMBER(3)
,COD_COM_ALBO_AVV_M                                 NUMBER(3)
,NUMERO_ALBO_AVV_M                                  VARCHAR2(7)
,COGNOME_AVV_F                                      VARCHAR2(100)
,NOME_AVV_F                                         VARCHAR2(100)
,COD_FISCALE_AVV_F                                  VARCHAR2(16)
,COD_PRO_ALBO_AVV_F                                 NUMBER(3)
,COD_COM_ALBO_AVV_F                                 NUMBER(3)
,NUMERO_ALBO_AVV_F                                  VARCHAR2(7)
,SOSTENTAMENTO_CN                                   NUMBER(1)
,CHI_SOSTENTAMENTO_CN                               NUMBER(1)
,IMPORTO_MENSILE_CN                                 NUMBER(6)
,IMPORTO_UNICO_CN                                   NUMBER(6)
,ABITAZIONE_ASSEGNATA                               NUMBER(1)
,SOSTENTAMENTO_FG                                   NUMBER(1)
,CHI_SOSTENTAMENTO_FG                               NUMBER(1)
,IMPORTO_MENSILE_FG                                 NUMBER(6)
,PRESENZA_FG                                        NUMBER(1)
,NUMERO_FG                                          NUMBER(2)
,SESSO_FG_1                                         VARCHAR2(1)
,DATA_NAS_FG_1                                      NUMBER(8)
,COD_FISCALE_FG_1                                   VARCHAR2(16)
,AFFIDAMENTO_FG_1                                   NUMBER(1)
,SESSO_FG_2                                         VARCHAR2(1)
,DATA_NAS_FG_2                                      NUMBER(8)
,COD_FISCALE_FG_2                                   VARCHAR2(16)
,AFFIDAMENTO_FG_2                                   NUMBER(1)
,SESSO_FG_3                                         VARCHAR2(1)
,DATA_NAS_FG_3                                      NUMBER(8)
,COD_FISCALE_FG_3                                   VARCHAR2(16)
,AFFIDAMENTO_FG_3                                   NUMBER(1)
,SESSO_FG_4                                         VARCHAR2(1)
,DATA_NAS_FG_4                                      NUMBER(8)
,COD_FISCALE_FG_4                                   VARCHAR2(16)
,AFFIDAMENTO_FG_4                                   NUMBER(1)
,SESSO_FG_5                                         VARCHAR2(1)
,DATA_NAS_FG_5                                      NUMBER(8)
,COD_FISCALE_FG_5                                   VARCHAR2(16)
,AFFIDAMENTO_FG_5                                   NUMBER(1)
,FLAG_COMPLETO                                      VARCHAR2(1)
,CAUSA_SCIOGLIMENTO                                 NUMBER(1)
,REGIME_PATRIMONIALE_MAT                            NUMBER(1)
,PRESENZA_FG_MIN                                    NUMBER(1)
,NUMERO_FG_MIN                                      NUMBER(2)
,PRESENZA_FG_MAG                                    NUMBER(1)
,NUMERO_FG_MAG                                      NUMBER(2)
,NOME_FG_1                                          VARCHAR2(100)
,COGNOME_FG_1                                       VARCHAR2(100)
,ETA_FG_1                                           NUMBER(2)
,PERNOTTAMENTI_FG_1                                 NUMBER(2)
,NOME_FG_2                                          VARCHAR2(100)
,COGNOME_FG_2                                       VARCHAR2(100)
,ETA_FG_2                                           NUMBER(2)
,PERNOTTAMENTI_FG_2                                 NUMBER(2)
,NOME_FG_3                                          VARCHAR2(100)
,COGNOME_FG_3                                       VARCHAR2(100)
,ETA_FG_3                                           NUMBER(2)
,PERNOTTAMENTI_FG_3                                 NUMBER(2)
,NOME_FG_4                                          VARCHAR2(100)
,COGNOME_FG_4                                       VARCHAR2(100)
,ETA_FG_4                                           NUMBER(2)
,PERNOTTAMENTI_FG_4                                 NUMBER(2)
,MANTENIMENTO_FG                                    NUMBER(1)
,CAPITOLO_SPESA_1                                   NUMBER(6)
,CAPITOLO_SPESA_2                                   NUMBER(6)
,CAPITOLO_SPESA_3                                   NUMBER(6)
,CAPITOLO_SPESA_4                                   NUMBER(6)
,CAPITOLO_SPESA_5                                   NUMBER(6)
,MANTENIMENTO_FG_MAG                                NUMBER(1)
,D_DATA_SENTENZA                                    DATE
,D_DATA_STIPULA_SEP                                 DATE
,D_DATA_REG_SEP                                     DATE
,D_DATA_MAT                                         DATE
,D_DATA_NAZIONALITA_M                               DATE
,D_DATA_NAZIONALITA_F                               DATE
,D_DATA_NAS_FG_1                                    DATE
,D_DATA_NAS_FG_2                                    DATE
,D_DATA_NAS_FG_3                                    DATE
,D_DATA_NAS_FG_4                                    DATE
,D_DATA_NAS_FG_5                                    DATE
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
,COD_PRO_RES_M                                      NUMBER(3)
,COD_COM_RES_M                                      NUMBER(3)
,COD_PRO_RES_F                                      NUMBER(3)
,COD_COM_RES_F                                      NUMBER(3)
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
w_nome_ogg	varchar2(255) := 'istmsc';
w_nome_col      varchar2(255) := 'data_iscrizione_ruolo_trib';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsc
add 
(data_iscr_ruolo_trib                               NUMBER(8)
,data_provvedimento_trib                            NUMBER(8)
,data_trascr_provv_trib                             NUMBER(8)
,d_data_iscr_ruolo_trib                             DATE
,d_data_provvedimento_trib                          DATE
,d_data_trascr_provv_trib                           DATE

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
w_nome_ogg	varchar2(255) := 'istmsc';
w_nome_col      varchar2(255) := 'ID_CIVANN';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsc
add 
(ID_CIVANN                     NUMBER(10)
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
w_nome_ogg	varchar2(255) := 'istmsc';
w_nome_col      varchar2(255) := 'COD_PRO_RES_M';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsc
add 
(COD_PRO_RES_M                                      NUMBER(3)
,COD_COM_RES_M                                      NUMBER(3)
,COD_PRO_RES_F                                      NUMBER(3)
,COD_COM_RES_F                                      NUMBER(3)
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
w_nome_ogg	varchar2(255) := 'istmsc';
w_nome_col      varchar2(255) := 'TIPO_PROCEDURA';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsc
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
w_nome_ogg	varchar2(255) := 'istmsc';
w_nome_col      varchar2(255) := 'TIPO_PROVVEDIMENTO_TRIB';
w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
     w_sql := 'alter table istmsc
add 
(TIPO_PROVVEDIMENTO_TRIB                            NUMBER(1)
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
w_nome_ogg	varchar2(255) := 'IDX1ISTMSC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx1istmsc on istmsc (ufficio, anno, atto, parte, serie)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'drop index idx1istmsc';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' droppato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non droppato ('||SQLERRM||')');
     end;

     w_sql := 'create index idx1istmsc on istmsc (ufficio, anno, atto, parte, serie)';

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
w_nome_ogg	varchar2(255) := 'IDX2ISTMSC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx2istmsc on istmsc (id_atto)';

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
w_nome_ogg	varchar2(255) := 'IDX3ISTMSC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create unique index idx3istmsc on istmsc (id)';

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
w_nome_ogg	varchar2(255) := 'IDX4ISTMSC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create index idx4istmsc on istmsc (id_civann)';

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
w_nome_ogg	varchar2(255) := 'ISTMSC_SQ';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create sequence istmsc_SQ nocache';

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
comment on table istmsc is 'ISTAT - Dati per Compilazione Modello ISTAT SDSU - Separazioni / Divorzi'
/
comment on column istmsc.COD_MODELLO is 'Valori consentiti: 12SD , 6SD , PROVV'
/
