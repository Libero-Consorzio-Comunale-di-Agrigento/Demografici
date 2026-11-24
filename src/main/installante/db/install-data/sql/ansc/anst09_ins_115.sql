--liquibase formatted sql
--changeset amonopoli:202602051410_1 runOnChange:true stripComments:false
insert into anst09 (ID, DESCRIZIONE, DATAINIZIOVALIDITA, DATAFINEVALIDITA, ORDINAMENTO)
select 115, 'Atto di costituzione e traduzione', '1900-01-01 00:00:00.0', '9999-12-31 00:00:00.0', 115
  from dual
 where not exists (select 1 from anst09
                    where id = 115)
/
