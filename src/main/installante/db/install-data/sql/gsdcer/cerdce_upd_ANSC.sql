--liquibase formatted sql
--changeset amonopoli:202310261355 runOnChange:true stripComments:false
update cerdce
   set codice_anpr = 'S1'
 where cod_certificato in ('CNA','CMA','CMO','CUC')
   and codice_anpr is null
   and competenza  = 'SC'
/
update cerdce
   set codice_anpr = 'S2'
 where cod_certificato in ('ENA','EMA','EMO','EUC')
   and codice_anpr is null
   and competenza  = 'SC'
/
update cerdce
   set codice_anpr = 'S6'
 where cod_certificato in ('CNP','CMP')
   and codice_anpr is null
   and competenza  = 'SC'
/
update cerdce
   set codice_anpr = 'S7'
 where cod_certificato in ('ENP','EMP')
   and codice_anpr is null
   and competenza  = 'SC'
/
