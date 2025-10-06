--liquibase formatted sql
--changeset amonopoli:202412051420 runOnChange:true stripComments:false
update cerdce
   set FLAG_ANNOTAZIONI_CIV = 'S'
 where ((tipo_archivio = 4 and cod_certificato in ('EMA'   -- ESTRATTO DI MATRIMONIO
                                                  ,'EMR'   -- ESTRATTO DI MATRIMONIO CON INDICAZIONE DEL RITO
                                                  ,'IMA')) -- ESTRATTO DI MATRIMONIO INTERNAZIONE (PLURILINGUE)
     or (tipo_archivio = 5 and cod_certificato in ('EMO'   -- ESTRATTO DI MORTE
                                                  ,'EMP'   -- ESTRATTO DI MORTE CON PAT/MAT
                                                  ,'IMO')) -- ESTRATTO DI MORTE INTERNAZIONE (PLURILINGUE)
     or (tipo_archivio = 2 and cod_certificato in ('ENA'   -- ESTRATTO DI NASCITA
                                                  ,'ENP'   -- ESTRATTO DI NASCITA CON PATERNITA'
                                                  ,'INA')) -- ESTRATTO DI NASCITA INTERNAZIONE (PLURILINGUE)
     or (tipo_archivio = -4 and cod_certificato in ('EUC')) -- ESTRATTO DI UNIONE CIVILE
       )
   and flag_annotazioni_civ is null
/
