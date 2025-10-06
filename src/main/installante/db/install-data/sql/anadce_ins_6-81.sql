--liquibase formatted sql
--changeset amonopoli:202305201025_2 runOnChange:true stripComments:false
insert into anadce
       (anagrafe, codice, descrizione, cod_mov, cod_eve, sigla_vana)
select 'RES', 147, 'NON RESIDENTE (ANPR)', 6, 81, 'ANP'
  from dual
 where not exists (select 'x' 
                     from anadce
                    where cod_mov = 6
                      and cod_eve = 81)
/
