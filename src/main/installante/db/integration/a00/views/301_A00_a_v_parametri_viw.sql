--liquibase formatted sql
--changeset amonopoli:202503241505_1 runOnChange:true stripComments:false
declare
w_tipo_ogg	varchar2(255);
w_nome_ogg	varchar2(255);
w_nome_col      varchar2(255);

w_des_ogg       varchar2(255);
w_check_db	number;

w_sql           varchar2(32000);
w_result        varchar2(32000);

begin
  w_tipo_ogg := 'viw';
  w_nome_ogg := 'a_v_parametri';
  w_nome_col := '';

  w_des_ogg  := w_tipo_ogg||'.'||w_nome_ogg||'.'||w_nome_col;
  w_check_db := f_A00_check_db(w_tipo_ogg,w_nome_ogg,w_nome_col);

  if w_check_db = 0 then
dbms_output.put_line('oggetto '||w_des_ogg||' non esistente');

     w_sql := 'CREATE VIEW a_v_parametri
(
     parametro
    ,descrizione
    ,descrizione_al1
    ,descrizione_al2
    ,valore
    ,sequenza
    ,no_prenotazione
)
AS SELECT
     P.PARAMETRO, S.DESCRIZIONE, S.DESCRIZIONE_AL1, S.DESCRIZIONE_AL2
    ,P.VALORE, S.SEQUENZA, N.NO_PRENOTAZIONE           
FROM
    a_parametri  p,
    a_selezioni  s,
    a_prenotazioni  n
 WHERE P.PARAMETRO = S.PARAMETRO
 AND S.VOCE_MENU = N.VOCE_MENU
 AND N.NO_PRENOTAZIONE = P.NO_PRENOTAZIONE';

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
