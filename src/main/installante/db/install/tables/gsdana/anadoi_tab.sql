--liquibase formatted sql
--changeset amonopoli:202606100955_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANADOI';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table ANADOI
(ANAGRAFE                                           VARCHAR2(3)
,TIPO_EVENTO                                        VARCHAR2(1)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,FLAG_LEGITTIMA                                     VARCHAR2(1)
,FLAG_PROPRIETARIO                                  VARCHAR2(1)
,SEZIONE_CATASTO                                    VARCHAR2(3)
,FOGLIO_CATASTO                                     VARCHAR2(5)
,NUMERO_CATASTO                                     VARCHAR2(5)
,SUBALTERNO_CATASTO                                 VARCHAR2(5)
,FLAG_LOCAZIONE                                     VARCHAR2(1)
,SEDE_CONTRATTO_LOCAZIONE                           VARCHAR2(60)
,DATA_CONTRATTO_LOCAZIONE                           NUMBER(8)
,NUM_CONTRATTO_LOCAZIONE                            VARCHAR2(20)
,NOME_PROPRIETA_LOCAZIONE                           VARCHAR2(100)
,CF_PROPRIETA_LOCAZIONE                             VARCHAR2(16)
,COMUNE_PROPRIETA_LOCAZIONE                         VARCHAR2(50)
,VIA_PROPRIETA_LOCAZIONE                            VARCHAR2(100)
,FLAG_LOCAZIONE_ERP                                 VARCHAR2(1)
,NOTE_LOCAZIONE_ERP                                 VARCHAR2(2000)
,FLAG_COMODATO                                      VARCHAR2(1)
,SEDE_CONTRATTO_COMODATO                            VARCHAR2(60)
,DATA_CONTRATTO_COMODATO                            NUMBER(8)
,NUM_CONTRATTO_COMODATO                             VARCHAR2(20)
,NOME_PROPRIETA_COMODATO                            VARCHAR2(100)
,CF_PROPRIETA_COMODATO                              VARCHAR2(16)
,COMUNE_PROPRIETA_COMODATO                          VARCHAR2(50)
,VIA_PROPRIETA_COMODATO                             VARCHAR2(100)
,FLAG_USUFRUTTO                                     VARCHAR2(1)
,NOTE_USUFRUTTO                                     VARCHAR2(2000)
,FLAG_TITOLO                                        VARCHAR2(1)
,NOTE_TITOLO                                        VARCHAR2(2000)
,SEZIONE_CATASTO_TPR                                VARCHAR2(3)
,FOGLIO_CATASTO_TPR                                 VARCHAR2(5)
,NUMERO_CATASTO_TPR                                 VARCHAR2(5)
,SUBALTERNO_CATASTO_TPR                             VARCHAR2(5)
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,D_DATA_CONTRATTO_LOCAZIONE                         DATE
,D_DATA_CONTRATTO_COMODATO                          DATE
,COD_PRO_CONTRATTO_LOCAZIONE                        NUMBER(3)
,COD_COM_CONTRATTO_LOCAZIONE                        NUMBER(3)
,COD_PRO_PROPRIETA_LOCAZIONE                        NUMBER(3)
,COD_COM_PROPRIETA_LOCAZIONE                        NUMBER(3)
,COD_PRO_CONTRATTO_COMODATO                         NUMBER(3)
,COD_COM_CONTRATTO_COMODATO                         NUMBER(3)
,COD_PRO_PROPRIETA_COMODATO                         NUMBER(3)
,COD_COM_PROPRIETA_COMODATO                         NUMBER(3)
,ID_ANATPR                                          NUMBER(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anadoi on anadoi (anagrafe, tipo_evento, anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anadoi_pk1 on anadoi (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create unique index anadoi_pk2 on anadoi (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk3 >>
     w_sql := 'create unique index anadoi_pk3 on anadoi (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anadoi_SQ nocache';

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
comment on table anadoi is 'Anagrafe - Dati Occupazione Immobile'
/

