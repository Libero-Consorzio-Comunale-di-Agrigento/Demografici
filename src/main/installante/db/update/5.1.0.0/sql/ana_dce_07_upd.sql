--liquibase formatted sql
--changeset amonopoli:202606081545_2 runOnChange:true stripComments:false
update anadce
   set flag_preliminare = 'S'
 where anagrafe         = 'RES'
   and tipo_evento      = 'I'
   and flag_tpr         = 'S'
   and tipo_evento_tpr  in ('P','W','Y')
   and flag_preliminare is null
/
update anadce
   set tipo_richiesta_apr4 = decode(tipo_evento_tpr,'',1,'W',1,'Y',1,2)
 where anagrafe         = 'RES'
   and tipo_evento      = 'E'
   and flag_tpr         = 'S'
   and tipo_richiesta_apr4 is null
/
update anadce
   set tipo_richiesta_apr4 = decode(cod_variazione,'I',1,2)
 where anagrafe         = 'RES'
   and tipo_evento      = 'R'
   and flag_tpr         = 'S'
   and tipo_richiesta_apr4 is null
/
update anadce
   set tipo_evento_tpr = 'P'
 where tipo_evento_tpr = 'R'
   and cod_mov = 10
   and cod_eve = 90
   and anagrafe = 'RES'
   and tipo_evento = 'R'
/
