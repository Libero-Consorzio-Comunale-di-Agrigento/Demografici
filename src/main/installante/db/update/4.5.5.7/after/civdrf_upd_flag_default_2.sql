--liquibase formatted sql
--changeset amonopoli:202302161622 runOnChange:true
update civdrf a
   set flag_default = 'S'
 where tipo_atto       = 2
   and richiamo        = 5
   and progr_dettaglio = 0
   and formula         in ('2-DNA-CNA')
   and flag_default    is null
   and not exists (select 1 from civdrf b
                    where b.tipo_atto       = a.tipo_atto
                      and b.richiamo        = a.richiamo
                      and b.progr_dettaglio = a.progr_dettaglio
                      and b.flag_default    is not null)
/