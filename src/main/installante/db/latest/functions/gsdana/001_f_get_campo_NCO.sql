--liquibase formatted sql
--changeset amonopoli:202509251140 runOnChange:true stripComments:false
create or replace function f_get_campo_NCO
(a_fascia	IN	number
,a_cod_fam	IN	number
,a_campo	IN	varchar2
)

return varchar

IS

w_campo		varchar2(255) := upper(a_campo);

w_return	varchar2(255);

begin
  w_return := '';

  begin 
    select decode(w_campo,
             'FLAG_COABITANTE', nco.flag_coabitante,
             'COD_FAM', decode(nco.cod_fam,a_cod_fam,nco.cod_fam_rif,nco.cod_fam),
             'COD_FAM_UNIQUE', f_ANA_get_cod_fam_unique(nco.fascia,decode(nco.cod_fam,a_cod_fam,nco.cod_fam_rif,nco.cod_fam))
           )
      into w_return
      from ananco nco
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
