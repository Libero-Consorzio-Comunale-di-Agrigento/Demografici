--liquibase formatted sql
--changeset amonopoli:202309041015 runAlways:true runOnChange:true stripComments:false
create or replace view ansciu_v_ATT 
AS
select ciu.id_operazione id,
       ciu.*, 
       f_ANSC_descrizione_esito_CIU(ciu.esito_ansc) des_esito_ansc,
       f_ANSC_flag_ultima_CIU(ciu.id_operazione, ciu.servizio, ciu.archivio_rif, ciu.id_rif) flag_ultima
  from ansciu ciu
 where ciu.ARCHIVIO_RIF in ('NAS','MAT','UCI','MOR','CIT')
   and ciu.flag_annullato is null
/
comment on table ansciu_v_ATT is 'ANSC - Comunicazioni in Uscita - Atti (view)'
/
