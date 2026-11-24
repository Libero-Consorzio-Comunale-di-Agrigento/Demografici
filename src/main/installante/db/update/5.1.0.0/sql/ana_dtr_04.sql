--liquibase formatted sql
--changeset amonopoli:202509101200 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANADTR';
w_nome_col      varchar2(255) := 'FLAG_NUMERO_TELEFONICO';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table anadtr add
(flag_numero_telefonico varchar2(1)
,flag_indirizzo         varchar2(1)
,flag_comune            varchar2(1)
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
update anadtr 
   set flag_numero_telefonico = 'S'
 where cod_tr in (1,2,4,5)
/
update anadtr 
   set flag_indirizzo = 'S'
 where cod_tr not in (1,2,4,5)
/
update anadtr 
   set flag_comune = 'S'
 where cod_tr in (7,8)
/
