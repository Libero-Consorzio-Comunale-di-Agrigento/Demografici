--liquibase formatted sql
--changeset amonopoli:202606111115_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANACPM';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANACPM 
(ANNO_DIC                                           NUMBER(4)
,NUMERO_DIC                                         NUMBER(6)
,NUMERO_ORDINE                                      NUMBER(2)
,MATRICOLA                                          NUMBER(7)
,IST_RP                                             VARCHAR2(2)
,SESSO                                              VARCHAR2(1)
,IST_TS                                             NUMBER(2)
,IST_NP                                             NUMBER(2)
,ANNULLAMENTO                                       VARCHAR2(1)
,FLAG_SOGGETTO                                      VARCHAR2(1)
,NUOVO_RAPPORTO_PAR                                 VARCHAR2(2)
,NUOVA_SEQUENZA_PAR                                 NUMBER(2)
,FLAG_RIPRISTINO                                    VARCHAR2(1)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1ANACPM ON ANACPM (ANNO_DIC, NUMERO_DIC, MATRICOLA)';

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
COMMENT ON TABLE ANACPM IS 'Anagrafe - Individui in APR/4 di Cancellazione'
/
