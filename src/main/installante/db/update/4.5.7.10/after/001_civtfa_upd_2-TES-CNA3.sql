--liquibase formatted sql
--changeset amonopoli:202410311000 runOnChange:true stripComments:false
update civtfa
   set testo_4000 = replace(testo_4000,'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF>','Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF>'),
       testo_a3   = replace(testo_4000,'Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF>','Atto Numero <NOTA_RIF>/<ANNO_NOTA_RIF>')
 where formula like '2-TES-CNA%'
   and testo_4000 like '%Atto Numero <NOTA_RIF>;<ANNO_NOTA_RIF>%'

/
