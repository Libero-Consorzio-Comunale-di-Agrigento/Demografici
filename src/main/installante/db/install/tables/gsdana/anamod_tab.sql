--liquibase formatted sql
--changeset amonopoli:202511261130_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANAMOD';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table anamod
(COD_MODELLO                                        VARCHAR2(4)
,DESCRIZIONE                                        VARCHAR2(100)
,NOTE                                               VARCHAR2(2000)
,TIPO_MODELLO                                       VARCHAR2(1)
,FLAG_WEGO                                          VARCHAR2(1)
,QUERY_WEGO                                         NUMBER
,TYPE_WEGO                                          VARCHAR2(10)
,FLAG_APR4_ALLEGATO                                 VARCHAR2(1)
,ID                                                 VARCHAR2(10)
,VERSION                                            NUMBER(20)
,D_DATA_ULT_AGG                                     DATE
,TERMINALISTA                                       VARCHAR2(8)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'CREATE UNIQUE INDEX IDX1ANAMOD ON ANAMOD (COD_MODELLO, TIPO_MODELLO)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk >>
     w_sql := 'create unique index anamod_pk on anamod (id)';

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
comment on table anamod is 'Anagrafe - Archivio Modelli'
/
