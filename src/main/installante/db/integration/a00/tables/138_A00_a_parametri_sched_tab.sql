--liquibase formatted sql
--changeset amonopoli:202503241000_38 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_parametri_sched';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_parametri_sched(
 intervallo_lavoro               NUMBER (3,0)     NOT NULL,
 parallelismo                    NUMBER (1,0)     NOT NULL,
 processi                        NUMBER (1,0)     NOT NULL,
 prenotazione                    VARCHAR (1)         NOT NULL,
 stato                           VARCHAR (1)         NOT NULL,
 vita_stampe                     NUMBER (3,0)     NOT NULL,
 vita_prenotazioni               NUMBER (3,0)     NOT NULL,
 tipo_schedulazione              VARCHAR (1)         NOT NULL,
 vita_accessi                    NUMBER (3,0)     NOT NULL
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
COMMENT ON TABLE a_parametri_sched
    IS 'Created from Entity PARAMETRI SCHEDULATORE by ASCOT on 19-DEC-91'
/
COMMENT ON COLUMN a_parametri_sched.intervallo_lavoro
    IS 'Tempo tra due attivazioni successive dello schedulatore'
/
COMMENT ON COLUMN a_parametri_sched.parallelismo
    IS 'Numero massimo di processi contemporaneamente attivi'
/
COMMENT ON COLUMN a_parametri_sched.processi
    IS 'Numero di processi attivi'
/
COMMENT ON COLUMN a_parametri_sched.prenotazione
    IS 'Indicatore di accettazione di prenotazioni'
/
COMMENT ON COLUMN a_parametri_sched.stato
    IS 'Stato di attivita''dello schedulatore'
/
