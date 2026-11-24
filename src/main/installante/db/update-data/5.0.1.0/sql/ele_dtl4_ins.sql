--liquibase formatted sql
--changeset amonopoli:202602121030_2 runOnChange:true stripComments:false
insert into eledtl (cod_tl, descrizione, descrizione_breve)
select 'O', 'LISTE ORDINARIE', 'Ordinarie'
  from dual
 where not exists (select 1 from eledtl b
                    where b.cod_tl = 'O')
/

