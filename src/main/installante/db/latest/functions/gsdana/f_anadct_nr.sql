--liquibase formatted sql
--changeset amonopoli:202606111545_1 runOnChange:true stripComments:false
create or replace function F_ANADCT_NR
(a_anagrafe		IN	varchar2
,a_tipo_evento		IN	varchar2
,a_codice_co		IN	number
)

return varchar2

IS

w_anagrafe	varchar2(255) := upper(a_anagrafe);
w_tipo_evento	varchar2(255) := upper(a_tipo_evento);
w_codice_co	number := a_codice_co;

w_id		varchar2(255);

begin
   if w_anagrafe is not null and w_tipo_evento is not null and w_codice_co is not null then
      w_id := w_anagrafe||w_tipo_evento||lpad(w_codice_co,3,'0');
   end if;

   return w_id;

end;
/
