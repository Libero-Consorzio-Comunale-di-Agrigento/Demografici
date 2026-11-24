--liquibase formatted sql
--changeset snocca:202209261145_3 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'GTE_GSDDMO_RELAZIONI';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

<< tab >>
     w_sql := 'create table GTE_GSDDMO_RELAZIONI
(ID                                                 NUMBER(10)
,ID_CIVDCA                                          VARCHAR2(3)
,CODICE_CO                                          NUMBER(2)
,ID_CIVDET                                          NUMBER(19)
,ID_MODELLO                                         NUMBER(19)
,ID_CERDCE                                          VARCHAR2(3)
,ID_ANAMOD                                          VARCHAR2(10)
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_pk >>
     w_sql := 'alter table GTE_GSDDMO_RELAZIONI
  add constraint GTE_GSDDMO_RELAZIONI_PK primary key (ID)
  using index';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_dmo >>
     w_sql := 'alter table GTE_GSDDMO_RELAZIONI
  add constraint GTEDMOREL_GTEDMO_FK foreign key (ID_MODELLO)
  references GTE_GSDDMO (ID)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' (FK) non creato ('||SQLERRM||')');
     end;

     w_sql := 'create index GTEDMOREL_GTEDMO_FK on GTE_GSDDMO_RELAZIONI (ID_MODELLO)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_dca >>
     w_sql := 'create index GTEDMOREL_CIVDCA_FK on GTE_GSDDMO_RELAZIONI (ID_CIVDCA)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_dco >>
     w_sql := 'create index GTEDMOREL_CIVDCO_FK on GTE_GSDDMO_RELAZIONI (CODICE_CO)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_det >>
     w_sql := 'create index GTEDMOREL_CIVDET_FK on GTE_GSDDMO_RELAZIONI (ID_CIVDET)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_dce >>
     w_sql := 'create index GTEDMOREL_CERDCE_FK on GTE_GSDDMO_RELAZIONI (ID_CERDCE)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx_fk_mod >>
     w_sql := 'create index GTEDMOREL_ANAMOD_FK on GTE_GSDDMO_RELAZIONI (ID_ANAMOD)';

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
comment on table GTE_GSDDMO_RELAZIONI is 'Gestione Testi - Relazione Modelli / Comunicazioni'
/
