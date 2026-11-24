--liquibase formatted sql
--changeset amonopoli:202512190845 runOnChange:true stripComments:false
create or replace function f_ANA_esiste_DOC
(a_matricola		IN	number
,a_tipo_documento	IN	varchar2
)

return varchar2

IS

w_tipo_documento	varchar2(255) := upper(a_tipo_documento);

w_flag			varchar2(1);

begin
  w_flag := '';

  if a_matricola is not null and a_tipo_documento is not null then
     begin
       select 'S'
         into w_flag
         from anadoc
        where matricola        = a_matricola
          and tipo_documento   = w_tipo_documento
          and progr_documento  = 1
          and natura_documento != 'A'
          and rownum = 1
       ;
     exception
       when others then
            w_flag := '';
     end;
  end if;

  return w_flag;

end;
/
