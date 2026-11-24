--liquibase formatted sql
--changeset amonopoli:201801251021 runOnChange:true stripComments:false
create or replace function f_ANPR_flag_annullamento
(a_id_operazione	IN	number)

return varchar2

is

w_flag_ann	varchar2(255);

begin
  begin
    select distinct rif.flag_annullamento
      into w_flag_ann
      from anpciu_rif rif
     where rif.id_operazione_rif = a_id_operazione
       and rif.flag_annullamento = 'S'
    ;
  exception
    when others then
         w_flag_ann := '';
  end;

<< fine >>
null;

  return w_flag_ann;

end;
/
