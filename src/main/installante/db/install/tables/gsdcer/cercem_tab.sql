--liquibase formatted sql
--changeset amonopoli:202403041055_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'CERCEM';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE CERCEM
(DATA                                               NUMBER(8)
,ANNO_EMISSIONE                                     NUMBER(4)
,PROGR_EMISSIONE                                    NUMBER(7)
,COD_CERTIFICATO                                    VARCHAR2(3)
,COGNOME_NOME                                       VARCHAR2(100)
,SEGRETERIA                                         NUMBER(10,2)
,STATO_CIVILE                                       NUMBER(10,2)
,CARTA_IDENTITA                                     NUMBER(10,2)
,RIMBORSO_ST                                        NUMBER(10,2)
,BOLLO                                              NUMBER(10,2)
,TERMINALISTA                                       VARCHAR2(8)
,ANNULLAMENTO                                       VARCHAR2(2)
,FLAG_RICHIEDENTE                                   VARCHAR2(1)
,RICHIEDENTE                                        VARCHAR2(100)
,SESSO_RICHIEDENTE                                  VARCHAR2(1)
,DATA_NAS_RICHIEDENTE                               NUMBER(8)
,NAZIONALITA_RICHIEDENTE                            VARCHAR2(3)
,D_DATA_EMISSIONE                                   DATE
,D_DATA_NAS_RICHIEDENTE                             DATE
,COD_FISCALE_RICHIEDENTE                            VARCHAR2(16)
,COD_FISCALE_BENEFICIARIO                           VARCHAR2(16)
,TIPO_PAGAMENTO                                     VARCHAR2(1)
,MODALITA_RILASCIO                                  NUMBER(2)
,ID_PRATICA_SURF                                    NUMBER(10)
,DATA_STORICO                                       NUMBER(7)
,D_DATA_STORICO                                     DATE
,IMMAGINE_CERTIFICATO                               BLOB
,NOTE_RICHIEDENTE                                   VARCHAR2(4000)
,FLAG_ANPR                                          VARCHAR2(1)
,NOTE_ANNULLAMENTO                                  VARCHAR2(4000)
,COD_PRO_NAS_RICHIEDENTE                            NUMBER(3)
,COD_COM_NAS_RICHIEDENTE                            NUMBER(3)
,ID                                                 NUMBER(10)
,VERSION                                            NUMBER(20)
,COGNOME_RICHIEDENTE                                VARCHAR2(100)
,NOME_RICHIEDENTE                                   VARCHAR2(100)
,COGNOME_BENEFICIARIO                               VARCHAR2(100)
,NOME_BENEFICIARIO                                  VARCHAR2(100)
,D_DATA_NAS_BENEFICIARIO                            DATE
,SESSO_BENEFICIARIO                                 VARCHAR2(1)
,TIPO_DOC_RICHIEDENTE                               VARCHAR2(2)
,NUMERO_DOC_RICHIEDENTE                             VARCHAR2(16)
,D_DATA_RIL_DOC_RICHIEDENTE                         DATE
,ID_DOCUMENTO_GDM                                   NUMBER(10)
,ID_OGGETTO_FILE_GDM                                NUMBER(10)
,NOME_ALLEGATO                                      VARCHAR2(255)
,ALLEGATO_BLOB                                      BLOB
,UTENTE_ANNULLAMENTO                                VARCHAR2(8)
,D_DATA_ANNULLAMENTO                                DATE
,UTENTE_RIPRISTINO                                  VARCHAR2(8)
,D_DATA_RIPRISTINO                                  DATE
,COD_PRO_NAS_BENEFICIARIO                           NUMBER(3)
,COD_COM_NAS_BENEFICIARIO                           NUMBER(3)
,DES_MODALITA_RILASCIO_LIBERA                       VARCHAR2(400)
,FLAG_TERMINALISTA_IN_STAMPA                        VARCHAR2(1)
,NOME_TERMINALISTA                                  VARCHAR2(100)
,QUALIFICA_TERMINALISTA                             VARCHAR2(100)
,ID_CERDTR                                          NUMBER(2)
,ENTE_RICHIEDENTE                                   VARCHAR2(255)
,COD_PRO_ENTE_RICHIEDENTE                           NUMBER(3)
,COD_COM_ENTE_RICHIEDENTE                           NUMBER(3)
,ID_CONSOLATO_ANSC_RICHIEDENTE                      NUMBER(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1CERCEM ON CERCEM (DATA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE UNIQUE INDEX IDX2CERCEM ON CERCEM (ANNO_EMISSIONE, PROGR_EMISSIONE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE UNIQUE INDEX IDX3CERCEM ON CERCEM (ID)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'create index idx4cercem on cercem (cognome_richiedente, nome_richiedente)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'CREATE INDEX IDX5CERCEM ON CERCEM (D_DATA_EMISSIONE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence CERCEM_SQ nocache';

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
COMMENT ON TABLE CERCEM IS 'Certificazione - Certificati Emessi'
/
