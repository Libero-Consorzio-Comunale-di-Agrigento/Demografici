--liquibase formatted sql
--changeset amonopoli:202301201135_1 runOnChange:true
update civdrf
   set flag_default = 'S'
 where tipo_atto       = 2
   and richiamo        = 1
   and progr_dettaglio = 0
   and formula         in ('2-TES-CNA1','2-TES-CNA2')
   and flag_default    is null
/
