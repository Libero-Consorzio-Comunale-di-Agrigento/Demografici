--liquibase formatted sql
--changeset amonopoli:202304261600 runOnChange:true
update civdta dta
   set flag_divorzio = 'S'
 where flag_divorzio is null
   and parte         = 2
   and tipo_atto     = -4
   and exists (select 'x' from civcta cta
                where cta.id = dta.id_civcta
                  and flag_divorzio is not null)
/
