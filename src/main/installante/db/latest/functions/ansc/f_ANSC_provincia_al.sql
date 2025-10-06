--liquibase formatted sql
--changeset amonopoli:202305181142 runOnChange:true stripComments:false
create or replace function f_ANSC_provincia_al
(A_COD_PROVINCIA                IN	NUMBER  
,A_COD_COMUNE                   IN	NUMBER  
,A_DATA                         IN	DATE
)

return varchar2

IS

w_sigla_provincia	varchar2(3) := '';
w_flag_sigla_pro	varchar2(1) := 'S';
w_flag_parentesi	varchar2(1) := '';

w_data_j		number;
w_provincia		varchar2(255);

begin
  if a_cod_provincia||a_cod_comune is not null then
     w_data_j    := to_char(nvl(a_data,trunc(sysdate)),'j');
     w_provincia := f_ANPR_luogo(a_cod_provincia,a_cod_comune,w_data_j,2,3);
  end if;

  return w_provincia;

end;
/
