--liquibase formatted sql
--changeset snocca:202311081440 runAlways:true runOnChange:true stripComments:false
create or replace view ansciu_v_ANN
AS
select ciu.id_operazione id,
       ciu.*, 
       f_ANSC_descrizione_esito_CIU(ciu.esito_ansc) des_esito_ansc,
       f_ANSC_flag_ultima_CIU(ciu.id_operazione, ciu.servizio, ciu.archivio_rif, ciu.id_rif) flag_ultima,
       ann.id id_civann
  from civann ann,
       ansciu ciu
 where ann.id           = ciu.ID_RIF
   and ciu.ARCHIVIO_RIF = 'ANN'
   and ciu.flag_annullato is null
/
comment on table ansciu_v_ANN is 'ANSC - Comunicazioni in Uscita - Annotazioni (view)'
/
