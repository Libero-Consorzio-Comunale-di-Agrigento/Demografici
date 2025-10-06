--liquibase formatted sql
--changeset amonopoli:202405221035_2 runOnChange:true stripComments:false
update CIVTFA 
   set testo_4000 = replace(testo_4000, 'e'' stato altresi'' trascritto', 'e'' stato trascritto')
 where formula = '4-MAR-TR1'
/
