--liquibase formatted sql
--changeset amonopoli:202511211505_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANACOM';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table ANACOM
(COMUNICAZIONE                                      VARCHAR2(10)
,MATRICOLA                                          NUMBER(7)
,COGNOME_NOME                                       VARCHAR2(100)
,ANNO_PRATICA                                       NUMBER(4)
,PRATICA                                            NUMBER(4)
,COD_MOV                                            NUMBER(2)
,COD_EVE                                            NUMBER(2)
,DATA_REG                                           NUMBER(8)
,ANNO_PROGR                                         NUMBER(4)
,NUMERO_PROGR                                       NUMBER(7)
,ENTE_LP                                            NUMBER(2)
,NUMERO_COPIE                                       NUMBER(1)
,ID                                                 NUMBER(10)
,ANAGRAFE                                           VARCHAR2(3)
,TIPO_EVENTO                                        VARCHAR2(1)
,CODICE_CO                                          NUMBER(3)
,STAMPA_ESEGUITA                                    VARCHAR2(2)
,D_DATA_REG                                         DATE
,ID_DOCUMENTO_GDM                                   NUMBER(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_1 >>
     w_sql := 'create index idx1ANACOM on ANACOM (anno_progr, numero_progr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'create index idx2ANACOM on ANACOM (data_reg)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'create index idx3ANACOM on ANACOM (matricola)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'create index idx4ANACOM on ANACOM (anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'create index idx5ANACOM on ANACOM (comunicazione)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_6 >>
     w_sql := 'CREATE UNIQUE INDEX IDX6ANACOM ON ANACOM (ID)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_7 >>
     w_sql := 'create index idx7ANACOM on ANACOM (anagrafe, tipo_evento, anno_pratica, pratica)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_8 >>
     w_sql := 'create index idx8ANACOM on ANACOM (d_data_reg)';

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
comment on table ANACOM is 'Anagrafe - Comunicazioni da stampare'
/
