--liquibase formatted sql
--changeset amonopoli:202303291610 runOnChange:true stripComments:false
create or replace function f_ANSC_comprensione
(a_cod_comprensione	IN	varchar2
)

return varchar2

IS

w_cod_comprensione	varchar2(255) := upper(a_cod_comprensione);

w_return		varchar2(255);

begin
  if a_cod_comprensione is not null then
     begin
       select codice_ansc
         into w_return
         from civdcd
        where cod_cd = w_cod_comprensione
       ;
     exception
       when others then
            w_return := '0';
     end;
  end if;

  return w_return;
end;
/
