--liquibase formatted sql
--changeset amonopoli:202412171210_2 runOnChange:true stripComments:false
update anaddo
   set flag_riconoscimento = flag_identita
 where flag_identita is not null
   and not exists (select 1 from anaddo b
                    where b.flag_riconoscimento is not null)
/
update anaddo
   set flag_riconoscimento = 'S'
 where flag_riconoscimento is null
   and cod_do in ('PP','PT')
/

