--liquibase formatted sql
--changeset amonopoli:202505271055 runOnChange:true stripComments:false
create or replace function F_NUCLEO_COABITANTE_NCO
(a_fascia	IN	number
,a_cod_fam	IN	number
)

return varchar

IS

w_return		varchar2(255);

begin
  w_return := '';

  begin 
    select 'S'
      into w_return
      from ananco
     where fascia = a_fascia
       and ((cod_fam = a_cod_fam and cod_fam_rif is not null)
            or cod_fam_rif = a_cod_fam)
       and rownum 	= 1
    ;
  exception
    when others then
         w_return := '';
  end;

  return w_return;

end;
/
