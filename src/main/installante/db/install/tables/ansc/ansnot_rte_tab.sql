--liquibase formatted sql
--changeset amonopoli:202311131000 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ANSNOT_RTE';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'create table ANSNOT_RTE
(ID                                                 NUMBER(10)
,ID_SOGGETTO_ANSC                                   NUMBER(20)
,ID_ANSC                                            VARCHAR2(100)
,STATO                                              NUMBER(2)
,GENERE                                             NUMBER(2)
,VALIDO_DAL                                         DATE
,VALIDO_AL                                          DATE
,ID_COMUNE_COMPETENTE                               NUMBER(10)
,ID_COMUNE_FORMAZIONE                               NUMBER(10)
,ID_OPERAZIONE                                      NUMBER(10)
,COGNOME_SOGGETTO_ANSC                              VARCHAR2(255)
,NOME_SOGGETTO_ANSC                                 VARCHAR2(255)
)';

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
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'idx';
w_nome_ogg	varchar2(255) := 'ANSNOT_RTE_PK';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table ANSNOT_RTE
  add constraint ANSNOT_RTE_PK primary key (ID)
  using index';

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
comment on table ANSNOT_RTE is 'ANSC - Notifiche Totale per Rapporto di Test'
/

