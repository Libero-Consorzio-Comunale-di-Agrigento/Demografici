--liquibase formatted sql
--changeset amonopoli:202311101015 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_servizio_RTE
(a_archivio_rif         IN 	varchar2
,a_id_rif		IN	varchar2
,a_servizio		IN	varchar2
)

return varchar2

IS

w_flag      varchar2(255);

begin
  begin
    select 'SI'
      into w_flag
      from ansciu ciu
     where archivio_rif   = a_archivio_rif
       and id_rif         = a_id_rif
       and servizio       = a_servizio
       and flag_invio_ws  = 'S'
       and flag_annullato is null
       and rownum =1
    ;
  exception
    when others then
         w_flag := 'NO';
  end;

  return w_flag;

end;
/
