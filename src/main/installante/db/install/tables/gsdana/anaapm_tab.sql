--liquibase formatted sql
--changeset amonopoli:202606091245_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAAPM';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAAPM 
(ANNO_DIC                                           NUMBER(4)
,NUMERO_DIC                                         NUMBER(4)
,NUMERO_ORDINE                                      NUMBER(2)
,MATRICOLA                                          NUMBER(7)
,IST_RP                                             VARCHAR2(2)
,SESSO                                              VARCHAR2(1)
,IST_TS                                             NUMBER(2)
,IST_NP                                             NUMBER(2)
,ANNULLAMENTO                                       VARCHAR2(1)
,NUOVO_RAPPORTO_PAR                                 VARCHAR2(2)
,NUOVA_SEQUENZA_PAR                                 NUMBER(2)
,FLAG_SOGGETTO                                      VARCHAR2(1)
,RAPPORTO_PAR_PREC                                  VARCHAR2(2)
,SEQUENZA_PAR_PREC                                  NUMBER(2)
,ID                                                 NUMBER(10)
,ID_DICHIARAZIONE                                   VARCHAR2(20)
,ID_ANAAP4                                          NUMBER(10)
,ID_ANATPR                                          NUMBER(10)
,FASCIA_RIPRISTINO                                  NUMBER(1)
,STATO_RIPRISTINO                                   NUMBER(2)
,COD_FAM_RIPRISTINO                                 NUMBER(7)
,RAPPORTO_PAR_RIPRISTINO                            VARCHAR2(2)
,SEQUENZA_PAR_RIPRISTINO                            NUMBER(2)
,D_DATA_INIZIO_FAM_RIPRISTINO                       DATE
,D_DATA_INIZIO_RES_RIPRISTINO                       DATE
,COD_FAM_UNIQUE_RIPRISTINO                          VARCHAR2(20)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1ANAAPM ON ANAAPM (MATRICOLA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAAPM ON ANAAPM (ANNO_DIC, NUMERO_DIC)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anaapm_pk1 on anaapm (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create index anaapm_pk2 on anaapm (id_anaap4)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk3 >>
     w_sql := 'create index anaapm_pk3 on anaapm (id_dichiarazione)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk4 >>
     w_sql := 'create index anaapm_pk4 on anaapm (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anaapm_SQ nocache';

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
COMMENT ON TABLE ANAAPM IS 'Anagrafe - Individui in APR/4 di iscrizione'
/
