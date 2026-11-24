--liquibase formatted sql
--changeset amonopoli:202501311415_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAANA';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAANA 
(MATRICOLA                                          NUMBER(7)
,COGNOME_NOME                                       VARCHAR2(100)
,FASCIA                                             NUMBER(1)
,STATO                                              NUMBER(2)
,DATA_ULT_EVE                                       NUMBER(8)
,SOSPENSIONE                                        NUMBER(2)
,STATO_CIVILE                                       VARCHAR2(2)
,SESSO                                              VARCHAR2(1)
,NAZIONALITA                                        VARCHAR2(3)
,PATERNITA                                          VARCHAR2(100)
,MATERNITA                                          VARCHAR2(100)
,TITOLO_STUDIO                                      VARCHAR2(3)
,COD_PROF                                           NUMBER(5)
,ATTIVITA_PROF                                      NUMBER(1)
,POSIZIONE_PROF                                     NUMBER(1)
,PENSIONATO                                         NUMBER(1)
,COD_FAM                                            NUMBER(7)
,RAPPORTO_PAR                                       VARCHAR2(2)
,SEQUENZA_PAR                                       NUMBER(2)
,DATA_INIZIO_FAM                                    NUMBER(8)
,DATA_INIZIO_RES                                    NUMBER(8)
,COGNOME_NOME_CN                                    VARCHAR2(100)
,MATRICOLA_CN                                       NUMBER(7)
,ANNO_CENS                                          NUMBER(4)
,SEZIONE_CENS                                       NUMBER(4)
,FOGLIO_CENS                                        NUMBER(4)
,COD_PRO_NAS                                        NUMBER(3)
,COD_COM_NAS                                        NUMBER(3)
,DATA_NAS                                           NUMBER(8)
,COD_PRO_ATTO_NAS                                   NUMBER(3)
,COD_COM_ATTO_NAS                                   NUMBER(3)
,ANNO_ATTO_NAS                                      NUMBER(4)
,ATTO_NAS                                           NUMBER(4)
,PARTE_NAS                                          NUMBER(1)
,SERIE_NAS                                          VARCHAR2(1)
,UFFICIO_NAS                                        NUMBER(2)
,ANNO_ATTO_NAS_TR                                   NUMBER(4)
,ATTO_NAS_TR                                        NUMBER(4)
,PARTE_NAS_TR                                       NUMBER(1)
,SERIE_NAS_TR                                       VARCHAR2(1)
,UFFICIO_NAS_TR                                     NUMBER(2)
,COD_PRO_MAT                                        NUMBER(3)
,COD_COM_MAT                                        NUMBER(3)
,DATA_MAT                                           NUMBER(8)
,ANNO_ATTO_MAT                                      NUMBER(4)
,ATTO_MAT                                           NUMBER(4)
,PARTE_MAT                                          NUMBER(1)
,SERIE_MAT                                          VARCHAR2(1)
,UFFICIO_MAT                                        NUMBER(2)
,ANNO_ATTO_MAT_TR                                   NUMBER(4)
,ATTO_MAT_TR                                        NUMBER(4)
,PARTE_MAT_TR                                       NUMBER(1)
,SERIE_MAT_TR                                       VARCHAR2(1)
,UFFICIO_MAT_TR                                     NUMBER(2)
,DATA_MOR                                           NUMBER(8)
,COD_PRO_MOR                                        NUMBER(3)
,COD_COM_MOR                                        NUMBER(3)
,ANNO_ATTO_MOR                                      NUMBER(4)
,ATTO_MOR                                           NUMBER(4)
,PARTE_MOR                                          NUMBER(1)
,SERIE_MOR                                          VARCHAR2(1)
,UFFICIO_MOR                                        NUMBER(2)
,ANNO_ATTO_MOR_TR                                   NUMBER(4)
,ATTO_MOR_TR                                        NUMBER(4)
,PARTE_MOR_TR                                       NUMBER(1)
,SERIE_MOR_TR                                       VARCHAR2(5)
,UFFICIO_MOR_TR                                     NUMBER(2)
,COD_PRO_VED                                        NUMBER(3)
,COD_COM_VED                                        NUMBER(3)
,DATA_VED                                           NUMBER(8)
,ANNO_ATTO_VED                                      NUMBER(4)
,ATTO_VED                                           NUMBER(4)
,PARTE_VED                                          NUMBER(1)
,SERIE_VED                                          VARCHAR2(1)
,UFFICIO_VED                                        NUMBER(2)
,COD_FISCALE                                        VARCHAR2(16)
,DATA_REG                                           NUMBER(8)
,ANNO_NAS                                           VARCHAR2(1)
,COD_PRO_DIV                                        NUMBER(3)
,COD_COM_DIV                                        NUMBER(3)
,DATA_DIV                                           NUMBER(8)
,ANNO_ATTO_DIV                                      NUMBER(4)
,ATTO_DIV                                           NUMBER(4)
,PARTE_DIV                                          NUMBER(1)
,SERIE_DIV                                          VARCHAR2(1)
,UFFICIO_DIV                                        NUMBER(2)
,MATRICOLA_AIRE                                     VARCHAR2(12)
,CF_CALCOLATO                                       VARCHAR2(1)
,VAL_ESPATRIO                                       VARCHAR2(1)
,COD_PRO_ATTO_MAT                                   NUMBER(3)
,COD_COM_ATTO_MAT                                   NUMBER(3)
,COD_PRO_ATTO_VED                                   NUMBER(3)
,COD_COM_ATTO_VED                                   NUMBER(3)
,COD_PRO_ATTO_MOR                                   NUMBER(3)
,COD_COM_ATTO_MOR                                   NUMBER(3)
,NOTE                                               VARCHAR2(2000)
,ANNO_MAT                                           VARCHAR2(1)
,COD_EDIFICIO_CENS                                  NUMBER(4)
,COD_PRO_ATTO_DIV                                   NUMBER(3)
,COD_COM_ATTO_DIV                                   NUMBER(3)
,DATA_DIV_GIU                                       NUMBER(8)
,DATA_DIV_ANN                                       NUMBER(8)
,COGNOME_NOME_RIC                                   VARCHAR2(100)
,DATA_VAL_ESPATRIO                                  NUMBER(8)
,ID_DOCUMENTO_GDM                                   NUMBER(10)
,MATRICOLA_PD                                       NUMBER(7)
,MATRICOLA_MD                                       NUMBER(7)
,DATA_INIZIO_NAZ                                    NUMBER(8)
,QUESTIONARIO_CENS                                  NUMBER(7)
,ATTO_NAS_DIGITALE                                  VARCHAR2(100)
,ATTO_NAS_TR_DIGITALE                               VARCHAR2(100)
,ATTO_MAT_DIGITALE                                  VARCHAR2(100)
,ATTO_MAT_TR_DIGITALE                               VARCHAR2(100)
,ATTO_DIV_DIGITALE                                  VARCHAR2(100)
,ATTO_VED_DIGITALE                                  VARCHAR2(100)
,ATTO_MOR_DIGITALE                                  VARCHAR2(100)
,ATTO_MOR_TR_DIGITALE                               VARCHAR2(100)
,COGNOME                                            VARCHAR2(100)
,NOME                                               VARCHAR2(100)
,D_DATA_NAS                                         DATE
,COGNOME_RIC                                        VARCHAR2(100)
,NOME_RIC                                           VARCHAR2(100)
,D_DATA_ULT_EVE                                     DATE
,D_DATA_INIZIO_FAM                                  DATE
,D_DATA_INIZIO_RES                                  DATE
,D_DATA_MAT                                         DATE
,D_DATA_MOR                                         DATE
,D_DATA_VED                                         DATE
,D_DATA_DIV                                         DATE
,D_DATA_DIV_GIU                                     DATE
,D_DATA_DIV_ANN                                     DATE
,D_DATA_VAL_ESPATRIO                                DATE
,D_DATA_INIZIO_NAZ                                  DATE
,D_DATA_REG                                         DATE
,COGNOME_PD                                         VARCHAR2(100)
,NOME_PD                                            VARCHAR2(100)
,COGNOME_MD                                         VARCHAR2(100)
,NOME_MD                                            VARCHAR2(100)
,COGNOME_CN                                         VARCHAR2(100)
,NOME_CN                                            VARCHAR2(100)
,COD_FAM_UNIQUE                                     VARCHAR2(20)
,SENZA_COGNOME                                      VARCHAR2(1)
,SENZA_NOME                                         VARCHAR2(1)
,SENZA_COGNOME_PD                                   VARCHAR2(1)
,SENZA_NOME_PD                                      VARCHAR2(1)
,SENZA_COGNOME_MD                                   VARCHAR2(1)
,SENZA_NOME_MD                                      VARCHAR2(1)
,SENZA_COGNOME_CN                                   VARCHAR2(1)
,SENZA_NOME_CN                                      VARCHAR2(1)
,MESE_ANNO_NAS                                      VARCHAR2(1)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE UNIQUE INDEX IDX1ANAANA ON ANAANA (MATRICOLA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAANA ON ANAANA (COGNOME_NOME)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE INDEX IDX3ANAANA ON ANAANA (FASCIA, COD_FAM, SEQUENZA_PAR, DATA_NAS)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'CREATE INDEX IDX4ANAANA ON ANAANA (ANNO_CENS, SEZIONE_CENS, FOGLIO_CENS)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'CREATE INDEX IDX5ANAANA ON ANAANA (COD_FISCALE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_6 >>
     w_sql := 'CREATE INDEX IDX6ANAANA ON ANAANA (MATRICOLA_AIRE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_7 >>
     w_sql := 'CREATE INDEX IDX7ANAANA ON ANAANA (COGNOME_NOME_RIC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_8 >>
     w_sql := 'CREATE INDEX IDX8ANAANA ON ANAANA (DATA_NAS)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_9 >>
     w_sql := 'CREATE INDEX IDX9ANAANA ON ANAANA (STATO_CIVILE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_10 >>
     w_sql := 'CREATE INDEX IDX10ANAANA ON ANAANA (COGNOME, NOME)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_11 >>
     w_sql := 'CREATE INDEX IDX11ANAANA ON ANAANA (D_DATA_NAS)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_12 >>
     w_sql := 'CREATE INDEX IDX12ANAANA ON ANAANA (COGNOME_RIC, NOME_RIC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_13 >>
     w_sql := 'CREATE INDEX IDX13ANAANA ON ANAANA (COD_FAM_UNIQUE)';

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
COMMENT ON TABLE ANAANA IS 'Anagrafe - Archivio Anagrafe'
/
