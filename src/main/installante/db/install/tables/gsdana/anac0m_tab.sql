--liquibase formatted sql
--changeset amonopoli:202606111120_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAC0M';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'CREATE TABLE ANAC0M 
(ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,MATRICOLA                                          NUMBER(7)
,PROTOCOLLO_AIRE                                    NUMBER(4)
,MATRICOLA_AIRE                                     VARCHAR2(12)
,ANNO_PROTOCOLLO_AIRE                               NUMBER(4)
,NUMERO_ORDINE                                      NUMBER(2)
,FLAG_SOGGETTO                                      VARCHAR2(1)
,NUOVO_RAPPORTO_PAR                                 VARCHAR2(2)
,NUOVA_SEQUENZA_PAR                                 NUMBER(2)
,ANNULLAMENTO                                       VARCHAR2(1)
,IST_RP                                             VARCHAR2(2)
,SESSO                                              VARCHAR2(1)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE INDEX IDX1ANAC0M ON ANAC0M (ANNO_PROTOCOLLO_AIRE, PROTOCOLLO_AIRE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'CREATE INDEX IDX2ANAC0M ON ANAC0M (ANNO_PRATICA, PRATICA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'CREATE INDEX IDX3ANAC0M ON ANAC0M (MATRICOLA))';

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
COMMENT ON TABLE ANAC0M IS 'Anagrafe - Matricole in AIRE/01 di Cancellazione'
/
