--liquibase formatted sql
--changeset amonopoli:202309071515 runOnChange:true stripComments:false
insert into ansinp (PARAMETRO, VALORE, DESCRIZIONE, VERSION, FLAG_VISIBILE)
select 'ID_VERSION', '100004', 'WS: ID VERSIONE', 0, 'S'
  from dual
 where not exists (select 1 from ansinp b
                    where b.parametro = 'ID_VERSION')
/
update ansinp
   set valore        = '100022',
       flag_visibile = 'S'
 where parametro = 'ID_VERSION'
/
