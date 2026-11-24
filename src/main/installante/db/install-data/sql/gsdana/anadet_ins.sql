--liquibase formatted sql
--changeset amonopoli:202606081445_90 runOnChange:true stripComments:false
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'C', 10, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'C', 20, 8
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'C', 30, 13
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'E', 10, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'E', 20, 8
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'I', 10, 5
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'I', 20, 6
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'I', 30, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'I', 40, 8
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'AIR', 'I', 50, 13
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 5, 1
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 10, 3
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 15, 4
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 20, 5
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 30, 6
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 40, 11
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 50, 12
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 60, 13
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 90, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'C', 95, 8
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'E', 10, 1
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'E', 20, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'E', 25, 14
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'E', 30, 8
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 10, 2
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 15, 7
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 20, 1
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 25, 9
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 27, 10
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 35, 14
  from dual
 where not exists (select 1 from anadet)
/
insert into anadet (ANAGRAFE, TIPO_EVENTO, SEQUENZA, EVENTO_PRATICA)
select 'RES', 'I', 40, 8
  from dual
 where not exists (select 1 from anadet)
/
