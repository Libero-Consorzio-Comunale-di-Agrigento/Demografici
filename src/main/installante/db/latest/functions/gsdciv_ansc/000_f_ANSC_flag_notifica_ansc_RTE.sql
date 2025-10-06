--liquibase formatted sql
--changeset amonopoli:202311101120 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_notifica_ansc_RTE
(a_id_atto_ansc		IN	varchar2
)

return varchar2

IS

w_stato		number;
w_des_stato	varchar2(255);

w_flag      	varchar2(255);

begin
  begin
    select 'SI', stato, decode(stato,1,'da approvare',2,'approvata')
      into w_flag, w_stato, w_des_stato
      from ansnot_rte
     where id_ansc = a_id_atto_ansc
       and rownum =1
    ;
  exception
    when others then
         w_flag := 'NO';
  end;

  if w_flag = 'SI' then
     w_flag := w_flag||' ('||w_des_stato||')';
  end if;

  return w_flag;

end;
/
