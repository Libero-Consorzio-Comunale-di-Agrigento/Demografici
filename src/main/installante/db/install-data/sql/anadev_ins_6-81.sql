--liquibase formatted sql
--changeset amonopoli:202305201025_1 runOnChange:true stripComments:false
insert into anadev
       (cod_ev, descrizione, segnalazione)
select 81, 'NON RESIDENTE (ANPR)', 0
  from dual
 where not exists (select 'x' 
                     from anadev
                    where cod_ev = 81)
/
