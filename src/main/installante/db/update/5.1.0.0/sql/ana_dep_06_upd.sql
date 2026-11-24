--liquibase formatted sql
--changeset amonopoli:202606091555_2 runOnChange:true stripComments:false
update anadep
   set flag_monitoraggio = 'S'
 where flag_monitoraggio is null
   and cod_ep in (1	-- ACCERTAMENTO VIGILI
                 ,2	-- APR/4 A COMUNE DI PROVENIENZA
                 ,3	-- APR/4 DA COMUNE DI EMIGRAZIONE
                 ,4	-- CONFERMA DATI A COMUNE DI EMIGRAZIONE
                 ,5	-- MOD. CONS/01 DA CONSOLATO
                 ,6	-- COMUNICAZIONE A CONSOLATO
                 ,7	-- PERFEZIONAMENTO
                 ,8	-- ANNULLAMENTO
                 ,11	-- NOTIFICA AVVIO PROCEDIMENTO
                 ,12	-- PROVVEDIMENTO DI CANCELLAZIONE
                 ,13	-- NOTIFICA ARCHIVIAZIONE PRATICA
                 ,14	-- SOSPENSIONE DEI TERMINI (10BIS L.241/90)
                 )
/
