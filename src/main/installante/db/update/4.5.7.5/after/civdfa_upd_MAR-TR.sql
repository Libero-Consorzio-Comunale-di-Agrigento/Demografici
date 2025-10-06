--liquibase formatted sql
--changeset amonopoli:202405221035_1 runOnChange:true stripComments:false
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA SPOSO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA SPOSO)'
 where formula = '4-MAR-TR1'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA SPOSA)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA SPOSA)'
 where formula = '4-MAR-TR2'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA NATO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA NATO)'
 where formula = '2-MAR-TR1'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA DECEDUTO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA DECEDUTO)'
 where formula = '5-MAR-TR1'
/
