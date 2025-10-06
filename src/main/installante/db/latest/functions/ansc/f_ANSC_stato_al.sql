--liquibase formatted sql
--changeset amonopoli:202305181143 runOnChange:true stripComments:false
create or replace function f_ANSC_stato_al
(A_COD_PROVINCIA	IN	NUMBER  
,A_COD_COMUNE           IN	NUMBER  
,A_DATA                 IN	DATE
)

return varchar2

IS

w_sigla_provincia	varchar2(3) := '';
w_flag_sigla_pro	varchar2(1) := '';
w_flag_parentesi	varchar2(1) := '';

w_data_j		number;
w_des_stato_anpr	varchar2(255);
w_des_stato_ads  	varchar2(255);
w_des_stato         	varchar2(255);

begin
  if a_cod_provincia||a_cod_comune is not null then
     if (a_cod_provincia >= 201 and a_cod_provincia not in (701,702,703)) 
        or (a_cod_provincia in (701,702,703) and a_cod_comune < 500) 
     then
        w_data_j := to_char(nvl(a_data,trunc(sysdate)),'j');
        w_des_stato_anpr := f_ANPR_luogo(a_cod_provincia,a_cod_comune,w_data_j,3,2);
        w_des_stato_ads  := f_stato_estero_al(a_cod_provincia,a_cod_comune,w_data_j);
        w_des_stato      := nvl(w_des_stato_ads,w_des_stato_anpr);
     else
        w_des_stato  := 'ITALIA';
     end if;
  end if;

  return f_ANSC_stringa(w_des_stato,'()');

end;
/
