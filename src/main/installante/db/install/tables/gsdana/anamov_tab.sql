--liquibase formatted sql
--changeset amonopoli:202606101435_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAMOV';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAMOV 
(MATRICOLA                                          NUMBER(7)
,COD_MOV                                            NUMBER(2)
,COD_EVE                                            NUMBER(2)
,DATA_EVE                                           NUMBER(8)
,COD_PRO_EVE                                        NUMBER(3)
,COD_COM_EVE                                        NUMBER(3)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,NUCLEO_PARTENZA                                    NUMBER(1)
,NUCLEO_ARRIVO                                      NUMBER(1)
,COGNOME_NOME_PREC                                  VARCHAR2(100)
,STATO_CIVILE_PREC                                  VARCHAR2(2)
,SESSO_PREC                                         VARCHAR2(1)
,NAZIONALITA_PREC                                   VARCHAR2(3)
,PATERNITA_PREC                                     VARCHAR2(60)
,MATERNITA_PREC                                     VARCHAR2(60)
,TITOLO_STUDIO_PREC                                 VARCHAR2(3)
,COD_PROF_PREC                                      NUMBER(5)
,ATTIVITA_PROF_PREC                                 NUMBER(1)
,POSIZIONE_PROF_PREC                                NUMBER(1)
,PENSIONATO_PREC                                    VARCHAR2(1)
,COD_FAM_PREC                                       NUMBER(7)
,INTESTATARIO_PREC                                  VARCHAR2(100)
,RAPPORTO_PAR_PREC                                  VARCHAR2(2)
,COD_VIA_PREC                                       NUMBER(4)
,NUM_CIV_PREC                                       NUMBER(6)
,SUFFISSO_PREC                                      VARCHAR2(10)
,INTERNO_PREC                                       NUMBER(4)
,VIA_AIRE_PREC                                      VARCHAR2(100)
,COD_PRO_AIRE_PREC                                  NUMBER(3)
,COD_COM_AIRE_PREC                                  NUMBER(3)
,COGNOME_NOME_CN_PREC                               VARCHAR2(100)
,MATRICOLA_CN_PREC                                  NUMBER(7)
,ANNO_CENS_PREC                                     NUMBER(4)
,SEZIONE_CENS_PREC                                  NUMBER(4)
,FOGLIO_CENS_PREC                                   NUMBER(4)
,COD_PRO_NAS_PREC                                   NUMBER(3)
,COD_COM_NAS_PREC                                   NUMBER(3)
,DATA_NAS_PREC                                      NUMBER(8)
,COD_PRO_ATTO_NAS_PREC                              NUMBER(3)
,COD_COM_ATTO_NAS_PREC                              NUMBER(3)
,ANNO_ATTO_NAS_PREC                                 NUMBER(4)
,ATTO_NAS_PREC                                      NUMBER(4)
,PARTE_NAS_PREC                                     NUMBER(1)
,SERIE_NAS_PREC                                     VARCHAR2(1)
,UFFICIO_NAS_PREC                                   NUMBER(2)
,ANNO_ATTO_NAS_TR_PREC                              NUMBER(4)
,ATTO_NAS_TR_PREC                                   NUMBER(4)
,PARTE_NAS_TR_PREC                                  NUMBER(1)
,SERIE_NAS_TR_PREC                                  VARCHAR2(1)
,UFFICIO_NAS_TR_PREC                                NUMBER(2)
,COD_PRO_MAT_PREC                                   NUMBER(3)
,COD_COM_MAT_PREC                                   NUMBER(3)
,DATA_MAT_PREC                                      NUMBER(8)
,ANNO_ATTO_MAT_PREC                                 NUMBER(4)
,ATTO_MAT_PREC                                      NUMBER(4)
,PARTE_MAT_PREC                                     NUMBER(1)
,SERIE_MAT_PREC                                     VARCHAR2(1)
,UFFICIO_MAT_PREC                                   NUMBER(2)
,ANNO_ATTO_MAT_TR_PREC                              NUMBER(4)
,ATTO_MAT_TR_PREC                                   NUMBER(4)
,PARTE_MAT_TR_PREC                                  NUMBER(1)
,SERIE_MAT_TR_PREC                                  VARCHAR2(1)
,UFFICIO_MAT_TR_PREC                                NUMBER(2)
,COD_PRO_MOR_PREC                                   NUMBER(3)
,COD_COM_MOR_PREC                                   NUMBER(3)
,DATA_MOR_PREC                                      NUMBER(8)
,ANNO_ATTO_MOR_PREC                                 NUMBER(4)
,ATTO_MOR_PREC                                      NUMBER(4)
,PARTE_MOR_PREC                                     NUMBER(1)
,SERIE_MOR_PREC                                     VARCHAR2(1)
,UFFICIO_MOR_PREC                                   NUMBER(2)
,ANNO_ATTO_MOR_TR_PREC                              NUMBER(4)
,ATTO_MOR_TR_PREC                                   NUMBER(4)
,PARTE_MOR_TR_PREC                                  NUMBER(1)
,SERIE_MOR_TR_PREC                                  VARCHAR2(5)
,UFFICIO_MOR_TR_PREC                                NUMBER(2)
,COD_PRO_VED_PREC                                   NUMBER(3)
,COD_COM_VED_PREC                                   NUMBER(3)
,DATA_VED_PREC                                      NUMBER(8)
,ANNO_ATTO_VED_PREC                                 NUMBER(4)
,ATTO_VED_PREC                                      NUMBER(4)
,PARTE_VED_PREC                                     NUMBER(1)
,SERIE_VED_PREC                                     VARCHAR2(1)
,UFFICIO_VED_PREC                                   NUMBER(2)
,COD_FISCALE_PREC                                   VARCHAR2(16)
,COGNOME_NOME                                       VARCHAR2(100)
,STATO_CIVILE                                       VARCHAR2(2)
,SESSO                                              VARCHAR2(1)
,NAZIONALITA                                        VARCHAR2(3)
,PATERNITA                                          VARCHAR2(60)
,MATERNITA                                          VARCHAR2(60)
,TITOLO_STUDIO                                      VARCHAR2(3)
,COD_PROF                                           NUMBER(5)
,ATTIVITA_PROF                                      NUMBER(1)
,POSIZIONE_PROF                                     NUMBER(1)
,PENSIONATO                                         VARCHAR2(1)
,COD_FAM                                            NUMBER(7)
,INTESTATARIO                                       VARCHAR2(100)
,RAPPORTO_PAR                                       VARCHAR2(2)
,DATA_INIZIO_FAM                                    NUMBER(8)
,COD_VIA                                            NUMBER(4)
,NUM_CIV                                            NUMBER(6)
,SUFFISSO                                           VARCHAR2(10)
,INTERNO                                            NUMBER(4)
,VIA_AIRE                                           VARCHAR2(100)
,COD_PRO_AIRE                                       NUMBER(3)
,COD_COM_AIRE                                       NUMBER(3)
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
,COD_PRO_MOR                                        NUMBER(3)
,COD_COM_MOR                                        NUMBER(3)
,DATA_MOR                                           NUMBER(8)
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
,TERMINALISTA                                       VARCHAR2(8)
,ELETTORALE                                         VARCHAR2(2)
,ANNULLAMENTO                                       VARCHAR2(2)
,ANNO_PROGR                                         NUMBER(4)
,NUMERO_PROGR                                       NUMBER(7)
,COD_PRO_DIV_PREC                                   NUMBER(3)
,COD_COM_DIV_PREC                                   NUMBER(3)
,DATA_DIV_PREC                                      NUMBER(8)
,ANNO_ATTO_DIV_PREC                                 NUMBER(4)
,ATTO_DIV_PREC                                      NUMBER(4)
,PARTE_DIV_PREC                                     NUMBER(1)
,SERIE_DIV_PREC                                     VARCHAR2(1)
,UFFICIO_DIV_PREC                                   NUMBER(2)
,COD_PRO_DIV                                        NUMBER(3)
,COD_COM_DIV                                        NUMBER(3)
,DATA_DIV                                           NUMBER(8)
,ANNO_ATTO_DIV                                      NUMBER(4)
,ATTO_DIV                                           NUMBER(4)
,PARTE_DIV                                          NUMBER(1)
,SERIE_DIV                                          VARCHAR2(1)
,UFFICIO_DIV                                        NUMBER(2)
,MATRICOLA_AIRE_PREC                                VARCHAR2(12)
,MATRICOLA_AIRE                                     VARCHAR2(12)
,COD_PRO_ATTO_MAT_PREC                              NUMBER(3)
,COD_COM_ATTO_MAT_PREC                              NUMBER(3)
,COD_PRO_ATTO_VED_PREC                              NUMBER(3)
,COD_COM_ATTO_VED_PREC                              NUMBER(3)
,COD_PRO_ATTO_MOR_PREC                              NUMBER(3)
,COD_COM_ATTO_MOR_PREC                              NUMBER(3)
,COD_PRO_ATTO_MAT                                   NUMBER(3)
,COD_COM_ATTO_MAT                                   NUMBER(3)
,COD_PRO_ATTO_VED                                   NUMBER(3)
,COD_COM_ATTO_VED                                   NUMBER(3)
,COD_PRO_ATTO_MOR                                   NUMBER(3)
,COD_COM_ATTO_MOR                                   NUMBER(3)
,CF_CALCOLATO_PREC                                  VARCHAR2(1)
,CF_CALCOLATO                                       VARCHAR2(1)
,COD_VARIAZIONE                                     VARCHAR2(1)
,SCALA_PREC                                         VARCHAR2(3)
,PIANO_PREC                                         VARCHAR2(3)
,ZIPCODE_PREC                                       VARCHAR2(10)
,SCALA                                              VARCHAR2(3)
,PIANO                                              VARCHAR2(3)
,ZIPCODE                                            VARCHAR2(10)
,COD_EDIFICIO_CENS_PREC                             NUMBER(4)
,COD_EDIFICIO_CENS                                  NUMBER(4)
,NO_CONTEGGIO                                       VARCHAR2(1)
,COD_PRO_ATTO_DIV                                   NUMBER(3)
,COD_COM_ATTO_DIV                                   NUMBER(3)
,DATA_DIV_GIU                                       NUMBER(8)
,DATA_DIV_ANN                                       NUMBER(8)
,COD_PRO_ATTO_DIV_PREC                              NUMBER(3)
,COD_COM_ATTO_DIV_PREC                              NUMBER(3)
,DATA_DIV_GIU_PREC                                  NUMBER(8)
,DATA_DIV_ANN_PREC                                  NUMBER(8)
,COD_PRO_ISCR_AIRE                                  NUMBER(3)
,COD_COM_ISCR_AIRE                                  NUMBER(3)
,PROVINCIA_CONTEA_PREC                              VARCHAR2(60)
,PRESSO_PREC                                        VARCHAR2(60)
,PROVINCIA_CONTEA                                   VARCHAR2(60)
,PRESSO                                             VARCHAR2(60)
,ANNO_NAS_PREC                                      VARCHAR2(1)
,ANNO_MAT_PREC                                      VARCHAR2(1)
,ANNO_NAS                                           VARCHAR2(1)
,ANNO_MAT                                           VARCHAR2(1)
,SUB_INTERNO                                        VARCHAR2(3)
,CIVICO_ESTERNO                                     VARCHAR2(100)
,CIVICO_INTERNO                                     VARCHAR2(100)
,SUB_INTERNO_PREC                                   VARCHAR2(3)
,CIVICO_ESTERNO_PREC                                VARCHAR2(100)
,CIVICO_INTERNO_PREC                                VARCHAR2(100)
,MATRICOLA_PD_PREC                                  NUMBER(7)
,MATRICOLA_MD_PREC                                  NUMBER(7)
,MATRICOLA_PD                                       NUMBER(7)
,MATRICOLA_MD                                       NUMBER(7)
,DATA_INIZIO_NAZ                                    NUMBER(8)
,DATA_INIZIO_NAZ_PREC                               NUMBER(8)
,NO_VANA                                            VARCHAR2(1)
,ATTO_NAS_DIGITALE_PREC                             VARCHAR2(100)
,ATTO_NAS_TR_DIGITALE_PREC                          VARCHAR2(100)
,ATTO_MAT_DIGITALE_PREC                             VARCHAR2(100)
,ATTO_MAT_TR_DIGITALE_PREC                          VARCHAR2(100)
,ATTO_DIV_DIGITALE_PREC                             VARCHAR2(100)
,ATTO_VED_DIGITALE_PREC                             VARCHAR2(100)
,ATTO_MOR_DIGITALE_PREC                             VARCHAR2(100)
,ATTO_MOR_TR_DIGITALE_PREC                          VARCHAR2(100)
,ATTO_NAS_DIGITALE                                  VARCHAR2(100)
,ATTO_NAS_TR_DIGITALE                               VARCHAR2(100)
,ATTO_MAT_DIGITALE                                  VARCHAR2(100)
,ATTO_MAT_TR_DIGITALE                               VARCHAR2(100)
,ATTO_DIV_DIGITALE                                  VARCHAR2(100)
,ATTO_VED_DIGITALE                                  VARCHAR2(100)
,ATTO_MOR_DIGITALE                                  VARCHAR2(100)
,ATTO_MOR_TR_DIGITALE                               VARCHAR2(100)
,FLAG_METRICO_PREC                                  VARCHAR2(1)
,PROGR_SNC_PREC                                     VARCHAR2(10)
,FLAG_LETTERA_PREC                                  VARCHAR2(1)
,FLAG_ESPONENTE_PREC                                VARCHAR2(1)
,FLAG_NUI_PREC                                      VARCHAR2(1)
,NUI_PREC                                           VARCHAR2(10)
,COLORE_PREC                                        VARCHAR2(10)
,CORTE_PREC                                         VARCHAR2(10)
,INTERNO2_PREC                                      NUMBER(4)
,SUB_INTERNO2_PREC                                  VARCHAR2(3)
,SECONDARIO_PREC                                    VARCHAR2(10)
,SCALA_ESTERNA_PREC                                 VARCHAR2(10)
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
     w_sql := 'CREATE INDEX IDX1ANAMOV ON ANAMOV (DATA_REG)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE UNIQUE INDEX IDX2ANAMOV ON ANAMOV (ANNO_PROGR, NUMERO_PROGR)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE INDEX IDX3ANAMOV ON ANAMOV (MATRICOLA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'CREATE INDEX IDX4ANAMOV ON ANAMOV (ANNO_CENS_PREC, SEZIONE_CENS_PREC, FOGLIO_CENS_PREC, COD_EDIFICIO_CENS_PREC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'CREATE INDEX IDX5ANAMOV ON ANAMOV (COD_FAM_PREC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_6 >>
     w_sql := 'CREATE INDEX IDX6ANAMOV ON ANAMOV (COD_FAM)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_7 >>
     w_sql := 'CREATE INDEX IDX7ANAMOV ON ANAMOV (COD_MOV, COD_EVE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_8 >>
     w_sql := 'CREATE INDEX IDX8ANAMOV ON ANAMOV (ANNO_PRATICA, PRATICA)';

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
COMMENT ON TABLE ANAMOV IS 'Anagrafe - Archivio Movimenti'
/
