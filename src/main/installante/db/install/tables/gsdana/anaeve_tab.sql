--liquibase formatted sql
--changeset amonopoli:202503101300_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAEVE';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAEVE 
(MATRICOLA                                          NUMBER(7)
,COD_MOV                                            NUMBER(2)
,COD_EVE                                            NUMBER(2)
,DATA_INIZIO                                        NUMBER(8)
,DATA_EVE                                           NUMBER(8)
,COD_PRO_EVE                                        NUMBER(3)
,COD_COM_EVE                                        NUMBER(3)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,COD_EVE_PR                                         NUMBER(2)
,COD_FAM                                            NUMBER(7)
,RAPPORTO_PAR                                       VARCHAR2(2)
,COD_VIA                                            NUMBER(4)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,VIA_AIRE                                           VARCHAR2(100)
,COD_PRO_AIRE                                       NUMBER(3)
,COD_COM_AIRE                                       NUMBER(3)
,TITOLO_STUDIO                                      VARCHAR2(3)
,COD_PROF                                           NUMBER(5)
,ATTIVITA_PROF                                      NUMBER(1)
,POSIZIONE_PROF                                     NUMBER(1)
,DATA_REG                                           NUMBER(8)
,DATA_RIC                                           NUMBER(8)
,COD_PRO_RIC                                        NUMBER(3)
,COD_COM_RIC                                        NUMBER(3)
,ANNO_PRATICA_RIC                                   NUMBER(4)
,PRATICA_RIC                                        NUMBER(6)
,COD_VARIAZIONE                                     VARCHAR2(1)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,ZIPCODE                                            VARCHAR2(10)
,COD_PRO_ISCR_AIRE                                  NUMBER(3)
,COD_COM_ISCR_AIRE                                  NUMBER(3)
,PROVINCIA_CONTEA                                   VARCHAR2(60)
,PRESSO                                             VARCHAR2(60)
,SUB_INTERNO                                        VARCHAR2(3)
,CIVICO_ESTERNO                                     VARCHAR2(100)
,CIVICO_INTERNO                                     VARCHAR2(100)
,D_DATA_INIZIO                                      DATE
,D_DATA_EVE                                         DATE
,D_DATA_REG                                         DATE
,D_DATA_RIC                                         DATE
,COD_FAM_UNIQUE                                     VARCHAR2(20)
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
,ID                                                 NUMBER(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1ANAEVE ON ANAEVE (MATRICOLA, DATA_EVE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAEVE ON ANAEVE (ANNO_PRATICA, PRATICA, MATRICOLA, COD_EVE_PR, COD_MOV)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE INDEX IDX3ANAEVE ON ANAEVE (COD_MOV, COD_FAM, DATA_EVE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'CREATE INDEX IDX4ANAEVE ON ANAEVE (MATRICOLA, D_DATA_EVE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'CREATE INDEX IDX5ANAEVE ON ANAEVE (COD_MOV, COD_FAM, D_DATA_EVE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_6 >>
     w_sql := 'CREATE INDEX IDX6ANAEVE ON ANAEVE (COD_FAM_UNIQUE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk >>
     w_sql := 'CREATE UNIQUE INDEX ANAEVE_PK ON ANAEVE (ID)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anaeve_SQ nocache';

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
COMMENT ON TABLE ANAEVE IS 'Anagrafe - Archivio Eventi'
/
