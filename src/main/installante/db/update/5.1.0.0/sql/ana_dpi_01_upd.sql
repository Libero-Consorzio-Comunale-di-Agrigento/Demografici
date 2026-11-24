--liquibase formatted sql
--changeset amonopoli:202508051120_2 runOnChange:true stripComments:false
update anadpi
   set famiglia_convivenza = 'C'
 where ist_rp in ('24','25')
/
update anadpi
   set famiglia_convivenza = 'F'
 where ist_rp not in ('24','25')
/
