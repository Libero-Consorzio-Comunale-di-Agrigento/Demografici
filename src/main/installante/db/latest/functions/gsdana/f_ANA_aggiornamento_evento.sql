--liquibase formatted sql
--changeset amonopoli:202605221210_2 runOnChange:true stripComments:false
create or replace function f_ANA_aggiornamento_evento
(a_terminale			IN	varchar2	-- return della f_tabrep_terminale
)

return varchar2
 
IS

w_messaggio_1		varchar2(32000);
w_messaggio_2 		varchar2(32000);
w_messaggio_3		varchar2(32000);

w_chiave		varchar2(255) := 'AGEV';
w_terminale		varchar2(255) := a_terminale;

w_messaggio		varchar2(32000);

begin
  ANAAGEV.main(a_terminale,w_messaggio_1,w_messaggio_2,w_messaggio_3);

--  w_messaggio := 'messaggio (1): '||w_messaggio_1||chr(10)||
--                 'messaggio (2): '||w_messaggio_2||chr(10)||
--                 'messaggio (3): '||w_messaggio_3;

--  w_messaggio := coalesce(w_messaggio_3,w_messaggio_2,w_messaggio_1);

  if w_messaggio_3 is not null then
     w_messaggio := w_messaggio_3;
  end if;

  if w_messaggio is not null and w_messaggio_2 is not null then
     w_messaggio := w_messaggio||chr(10)||chr(10)||w_messaggio_2;
  elsif w_messaggio is null and w_messaggio_2 is not null then
     w_messaggio := w_messaggio_2;
  end if;

  if w_messaggio is not null and w_messaggio_1 is not null then
     w_messaggio := w_messaggio||chr(10)||chr(10)||w_messaggio_1;
  elsif w_messaggio is null and w_messaggio_1 is not null then
     w_messaggio := w_messaggio_1;
  end if;

  return w_messaggio;

end;
/
