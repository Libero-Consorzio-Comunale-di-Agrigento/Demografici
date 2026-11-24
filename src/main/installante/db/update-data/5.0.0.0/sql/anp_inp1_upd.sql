--liquibase formatted sql
--changeset amonopoli:202511030855_2 runOnChange:true stripComments:false
update anpinp
   set flag_visibile = 'S'
 where flag_visibile is null
   and parametro not like f_get_comune_cliente('COD_COMUNE')||'%'
/

