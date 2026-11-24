--liquibase formatted sql
--changeset amonopoli:202606081630_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANATPR';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table anatpr
(ANAGRAFE                                           VARCHAR2(3)
,TIPO_EVENTO                                        VARCHAR2(1)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,DATA_PRATICA                                       NUMBER(8)
,COD_VARIAZIONE                                     VARCHAR2(1)
,MATRICOLA_DIC                                      NUMBER(7)
,COGNOME_NOME_DIC                                   VARCHAR2(100)
,COD_FAM_DIC                                        NUMBER(7)
,FLAG_PERFEZIONAMENTO                               VARCHAR2(1)
,FLAG_ANNULLAMENTO                                  VARCHAR2(1)
,TERMINALISTA                                       VARCHAR2(8)
,DATA_REG                                           NUMBER(8)
,ID_DOCUMENTO_GDM                                   NUMBER
,D_DATA_REG                                         DATE
,ID                                                 NUMBER(10)
,ID_PRATICA                                         VARCHAR2(20)
,D_DATA_PRATICA                                     DATE
,COGNOME_DIC                                        VARCHAR2(100)
,NOME_DIC                                           VARCHAR2(100)
,COD_FAM_UNIQUE_DIC                                 VARCHAR2(20)
,D_DATA_DECORRENZA                                  DATE
,INIZIATIVA                                         NUMBER(1)
,VERSION                                            NUMBER(20)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create unique index idx1anatpr on anatpr (anagrafe, tipo_evento, anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk1 >>
     w_sql := 'create unique index anatpr_pk1 on anatpr (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk2 >>
     w_sql := 'create unique index anatpr_pk2 on anatpr (id_pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anatpr_SQ nocache';

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
comment on table anatpr is 'Anagrafe - Testata Pratiche'
/
