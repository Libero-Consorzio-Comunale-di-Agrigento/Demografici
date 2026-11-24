--liquibase formatted sql
--changeset amonopoli:202606091455_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANACRE';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table anacre 
(ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,COD_FAM_PROV                                       NUMBER(7)
,FLAG_INTERO_NUCLEO                                 VARCHAR2(1)
,FLAG_AGGREGAZIONE                                  VARCHAR2(1)
,FAMIGLIA_CONVIVENZA                                VARCHAR2(1)
,COD_VIA                                            NUMBER(4)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,CONVIVENZA                                         VARCHAR2(60)
,COD_FAM_DEST                                       NUMBER(7)
,FLAG_ANNULLAMENTO                                  VARCHAR2(1)
,PRESSO                                             VARCHAR2(60)
,SUB_INTERNO                                        VARCHAR2(3)
,CIVICO_ESTERNO                                     VARCHAR2(100)
,CIVICO_INTERNO                                     VARCHAR2(100)
,DATA_DECORRENZA                                    NUMBER(8)
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,COD_FAM_UNIQUE_DEST                                VARCHAR2(20)
,COD_FAM_UNIQUE_PROV                                VARCHAR2(20)
,TIPO_CONVIVENZA                                    NUMBER(2)
,D_DATA_ISTITUZIONE_CONV                            DATE
,MATRICOLA_INTESTATARIO_CONV                        NUMBER(7)
,COGNOME_INTESTATARIO_CONV                          VARCHAR2(100)
,NOME_INTESTATARIO_CONV                             VARCHAR2(100)
,D_DATA_INTESTATARIO_CONV                           DATE
,COGNOME_PRESSO                                     VARCHAR2(100)
,NOME_PRESSO                                        VARCHAR2(100)
,ID_ANATPR                                          NUMBER(10)
,D_DATA_DECORRENZA                                  DATE
,SOTTOSCRITTO                                       NUMBER(2)
,FLAG_METRICO                                       VARCHAR2(1)
,PROGR_SNC                                          VARCHAR2(10)
,FLAG_LETTERA                                       VARCHAR2(1)
,FLAG_ESPONENTE                                     VARCHAR2(1)
,FLAG_NUI                                           VARCHAR2(1)
,NUI                                                VARCHAR2(10)
,COLORE                                             VARCHAR2(10)
,CORTE                                              VARCHAR2(10)
,INTERNO2                                           NUMBER(4)
,SUB_INTERNO2                                       VARCHAR2(3)
,SECONDARIO                                         VARCHAR2(10)
,SCALA_ESTERNA                                      VARCHAR2(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anacre on anacre (anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'create unique index idx2anacre on anacre (cod_fam_unique_dest)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anacre_pk1 on anacre (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create index anacre_pk2 on anacre (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk4 >>
     w_sql := 'create index anacre_pk4 on anacre (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anacre_SQ nocache';

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
comment on table anacre is 'Anagrafe - Dati preparatori per pratiche di Cambio Residenza'
/
