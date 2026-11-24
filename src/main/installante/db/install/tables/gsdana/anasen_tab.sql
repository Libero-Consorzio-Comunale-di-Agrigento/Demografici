--liquibase formatted sql
--changeset amonopoli:202511051240_0 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'TAB';
w_nome_ogg	varchar2(255) := 'ANASEN';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table anasen
(MATRICOLA                                          NUMBER(7)
,ROWID_MOV                                          VARCHAR2(20)
,ANNO_PROGR_MOV                                     NUMBER(4)
,NUMERO_PROGR_MOV                                   NUMBER(7)
,TIPO_SENTENZA                                      NUMBER(2)
,COD_PRO_TRIB                                       NUMBER(3)
,COD_COM_TRIB                                       NUMBER(3)
,DATA_DECRETO                                       NUMBER(8)
,NUMERO_DECRETO                                     VARCHAR2(10)
,COD_PRO_ATTO_TR                                    NUMBER(3)
,COD_COM_ATTO_TR                                    NUMBER(3)
,DATA_ATTO_TR                                       NUMBER(8)
,ANNO_ATTO_TR                                       NUMBER(4)
,ATTO_TR                                            NUMBER(4)
,PARTE_ATTO_TR                                      NUMBER(1)
,SERIE_ATTO_TR                                      VARCHAR2(1)
,UFFICIO_ATTO_TR                                    NUMBER(2)
,PRIVACY                                            VARCHAR2(1)
,TIPO_PROVVEDIMENTO                                 NUMBER(2)
,ENTE_PROVVEDIMENTO                                 NUMBER(2)
,AUTORE_PROVVEDIMENTO                               VARCHAR2(100)
,ATTO_TR_DIGITALE                                   VARCHAR2(100)
,ID                                                 NUMBER(10)
,D_DATA_DECRETO                                     DATE
,D_DATA_ATTO_TR                                     DATE
,ID_ANAMOV                                          NUMBER(10)
,ANAGRAFE_TPR                                       VARCHAR2(3)
,TIPO_EVENTO_TPR                                    VARCHAR2(1)
,ANNO_PRATICA_TPR                                   NUMBER(4)
,PRATICA_TPR                                        NUMBER(4)
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
     w_sql := 'create index idx1anasen on anasen (matricola)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_2 >>
     w_sql := 'create index idx2anasen on anasen (rowid_mov)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_3 >>
     w_sql := 'create index idx3anasen on anasen (anno_progr_mov, numero_progr_mov)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_4 >>
     w_sql := 'create index idx4anasen on anasen (id_anamov)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_5 >>
     w_sql := 'create index idx5anasen on anasen (id_anatpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_6 >>
     w_sql := 'create index idx6anasen on anasen (anagrafe_tpr, tipo_evento_tpr, anno_pratica_tpr, pratica_tpr)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk >>
     w_sql := 'create unique index idx1anasen_pk on anasen (id)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< seq >>
     w_sql := 'create sequence anasen_SQ nocache';

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
comment on table anasen is 'Anagrafe - Provvedimenti / Sentenze dell''Individuo'
/
