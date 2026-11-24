--liquibase formatted sql
--changeset amonopoli:202503171220 runOnChange:true stripComments:false
create or replace function f_get_campo_CDF_x_matricola
(a_matricola		IN	number
,a_campo		IN	varchar2
)

return varchar2

IS

w_campo		varchar2(255) := upper(a_campo);
w_valore	varchar2(255);

begin
  begin
    select decode(w_campo,
             'COD_CDF', cdf.cod_cdf,
             'ID', cdf.id)
      into w_valore
      from anacdf cdf
     where matricola = a_matricola
       and nvl(data_inizio,1111111) = (select max(nvl(b.data_inizio,1111111)) 
                                         from anacdf b
                                        where b.matricola = a_matricola)
       and rownum = 1
    ;
  exception 
    when others then
         w_valore := '';
  end;

  return w_valore;

end;
/
