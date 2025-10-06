--liquibase formatted sql
--changeset amonopoli:202306121110_2 runOnChange:true stripComments:false
update civnas nas
   set tipo_riconoscimento = 'PD'
 where tipo_riconoscimento = 'EN'
/
update civnas nas
   set tipo_riconoscimento = 'PDMD'
 where tipo_riconoscimento = 'MDPD'
/