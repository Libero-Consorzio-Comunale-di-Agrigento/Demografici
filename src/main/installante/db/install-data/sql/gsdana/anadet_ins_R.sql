--liquibase formatted sql
--changeset amonopoli:202606081445_92 runOnChange:true stripComments:false
delete anadet
 where tipo_evento = 'R'
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'R', 0, 99
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'RES'
                      and b.tipo_evento    = 'R'
                      and b.evento_pratica = 99)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'R', 90, 7
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'RES'
                      and b.tipo_evento    = 'R'
                      and b.evento_pratica = 7)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'R', 0, 99
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'AIR'
                      and b.tipo_evento    = 'R'
                      and b.evento_pratica = 99)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'R', 90, 7
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'AIR'
                      and b.tipo_evento    = 'R'
                      and b.evento_pratica = 7)
/
