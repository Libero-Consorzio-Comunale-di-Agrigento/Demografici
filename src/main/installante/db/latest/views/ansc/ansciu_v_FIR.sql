--liquibase formatted sql
--changeset snocca:202422021430 runAlways:true runOnChange:true stripComments:false
create or replace view ansciu_v_FIR
AS
select ciu.id_operazione id,
       ciu.*,
       f_ANSC_descrizione_esito_CIU(ciu.esito_ansc) des_esito_ansc,
       f_ANSC_flag_ultima_CIU(ciu.id_operazione, ciu.servizio, ciu.archivio_rif, ciu.id_rif) flag_ultima,
       fir.id id_civfir
  from civfir fir,
       ansciu ciu
 where fir.id           = ciu.ID_RIF
   and ciu.ARCHIVIO_RIF = 'FIR'
   and ciu.flag_annullato is null
/
comment on table ansciu_v_FIR is 'ANSC - Comunicazioni in Uscita - Firmatari (view)'
/
