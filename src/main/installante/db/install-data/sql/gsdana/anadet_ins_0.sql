--liquibase formatted sql
--changeset amonopoli:202606081445_91 runOnChange:true stripComments:false
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 1, 0
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'RES'
                      and b.tipo_evento    = 'I'
                      and b.evento_pratica = 0)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'E', 1, 0
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'RES'
                      and b.tipo_evento    = 'E'
                      and b.evento_pratica = 0)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 1, 0
  from dual
 where not exists (select 'x' from anadet b
                    where b.anagrafe       = 'RES'
                      and b.tipo_evento    = 'C'
                      and b.evento_pratica = 0)
/
