--liquibase formatted sql
--changeset amonopoli:202306011515 runOnChange:true stripComments:false
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'CIVDPA';
w_nome_col      varchar2(255) := 'RICONOSCIMENTO_PRE_COD_PRO';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_COD_PRO to RICONOSCIMENTO_PRE_COD_PRO_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_COD_COM to RICONOSCIMENTO_PRE_COD_COM_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_UFFICIO to RICONOSCIMENTO_PRE_UFFICIO_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_ANNO to RICONOSCIMENTO_PRE_ANNO_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_PARTE to RICONOSCIMENTO_PRE_PARTE_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_SERIE to RICONOSCIMENTO_PRE_SERIE_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column RICONOSCIMENTO_PRE_ATTO to RICONOSCIMENTO_PRE_ATTO_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

     w_sql := 'alter table civdpa rename column D_RICONOSCIMENTO_PRE_DATA to D_RICONOSCIMENTO_PRE_DATA_1';
     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' modificato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non modificato ('||SQLERRM||')');
     end;

  elsif w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');
  end if;
end;
/
declare
w_oracle_ver	varchar2(255) := f_GSD_versione_oracle();

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'CIVDPA';
w_nome_col      varchar2(255) := 'RICONOSCIMENTO_PRE_COD_PRO_1';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civdpa
add
(RICONOSCIMENTO_PRE_COD_PRO_1	NUMBER(3)
,RICONOSCIMENTO_PRE_COD_COM_1	NUMBER(3)
,RICONOSCIMENTO_PRE_UFFICIO_1	NUMBER(2)
,RICONOSCIMENTO_PRE_ANNO_1	NUMBER(4)
,RICONOSCIMENTO_PRE_PARTE_1	NUMBER(1)
,RICONOSCIMENTO_PRE_SERIE_1	VARCHAR2(1)
,RICONOSCIMENTO_PRE_ATTO_1	NUMBER(4)
,D_RICONOSCIMENTO_PRE_DATA_1	DATE
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

w_tipo_ogg	varchar2(255) := 'COL';
w_nome_ogg	varchar2(255) := 'CIVDPA';
w_nome_col      varchar2(255) := 'RICONOSCIMENTO_PRE_COD_PRO_2';

w_des_ogg       varchar2(255) := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
w_check_db	number := f_GSD_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'alter table civdpa
add
(RICONOSCIMENTO_PRE_COD_PRO_2	NUMBER(3)
,RICONOSCIMENTO_PRE_COD_COM_2	NUMBER(3)
,RICONOSCIMENTO_PRE_UFFICIO_2	NUMBER(2)
,RICONOSCIMENTO_PRE_ANNO_2	NUMBER(4)
,RICONOSCIMENTO_PRE_PARTE_2	NUMBER(1)
,RICONOSCIMENTO_PRE_SERIE_2	VARCHAR2(1)
,RICONOSCIMENTO_PRE_ATTO_2	NUMBER(4)
,D_RICONOSCIMENTO_PRE_DATA_2	DATE
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
