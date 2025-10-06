--liquibase formatted sql
--changeset amonopoli:202405221015_1 runOnChange:true stripComments:false
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA SPOSO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA SPOSO)'
 where formula = 'MAT-TR1-AN'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA SPOSA)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA SPOSA)'
 where formula = 'MAT-TR2-AN'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA NATO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA NATO)'
 where formula = 'NAS-TR1-AN'
/
update CIVDFA 
   set descrizione_1 = 'MARGINE - TRASCRIZIONE ATTO',
       descrizione_2 = '(COMUNE RESIDENZA DECEDUTO)', 
       descrizione   = 'MARGINE - TRASCRIZIONE ATTO (COMUNE RESIDENZA DECEDUTO)'
 where formula = 'MOR-TR1-AN'
/
