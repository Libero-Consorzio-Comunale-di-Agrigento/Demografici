--liquibase formatted sql
--changeset amonopoli:202509301245_2 runOnChange:true stripComments:false
update anadrp
   set famiglia_convivenza = 'C'
 where cod_rp in ('IC','CC')
/
update anadrp
   set famiglia_convivenza = 'F'
 where cod_rp not in ('IC','CC')
/
