--liquibase formatted sql
--changeset amonopoli:202402061455 runOnChange:true stripComments:false
update anpinp
   set valore = 'ANPR05'
 where parametro = 'COD_DEST'
/
