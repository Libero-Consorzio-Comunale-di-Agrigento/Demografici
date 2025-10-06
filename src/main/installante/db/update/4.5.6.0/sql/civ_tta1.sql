--liquibase formatted sql
--changeset amonopoli:202303131437 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'civtta';
w_nome_col      varchar2(255) := 'COGNOME_3';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civtta
add 
(COGNOME_3                                          VARCHAR2(100)
,NOME_3                                             VARCHAR2(100)
,SESSO_3                                            VARCHAR2(1)
,COD_PRO_NAS_3                                      NUMBER(3)
,COD_COM_NAS_3                                      NUMBER(3)
,D_DATA_NAS_3                                       DATE
,COD_PRO_RES_3                                      NUMBER(3)
,COD_COM_RES_3                                      NUMBER(3)
,NAZIONALITA_3                                      VARCHAR2(3)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'civtta';
w_nome_col      varchar2(255) := 'COGNOME_4';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civtta
add 
(COGNOME_4                                          VARCHAR2(100)
,NOME_4                                             VARCHAR2(100)
,SESSO_4                                            VARCHAR2(1)
,COD_PRO_NAS_4                                      NUMBER(3)
,COD_COM_NAS_4                                      NUMBER(3)
,D_DATA_NAS_4                                       DATE
,COD_PRO_RES_4                                      NUMBER(3)
,COD_COM_RES_4                                      NUMBER(3)
,NAZIONALITA_4                                      VARCHAR2(3)
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

w_tipo_ogg	varchar2(255) := 'col';
w_nome_ogg	varchar2(255) := 'civtta';
w_nome_col      varchar2(255) := 'NUMERO_TESTIMONI';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civtta
add 
(NUMERO_TESTIMONI                                      NUMBER(1)
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
