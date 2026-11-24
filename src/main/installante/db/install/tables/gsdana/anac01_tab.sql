--liquibase formatted sql
--changeset amonopoli:202606101210_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAC01';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAC01 
(ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,DATA_PRATICA                                       NUMBER(8)
,CONTEGGIO                                          VARCHAR2(1)
,DATA_DEFINIZIONE                                   NUMBER(8)
,DATA_DECORRENZA                                    NUMBER(8)
,INIZIATIVA                                         NUMBER(1)
,ISCRIZIONE                                         VARCHAR2(1)
,MOTIVO                                             VARCHAR2(3)
,INDIVIDUAZIONE                                     NUMBER(1)
,COD_FAM                                            NUMBER(7)
,COD_CONSOLATO                                      NUMBER(5)
,TIPO_CONSOLATO                                     NUMBER(2)
,COD_TERRITORIO                                     NUMBER(3)
,PRESSO                                             VARCHAR2(60)
,VIA_AIRE                                           VARCHAR2(100)
,NUM_CIV                                            NUMBER(9)
,PAL_FABB                                           NUMBER(2)
,SCALA                                              NUMBER(2)
,PIANO                                              NUMBER(2)
,INTERNO                                            NUMBER(4)
,COD_PRO_AIRE                                       NUMBER(3)
,COD_COM_AIRE                                       NUMBER(3)
,DATA_ARRIVO                                        NUMBER(8)
,ANNO_ESPATRIO                                      NUMBER(4)
,COD_PRO_EVE                                        NUMBER(3)
,COD_COM_EVE                                        NUMBER(3)
,SOTTOSCRITTO                                       NUMBER(2)
,DICHIARO_CHIEDO                                    VARCHAR2(1)
,DATA_REG                                           NUMBER(8)
,PROTOCOLLO_AIRE                                    NUMBER(4)
,FLAG_AGGREGAZIONE                                  VARCHAR2(1)
,FLAG_INTERO_NUCLEO                                 VARCHAR2(1)
,COD_FAM_PROV                                       NUMBER(7)
,ZIPCODE                                            VARCHAR2(10)
,PROVINCIA_CONTEA                                   VARCHAR2(60)
,STATO_PRATICA                                      VARCHAR2(1)
,ANNO_PROTOCOLLO_AIRE                               NUMBER(4)
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,ID_PROTOCOLLO_AIRE                                 VARCHAR2(20)
,D_DATA_PRATICA                                     DATE
,D_DATA_DEFINIZIONE                                 DATE
,D_DATA_DECORRENZA                                  DATE
,D_DATA_ARRIVO                                      DATE
,D_DATA_REG                                         DATE
,COD_FAM_UNIQUE                                     VARCHAR2(20)
,COGNOME_PRESSO                                     VARCHAR2(100)
,NOME_PRESSO                                        VARCHAR2(100)
,ID_ARCCON                                          NUMBER(10)
,ID_ANATPR                                          NUMBER(10)
,COD_FAM_PROV_UNIQUE                                VARCHAR2(20)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1ANAC01 ON ANAC01 (ANNO_PROTOCOLLO_AIRE, PROTOCOLLO_AIRE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAC01 ON ANAC01 (ANNO_PRATICA, PRATICA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anac01_pk1 on anac01 (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create index anac01_pk2 on anac01 (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk3 >>
     w_sql := 'create index anac01_pk3 on anac01 (id_protocollo_aire)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk4 >>
     w_sql := 'create index anac01_pk4 on anac01 (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anac01_SQ nocache';

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
COMMENT ON TABLE ANAC01 IS 'Anagrafe - Modello AIRE/01 di Cancellazione'
/
