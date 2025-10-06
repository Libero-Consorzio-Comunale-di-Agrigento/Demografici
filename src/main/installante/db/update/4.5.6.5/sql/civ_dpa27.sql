--liquibase formatted sql
--changeset snocca:202307271117 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'CIVDPA';
w_nome_col      varchar2(255) := 'FINE_OPPOSIZIONE_TIPO_DOC';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civdpa
add
(FINE_OPPOSIZIONE_TIPO_DOC               VARCHAR2(2)
,D_FINE_OPPOSIZIONE_DATA_DOC             DATE
,FINE_OPPOSIZIONE_ESTREMI_DOC            VARCHAR2(20)
,FINE_OPPOSIZIONE_ENTE                   VARCHAR2(255)
,FINE_OPPOSIZIONE_COD_COM		             NUMBER(3)
,FINE_OPPOSIZIONE_COD_PRO		             NUMBER(3)
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