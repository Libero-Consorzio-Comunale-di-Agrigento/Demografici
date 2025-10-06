--liquibase formatted sql
--changeset amonopoli:202503241000_61 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
<< tab >>
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'a00_ref_codes';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a00_ref_codes  
(RV_LOW_VALUE                    VARCHAR (240)       NOT NULL,
 RV_HIGH_VALUE                   VARCHAR (240)       NULL,
 RV_ABBREVIATION                 VARCHAR (240)       NULL,
 RV_DOMAIN                       VARCHAR (100)       NOT NULL,
 RV_MEANING                      VARCHAR (240)       NULL,
 RV_TYPE                         VARCHAR (10)        NULL,
 RV_MEANING_AL1                  VARCHAR (240)       NULL,
 RV_MEANING_AL2                  VARCHAR (240)       NULL,
 RV_ABBREVIATION_AL1             VARCHAR (240)       NULL,
 RV_ABBREVIATION_AL2             VARCHAR (240)       NULL
)';

     begin
       execute immediate w_sql;
dbms_output.put_line('oggetto '||w_des_ogg||' creato');
     exception
       when others then
dbms_output.put_line('oggetto '||w_des_ogg||' non creato ('||SQLERRM||')');
     end;

<< idx >>
     w_tipo_ogg := 'idx';
     w_nome_ogg := 'X_A00_REF_CODES_1';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX X_A00_REF_CODES_1 ON A00_REF_CODES  
( RV_DOMAIN, 
  RV_LOW_VALUE )';

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

  elsif w_check_db = 1 then
dbms_output.put_line('oggetto '||w_des_ogg||' esistente');
  end if;
end;
/
