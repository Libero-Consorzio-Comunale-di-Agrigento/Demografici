--liquibase formatted sql
--changeset amonopoli:202602121030_3 runOnChange:true stripComments:false
update eledtl dtl
   set descrizione_breve = decode(dtl.cod_tl,
                             'C', 'Agg. UE Comunali',
                             'E', 'Agg. UE Europee', 
                             'B', 'Agg. Bolzano',
                             'T', 'Agg. Trento', 
                             'V', 'Agg. Valle d''Aosta',
                             'F', 'Agg. Fuori Sede',
                                  'Agg. '||dtl.cod_tl)
 where descrizione_breve is null
/
