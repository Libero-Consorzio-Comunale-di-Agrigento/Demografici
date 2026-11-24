--liquibase formatted sql
--changeset amonopoli:202606101425_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAFAM';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAFAM 
(FASCIA                                             NUMBER(1)
,COD_FAM                                            NUMBER(7)
,TIPO_FAM                                           NUMBER(1)
,COD_VIA                                            NUMBER(6)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,VIA_AIRE                                           VARCHAR2(100)
,COD_PRO_AIRE                                       NUMBER(3)
,COD_COM_AIRE                                       NUMBER(3)
,CONVIVENZA                                         VARCHAR2(60)
,INTESTATARIO                                       VARCHAR2(100)
,VIA_RES                                            VARCHAR2(100)
,COD_PRO_RES                                        NUMBER(3)
,COD_COM_RES                                        NUMBER(3)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,ZIPCODE                                            VARCHAR2(10)
,PROGR_ELIMINAZIONE                                 NUMBER(7)
,PROVINCIA_CONTEA                                   VARCHAR2(60)
,PRESSO                                             VARCHAR2(60)
,ID_DOCUMENTO_GDM                                   NUMBER(10)
,SUB_INTERNO                                        VARCHAR2(3)
,CIVICO_ESTERNO                                     VARCHAR2(100)
,CIVICO_INTERNO                                     VARCHAR2(100)
,TIPO_CONVIVENZA                                    NUMBER(2)
,DATA_ISTITUZIONE                                   NUMBER(8)
,MATRICOLA_INTESTATARIO                             NUMBER(7)
,DATA_INTESTATARIO                                  NUMBER(8)
,D_DATA_ISTITUZIONE                                 DATE
,D_DATA_INTESTATARIO                                DATE
,COGNOME_INTESTATARIO                               VARCHAR2(100)
,NOME_INTESTATARIO                                  VARCHAR2(100)
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
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE UNIQUE INDEX IDX1ANAFAM ON ANAFAM (FASCIA, COD_FAM)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAFAM ON ANAFAM (INTESTATARIO)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE INDEX IDX3ANAFAM ON ANAFAM (CONVIVENZA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'CREATE INDEX IDX4ANAFAM ON ANAFAM (COD_FAM)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'CREATE INDEX IDX5ANAFAM ON ANAFAM (COD_FAM_UNIQUE)';

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
COMMENT ON TABLE ANAFAM IS 'Anagrafe - Archivio Famiglie'
/
