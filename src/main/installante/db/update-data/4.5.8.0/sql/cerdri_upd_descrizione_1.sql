--liquibase formatted sql
--changeset amonopoli:202412091430_2 runOnChange:true stripComments:false
update cerdri
   set descrizione_1  = descrizione_1||decode(descrizione_2,'','',' '||descrizione_2),
       descrizione_2  = '',
       descr_stampa_1 = descr_stampa_1||decode(descr_stampa_2,'','', ' '||descr_stampa_2),
       descr_stampa_2 = ''
 where descrizione_2||descr_stampa_2 is not null
/
