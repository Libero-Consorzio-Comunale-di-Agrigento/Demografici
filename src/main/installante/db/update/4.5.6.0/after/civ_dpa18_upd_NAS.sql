--liquibase formatted sql
--changeset amonopoli:202303310935 runOnChange:true stripComments:false
update civdpa dpa
   set tipo_comparente = tipo_dichiarante, 
       tipo_firmatario = tipo_dichiarante
 where tipo_atto                        = 2
   and tipo_dichiarante                 is not null
   and tipo_comparente||tipo_firmatario is null
   and exists (select 1 from civnas
                where id_atto = dpa.id_atto
                  and cod_rec = 3)
/
