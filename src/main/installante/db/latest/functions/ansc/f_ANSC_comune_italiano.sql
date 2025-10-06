--liquibase formatted sql
--changeset amonopoli:202407100950 runOnChange:true stripComments:false
create or replace function f_ANSC_comune_italiano
(A_COD_PROVINCIA                IN	NUMBER
,A_COD_COMUNE                   IN	NUMBER
,A_DATA                         IN	DATE
)

return varchar2

IS

w_data_j		number;
w_comune		varchar2(255);

begin
  if a_cod_provincia||a_cod_comune is not null then
     if a_cod_provincia < 201 or (a_cod_provincia in (701,702,703) and a_cod_comune > 500) then
        w_data_j := to_char(a_data,'j');
        w_comune := f_comune_al(a_cod_provincia,a_cod_comune,w_data_j);
     end if;
  end if;

  return f_ANSC_stringa(w_comune,'()');
end;
/
