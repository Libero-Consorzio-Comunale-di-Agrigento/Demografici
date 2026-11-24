--liquibase formatted sql
--changeset amonopoli:2026030110905 runOnChange:true stripComments:false
update arcinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro in ('ANA_COM_PR',
                     'ANA_FIRMA')
/
update arcinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro in ('CIV_FIRMA')
/
update arcinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro in ('ELE_FIRMA',
                     'LISTE_ANN',
                     'LISTE_COM',
                     'LISTE_FIR',
                     'LISTE_FIR2',
                     'LISTE_MAT',
                     'LISTE_PSEZ',
                     'LISTE_PAG',
                     'LISTE_TIM',
                     'LISTE_TIM1')
/
update arcinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro in ('ATTI_ALERT',
                     'DOCAREA',
                     'DOCAREA_UT',
                     'DUCD_IPA',
                     'DUCD_MAIL',
                     'DUCD_MAILS',
                     'STATS_URL',
                     'UNICODE')
/
update arcinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro in ('LEV_FIRMA')
/

