--liquibase formatted sql
--changeset amonopoli:202407301240_2 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_fake_response_CIU
(a_id_operazione	IN	number
,a_flag_invio_ws	IN 	varchar2
) 

return varchar2

IS

w_flag_invio_ws	varchar2(255) := upper(nvl(a_flag_invio_ws,'N'));

w_flag		varchar2(255);

begin
  w_flag := '';

  if w_flag_invio_ws = 'N' then
     begin
       select 'S' into w_flag
         from anserr
        where id_operazione = a_id_operazione
          and tipo_errore   = 'F'
          and rownum = 1
       ;  
    exception
      when others then
           w_flag := '';
    end;
  end if;

  return w_flag;
end;
/
