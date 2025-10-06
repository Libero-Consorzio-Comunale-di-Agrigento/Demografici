--liquibase formatted sql
--changeset snocca:202314111730 runOnChange:true stripComments:false
create or replace function f_ANSC_flag_firmato
(a_archivio_rif    IN varchar2
,a_id_rif          IN varchar2
,a_tipo_firma      IN varchar2
)

return varchar2

IS

w_flag			varchar2(255);
w_servizio_firma 	varchar2(10);
w_servizio_firma_ciu 	varchar2(10);

begin
--
-- a_tipo_firma = 'USC': firma Ufficiale di stato civile - servizio R007
-- a_tipo_firma = 'ATT': firma Attestazione di conformità - servizio R007_C
--

  if a_tipo_firma = 'ATT' then
     w_servizio_firma := 'R007_C';
  else
     w_servizio_firma := 'R007';
  end if;

  if a_tipo_firma in ('ATT','USC') then
      if a_archivio_rif in ('NAS','MAT','UCI','MOR','CIT') then
         w_servizio_firma_ciu := w_servizio_firma;
      else
         w_servizio_firma_ciu := w_servizio_firma||'%';
      end if;

      begin
        select 'S'
          into w_flag
          from ansciu ciu
         where archivio_rif   = a_archivio_rif
           and id_rif         = a_id_rif
           and servizio       like w_servizio_firma_ciu
           and flag_invio_ws  = 'S'
           and flag_annullato is null
           and rownum =1
        ;
      exception
        when others then
             w_flag := '';
      end;
  end if;

  return w_flag;

end;
/
