--liquibase formatted sql
--changeset amonopoli:202305181130 runOnChange:true stripComments:false
create or replace function f_ANSC_comune_al
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
     w_data_j := to_char(a_data,'j');
     w_comune := f_comune_al(a_cod_provincia,a_cod_comune,w_data_j);
  end if;

  return f_ANSC_stringa(w_comune,'()');
end;
/
