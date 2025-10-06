--liquibase formatted sql
--changeset amonopoli:202503241000_34 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_parametri';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_parametri(
 parametro                       VARCHAR (30)        NOT NULL,
 no_prenotazione                 NUMBER (6,0)     NOT NULL,
 valore                          VARCHAR (240)       NULL,
 sequenza                        NUMBER (3,0)     NOT NULL,
 operatore                       VARCHAR (11)        NULL,
 tipo_valore                     VARCHAR (1)         NULL,
 operatore_logico                VARCHAR (3)         NULL,
 gruppo                          NUMBER (2,0)     NULL
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
     w_nome_ogg := 'PARA_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX PARA_PK ON A_PARAMETRI
(
      no_prenotazione ,
      parametro ,
      sequenza )';

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
COMMENT ON TABLE a_parametri
    IS 'Created from Entity PARAMETRO by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_parametri.parametro
    IS 'Codice del parametro fornito'
/
COMMENT ON COLUMN a_parametri.no_prenotazione
    IS 'Numero assegnato alla prenotazione'
/
COMMENT ON COLUMN a_parametri.valore
    IS 'Valore fornito al parametro'
/
COMMENT ON COLUMN a_parametri.sequenza
    IS 'Sequenza di definizione del parametro'
/
COMMENT ON COLUMN a_parametri.operatore
    IS 'Operatore di confronto in una espressione'
/
COMMENT ON COLUMN a_parametri.tipo_valore
    IS 'Significato del valore'
/
COMMENT ON COLUMN a_parametri.operatore_logico
    IS 'Operatore logico di legame  fra due espressioni'
/
COMMENT ON COLUMN a_parametri.gruppo
    IS 'Gruppo per la definizioni di espressioni fra parentesi'
/
