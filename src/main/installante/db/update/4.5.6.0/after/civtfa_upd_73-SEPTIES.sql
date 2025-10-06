--liquibase formatted sql
--changeset amonopoli:202304271525 runOnChange:true
update civtfa
   set testo_4000 = replace(testo_4000,'la legge ... da applicare','la legge <LEGGE_CONVENZIONI> da applicare')
 where formula = '73-SEPTIES'
/
