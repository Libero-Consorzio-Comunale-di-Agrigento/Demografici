--liquibase formatted sql
--changeset amonopoli:202603231555_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ARCDNC';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table ARCDNC
(ELEMENTO                                           VARCHAR2(20)
,FLAG_ESTERNO                                       VARCHAR2(1)
,FLAG_INTERNO                                       VARCHAR2(1)
,SEQUENZA                                           NUMBER(2)
,SEPARATORE                                         VARCHAR2(10)
,FLAG_VISIBILE                                      VARCHAR2(1)
,COD_VIA                                            NUMBER(4)
,FLAG_DEFAULT                                       VARCHAR2(1)
,ID                                                 NUMBER(10)
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
     w_sql := 'create unique index idx1arcdnc on arcdnc (cod_via, elemento)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'create index idx2arcdnc on arcdnc (elemento)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'create index idx2arcdnc on arcdnc (cod_via)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk >>
     w_sql := 'create unique index arcdnc_pk on arcdnc (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence ARCDNC_SQ nocache';

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
comment on table arcdnc is 'Toponomastica - Defizione Numerazione Civica'
/
