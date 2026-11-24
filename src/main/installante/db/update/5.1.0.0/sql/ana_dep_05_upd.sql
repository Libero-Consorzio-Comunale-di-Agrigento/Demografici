--liquibase formatted sql
--changeset amonopoli:202509170920_2 runOnChange:true stripComments:false
update anadep
   set flag_on_line = 'S'
 where cod_ep = 1
   and flag_on_line is null
/
update anadep
   set flag_esito = 'S'
 where flag_esito is null
   and cod_ep not in (0,7,8)
/
update anadep
   set flag_perfezionamento = 'S'
 where cod_ep = 7
   and flag_perfezionamento is null
/
update anadep
   set flag_annullamento = 'S'
 where cod_ep = 8
   and flag_annullamento is null
/
