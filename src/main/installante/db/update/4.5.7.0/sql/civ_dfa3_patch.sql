--liquibase formatted sql
--changeset amonopoli:202312120845 runOnChange:true stripComments:false
update civdfa
   set descrizione = rtrim(descrizione_1||' '||descrizione_2||' '||descrizione_3)
 where descrizione is null
   and descrizione_1||descrizione_2||descrizione_3 is not null
/
