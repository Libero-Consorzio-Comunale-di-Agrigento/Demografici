--liquibase formatted sql
--changeset snocca:202305081430 runAlways:true runOnChange:true stripComments:false
create or replace view ansciu_v 
AS
select ciu.*
     , f_ANSC_descrizione_esito_CIU(ciu.esito_ansc) des_esito_ansc
     , f_ANSC_flag_http_error_CIU(ciu.id_operazione,ciu.flag_invio_ws) flag_http_error
--     , f_ANSC_flag_fake_response_CIU(ciu.id_operazione,ciu.flag_invio_ws) flag_fake_response
  from ansciu ciu
 where ciu.flag_annullato is null
/
comment on table ansciu_v is 'ANSC - Comunicazioni in Uscita (view)'
/
