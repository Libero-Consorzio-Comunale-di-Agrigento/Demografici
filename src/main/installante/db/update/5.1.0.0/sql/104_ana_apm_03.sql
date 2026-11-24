--liquibase formatted sql
--changeset amonopoli:202606091345_3 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'ANAAPM';
w_nome_col      varchar2(255) := 'FASCIA_RIPRISTINO';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'ALTER TABLE ANAAPM 
add
(FASCIA_RIPRISTINO                                  NUMBER(1)
,STATO_RIPRISTINO                                   NUMBER(2)
,COD_FAM_RIPRISTINO                                 NUMBER(7)
,RAPPORTO_PAR_RIPRISTINO                            VARCHAR2(2)
,SEQUENZA_PAR_RIPRISTINO                            NUMBER(2)
,D_DATA_INIZIO_FAM_RIPRISTINO                       DATE
,D_DATA_INIZIO_RES_RIPRISTINO                       DATE
,COD_FAM_UNIQUE_RIPRISTINO                          VARCHAR2(20)
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
