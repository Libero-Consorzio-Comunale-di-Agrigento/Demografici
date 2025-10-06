--liquibase formatted sql
--changeset amonopoli:202503241000_30 runOnChange:false stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  w_tipo_ogg := 'tab';
  w_nome_ogg := 'a_margini_stampa';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_margini_stampa(
 stampa                          VARCHAR (8)         NOT NULL,
 stampante                       VARCHAR (100)        NOT NULL,
 margine_top                     NUMBER (2,0)     NULL
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
COMMENT ON TABLE a_margini_stampa
    IS 'Created from Entity MARGINE STAMPA by A00 on 03-FEB-93'
/
COMMENT ON COLUMN a_margini_stampa.stampa
    IS 'Codice della stampa'
/
COMMENT ON COLUMN a_margini_stampa.stampante
    IS 'Codice della stampante'
/
COMMENT ON COLUMN a_margini_stampa.margine_top
    IS 'Margine in testa di stampa'
/
