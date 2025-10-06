--liquibase formatted sql
--changeset snocca:202305091430 runAlways:true runOnChange:true stripComments:false
create or replace view ansciu_v_ALL 
AS
select ciu.id_operazione id,
       ciu.*, 
       f_ANSC_descrizione_esito_CIU(ciu.esito_ansc) des_esito_ansc,
       f_ANSC_flag_ultima_CIU(ciu.id_operazione, ciu.servizio, ciu.archivio_rif, ciu.id_rif) flag_ultima,
       faa.id id_civfas_alle,
       fas.id id_civfas,
       ddo.descrizione des_tipo_documento
  from civddo ddo,
       civfas fas,
       civfas_alle faa,
       ansciu ciu
 where ddo.id           = fas.id_civddo
   and fas.id           = faa.id_civfas
   and faa.id           = ciu.ID_RIF
   and ciu.ARCHIVIO_RIF = 'ALL'
   and ciu.flag_annullato is null
/
comment on table ansciu_v_ALL is 'ANSC - Comunicazioni in Uscita - Allegati (view)'
/
