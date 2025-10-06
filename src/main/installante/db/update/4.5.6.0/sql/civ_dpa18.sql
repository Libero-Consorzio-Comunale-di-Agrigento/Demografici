--liquibase formatted sql
--changeset amonopoli:202303270920_1 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'civdpa';
w_nome_col      varchar2(255) := 'TIPO_COMPARENTE';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civdpa
add 
(TIPO_COMPARENTE	varchar2(20)
,TIPO_FIRMATARIO	varchar2(20)
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
comment on column civdpa.tipo_dichiarante is 'PD=PADRE - MD=MADRE - AL=ALTRO'
/
comment on column civdpa.tipo_comparente is 'PD=PADRE - MD=MADRE - PDMD=ENTRAMBI - AL=ALTRO'
/
comment on column civdpa.tipo_firmatario is 'PD=PADRE - MD=MADRE - PDMD=ENTRAMBI - AL=ALTRO'
/
