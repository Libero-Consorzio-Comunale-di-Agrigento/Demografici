--liquibase formatted sql
--changeset amonopoli:202311101040 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_notifica_anpr_RTE
(a_id_atto_ansc		IN	varchar2
)

return varchar2

IS

w_flag_aggiornato	varchar2(255);
w_des_aggiornato	varchar2(255);
w_flag      		varchar2(255);

begin
  begin
    select 'SI', flag_aggiornato, decode(flag_aggiornato,'S','aggiornata','non aggiornata')
      into w_flag, w_flag_aggiornato, w_des_aggiornato
      from anpna0
     where idAnsc = a_id_atto_ansc
       and rownum =1
    ;
  exception
    when others then
         w_flag := 'NO';
  end;

  if w_flag = 'SI' then
     w_flag := w_flag||' ('||w_des_aggiornato||')';
  end if;

  return w_flag;

end;
/
