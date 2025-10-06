--liquibase formatted sql
--changeset amonopoli:202504021130 runOnChange:true stripComments:false
create or replace function f_get_campo_VIE
(a_cod_via	IN 	varchar2
,a_campo	IN 	varchar2
)

return varchar2

IS

w_campo  varchar2(255) := upper(a_campo);
w_valore varchar2(255);

begin
  begin
    select decode(w_campo,
             'DENOM_UFF', vie.denom_uff
           )
      into w_valore
      from arcvie vie
     where vie.cod_via = a_cod_via
    ;
  exception
    when others then
         w_valore := '';
  end;

  return w_valore;

end;
/