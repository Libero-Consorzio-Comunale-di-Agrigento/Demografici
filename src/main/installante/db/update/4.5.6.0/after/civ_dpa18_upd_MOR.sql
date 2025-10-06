--liquibase formatted sql
--changeset amonopoli:202305161115 runOnChange:true stripComments:false
update civdpa dpa
   set tipo_comparente = 'C1', 
       tipo_firmatario = 'C1'
 where tipo_atto = 5
   and tipo_comparente||tipo_firmatario is null
   and exists (select 1 from civmor
                where id_atto = dpa.id_atto
                  and cod_rec = 3)
/
