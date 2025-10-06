--liquibase formatted sql
--changeset amonopoli:202503191545 runOnChange:true stripComments:false
create or replace function f_AOFE_flag_archiviato
(a_tipo_documento		IN	varchar2
,a_matricola			IN	number
,a_fascicolo			IN	number
)

return varchar2

IS

w_flag		varchar2(255);

begin
  begin
    select 'S'
      into w_flag
      from ELEDOC
     where matricola        = a_matricola
       and numero           = a_fascicolo
       and tipo_documento   = a_tipo_documento
       and id_documento_gdm is not null
       and rownum = 1
    ;
  exception
    when others then
         w_flag := '';
  end;

  return w_flag;
end;
/
