--liquibase formatted sql
--changeset amonopoli:202606101515_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANARET';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANARET 
(ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,TIPO_RETTIFICA                                     VARCHAR2(1)
,COD_FAM                                            NUMBER(7)
,COD_VIA                                            NUMBER(4)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,FLAG_ANNULLAMENTO                                  VARCHAR2(1)
,SUB_INTERNO                                        VARCHAR2(3)
,CIVICO_ESTERNO                                     VARCHAR2(100)
,CIVICO_INTERNO                                     VARCHAR2(100)
,DATA_DECORRENZA                                    NUMBER(8)
,D_DATA_DECORRENZA                                  DATE
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
,COD_FAM_UNIQUE                                     VARCHAR2(20)
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,ID_ANATPR                                          NUMBER(10)
,SOTTOSCRITTO                                       NUMBER(2)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anaret on anaret (anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anaret_pk1 on anaret (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create index anaret_pk2 on anaret (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk4 >>
     w_sql := 'create index anaret_pk4 on anaret (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anaret_SQ nocache';

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
COMMENT ON TABLE ANARET IS 'Anagrafe - Dati preparatori per Pratiche di Rettifica'
/
