--liquibase formatted sql
--changeset snocca:202404031040 runOnChange:true
update civdrc
   set num_righe = 8
 where tipo_Atto = 2
   and richiamo = 5
   and progr_dettaglio = 0
   and num_righe = 6
/
