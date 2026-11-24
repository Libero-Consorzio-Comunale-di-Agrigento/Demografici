--liquibase formatted sql
--changeset amonopoli:202606091055_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANASAP';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table anasap
(ANAGRAFE                                           VARCHAR2(3)
,TIPO_EVENTO                                        VARCHAR2(1)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,SEQUENZA                                           NUMBER(2)
,EVENTO_PRATICA                                     NUMBER(2)
,DATA_EVENTO                                        NUMBER(8)
,DATA_RESTITUZIONE                                  NUMBER(8)
,ESITO                                              VARCHAR2(1)
,NOTE                                               VARCHAR2(2000)
,TERMINALISTA                                       VARCHAR2(8)
,DATA_REG                                           NUMBER(8)
,D_DATA_REG                                         DATE
,FLAG_ON_LINE                                       VARCHAR2(1)
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,D_DATA_EVENTO                                      DATE
,D_DATA_RESTITUZIONE                                DATE
,ID_ANATPR                                          NUMBER(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anasap on anasap (anagrafe, tipo_evento, anno_pratica, pratica, sequenza)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anasap_pk1 on anasap (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create index anasap_pk2 on anasap (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk3 >>
     w_sql := 'create index anasap_pk3 on anasap (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anasap_SQ nocache';

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
comment on table anasap is 'Anagrafe - Stato Avanzamento Pratiche'
/
