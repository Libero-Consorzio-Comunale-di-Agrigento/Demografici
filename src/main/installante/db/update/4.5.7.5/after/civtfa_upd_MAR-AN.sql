--liquibase formatted sql
--changeset amonopoli:202405221015_2 runOnChange:true stripComments:false
update CIVTFA 
   set testo_4000 = replace(testo_4000, 'e'' stato altresi'' trascritto', 'e'' stato trascritto')
 where formula in ('MAT-TR1-AN','MAT-TR2-AN')
/
