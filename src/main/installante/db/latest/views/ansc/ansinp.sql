--liquibase formatted sql
--changeset amonopoli:202510311145_3 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'tab';
w_nome_ogg	varchar2(255) := 'ANSINP_ORIG';
w_nome_col      varchar2(255) := '';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'rename ansinp to ansinp_orig';

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
create or replace view ansinp
AS
select ar.stringa               parametro
     , ar.valore                valore
     , substr(ar.commento,1,20) descrizione
     , inp.allegato_blob        allegato_blob
     , inp.version              version
     , inp.flag_blob            flag_blob
     , inp.flag_visibile        flag_visibile
  from ansinp_orig inp
     , ad4_registro ar
 where inp.parametro = ar.stringa  
   and ar.chiave     = f_GSD_chiave_registro('ANSINP')
/
comment on table anpinp is 'ANSC - Parametri Applicativi da AD4_REGISTRO / ANSINP (view)'
/
