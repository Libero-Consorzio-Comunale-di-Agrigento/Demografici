--liquibase formatted sql
--changeset amonopoli:202503101225_2 runOnChange:true stripComments:false
create or replace function f_ANA_get_cod_fam_unique
(a_fascia_cod_mov	IN	number
,a_cod_fam		IN	number
)

return varchar2

IS

w_cod_fam_unique	varchar2(255);

begin
  if a_fascia_cod_mov is not null and a_cod_fam is not null then
     begin
       select f_ANA_get_anagrafe(a_fascia_cod_mov)||lpad(a_cod_fam,7,'0') 
         into w_cod_fam_unique
         from dual
        where a_fascia_cod_mov in (1,2,3,4,6) -- fascia / cod_mov
           or a_fascia_cod_mov in (10,11,12,13,14,97,98) -- cod_mov
       ;
     exception
       when others then 
            w_cod_fam_unique := '';
     end;
  end if;

  return w_cod_fam_unique;

end;
/

