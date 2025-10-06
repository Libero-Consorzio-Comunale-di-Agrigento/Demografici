--liquibase formatted sql
--changeset amonopoli:202503241000_46 runOnChange:false stripComments:false
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
  w_nome_ogg := 'a_segnalazioni_errore';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE TABLE a_segnalazioni_errore(
 no_prenotazione                 NUMBER (6,0)     NOT NULL,
 passo                           NUMBER (2,0)     NOT NULL,
 progressivo                     NUMBER (10,0)    NOT NULL,
 errore                          VARCHAR (6)         NOT NULL,
 precisazione                    VARCHAR (50)        NULL
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
     w_nome_ogg := 'SEER_PK';
     w_nome_col := '';

     w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
     w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

     if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

        w_sql := 'CREATE UNIQUE INDEX SEER_PK ON A_SEGNALAZIONI_ERRORE
(
      no_prenotazione ,
      passo ,
      progressivo )';

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
COMMENT ON TABLE a_segnalazioni_errore
    IS 'Created from Entity SEGNALAZIONE ERRORE by A00 on 24-MAR-92'
/
COMMENT ON COLUMN a_segnalazioni_errore.no_prenotazione
    IS 'Numero assegnato alla prenotazione'
/
COMMENT ON COLUMN a_segnalazioni_errore.passo
    IS 'Numero del passo procedurale che ha generato la segnalazione'
/
COMMENT ON COLUMN a_segnalazioni_errore.progressivo
    IS 'Progressivo dell''evento verificatosi (rownumber)'
/
COMMENT ON COLUMN a_segnalazioni_errore.errore
    IS 'Codice dell''errore'
/
COMMENT ON COLUMN a_segnalazioni_errore.precisazione
    IS 'Testo o codice di precisazione'
/
