--liquibase formatted sql
--changeset amonopoli:202606111040_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANACP4';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANACP4
(ANNO_DIC                                           NUMBER(4)
,NUMERO_DIC                                         NUMBER(6)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,DATA_PRATICA                                       NUMBER(8)
,CONTEGGIO                                          VARCHAR2(1)
,DATA_DECORRENZA                                    NUMBER(8)
,TIPO_RICHIESTA                                     VARCHAR2(1)
,COD_PRO_EVE                                        NUMBER(3)
,COD_COM_EVE                                        NUMBER(3)
,RICHIESTA                                          NUMBER(1)
,PROVVEDIMENTO                                      NUMBER(1)
,COD_STATO                                          NUMBER(3)
,DATA_IRREPERIBILITA                                NUMBER(8)
,DATA_DEFINIZIONE                                   NUMBER(8)
,SOTTOSCRITTO                                       NUMBER(2)
,FAMIGLIA_CONVIVENZA                                VARCHAR2(1)
,COD_VIA                                            NUMBER(4)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,DATA_REG                                           NUMBER(8)
,STATO_PRATICA                                      VARCHAR2(1)
,PRESSO                                             VARCHAR2(60)
,MOTIVO                                             VARCHAR2(30)
,COD_FAM_PROV                                       NUMBER(7)
,FLAG_INTERO_NUCLEO                                 VARCHAR2(1)
,INDIRIZZO_EMI                                      VARCHAR2(60)
,MATRICOLA_DIC                                      NUMBER(8)
,SUB_INTERNO                                        VARCHAR2(3)
,DATA_RIPRISTINO                                    NUMBER(8)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE UNIQUE INDEX IDX1ANACP4 ON ANACP4 (ANNO_DIC, NUMERO_DIC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANACP4 ON ANACP4 (ANNO_PRATICA, PRATICA)';

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
COMMENT ON TABLE ANACP4 IS 'Anagrafe - Testata Modello APR4 di Cancellazione'
/
