--liquibase formatted sql
--changeset ftravaglini:202307101200 runOnChange:true stripComments:false

create or replace function f_ANSC_ruolo_operatore
(a_qualifica_utente     IN	varchar2        
)

return number

IS

w_ruolo			number;
w_return        number;

begin
-- 1 - in qualità di Sindaco
-- 2 - per delega ricevuta
-- 3 - in sostituzione del Sindaco

  begin
    if upper(a_qualifica_utente) like '%SINDACO%' then
       w_ruolo := 1;
    elsif upper(a_qualifica_utente) like '%VICESINDACO%' then
       w_ruolo := 3;
    else 
       w_ruolo := 2;
    end if;
 
  exception 
    when others then
       w_ruolo := 2
    ;
  end;

  begin
     select t67.id
       into w_return
       from anst67 t67
      where t67.ordinamento = w_ruolo
     ;
  exception
    when others then
      w_return := 2;
  end;

  return w_return;
end;
/
