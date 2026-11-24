--liquibase formatted sql
--changeset dfiloni:202607211000 runOnChange:true stripComments:false
create or replace view cercit_filtro as
select cit.*, 'ANS' filtro
  from civcit cit
 where cod_rec = 5
   and atto > 0
UNION
select cit.*, 'TUT' filtro
  from civcit cit
 where cod_rec in (0,3)
   and atto > 0
   and natura in ('P','A','D')
/
comment on table CERCIT_FILTRO is 'Certificazione - Atti di Cittadinanza con campo Filtro'
/